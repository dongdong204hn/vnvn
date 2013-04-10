
//
//  NewViewController.h
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

//#import "PlayViewController.h"
#import "PlayerViewController.h"
#import "VOAView.h"
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "VoaViewCell.h"
#import "UIImageView+WebCache.h"
#import "SearchViewController.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "ASIHTTPRequest.h"
#import "MBProgressHUD.h"
#import "Reachability.h"//isExistenceNetwork
#import "EGORefreshTableHeaderView.h" 

@interface NewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,ASIHTTPRequestDelegate,MBProgressHUDDelegate,EGORefreshTableHeaderDelegate> 
{
    UITableView *voasTableView;
    NSMutableArray *voasArray;
    UISearchBar *search;
    MBProgressHUD *HUD;
    NSInteger lastId;
    NSInteger addNum;
    NSInteger pageNum;
//    BOOL isExisitNet;
    BOOL rightCharacter;
    BOOL _reloading; 
    BOOL isiPhone;
    BOOL notSelect;
    EGORefreshTableHeaderView *_refreshHeaderView; 
    
}

@property (nonatomic, retain) NSMutableArray *voasArray;
@property (nonatomic, retain) NSArray *classArray;
@property (nonatomic) NSInteger				lastId;
@property (nonatomic) NSInteger addNum;
@property (nonatomic) NSInteger pageNum;
@property (nonatomic) NSInteger category;
@property (nonatomic, retain) NSString *nowTitle;
//@property (nonatomic) BOOL isExisitNet;
@property (nonatomic) BOOL rightCharacter;
@property (nonatomic) BOOL reloading; 
@property (nonatomic) BOOL isiPhone;
@property (nonatomic) BOOL notSelect;
@property (nonatomic) BOOL returnFromPlayer;
@property (nonatomic) BOOL haveRotate;
@property (nonatomic) BOOL haveReseach;
@property (nonatomic, retain) UIButton *titleBtn;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) IBOutlet UITableView *voasTableView;
@property (nonatomic, retain) UITableView *classTableView;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic, retain) EGORefreshTableHeaderView *refreshHeaderView; 
@property (nonatomic, retain) NSOperationQueue *sharedSingleQueue;

//- (IBAction)doReturn:(id)sender;
- (void)catchIntroduction:(NSInteger)maxid pages:(NSInteger)pages pageNum:(NSInteger)pageNumOne;
- (void)catchDetails:(VOAView *)voaid;
-(BOOL) isExistenceNetwork:(NSInteger)choose;
- (void)reloadTableViewDataSource; 
- (void)doneLoadingTableViewData; 
//- (void)catchNetA;

@end