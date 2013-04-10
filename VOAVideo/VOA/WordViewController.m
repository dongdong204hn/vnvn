//
//  WordViewController.m
//  VOA
//
//  Created by song zhao on 12-2-6.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "WordViewController.h"

@implementation WordViewController

@synthesize wordsTableView;
@synthesize wordPlayerTwo;
@synthesize wordsArray;
@synthesize myWord;
@synthesize isCellPlay;
@synthesize nowUserId;
@synthesize flg;
@synthesize isiPhone;
@synthesize search;
@synthesize explainView;
//@synthesize HUD;
//@synthesize wordFrame;
@synthesize alert;
//@synthesize isExisitNet;
@synthesize sharedSingleQueue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

- (NSOperationQueue *)sharedQueue
{
//    static NSOperationQueue *sharedSingleQueue;
    
    @synchronized(self)
    {
        if (!sharedSingleQueue){
            sharedSingleQueue = [[NSOperationQueue alloc] init];
            [sharedSingleQueue setMaxConcurrentOperationCount:1];
        }
        return sharedSingleQueue;
    }
}

- (void) playDef:(UIButton *)sender
{
    if (search.isFirstResponder) {
        [search resignFirstResponder];
        NSString *searchWords =  [search text];
        if (searchWords.length == 0) {
        }else
        {
            self.navigationController.navigationBarHidden = NO;
            [self.view endEditing:YES];
            if (isiPhone) {
                if (kIsLandscapeTest) {
                    [wordsTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                } else {
                    [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 320, 44)];
                }
//                [wordsTableView setFrame:CGRectMake(0, 0, 320, 372)];
//                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }else {
                if (kIsLandscapeTest) {
                    [wordsTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 1024, 44)];
                } else {
                    [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 768, 44)];
                }
//                [wordsTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
            
            [search setHidden:YES];
            [self catchWords:searchWords];
        }    
    }else{
        if (!search.isHidden) {
            self.navigationController.navigationBarHidden = NO;
            if (isiPhone) {
                if (kIsLandscapeTest) {
                    [wordsTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                } else {
                    [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 320, 44)];
                }
//                [wordsTableView setFrame:CGRectMake(0, 0, 320, 372)];
//                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }else {
                if (kIsLandscapeTest) {
                    [wordsTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 1024, 44)];
                } else {
                    [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 768, 44)];
                }
//                [wordsTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
            [search setHidden:YES];
            search.text = @"";
        }else{
            if (![explainView isHidden]) {
                [explainView setHidden:YES];
                return;
            }
            
            if (wordPlayerTwo) {
                [wordPlayerTwo release];
            }
            VOAWord *nowWord = [VOAWord findById:sender.tag userId:nowUserId];
            wordPlayerTwo =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:nowWord.audio]];
            [wordPlayerTwo play];
            
            UIFont *Courier = [UIFont fontWithName:@"Courier" size:15];
            if ([sender.titleLabel.text isEqualToString:kWordOne]) {
                [sender.titleLabel setFont :Courier];
                [sender setBackgroundColor:[UIColor clearColor]];
                [sender.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
                [sender.titleLabel setNumberOfLines:3];
                [sender setTitle:[VOAWord findById:sender.tag userId:nowUserId].def forState:UIControlStateNormal];
                [VOAWord addCheck:sender.tag userId:nowUserId];    
            }
        }
    }
}

- (void) playWord:(UIButton *)sender
{
    if (wordPlayerTwo) {
        [wordPlayerTwo release];
    }
    VOAWord *nowWord = [wordsArray objectAtIndex:sender.tag];
    wordPlayerTwo =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:nowWord.audio]];
    [wordPlayerTwo play];
//    NSLog(@"play word");
}

- (void) playWordTwo:(UIButton *)sender
{
    if (wordPlayerTwo) {
        [wordPlayerTwo release];
    }
    wordPlayerTwo =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:myWord.audio]];
    [wordPlayerTwo play];
//    NSLog(@"play word");
}


- (void)doSeg:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        if (nowUserId>0) {
            [self catchAllByPageNumber:1];
        }else
        {
            LogController *myLog = [[LogController alloc]init];
            [myLog setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myLog animated:YES];
            [myLog release], myLog = nil;
        }
    }else
    {
        [wordsTableView setEditing:!wordsTableView.editing animated:YES];
        if(wordsTableView.editing)
            [sender setTitle:kSearchOne forSegmentAtIndex:1];
        else
            [sender setTitle:kSearchTwo forSegmentAtIndex:1];
    }
}

- (void) addWordPressed:(UIButton *)sender
{
//    NSLog(@"生词本添加用户：%d",nowUserId);
    if (nowUserId>0) {
//        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定添加" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消",nil];
//        [addAlert setTag:2];
//        [addAlert show];
        myWord.userId = nowUserId;
        if ([myWord alterCollect]) {
            alert = [[UIAlertView alloc] initWithTitle:kWordTwo message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            
            [alert setBackgroundColor:[UIColor clearColor]];
            
            [alert setContentMode:UIViewContentModeScaleAspectFit];
            
            [alert show];
            
            NSTimer *timer = nil;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(c) userInfo:nil repeats:NO];
        }
        if (myWord.flag != -1) {
            NSArray *words = [VOAWord findWords:nowUserId];
            [wordsArray removeAllObjects];
            for (VOAWord *fav in words) {
                [wordsArray addObject:fav];
            }
            [self.wordsTableView reloadData];
            [self catchAsFlg:myWord.wordId mode:@"insert"];
        }
        
    }else
    {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:kColFour message:kWordThree delegate:self cancelButtonTitle:kWordFour otherButtonTitles:nil ,nil];
        [addAlert setTag:3];
        [addAlert show];
    }
}

-(void)c
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
}

- (void) doEdit{
	[wordsTableView setEditing:!wordsTableView.editing animated:YES];
	if(wordsTableView.editing)
		self.navigationItem.rightBarButtonItem.title = kSearchOne;
	else
		self.navigationItem.rightBarButtonItem.title = kSearchTwo;
}

- (void)modalView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//点击确定下载为0，取消为1
//        if (alertView.tag == 2) {
//            [myWord alterCollect];
//            NSArray *words = [[NSArray alloc] init];
////            NSLog(@"添加生词到:%d",nowUserId);
//            words = [VOAWord findWords:nowUserId];
//            [wordsArray removeAllObjects];
//            for (id fav in words) {
//                [wordsArray addObject:fav];
//            }
//            [self.wordsTableView reloadData];
//            [words release], words = nil;
//        }else if (alertView.tag == 3)
//        {
            LogController *myLog = [[LogController alloc]init];
            [self.navigationController pushViewController:myLog animated:YES];
         [myLog release], myLog = nil;
//        }
    }
    [alertView release];
}

- (void)doYun
{
    LogController *myLog = [[LogController alloc]init];
    [self presentModalViewController:myLog animated:YES];  
    [myLog release], myLog = nil;
}

- (void)doSearch
{
    self.navigationController.navigationBarHidden = YES;
    [search setText:@""];
    if (isiPhone) {
        if (kIsLandscapeTest) {
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            [wordsTableView setFrame:CGRectMake(0, 44, kScreenHeight, kViewHeight)];
        } else {
            [search setFrame:CGRectMake(0, 0, 320, 44)];
            [wordsTableView setFrame:CGRectMake(0, 44, 320, kViewHeight)];
        }
//        [search setFrame:CGRectMake(0, 0, 320, 44)];
//        [wordsTableView setFrame:CGRectMake(0, 44, 320, 372)];
    }else {
        if (kIsLandscapeTest) {
            [wordsTableView setFrame:CGRectMake(0, 44, 1024, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
        } else {
            [wordsTableView setFrame:CGRectMake(0, 44, 768, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
//        [search setFrame:CGRectMake(0, 0, 768, 44)];
//        [wordsTableView setFrame:CGRectMake(0, 44, 768, 916)];
    }
    [search setHidden:NO];
}

- (void)wordExistNetDisplay {
    for (UIView *sView in [explainView subviews]) {
        if (![sView isKindOfClass:[UIImageView class]]) {
            [sView removeFromSuperview];
        }
    }
    NSString *totalString = [[NSString alloc] init];
    int totalNum = 0;
    for (int i = 0; i<myWord.engArray.count; i++) {
        //        NSLog(@"retain1: %i", [totalString retainCount]);
        totalString = [totalString stringByAppendingFormat:@"%d:%@\n%@\n",i+1,[myWord.engArray objectAtIndex:i],[myWord.chnArray objectAtIndex:i]];
        //        NSLog(@"retain2: %i", [totalString retainCount]);
        //        totalNum += ([[myWord.engArray objectAtIndex:i] length]+2)/34 + 2 + [[myWord.chnArray objectAtIndex:i] length]/34;
    }
    
    UIFont *Courier = [UIFont fontWithName:@"Courier" size:15];
    
    float cnHight = [@"赵" sizeWithFont:Courier].height;
    totalNum = [totalString sizeWithFont:Courier constrainedToSize:CGSizeMake(self.view.frame.size.width-30, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / cnHight + 1;
    
    NSInteger lines = myWord.def.length/23+1;
    
    
    [explainView setFrame:CGRectMake(15, 15, self.view.frame.size.width-30, 40+lines*20+totalNum*20)];
    explainView.layer.cornerRadius = 10.0;
    //    [wordFrame setFrame:CGRectMake(0, 0, explainView.frame.size.width, explainView.frame.size.height)];
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    if (isiPhone) {
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
    } else {
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
    }
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(3, 3, 35, 35)];
    [explainView addSubview:addButton];
    
    UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, [myWord.key sizeWithFont:Courier].width+10, 20)];
    [wordLabel setFont :Courier];
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    wordLabel.text = myWord.key;
    [wordLabel setTextColor:[UIColor blackColor]];
    wordLabel.backgroundColor = [UIColor clearColor];
    [explainView addSubview:wordLabel];
    [wordLabel release];
    
    UILabel *pronLabel = [[UILabel alloc]initWithFrame:CGRectMake(50+[myWord.key sizeWithFont:Courier].width, 10, [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width+10, 20)];
    [pronLabel setFont :Courier];
    [pronLabel setTextAlignment:UITextAlignmentCenter];
    if ( [myWord.pron isEqualToString:@" "]) {
        pronLabel.text = @"";
    }else
    {
        pronLabel.text = [NSString stringWithFormat:@"[%@]", myWord.pron];
    }
    [pronLabel setTextColor:[UIColor blackColor]];
    pronLabel.backgroundColor = [UIColor clearColor];
    [explainView addSubview:pronLabel];
    [pronLabel release];
    
    if (wordPlayerTwo) {
        [wordPlayerTwo release];
    }
    wordPlayerTwo =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:myWord.audio]];
    [wordPlayerTwo play];
    
    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [audioButton setImage:[UIImage imageNamed:@"wordSound.png"] forState:UIControlStateNormal];
    [audioButton addTarget:self action:@selector(playWordTwo:) forControlEvents:UIControlEventTouchUpInside];
    [audioButton setFrame:CGRectMake(60+[myWord.key sizeWithFont:Courier].width + [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width, 5, 30, 30)];
    [explainView addSubview:audioButton];
    
    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, explainView.frame.size.width, lines*20)];
    [defLabel setFont :Courier];
    [defLabel setTextColor:[UIColor blackColor]];
    defLabel.backgroundColor = [UIColor clearColor];
    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
    [defLabel setNumberOfLines:lines];
    defLabel.text = myWord.def;
    [explainView addSubview:defLabel];
    [defLabel release];
    
    UILabel *dictLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40+lines*20, explainView.frame.size.width, totalNum*20)];
    [dictLabel setFont :Courier];
    [dictLabel setTextColor:[UIColor blackColor]];
    dictLabel.backgroundColor = [UIColor clearColor];
    [dictLabel setLineBreakMode:UILineBreakModeWordWrap];
    [dictLabel setNumberOfLines:totalNum];
    //    NSLog(@"retain3: %i", [totalString retainCount]);
    [dictLabel setText: totalString];
    [explainView addSubview:dictLabel];
    [dictLabel release];
    //    NSLog(@"retain4: %i totalString:%@", [totalString retainCount], totalString);
    
    //    [explainView setAlpha:1];
    [self.view addSubview:explainView];
    [explainView setHidden:NO];
}

- (void)wordNoDisplay {
    myWord.audio = @"";
    myWord.pron = @" ";
    myWord.def = @"";
    
    for (UIView *sView in [explainView subviews]) {
        if (![sView isKindOfClass:[UIImageView class]]) {
            [sView removeFromSuperview];
        }
    }
    
    UIFont *Courier = [UIFont fontWithName:@"Courier" size:15];
    [explainView setFrame:CGRectMake(15, 440-35, self.view.frame.size.width-30, 35+19)];
    explainView.layer.cornerRadius = 10.0;
    //    [wordFrame setFrame:CGRectMake(0, 0, explainView.frame.size.width, explainView.frame.size.height)];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    if (isiPhone) {
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
    } else {
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
    }
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(10, 3, 30, 30)];
    [explainView addSubview:addButton];
    
    UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 3, [myWord.key sizeWithFont:Courier].width+10, 30)];
    [wordLabel setFont :Courier];
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    wordLabel.text = myWord.key;
    wordLabel.backgroundColor = [UIColor clearColor];
    [wordLabel setTextColor:[UIColor blackColor]];
    [explainView addSubview:wordLabel];
    [wordLabel release];
    
    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, 19)];
    [defLabel setFont :Courier];
    defLabel.backgroundColor = [UIColor clearColor];
    [defLabel setTextColor:[UIColor blackColor]];
    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
    [defLabel setNumberOfLines:1];
    defLabel.text = kWordEight;
    //                    NSLog(@"无查找结果!");
    [explainView addSubview:defLabel];
    [defLabel release];
    
    //    [explainView setAlpha:1];
    [self.view addSubview:explainView];
    [explainView setHidden:NO];
}


#pragma mark - View lifecycle
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    kNetTest;
//    [self catchNetA];
    nowUserId = 0;
    nowUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
    [explainView setHidden:YES];
    search.showsCancelButton = YES;
    [search setPlaceholder:kWordFive];
    if (isiPhone) {
//        [wordsTableView setFrame:CGRectMake(0, 0, 320, 372)];
//        [search setFrame:CGRectMake(0, 0, 320, 44)];
        if (kIsLandscapeTest) {
            [wordsTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
        } else {
            [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }
    }else {
        if (kIsLandscapeTest) {
            [wordsTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
        } else {
            [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 768, 44)];
//        [wordsTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//        [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
    }
    self.navigationController.navigationBarHidden = NO;
	[search setHidden:YES];
    //    NSArray *delWords = [[NSArray alloc] init];
    NSArray *delWords = [VOAWord findDelWords:nowUserId];//$$$
    for (VOAWord *fav in delWords) {
//        NSLog(@"删除:%@",fav.key);
		[self catchAsFlg:fav.wordId mode:@"delete"];
	}
    [delWords release],delWords = nil;
	NSArray *words = [VOAWord findWords:nowUserId];
	[wordsArray removeAllObjects];
	for (VOAWord *fav in words) {
		[wordsArray addObject:fav];
        if (fav.flag == 1) {
            //        NSLog(@"insert");
            [self catchAsFlg:fav.wordId mode:@"insert"];
        }
	}
	[self.wordsTableView reloadData];
	[words release], words = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isiPhone = ![Constants isPad];
    explainView = [[MyLabel alloc]init];
    explainView.tag = 2000;
    explainView.delegate = self;
//    wordFrame = [[UIImageView alloc]init];
//    [wordFrame setImage:[UIImage imageNamed:@"wordFrame.png"]];
//    [explainView addSubview:wordFrame];
    
//    [explainView setBackgroundColor:[UIColor colorWithRed:0.8 green:0.8 blue:1 alpha:1]];
//    [explainView setBackgroundColor:[UIColor colorWithRed:0.29f green:0.459f blue:0.271f alpha:1]];
    [explainView setBackgroundColor:[UIColor colorWithRed:217.0/255 green:241.0/255 blue:253.0/255 alpha:1]];
    [explainView setAlpha:0.8f];
    [explainView setHidden:YES];
    myWord = [[VOAWord alloc]init];
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
    
    UISegmentedControl *segmentedControl=[[UISegmentedControl alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 30.0f) ];
    [segmentedControl insertSegmentWithTitle:kWordNine atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:kSearchTwo atIndex:1 animated:YES];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.momentary = YES;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(doSeg:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *segButton = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    [segmentedControl release], segmentedControl = nil;
    
    self.navigationItem.rightBarButtonItem = segButton;
    [segButton release], segButton = nil;
    
    self.navigationController.navigationBarHidden = NO;
    self.title = kWordSix;
    wordsArray = [[NSMutableArray alloc] init];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    self.wordsTableView.delegate = nil;
    self.wordsTableView.dataSource = nil;
    self.wordsTableView = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    kLandscapeTest;
    if (kIsLandscapeTest) {
        if (self.navigationController.navigationBarHidden) {
            if (isiPhone) {
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            } else {
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
            }
        }
    } else if (self.navigationController.navigationBarHidden) {
        if (isiPhone) {
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        } else {
            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
        
    }
}


- (void)dealloc {
    [self.wordPlayerTwo release], wordPlayerTwo = nil;
    [self.wordsTableView release], wordsTableView = nil;
    [self.explainView release], explainView = nil;
//    [self.wordFrame release], wordFrame = nil;
    [self.myWord release], myWord = nil;
    [self.wordsArray release], wordsArray = nil;
    [self.sharedSingleQueue release], sharedSingleQueue = nil;
    
    [super dealloc];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
    return [wordsArray count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *FirstLevelCell= @"WordCell";
    WordViewCell *cell = (WordViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
    if (!cell) {
        if (isiPhone) {
            
            cell = (WordViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"WordViewCell"
                                                                 owner:self 
                                                               options:nil] objectAtIndex:0];
        }else {
            cell = (WordViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"WordViewCell-iPad" 
                                                                 owner:self 
                                                               options:nil] objectAtIndex:0];
        }
    }
    UIFont *Courier = [UIFont fontWithName:@"Arial" size:15];
    UIFont *CourierTwo = [UIFont fontWithName:@"Arial" size:18];
    VOAWord *word = [wordsArray objectAtIndex:indexPath.row];
    [word addRemember];
//    [cell.keyLabel setFrame:CGRectMake(40, 3, [word.key sizeWithFont:CourierTwo].width+10, 25)];
    [cell.keyLabel setText:[word key]];
    [cell.keyLabel setFont:CourierTwo];
    if ([word.pron isEqualToString:@" "]) {
        cell.pronLabel.text = @"";
    }else
    {
        [cell.pronLabel setText:[NSString stringWithFormat:@"[%@]", word.pron]];
    }
    [cell.pronLabel setFont :Courier];
//    [cell.pronLabel setTextColor:[UIColor colorWithRed:0.482f green:0.596f blue:0.471f alpha:1.0f]];
//    [cell.pronLabel setFrame:CGRectMake(50+[word.key sizeWithFont:CourierTwo].width, 3, [word.pron sizeWithFont:CourierTwo].width+20, 25)];
//    [cell.audioButton setTitle:@"播" forState:UIControlStateNormal];
    [cell.audioButton setTag:indexPath.row];
    [cell.audioButton addTarget:self action:@selector(playWord:) forControlEvents:UIControlEventTouchUpInside];
    [cell.defButton.titleLabel setFont:Courier];
    [cell.defButton setTag:word.wordId];
    if ([word.def isEqualToString:@""]) {
        [cell.defButton setTitle:kWordSeven forState:UIControlStateNormal];
        [self catchAsWordDetails:word.wordId];
    }else
    {
        [cell.defButton setTitle:kWordOne forState:UIControlStateNormal];
    }
//    NSLog(@"flg:%d",word.flag);
    if (word.flag == 1) {
//        NSLog(@"insert");
        [self catchAsFlg:word.wordId mode:@"insert"];
    }
    [cell.defButton addTarget:self action:@selector(playDef:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.defButton.titleLabel setFont :Courier];
    [cell.defButton setBackgroundColor:[UIColor clearColor]];
    [cell.defButton.titleLabel setLineBreakMode:UILineBreakModeWordWrap];
    [cell.defButton.titleLabel setNumberOfLines:3];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
	return cell;

}

#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (isiPhone?85.0f:125.0f);
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{	
    VOAWord *word = [wordsArray objectAtIndex:indexPath.row];
	[VOAWord deleteWord:word.key userId:nowUserId];
    [self catchAsFlg:word.wordId mode:@"delete"];
	[wordsArray removeObjectAtIndex:indexPath.row];
	[wordsTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
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
    if (!search.isHidden) {
        self.navigationController.navigationBarHidden = NO;
        [self.view endEditing:YES];
        if (isiPhone) {
            if (kIsLandscapeTest) {
                [wordsTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            } else {
                [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }
//            [wordsTableView setFrame:CGRectMake(0, 0, 320, 372)];
//            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }else {
            if (kIsLandscapeTest) {
                [wordsTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
            } else {
                [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
//            [wordsTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
        [search setHidden:YES];
        search.text = @"";
    }
}

#pragma mark - Http connect
//- (void)catchNetA
//{
//    NSString *url = @"http://www.baidu.com";
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    //    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:@"catchnet"];
//    [request startAsynchronous];
//}

- (void)catchAsWordDetails:(NSInteger) wordId
{
//    NSLog(@"!!!!!!!_____________!!!!!!!!!!!");  
    VOAWord *nowWord = [VOAWord findById:wordId userId:nowUserId];
    if ([nowWord.def isEqualToString:@""]){
        //        NSLog(@"下载");       
        //        NSLog(@"Queue 预备: %d",wordId);
        NSOperationQueue *myQueue = [self sharedQueue];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://word.iyuba.com/words/apiWord.jsp?q=%@",nowWord.key]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        [request setDelegate:self];
        [request setUsername:nowWord.key];
        [request setTag:wordId];
        //        [request setDidStartSelector:@selector(requestMyStarted:)];
        [request setDidFinishSelector:@selector(requestDone:)];
        //        [request setDidFailSelector:@selector(requestWentWrong:)];
        [myQueue addOperation:request];
    }else
    {
        //        NSLog(@"%d,已经有了。",wordId);
    }
}

- (void)catchAsFlg:(NSInteger) wordId mode:(NSString *) mode
{
    //    NSLog(@"!!!!!!!_____________!!!!!!!!!!!");  
    VOAWord *nowWord = [VOAWord findById:wordId userId:nowUserId];
    //        NSLog(@"下载");       
    //        NSLog(@"Queue 预备: %d",wordId);
    NSOperationQueue *myQueue = [self sharedQueue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://word.iyuba.com/words/updateWord.jsp?userId=%d&mod=%@&groupName=Iyuba&word=%@", nowWord.userId,mode,nowWord.key]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setUsername:nowWord.key];
    if ([mode isEqualToString:@"insert"]) {
        [request setTag:0];
    }else{
        [request setTag:-1];
    }
    //        [request setDidStartSelector:@selector(requestMyStarted:)];
    [request setDidFinishSelector:@selector(requestDone:)];
    //        [request setDidFailSelector:@selector(requestWentWrong:)];
    [myQueue addOperation:request];
}

- (void)catchWords:(NSString *) word
{
    NSString *url = [NSString stringWithFormat:@"http://word.iyuba.com/words/apiWord.jsp?q=%@",word];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSOperationQueue *myQueue = [self sharedQueue];
    request.delegate = self;
    [request setUsername:word];
    [request setTag:0];
    //        [request setDidStartSelector:@selector(requestMyStarted:)];
    [request setDidFinishSelector:@selector(requestDoneTwo:)];
    [request setDidFailSelector:@selector(requestWentWrongTwo:)];
    [myQueue addOperation:request];
}

- (void)catchAllByPageNumber:(NSInteger) number 
{
    NSString *url = [NSString stringWithFormat:@"http://word.iyuba.com/words/wordListService.jsp?u=%d&pageNumber=%d&pageCounts=1000",nowUserId,number];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setTag:number];
    NSOperationQueue *myQueue = [self sharedQueue];
    request.delegate = self;
    //        [request setDidStartSelector:@selector(requestMyStarted:)];
    [request setDidFinishSelector:@selector(requestDoneTwo:)];
    [request setDidFailSelector:@selector(requestWentWrongTwo:)];
    [myQueue addOperation:request];
}

- (void)requestMyStarted:(ASIHTTPRequest *)request
{
    //        NSLog(@"Queue 开始: %d",request.tag);
}

- (void)requestDone:(ASIHTTPRequest *)request 
{
    kNetEnable;
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if (request.tag > 0) {
        NSArray *items = [doc nodesForXPath:@"data" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                NSString *key = [[obj elementForName:@"key"] stringValue];
                NSString *audio = [[obj elementForName:@"audio"] stringValue];
                NSString *pron = [[obj elementForName:@"pron"] stringValue];
                NSString *def = [[obj elementForName:@"def"] stringValue];
//                            NSLog(@"key:%@", key);
//                                NSLog(@"audio:%@", audio);
//                               NSLog(@"pron:%@", pron);
//                            NSLog(@"def:%@", def);
                [VOAWord updateBykey:key audio:audio pron:pron def:def userId:nowUserId];
            }
            
        }
//                NSLog(@"%d,圆满完成。",request.tag);
        NSArray *words = [VOAWord findWords:nowUserId];
        [wordsArray removeAllObjects];
        for (id fav in words) {
            [wordsArray addObject:fav];
        }
        [self.wordsTableView reloadData];
        [words release], words = nil;
    }else
    {
        NSArray *items = [doc nodesForXPath:@"response" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                NSInteger result= [[[obj elementForName:@"result"] stringValue] integerValue];
                NSString *word = [[obj elementForName:@"word"] stringValue];
                //                NSLog(@"result:%d", result);
                //                NSLog(@"word:%@", word);
                if (result==1) {
                    if (request.tag < 0) {
                        //                        NSLog(@"删除:%@",word);
                        [VOAWord deleteByKey:word userId:nowUserId];
                    }
                    else{
                        [VOAWord updateFlgByKey:request.username userId:nowUserId];
                    }
                }
            }
        }
        //        NSLog(@"%d:%@,圆满完成。",request.tag,request.username);        
    }
    [doc release],doc = nil;
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    kNetDisable;
}

- (void)requestWentWrongTwo:(ASIHTTPRequest *)request
{
    kNetDisable;
    if (request.tag == 0) {
        [myWord init];
        myWord.wordId = [VOAWord findLastId]+1;
        myWord.checks = 0;
        myWord.remember = 0;
        myWord.key = request.username;
        myWord.audio = @"";
        myWord.pron = @" ";
        myWord.def = @"";
        myWord.userId = nowUserId;
    }
    
}

- (void)requestDoneTwo:(ASIHTTPRequest *)request{
    kNetEnable;
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];;
    /////解析
    if (request.tag == 0) {
        //        NSLog(@"查词接收到了");
        [myWord init];
        int result = 0;
        NSArray *items = [doc nodesForXPath:@"data" error:nil];
        if (items) {
            //            NSLog(@"1");
            for (DDXMLElement *obj in items) {
                //                NSLog(@"2");
                NSMutableArray *eng = [[NSMutableArray alloc] init];
                NSMutableArray *chi = [[NSMutableArray alloc] init];
                myWord.wordId = [VOAWord findLastId]+1;
                myWord.checks = 0;
                myWord.remember = 0;
                myWord.userId = nowUserId;
                result = [[obj elementForName:@"result"] stringValue].intValue;
                if (result) {
                    //                    NSLog(@"3");
                    myWord.key = [[obj elementForName:@"key"] stringValue];
                    myWord.audio = [[obj elementForName:@"audio"] stringValue];
                    myWord.pron = [[obj elementForName:@"pron"] stringValue];
                    if (myWord.pron == nil) {
                        myWord.pron = @" ";
                    }
                    myWord.def = [[[obj elementForName:@"def"] stringValue] stringByReplacingOccurrencesOfRegex:@"\\s+" withString:@""];
                    NSArray *itemsOne = [doc nodesForXPath:@"data/sent" error:nil];
                    if (itemsOne) {
                        //                        NSLog(@"4");
                        for (DDXMLElement *objOne in itemsOne) {
                            NSString *orig = [[[[[objOne elementForName:@"orig"] stringValue]stringByReplacingOccurrencesOfString:@"<em>" withString:@""] stringByReplacingOccurrencesOfString:@"</em>" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            [eng addObject:orig];
                            NSString *trans = [[[objOne elementForName:@"trans"] stringValue] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                            [chi addObject:trans];
                            //                            NSLog(@"orig:%@", orig);
                            //                            NSLog(@"trans:%@", trans);
                        }
                    }
                    myWord.engArray = eng;
                    [eng release], eng = nil;
                    myWord.chnArray = chi;
                    [chi release], chi = nil;
                    [self wordExistNetDisplay];
                    
                }else
                {
                    //                    NSLog(@"5");
                    myWord.key = request.username;
                    [self wordNoDisplay];
                    
                }
                
            }
            
        }
    }else
    {
        //        NSLog(@"6");
        NSArray *items = [doc nodesForXPath:@"response/row" error:nil];
        NSInteger lastPage = 0;
        if (items) {
            for (DDXMLElement *obj in items) {
                lastPage = [[[obj elementForName:@"lastPage"] stringValue] integerValue];
                NSString *key = [[obj elementForName:@"Word"] stringValue];
                NSString *audio = [[obj elementForName:@"Audio"] stringValue];
                NSString *pron = [[obj elementForName:@"Pron"] stringValue];
                NSString *def = [[obj elementForName:@"Def"] stringValue];
                VOAWord *nowWord = [[VOAWord alloc] initWithVOAWord:([VOAWord findLastId]+1) key:key audio:audio pron:pron def:def date:nil checks:0 remember:0 userId:nowUserId flag:0];
                //                NSLog(@"初始化");
                [nowWord alterSynchroCollect];
                [nowWord release];
            }
        }
        if (lastPage <= request.tag) {
            //            NSLog(@"%d,同步圆满完成。",request.tag);
            [VOAWord deleteSynchro:nowUserId];
            NSArray *words = [VOAWord findWords:nowUserId];
            [wordsArray removeAllObjects];
            for (id fav in words) {
                [wordsArray addObject:fav];
            }
            [self.wordsTableView reloadData];
            [words release], words = nil;
            [VOAWord clearSynchro];
        }else
        {
            [self catchAllByPageNumber:request.tag+1];
        }
    }
    //    NSLog(@"7");
    [doc release], doc = nil;
}

- (void) requestFinished:(ASIHTTPRequest *)request
{
    kNetEnable;
    if ([request.username isEqualToString:@"catchnet"]) {
        //        NSLog(@"有网络");
//        isExisitNet = YES;
        return;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    kNetDisable;
    if ([request.username isEqualToString:@"catchnet"]) {
        //        NSLog(@"有网络");
//        isExisitNet = NO;
        return;
    }
}

#pragma mark -
#pragma mark UISearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    NSString *searchWords =  [searchBar text];
    if (searchWords.length == 0) {
        UIAlertView *alertOne = [[UIAlertView alloc] initWithTitle:kColFour message:[NSString stringWithFormat:kColFive,searchWords] delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil, nil ];
        [alertOne show];
        [alertOne release];
    }else
    {
        self.navigationController.navigationBarHidden = NO;
        if (isiPhone) {
            if (kIsLandscapeTest) {
                [wordsTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
            } else {
                [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }
//            [wordsTableView setFrame:CGRectMake(0, 0, 320, 372)];
//            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }else {
            if (kIsLandscapeTest) {
                [wordsTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 1024, 44)];
            } else {
                [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
//            [wordsTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
        [search setHidden:YES];
        LocalWord *word = [LocalWord findByKey:searchWords];
        myWord.wordId = [VOAWord findLastId] + 1;
        if (word && [[NSUserDefaults standardUserDefaults] boolForKey:kBePro]) {
            //            if (word) {
            myWord.wordId = [VOAWord findLastId] + 1;
            myWord.key = word.key;
            myWord.audio = word.audio;
            myWord.pron = [NSString stringWithFormat:@"%@",word.pron] ;
            if (myWord.pron == nil) {
                myWord.pron = @" ";
            }
            myWord.def = [[word.def stringByReplacingOccurrencesOfRegex:@"\\s+" withString:@""]stringByReplacingOccurrencesOfString:@"null" withString:@""];
            [word release];
            [self wordExistNetDisplay];
            //            }
        } else {
            kNetTest;
            if (kNetIsExist) {
                //            NSLog(@"有网");
                [self catchWords:searchWords];
            } else {
                myWord.key = searchWords;
                myWord.audio = @"";
                myWord.pron = @" ";
                myWord.def = @"";
                [self wordNoDisplay];
            }
        }
        
    }
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    self.navigationController.navigationBarHidden = NO;
    if (isiPhone) {
        if (kIsLandscapeTest) {
            [wordsTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
        } else {
            [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 320, 44)];
        }
//        [wordsTableView setFrame:CGRectMake(0, 0, 320, 372)];
//        [search setFrame:CGRectMake(0, 0, 320, 44)];
    }else {
        if (kIsLandscapeTest) {
            [wordsTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 1024, 44)];
        } else {
            [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
            [search setFrame:CGRectMake(0, 0, 768, 44)];
        }
//        [wordsTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//        [search setFrame:CGRectMake(0, 0, 768, 44)];
    }
    [search setHidden:YES];
    search.text = @"";
    
}

#pragma mark -
#pragma mark MyLabel Delegate Methods
- (void)touchUpInside: (NSSet *)touches mylabel:(MyLabel *)mylabel {
//    NSLog(@"2");
    if (search.isFirstResponder) {
        [search resignFirstResponder];
        NSString *searchWords =  [search text];
        if (searchWords.length == 0) {
        }else
        {
            self.navigationController.navigationBarHidden = NO;
            if (isiPhone) {
                [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }else {
                [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
            [search setHidden:YES];
            [self catchWords:searchWords];
        }    
    }else{
        if (!search.isHidden) {
            self.navigationController.navigationBarHidden = NO;
            if (isiPhone) {
                [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }else {
                [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
            [search setHidden:YES];
            search.text = @"";
        }else{
            if (![explainView isHidden]) {
                [explainView setHidden:YES];
                return;
            }
            if ([mylabel.text isEqualToString:kWordOne]) {
                [mylabel setText:[VOAWord findById:mylabel.tag userId:nowUserId].def];
                [VOAWord addCheck:mylabel.tag userId:nowUserId];    
            }
        }   
    }
}

- (void)touchUpInsideLong: (NSSet *)touches mylabel:(MyLabel *)mylabel {
    if (![explainView isHidden]) {
        [explainView setHidden:YES];
        return;
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (search.isFirstResponder) {
        [search resignFirstResponder];
        [self.view endEditing:YES];
    }else
    {
        if (![explainView isHidden]) {
            [explainView setHidden:YES];
        }
        if (!search.isHidden) {
            self.navigationController.navigationBarHidden = NO;
            if (isiPhone) {
                if (kIsLandscapeTest) {
                    [wordsTableView setFrame:CGRectMake(0, 0, kScreenHeight, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, kScreenHeight, 44)];
                } else {
                    [wordsTableView setFrame:CGRectMake(0, 0, 320, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 320, 44)];
                }
//                [wordsTableView setFrame:CGRectMake(0, 0, 320, 372)];
//                [search setFrame:CGRectMake(0, 0, 320, 44)];
            }else {
                if (kIsLandscapeTest) {
                    [wordsTableView setFrame:CGRectMake(0, 0, 1024, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 1024, 44)];
                } else {
                    [wordsTableView setFrame:CGRectMake(0, 0, 768, kViewHeight)];
                    [search setFrame:CGRectMake(0, 0, 768, 44)];
                }
//                [wordsTableView setFrame:CGRectMake(0, 0, 768, 372+544)];
//                [search setFrame:CGRectMake(0, 0, 768, 44)];
            }
            [search setHidden:YES];
            search.text = @"";
        }
    }
}

@end

//#pragma mark - Http connect
//- (void)catchAsWordDetails:(NSInteger) wordId
//{
////    NSLog(@"!!!!!!!_____________!!!!!!!!!!!");  
//    VOAWord *nowWord = [VOAWord findById:wordId userId:nowUserId];
//    if ([nowWord.def isEqualToString:@""]){
////        NSLog(@"下载");       
////        NSLog(@"Queue 预备: %d",wordId);
//        NSOperationQueue *myQueue = [self sharedQueue];
//        [myQueue setMaxConcurrentOperationCount:1];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://word.iyuba.com/words/apiWord.jsp?q=%@",nowWord.key]];
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//        [request setDelegate:self];
//        [request setUsername:nowWord.key];
//        [request setTag:wordId];
//        [request setDidStartSelector:@selector(requestMyStarted:)];
//        [request setDidFinishSelector:@selector(requestDone:)];
//        [request setDidFailSelector:@selector(requestWentWrong:)];
//        [myQueue addOperation:request];
//    }else
//    {
////        NSLog(@"%d,已经有了。",wordId);
//    }
//}
////
//- (void)catchAsFlg:(NSInteger) wordId mode:(NSString *) mode
//{
////    NSLog(@"!!!!!!!_____________!!!!!!!!!!!");  
//    VOAWord *nowWord = [VOAWord findById:wordId userId:nowUserId];
////        NSLog(@"下载");       
////        NSLog(@"Queue 预备: %d",wordId);
//        NSOperationQueue *myQueue = [self sharedQueue];
//        [myQueue setMaxConcurrentOperationCount:1];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://word.iyuba.com/words/updateWord.jsp?userId=%d&mod=%@&groupName=Iyuba&word=%@", nowWord.userId,mode,nowWord.key]];
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//        [request setDelegate:self];
//        [request setUsername:nowWord.key];
//    if ([mode isEqualToString:@"insert"]) {
//        [request setTag:0];
//    }else{
//        [request setTag:-1];
//    }
//        [request setDidStartSelector:@selector(requestMyStarted:)];
//        [request setDidFinishSelector:@selector(requestDone:)];
//        [request setDidFailSelector:@selector(requestWentWrong:)];
//        [myQueue addOperation:request];
//}
//
//- (void)catchWords:(NSString *) word
//{
//    NSString *url = [NSString stringWithFormat:@"http://word.iyuba.com/words/apiWord.jsp?q=%@",word];
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:word];
//    [request setTag:0];
//    [request startAsynchronous];
//}
//
//- (void)catchAllByPageNumber:(NSInteger) number 
//{
//    NSString *url = [NSString stringWithFormat:@"http://word.iyuba.com/words/wordListService.jsp?u=%d&pageNumber=%d&pageCounts=1000",nowUserId,number];
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setTag:number];
//    [request startAsynchronous];
//    //    NSLog(@"开始查词");
//}
//
//
//
//- (void)requestMyStarted:(ASIHTTPRequest *)request
//{
////        NSLog(@"Queue 开始: %d",request.tag);
//}
//
//- (void)requestDone:(ASIHTTPRequest *)request 
//{
//    NSData *myData = [request responseData];
//    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
//    if (request.tag > 0) {
//        NSArray *items = [doc nodesForXPath:@"data" error:nil];
//        if (items) {
//            for (DDXMLElement *obj in items) {
//                NSString *key = [[obj elementForName:@"key"] stringValue];
//                NSString *audio = [[obj elementForName:@"audio"] stringValue];
//                NSString *pron = [[obj elementForName:@"pron"] stringValue];
//                NSString *def = [[obj elementForName:@"def"] stringValue];
////                NSLog(@"key:%@", key);
////                NSLog(@"audio:%@", audio);
////                NSLog(@"pron:%@", pron);
////                NSLog(@"def:%@", def);
//                [VOAWord updateBykey:key audio:audio pron:pron def:def userId:nowUserId];
//            }
//            
//        }
////        NSLog(@"%d,圆满完成。",request.tag);
//        [doc release],doc = nil;
//        NSArray *words = [[NSArray alloc] init];
//        words = [VOAWord findWords:nowUserId];
//        [wordsArray removeAllObjects];
//        for (id fav in words) {
//            [wordsArray addObject:fav];
//        }
//        [self.wordsTableView reloadData];
//        [words release], words = nil;
//    }else
//    {
//        NSArray *items = [doc nodesForXPath:@"response" error:nil];
//        if (items) {
//            for (DDXMLElement *obj in items) {
//                NSInteger result= [[[obj elementForName:@"result"] stringValue] integerValue];
//                NSString *word = [[obj elementForName:@"word"] stringValue];
////                NSLog(@"result:%d", result);
////                NSLog(@"word:%@", word);
//                if (result==1) {
//                    if (request.tag < 0) {
////                        NSLog(@"删除:%@",word);
//                        [VOAWord deleteByKey:word userId:nowUserId];
//                    }
//                    else{
//                        [VOAWord updateFlgByKey:request.username userId:nowUserId];
//                    }
//                }
//            }
//        }
////        NSLog(@"%d:%@,圆满完成。",request.tag,request.username);        
//        [doc release],doc = nil;
//    }
//    
//}
//
//- (void)requestWentWrong:(ASIHTTPRequest *)request
//{
//}
//
//
//
//- (void)requestFailed:(ASIHTTPRequest *)request
//{
//    if (request.tag == 0) {
//        [myWord init];
//        myWord.wordId = [VOAWord findLastId]+1;
//        myWord.checks = 0;
//        myWord.remember = 0;
//        myWord.key = request.username;
//        myWord.audio = @"";
//        myWord.pron = @" ";
//        myWord.def = @"";
//        myWord.userId = nowUserId;
//    }
//    
//}
//
//
//- (void)requestFinished:(ASIHTTPRequest *)request{
//    NSData *myData = [request responseData];
//    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
//    /////解析
//    if (request.tag == 0) {
////        NSLog(@"查词接收到了");
//        [myWord init];
//        int result = 0;
//        NSArray *items = [doc nodesForXPath:@"data" error:nil];
//        if (items) {
////            NSLog(@"1");
//            for (DDXMLElement *obj in items) {
////                NSLog(@"2");
//                NSMutableArray *eng = [[NSMutableArray alloc] init];
//                NSMutableArray *chi = [[NSMutableArray alloc] init];
//                myWord.wordId = [VOAWord findLastId]+1;
//                myWord.checks = 0;
//                myWord.remember = 0;
//                myWord.userId = nowUserId;
//                result = [[obj elementForName:@"result"] stringValue].intValue;
//                if (result) {
////                    NSLog(@"3");
//                    myWord.key = [[obj elementForName:@"key"] stringValue];
//                    myWord.audio = [[obj elementForName:@"audio"] stringValue];
//                    myWord.pron = [[obj elementForName:@"pron"] stringValue];
//                    if (myWord.pron == nil) {
//                        myWord.pron = @" ";
//                    }
//                    myWord.def = [[[obj elementForName:@"def"] stringValue] stringByReplacingOccurrencesOfRegex:@"\\s+" withString:@""];
//                    NSArray *itemsOne = [doc nodesForXPath:@"data/sent" error:nil];
//                    if (itemsOne) {
////                        NSLog(@"4");
//                        for (DDXMLElement *objOne in itemsOne) {
//                            NSString *orig = [[[[[objOne elementForName:@"orig"] stringValue]stringByReplacingOccurrencesOfString:@"<em>" withString:@""] stringByReplacingOccurrencesOfString:@"</em>" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                            [eng addObject:orig];
//                            NSString *trans = [[[objOne elementForName:@"trans"] stringValue] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//                            [chi addObject:trans];
////                            NSLog(@"orig:%@", orig);
////                            NSLog(@"trans:%@", trans);
//                        }
//                    }
//                    myWord.engArray = eng;
//                    myWord.chnArray = chi;
//                    for (UIView *sView in [explainView subviews]) {
//                        if (![sView isKindOfClass:[UIImageView class]]) {
//                            [sView removeFromSuperview];
//                        }
//                    }
//                    NSString *totalString = [[NSString alloc] init];
//                    int totalNum = 0;
//                    for (int i = 0; i<eng.count; i++) {
//                        totalString = [totalString stringByAppendingFormat:@"%d:%@\n%@\n",i+1,[eng objectAtIndex:i],[chi objectAtIndex:i]];
////                        totalNum += ([[eng objectAtIndex:i] length]+2)/34 + 2 + [[chi objectAtIndex:i] length]/34;
//                    }
//                    
//                    UIFont *Courier = [UIFont fontWithName:@"Courier" size:15];
//                    
//                    float cnHight = [@"赵" sizeWithFont:Courier].height;
//                    totalNum = [totalString sizeWithFont:Courier constrainedToSize:CGSizeMake(self.view.frame.size.width-30, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / cnHight + 1;
//                    NSInteger lines = myWord.def.length/23 + 1;
//                    
//                    [explainView setFrame:CGRectMake(15, 15, self.view.frame.size.width-30, 20+lines*20+totalNum*20)];
//                    explainView.layer.cornerRadius = 7.0;
//                    [wordFrame setFrame:CGRectMake(0, 0, explainView.frame.size.width, explainView.frame.size.height)];
//                    
//                    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//                    [addButton setImage:[UIImage imageNamed:@"addWord.png"] forState:UIControlStateNormal];
//                    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
//                    [addButton setFrame:CGRectMake(10, 3, 20, 20)];
//                    [explainView addSubview:addButton];
//
//                    UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 3, [myWord.key sizeWithFont:Courier].width+10, 20)];
//                    [wordLabel setFont :Courier];
//                    [wordLabel setTextAlignment:UITextAlignmentCenter];
//                    wordLabel.text = myWord.key;
//                    wordLabel.backgroundColor = [UIColor clearColor];
//                    [explainView addSubview:wordLabel];
//                    
//                    UILabel *pronLabel = [[UILabel alloc]initWithFrame:CGRectMake(40+[myWord.key sizeWithFont:Courier].width, 3, [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width+10, 20)];
//                    [pronLabel setFont :Courier];
//                    [pronLabel setTextAlignment:UITextAlignmentCenter];
//                    if ( [myWord.pron isEqualToString:@" "]) {
//                        pronLabel.text = @"";
//                    }else
//                    {
//                        pronLabel.text = [NSString stringWithFormat:@"[%@]", myWord.pron];
//                    }
//
//                    pronLabel.backgroundColor = [UIColor clearColor];
//                    [explainView addSubview:pronLabel];
//                    
//                    if (wordPlayerTwo) {
//                        [wordPlayerTwo release];
//                    }
//                    wordPlayerTwo =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:myWord.audio]];
//                    [wordPlayerTwo play];
//                    
//                    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//                    [audioButton setImage:[UIImage imageNamed:@"wordSound.png"] forState:UIControlStateNormal];
//                    [audioButton addTarget:self action:@selector(playWordTwo:) forControlEvents:UIControlEventTouchUpInside];
//                    [audioButton setFrame:CGRectMake(50+[myWord.key sizeWithFont:Courier].width + [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width, 3, 20, 20)];
//                    [explainView addSubview:audioButton];
//                    
//                    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20, explainView.frame.size.width, lines*20)];
//                    [defLabel setFont :Courier];
//                    defLabel.backgroundColor = [UIColor clearColor];
//                    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
//                    [defLabel setNumberOfLines:lines];
//                    defLabel.text = myWord.def;
//                    [explainView addSubview:defLabel];
//                    
//                    UILabel *dictLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 20+lines*20, explainView.frame.size.width, totalNum*20)];
//                    [dictLabel setFont :Courier];
//                    dictLabel.backgroundColor = [UIColor clearColor];
//                    [dictLabel setLineBreakMode:UILineBreakModeWordWrap];
//                    [dictLabel setNumberOfLines:totalNum];
//                    dictLabel.text = totalString;
//                    [explainView addSubview:dictLabel];
//                    
//                    [explainView setAlpha:1];
//                    [self.view addSubview:explainView];
//                    [explainView setHidden:NO];
//                }else
//                {
////                    NSLog(@"5");
//                    myWord.key = request.username;
//                    myWord.audio = @"";
//                    myWord.pron = @" ";
//                    myWord.def = @"";
//
//                    for (UIView *sView in [explainView subviews]) {
//                        if (![sView isKindOfClass:[UIImageView class]]) {
//                            [sView removeFromSuperview];
//                        }
//                    }
//
//                    UIFont *Courier = [UIFont fontWithName:@"Courier" size:15];
//                    [explainView setFrame:CGRectMake(15, 440-19, self.view.frame.size.width-30, 19+19)];
//                    explainView.layer.cornerRadius = 7.0;
//                    [wordFrame setFrame:CGRectMake(0, 0, explainView.frame.size.width, explainView.frame.size.height)];
//                    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//                    [addButton setImage:[UIImage imageNamed:@"addWord.png"] forState:UIControlStateNormal];
//                    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
//                    [addButton setFrame:CGRectMake(10, 3, 20, 20)];
//                    [explainView addSubview:addButton];
//                    
//                    UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 3, [myWord.key sizeWithFont:Courier].width+10, 20)];
//                    [wordLabel setFont :Courier];
//                    [wordLabel setTextAlignment:UITextAlignmentCenter];
//                    wordLabel.text = myWord.key;
//                    wordLabel.backgroundColor = [UIColor clearColor];
//                    [explainView addSubview:wordLabel];
//                    
//                    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 19, self.view.frame.size.width, 19)];
//                    [defLabel setFont :Courier];
//                    defLabel.backgroundColor = [UIColor clearColor];
//                    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
//                    [defLabel setNumberOfLines:1];
//                    
//                    defLabel.text = kWordEight;
////                    NSLog(@"无查找结果!");
//                    [explainView addSubview:defLabel];
//                    [explainView setAlpha:1];
//                    [self.view addSubview:explainView];
//                    [explainView setHidden:NO];
//                }
//                
//            }
//            
//        }
//    }else
//    {
////        NSLog(@"6");
//        NSArray *items = [doc nodesForXPath:@"response/row" error:nil];
//        NSInteger lastPage = 0;
//        if (items) {
//            for (DDXMLElement *obj in items) {
//                lastPage = [[[obj elementForName:@"lastPage"] stringValue] integerValue];
//                NSString *key = [[obj elementForName:@"Word"] stringValue];
//                NSString *audio = [[obj elementForName:@"Audio"] stringValue];
//                NSString *pron = [[obj elementForName:@"Pron"] stringValue];
//                NSString *def = [[obj elementForName:@"Def"] stringValue];
////                NSLog(@"lastPage:%d", lastPage);
////                NSLog(@"word:%@", key);
////                NSLog(@"audio:%@", audio);
////                NSLog(@"pron:%@", pron);
////                NSLog(@"def:%@ %d", def,[VOAWord findLastId]+1);
//                VOAWord *nowWord = [[VOAWord alloc] initWithVOAWord:([VOAWord findLastId]+1) key:key audio:audio pron:pron def:def date:nil checks:0 remember:0 userId:nowUserId flag:0];
////                NSLog(@"初始化");
//                [nowWord alterSynchroCollect];
//                [nowWord release];
//            }
//        }
//        if (lastPage <= request.tag) {
////            NSLog(@"%d,同步圆满完成。",request.tag);
//            [VOAWord deleteSynchro:nowUserId];
//            NSArray *words = [[NSArray alloc] init];
//            words = [VOAWord findWords:nowUserId];
//            [wordsArray removeAllObjects];
//            for (id fav in words) {
//                [wordsArray addObject:fav];
//            }
//            [self.wordsTableView reloadData];
//            [words release], words = nil;
//            [VOAWord clearSynchro];
//        }else
//        {
//            [self catchAllByPageNumber:request.tag+1];
//        }
//    }
////    NSLog(@"7");
//    [doc release];
//    request.delegate = nil;
//}
//
//@end
