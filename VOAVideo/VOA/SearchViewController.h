//
//  SearchViewController.h
//  VOA
//
//  Created by song zhao on 12-2-11.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "VOAView.h"
#import "VoaViewCell.h"
#import "UIImageView+WebCache.h"
#import "PlayerViewController.h"
#import "MBProgressHUD.h"
#import "VOADetail.h"

@interface SearchViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,ASIHTTPRequestDelegate,MBProgressHUDDelegate,UIAlertViewDelegate> 
{
    NSMutableArray *_contentsArray;
    NSMutableArray *_contentsSrArray;
    UITableView *_voasTableView;
    NSString *_searchWords;
    NSInteger _addNum;
//    NSInteger _searchFlg;
    NSInteger _contentMode;
    MBProgressHUD *_HUD;
    BOOL _isiPhone;
}

@property (nonatomic, retain) IBOutlet UITableView *voasTableView;
@property (nonatomic, retain) NSMutableArray *contentsArray;
@property (nonatomic, retain) NSString *searchWords;
//@property (nonatomic) NSInteger category;
@property (nonatomic, assign) NSInteger searchFlg;
@property (nonatomic, assign) NSInteger contentMode;
@property (nonatomic, retain) NSMutableArray *contentsSrArray;
@property (nonatomic, assign) NSInteger addNum;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property(nonatomic) BOOL isiPhone;
@property (nonatomic, retain) NSOperationQueue *sharedSingleQueue;

- (void)catchDetails:(VOAView *) voaid;
- (void)catchResult:(NSString *) searchWord page:(NSInteger)page;

@end
