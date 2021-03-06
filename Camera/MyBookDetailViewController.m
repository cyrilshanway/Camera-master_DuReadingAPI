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
#import "AFNetworking.h"
//#import "AFHTTPRequestOperationManager.h"

@interface MyBookDetailViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bookImg;
@property (weak, nonatomic) IBOutlet UILabel *bookTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel  *authorLabel;

@property (weak, nonatomic) IBOutlet UIButton *btnPressed;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong, nonatomic) IBOutlet UIView *showView;
@property (strong, nonatomic) IBOutlet UIView *commentShowView;
@property (strong, nonatomic) IBOutlet UIView *photoShowView;
@property (weak, nonatomic) IBOutlet UIScrollView *backgroundScrollView;

@property (nonatomic, strong) UITextField *descriptionTextField;
@property (nonatomic, strong) UITextField *isbntextField;
@property (nonatomic, strong) UITextField *pagesTextField;
@property (nonatomic, strong) UITextField *publisherTextField;
@property (nonatomic, strong) UITextField *publishedTextField;
@property (nonatomic, strong) UITextField *commentTextField;
@property (nonatomic, strong) UIImage *duPic;
@property (nonatomic, strong) UIImageView *duPicImageView;

@property (nonatomic, strong) NSArray *showArray;

@property (nonatomic,strong) NSString *savePicLocal;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


@property (weak, nonatomic) IBOutlet UIButton *saveTextBtn;
@property (weak, nonatomic) IBOutlet UIButton *savePhotoBtn;

@property (nonatomic, strong) UITextField *showDeatilTextField;
@property (nonatomic, strong) UITextView *descriptionView;
@property (nonatomic, strong) UITextView *commentView;
@property (strong, nonatomic) IBOutlet UITextView *addTextView;

@property (nonatomic, strong) UIImage *finalImage;
@property (retain, nonatomic)  IBOutlet UITextView *addTextView2;


@property (nonatomic, strong) UIImageView *pv1;
@property (nonatomic, strong) UIImageView *pv2;
@property (nonatomic, strong) UIImageView *pv3;
@property (nonatomic, strong) NSMutableArray *commentPhotoArray;
@property (nonatomic, strong) UIImageView *imageView2;
@property (nonatomic, strong) NSMutableArray *myArray;
@end

@implementation MyBookDetailViewController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

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
    //出版社.頁數.isbn.描述
    self.descriptionTextField.enabled = NO;
    self.isbntextField.enabled = NO;
    self.pagesTextField.enabled = NO;
    self.publisherTextField.enabled = NO;
    self.publishedTextField.enabled = NO;
    //先放進欄位
    self.descriptionTextField.text = self.myBook.descriptionBook;
    self.isbntextField.text = self.myBook.ISBNNum;
    self.pagesTextField.text = self.myBook.pageNum;
    self.publisherTextField.text = self.myBook.bookPublisher;
    self.publishedTextField.text = self.myBook.bookPublished;
    
    
    NSString *publishedString = [NSString stringWithFormat:@" 出版社 ： %@", _myBook.bookPublisher];
    NSString *pageNumString =   [NSString stringWithFormat:  @" 頁數     :   %@", _myBook.pageNum];
    NSString *isbnNumString =   [NSString stringWithFormat:  @" ISBN    :   %@", _myBook.ISBNNum];
    
    
    _showArray = @[ publishedString, pageNumString, isbnNumString];
    
    self.btnPressed.tag = 1;
    self.moreButton.tag = 2;
    self.commentButton.tag = 3;
    self.deleteButton.tag = 4;
    
    //scrollView
    self.backgroundScrollView.contentSize = CGSizeMake(320.0f, 660.0f);
    
    self.savePhotoBtn.hidden = YES;
    self.saveTextBtn.hidden  = YES;
    
    //view alloc/init
//    self.showView = [[UIView alloc] init];
//    self.commentShowView = [[UIView alloc] init];
//    self.photoShowView = [[UIView alloc] init];
//    //image/imageView alloc/init
//    self.duPic = [[UIImage alloc] init];
//    self.duPicImageView = [[UIImageView alloc] init];
//    self.addTextView2 = [[UITextView alloc] init];
    
    self.commentShowView.hidden = NO;
    self.photoShowView.hidden = YES;
    self.showView.hidden = YES;
    self.imageView.hidden = YES;
    self.addTextView2.hidden = YES;
    self.addTextView2.editable = NO;
    
    //取fb_pic
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *fb_pic = [defaults objectForKey:@"Photo"];
    //UIImage *result;
    NSString *imgurlTrans = fb_pic;
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurlTrans]];
    
    _duPic = [UIImage imageWithData:data];
    
    
    _savePicLocal = [[NSString alloc] init];
    
    
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(hideKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    self.addTextView2.hidden = NO;
    self.addTextView2.editable = YES;
    //self.addTextView2.backgroundColor = [UIColor redColor];
    self.addTextView2.frame = CGRectMake(0, 0, 325, 260);
    //[self.addTextView2 setText:@"TEST"];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)hideKeyboard {
    
    [self.view endEditing:YES];
    
}

-(NSArray*) showArray{
    
    if(!_showArray)
        _showArray = [[NSArray alloc]init];
    
    return _showArray;
}


//看其他內容(detail)
- (IBAction)btnPressed:(id)sender {
    
    [_showDeatilTextField resignFirstResponder];
    
    self.commentShowView.hidden = YES;
    self.photoShowView.hidden = YES;
    self.showView.hidden = NO;
    self.imageView.hidden = YES;
    self.addTextView2.hidden = YES;
    
    //UITextField *showSthTextField;
    NSString *descriptionString = [NSString stringWithFormat:@"描述     :   %@", _myBook.descriptionBook];
    
    //針對description做改善
    NSString *final = [descriptionString stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    
    for (int i = 0; i < _showArray.count; i++) {

        switch (i) {
            case 0:
                _showDeatilTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 10, 300, 30)];
                _showDeatilTextField.text = [_showArray objectAtIndex:i];
                _showDeatilTextField.enabled = NO;
                break;
            case 1:
                _showDeatilTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 50, 300, 30)];
                _showDeatilTextField.text = [_showArray objectAtIndex:i];
                _showDeatilTextField.enabled = NO;
                break;
            case 2:
                _showDeatilTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 90, 300, 30)];
                _showDeatilTextField.text = [_showArray objectAtIndex:i];
                _showDeatilTextField.enabled = NO;
                break;
            default:
                break;
        }
        
        _descriptionView = [[UITextView alloc] initWithFrame:CGRectMake(0, 130, 330, 200)];
        _descriptionView.text = final;
        _descriptionView.font = [UIFont systemFontOfSize:16.0f];
        
        self.showView.frame = CGRectMake(0, 0, 325, 260);
        self.showView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
        [self.showView addSubview:_descriptionView];
        [self.showView addSubview:_showDeatilTextField];
        [self.backgroundScrollView addSubview:self.showView];
        
        
        //[self.backgroundScrollView addSubview:_descriptionView];
        //[self.backgroundScrollView addSubview:_showDeatilTextField];
        [self.view addSubview:self.backgroundScrollView];
    }
}

//看留言(comments)
- (IBAction)commentBtnPressed:(id)sender {
    NSLog(@"%lu",self.myBook.bookCommentArray.count);
    //NSLog(@"%@",_myBook.bookCommentArray[0]);
    self.commentShowView.hidden = NO;
    self.photoShowView.hidden = YES;
    self.showView.hidden = YES;
    self.imageView.hidden = YES;
    self.addTextView2.hidden = YES;
   
    ////
    NSMutableArray *myArray = [[NSMutableArray alloc] init];
    for (int i = 0; i <self.myBook.bookCommentArray.count; i++) {
        NSString *tmpString = [NSString stringWithFormat:@"%@",[self.myBook.bookCommentArray[i] objectForKey:@"content"]];
        
        NSObject* o =[self.myBook.bookCommentArray[i] objectForKey:@"content"];
        if([o isKindOfClass:[NSNull class]]){
            continue;
        }

        if ([tmpString isEqualToString:@""]) {
            continue;
        }
        
        [myArray addObject:[self.myBook.bookCommentArray[i] objectForKey:@"content"]];
    }
    
    //NSLog(@"%@", myArray);
    //
    
    
    //for (int i=0; i<self.myBook.bookCommentArray.count; i++) {
    for (int i=0; i<myArray.count; i++) {
        //NSString *oneComment = [NSString stringWithFormat:@"%@",[self.myBook.bookCommentArray[i]objectForKey:@"content"]];
        NSString *oneComment = myArray[i];
        id value = oneComment;
        if ([value isEqualToString:@"<null>"]){
            NSLog(@"no message");
        }else{
        NSInteger x = 0;
        NSInteger y1 = 106;
        NSInteger y2 = 156;
        NSInteger y = 0;
        //NSInteger w = 40;
        NSInteger h = 100;//height
        NSInteger g = 40;//間隔
        
        UIImageView *img = [[UIImageView alloc] initWithImage:_duPic];
        //NSInteger w1 = 290;
        
        if( (i % 2) == 0) {
            x = 32;
            y = y1 + 0.5*( h + g )* (i-1);
            self.commentView.backgroundColor = [UIColor blueColor];
            //_duPicImageView.image = _duPic;
            img.frame = CGRectMake(x-30, y, 30, 30);
            //_duPicImageView.frame = CGRectMake(2, 36, 30, 30);
            
            //img.frame =CGRectMake(2, 36, 30, 30);
        }
        else {
            x = 170;
            y = y2 + 0.5*( h + g )* (i-2);
            self.commentView.backgroundColor = [UIColor redColor];
            //_duPicImageView.image = _duPic;
            img.frame = CGRectMake(x+120, y, 30, 30);
            //UIImageView *img = [[UIImageView alloc] initWithImage:_duPic];
            //img.frame = CGRectMake(290, 86, 30, 30);
        }
        
        self.commentView = [[UITextView alloc] initWithFrame:CGRectMake(x, y, 120, 30)];
        //self.commentView.text = [self.myBook.bookCommentArray[i]objectForKey:@"content"];
            self.commentView.text = myArray[i];
            
        NSLog(@"self.commentView.text: %@", self.commentView.text);
        
        [self.commentShowView addSubview:self.duPicImageView];
        
        _commentShowView.frame=CGRectMake(0, 0, 325, 560);
        
        //[self.backgroundScrollView addSubview:self.commentView];
        self.commentShowView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
       self.backgroundScrollView.backgroundColor =[UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
       [self.commentShowView addSubview:img];
       [self.commentShowView addSubview:self.commentView];
       [self.backgroundScrollView addSubview:self.commentShowView];
       [self.view addSubview:self.backgroundScrollView];
        }
    }
    
}

//看相片
- (IBAction)photoBtnPressed:(id)sender {
    self.commentShowView.hidden = YES;
    self.photoShowView.hidden = NO;
    self.showView.hidden = YES;
    self.imageView.hidden = YES;
    self.addTextView2.hidden = YES;
    
    _myArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i <self.myBook.bookCommentArray.count; i++) {
        NSString *tmpString = [NSString stringWithFormat:@"%@",[self.myBook.bookCommentArray[i] objectForKey:@"photo_large_url"]];
        NSObject* o =[self.myBook.bookCommentArray[i] objectForKey:@"photo_large_url:"];
        if([o isKindOfClass:[NSNull class]]){
            continue;
        }
        if ([tmpString isEqualToString:@"http://106.185.55.19/images/original/missing.png"]) {
            continue;
        }
        [_myArray addObject:[self.myBook.bookCommentArray[i] objectForKey:@"photo_large_url"]];
    }
    NSLog(@"%@",_myArray);
    
    self.commentPhotoArray = [[NSMutableArray alloc] initWithCapacity:0];
    UIView *bgView = [[UIView alloc] init];
    //NSMutableArray *tmpPicArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (_myArray.count == 0) {
        [self.commentPhotoArray addObject:@"book13.jpg"];
        [self.commentPhotoArray addObject:@"baby.jpg"];
        [self.commentPhotoArray addObject:@"book12.jpg"];
        NSLog(@"%@", self.commentPhotoArray);
        for (int i = 0 ; i < _commentPhotoArray.count; i++)
        {
            switch (i) {
                case 0:
                    bgView.frame = CGRectMake(0, 0, 325, 260);
                    bgView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
                    _imageView2 = [[UIImageView alloc] init];
                    _imageView2.frame=CGRectMake(0, 0, 325, 260);
                    _imageView2.image = [UIImage imageNamed:_commentPhotoArray[0]];
                    [bgView addSubview:_imageView2];
                    break;
                case 1:
                    bgView.frame = CGRectMake(0, 0, 325, 260);
                    bgView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
                    _imageView2 = [[UIImageView alloc] init];
                    _imageView2.frame=CGRectMake(0, 260, 325, 260);
                    _imageView2.image = [UIImage imageNamed:_commentPhotoArray[1]];
                    [bgView addSubview:_imageView2];
                    break;
                case 2:
                    bgView.frame = CGRectMake(0, 0, 325, 260);
                    bgView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
                    _imageView2 = [[UIImageView alloc] init];
                    _imageView2.frame=CGRectMake(0, 520, 325, 260);
                    _imageView2.image = [UIImage imageNamed:_commentPhotoArray[2]];
                    [bgView addSubview:_imageView2];
                    break;
                case 3:
                    break;
                case 4:
                    break;
                default:
                    break;
            }
            [self.photoShowView addSubview:bgView];
            [self.backgroundScrollView addSubview:self.photoShowView];
        }
    }else{
        for (int i =0; i < _myArray.count; i++) {
            NSObject* o =_myArray[i];
            if([o isKindOfClass:[NSNull class]]){
            continue;
            }
            UIImage *result;
            NSString *imgurlTrans = _myArray[i];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imgurlTrans]];
        
            result = [UIImage imageWithData:data];
            [self.commentPhotoArray addObject:result];
            
            NSLog(@"%@", self.commentPhotoArray);
            switch (i) {
                case 0:
                    //bgView.frame = CGRectMake(0, 0, 148, 130);
                    bgView.frame = CGRectMake(0, 0, 325, 260);
                    bgView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
                    _imageView2 = [[UIImageView alloc] init];
                    //_imageView2.frame=CGRectMake(0, 0, 148, 130);
                    _imageView2.frame=CGRectMake(0, 0, 325, 260);
                    _imageView2.image = [_commentPhotoArray objectAtIndex:0];
                   [bgView addSubview:_imageView2];
                    
                    //[_imageView2 setImage:[_commentPhotoArray objectAtIndex:0]];
                    break;
                case 1:
                     //bgView.frame = CGRectMake(0, 0, 148, 130);
                    bgView.frame = CGRectMake(0, 0, 325, 260);
                     bgView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
                    _imageView2 = [[UIImageView alloc] init];
                    //_imageView2.frame=CGRectMake(0, 130, 148, 130);
                    _imageView2.frame=CGRectMake(0, 260, 325, 260);
                    _imageView2.image = self.commentPhotoArray[1];
                    [bgView addSubview:_imageView2];
                    break;
                case 2:
                    //bgView.frame = CGRectMake(0, 0, 148, 130);
                    bgView.frame = CGRectMake(0, 0, 325, 260);
                     bgView.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
                    _imageView2 = [[UIImageView alloc] init];
                    //_imageView2.frame=CGRectMake(145, 0, 180, 260);
                    _imageView2.frame=CGRectMake(0, 520, 325, 260);
                    _imageView2.image = self.commentPhotoArray[2];
                    [bgView addSubview:_imageView2];
                    break;
                 case 3:
                    break;
                case 4:
                    break;
                default:
                    break;
            }
            [self.photoShowView addSubview:bgView];
            [self.backgroundScrollView addSubview:self.photoShowView];
            //[self.view addSubview:self.backgroundScrollView];
        }
    }
}

//刪除書籍資料
//DELETE /api/v1/books/{id} 刪除書
- (IBAction)deleteBtnPressed:(id)sender {
    Book *myNewBook = [[Book alloc] init];
    myNewBook = _myBook;
    
    if (myNewBook.email == nil) {
        myNewBook.email = @"default@email.com";
    }
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *user_id    = [defaults objectForKey:@"user_id"];
    
    //DELETE /api/v1/books/{id} 刪除書
    //1. 準備HTTP Client
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.185.55.19/"]];
    
    //11/28//取auth_token / user_id
    NSString *auth_token = [defaults objectForKey:@"auth_token"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            auth_token,@"auth_token",
                            myNewBook.book_id,@"id",
                            nil];
    NSString *path = [NSString stringWithFormat:@"api/v1/books/%@?auth_token=%@",myNewBook.book_id, auth_token];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"DELETE"
                                                            path:path
                                                      parameters:nil];//dictionary
    //2.準備operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    //3.準備callback block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma mark - progressed 完成
        //載入完成
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"已刪除" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
        
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];
    
    //4. Start傳輸
    [operation start];
}

- (IBAction)nextBtnPressed:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"現在想要" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"增加..." otherButtonTitles: @"寫點東西?", @"拍張照吧!", nil];
    
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //actionSheet.tag = 1;
    
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        NSLog(@"隨手心情");
        [self addNote];
    }else if(buttonIndex == 2){
        NSLog(@"永恆瞬間");
        [self openCamera];
    }
}

//新增筆記(增加save鈕)
- (void)addNote{
    self.savePhotoBtn.hidden = YES;
    self.saveTextBtn.hidden  = NO;
    
    self.addTextView2.hidden = NO;
    self.addTextView2.editable = YES;
    self.addTextView2.backgroundColor = [UIColor colorWithRed:211.0/255 green:211.0/255 blue:190.0/255 alpha:1];
    //self.addTextView2.tintColor = [UIColor grayColor];
    self.addTextView2.frame = CGRectMake(0, 0, 325, 260);
    //[self.addTextView2 setText:@"TEST"];
    
    
    self.commentShowView.hidden = YES;
    self.photoShowView.hidden = YES;
    self.showView.hidden = YES;
    self.imageView.hidden = YES;
    
    
}

//新增照片/開啟相機
-(void)openCamera{
    self.savePhotoBtn.hidden = NO;
    self.saveTextBtn.hidden = YES;
    
    //使用內建相簿
    if ([UIImagePickerController isSourceTypeAvailable:(UIImagePickerControllerSourceTypeSavedPhotosAlbum)]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}
#pragma mark - delegte
//使用相機照相或是相簿選照片此delegate方法會被呼叫
//info是一個NSDictionary，包含原始圖像以及讓UIImagePickerControllerEditedImage標籤來存取的編輯後圖像
//，當app允許使用者編輯圖片時，就會用編輯後的圖片來取代遠使的圖片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.commentShowView.hidden = YES;
    self.photoShowView.hidden = YES;
    self.showView.hidden = YES;
    self.imageView.hidden = NO;
    self.addTextView2.hidden = YES;
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/profile.jpg"];
    UIImage *currentImg = chosenImage;
    [UIImageJPEGRepresentation(currentImg, 1.0) writeToFile:savePath atomically:YES];
    //UIImage *profileImage = [UIImage imageWithContentsOfFile:savePath];
    self.imageView.image =[UIImage imageWithContentsOfFile:savePath];
    _savePicLocal = savePath;
    
    [self.backgroundScrollView addSubview:self.imageView];
    [self.view addSubview:_backgroundScrollView];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.savePhotoBtn.hidden = NO;
    self.saveTextBtn.hidden = YES;
}

//user有可能會按"cancel"取消操作
//只要移除PickerController就可以了
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
    self.savePhotoBtn.hidden = YES;
    self.saveTextBtn.hidden = YES;
}

//留言儲存
/*DELETE /ap1/v1/comments/{id} 刪除
http://106.185.55.19/api/v1/comments/2?auth_token=12ece4d48c55518afc3710008489315e
*/
 - (IBAction)saveTextBtnPressed:(id)sender {
     self.commentShowView.hidden = YES;
     self.photoShowView.hidden = YES;
     self.showView.hidden = YES;
     self.imageView.hidden = YES;
     self.addTextView2.hidden = NO;
     
    Book *myNewBook = [[Book alloc] init];
    myNewBook = _myBook;
    
    //儲存留言
    /*
     POST /ap1/v1/books/{id}/comments 新增一個留言(或照片)
     參數 content
     參數 photo
     回傳 comment_id
     */
    //1. 準備HTTP Client
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.185.55.19/"]];
     self.addTextView2.backgroundColor = [UIColor grayColor];
     NSString *saveString = [NSString stringWithFormat:@"%@", self.addTextView2.text];
     
    //取auth_token
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults objectForKey:@"auth_token"];
    NSString *path = [NSString stringWithFormat:@"api/v1/books/%@/comments",myNewBook.book_id];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                             auth_token,@"auth_token",
                             saveString,@"content",
                             nil];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod: @"POST"
                                                            path: path
                                                      parameters: params];//dictionary
    //2.準備operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    //3.準備callback block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma mark - progressed 完成
        
        //載入完成
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"留言已加入" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
        
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error");
    }];
    
    //4. Start傳輸
    [operation start];

}

//相片儲存
- (IBAction)savePhotoBtnPressed:(id)sender {
    
    self.commentShowView.hidden = YES;
    self.photoShowView.hidden = YES;
    self.showView.hidden = YES;
    self.imageView.hidden = NO;
    self.addTextView2.hidden = YES;
    
    Book *myNewBook = [[Book alloc] init];
    myNewBook = _myBook;
    
    //儲存留言/相片
    /*
     http://106.185.55.19/api/v1/books/2/comments?auth_token=12ece4d48c55518afc3710008489315e
     http://106.185.55.19/api/v1/books/7/comments?auth_token=12ece4d48c55518afc3710008489315e
     POST /ap1/v1/books/{id}/comments 新增一個留言(或照片)
     參數 content
     參數 photo
     回傳 comment_id
     */
    
    UIImage *chosenImage = self.imageView.image;
     NSString *savePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/profile.jpg"];
     UIImage *currentImg = chosenImage;
     [UIImageJPEGRepresentation(currentImg, 1.0) writeToFile:savePath atomically:YES];
    
    //1. 準備HTTP Client
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.185.55.19/"]];
    
    //11/28//取auth_token / user_id
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *auth_token = [defaults objectForKey:@"auth_token"];
    //NSString *path = [NSString stringWithFormat:@"api/v1/books/%@/comments?auth_token=%@",myNewBook.book_id, auth_token];
    NSString *path = [NSString stringWithFormat:@"api/v1/books/"];
    //UIImageView *tmp = [[UIImageView alloc] initWithImage:self.imageView.image];
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.5);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            auth_token,@"auth_token",
                            myNewBook.book_id,@"id",
                            imageData,@"photo",
                            nil];
    
    NSLog(@"%@", params);
    NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST"
                                                                         path:path
                                                                   parameters:params
                                                    constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                                                        NSString *photoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/profile.jpg"];
                                                        UIImage *originalImage = [UIImage imageWithContentsOfFile:photoPath];
                                                        //UIImage *finalImage = [self scaleImage:originalImage toScale:(float)0.5f];
                                                        NSData *uploadFile = UIImageJPEGRepresentation(originalImage, 1.0);
                                                        
                                                        [formData appendPartWithFileData:uploadFile name:@"profile" fileName:@"profile.jpg" mimeType:@"image/jpeg"];
                                                    }];
    
    
/*
    NSMutableURLRequest *request = [httpClient requestWithMethod: @"POST"
                                                            path: path
                                                      parameters: params];//dictionary
    
*/
    //2.準備operation
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    //3.準備callback block
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
#pragma mark - progressed 完成
        
        //載入完成
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"相片已加入" delegate:self cancelButtonTitle:@"確定" otherButtonTitles: nil];
        
        [alert show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error %@", [error description]);
    }];
    
    //4. Start傳輸
    [operation start];
    
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView;{
    NSLog(@"ok");
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
