//
//  WordViewController.h
//  VOA
//
//  Created by song zhao on 12-2-6.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "VOAWord.h"
#import "MyLabel.h"
#import "ASIHTTPRequest.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "RegexKitLite.h"
//#import "MBProgressHUD.h"
#import "WordViewCell.h"
#import "LogController.h"
#import "LocalWord.h"

@interface WordViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,MyLabelDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>{
    UITableView *wordsTableView;
    NSMutableArray *wordsArray;
    UISearchBar *search;
    VOAWord *myWord;
    MyLabel *explainView;
//    MBProgressHUD *HUD;
    AVPlayer	*wordPlayerTwo;
    NSInteger isCellPlay;
    NSInteger nowUserId;
    NSInteger flg;
//    UIImageView     *wordFrame;
    UIAlertView *alert;
    BOOL isiPhone;
//    BOOL isExisitNet;
}

@property (nonatomic, retain) AVPlayer	*wordPlayerTwo;
@property (nonatomic, retain) NSMutableArray *wordsArray;
@property (nonatomic, retain) IBOutlet UITableView *wordsTableView;
@property (nonatomic, retain) VOAWord *myWord;
@property (nonatomic) NSInteger isCellPlay;
@property (nonatomic) NSInteger nowUserId;
@property (nonatomic) NSInteger flg;
@property (nonatomic) BOOL isiPhone;
//@property (nonatomic) BOOL isExisitNet;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) MyLabel *explainView;
//@property (nonatomic, retain) MBProgressHUD *HUD;
//@property (nonatomic, retain) UIImageView     *wordFrame;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSOperationQueue *sharedSingleQueue;

- (void)catchWords:(NSString *) word;
- (NSOperationQueue *)sharedQueue;
- (void)catchAsWordDetails:(NSInteger) wordId;
- (void)catchAsFlg:(NSInteger) wordId mode:(NSString *) mode;
- (void)catchAllByPageNumber:(NSInteger) number;

@end
