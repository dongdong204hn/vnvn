//
//  CollectViewController.m
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "CollectViewController.h"
#import "database.h"
#import "UIImageView+WebCache.h"
@implementation CollectViewController

@synthesize voasTableView;
@synthesize favArray;
@synthesize search;
@synthesize HUD;
@synthesize isiPhone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - My action
//- (BOOL)isPad {
//	BOOL isPad = NO;
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
//	isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//#endif
//	return isPad;
//}

-(UIButton*)getSearchBarCancelButton{
    
    UIButton* btn=nil;
    
    for(UIView* v in search.subviews) {
        
        if ([v isKindOfClass:UIButton.class]) {
            
            btn=(UIButton*)v;
            
            break;
            
        }
        
    }
    
    return btn;
    
}

- (void)doSearch
{
    self.navigationController.navigationBarHidden = YES;
    
    if (isiPhone) {
        //        UIDevice *device = [UIDevice currentDevice] ;
        if (kIsLandscapeTest) {
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, kScreenHeight, kViewHeight)];
        } else {
            [search setFrame:CGRectMake(0, 0, 320, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, 320, kViewHeight)];
        }
    }else {
        if (kIsLandscapeTest) {
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, 1024, kViewHeight)];
        } else {
            [search setFrame:CGRectMake(0, 0, 768, 44)];
            [voasTableView setFrame:CGRectMake(0, 44, 768, kViewHeight)];
        }
    }
    
    
    [search setHidden:NO];
    
    UIButton* btn=[self getSearchBarCancelButton];
    
    if (btn!=nil) {
        
        [btn setMultipleTouchEnabled:YES];
        
    } 
}

#pragma mark - View lifecycle
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    search.showsCancelButton = YES;
    
    [search setPlaceholder:kColOne];
    
    self.navigationController.navigationBarHidden = NO;
    
    [voasTableView setUserInteractionEnabled:YES];
    
    if (isiPhone) {
        if (kIsLandscapeTest) {
            [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
        } else {
            [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }
    }else {
        if (kIsLandscapeTest) {
            [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
        } else {
            [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
    }
    
	[search setHidden:YES];
    
	
    
	NSArray *favViews = [VOAFav findCollect];

	[favArray removeAllObjects];
    
	for (id fav in favViews) {
        
		[favArray addObject:fav];
        
	}
    
	[self.voasTableView reloadData];
    
	[favViews release], favViews = nil;
    
//    kLandscapeTest;
    [voasTableView reloadData];
}

- (void)viewRorateResize {
//    int commCellNum = [favArray count];
//    if (isiPhone) {
//        
//        if (kIsLandscapeTest) {
//            if (self.navigationController.navigationBarHidden) {
//                //                NSLog(@"nav隐藏");
//                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
//                [voasTableView setFrame:CGRectMake(0, 44, kScreenHeight, (commCellNum*165 < 220? commCellNum*165: 220))];
//            } else {
//                //                NSLog(@"nav显示");
//                if (kPlayerIsExist) {
//                    //                    NSLog(@"特殊");
//                    [voasTableView setFrame:CGRectMake(0, 30, kScreenHeight, (commCellNum*165 < 220? commCellNum*165: 220))];
//                } else {
//                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, (commCellNum*165 < 220? commCellNum*165: 220))];
//                }
//            }
//        } else {
//            if (self.navigationController.navigationBarHidden) {
//                [search setFrame:CGRectMake(0, 0, 320, 44)];
//                [voasTableView setFrame:CGRectMake(0, 44, 320, (commCellNum*110 < 372? commCellNum*110: 372))];
//            } else {
//                if (kPlayerIsExist) {
//                    //                    NSLog(@"特殊");
//                    [voasTableView setFrame:CGRectMake(0, 44, 320, (commCellNum*110 < 372? commCellNum*110: 372))];
//                } else {
//                    [voasTableView setFrame:CGRectMake(0, 0, 320, (commCellNum*110 < 372? commCellNum*110: 372))];
//                }
//                //                [voasTableView setFrame:CGRectMake(0, 0, 320, 372)];
//            }
//        }
//    } else {
//        if (kIsLandscapeTest) {
//            if (self.navigationController.navigationBarHidden) {
//                [search setFrame:CGRectMake(0, 0, 1024, 44)];
//                [voasTableView setFrame:CGRectMake(0, 44, 1024, (commCellNum*280 < 668? commCellNum*280: 668))];
//            } else {
//                if (kPlayerIsExist) {
//                    //                    NSLog(@"特殊");
//                    [voasTableView setFrame:CGRectMake(0, 44, 1024, (commCellNum*280 < 668? commCellNum*280: 668))];
//                } else {
//                    [voasTableView setFrame:CGRectMake(0, 0, 1024, (commCellNum*280 < 668? commCellNum*280: 668))];
//                }
//            }
//        } else {
//            if (self.navigationController.navigationBarHidden) {
//                [search setFrame:CGRectMake(0, 0, 768, 44)];
//                [voasTableView setFrame:CGRectMake(0, 44, 768, (commCellNum*210 < 916? commCellNum*210: 916))];
//            } else {
//                if (kPlayerIsExist) {
//                    //                    NSLog(@"特殊");
//                    [voasTableView setFrame:CGRectMake(0, 40, 768, (commCellNum*210 < 916? commCellNum*210: 916))];
//                } else {
//                    [voasTableView setFrame:CGRectMake(0, 0, 768, (commCellNum*210 < 916? commCellNum*210: 916))];
//                }
//                //                [voasTableView setFrame:CGRectMake(0, 0, 768, 916)];
//            }
//        }
//    }
    if (isiPhone) {
        if (kIsLandscapeTest) {
            if (self.navigationController.navigationBarHidden) {
//                NSLog(@"nav隐藏");
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, kScreenHeight, kViewHeight)];
            } else {
//                NSLog(@"nav显示");
//                if (kPlayerIsExist) {
//                    [voasTableView setFrame:CGRectMake(0, 30, kScreenHeight, 220)];
//                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
//                }
            }
        } else {
            if (self.navigationController.navigationBarHidden) {
                [search setFrame:CGRectMake(0, 0, 320, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, 320, kViewHeight)];
            } else {
//                if (kPlayerIsExist) {
//                    [voasTableView setFrame:CGRectMake(0, 44, 320, 372)];
//                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
//                }
                
            }
        }
    } else {
        if (kIsLandscapeTest) {
            if (self.navigationController.navigationBarHidden) {
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, 1024, kViewHeight)];
            } else {
                [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
            }
        } else {
            if (self.navigationController.navigationBarHidden) {
                [search setFrame:CGRectMake(0, 0, 768, 44)];
                [voasTableView setFrame:CGRectMake(0, 44, 768, kViewHeight)];
            } else {
                [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            }
        }
    }
    [voasTableView reloadData];
}

- (void)viewDidLoad
{
    isiPhone = ![Constants isPad];
    
    search = [[UISearchBar alloc] init];
    
    search.delegate = self;
    
//    search.backgroundImage = [UIImage imageNamed:@"searchbg-ipad.png"];
    
    search.backgroundColor = [UIColor clearColor];
    
    [search setTintColor:[UIColor colorWithRed:1.0/255 green:151.0/255 blue:211.0/255 alpha:1]];
//    [search setTintColor:[UIColor colorWithRed:0.863f green:0.957f blue:0.827f alpha:1.0f]];
//    [search setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title.png"]]];

    [self.view addSubview:search];
    
    [search release];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(doSearch)];
    
	self.navigationItem.leftBarButtonItem = searchButton;
    
    [searchButton release], searchButton = nil;
    
    self.navigationController.navigationBarHidden = NO;
    
    self.title = kColTwo;
    
    favArray = [[NSMutableArray alloc] init];
    
    voasTableView.delegate = self;
    
	voasTableView.dataSource = self;
	
	UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:kSearchTwo style:UIBarButtonItemStylePlain target:self action:@selector(doEdit)];
    
	self.navigationItem.rightBarButtonItem = editButton;
    
    [editButton release], editButton = nil;
    
//	NSLog(@"storeArray: %@",favArray);
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.voasTableView = nil;
    
    [super viewDidUnload];
    
}

- (void)dealloc
{
    [self.voasTableView release], voasTableView = nil;
    [self.favArray release], favArray = nil;
    //    [favArray release];
    //    [search release];
    //    [HUD release];
    //    [self.voasArray release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    kLandscapeTest;
//    [voasTableView reloadData];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    kLandscapeTest;
    [voasTableView reloadData];
    [self viewRorateResize];
//    if (kIsLandscapeTest) {
//        if (self.navigationController.navigationBarHidden) {
//            if (isiPhone) {
//                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
//            } else {
//                [search setFrame:CGRectMake(0, 0, 1024, 44)];
//            }
//        }
//    } else if (self.navigationController.navigationBarHidden) {
//        if (isiPhone) {
//            [search setFrame:CGRectMake(0, 0, 320, 44)];
//        } else {
//            [search setFrame:CGRectMake(0, 0, 768, 44)];
//        }
//        
//    }
}

- (void) doEdit{
	
	[voasTableView setEditing:!voasTableView.editing animated:YES];
    
	if(voasTableView.editing)
        
		self.navigationItem.rightBarButtonItem.title = kSearchOne;

	else
        
		self.navigationItem.rightBarButtonItem.title = kSearchTwo;
}


#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
    return [favArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *FirstLevelCell= @"CollectCell";
    
    VoaViewCell *cell = (VoaViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
	
    if (!cell) {
        //            NSLog(@"新建cell");
        if (isiPhone) {
            
            if (kIsLandscapeTest) {
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCellLS"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            } else {
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            }
            
        }else {
            if (kIsLandscapeTest) {
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCellLS-iPad"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            } else {
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell-iPad"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            }
            
        }
    }
    
//	if (!cell) {
//
//		if (isiPhone) {
//            if (kIsLandscapeTest) {
//                if (self.navigationController.navigationBarHidden) {
//                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
//                    [voasTableView setFrame:CGRectMake(0, 44, kScreenHeight, 220)];
//                } else {
//                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, 220)];
//                }
//                
//                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCellLS"
//                                                                    owner:self
//                                                                  options:nil] objectAtIndex:0];
//            } else {
//                if (self.navigationController.navigationBarHidden) {
//                    [search setFrame:CGRectMake(0, 0, 320, 44)];
//                    [voasTableView setFrame:CGRectMake(0, 44, 320, 372)];
//                } else {
//                    [voasTableView setFrame:CGRectMake(0, 0, 320, 372)];
//                }
//                
//                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell"
//                                                                    owner:self
//                                                                  options:nil] objectAtIndex:0];
//            }
//        }else {
//            cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell-iPad"
//                                                                owner:self 
//                                                              options:nil] objectAtIndex:0];
//        }
//	}
    NSUInteger row = [indexPath row];
    
    VOAFav *fav = [favArray objectAtIndex:row];
    
    VOAView *voa = [VOAView find:fav._voaid];

    cell.myTitle.text = voa._title;
    
    cell.myDate.text = voa._creatTime;
    
    cell.collectDate.text = fav._date;
    
    [cell.collectDate setHidden:NO];
    
    //--------->设置内容换行
    [cell.myTitle setLineBreakMode:UILineBreakModeClip];
    
    //--------->设置最大行数
    [cell.myTitle setNumberOfLines:3];
    
    NSURL *url = [NSURL URLWithString: voa._pic];
    
    [cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesceBBC.png"]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (voa._hotFlg.integerValue == 1) {

        [cell.hotImg setHidden:NO];
        
//        NSLog(@"hot:1");
    }
    [voa release];
    return cell;
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kIsLandscapeTest) {
        return (isiPhone?165.0f:280.0f);
    }
    return (isiPhone?110.0f:210.0f);
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{	
    VOAFav *fav = [favArray objectAtIndex:indexPath.row];
    
    NSFileManager *deleteFile = [NSFileManager defaultManager];
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];
    
    NSString *userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4", fav._voaid]];
    
//    NSLog(@"yunsi:%@",userPath);
    
    NSError *error = nil;
    
	if ([deleteFile removeItemAtPath:userPath error:&error]) {
//		NSLog(@"delete succeed");
        PlayerViewController *player = [PlayerViewController sharedPlayer];
//        if (player.playMode == 3) {
            player.flushList = YES;
//        }
	}
	
	[VOAFav deleteCollect:[fav _voaid]];
    
	[favArray removeObjectAtIndex:indexPath.row];
    
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (search.isFirstResponder) {
        
        [search resignFirstResponder];
        
        NSString *searchWords =  [search text];
        
        if (searchWords.length == 0) {
        }else
        {
            self.navigationController.navigationBarHidden = NO;
            
            if (isiPhone) {
                //                UIDevice *device = [UIDevice currentDevice] ;
                if (kIsLandscapeTest) {
                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 320, 44)];
                }
                
            }else {
                if (kIsLandscapeTest) {
                    [search setFrame:CGRectMake(0, 0, 1024, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
                } else {
                    [search setFrame:CGRectMake(0, 0, 768, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                }
            }
            
            
            [search setHidden:YES];
            
            NSMutableArray *allVoaArray = favArray;
            
            NSMutableArray *contentsArray = nil;
            
            contentsArray = [VOAView findFavSimilar:allVoaArray search:searchWords];
            
//            NSLog(@"count:%d", [contentsArray count]);
            
            if ([contentsArray count] == 0) {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kColFour message:[NSString stringWithFormat:@"%@%@%@",kSearchThree,searchWords,kColThree] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil ];
                
                [alert show];
                
                [alert release];
                
                [contentsArray release];
                
            }else
            {
                search.text = @"";
                
                SearchViewController *searchController = [SearchViewController alloc];
                
                searchController.searchWords = searchWords;
                
                searchController.contentsArray = contentsArray;
                
                searchController.contentMode = 2;
                
                searchController.searchFlg = 111;
                
                [contentsArray release];
                
                [self.navigationController pushViewController:searchController animated:YES];
                
                 [searchController release], searchController = nil;
            }
        }
    }else{
        if (!search.isHidden) {
            
            self.navigationController.navigationBarHidden = NO;
            
            if (isiPhone) {
                //                UIDevice *device = [UIDevice currentDevice] ;
                if (kIsLandscapeTest) {
                    [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                } else {
                    [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 320, 44)];
                }
            }else {
                if (kIsLandscapeTest) {
                    [search setFrame:CGRectMake(0, 0, 1024, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
                } else {
                    [search setFrame:CGRectMake(0, 0, 768, 44)];
                    [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                }
            }
            
            
            [search setHidden:YES];
            
            search.text = @"";
        }else{
            
            NSUInteger row = [indexPath row];
            
            VOAFav *fav = [favArray objectAtIndex:row];
            
            HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
            
            HUD.dimBackground = YES;
            
            HUD.labelText = @"Loading!";
            
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
                
                dispatch_async(dispatch_get_main_queue(), ^{  
                    VOAView *voa = [VOAView find:fav._voaid];
                    PlayerViewController *play = [PlayerViewController sharedPlayer];//新建新界面的controller实例
                    if(play.voa._voaid == voa._voaid)
                    {
                        play.newFile = NO;
                    }else
                    {
                        play.newFile = YES;
                        play.voa = voa;
                    }
                    [voa release];
                    [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
                    if (play.contentMode != 2) {
                        play.flushList = YES;
                        play.contentMode = 2;
                    }
                    [self.navigationController pushViewController:play animated:NO];
                    [HUD hide:YES];
                });  
            }); 
            
        }
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [search resignFirstResponder];
    NSString *searchWords =  [search text];
    if (searchWords.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kColFour message:kColFive delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil, nil ];
        [alert show];
        [alert release];
    }else
    {
        self.navigationController.navigationBarHidden = NO;
        
        if (isiPhone) {
            //            UIDevice *device = [UIDevice currentDevice] ;
            if (kIsLandscapeTest) {
                [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            } else {
                [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }
        }else {
            if (kIsLandscapeTest) {
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
            } else {
                [search setFrame:CGRectMake(0, 0, 768, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            }
        }
        [search setHidden:YES];
        NSMutableArray *allVoaArray = favArray;
        
        HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
        HUD.dimBackground = YES;
        HUD.labelText = @"Loading!";
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
            
            dispatch_async(dispatch_get_main_queue(), ^{  
                NSMutableArray *contentsArray = nil;
                contentsArray = [VOAView findFavSimilar:allVoaArray search:searchWords];
//                NSLog(@"count:%d", [contentsArray count]);
                
                if ([contentsArray count] == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kColFour message:[NSString stringWithFormat:@"%@%@%@",kSearchThree,searchWords,kColThree] delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil, nil ];
                    [alert show];
                    [alert release];
                    [contentsArray release];
                }else
                {
                    search.text = @"";
                    SearchViewController *searchController = [SearchViewController alloc];
                    searchController.searchWords = searchWords;
                    searchController.contentsArray = contentsArray;
                    searchController.contentMode = 2;
                    [contentsArray release];
                    searchController.searchFlg = 111;
                    [self.navigationController pushViewController:searchController animated:YES];
                    [searchController release], searchController = nil;
                }
                [HUD hide:YES];
            });  
        }); 
    }
}
    
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    if (isiPhone) {
        //        UIDevice *device = [UIDevice currentDevice] ;
        if (kIsLandscapeTest) {
            [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
        } else {
            [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }
    }else {
        if (kIsLandscapeTest) {
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
            [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
        } else {
            [search setFrame:CGRectMake(0, 0, 768, 44)];
            [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
        }
    }
    [search setHidden:YES];
    search.text = @"";
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!search.isHidden) {
        self.navigationController.navigationBarHidden = NO;
        
        if (isiPhone) {
            //            UIDevice *device = [UIDevice currentDevice] ;
            if (kIsLandscapeTest) {
                [voasTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            } else {
                [voasTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }
        }else {
            if (kIsLandscapeTest) {
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
            } else {
                [search setFrame:CGRectMake(0, 0, 768, 44)];
                [voasTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            }
        }
        [search setHidden:YES];
        search.text = @"";
    }
}

@end
