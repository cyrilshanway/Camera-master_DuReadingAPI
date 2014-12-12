//
//  MainViewController.m
//  Camera
//
//  Created by Cyrilshanway on 2014/11/23.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "Book.h"
#import "ShowBookViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "MyBookDetailViewController.h"

@interface MainViewController ()
{
    NSInteger *arrayNum;
    NSMutableArray *imageArray;
}
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;

@property (nonatomic, strong )NSMutableArray *isbnArray;
@property (nonatomic, strong) NSDictionary *showThisBookInfoDict;
@property (nonatomic, strong) NSDictionary *tempDict;

@property (nonatomic, strong) NSMutableArray *currentIsbnArray2;
@property (nonatomic, strong) NSMutableArray *currentPicArray2;
@property (nonatomic, strong) NSDictionary   *currrentBookDict2;
@property (nonatomic, strong) NSMutableArray *userAllBookArray2;


@property (nonatomic, strong) NSMutableArray *showPicArray2;
//@property Book *myBook;

@end

@implementation MainViewController
- (NSMutableArray *) imageArray {
 
    if (!imageArray) {
        imageArray = [@[]mutableCopy];
    }
    
    return imageArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //self.title = @"News";
    
    self.backgroundScrollView.contentSize = CGSizeMake(320.0f, 900.0f);
    
    //設定按鈕顏色
    _sideBarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.3f];
    //設定側邊欄按鈕動作，按下時，顯示側邊欄
    _sideBarButton.target = self.revealViewController;
    _sideBarButton.action = @selector(revealToggle:);
    
    //設定手勢
    //[self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //defaultuser
    //1209
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    //NSString *defaultuser = [defaults objectForKey:@"user"];
    //defaultuser:access_token
    
    //設定fb access_token
    //1209
    //NSString *access_token = [FBSession activeSession].accessTokenData.accessToken;
    //NSLog(@"access_token: %@", access_token);
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //1209
    //[defaults setObject:access_token forKey:@"access_token"];
    
    //[defaults synchronize];
    
    [self getLogin];
    
    
    /*
    //parse query
    PFQuery *query = [PFQuery queryWithClassName:@"Book"];
    [query whereKey:@"Owner" equalTo:defaultuser];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    
    {
        if (objects) {
            // The find succeeded.
            NSLog(@"successful");
            
            arrayNum = (NSInteger *)objects.count;
            NSLog(@"objects: %ld", objects.count);
            
            
            NSMutableArray *showPicArray = [[NSMutableArray alloc] init];
            
            NSArray *array1 = objects;
            
            for (int i =0; i < array1.count; i++) {
                UIImage *result;
                NSString *imgurlTrans = array1[i][@"imageUrl"];
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurlTrans]];
                
                result = [UIImage imageWithData:data];
                
                [showPicArray addObject:result];
                
                
                //NSLog(@"pic: %@", array1[i][@"imageUrl"]);
                
            }
           imageArray = showPicArray;
            //NSLog(@"%@",array1[0][@"imageUrl"]);
            
            
            
            //顯示畫面
            
             //設定要顯示的書籍數量
             NSMutableArray *imageList = [NSMutableArray arrayWithCapacity:objects.count];
             NSMutableArray *buttonList= [NSMutableArray arrayWithCapacity:objects.count];
             NSMutableArray *imageArray2 = imageArray;
            
             for (int i = 0 ; i < array1.count; i++) {
             
             NSInteger x = 40;
             NSInteger y1 = 40;
             NSInteger y = 0;
             NSInteger w = 40;
             NSInteger h = 100;//height
             NSInteger g = 40;//間隔
             
             if( (i % 2) == 0) {
             x = 65;
             y = y1 + 0.5*( h + g )* (i-1);
             }
             else {
             x = 220;
             y = y1 + 0.5*( h + g )* (i-2);
             }
             UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 100, 130)];
             [bgView setBackgroundColor:[UIColor grayColor]];
             UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 130)];
             
             //[imageView setImage:[UIImage imageNamed:[imageArray2 objectAtIndex:i]]];
                 imageView.image = [imageArray2 objectAtIndex:i];
             [imageView setContentMode:UIViewContentModeScaleAspectFit];
             [bgView addSubview:imageView];
             
             
             
             [imageList addObject:bgView];
             
             UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x+5, y+5, 90, 110)];
             button.backgroundColor = [UIColor clearColor];
             button.alpha = 0.5;
             [buttonList addObject:button];
             [button setTag:i];
             
             if (i == 0) {
             //[button addTarget:self action:@selector(buttonPressed2VC:) forControlEvents:UIControlEventTouchUpInside];
             NSLog(@"ok");
             }
             
             [self.backgroundScrollView addSubview:bgView];
             [self.backgroundScrollView addSubview:button];
             }

            
        } else {
            
            UIAlertController *alert = [UIAlertController
                                        alertControllerWithTitle:@"提醒"
                                        message:@"您的書櫃還沒有書籍，開始新增吧！"
                                        preferredStyle:(UIAlertControllerStyleAlert)];
            
            // 想像成button
            UIAlertAction *ok = [UIAlertAction actionWithTitle:@"確認"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action){
                                                           [alert dismissViewControllerAnimated:YES
                                                                                     completion:nil];
                                                       }];
            
            [alert addAction:ok];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
    
    */
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableArray*) isbnArray{
    
    if(!_isbnArray)
        _isbnArray = [[NSMutableArray alloc]init];
    
    return _isbnArray;
}

-(NSDictionary*) showThisBookInfoDict{
    
    if(!_showThisBookInfoDict)
        _showThisBookInfoDict = [[NSDictionary alloc]init];
    
    return _showThisBookInfoDict;
}

-(NSDictionary*) tempDict{
    
    if(!_tempDict)
        _tempDict = [[NSDictionary alloc]init];
    
    return _tempDict;
}

-(NSMutableArray*) currentIsbnArray2{
    
    if(!_currentIsbnArray2)
        _currentIsbnArray2 = [[NSMutableArray alloc]init];
    
    return _currentIsbnArray2;
}

-(NSMutableArray*) currentPicArray2{
    
    if(!_currentPicArray2)
        _currentPicArray2 = [[NSMutableArray alloc]init];
    
    return _currentPicArray2;
}

-(NSMutableArray*) userAllBookArray2{
    
    if(!_userAllBookArray2)
        _userAllBookArray2 = [[NSMutableArray alloc]init];
    
    return _userAllBookArray2;
}

-(NSDictionary*) currrentBookDict2{
    
    if(!_currrentBookDict2)
        _currrentBookDict2 = [[NSDictionary alloc]init];
    
    return _currrentBookDict2;
}

-(NSDictionary*) finalBookDict{
    
    if(!_finalBookDict)
        _finalBookDict = [[NSDictionary alloc]init];
    
    return _finalBookDict;
}

-(NSMutableArray*) showPicArray2{
    
    if(!_showPicArray2)
        _showPicArray2 = [[NSMutableArray alloc]init];
    
    return _showPicArray2;
}

- (void)getLogin{
    //1. 準備HTTP Client
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.185.55.19/"]];
    
    //取sccess_tiken
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *access_token = [defaults objectForKey:@"access_token"];
    
    //11/28
    //NSString *token = fb_token;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            access_token,@"access_token",
                            nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"api/v1/login"
                                                      parameters:params];//dictionary
    //2.準備operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    //3.準備callback block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma mark - progressed 完成
        //載入完成
        
        
        NSString *tmp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //test log
        NSLog(@"Response: %@",tmp);
        
        
        
#pragma mark - 轉資料11/26
        
        //Generate NSDictionary
        NSData *rawData = [tmp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *e1;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingMutableContainers error:&e1];
        
        //Generate JSON data(11/28)想要存在local端
        NSError *e2;
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&e2];
        NSLog(@"json data: %@",jsondata);
        
        //設定auth_token / user_id(存)
        NSString *tmp_auth = [dict objectForKey:@"auth_token"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_id"]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:tmp_auth forKey:@"auth_token"];
        [defaults setObject:user_id forKey:@"user_id"];
        
        //step.4
        [self getDuReadingURL];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error:%@ ", [error description]);
    }];
    
    //4. Start傳輸
    [operation start];
}

- (void)getDuReadingURL{
    //1. 準備HTTP Client
    //取auth_token / user_id
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults objectForKey:@"auth_token"];
    NSString *user_id    = [defaults objectForKey:@"user_id"];
    NSLog(@"auth_token:%@", auth_token);
    
    //NSString *auth_token = fb_token;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            auth_token,@"auth_token",
                            nil];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.185.55.19/"]];
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:@"api/v1/books"
                                                      parameters:params];
    //2.準備operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    //3.準備callback block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString *tmp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        //NSLog(@"Response: %@",tmp);
        
        NSData *rawData = [tmp dataUsingEncoding:NSUTF8StringEncoding];
        
        NSError *e1;
        
        //裝isbn
        NSMutableArray *currentIsbnArray = [[NSMutableArray alloc] init];
        //裝封面(做處理)
        NSMutableArray *currentPicArray = [[NSMutableArray alloc] init];
        //裝個別書資訊
        NSDictionary *currrentBookDict = [[NSDictionary alloc] init];
        //user所有書籍資訊
        //NSMutableDictionary *userAllBookDict = [[NSMutableArray alloc] init];
        NSMutableArray *userAllBookArray = [[NSMutableArray alloc] init];
        
        
        //開始找書吧！
        //1. 先找出user擁有的書
        NSString *user = user_id;
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:rawData options:NSJSONReadingMutableContainers error:&e1];
        //NSArray *bookInfo1 = dict[@"books"];
        NSInteger arrayNum = [dict[@"books"] count];
        
        //Generate JSON data(11/28)想要存在local端
        NSError *e2;
        NSData *jsondata = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&e2];
        NSLog(@"json data: %@",jsondata);
        
        
        //NSLog(@"%@",dict[@"books"][0][@"id"]);
        
        for (int i = 0; i < arrayNum; i++) {
            //            NSLog(@"i = %d,id: %@", i ,[dict[@"books"][i]objectForKey:@"id"]);
            //            NSLog(@"%@", dict[@"books"]);
            NSLog(@"%@",dict[@"books"][i]);
            
            NSString *stringA = [NSString stringWithFormat:@"%@", [dict[@"books"][i] objectForKey:@"user_id"]];
            
            if ([user isEqualToString:stringA]) {
                //NSString *isbnString =[dict[@"books"][i] objectForKey:@"isbn"];
                //只存isbn訊息的array
                [currentIsbnArray addObject:[dict[@"books"][i] objectForKey:@"isbn"]];
                //只存pic封面的array
                [currentPicArray addObject:[dict[@"books"][i] objectForKey:@"cover_large_url"]];
                //裝個別書資訊
                currrentBookDict = @{@"author":[dict[@"books"][i] objectForKey:@"author"],
                                     @"cover_large_url":[dict[@"books"][i] objectForKey:@"cover_large_url"],
                                     @"cover_small_url":[dict[@"books"][i] objectForKey:@"cover_small_url"],
                                     @"description":[dict[@"books"][i] objectForKey:@"description"],
                                     @"id":[dict[@"books"][i] objectForKey:@"id"],
                                     @"isbn":[dict[@"books"][i] objectForKey:@"isbn"],
                                     @"pages":[dict[@"books"][i] objectForKey:@"pages"],
                                     @"publish_date":[dict[@"books"][i] objectForKey:@"publish_date"],
                                     @"publisher":[dict[@"books"][i] objectForKey:@"publisher"],
                                     @"title":[dict[@"books"][i] objectForKey:@"title"],
                                     @"user_id":[dict[@"books"][i] objectForKey:@"user_id"],
                                     @"comments":[dict[@"books"][i] objectForKey:@"comments"]
                                     };
                
                //NSLog(@"currrentBookDict: %@", currrentBookDict);
                [userAllBookArray addObject:currrentBookDict];
                //[userAllBookDict setObject:currrentBookDict forKey:isbnString];
                
            }
            
        }
        
        self.userAllBookArray2 = userAllBookArray;
        NSLog(@"currentPicArray: %@",currentPicArray);
        NSLog(@"currrentBookDict: %@",currrentBookDict);
        NSLog(@"currentIsbnArray: %@", currentIsbnArray);
        //user擁有的書的isbn array isbnArray
        self.isbnArray = currentIsbnArray;
        //擁有的書籍數量(首先用途：要產生幾本封面)
        //NSInteger ownerbbookNum = currentIsbnArray.count;
        
        NSMutableArray *showPicArray = [[NSMutableArray alloc] init];
        
        NSMutableArray *imageList = [NSMutableArray arrayWithCapacity:self.isbnArray.count];
        NSMutableArray *buttonList= [NSMutableArray arrayWithCapacity:self.isbnArray.count];
        
        //pic轉檔
        
        for (int i =0; i < currentPicArray.count; i++) {
            
            NSObject* o =currentPicArray[i];
            if([o isKindOfClass:[NSNull class]]){
                continue;
            }
            
            NSString *tmp = [NSString stringWithFormat:@"%@",currentPicArray[i]];
//            if (tmp != <null>) {
//                <#statements#>
//            }
            UIImage *result;
            NSString *imgurlTrans = currentPicArray[i];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurlTrans]];
            
            result = [UIImage imageWithData:data];
            
            [showPicArray addObject:result];
            
            //NSLog(@"pic: %@", array1[i][@"imageUrl"]);
            //self.backgroundScrollView.imageView.image = result;
        }
        _showPicArray2 = showPicArray;
        
        //------------------AFImageRequestOperation----------------------//
        //因為不是同步處理照片，接下來往下走就要存照片，那pic的array就是空的，會當掉
        
        //        for (int i = 0 ; i < [currentPicArray count]; i++) {
        //            //NSString *urlStr = [_dataSource[i] objectForKey:@"featured_image"];
        //            NSString *urlString = currentPicArray[i];
        //            NSString *imageRequestURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //            NSURL *imageURL = [NSURL URLWithString:imageRequestURL];
        //
        //            AFImageRequestOperation* imageOperation = [AFImageRequestOperation imageRequestOperationWithRequest: [NSURLRequest requestWithURL:imageURL] success:^(UIImage *image) {
        //                [showPicArray addObject:image];
        //                //[showPicArray setObject:image atIndexedSubscript:i];
        //                //[self.tableView reloadData];
        //            }];
        //
        //            NSOperationQueue* queue = [[NSOperationQueue alloc] init];
        //            [queue addOperation:imageOperation];
        //            [imageOperation start];
        //        }
        
        
        //------------------------------------------------//
        for (int i = 0 ; i < _showPicArray2.count; i++) {
            
            NSInteger x = 40;
            NSInteger y1 = 106;
            NSInteger y = 0;
            //NSInteger w = 40;
            NSInteger h = 100;//height
            NSInteger g = 40;//間隔
            
            if( (i % 2) == 0) {
                x = 69;
                y = y1 + 0.5*( h + g )* (i-1);
            }
            else {
                x = 240;
                y = y1 + 0.5*( h + g )* (i-2);
            }
            UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, y, 34, 98)];
            [bgView setBackgroundColor:[UIColor grayColor]];
            UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 98)];
            
            //[imageView setImage:[UIImage imageNamed:[imageArray2 objectAtIndex:i]]];
            //imageView.image = [imageArray2 objectAtIndex:i];
            //先試試都放default
            imageView.image = [showPicArray objectAtIndex:i];
            
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [bgView addSubview:imageView];
            
            [imageList addObject:bgView];
            
            UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(x-20, y, 90, 110)];
            button.backgroundColor = [UIColor clearColor];
            
            button.alpha = 1;
            [buttonList addObject:button];
            [button setTag:i];
            [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.backgroundScrollView addSubview:bgView];
            [self.backgroundScrollView addSubview:button];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"HTTP Error");
    }];
    
    //4. Start傳輸
    [operation start];
    
}

-(void)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    NSInteger aNum = button.tag;
    
    _finalBookDict = _userAllBookArray2[aNum] ;
    
    Book *myNewBook = [[Book alloc] init];
    
    myNewBook.descriptionBook = _finalBookDict[@"description"];
    myNewBook.owner = [NSString stringWithFormat:@"%@", _finalBookDict[@"id"]];
    myNewBook.bookCommentArray = _finalBookDict[@"comments"];
    myNewBook.pageNum = [NSString stringWithFormat:@"%@", _finalBookDict[@"pages"]];
    myNewBook.bookPublished = _finalBookDict[@"publish_date"];
    myNewBook.name = _finalBookDict[@"author"];
    myNewBook.ISBNNum = _finalBookDict[@"isbn"];
    myNewBook.title = _finalBookDict[@"title"];
    myNewBook.bookPublisher = _finalBookDict[@"publisher"];
    myNewBook.imageAuthor = _showPicArray2[aNum];
    myNewBook.book_id = _finalBookDict[@"id"];
    myNewBook.bookCommentArray = [_finalBookDict objectForKey:@"comments"];
    
    //NSLog(@"%@",myNewBook.bookCommentArray.count);
    
    //UIImageView *img = [[UIImageView alloc] initWithImage:myNewBook.imageAuthor];
    
    //NSLog(@"%@",[ myNewBook.bookCommentArray[0] objectForKey:@"id"]);
    
    
    self.myBook = myNewBook;
    
    [self performSegueWithIdentifier:@"detailSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MyBookDetailViewController* vc = segue.destinationViewController;
    vc.myBook = self.myBook;
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
