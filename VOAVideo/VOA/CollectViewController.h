//
//  CollectViewController.h
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "VOAView.h"
#import <PlausibleDatabase/PlausibleDatabase.h>
#import "VoaViewCell.h"
#import "SearchViewController.h"
#import "VOAFav.h"
#import "PlayerViewController.h"

@interface CollectViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> 
{
    UITableView *voasTableView;
//    NSMutableArray *voasArray;
    NSMutableArray *favArray;
    UISearchBar *search;
    MBProgressHUD *HUD;
    BOOL isiPhone;
}

@property (nonatomic, retain) IBOutlet UITableView *voasTableView;
//@property (nonatomic, retain) NSMutableArray *voasArray;
@property (nonatomic, retain) NSMutableArray *favArray;
@property (nonatomic, retain) UISearchBar *search;
@property (nonatomic, retain) MBProgressHUD *HUD;
@property (nonatomic) BOOL isiPhone;

@end
