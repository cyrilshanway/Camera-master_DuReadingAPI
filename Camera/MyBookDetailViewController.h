//
//  MyBookDetailViewController.h
//  Camera
//
//  Created by Cyrilshanway on 2014/12/7.
//  Copyright (c) 2014年 Cyrilshanway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

@interface MyBookDetailViewController : UIViewController
@property (nonatomic, strong) NSDictionary *finalBookDict;

@property Book *myBook;
@end
