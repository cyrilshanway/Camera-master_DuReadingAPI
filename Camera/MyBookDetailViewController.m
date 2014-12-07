//
//  MyBookDetailViewController.m
//  Camera
//
//  Created by Cyrilshanway on 2014/12/7.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "MyBookDetailViewController.h"
#import "MainViewController.h"
#import "Book.h"
#import "SWRevealViewController.h"

@interface MyBookDetailViewController ()<UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bookImg;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel  *authorLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnPressed;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;




@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIView *showView;
@property (weak, nonatomic) IBOutlet UIView *commentShowView;
@property (weak, nonatomic) IBOutlet UIView *photoShowView;

@end

@implementation MyBookDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MainViewController *mainVC = [[MainViewController alloc] init];
    
    //設定按鈕顏色
    mainVC.sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    //設定側邊欄按鈕動作，按下時，顯示側邊欄
    mainVC.sideBarButton.target = self.revealViewController;
    mainVC.sideBarButton.action = @selector(revealToggle:);
    
    //設定手勢
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.bookImg.image = self.myBook.imageAuthor;
    self.bookTitleLabel.text = self.myBook.title;
    self.authorLabel.text = self.myBook.name;
    
    self.btnPressed.tag = 1;
    self.moreButton.tag = 2;
    self.commentButton.tag = 3;
    self.deleteButton.tag = 4;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnPressed:(id)sender {
    

            
    
            
    
    
}

- (IBAction)commentBtnPressed:(id)sender {
    
}

- (IBAction)photoBtnPressed:(id)sender {
    
}

- (IBAction)deleteBtnPressed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"已刪除" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
    
    [alert show];
}

- (IBAction)nextBtnPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"請選擇" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"還想增加" otherButtonTitles: @"文字記事", @"相片記事", @"存取", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //actionSheet.tag = 1;
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSLog(@"文字記事");
        //[self openMail];
    }else if(buttonIndex == 2){
        NSLog(@"相片記事");
        //[self openLine];
    }else if(buttonIndex == 3){
        NSLog(@"Save");
        //[self save];
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
