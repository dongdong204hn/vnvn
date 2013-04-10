//
//  SearchViewController.m
//  VOA
//
//  Created by song zhao on 12-2-11.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "SearchViewController.h"

@implementation SearchViewController
//@synthesize category = _category;
@synthesize contentsArray = _contentsArray;
@synthesize contentsSrArray = _contentsSrArray;
@synthesize searchWords = _searchWords;
@synthesize voasTableView = _voasTableView;
@synthesize addNum = _addNum;
@synthesize searchFlg = _searchFlg;
@synthesize HUD = _HUD;
@synthesize isiPhone = _isiPhone;
@synthesize contentMode = _contentMode;
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

#pragma mark - My Action
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

- (void) doEdit{
	
	[_voasTableView setEditing:!_voasTableView.editing animated:YES];
	if(_voasTableView.editing)
		self.navigationItem.rightBarButtonItem.title = kSearchOne;
	else
		self.navigationItem.rightBarButtonItem.title = kSearchTwo;
}

//- (BOOL)isPad {
//	BOOL isPad = NO;
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
//	isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//#endif
//	return isPad;
//}


#pragma mark - View lifecycle

- (void) viewWillAppear:(BOOL)animated {
    
    self.navigationController.navigationBarHidden = NO;
    if (_isiPhone) {
        if (kIsLandscapeTest) {
            [_voasTableView setFrame:CGRectMake(0, 0, 480, self.view.frame.size.height)];
        } else {
            [_voasTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
        }
    }else {
        if (kIsLandscapeTest) {
            [_voasTableView setFrame:CGRectMake(0, 0, 1024, self.view.frame.size.height)];
        } else {
            [_voasTableView setFrame:CGRectMake(0, 0, 768, self.view.frame.size.height)];
        }
    }
}

- (void)viewDidLoad
{
    //    myRequest = [[ASIHTTPRequest alloc]init];
    _isiPhone = ![Constants isPad];
    
    _contentsSrArray = [[NSMutableArray alloc] initWithCapacity:10];
    self.navigationController.navigationBarHidden = NO;
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:kSearchTwo style:UIBarButtonItemStylePlain target:self action:@selector(doEdit)];
    self.navigationItem.rightBarButtonItem = editButton;
    [editButton release], editButton = nil;
    self.title = [NSString stringWithFormat:@"%@\"%@\"%@", kSearchThree,_searchWords,kSearchFour];
    if (_searchFlg<111) {
        [self catchResultSy:_searchWords page:1];
    }
//    NSLog(@"22");
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.voasTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
//    kLandscapeTest;
//    [_voasTableView reloadData];
//    if ([NetTest isLandscape:toInterfaceOrientation]) {
//        [_voasTableView setFrame:CGRectMake(0, 0, 480, self.view.frame.size.height)];
//    } else {
//        [_voasTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
//    }
    
//    double yy = [_voasTableView convertRect:_voasTableView.frame toView:self.view.window].origin.y ;
//    NSLog(@"y:%f", yy);
//    [self.navigationController.view setNeedsLayout];//关键函数 保证界面的整齐
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    kLandscapeTest;
    [_voasTableView reloadData];
}

- (void)dealloc {
    //    [myRequest clearDelegatesAndCancel];
    //    [myRequest release];
    [self.voasTableView release], _voasTableView = nil;
    [self.contentsSrArray release], _contentsSrArray = nil;
    [self.sharedSingleQueue release],sharedSingleQueue = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
    return self.searchFlg == 111 ?[self.contentsArray count] : [_contentsSrArray count]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    NSUInteger row = [indexPath row];
//    NSLog(@"row:%d",row);
    static NSString *FirstLevelCell= @"SearchCell";
    VoaViewCell *cell = (VoaViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
    if (!cell) {
        if (_isiPhone) {
//            double yy = [_voasTableView convertRect:_voasTableView.frame toView:self.view.window].origin.y ;
//            NSLog(@"y:%f", yy);
            if (kIsLandscapeTest) {

                [_voasTableView setFrame:CGRectMake(0, 0, 480, self.view.frame.size.height)];
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCellLS"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            } else {

                [_voasTableView setFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            }
        }else {
            if (kIsLandscapeTest) {
                
                [_voasTableView setFrame:CGRectMake(0, 0, 1024, self.view.frame.size.height)];
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCellLS-iPad"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            } else {

                [_voasTableView setFrame:CGRectMake(0, 0, 768, self.view.frame.size.height)];
                
                cell = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaViewCell-iPad"
                                                                    owner:self
                                                                  options:nil] objectAtIndex:0];
            }
        }
        
    }
    VOAContent *content = nil;
    if (self.searchFlg == 111) {
//        NSLog(@"不会吧。。");
        content = [_contentsArray objectAtIndex:row];
    }else{
        if (row == [_contentsSrArray count]) {
            //            UITableViewCell *cellTwo = [[UITableViewCell alloc]init];
            //            [cellTwo setSelectionStyle:UITableViewCellSelectionStyleNone];
            static NSString *SecondLevelCell= @"SearchCellOne";
            UITableViewCell *cellTwo = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:SecondLevelCell];
            if (!cellTwo) {
                if (_isiPhone) {
                    cellTwo = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:SecondLevelCell] autorelease];
                }else {
                    cellTwo = (VoaViewCell*)[[[NSBundle mainBundle] loadNibNamed:@"VoaImageCell-iPad" 
                                                                           owner:self 
                                                                         options:nil] objectAtIndex:0];
                }
            }
//            NSLog(@"_addNum:%i", _addNum);
            if (_addNum == 10) {
                //                [cellTwo.imageView setImage:[UIImage imageNamed:@"load.png"]];
                if (_isiPhone) {
                    [cellTwo.imageView setImage:[UIImage imageNamed:@"load.png"]];
                }
            }else{
                [cellTwo setHidden:YES];
            }
            return cellTwo;
        }
        else
        {
            if (row == [_contentsSrArray count]+1) {
                static NSString *ThirdLevelCell= @"SearchCellTwo";
                UITableViewCell *cellThree = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ThirdLevelCell];
                if (!cellThree) {
                    cellThree = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ThirdLevelCell] autorelease];
                    //                    cellThree = [[UITableViewCell alloc]init];
                }
                [cellThree setSelectionStyle:UITableViewCellSelectionStyleNone];
                if (_addNum == 10) {
                    [self catchResult:_searchWords page:([_contentsSrArray count]/10)+1];
                    [self.voasTableView reloadData];
                }else{
                    [cellThree setHidden:YES];
                }
                return cellThree;
            }
            content = [_contentsSrArray objectAtIndex:row];
        }
    }
    VOAView *myVoa = [VOAView find:content._voaid];
    if (myVoa._isRead.integerValue == 1) {
        //            [cell.readImg setImage:[UIImage imageNamed:@"detailRead-ipad.png"]];
        [cell.myTitle setTextColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1]];
        [cell.myDate setTextColor:[UIColor colorWithRed:0.702 green:0.702 blue:0.702 alpha:1]];
    }else
    {
        //            [cell.myTitle setTextColor:[UIColor redColor]];
        //            [cell.myDate setTextColor:[UIColor redColor]];
        //            [cell.readImg setImage:[UIImage imageNamed:@"detail-ipad.png"]];
    }
    if ([VOAFav isCollected:myVoa._voaid]) {
        [cell.localImg setHidden:NO];
    }
    
//    [cell.myTitle setTextColor:[UIColor purpleColor]];
    cell.myTitle.text = content._title;
//    [cell.myDate setTextColor:[UIColor redColor]];
    cell.myDate.text = [NSString stringWithFormat:@"%@%d%@;%@%d%@",kSearchSix, content._titleNum, kSearchEight, kSearchSeven,content._number,kSearchEight];
//    [cell.collectDate setTextColor:[UIColor purpleColor]];
    cell.collectDate.text = content._creattime;
    //--------->设置内容换行
    [cell.myTitle setLineBreakMode:UILineBreakModeClip];
    //--------->设置最大行数
    [cell.myTitle setNumberOfLines:3];
    NSURL *url = [NSURL URLWithString: content._pic];
    if (self.isiPhone) {
        [cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesceBBC.png"]];
    } else {
        [cell.myImage setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesceBBCP.png"]];
    }
    [myVoa release];
    //        }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;  
}

#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (kIsLandscapeTest) {
        return self.searchFlg == 111 ?(_isiPhone?165.0f:280.0f):( [indexPath row] < [_contentsSrArray count]? (_isiPhone?165.0f:280.0f): (([indexPath row] < [_contentsSrArray count]+1)?(_isiPhone?42.0f:48.0f):1.0f));
    }
    return self.searchFlg == 111 ?(_isiPhone?110.0f:210.0f):( [indexPath row] < [_contentsSrArray count]? (_isiPhone?110.0f:210.0f): (([indexPath row] < [_contentsSrArray count]+1)?(_isiPhone?28.0f:48.0f):1.0f));
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{	
    if (self.searchFlg == 111) {
        [_contentsArray removeObjectAtIndex:indexPath.row];
    }else{
        [_contentsSrArray removeObjectAtIndex:indexPath.row];
    }
	[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    VOAContent *content = nil;
    if (self.searchFlg == 111) {
        content = [_contentsArray objectAtIndex:row];
    }else{
        content = [_contentsSrArray objectAtIndex:row];
    }
    VOAView *voa = [VOAView find:content._voaid];
    //    NSLog(@"没有：%d",voa._voaid);
    _HUD = [[MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES] retain];
    _HUD.delegate = self;
    _HUD.dimBackground = YES;
    _HUD.labelText = @"Loading!";    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
        
        dispatch_async(dispatch_get_main_queue(), ^{  
//            NSLog(@"选中：%d-%d",row,voa._voaid);
            VOADetail *myDetail = [VOADetail find:voa._voaid];
            if (!myDetail) {
                [VOADetail deleteByVoaid: voa._voaid];
                [self catchDetails:voa];
                
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
//                if (play.contentMode != self.contentMode) {
                play.flushList = YES;
                play.contentMode = self.contentMode;
                play.category = self.searchFlg;
//                }
                [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
                [self.navigationController pushViewController:play animated:NO]; 
                [_HUD hide:YES];
            } else {
                [myDetail release];
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
//                if (play.contentMode != self.contentMode) {
                    play.flushList = YES;
                    play.contentMode = self.contentMode;
                play.category = self.searchFlg;
//                }
                [play setHidesBottomBarWhenPushed:YES];//设置推到新界面时无bottomBar
                [self.navigationController pushViewController:play animated:NO]; 
                [_HUD hide:YES];
            }
            
        });  
    });     
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleDelete;
}

#pragma mark - Http connect



- (void)catchResult:(NSString *) searchWord page:(NSInteger)page{
    //    self.lastId = [VOAView findLastId];
    //    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/searchApi.jsp?key=%@&format=xml&pages=%d&pageNum=10&parentID=%d&fields=all",searchWord,page,_searchFlg];
    ////    NSLog(@"url:%@",url);
    ////    [myRequest setURL:[NSURL URLWithString:url]];
    //    _myRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ////    myRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    //    _myRequest.delegate = self;
    //    [_myRequest setUsername:@"search"];
    //    [_myRequest startSynchronous];
    
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/searchChangSuApi.jsp?key=%@&format=xml&pages=%d&pageNum=10&parentID=%d&fields=all&maxid=700",searchWord,page,_searchFlg];
    NSOperationQueue *myQueue = [self sharedQueue];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setUsername:@"search"];
    //    [request setDidStartSelector:@selector(requestMyStarted:)];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    
    [myQueue addOperation:request];
}

- (void)catchResultSy:(NSString *) searchWord page:(NSInteger)page{
    //    self.lastId = [VOAView findLastId];
    //    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/searchApi.jsp?key=%@&format=xml&pages=%d&pageNum=10&parentID=%d&fields=all",searchWord,page,_searchFlg];
    ////    NSLog(@"url:%@",url);
    ////    [myRequest setURL:[NSURL URLWithString:url]];
    //    _myRequest = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ////    myRequest = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    //    _myRequest.delegate = self;
    //    [_myRequest setUsername:@"search"];
    //    [_myRequest startSynchronous];
    
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/searchChangSuApi.jsp?key=%@&format=xml&pages=%d&pageNum=10&parentID=%d&fields=all&maxid=700",searchWord,page,_searchFlg];
    NSLog(@"url:%@",url);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"search"];
    [request startSynchronous];
}

- (void)catchDetails:(VOAView *) voaid
{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/textChangSuApi.jsp?voaid=%d&format=xml",voaid._voaid];
    //    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"detail"];
    [request setTag:voaid._voaid];
    [request startSynchronous];
    //    request = nil;
    //    [request release];
    //    
    ////    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/searchApi.jsp?key=%@&format=xml&pages=%d&pageNum=10&parentID=%d&fields=all",searchWord,page,_searchFlg];
    //    NSOperationQueue *myQueue = [self sharedQueue];
    //    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    //    [request setDelegate:self];
    //    [request setUsername:@"detail"];
    //    //    [request setDidStartSelector:@selector(requestMyStarted:)];
    //    [request setDidFinishSelector:@selector(requestDone:)];
    //    [request setDidFailSelector:@selector(requestWentWrong:)];
    //    [myQueue addOperation:request];
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"search"])
    {
        UIAlertView * alert = [[[UIAlertView alloc] initWithTitle:kSearchNine message:kSearchTen delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] autorelease];
        [alert setTag:1];
        [alert show];
        [_HUD hide:YES];
    }else
    {
        if ([request.username isEqualToString:@"detail"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kSearchEleven message:[NSString stringWithFormat:@"%@,%@",kSearchEleven,kSearchTwelve] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release];
            [_HUD hide:YES];
        }
    }
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"search"])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kSearchNine message:kSearchTen delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil ];
        [alert setTag:1];
        [alert show];
//        [alert release];
        [_HUD hide:YES];
    }else
    {
        if ([request.username isEqualToString:@"detail"]) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kSearchEleven message:[NSString stringWithFormat:@"%@,%@",kSearchEleven,kSearchTwelve] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
            [alert release]; 
            [_HUD hide:YES];
        }
    }
    
}

- (void)requestDone:(ASIHTTPRequest *)request
{
//    NSLog(@"2");
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"search" ]) {
        /////解析      
        _addNum = 0;
        //        NSArray *items = [doc nodesForXPath:@"data" error:nil];
        //        if (items) {
        //            for (DDXMLElement *obj in items) {
        ////                NSInteger total = [[[obj elementForName:@"total"] stringValue] integerValue] ;
        ////                NSLog(@"total:%d",total);
        //            }
        //        }
        
        NSArray *items = [doc nodesForXPath:@"data/voatitle" error:nil];
        if (items) {
            //            addNum = 0;
            for (DDXMLElement *obj in items) {
                VOAView *newVoa = [[VOAView alloc] init];
                newVoa._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                newVoa._title = [[obj elementForName:@"Title"] stringValue];
                newVoa._descCn = [[[obj elementForName:@"DescCn"] stringValue] stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                newVoa._title_Cn = [[[obj elementForName:@"Title_cn"] stringValue] isEqualToString: @" null"] ? nil :[[obj elementForName:@"Title_cn"] stringValue];
                newVoa._category = [[obj elementForName:@"Category"] stringValue];
                newVoa._sound = [[obj elementForName:@"Sound"] stringValue];
                newVoa._url = [[obj elementForName:@"Url"] stringValue];
                newVoa._pic = [[obj elementForName:@"Pic"] stringValue];
                newVoa._creatTime = [[obj elementForName:@"CreatTime"] stringValue];
                newVoa._publishTime = [[obj elementForName:@"PublishTime"] stringValue] == @" null" ? nil :[[obj elementForName:@"PublishTime"] stringValue];
                newVoa._readCount = [[obj elementForName:@"ReadCount"] stringValue];
                newVoa._hotFlg = [[obj elementForName:@"HotFlg"] stringValue];
                newVoa._isRead = @"0";
                if ([VOAView isExist:newVoa._voaid] == NO) {
                    [newVoa insert];
                    //                    NSLog(@"插入%d成功",newVoa._voaid);
                }
                
                VOAContent *voaCon = [[VOAContent alloc] init];
                //                voaCon._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                voaCon._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                voaCon._titleNum = [[[obj elementForName:@"titleFind"] stringValue] integerValue];
                voaCon._number = [[[obj elementForName:@"textFind"] stringValue] integerValue];
                voaCon._title = [[[obj elementForName:@"Title"] stringValue] isEqualToString: @"null"] ? nil :[[obj elementForName:@"Title"] stringValue];
                voaCon._pic = [[obj elementForName:@"Pic"] stringValue];
                voaCon._creattime = [[obj elementForName:@"CreatTime"] stringValue];
//                NSLog(@"title:%@",voaCon._title );
                //                voaCon._title = newVoa._title;
                //                voaCon._pic = newVoa._pic;
                //                voaCon._creattime = newVoa._creatTime;
                [_contentsSrArray addObject:voaCon];
                _addNum++;
                [newVoa release],newVoa = nil;
                [voaCon release],voaCon = nil;
            }
            
            //            NSLog(@"addNum:%d",addNum);
        }
        else{
            
        }
        if (_addNum == 0 && [_contentsSrArray count] == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kSearchNine message:kSearchTen delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
            [alert setTag:1];
            [alert show];
        }
    }else
    {
        if ([request.username isEqualToString:@"detail"]) {
            NSArray *items = [doc nodesForXPath:@"data/voatext" error:nil];
            if (items) {
                
                for (DDXMLElement *obj in items) {
                    VOADetail *newVoaDetail = [[VOADetail alloc] init];
                    newVoaDetail._voaid = request.tag ;
                    newVoaDetail._paraid = [[[obj elementForName:@"ParaId"] stringValue]integerValue];
                    newVoaDetail._idIndex = [[[obj elementForName:@"IdIndex"] stringValue]integerValue];             
                    newVoaDetail._timing = [[[obj elementForName:@"Timing"] stringValue]integerValue];
                    newVoaDetail._sentence = [[[obj elementForName:@"Sentence"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                    newVoaDetail._imgWords = [[[obj elementForName:@"ImgWords"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                    newVoaDetail._imgPath = [[obj elementForName:@"ImgPath"] stringValue];
                    newVoaDetail._sentence_cn = [[[obj elementForName:@"sentence_cn"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                    if ([newVoaDetail insert]) {
                        //                        NSLog(@"插入%d成功",newVoaDetail._voaid);
                    }
                    [newVoaDetail release],newVoaDetail = nil;
                    
                }
                
            } 
            
            //            else {
            //                [VOAView deleteByVoaid:request.tag];
            //            }
            [_HUD hide:YES];
        }
        
    }
    [doc release],doc = nil;
    //    [myData release], myData = nil;
    //    [request clearDelegatesAndCancel];
    //    [request release];
    //    request.delegate = nil;
    //    [request release];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"search" ]) {
        /////解析      
        _addNum = 0;
        //        NSArray *items = [doc nodesForXPath:@"data" error:nil];
        //        if (items) {
        //            for (DDXMLElement *obj in items) {
        ////                NSInteger total = [[[obj elementForName:@"total"] stringValue] integerValue] ;
        ////                NSLog(@"total:%d",total);
        //            }
        //        }
//        NSLog(@"22");
        NSArray *items = [doc nodesForXPath:@"data/voatitle" error:nil];
        if (items) {
            //            addNum = 0;
            for (DDXMLElement *obj in items) {
                VOAView *newVoa = [[VOAView alloc] init];
                newVoa._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                newVoa._title = [[obj elementForName:@"Title"] stringValue];
                newVoa._descCn = [[[obj elementForName:@"DescCn"] stringValue] stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                newVoa._title_Cn = [[[obj elementForName:@"Title_cn"] stringValue] isEqualToString: @" null"] ? nil :[[obj elementForName:@"Title_cn"] stringValue];
                newVoa._category = [[obj elementForName:@"Category"] stringValue];
                newVoa._sound = [[obj elementForName:@"Sound"] stringValue];
                newVoa._url = [[obj elementForName:@"Url"] stringValue];
                newVoa._pic = [[obj elementForName:@"Pic"] stringValue];
                newVoa._creatTime = [[obj elementForName:@"CreatTime"] stringValue];
                newVoa._publishTime = [[obj elementForName:@"PublishTime"] stringValue] == @" null" ? nil :[[obj elementForName:@"PublishTime"] stringValue];
                newVoa._readCount = [[obj elementForName:@"ReadCount"] stringValue];
                newVoa._hotFlg = [[obj elementForName:@"HotFlg"] stringValue];
                newVoa._isRead = @"0";
                if ([VOAView isExist:newVoa._voaid] == NO) {
                    [newVoa insert];
                    //                    NSLog(@"插入%d成功",newVoa._voaid);
                }
                
                VOAContent *voaCon = [[VOAContent alloc] init];
                //                voaCon._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                voaCon._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                voaCon._titleNum = [[[obj elementForName:@"titleFind"] stringValue] integerValue];
                voaCon._number = [[[obj elementForName:@"textFind"] stringValue] integerValue];
                voaCon._title = [[[obj elementForName:@"Title"] stringValue] isEqualToString: @"null"] ? nil :[[obj elementForName:@"Title"] stringValue];
                voaCon._pic = [[obj elementForName:@"Pic"] stringValue];
                voaCon._creattime = [[obj elementForName:@"CreatTime"] stringValue];
//                NSLog(@"title:%@",voaCon._title );
                //                voaCon._title = newVoa._title;
                //                voaCon._pic = newVoa._pic;
                //                voaCon._creattime = newVoa._creatTime;
                [_contentsSrArray addObject:voaCon];
                _addNum++;
                [newVoa release],newVoa = nil;
                [voaCon release],voaCon = nil;
            }
            
//            NSLog(@"addNum:%d",_addNum);
        }
        else{
            
        }
        if (_addNum == 0 && [_contentsSrArray count] == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:kSearchNine message:kSearchTen delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] ;
            [alert setTag:1];
            [alert show];
        }
    }else
    {
        if ([request.username isEqualToString:@"detail"]) {
            NSArray *items = [doc nodesForXPath:@"data/voatext" error:nil];
            if (items) {
                
                for (DDXMLElement *obj in items) {
                    VOADetail *newVoaDetail = [[VOADetail alloc] init];
                    newVoaDetail._voaid = request.tag ;
                    newVoaDetail._paraid = [[[obj elementForName:@"ParaId"] stringValue]integerValue];
                    newVoaDetail._idIndex = [[[obj elementForName:@"IdIndex"] stringValue]integerValue];             
                    newVoaDetail._timing = [[[obj elementForName:@"Timing"] stringValue]integerValue];
                    newVoaDetail._sentence = [[[obj elementForName:@"Sentence"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                    newVoaDetail._imgWords = [[[obj elementForName:@"ImgWords"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                    newVoaDetail._imgPath = [[obj elementForName:@"ImgPath"] stringValue];
                    newVoaDetail._sentence_cn = [[[obj elementForName:@"sentence_cn"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                    if ([newVoaDetail insert]) {
                        //                        NSLog(@"插入%d成功",newVoaDetail._voaid);
                    }
                    [newVoaDetail release],newVoaDetail = nil;
                    
                }
                
            } 
            
            //            else {
            //                [VOAView deleteByVoaid:request.tag];
            //            }
            [_HUD hide:YES];
        }         
    }
//    NSLog(@"33");
    [doc release],doc = nil;
    //    [myData release], myData = nil;
    //    [request clearDelegatesAndCancel];
    //    [request release];
    //    request.delegate = nil;
    //    [request release];
}

- (void)modalView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//点击确定下载为0，取消为1
        if (alertView.tag == 1) {
            [self.navigationController popViewControllerAnimated:NO];
            [alertView release];
        }
        else{
        }
    }
//    [alertView release];
}

//#pragma mark - debug
//#ifdef _FOR_DEBUG_  
//-(BOOL) respondsToSelector:(SEL)aSelector {  
//    printf("SELECTOR: %s\n", [NSStringFromSelector(aSelector) UTF8String]);  
//    return [super respondsToSelector:aSelector];  
//}  
//#endif 



@end
