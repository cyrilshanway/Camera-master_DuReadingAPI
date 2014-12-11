//
//  LoginViewController.m
//  Camera
//
//  Created by Cyrilshanway on 2014/11/28.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "LoginViewController.h"
#import "Book.h"
#import "MainViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *fbBtn;
@property (weak, nonatomic) IBOutlet UILabel *orLabel;
@property (weak, nonatomic) IBOutlet UIButton *goBtn;
@property (weak, nonatomic) IBOutlet UIButton *fb2Btn;
@property (nonatomic,strong)UIImage *profileImage;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property Book *myBook;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [FBAppEvents activateApp];
//    
//    FBLoginView *loginView = [[FBLoginView alloc] init];
//    loginView.center = self.view.center;
//    
//    
//    [self.view addSubview:loginView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.userNameTextField.hidden  = NO;
    self.userEmailTextField.hidden = YES;
    self.pwdTextField.hidden = NO;
    self.fbBtn.hidden = YES;
    self.goBtn.hidden = NO;
    self.orLabel.hidden = NO;
    self.nextBtn.hidden = YES;
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    
//    //設定fb access_token
//    NSString *access_token = [FBSession activeSession].accessTokenData.accessToken;
//    NSLog(@"access_token: %@", access_token);
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    [defaults setObject:access_token forKey:@"access_token"];
//    
//    [defaults synchronize];
//
//
//
//[self performSegueWithIdentifier:@"segueMainView" sender:self];
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    MainViewController* vc = segue.destinationViewController;
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dismissKeyboard {
    [_userNameTextField resignFirstResponder];
    [_pwdTextField resignFirstResponder];
}
- (IBAction)loginBtnPressed:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.userNameTextField.text
                                 password:self.pwdTextField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            NSLog(@"successful");
                                            
                                            //會員存到Book
                                            NSString *bookOwner = self.userNameTextField.text;
                                            NSString *bookOwnerEmail = self.userEmailTextField.text;
                                            Book *book = [[Book alloc] init];
                                            book.owner = bookOwner;
                                            book.email = bookOwnerEmail;
                                            self.myBook = book;
                                            
    //---------------------NSUserDefault test
                                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                            [defaults setObject:self.userNameTextField.text forKey:@"user"];
                                            //[defaults setObject:self.userEmailTextField.text forKey:@"email"];
                                            [defaults synchronize];
    //---------------------NSUserDefault test                                        
                                            
                                            // 直接跳到下一頁
                                            [self performSegueWithIdentifier:@"MainViewController" sender:nil];
                                        } else {
                                            // The login failed. Check error to see why.
                                            NSLog(@"failed");
                                            
                                            UIAlertController *alert = [UIAlertController
                                                                        alertControllerWithTitle:@"OOPs"
                                                                        message:@"查無此人"
                                                                        preferredStyle:(UIAlertControllerStyleAlert)];
                                            
                                            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK"
                                                                                         style:UIAlertActionStyleDefault
                                                                                       handler:^(UIAlertAction *action){
                                                                                           [alert dismissViewControllerAnimated:YES
                                                                                                                     completion:nil];
                                                                                       }];
                                            
                                            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"cancel"
                                                                                             style:UIAlertActionStyleDefault
                                                                                           handler:^(UIAlertAction *action){
                                                                                               [alert dismissViewControllerAnimated:YES
                                                                                                                         completion:nil];
                                                                                           }];
                                            
                                            [alert addAction:ok];
                                            [alert addAction:cancel];
                                            
                                            
                                            [self presentViewController:alert animated:YES completion:nil];
                                            
                                            
                                        }
                                    }];

}
- (IBAction)btnPressed2FbLogin:(id)sender {
    if
        (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
    }
    else
    
    {
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"publish_actions", @"read_stream"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *FBuser, NSError *error) {
                 if (error) {
                     // Handle error
                     NSLog(@"[fb login] an error occurs");
                 }
                 else {
                     NSMutableDictionary *userData = [[NSMutableDictionary alloc] init];
                     
                     [userData setObject:[FBuser objectForKey:@"id"] forKey:@"id"];
                     
                     if ([[FBuser allKeys] containsObject:@"email"])
                         [userData setObject:[FBuser objectForKey:@"email"]  forKey:@"UserName"];
                     else
                         [userData setObject:@""  forKey:@"UserName"];
                     
                     if ([[FBuser allKeys] containsObject:@"name"])
                         [userData setObject:[FBuser objectForKey:@"name"]   forKey:@"NickName"];
                     else
                         [userData setObject:@""  forKey:@"NickName"];
                     
                     NSString *access_token = [[[FBSession activeSession] accessTokenData] accessToken];
                     NSDate *expireationdate = [[[FBSession activeSession] accessTokenData] expirationDate];
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     
                     [defaults setObject:access_token forKey:@"access_tokenKey"];
                     [defaults setObject:expireationdate forKey:@"FBExpirationDateKey"];
                     
                     //設定fb access_token
                     //NSString *access_token = [FBSession activeSession].accessTokenData.accessToken;
                     NSLog(@"access_token: %@", access_token);
                     
                     //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     //[defaults setObject:access_token forKey:@"access_token"];

                     
                     
                     
                     [defaults synchronize];
                     
                     NSString *profileImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?width=33&height=33", [FBuser objectForKey:@"id"]];
                     
                     [defaults setObject:profileImageURL forKey:@"Photo"];
                     
                     NSURL *imageURL = [NSURL URLWithString:profileImageURL];
                     AFImageRequestOperation* imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL] success:^(UIImage *image) {
                         NSLog(@"Get Image from facebook");
                         self.profileImage = image;
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:nil];
                     }];
                     
                     NSOperationQueue* queue = [[NSOperationQueue alloc] init];
                     [queue addOperation:imageOperation];
                     
                     
                     
                     //[self.delegate loginReturn:YES userInfo:userData FailWithError:nil];
                 }
             }];
         }];
    }

}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:YES];
//    
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *access_token = [defaults objectForKey:@"access_token"];
//    
//    if (access_token != nil) {
//        [self performSegueWithIdentifier:@"segueLoginFB" sender:self];
//    }
//}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    MainViewController* vc = segue.destinationViewController;
//    vc.myBook = self.myBook;
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
