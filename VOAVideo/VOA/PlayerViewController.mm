//
//  PlayerViewController.m
//  AEHTS
//
//  Created by zhao song on 12-10-31.
//  Copyright (c) 2012年 zhao song. All rights reserved.
//

#import "PlayerViewController.h"
#import "JMWhenTapped.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController
@synthesize voa;
@synthesize videoView;
@synthesize playbackButton;
@synthesize newFile;
@synthesize contentMode;
@synthesize pre;
@synthesize aft;
@synthesize isFive = _isFive;
@synthesize category = _category;
@synthesize commScroll = _commScroll;
@synthesize senLabel = _senLabel;
@synthesize commCellNum = _commCellNum;
@synthesize keyboardFlg = _keyboardFlg;
@synthesize myView = _myView;
@synthesize textView = _textView;
@synthesize containerView = _containerView;
@synthesize nowPage = _nowPage;
@synthesize totalPage = _totalPage;
@synthesize isNewComm = _isNewComm;
@synthesize commArray = _commArray;
@synthesize commTableView = _commTableView;
@synthesize alert = _alert;
@synthesize fixTimer = _fixTimer;
@synthesize fixSeconds = _fixSeconds;
@synthesize hoursArray = _hoursArray;
@synthesize minsArray = _minsArray;
@synthesize secsArray = _secsArray;
@synthesize fixButton = _fixButton;
@synthesize fixTimeView = _fixTimeView;
@synthesize myPick = _myPick;
@synthesize isFixing = _isFixing;
@synthesize displayModeBtn = _displayModeBtn;
@synthesize HUD = _HUD;
@synthesize listArray = _listArray;
@synthesize playIndex = _playIndex;
@synthesize localFileExist = _localFileExist;
@synthesize downloaded = _downloaded;
@synthesize userPath = _userPath;
@synthesize playMode = _playMode;
@synthesize flushList = _flushList;
@synthesize btnOne = _btnOne;
@synthesize btnTwo = _btnTwo;
@synthesize btnThree = _btnThree;
@synthesize btnFour = _btnFour;
@synthesize RoundBack = _RoundBack;
@synthesize isFree = _isFree;
@synthesize isiPhone = _isiPhone;
@synthesize bannerView = _bannerView;
@synthesize needFlushAdv = _needFlushAdv;
//@synthesize isExisitNet = _isExisitNet;
@synthesize myScroll = _myScroll;
@synthesize titleWords = _titleWords;
@synthesize pageControl = _pageControl;
@synthesize titleView = _titleView;
@synthesize imgWords = _imgWords;
@synthesize btnView = _btnView;
@synthesize myImageView = _myImageView;
@synthesize modeBtn = _modeBtn;
@synthesize textScroll = _textScroll;
@synthesize downloadFlg = _downloadFlg;
@synthesize downloadingFlg = _downloadingFlg;
@synthesize collectButton = _collectButton;
@synthesize lyricArray = _lyricArray;
@synthesize lyricCnArray = _lyricCnArray;
@synthesize lyricLabelArray = _lyricLabelArray;
@synthesize lyricCnLabelArray = _lyricCnLabelArray;
@synthesize indexArray = _indexArray;
@synthesize timeArray = _timeArray;
@synthesize explainView = _explainView;
@synthesize engLines = _engLines;
@synthesize cnLines = _cnLines;
@synthesize myHighLightWord = _myHighLightWord;
@synthesize myWord = _myWord;
@synthesize wordPlayer = _wordPlayer;
@synthesize nowUserId = _nowUserId;
@synthesize senImage = _senImage;
//@synthesize shareSenBtn = _shareSenBtn;

#pragma mark - static method
+ (PlayerViewController *)sharedPlayer
{
    static PlayerViewController *sharedPlayer;
    
    @synchronized(self)
    {
        if (!sharedPlayer){
            sharedPlayer = [[PlayerViewController alloc] init];
            sharedPlayer.contentMode = 0;
        }
        else{
            
        }
        
        return sharedPlayer;
    }
}

+ (NSOperationQueue *)sharedQueue
{
    static NSOperationQueue *sharedSingleQueue;
    
    @synchronized(self)
    {
        if (!sharedSingleQueue){
            sharedSingleQueue = [[NSOperationQueue alloc] init];
            [sharedSingleQueue setMaxConcurrentOperationCount:1];
        }
        return sharedSingleQueue;
    }
}

#pragma mark - View lifecycle
-(id)init
{
	self = [super init];
	if(self){
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillHide:)
													 name:UIKeyboardWillHideNotification
												   object:nil];
	}
	
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    _isiPhone = ![Constants isPad];
	if (_isiPhone) {
        self = [super initWithNibName:@"PlayerViewController" bundle:nibBundleOrNil];
	}else {
        self = [super initWithNibName:@"PlayerViewController-iPad" bundle:nibBundleOrNil];
    }
    if (self) {
        //        NSLog(@"%@",nibNameOrNil);
        
    }
    
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    //    if (self) {
    //        // Custom initialization
    //        videoView = [[FGalleryVideoView alloc] initWithFrame:CGRectMake(10, 0, 300, 210)];
    //        videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //        videoView.autoresizesSubviews = YES;
    //        videoView.videoDelegate = self;
    //        [videoView whenDoubleTapped:^{
    //            [videoView toggleScreenControls];
    //            [self toggleFullScreen];
    //        }];
    //        [self.view addSubview:videoView];
    //
    //
    //    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    kNetTest;
    _isFree = ![[NSUserDefaults standardUserDefaults] boolForKey:kBePro];
//    _isFree = NO;
    self.navigationController.navigationBarHidden = YES;
    if (newFile) _commCellNum = 0;
    [self viewResize];
    [_commTableView reloadData];
    [[UIApplication sharedApplication] setIdleTimerDisabled:[[NSUserDefaults standardUserDefaults] boolForKey:@"keepScreenLight"]];
    kNetTest;
    if (_needFlushAdv && kNetIsExist) {
        _needFlushAdv = NO;
        [_bannerView loadRequest:[GADRequest request]];
    }
    
    
    _nowUserId = 0;
    _nowUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
    
    if ([VOAFav isCollected:voa._voaid]) {
        [_downloadFlg setHidden:NO];
        [_collectButton setHidden:YES];
        [_downloadingFlg setHidden:YES];
    } else if([VOAView isDownloading:voa._voaid]) {
        [_downloadFlg setHidden:YES];
        [_collectButton setHidden:YES];
        [_downloadingFlg setHidden:NO];
    } else {
        [_downloadFlg setHidden:YES];
        [_collectButton setHidden:NO];
        [_downloadingFlg setHidden:YES];
    }
    
    NSInteger myColor = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueColor"];
    UIColor *swColor = [UIColor redColor];
    switch (myColor) {
        case 1:
            swColor = [UIColor colorWithRed:0.78f green:0.078f blue:0.11f alpha:1.0];
            break;
        case 2:
//            swColor = [UIColor colorWithRed:0.153f green:0.012f blue:0.518f alpha:1.0];
            swColor = [UIColor colorWithRed:1.0/255 green:151.0/255 blue:211.0/255 alpha:1];
            break;
        case 3:
            swColor = [UIColor colorWithRed:0.384f green:0.247f blue:0.157f alpha:1.0];
            break;
        case 4:
            swColor = [UIColor colorWithRed:1.0f green:0.4f blue:0.192 alpha:1.0];
            break;
        case 5:
            swColor = [UIColor colorWithRed:0.435f green:0.106f blue:0.361f alpha:1.0];
            break;
        case 6:
            swColor = [UIColor colorWithRed:0.421f green:0.753f blue:0.173f alpha:1.0];
            break;
        default:
            break;
    }
    [_senLabel setTextColor:swColor];
    
    if (_flushList) {
        NSLog(@"获取列表");
        if (contentMode == 1) {
//            NSLog(@"联网获取列表");
//            [VOAView getList:_listArray];
            [VOAView getList:_listArray category:_category];
            //            }
        } else if (contentMode == 2) {
            [VOAFav getList:_listArray];
            //            }
        }
        _flushList = NO;
    }
    
    _playIndex = [self indexOfArray:_listArray bbcId:voa._voaid];
    
    if (newFile) {
        
        [self initialize];
    } else {
        UILabel *test = [_lyricLabelArray objectAtIndex:0];
        int fontSize = 15;
        if ([Constants isPad]) {
            fontSize = 20;
        }
        int mulValueFont = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueFont"];
        if (mulValueFont > 0) {
            fontSize = mulValueFont;
        }
        //    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:fontSize] forKey:@"nowValueFont"];
        //    UIFont *Courier = [UIFont fontWithName:@"Courier" size:fontSize];//初始15
        UIFont *Courier = [UIFont systemFontOfSize:fontSize];//初始15
        
        if (test.font == Courier) {
//            NSLog(@"same!!");
        } else {
//            NSLog(@"not same!!");
            for (UIView *deleteView in [_textScroll subviews]) {
                [deleteView removeFromSuperview];
            }
            
            /*
             *  清空lyricLabelArray与lyricCnLabelArray两个数组
             */
            for (UIView *deleteView in _lyricLabelArray) {
                [deleteView removeFromSuperview];
            }
            for (UIView *deleteView in _lyricCnLabelArray) {
                [deleteView removeFromSuperview];
            }
            [_lyricLabelArray removeAllObjects];
            [_lyricCnLabelArray removeAllObjects];
//            NSLog(@"textScroll：%f", _textScroll.frame.size.width);
            int setY = [LyricSynClass lyricView : (NSMutableArray *)_lyricLabelArray
                               lyricCnLabelArray: (NSMutableArray *)_lyricCnLabelArray
                                          index : (NSMutableArray *)_indexArray
                                          lyric : (NSMutableArray *)_lyricArray
                                        lyricCn : (NSMutableArray *)_lyricCnArray
                                         scroll : (TextScrollView *)_textScroll
                                 myLabelDelegate: (id <MyLabelDelegate>) self
                                       engLines : (int *)&_engLines
                                        cnLines : (int *)&_cnLines];
            //        NSLog(@"lyricLabelArrayretainnumber:%i", [self.lyricLabelArray retainCount]);
            CGSize newSize = CGSizeMake(_textScroll.frame.size.width, setY);
            [_textScroll setContentSize:newSize];
        }
    }
    
}

- (void) initialize {
//    NSLog(@"初始化");
    [VOAView alterRead:voa._voaid];//设置已读
    switch (_playMode) {
        case 1:
            if (_isiPhone) {
                [_modeBtn setImage:[UIImage imageNamed:@"sin.png"] forState:UIControlStateNormal];
            } else {
                [_modeBtn setImage:[UIImage imageNamed:@"sinP.png"] forState:UIControlStateNormal];
            }
            
            //            [displayModeBtn setTitle:@"单曲循环" forState:UIControlStateNormal];
            break;
        case 2:
            if (_isiPhone) {
                [_modeBtn setImage:[UIImage imageNamed:@"seq.png"] forState:UIControlStateNormal];
            } else {
                [_modeBtn setImage:[UIImage imageNamed:@"seqP.png"] forState:UIControlStateNormal];
            }
            
            //            [displayModeBtn setTitle:@"顺序播放" forState:UIControlStateNormal];
            break;
        case 3:
            if (_isiPhone) {
                [_modeBtn setImage:[UIImage imageNamed:@"ran.png"] forState:UIControlStateNormal];
            } else {
                [_modeBtn setImage:[UIImage imageNamed:@"ranP.png"] forState:UIControlStateNormal];
            }
            
            //            [displayModeBtn setTitle:@"随机播放" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    _nowPage = 1;
    _totalPage = 1;
    [self catchComments:1];
    
    _downloaded = NO;
    
    [_titleWords setText:[voa _title]];
    [_imgWords setText:voa._descCn];
    [_myImageView setImageWithURL:[NSURL URLWithString: voa._pic] placeholderImage:[UIImage imageNamed:@"acquiesce.png"]];
    
    [videoView currentTimeLabel].text = [timeSwitchClass timeToSwitchAdvance:0];
    [videoView totalTimeLabel].text = [NSString stringWithFormat:@"/ %@", [timeSwitchClass timeToSwitchAdvance:0]];
    [[videoView timeSlider] setValue:0.f];
    videoView.showPic = NO;
    if(videoView.player) // Not loaded yet
    {
        [videoView.player pause];
        [videoView.player release];
        videoView.player = nil;
    }
    [videoView.playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
    videoView.isPlaying = NO;
    //        http://voa.iyuba.com/voa/HTS/[voaid].mp4
    //        AVAudioSession *session = [AVAudioSession sharedInstance];
    //        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    if (contentMode == 1) {
    } else {
        //        [videoView.loadProgress setProgress:1.0];
        //        //            NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"haku" ofType:@"mov"];
        //        NSString *sourcePath = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] bundlePath], voa._sound];
        //        NSLog(@"加载视频:%@", sourcePath);
        //        AVAsset *avSet = [AVAsset assetWithURL:[NSURL fileURLWithPath:sourcePath]];
        //        AVPlayerItem * playerItem = [AVPlayerItem playerItemWithAsset:avSet];
        //        [[NSNotificationCenter defaultCenter] addObserver:videoView
        //                                                 selector:@selector(playerItemDidReachEnd:)
        //                                                     name:AVPlayerItemDidPlayToEndTimeNotification
        //                                                   object:playerItem];
        //        AVPlayer * aplayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        //        [videoView setPlayer:aplayer];
    }
    
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //创建audio份目录在Documents文件夹下，not to back up
    NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];;
    _userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d.mp4", voa._voaid]];
    _localFileExist = [[NSFileManager defaultManager] fileExistsAtPath:_userPath];
    if (_localFileExist) {
        videoView.playerFlag = 0;
        [videoView.loadProgress setProgress:1.0];
        [_downloadFlg setHidden:NO];
        [_collectButton setHidden:YES];
        [_downloadingFlg setHidden:YES];
        AVPlayerItem * playerItem = nil;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            AVAsset *avSet = [AVAsset assetWithURL:[NSURL fileURLWithPath:_userPath]];
            playerItem = [AVPlayerItem playerItemWithAsset:avSet];
        } else {
            playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:_userPath]];
        }
        [[NSNotificationCenter defaultCenter] addObserver:videoView
                                                 selector:@selector(playerItemDidReachEnd:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:playerItem];
        AVPlayer * aplayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
        [videoView setPlayer:aplayer];
    } else {
        videoView.playerFlag = 1;
        [videoView.loadProgress setProgress:0.f];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://static.iyuba.com/video/voa/%i.mp4", voa._voaid]] options:nil];
            //            NSLog(@"加载视频:%@", voa._sound);
            NSError * error;
            AVKeyValueStatus status = [asset statusOfValueForKey:@"track" error:&error];
            
            
            if(status != AVKeyValueStatusLoaded) {
                AVPlayerItem * playerItem = [AVPlayerItem playerItemWithAsset:asset];
                [[NSNotificationCenter defaultCenter] addObserver:videoView
                                                         selector:@selector(playerItemDidReachEnd:)
                                                             name:AVPlayerItemDidPlayToEndTimeNotification
                                                           object:playerItem];
                
                AVPlayer * aplayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
                [videoView setPlayer:aplayer];
            }
            else
            {
                //                NSLog(@"Asset loading failed : %@", [error localizedDescription]);
            }
        } else {
            AVPlayerItem * playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://static.iyuba.com/video/voa/%i.mp4", voa._voaid]]];
            [[NSNotificationCenter defaultCenter] addObserver:videoView
                                                     selector:@selector(playerItemDidReachEnd:)
                                                         name:AVPlayerItemDidPlayToEndTimeNotification
                                                       object:playerItem];
            
            AVPlayer * aplayer = [[AVPlayer alloc] initWithPlayerItem:playerItem];
            [videoView setPlayer:aplayer];
        }
        
        if ([VOAView isDownloading:voa._voaid]) {
            [_downloadingFlg setHidden:NO];
            [_downloadFlg setHidden:YES];
            [_collectButton setHidden:YES];
        }else {
            [_downloadingFlg setHidden:YES];
            [_downloadFlg setHidden:YES];
            [_collectButton setHidden:NO];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoDownload"]) {
                [self collectButtonPressed:_collectButton];
            }
        }
        
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.voa._voaid] forKey:@"lastPlay"];
//    NSLog(@"清空");
//    [videoView  disableTimer];
    [_lyricArray removeAllObjects];
    [_timeArray removeAllObjects];
    [_indexArray removeAllObjects];
    [_lyricCnArray removeAllObjects];
//    NSLog(@"开始");
    [DataBaseClass querySQL:(NSMutableArray *)_lyricArray
            lyricCnResultIn:(NSMutableArray *)_lyricCnArray
               timeResultIn:(NSMutableArray *)_timeArray
              indexResultIn:(NSMutableArray *)_indexArray
                voaResultIn:(VOAView *)voa];
//    NSLog(@"获取%i", [_timeArray count]);
//    [videoView.timeArray removeAllObjects];
//    NSLog(@"数目对比:%i:%i",[_timeArray count] ,[videoView.timeArray count] );
    videoView.timeArray = _timeArray;
//    NSLog(@"数目对比:%i:%i",[_timeArray count] ,[videoView.timeArray count] );
    videoView.sen_num = 1;
    [self playSenID:1 isEng:YES];
//     NSLog(@"获取");
//    [videoView enableTimer];
    
    for (UIView *deleteView in [_textScroll subviews]) {
        [deleteView removeFromSuperview];
    }
    
    /*
     *  清空lyricLabelArray与lyricCnLabelArray两个数组
     */
    for (UIView *deleteView in _lyricLabelArray) {
        [deleteView removeFromSuperview];
    }
    for (UIView *deleteView in _lyricCnLabelArray) {
        [deleteView removeFromSuperview];
    }
    [_lyricLabelArray removeAllObjects];
    [_lyricCnLabelArray removeAllObjects];
//    NSLog(@"textScroll：%f", _textScroll.frame.size.width);
    int setY = [LyricSynClass lyricView : (NSMutableArray *)_lyricLabelArray
                       lyricCnLabelArray: (NSMutableArray *)_lyricCnLabelArray
                                  index : (NSMutableArray *)_indexArray
                                  lyric : (NSMutableArray *)_lyricArray
                                lyricCn : (NSMutableArray *)_lyricCnArray
                                 scroll : (TextScrollView *)_textScroll
                         myLabelDelegate: (id <MyLabelDelegate>) self
                               engLines : (int *)&_engLines
                                cnLines : (int *)&_cnLines];
    //        NSLog(@"lyricLabelArrayretainnumber:%i", [self.lyricLabelArray retainCount]);
    CGSize newSize = CGSizeMake(_textScroll.frame.size.width, setY);
    [_textScroll setContentSize:newSize];
    
    CGRect frame = _myScroll.frame;
    frame.origin.x = frame.size.width * 1;
    frame.origin.y = 0;
    [_myScroll scrollRectToVisible:frame animated:NO];
    [_RoundBack setCenter:CGPointMake(_btnTwo.center.x-3, _btnTwo.center.y)];
    
    _pageControl.currentPage = 1;
    //    int page = _pageControl.currentPage ;
    //    CGRect frame = _myScroll.frame;
    //    frame.origin.x = frame.size.width * page;
    //    frame.origin.y = 0;
    //    [_myScroll scrollRectToVisible:frame animated:YES];
    //
    [_HUD hide:YES];
}

- (void)viewRorateResize {
   _keyboardFlg = NO;
    if (_isFree) {
        if (_isiPhone) {
            if (_isFive) {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphone5Width, 180+20);
                    [_myScroll setContentSize:CGSizeMake(4*kIphone5Width, 180)];
                    [_textScroll setFrame:CGRectMake(2*kIphone5Width + 114 + kAddTwo, 10, 253, 160)];
                    [_myImageView setFrame:CGRectMake(20, 10, 260 + kAddTwo, 160)];
                    [_imgWords setFrame:CGRectMake(300 + kAddTwo, 10, 160 + kAddTwo, 160)];
                    [videoView setFrame:CGRectMake(kIphone5Width + 50, 0, 380 + kAddOne, 180)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(20, 130, 40, 40)];
                    [_clockButton setFrame:CGRectMake(130 + kAddThree, 130, 40, 40)];
                    [_collectButton setFrame:CGRectMake(240 + kAddTwo, 130, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(240 + kAddTwo, 130, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(240 + kAddTwo, 130, 40, 40)];
                    [_explainView setFrame:CGRectMake(30 + kAddTwo, 170, 420, 80)];
                    [_bannerView setFrame:CGRectMake(80.0f + kAddTwo,
                                                     250,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*kIphone5Width, self.myScroll.frame.size.height - 40, kIphone5Width, 40)];
                    [_myView setFrame:CGRectMake(3*kIphone5Width, 0, kIphone5Width, 140)];
                    //                NSLog(@"_commCellNum:%i" ,_commCellNum);
                    [_commTableView setFrame:CGRectMake(0, 0, kIphone5Width, (_commCellNum*kCommTableHeightPh < 140.f? _commCellNum*kCommTableHeightPh: 140))];
                    
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 340+20 + kAddOne);
                    [_myScroll setContentSize:CGSizeMake(960+320, 340 + kAddOne)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 320 + kAddOne)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130 + kAddOne)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+64)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 75 + kAddOne)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    [_bannerView setFrame:CGRectMake(0.0,
                                                     410 + kAddOne,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*320, self.myScroll.frame.size.height - 40, 320, 40)];
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 300 + kAddOne)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 300 + kAddOne? _commCellNum*kCommTableHeightPh: 300 + kAddOne))];
                }
            } else {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphoneWidth, 180+20);
                    [_myScroll setContentSize:CGSizeMake(4*kIphoneWidth, 180)];
                    [_textScroll setFrame:CGRectMake(2*kIphoneWidth + 114, 10, 253, 160)];
                    [_myImageView setFrame:CGRectMake(20, 10, 260, 160)];
                    [_imgWords setFrame:CGRectMake(300, 10, 160, 160)];
                    [videoView setFrame:CGRectMake(kIphoneWidth + 50, 0, 380, 180)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(20, 130, 40, 40)];
                    [_clockButton setFrame:CGRectMake(130, 130, 40, 40)];
                    [_collectButton setFrame:CGRectMake(240, 130, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(240, 130, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(240, 130, 40, 40)];
                    [_explainView setFrame:CGRectMake(30, 170, 420, 80)];
                    [_bannerView setFrame:CGRectMake(80.0f,
                                                     250,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*kIphoneWidth, self.myScroll.frame.size.height - 40, kIphoneWidth, 40)];
                    [_myView setFrame:CGRectMake(3*kIphoneWidth, 0, kIphoneWidth, 140)];
                    //                NSLog(@"_commCellNum:%i" ,_commCellNum);
                    [_commTableView setFrame:CGRectMake(0, 0, kIphoneWidth, (_commCellNum*kCommTableHeightPh < 140.f? _commCellNum*kCommTableHeightPh: 140))];
                    
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 340+20);
                    [_myScroll setContentSize:CGSizeMake(960+320, 340)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 320)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+64)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 75)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    [_bannerView setFrame:CGRectMake(0.0,
                                                     410,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*320, self.myScroll.frame.size.height - 40, 320, 40)];
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 300)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 300? _commCellNum*kCommTableHeightPh: 300))];
                }
            }
            
        } else {
            if (kIsLandscapeTest) {
                initMyscrollFrame = CGRectMake(0, 130, 1024, 528+20);
                [_myScroll setContentSize:CGSizeMake(3072+1024, 528)];
                [_textScroll setFrame:CGRectMake(2210, 14, 700, 500)];
                [_myImageView setFrame:CGRectMake(162, 14, 700, 400)];
                [_imgWords setFrame:CGRectMake(162, 424, 700, 90)];
                [videoView setFrame:CGRectMake(1109, 39, 700, 450)];
                [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                [_modeBtn setFrame:CGRectMake(1893, 79, 70, 70)];
                [_clockButton setFrame:CGRectMake(1893, 229, 70, 70)];
                [_collectButton setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_explainView setFrame:CGRectMake(212, 400, 600, 150)];
                [_bannerView setFrame:CGRectMake(148.0f,
                                                 658,
                                                 GAD_SIZE_728x90.width,
                                                 GAD_SIZE_728x90.height)];
                [_containerView setFrame:CGRectMake(3*1024, self.myScroll.frame.size.height - 40, 1024, 40)];
                [_myView setFrame:CGRectMake(3*1024, 0, 1024, 488)];
                //                [_commTableView setFrame:CGRectMake(0, 0, kScreenHeight, 140)];
                [_commTableView setFrame:CGRectMake(0, 0, 1024, (_commCellNum*kCommTableHeightPa < 488? _commCellNum*kCommTableHeightPa: 488))];
            } else {
                initMyscrollFrame = CGRectMake(0, 130, 768, 784+20);
                [_myScroll setContentSize:CGSizeMake(2304+768, 784)];
                [_textScroll setFrame:CGRectMake(1570, 22, 700, 740)];
                [_myImageView setFrame:CGRectMake(34, 48, 700, 400)];
                [_imgWords setFrame:CGRectMake(134, 496, 500, 240)];
                [videoView setFrame:CGRectMake(802, 42, 700, 450+64)];
                [_commScroll setFrame:CGRectMake(768, 650, 768, 130)];
                [_collectButton setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_clockButton setFrame:CGRectMake(1117, 570, 70, 70)];
                [_modeBtn setFrame:CGRectMake(917, 570, 70, 70)];
                [_explainView setFrame:CGRectMake(184, 600, 400, 200)];
                [_bannerView setFrame:CGRectMake(20.0f,
                                                 910,
                                                 GAD_SIZE_728x90.width,
                                                 GAD_SIZE_728x90.height)];
                [_containerView setFrame:CGRectMake(3*768, self.myScroll.frame.size.height - 44, 768, 40)];
                [_myView setFrame:CGRectMake(3*768, 0, 768, 740)];
                //                [_commTableView setFrame:CGRectMake(0, 0, 320, 300)];
                [_commTableView setFrame:CGRectMake(0, 0, 768, (_commCellNum*kCommTableHeightPa < 740? _commCellNum*kCommTableHeightPa: 740))];
            }
        }
    } else {
        if (_isiPhone) {
            if (_isFive) {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphone5Width, 230+20);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(4*kIphone5Width, 230)];
                    [_textScroll setFrame:CGRectMake(2*kIphone5Width + 114 + kAddTwo, 10, 253, 210)];
                    [_myImageView setFrame:CGRectMake(10, 10, 290 + kAddTwo, 210)];
                    [_imgWords setFrame:CGRectMake(310 + kAddTwo, 10, 160 + kAddTwo, 210)];
                    
                    [videoView setFrame:CGRectMake(kIphone5Width + 50, 0, 380+ kAddOne, 230)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(10, 180, 40, 40)];
                    [_clockButton setFrame:CGRectMake(135 + kAddThree, 180, 40, 40)];
                    [_collectButton setFrame:CGRectMake(260 + kAddTwo, 180, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(260 + kAddTwo, 180, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(260 + kAddTwo, 180, 40, 40)];
                    [_explainView setFrame:CGRectMake(30 + kAddTwo, 170, 420, 80)];
                    //                [_bannerView setFrame:CGRectMake(80.0f,
                    //                                                 250,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*kIphone5Width, 230 - 40, kIphone5Width, 40)];
                    [_myView setFrame:CGRectMake(3*kIphone5Width, 0, kIphone5Width, 190)];
                    [_commTableView setFrame:CGRectMake(0, 0, kIphone5Width, (_commCellNum*kCommTableHeightPh < 190.f? _commCellNum*kCommTableHeightPh: 190))];
                    
                    
                    
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 390+20 + kAddOne);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(960+320, 390 + kAddOne)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 370 + kAddOne)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130 + kAddOne)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+64)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 125 + kAddOne)];
                    //                [_collectButton setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadingFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_clockButton setFrame:CGRectMake(460, 290, 40, 40)];
                    //                [_modeBtn setFrame:CGRectMake(370, 290, 40, 40)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    //                [_bannerView setFrame:CGRectMake(0.0,
                    //                                                 410,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    //                NSLog(@"myScroll height:%f", self.myScroll.frame.size.height);
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*320, 390 + kAddOne - 40, 320, 40)];
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 350 + kAddOne)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 350 + kAddOne? _commCellNum*kCommTableHeightPh: 350 + kAddOne))];
                    
                }
            } else {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphoneWidth, 230+20);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(4*kIphoneWidth, 230)];
                    [_textScroll setFrame:CGRectMake(2*kIphoneWidth + 114, 10, 253, 210)];
                    [_myImageView setFrame:CGRectMake(10, 10, 290, 210)];
                    [_imgWords setFrame:CGRectMake(310, 10, 160, 210)];
                    
                    [videoView setFrame:CGRectMake(kIphoneWidth + 50, 0, 380, 230)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(10, 180, 40, 40)];
                    [_clockButton setFrame:CGRectMake(135, 180, 40, 40)];
                    [_collectButton setFrame:CGRectMake(260, 180, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(260, 180, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(260, 180, 40, 40)];
                    [_explainView setFrame:CGRectMake(30, 170, 420, 80)];
                    //                [_bannerView setFrame:CGRectMake(80.0f,
                    //                                                 250,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*kIphoneWidth, 230 - 40, kIphoneWidth, 40)];
                    [_myView setFrame:CGRectMake(3*kIphoneWidth, 0, kIphoneWidth, 190)];
                    [_commTableView setFrame:CGRectMake(0, 0, kIphoneWidth, (_commCellNum*kCommTableHeightPh < 190.f? _commCellNum*kCommTableHeightPh: 190))];
                    
                    
                    
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 390+20);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(960+320, 390)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 370)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+64)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 125)];
                    //                [_collectButton setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadingFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_clockButton setFrame:CGRectMake(460, 290, 40, 40)];
                    //                [_modeBtn setFrame:CGRectMake(370, 290, 40, 40)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    //                [_bannerView setFrame:CGRectMake(0.0,
                    //                                                 410,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    //                NSLog(@"myScroll height:%f", self.myScroll.frame.size.height);
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*320, 390 - 40, 320, 40)];
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 350)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 350? _commCellNum*kCommTableHeightPh: 350))];
                    
                }
            }
            
        } else {
            if (kIsLandscapeTest) {
                initMyscrollFrame = CGRectMake(0, 130, 1024, 618+20);
                [_myScroll setFrame:initMyscrollFrame];
                [_myScroll setContentSize:CGSizeMake(3072+1024, 618)];
                [_textScroll setFrame:CGRectMake(2210, 14, 700, 590)];
                [_myImageView setFrame:CGRectMake(162, 14, 700, 400)];
                [_imgWords setFrame:CGRectMake(162, 424, 700, 150)];
                [videoView setFrame:CGRectMake(1109, 39, 700, 450)];
                [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                [_modeBtn setFrame:CGRectMake(1893, 79, 70, 70)];
                [_clockButton setFrame:CGRectMake(1893, 229, 70, 70)];
                [_collectButton setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_explainView setFrame:CGRectMake(212, 400, 600, 150)];
//                [_bannerView setFrame:CGRectMake(148.0f,
//                                                 658,
//                                                 GAD_SIZE_728x90.width,
//                                                 GAD_SIZE_728x90.height)];
                [_bannerView setHidden:YES];
                [_containerView setFrame:CGRectMake(3*1024, 578, 1024, 40)];
                [_myView setFrame:CGRectMake(3*1024, 0, 1024, 578)];
                [_commTableView setFrame:CGRectMake(0, 0, 1024, (_commCellNum*kCommTableHeightPa < 578? _commCellNum*kCommTableHeightPa: 578))];
            } else {
                initMyscrollFrame = CGRectMake(0, 130, 768, 874+20);
                [_myScroll setFrame:initMyscrollFrame];
                [_myScroll setContentSize:CGSizeMake(2304+768, 874)];
                [_textScroll setFrame:CGRectMake(1570, 22, 700, 830)];
                [_myImageView setFrame:CGRectMake(34, 48, 700, 400)];
                [_imgWords setFrame:CGRectMake(134, 496, 500, 240)];
                [videoView setFrame:CGRectMake(802, 42, 700, 450+64)];
                [_commScroll setFrame:CGRectMake(768, 650, 768, 220)];
                [_collectButton setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_clockButton setFrame:CGRectMake(1117, 570, 70, 70)];
                [_modeBtn setFrame:CGRectMake(917, 570, 70, 70)];
                [_explainView setFrame:CGRectMake(184, 600, 400, 200)];
//                [_bannerView setFrame:CGRectMake(20.0f,
//                                                 910,
//                                                 GAD_SIZE_728x90.width,
//                                                 GAD_SIZE_728x90.height)];
                [_bannerView setHidden:YES];
                [_containerView setFrame:CGRectMake(3*768, 874 - 40, 768, 40)];
                [_myView setFrame:CGRectMake(3*768, 0, 768, 834)];
                //                [_commTableView setFrame:CGRectMake(0, 0, 320, 300)];
                [_commTableView setFrame:CGRectMake(0, 0, 768, (_commCellNum*kCommTableHeightPa < 834? _commCellNum*kCommTableHeightPa: 834))];
            }
        }
    }
    
    //保证显示当前content
    CGRect frame = _myScroll.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    [_myScroll scrollRectToVisible:frame animated:NO];
}

- (void)viewResize {
    _keyboardFlg = YES;
    if (_isFree) {
        if (_isiPhone) {
            if (_isFive) {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphone5Width, 180+20);
                    [_myScroll setContentSize:CGSizeMake(4*kIphone5Width, 180)];
                    [_textScroll setFrame:CGRectMake(2*kIphone5Width + 114 + kAddTwo, 10, 253, 160)];
                    [_myImageView setFrame:CGRectMake(20, 10, 260 + kAddTwo, 160)];
                    [_imgWords setFrame:CGRectMake(300 + kAddTwo, 10, 160 + kAddTwo, 160)];
                    [videoView setFrame:CGRectMake(kIphone5Width + 50, 0, 380 + kAddOne, 180-32)];
                    //                [_senLabel setFrame:CGRectMake(0, 0, 0, 0)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(20, 130, 40, 40)];
                    [_clockButton setFrame:CGRectMake(130 + kAddThree, 130, 40, 40)];
                    [_collectButton setFrame:CGRectMake(240 + kAddTwo, 130, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(240 + kAddTwo, 130, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(240 + kAddTwo, 130, 40, 40)];
                    [_explainView setFrame:CGRectMake(30 + kAddTwo, 170, 420, 80)];
                    [_bannerView setFrame:CGRectMake(80.0f + kAddTwo,
                                                     250,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*kIphone5Width, self.myScroll.frame.size.height - 40, kIphone5Width, 40)];
                    [_myView setFrame:CGRectMake(3*kIphone5Width, 0, kIphone5Width, 140)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, kScreenHeight, 140)];
                    [_commTableView setFrame:CGRectMake(0, 0, kIphone5Width, (_commCellNum*kCommTableHeightPh < 140.f? _commCellNum*kCommTableHeightPh: 140))];
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 340+20 + kAddOne);
                    [_myScroll setContentSize:CGSizeMake(960+320, 340 + kAddOne)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 320 + kAddOne)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130 + kAddOne)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+20)];
                    //                [_senLabel setFrame:CGRectMake(330, 260, 300, 80)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 75 + kAddOne)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    [_bannerView setFrame:CGRectMake(0.0,
                                                     410 + kAddOne,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*320, self.myScroll.frame.size.height - 40, 320, 40)];
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 300 + kAddOne)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, 320, 300)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 300 + kAddOne? _commCellNum*kCommTableHeightPh: 300 + kAddOne))];
                }
            } else {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphoneWidth, 180+20);
                    [_myScroll setContentSize:CGSizeMake(4*kIphoneWidth, 180)];
                    [_textScroll setFrame:CGRectMake(2*kIphoneWidth + 114, 10, 253, 160)];
                    [_myImageView setFrame:CGRectMake(20, 10, 260 , 160)];
                    [_imgWords setFrame:CGRectMake(300, 10, 160, 160)];
                    [videoView setFrame:CGRectMake(kIphoneWidth + 50, 0, 380, 180-32)];
                    //                [_senLabel setFrame:CGRectMake(0, 0, 0, 0)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(20, 130, 40, 40)];
                    [_clockButton setFrame:CGRectMake(130, 130, 40, 40)];
                    [_collectButton setFrame:CGRectMake(240, 130, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(240, 130, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(240, 130, 40, 40)];
                    [_explainView setFrame:CGRectMake(30, 170, 420, 80)];
                    [_bannerView setFrame:CGRectMake(80.0f,
                                                     250,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*kIphoneWidth, self.myScroll.frame.size.height - 40, kIphoneWidth, 40)];
                    [_myView setFrame:CGRectMake(3*kIphoneWidth, 0, kIphoneWidth, 140)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, kScreenHeight, 140)];
                    [_commTableView setFrame:CGRectMake(0, 0, kIphoneWidth, (_commCellNum*kCommTableHeightPh < 140.f? _commCellNum*kCommTableHeightPh: 140))];
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 340+20);
                    [_myScroll setContentSize:CGSizeMake(960+320, 340)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 320)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+20)];
                    //                [_senLabel setFrame:CGRectMake(330, 260, 300, 80)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 75)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    [_bannerView setFrame:CGRectMake(0.0,
                                                     410,
                                                     GAD_SIZE_320x50.width,
                                                     GAD_SIZE_320x50.height)];
                    [_containerView setFrame:CGRectMake(3*320, self.myScroll.frame.size.height - 40, 320, 40)];
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 300)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, 320, 300)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 300? _commCellNum*kCommTableHeightPh: 300))];
                }
            }
            
        } else {
            if (kIsLandscapeTest) {
                initMyscrollFrame = CGRectMake(0, 130, 1024, 528+20);
                [_myScroll setContentSize:CGSizeMake(3072+1024, 528)];
                [_textScroll setFrame:CGRectMake(2210, 14, 700, 500)];
                [_myImageView setFrame:CGRectMake(162, 14, 700, 400)];
                [_imgWords setFrame:CGRectMake(162, 424, 700, 90)];
                [videoView setFrame:CGRectMake(1109, 39, 700, 450-32)];
                [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                [_modeBtn setFrame:CGRectMake(1893, 79, 70, 70)];
                [_clockButton setFrame:CGRectMake(1893, 229, 70, 70)];
                [_collectButton setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_explainView setFrame:CGRectMake(212, 400, 600, 150)];
                [_bannerView setFrame:CGRectMake(148.0f,
                                                 658,
                                                 GAD_SIZE_728x90.width,
                                                 GAD_SIZE_728x90.height)];
                [_containerView setFrame:CGRectMake(3*1024, self.myScroll.frame.size.height - 40, 1024, 40)];
                [_myView setFrame:CGRectMake(3*1024, 0, 1024, 488)];
                //                [_commTableView setFrame:CGRectMake(0, 0, kScreenHeight, 140)];
                [_commTableView setFrame:CGRectMake(0, 0, 1024, (_commCellNum*kCommTableHeightPa < 488? _commCellNum*kCommTableHeightPa: 488))];
            } else {
                initMyscrollFrame = CGRectMake(0, 130, 768, 784+20);
                [_myScroll setContentSize:CGSizeMake(2304+768, 784)];
                [_textScroll setFrame:CGRectMake(1570, 22, 700, 740)];
                [_myImageView setFrame:CGRectMake(34, 48, 700, 400)];
                [_imgWords setFrame:CGRectMake(134, 496, 500, 240)];
                [videoView setFrame:CGRectMake(802, 42, 700, 450+20)];
                [_commScroll setFrame:CGRectMake(768, 650, 768, 130)];
                [_collectButton setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_clockButton setFrame:CGRectMake(1117, 570, 70, 70)];
                [_modeBtn setFrame:CGRectMake(917, 570, 70, 70)];
                [_explainView setFrame:CGRectMake(184, 600, 400, 200)];
                [_bannerView setFrame:CGRectMake(20.0,
                                                 910,
                                                 GAD_SIZE_728x90.width,
                                                 GAD_SIZE_728x90.height)];
                [_containerView setFrame:CGRectMake(3*768, self.myScroll.frame.size.height - 44, 768, 40)];
                [_myView setFrame:CGRectMake(3*768, 0, 768, 740)];
                //                [_commTableView setFrame:CGRectMake(0, 0, 320, 300)];
                [_commTableView setFrame:CGRectMake(0, 0, 768, (_commCellNum*kCommTableHeightPa < 740? _commCellNum*kCommTableHeightPa: 740))];
            }
        }
    } else {
        if (_isiPhone) {
//            NSLog(@"jinlai le ");
            if (_isFive) {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphone5Width, 230+20);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(4*kIphone5Width, 230)];
                    [_textScroll setFrame:CGRectMake(2*kIphone5Width + 114 + kAddTwo, 10, 253, 210)];
                    [_myImageView setFrame:CGRectMake(10, 10, 290 + kAddTwo, 210)];
                    [_imgWords setFrame:CGRectMake(310 + kAddTwo, 10, 160 + kAddTwo, 210)];
                    [videoView setFrame:CGRectMake(kIphone5Width + 50, 0, 380 + kAddOne, 230-32)];
                    //                [_senLabel setFrame:CGRectMake(0, 0, 0, 0)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(10, 180, 40, 40)];
                    [_clockButton setFrame:CGRectMake(135 + kAddThree, 180, 40, 40)];
                    [_collectButton setFrame:CGRectMake(260 + kAddTwo, 180, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(260 + kAddTwo, 180, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(260 + kAddTwo, 180, 40, 40)];
                    [_explainView setFrame:CGRectMake(30 + kAddTwo, 170, 420, 80)];
                    //                [_bannerView setFrame:CGRectMake(80.0f,
                    //                                                 250,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*kIphone5Width, 230 - 72, kIphone5Width, 40)];//特殊位置72
                    [_myView setFrame:CGRectMake(3*kIphone5Width, 0, kIphone5Width, 190)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, kScreenHeight, 190)];
                    [_commTableView setFrame:CGRectMake(0, 0, kIphone5Width, (_commCellNum*kCommTableHeightPh < 190.f? _commCellNum*kCommTableHeightPh: 190))];
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 390+20 + kAddOne);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(960+320, 390 + kAddOne)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 370 + kAddOne)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130 + kAddOne)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+20)];
                    //                [_senLabel setFrame:CGRectMake(330, 260, 300, 130)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 125 + kAddOne)];
                    //                [_collectButton setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadingFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_clockButton setFrame:CGRectMake(460, 290, 40, 40)];
                    //                [_modeBtn setFrame:CGRectMake(370, 290, 40, 40)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    //                [_bannerView setFrame:CGRectMake(0.0,
                    //                                                 410,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    //                NSLog(@"myScroll height:%f", self.myScroll.frame.size.height);
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*320, 390 + kAddOne - 84, 320, 40)];//特殊位置83
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 350 + kAddOne)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, 320, 350)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 350 + kAddOne? _commCellNum*kCommTableHeightPh: 350 + kAddOne))];
                }
            } else {
                if (kIsLandscapeTest) {
                    initMyscrollFrame = CGRectMake(0, 70, kIphoneWidth, 230+20);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(4*kIphoneWidth, 230)];
                    [_textScroll setFrame:CGRectMake(2*kIphoneWidth + 114, 10, 253, 210)];
                    [_myImageView setFrame:CGRectMake(10, 10, 290, 210)];
                    [_imgWords setFrame:CGRectMake(310, 10, 160, 210)];
                    [videoView setFrame:CGRectMake(kIphoneWidth + 50, 0, 380, 230-32)];
                    //                [_senLabel setFrame:CGRectMake(0, 0, 0, 0)];
                    [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                    //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                    [_modeBtn setFrame:CGRectMake(10, 180, 40, 40)];
                    [_clockButton setFrame:CGRectMake(135, 180, 40, 40)];
                    [_collectButton setFrame:CGRectMake(260, 180, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(260, 180, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(260, 180, 40, 40)];
                    [_explainView setFrame:CGRectMake(30, 170, 420, 80)];
                    //                [_bannerView setFrame:CGRectMake(80.0f,
                    //                                                 250,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*kIphoneWidth, 230 - 72, kIphoneWidth, 40)];//特殊位置72
                    [_myView setFrame:CGRectMake(3*kIphoneWidth, 0, kIphoneWidth, 190)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, kScreenHeight, 190)];
                    [_commTableView setFrame:CGRectMake(0, 0, kIphoneWidth, (_commCellNum*kCommTableHeightPh < 190.f? _commCellNum*kCommTableHeightPh: 190))];
                } else {
                    initMyscrollFrame = CGRectMake(0, 70, 320, 390+20);
                    [_myScroll setFrame:initMyscrollFrame];
                    [_myScroll setContentSize:CGSizeMake(960+320, 390)];
                    [_textScroll setFrame:CGRectMake(674, 10, 253, 370)];
                    [_myImageView setFrame:CGRectMake(25, 30, 270, 170)];
                    [_imgWords setFrame:CGRectMake(10, 204, 300, 130)];
                    [videoView setFrame:CGRectMake(330, 10, 300, 190+20)];
                    //                [_senLabel setFrame:CGRectMake(330, 260, 300, 130)];
                    [_commScroll setFrame:CGRectMake(320, 265, 320, 125)];
                    //                [_collectButton setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_downloadingFlg setFrame:CGRectMake(550, 290, 40, 40)];
                    //                [_clockButton setFrame:CGRectMake(460, 290, 40, 40)];
                    //                [_modeBtn setFrame:CGRectMake(370, 290, 40, 40)];
                    [_collectButton setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_downloadingFlg setFrame:CGRectMake(255, 160, 40, 40)];
                    [_clockButton setFrame:CGRectMake(140, 160, 40, 40)];
                    [_modeBtn setFrame:CGRectMake(25, 160, 40, 40)];
                    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
                    //                [_bannerView setFrame:CGRectMake(0.0,
                    //                                                 410,
                    //                                                 GAD_SIZE_320x50.width,
                    //                                                 GAD_SIZE_320x50.height)];
                    //                NSLog(@"myScroll height:%f", self.myScroll.frame.size.height);
                    [_bannerView setHidden:YES];
                    [_containerView setFrame:CGRectMake(3*320, 390 - 84, 320, 40)];//特殊位置83
                    [_myView setFrame:CGRectMake(3*320, 0, 320, 350)];
                    //                [_commTableView setFrame:CGRectMake(0, 0, 320, 350)];
                    [_commTableView setFrame:CGRectMake(0, 0, 320, (_commCellNum*kCommTableHeightPh < 350? _commCellNum*kCommTableHeightPh: 350))];
                }
            }
            
        } else {
            if (kIsLandscapeTest) {
                initMyscrollFrame = CGRectMake(0, 130, 1024, 618+20);
                [_myScroll setFrame:initMyscrollFrame];
                [_myScroll setContentSize:CGSizeMake(3072+1024, 618)];
                [_textScroll setFrame:CGRectMake(2210, 14, 700, 590)];
                [_myImageView setFrame:CGRectMake(162, 14, 700, 400)];
                [_imgWords setFrame:CGRectMake(162, 424, 700, 90)];
                [videoView setFrame:CGRectMake(1109, 39, 700, 450-32)];
                //            initialFrame = CGRectMake(0, frame.origin.y, frame.size.width, frame.size.height+64);
                [_commScroll setFrame:CGRectMake(0, 0, 0, 0)];
                [_modeBtn setFrame:CGRectMake(1893, 79, 70, 70)];
                [_clockButton setFrame:CGRectMake(1893, 229, 70, 70)];
                [_collectButton setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1893, 379, 70, 70)];
                [_explainView setFrame:CGRectMake(212, 400, 600, 150)];
//                [_bannerView setFrame:CGRectMake(148.0f,
//                                                 658,
//                                                 GAD_SIZE_728x90.width,
//                                                 GAD_SIZE_728x90.height)];
                [_bannerView setHidden:YES];
                [_containerView setFrame:CGRectMake(3*1024, 578-44, 1024, 40)];//初次进入。特殊情况534.。。少了44(navBar高度)
                [_myView setFrame:CGRectMake(3*1024, 0, 1024, 578)];
                [_commTableView setFrame:CGRectMake(0, 0, 1024, (_commCellNum*kCommTableHeightPa < 578? _commCellNum*kCommTableHeightPa: 578))];
            } else {
                initMyscrollFrame = CGRectMake(0, 130, 768, 874+20);
                [_myScroll setFrame:initMyscrollFrame];
                [_myScroll setContentSize:CGSizeMake(2304+768, 874)];
                [_textScroll setFrame:CGRectMake(1570, 22, 700, 830)];
                [_myImageView setFrame:CGRectMake(34, 48, 700, 400)];
                [_imgWords setFrame:CGRectMake(134, 496, 500, 240)];
                [videoView setFrame:CGRectMake(802, 42, 700, 450+20)];
                [_commScroll setFrame:CGRectMake(768, 650, 768, 220)];
                [_collectButton setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_downloadingFlg setFrame:CGRectMake(1317, 570, 70, 70)];
                [_clockButton setFrame:CGRectMake(1117, 570, 70, 70)];
                [_modeBtn setFrame:CGRectMake(917, 570, 70, 70)];
                [_explainView setFrame:CGRectMake(184, 600, 400, 200)];
//                [_bannerView setFrame:CGRectMake(20.0,
//                                                 910,
//                                                 GAD_SIZE_728x90.width,
//                                                 GAD_SIZE_728x90.height)];
                [_bannerView setHidden:YES];
//                NSLog(@"_myScroll：%f", _myScroll.frame.size.height);
                [_containerView setFrame:CGRectMake(3*768, 834 - 44, 768, 40)];//初次进入。特殊情况834.。。少了40(navBar高度)
                [_myView setFrame:CGRectMake(3*768, 0, 768, 834)];
                //                [_commTableView setFrame:CGRectMake(0, 0, 320, 300)];
                [_commTableView setFrame:CGRectMake(0, 0, 768, (_commCellNum*kCommTableHeightPa < 834? _commCellNum*kCommTableHeightPa: 834))];
                
//                [_containerView setFrame:CGRectMake(3*768, 874 - 40, 768, 40)];
//                [_myView setFrame:CGRectMake(3*768, 0, 768, 834)];
//                //                [_commTableView setFrame:CGRectMake(0, 0, 320, 300)];
//                [_commTableView setFrame:CGRectMake(0, 0, 768, (_commCellNum*kCommTableHeightPa < 834? _commCellNum*kCommTableHeightPa: 834))];
            }
        }
    }
    
    //保证显示当前content
    CGRect frame = _myScroll.frame;
    frame.origin.x = frame.size.width * _pageControl.currentPage;
    frame.origin.y = 0;
    [_myScroll scrollRectToVisible:frame animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    kPlayerIsExist = YES;
    kNetTest;
    //保证来电打断beginInterruption能被调用
    [[AVAudioSession sharedInstance] setDelegate: self];
    //开启外部控制音频播放
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    
    // Registers the audio route change listener callback function
    // An instance of the audio player/manager is passed to the listener
    AudioSessionAddPropertyListener ( kAudioSessionProperty_AudioRouteChange,
                                     audioRouteChangeListenerCallback, self );
    
    //此种模式下无法播放的同时录音
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    //Activate the audio session
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    
    //进入后台前的提醒
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResignActive:)
     name:UIApplicationWillResignActiveNotification
     object:nil];
    
    
    // Do any additional setup after loading the view from its nib.
    //    timerInValid = YES;
    _isFive = isiPhone5;
    _isFullscreen = NO;
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kBePro];
    _isFree = ![[NSUserDefaults standardUserDefaults] boolForKey:kBePro];
//    _isFree = NO;
    _isiPhone = ![Constants isPad];
    _isFixing = NO;
    _flushList = YES;          
    _isNewComm = NO;
    [[_fixButton layer] setCornerRadius:8.0f];
    [[_fixButton layer] setMasksToBounds:YES];
    
    _playMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"playMode"];
    if (_playMode == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"playMode"];
        _playMode = 1;
    }
    
    _myWord = [[VOAWord alloc]init];
    _listArray = [[NSMutableArray alloc] init];
    _lyricArray = [[NSMutableArray alloc] init];
    _lyricCnArray = [[NSMutableArray alloc] init];
	_timeArray = [[NSMutableArray alloc] init];
	_indexArray = [[NSMutableArray alloc] init];
    _explainView = [[MyLabel alloc]init];
    _explainView.delegate = self;
    _myHighLightWord = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    _lyricLabelArray = [[NSMutableArray alloc] init];
    _lyricCnLabelArray = [[NSMutableArray alloc] init];
    _commArray = [[NSMutableArray alloc]init];
    
    NSArray *myHrsArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    self.hoursArray = myHrsArray;
    [myHrsArray release];
    
    NSArray *myMesArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    self.minsArray = myMesArray;
    [myMesArray release];
    
    NSArray *mySesArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    self.secsArray = mySesArray;
    [mySesArray release];
    
    _myScroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    
//    if (_isiPhone) {
    initMyscrollFrame = CGRectMake(0, 70, 320, 340+20);
    [_myScroll setContentSize:CGSizeMake(1280, 340)];
    
    _textScroll = [[TextScrollView alloc]initWithFrame:CGRectMake(674, 10, 253, 320)];
    [_textScroll setTag:1];
    [_textScroll setDelegate:self];
    
    _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 30, 270, 170)];//图片尺寸
    _imgWords = [[UITextView alloc] initWithFrame:CGRectMake(10, 204, 300, 112)];//描述文字
    [_imgWords setFont:[UIFont systemFontOfSize:(_isiPhone ? 15: 18)]];
    
    
    videoView = [[FGalleryVideoView alloc] initWithFrame:CGRectMake(330, 10, 300, 190+20)];
    videoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    videoView.autoresizesSubviews = YES;
    videoView.videoDelegate = self;
    //    [videoView whenDoubleTapped:^{
    //        NSLog(@"22");
    //        [self toggleFullScreen];
    //        [videoView toggleScreenControls];
    //    }];
//    [_senLabel setFrame:CGRectMake(330, 300, 300, 40)];
    _senLabel = [[MyLabel alloc] initWithFrame:CGRectMake(330, 300, 300, 40)];
//    [_senLabel setText:@"geci"];
    [_senLabel setNumberOfLines:10];
    _senLabel.delegate = self;
    [_senLabel setTag:1010];
    [_senLabel setBackgroundColor:[UIColor clearColor]];
    
    _commScroll = [[TextScrollView alloc] initWithFrame:CGRectMake(320, 300, 320, 40)];
    [_commScroll setBackgroundColor:[UIColor clearColor]];
    
    _collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectButton setImage:[UIImage imageNamed:(_isiPhone ? @"PcollectPressedBBC.png": @"PcollectPressedBBCP.png")] forState:UIControlStateNormal];
    [_collectButton setFrame:CGRectMake(550, 270, 40, 40)];
    [_collectButton addTarget:self action:@selector(collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_collectButton setShowsTouchWhenHighlighted:YES];
    
    _downloadFlg = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadFlg setImage:[UIImage imageNamed:(_isiPhone ? @"downloadedBBC.png": @"downloadedBBCP.png")] forState:UIControlStateNormal];
    [_downloadFlg setFrame:CGRectMake(550, 270, 40, 40)];
    
    _downloadingFlg = [UIButton buttonWithType:UIButtonTypeCustom];
    [_downloadingFlg setImage:[UIImage imageNamed:(_isiPhone ? @"downloadingBBC.png": @"downloadingBBCP.png")] forState:UIControlStateNormal];
    [_downloadingFlg setFrame:CGRectMake(550, 270, 40, 40)];
    
    _clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clockButton setImage:[UIImage imageNamed:(_isiPhone ? @"clockBBC.png": @"clockBBCP.png")] forState:UIControlStateNormal];
    [_clockButton setFrame:CGRectMake(460, 270, 40, 40)];
    [_clockButton addTarget:self action:@selector(showFix:) forControlEvents:UIControlEventTouchUpInside];
    [_clockButton setBackgroundColor:[UIColor clearColor]];
    [_collectButton setShowsTouchWhenHighlighted:YES];
    
    _modeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_modeBtn setImage:[UIImage imageNamed:@"sin.png"] forState:UIControlStateNormal];
    [_modeBtn setFrame:CGRectMake(370, 270, 40, 40)];
    [_modeBtn addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventTouchUpInside];
    [_modeBtn setBackgroundColor:[UIColor clearColor]];
    [_collectButton setShowsTouchWhenHighlighted:YES];
    
    _myView = [[UIView alloc] initWithFrame:CGRectMake((_isiPhone? 320*3: 768*3), 0, (_isiPhone? 320: 768), (_isiPhone?(_isFree? 280: 330): (_isFree? 715: 805)))];
    _commTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, (_isiPhone? 320: 768), (_isiPhone?(_isFree? 280: 330): (_isFree? 715: 805))) style:UITableViewStylePlain];
    [_commTableView setBackgroundColor:[UIColor clearColor]];
    [_commTableView setDelegate:self];
    [_commTableView setDataSource:self];
    //    [inputText setPlaceholder:@"写下您的评论。\"轻松学外语,快乐交朋友\""];
    
    
    [_explainView setFrame:CGRectMake(20, 250, 280, 110)];
//    }
    [_myView addSubview:_commTableView];
    [_commTableView release];
    //    [myView addSubview:inputText];
    [_myScroll addSubview:_myView];
    [_myView release];
    [_myScroll addSubview:_textScroll];
    [_textScroll release];
    [_myScroll addSubview:_myImageView];
    [_myImageView release];
    [_imgWords setEditable:NO];
    [_imgWords setTextColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0]];
    [_imgWords setTextAlignment:UITextAlignmentLeft];
    [_imgWords setBackgroundColor:[UIColor clearColor]];
    [_imgWords setEditable:NO];
    [_myScroll addSubview:_imgWords];
    [_imgWords release];
    [_myScroll addSubview:videoView];
    [videoView release];
    [_myScroll addSubview:_collectButton];
    [_myScroll addSubview:_downloadFlg];
    [_myScroll addSubview:_downloadingFlg];
    [_myScroll addSubview:_clockButton];
    [_myScroll addSubview:_modeBtn];
    
    [_commScroll addSubview:_senLabel];
    [_senLabel release];
    [_myScroll addSubview:_commScroll];
    [_commScroll release];
    
    
    _explainView.tag = 2000;
    _explainView.delegate = self;
    _explainView.layer.cornerRadius = 10.0;
    [_explainView setBackgroundColor:[UIColor colorWithRed:217.0/255 green:241.0/255 blue:253.0/255 alpha:1]];
    [_explainView setAlpha:0.8f];
    
    [_explainView setHidden:YES];
    [self.view addSubview:_explainView];
    [_explainView release];
    
    [_myHighLightWord setHidden:YES];
    [_myHighLightWord setTag:1000];
    [_myHighLightWord setBackgroundColor:[UIColor colorWithRed:1.0/255 green:151.0/255 blue:211.0/255 alpha:1]];
    [_myHighLightWord setAlpha:0.5];
    [self.view addSubview:_myHighLightWord];
    [_myHighLightWord release];
    
    if (_isiPhone) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(3*320, self.myScroll.frame.size.height - 40, 320, 40)];
        
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    } else {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(3*768, self.myScroll.frame.size.height - 40, 768, 40)];
        
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 650, 40)];
    }
    
    _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	_textView.minNumberOfLines = 1;
	_textView.maxNumberOfLines = 6;
    [_textView setText:@"写评论"];
	_textView.returnKeyType = UIReturnKeyNext; //just as an example
	_textView.font = [UIFont systemFontOfSize:15.0f];
	_textView.delegate = self;
    _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    _textView.backgroundColor = [UIColor whiteColor];
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.myScroll addSubview:_containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    if (_isiPhone) {
        entryImageView.frame = CGRectMake(5, 0, 248, 40);
    } else {
        entryImageView.frame = CGRectMake(5, 0, 658, 40);
    }
    
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, _containerView.frame.size.width, _containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [_containerView addSubview:imageView];
    [_containerView addSubview:_textView];
    [_containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(_containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发表" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[_containerView addSubview:doneBtn];
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    if (_isFree) {
        // Create a view of the standard size at the bottom of the screen.
        if (_isiPhone) {
            _bannerView = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(0.0,
                                                    self.view.frame.size.height -
                                                    GAD_SIZE_320x50.height + kFiveAdd,
                                                    GAD_SIZE_320x50.width,
                                                    GAD_SIZE_320x50.height)];
        }else{
            //        bannerView_ = [[GADBannerView alloc]
            //                       initWithFrame:CGRectMake(20.0,
            //                                                self.view.frame.size.height -
            //                                                90,
            //                                                GAD_SIZE_728x90.width,
            //                                                GAD_SIZE_728x90.height)];
            _bannerView = [[GADBannerView alloc]
                           initWithFrame:CGRectMake(20.0,
                                                    self.view.frame.size.height -
                                                    GAD_SIZE_728x90.height,
                                                    GAD_SIZE_728x90.width,
                                                    GAD_SIZE_728x90.height)];
        }
        
        
        // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
        _bannerView.adUnitID = @"a14f752011a39fd";
        
        // Let the runtime know which UIViewController to restore after taking
        // the user wherever the ad goes and add it to the view hierarchy.
        _bannerView.rootViewController = self;
        [self.view addSubview:_bannerView];
        [_bannerView release];
        
        // Initiate a generic request to load it with an ad.
        [_bannerView loadRequest:[GADRequest request]];
        //    [bannerView_ setBackgroundColor:[UIColor blueColor]];
        kNetTest;
        if (!kNetIsExist) {
            _needFlushAdv = YES;
        }
        [_bannerView setHidden:NO];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    //有关外部控制音频播放
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    newFile = NO;
     [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//取消屏幕常亮
    //    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    //    [self resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * 外部控制音频播放所需重置
 */
- (BOOL)canBecomeFirstResponder
{
    return YES;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    //    [self viewResize];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
//    NSLog(@"转");
    kLandscapeTest;
    if (!_isFullscreen) {
        [self viewRorateResize];
    } else {
//        NSLog(@"test");
        [videoView changeSliderFrame];
    }
}

- (NSUInteger)supportedInterfaceOrientations{
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

- (BOOL)shouldAutorotate {
    return YES;//支持转屏
}

#pragma mark - My Method
- (void) playWord:(UIButton *)sender
{
    if (_wordPlayer) {
        [_wordPlayer release];
    }
    _wordPlayer =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:_myWord.audio]];
    [_wordPlayer play];
}

- (void) doSend{
    if ([[_textView text] length] > 0) {
        [self sendComments];
    }
    //    [inputText resignFirstResponder];
    //    if ([keyCommFd isFirstResponder]) {
    [self.view endEditing:YES];
    //    }
    //    NSLog(@"%@",[keyCommFd text]);
}

- (void) addWordPressed:(UIButton *)sender
{
    _nowUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
    //    NSLog(@"生词本添加用户：%d",nowUserId);
    _myWord.userId = _nowUserId;
    if (_nowUserId>0) {
        if ([_myWord alterCollect]) {
            _alert = [[UIAlertView alloc] initWithTitle:kWordTwo message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            
            [_alert setBackgroundColor:[UIColor clearColor]];
            
            [_alert setContentMode:UIViewContentModeScaleAspectFit];
            
            [_alert show];
            
            NSTimer *timer = nil;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(c) userInfo:nil repeats:NO];
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
    [_alert dismissWithClickedButtonIndex:0 animated:YES];
    [_alert release];
}

- (void) showFix:(id)sender
{
    //设置两个View切换时的淡入淡出效果
    [UIView beginAnimations:@"Switch" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    [_fixTimeView setAlpha:0.6];
    [UIView commitAnimations];
}

- (IBAction) doFix:(id)sender
{
    //    [self changeTimer];
    if (_isFixing) {
        _isFixing = NO;
        [_fixButton setTitle:@"开启定时" forState:UIControlStateNormal];
        if (_isiPhone) {
            [_clockButton setImage:[UIImage imageNamed:@"clockBBC.png"] forState:UIControlStateNormal];
        } else {
            [_clockButton setImage:[UIImage imageNamed:@"clockBBCP.png"] forState:UIControlStateNormal];
        }
        
        [self changeTimer];
        //        [myPick selectRow:[myPick selectedRowInComponent:kMinComponent]+1 inComponent:kMinComponent animated:YES];
    } else {
        
        NSString *fixHour = [_hoursArray objectAtIndex:[_myPick selectedRowInComponent:kHourComponent]];
        NSString *fixMinute = [_minsArray objectAtIndex:[_myPick selectedRowInComponent:kMinComponent]];
        NSString *fixSecond = [_minsArray objectAtIndex:[_myPick selectedRowInComponent:kSecComponent]];
        _fixSeconds = ([fixHour intValue]*60 + [fixMinute intValue])*60 + [fixSecond intValue];
        if (_fixSeconds>0) {
            _isFixing = YES;
            [_fixButton setTitle:@"取消定时" forState:UIControlStateNormal];
            if (_isiPhone) {
                [_clockButton setImage:[UIImage imageNamed:@"clockedBBC.png"] forState:UIControlStateNormal];
            } else {
                [_clockButton setImage:[UIImage imageNamed:@"clockedBBCP.png"] forState:UIControlStateNormal];
            }
            
            //            NSLog(@"%@时%@分%@秒--共:%d秒", fixHour, fixMinute,fixSecond,fixSeconds);
            [self changeTimer];
        }
        //        if (fixTimeView.hidden == NO) {
        //            [UIView beginAnimations:@"Switch" context:nil];
        //            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        //            [UIView setAnimationDuration:.5];
        //            [fixTimeView setHidden:YES];
        //            [UIView commitAnimations];
        //        }
    }
}

-(void)changeTimer
{
    //    //时间间隔
    //    NSTimeInterval timeInterval =1.0 ;
    //定时器
    if ([_fixTimer isValid]) {
        [_fixTimer invalidate];
        _fixTimer = nil;
    } else {
        _fixTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                     target:self
                                                   selector:@selector(handleFixTimer)
                                                   userInfo:nil
                                                    repeats:YES];
    }
    
}

-(void) handleFixTimer {
    _fixSeconds--;
    if (_fixSeconds != 0) {
        int sec = [_myPick selectedRowInComponent:kSecComponent];
        int min = [_myPick selectedRowInComponent:kMinComponent];
        int hour = [_myPick selectedRowInComponent:kHourComponent];
        if (sec > 0) {
            [_myPick selectRow:sec-1 inComponent:kSecComponent animated:YES];
        } else {
            if (min > 0) {
                [_myPick selectRow:[self.secsArray count]-1 inComponent:kSecComponent animated:YES];
                [_myPick selectRow:min-1 inComponent:kMinComponent animated:YES];
            } else {
                if (hour > 0) {
                    [_myPick selectRow:[self.secsArray count]-1 inComponent:kSecComponent animated:YES];
                    [_myPick selectRow:[self.minsArray count]-1 inComponent:kMinComponent animated:YES];
                    [_myPick selectRow:hour-1 inComponent:kHourComponent animated:YES];
                }
                /*这句话其实可以不用写，为了保险起见就写了吧，。。*/
                else {
                    if ([videoView isPlaying]) {
                        [videoView pause];
                    }
                    [_myPick selectRow:0 inComponent:kSecComponent animated:YES];
                    [_fixTimer invalidate];
                    _fixTimer = nil;
                    _isFixing = NO;
                    [_fixButton setTitle:@"开启定时" forState:UIControlStateNormal];
                    if (_isiPhone) {
                        [_clockButton setImage:[UIImage imageNamed:@"clockBBC.png"] forState:UIControlStateNormal];
                    } else {
                        [_clockButton setImage:[UIImage imageNamed:@"clockBBCP.png"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    } else {
        if ([videoView isPlaying]) {
            [videoView pause];
        }
        [_myPick selectRow:0 inComponent:kSecComponent animated:YES];
        [_fixTimer invalidate];
        _fixTimer = nil;
        _isFixing = NO;
        [_fixButton setTitle:@"开启定时" forState:UIControlStateNormal];
        if (_isiPhone) {
            [_clockButton setImage:[UIImage imageNamed:@"clockBBC.png"] forState:UIControlStateNormal];
        } else {
            [_clockButton setImage:[UIImage imageNamed:@"clockBBCP.png"] forState:UIControlStateNormal];
        }
        
    }
    
    
}

- (void) changeMode:(UIButton *)sender {
    _playMode = (_playMode + 1 > 3 ? 1 : _playMode + 1);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_playMode] forKey:@"playMode"];
    switch (_playMode) {
        case 1:
            if (_isiPhone) {
                [_modeBtn setImage:[UIImage imageNamed:@"sin.png"] forState:UIControlStateNormal];
            } else {
                [_modeBtn setImage:[UIImage imageNamed:@"sinP.png"] forState:UIControlStateNormal];
            }
            
            [_displayModeBtn setTitle:@"单曲循环" forState:UIControlStateNormal];
            break;
        case 2:
            if (_isiPhone) {
                [_modeBtn setImage:[UIImage imageNamed:@"seq.png"] forState:UIControlStateNormal];
            } else {
                [_modeBtn setImage:[UIImage imageNamed:@"seqP.png"] forState:UIControlStateNormal];
            }
            
            [_displayModeBtn setTitle:@"顺序播放" forState:UIControlStateNormal];
            break;
        case 3:
            if (_isiPhone) {
                [_modeBtn setImage:[UIImage imageNamed:@"ran.png"] forState:UIControlStateNormal];
            } else {
                [_modeBtn setImage:[UIImage imageNamed:@"ranP.png"] forState:UIControlStateNormal];
            }
            
            [_displayModeBtn setTitle:@"随机播放" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [UIView beginAnimations:@"Display" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [_displayModeBtn setAlpha:0.8];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"Dismiss" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2.0];
    [_displayModeBtn setAlpha:0];
    [UIView commitAnimations];
}

- (NSInteger) indexOfArray:(NSMutableArray *) array bbcId:(NSInteger)bbcId
{
//    NSLog(@"列表歌曲数:%i", [array count]);
    NSInteger i = 0;
    for (i = 0; i < [array count]; i++) {
        if ([[array objectAtIndex:i] integerValue] == bbcId) {
            return i;
        }
    }
    return 0;
}

- (void)collectButtonPressed:(UIButton *)sender {
    //    NSLog(@"%d,%@,%@",[voa _voaid],[voa _title],[voa _creatTime]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoDownload"]) {
        [self QueueDownloadVoa];
        [_collectButton setHidden:YES];
        [_downloadFlg setHidden:YES];
        [_downloadingFlg setHidden:NO];
    } else {
        UIAlertView *downAlert = [[UIAlertView alloc] initWithTitle:kPlayTwo message:kPlayThree delegate:self cancelButtonTitle:kFeedbackFive otherButtonTitles:kPlayFour,nil];
        [downAlert setTag:1];
        [downAlert show];
    }
	
}

- (void)shareAll {
    NSString * Message = [NSString stringWithFormat:@"@爱语吧 VOA美语怎么说的话题:%@是极好的,你也来听听吧,瞧瞧有木有",voa._title];
    
    int nowUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
    if (nowUserID > 0) {
        //            [ShareToCNBox showWithText:Message link:[NSString stringWithFormat:@"http://apps.iyuba.com/voa/showItem.jsp?voaId=%d&network=weibo&userId=%d",voa._voaid,nowUserID] titleId:voa._voaid];
        [ShareToCNBox showWithText:Message link:[NSString stringWithFormat:@"http://apps.iyuba.com/minutes/showItem.jsp?network=weibo&BbcId=%d&userId=%d",voa._voaid,nowUserID] titleId:voa._voaid];
    } else {
        [ShareToCNBox showWithText:Message link:[NSString stringWithFormat:@"http://apps.iyuba.com/minutes/showItem.jsp?network=weibo&BbcId=%d",voa._voaid] titleId:voa._voaid];
    }
}

- (void)ShareThisQuestion{
    //    if (isExisitNet) {
    NSString * url = Nil;
    //        url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/showItem.jsp?voaId=%d&network=weibo",voa._voaid];
    int nowUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
    if (nowUserID > 0) {
        url = [NSString stringWithFormat:@"http://apps.iyuba.com/minutes/showItem.jsp?network=weibo&BbcId=%d&userId=%d",voa._voaid,nowUserID];
    } else {
        url = [NSString stringWithFormat:@"http://apps.iyuba.com/minutes/showItem.jsp?network=weibo&BbcId=%d",voa._voaid];
    }
    NSString * time = [[voa._creatTime componentsMatchedByRegex:@"\\S+"] objectAtIndex:0];
    //    NSLog(@"shijian : %@",time);
    NSString * Message = [NSString stringWithFormat:@"爱语吧VOA美语怎么说%@的新闻",time];
    //    NSString * WeiboContent = [NSString stringWithFormat:@"%@%@",Message,url];
    SVShareTool * shareTool = [SVShareTool DefaultShareTool];
    //    [shareTool RenrenLogout];
    //    [self viewWillDisappear:YES];
    // 微博分享：
    //    [shareTool GetScreenshotAndShareOnWeibo:self WithContent:WeiboContent AndDelegate:self];
    
    //人人分享：
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 url,@"url",
                                 Message,@"name",
                                 @"BBC六分钟英语",@"action_name",
                                 kMyWebLink,@"action_link",
                                 (voa._descCn == nil ? [voa._descCn substringToIndex:120] : @"轻松学外语,快了交朋友,一切尽在爱语吧"),@"description",
                                 @"BBC六分钟英语",@"caption",
                                 kMyRenRenImage,@"image",
                                 [NSString stringWithFormat:@"\"%@\"这篇文章-哎呦,不错哦!大家都来听听看,有木有。边听边看读新闻,轻松舒畅学英语", voa._title] ,@"message",
                                 nil];
    //    NSLog(@"param:%@",[params valueForKey:@"action_name"]);
    [shareTool PublishFeedOnRenRen:self WithFeedParam:params TitleId:[NSString stringWithFormat:@"%d",voa._voaid]];
    //    } else {
    //        UIAlertView * alertShare = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"请您确保已连接网络" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //        [alertShare show];
    //        [alertShare release];
    //    }
}

- (IBAction) shareTo:(id)sender {
    if (_isiPhone) {
        UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"分享当前新闻到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网", nil];
        [share showInView:self.view.window];
    } else {
        UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"分享当前新闻到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网", nil];
        [share showInView:self.view];
    }
}

- (IBAction) changeView:(UIButton *)sender {
//    if (sender.tag == 3 && _isFree) {
//        UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:kColFour message:kPlayNine delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [netAlert show];
//        [netAlert release];
//    } else {
        //设置两个View切换时的淡入淡出效果
        [UIView beginAnimations:@"Switch" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.5];
    int deviation = 0;
    if (_RoundBack.center.x<sender.center.x) {
        deviation = 3;
        if (_isiPhone) {
            [_RoundBack setImage:[UIImage imageNamed:@"RoundBack.png"]];

        } else {
            [_RoundBack setImage:[UIImage imageNamed:@"RoundBack-iPad.png"]];

        }
    } else {
        deviation = -2;
        if (_isiPhone) {
            [_RoundBack setImage:[UIImage imageNamed:@"RoundBackTwo.png"]];
        } else {
            [_RoundBack setImage:[UIImage imageNamed:@"RoundBackTwo-iPad.png"]];
        }
        

    }
        [_RoundBack setCenter:CGPointMake(sender.center.x-deviation, sender.center.y)];
        //    CGFloat pageWidth = myScroll.frame.size.width;
        if (![_explainView isHidden]) {
            [_explainView setHidden:YES];
            [_myHighLightWord setHidden:YES];
        }
        /* 下取整直接去掉小数位 */
        int page = sender.tag-1;
        CGRect frame = _myScroll.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        [_myScroll scrollRectToVisible:frame animated:YES];
        
        _pageControl.currentPage = page;
        [UIView commitAnimations];
//    }
    
}

- (IBAction) goBack:(UIButton *)sender
{
    //    if (![explainView isHidden]) {
    //        [explainView setHidden:YES];
    //        [myHighLightWord setHidden:YES];
    //    }
    //    afterRecord = NO;
    //    [self myStopRecord];
    //    [self stopPlayRecord];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)prePlay:(id)sender
{
    CMTime playerProgress = [videoView.player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    [videoView.player seekToTime:CMTimeMakeWithSeconds(progress+2, NSEC_PER_SEC)];
}

- (IBAction)aftPlay:(id)sender
{
    CMTime playerProgress = [videoView.player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    [videoView.player seekToTime:CMTimeMakeWithSeconds(progress-2, NSEC_PER_SEC)];
}

- (void)preparePlay
{
    CMTime playerProgress = [videoView.player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    [videoView.player seekToTime:CMTimeMakeWithSeconds(progress+0.3, NSEC_PER_SEC)];
}

- (void)enableApp
{
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

- (void)disableApp
{
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)enterFullscreen
{
	_isFullscreen = YES;
	[[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade];
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    //    [self.view setBackgroundColor:[UIColor blackColor]];
    
    //	[self disableApp];
    
    //	UIApplication* application = [UIApplication sharedApplication];
    //	if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
    //		[[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade]; // 3.2+
    //	}
    //    else {
    //		[[UIApplication sharedApplication] setStatusBarHidden: YES animated:YES]; // 2.0 - 3.2
    //	}
    //    CGRect rx = [ UIScreen mainScreen ].bounds;
    //    CGRect ry = self.view.window.frame;
    //    NSLog(@"x1:%f  y1:%f %f" , rx.size.width, rx.size.height, rx.origin.y);
    //    NSLog(@"x2:%f  y2:%f %f" , ry.size.width, ry.size.height, ry.origin.y);
	
    
    
    
    //    [self.view setFrame:[ UIScreen mainScreen ].bounds];
    //    [self.view setFrame:CGRectMake(0, -20, 320, 520)];
    //    [_myScroll setFrame:self.view.frame];
    
    
    //    [_myScroll setFrame:self.view.frame];
    //    [self.view.window setBackgroundColor:[UIColor blackColor]];
    //    NSLog(@"x2:%f  y2:%f %f" , videoView.frame.size.width, videoView.frame.size.height, videoView.frame.origin.y);
    
    //	[self.navigationController setNavigationBarHidden:YES animated:YES];
	
}



- (void)exitFullscreen
{
	_isFullscreen = NO;
    
    //	[self disableApp];
    
	UIApplication* application = [UIApplication sharedApplication];
	if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; // 3.2+
	} else {
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO]; // 2.0 - 3.2
	}
    
    //    [self.view setFrame:self.view.window.frame];
    //    [_myScroll setFrame:initMyscrollFrame];
    
    
    //	[self.navigationController setNavigationBarHidden:NO animated:YES];
    
    //	[UIView beginAnimations:@"galleryIn" context:nil];
    //	[UIView setAnimationDelegate:self];
    //	[UIView setAnimationDidStopSelector:@selector(enableApp)];
    //	_toolbar.alpha = 1.0;
    //	_captionContainer.alpha = 1.0;
    //	[UIView commitAnimations];
}

- (void) toggleFullScreen {
    
    if( _isFullscreen == NO ) {
		[_titleView setHidden:YES];
        [_bannerView setHidden:YES];
        [_imgWords setHidden:YES];
        [_btnView setHidden:YES];
        [_btnOne setHidden:YES];
        [_btnTwo setHidden:YES];
        [_btnThree setHidden:YES];
        [_btnFour setHidden:YES];
        [_RoundBack setHidden:YES];
        [_downloadFlg setHidden:YES];
        [_downloadingFlg setHidden:YES];
        [_collectButton setHidden:YES];
        [_clockButton setHidden:YES];
        [_modeBtn setHidden:YES];
        [_senLabel setHidden:YES];
        //        if (kIsLandscapeTest) {
        //            [_myScroll setFrame:CGRectMake(self.view.frame.origin.y, self.view.frame.origin.x, self.view.frame.size.height, self.view.frame.size.width)];
        //        } else {
        [_myScroll setFrame:self.view.frame];
        //        }
        
        
		[self enterFullscreen];
        
        [self.navigationController.view setNeedsLayout];//关键函数 保证界面的整齐
	}
	else {
		[_titleView setHidden:NO];
        [_bannerView setHidden:NO];
        [_imgWords setHidden:NO];
        [_btnView setHidden:NO];
        [_btnOne setHidden:NO];
        [_btnTwo setHidden:NO];
        [_btnThree setHidden:NO];
        [_btnFour setHidden:NO];
        [_RoundBack setHidden:NO];
        if ([VOAFav isCollected:voa._voaid]) {
            [_downloadFlg setHidden:NO];
            [_collectButton setHidden:YES];
            [_downloadingFlg setHidden:YES];
        } else if([VOAView isDownloading:voa._voaid]) {
            [_downloadFlg setHidden:YES];
            [_collectButton setHidden:YES];
            [_downloadingFlg setHidden:NO];
        } else {
            [_downloadFlg setHidden:YES];
            [_collectButton setHidden:NO];
            [_downloadingFlg setHidden:YES];
        }
        [_clockButton setHidden:NO];
        [_modeBtn setHidden:NO];
        [_senLabel setHidden:NO];
        
		[self exitFullscreen];
        [self viewRorateResize];
        [_myScroll setFrame:initMyscrollFrame];
        if (kIsLandscapeTest) {//界面微调
            if (_isiPhone) {
                [_containerView setFrame:CGRectMake(3*kScreenHeight, self.myScroll.frame.size.height - 40, kScreenHeight, 40)];
            } else {
                [_containerView setFrame:CGRectMake(3*1024, self.myScroll.frame.size.height - 40, 1024, 40)];
            }
        
        } else {
            if (_isiPhone) {
                [_containerView setFrame:CGRectMake(3*320, self.myScroll.frame.size.height - 40, 320, 40)];
            } else {
                [_containerView setFrame:CGRectMake(3*768, self.myScroll.frame.size.height - 40, 768, 40)];
            }
        
        }
        
        [self.navigationController.view setNeedsLayout];//关键函数 保证界面的整齐
        
//        NSLog(@"_myScroll:%f  _myScroll:%f %f" , _myScroll.frame.size.width, _myScroll.frame.size.height, _myScroll.frame.origin.y);
//        NSLog(@"_myScroll:%f  _myScroll:%f %f" , _myScroll.contentSize.width, _myScroll.contentSize.height, _myScroll.frame.origin.y);
	}
}

- (void)wordExistDisplay {
    for (UIView *sView in [_explainView subviews]) {
        if (![sView isKindOfClass:[UIImageView class]]) {
            [sView removeFromSuperview];
        }
    }
    
    UIFont *Courier = [UIFont systemFontOfSize:15];
    UIFont *CourierT = [UIFont boldSystemFontOfSize:15];
    UIFont *CourierD = [UIFont systemFontOfSize:18];
    UIFont *CourierTD = [UIFont boldSystemFontOfSize:18];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    UILabel *wordLabel = [[UILabel alloc]init];
    UILabel *pronLabel = [[UILabel alloc]init];
    UITextView *defTextView = [[UITextView alloc] init];
    UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    if (_isiPhone) {
        [addButton setFrame:CGRectMake(3, 0, 35, 35)];
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(40, 5, [_myWord.key sizeWithFont:CourierT].width+10, 20)];
        [pronLabel setFrame:CGRectMake(50+[_myWord.key sizeWithFont:CourierT].width, 5, [[NSString stringWithFormat:@"[%@]", _myWord.pron] sizeWithFont:Courier].width+10, 20)];
        [defTextView setFrame:CGRectMake(0, 30, _explainView.frame.size.width, 80)];
        [audioButton setFrame:CGRectMake(60+[_myWord.key sizeWithFont:CourierT].width + [[NSString stringWithFormat:@"[%@]", _myWord.pron] sizeWithFont:Courier].width, 5, 30, 30)];
        [wordLabel setFont :CourierT];
        [pronLabel setFont :Courier];
        [defTextView setFont :Courier];
    } else {
        [addButton setFrame:CGRectMake(10, 5, 40, 40)];
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(60, 5, [_myWord.key sizeWithFont:CourierTD].width+10, 40)];
        [pronLabel setFrame:CGRectMake(70+[_myWord.key sizeWithFont:CourierTD].width, 5, [[NSString stringWithFormat:@"[%@]", _myWord.pron] sizeWithFont:CourierD].width+10, 40)];
        [defTextView setFrame:CGRectMake(0, 50, _explainView.frame.size.width, 100)];
        [audioButton setFrame:CGRectMake(80+[_myWord.key sizeWithFont:CourierTD].width + [[NSString stringWithFormat:@"[%@]", _myWord.pron] sizeWithFont:CourierD].width, 5, 40, 40)];
        [wordLabel setFont :CourierTD];
        [pronLabel setFont :CourierD];
        [defTextView setFont :CourierD];
    }
    
    //                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    //                [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_explainView addSubview:addButton];
    
    //                UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:Courier].width+10, 20)];
    //                [wordLabel setFont :Courier];
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    [wordLabel setTextColor:[UIColor blackColor]];
    wordLabel.text = _myWord.key;
    wordLabel.backgroundColor = [UIColor clearColor];
    [_explainView addSubview:wordLabel];
    [wordLabel release];
    
    
    
    [pronLabel setTextColor:[UIColor blackColor]];
    [pronLabel setTextAlignment:UITextAlignmentLeft];
    if ([_myWord.pron isEqualToString:@" "]) {
        pronLabel.text = @"";
    }else
    {
        pronLabel.text = [NSString stringWithFormat:@"[%@]", _myWord.pron];
    }
    pronLabel.backgroundColor = [UIColor clearColor];
    [_explainView addSubview:pronLabel];
    [pronLabel release];
    
    if (_wordPlayer) {
        [_wordPlayer release];
    }
    _wordPlayer =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:_myWord.audio]];
    [_wordPlayer play];
    
    
    [audioButton setImage:[UIImage imageNamed:@"wordSound.png"] forState:UIControlStateNormal];
    [audioButton addTarget:self action:@selector(playWord:) forControlEvents:UIControlEventTouchUpInside];
    
    [_explainView addSubview:audioButton];
    
    
    if ([_myWord.def isEqualToString:@" "]) {
        defTextView.text = kPlaySeven;
        //                    NSLog(@"未联网无法查看释义!");
    }else{
        defTextView.text = _myWord.def;
    }
    [defTextView setEditable:NO];
    
    [defTextView setTextColor:[UIColor blackColor]];
    defTextView.backgroundColor = [UIColor clearColor];
    [_explainView addSubview:defTextView];
    [defTextView release];
    //                [explainView setAlpha:1];
    [_explainView setHidden:NO];
}

- (void)wordNoDisplay {
    for (UIView *sView in [_explainView subviews]) {
        if (![sView isKindOfClass:[UIImageView class]]) {
            [sView removeFromSuperview];
        }
    }
    
    UIFont *Courier = [UIFont systemFontOfSize:15];
    UIFont *CourierT = [UIFont boldSystemFontOfSize:15];
    UIFont *CourierD = [UIFont systemFontOfSize:18];
    UIFont *CourierTD = [UIFont boldSystemFontOfSize:18];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    UILabel *wordLabel = [[UILabel alloc]init];
    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, _explainView.frame.size.width, 70)];
    if (_isiPhone) {
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
        [addButton setFrame:CGRectMake(10, 5, 30, 30)];
        [wordLabel setFrame:CGRectMake(30, 5, [_myWord.key sizeWithFont:CourierT].width+10, 30)];
        [wordLabel setFont :CourierT];
        [defLabel setFont :Courier];
    } else {
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
        [addButton setFrame:CGRectMake(10, 5, 40, 40)];
        [wordLabel setFrame:CGRectMake(60, 5, [_myWord.key sizeWithFont:CourierTD].width+10, 40)];
        [wordLabel setFont :CourierTD];
        [defLabel setFont :CourierD];
    }
    
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_explainView addSubview:addButton];
    
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    [wordLabel setTextColor:[UIColor blackColor]];
    wordLabel.text = _myWord.key;
    wordLabel.backgroundColor = [UIColor clearColor];
    [_explainView addSubview:wordLabel];
    [wordLabel release];
    
    defLabel.backgroundColor = [UIColor clearColor];
    [defLabel setTextColor:[UIColor blackColor]];
    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
    [defLabel setNumberOfLines:1];
    defLabel.text = kPlaySix;
    //    NSLog(@"未联网无法查看释义!");
    [_explainView addSubview:defLabel];
    [defLabel release];
    
    [_explainView setHidden:NO];
}

- (void)modalView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//点击确定下载为0，取消为1
        if (alertView.tag == 1) {
            [self QueueDownloadVoa];
            [_collectButton setHidden:YES];
            //            [downloadFlg setHidden:YES];
            //            [downloadingFlg setHidden:NO];
        }
        else if (alertView.tag == 2){
            
            [_myWord alterCollect];
        }else if (alertView.tag == 3)
        {
            LogController *myLog = [[LogController alloc]init];
            [self.navigationController pushViewController:myLog animated:YES];
            [myLog release], myLog = nil;
        }
    }
    [alertView release];
}

#pragma mark - FGalleryVideoViewDelegate
- (void)playerItemDidReachEnd:(FGalleryVideoView *)videoViewOne
{
//    NSLog(@"播完了");
    if (_playMode == 1) {
//        NSLog(@"单曲循环");
        [videoView.player seekToTime:kCMTimeZero];
        //        [videoView.player play];
        videoView.isPlaying = NO;
        [videoView showControls:YES];
        [videoView zeroAfterEnd];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoPlay"]) {
            [videoView.player play];
        }
    } else {
        if (_playMode == 3) {
            NSLog(@"随机循环");
            NSInteger next = arc4random()%[_listArray count];
//            NSLog(@"结束index = %i",next);
            NSInteger playId = [[_listArray objectAtIndex:next] integerValue];
            //                    if (contentMode == 1) {
            //                        voa = [VOAView find:playId];
            //                    } else if (contentMode == 2) {
            voa = [VOAView find:playId];
            //                    }
            _playIndex = [self indexOfArray:_listArray bbcId:voa._voaid] ;
        } else {
            NSLog(@"顺序循环");
            NSLog(@"playIndex = %i; count = %i", _playIndex , [_listArray count]);
            if (_playIndex + 1 == [_listArray count]) {
                
                _playIndex = 0;
            } else {
                _playIndex++;
                //                        NSLog(@"结束index = %i",playIndex);
            }
            NSInteger playId = [[_listArray objectAtIndex:_playIndex] integerValue];
            //                    if (contentMode == 1) {
            //                        voa = [VOAView find:playId];
            //                    } else if (contentMode == 2) {
            voa = [VOAView find:playId];
        }
        //                    }
        
        NSLog(@"顺序循环:%@", voa._title);
        if (contentMode == 1 && ![VOADetail isExist:voa._voaid]) {
            videoView.isPlaying = NO;
            [videoView showControls:YES];
            [videoView zeroAfterEnd];
            
            //            if (![VOADetail isExist:voa._voaid]) {
            //                        NSLog(@"内容不全-%d",voa._voaid);
            [VOADetail deleteByVoaid: voa._voaid];
            //                        NSLog(@"voaid:%i",voa._voaid);
            //                voa._isRead = @"1";
            
            kNetTest;
            if (kNetIsExist) {
                
                [self catchDetails:voa];
            } else {
                UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:kPlayEight message:kNewSix delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [netAlert show];
                [netAlert release];
            }
            
            //            }
        } else {
//            _HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            _HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow ];
            [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
            _HUD.delegate = self;
            _HUD.labelText = @"Loading";
            [_HUD show:YES];
            dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self initialize];
                });
            });
        }
        
    }
}

- (void)didTapVideoView:(FGalleryVideoView*)videoViewOne
{
    [self toggleFullScreen];
    [videoView toggleScreenControls];
    //    NSLog(@"11");
    
    //    if( _isFullscreen == NO ) {
    //
    //		[self enterFullscreen];
    //	}
    //	else {
    //
    //		[self exitFullscreen];
    //	}
}

- (void)playSenID:(NSInteger)senID isEng:(BOOL)isEng{
//    [_lyricArray objectAtIndex:senID-1] stringValue
//    [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:i]]
//    [_senLabel setText:[[_lyricArray objectAtIndex:senID-1] stringValue]];
//    NSLog(@"%@", [_lyricArray objectAtIndex:senID-1]);
//    NSLog(@"换内容");

    [_myHighLightWord setHidden:YES];
    int fontSize = 15;
    if ([Constants isPad]) {
        fontSize = 20;
    }
    
    int mulValueFont = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueFont"];
    if (mulValueFont > 0) {
        fontSize = mulValueFont;
    }
    
    if (_isiPhone) {
        if (isEng) {
            UIFont *Courier = [UIFont systemFontOfSize:fontSize];
            int engHight = [@"a" sizeWithFont:Courier].height;
            //        NSLog(@"height1:%f height2:%f",engHight,[@"a" sizeWithFont:Courier constrainedToSize:CGSizeMake(textScroll.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
            int engLines = [[_lyricArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)] sizeWithFont:Courier constrainedToSize:CGSizeMake(300, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
            //        NSLog(@"engLines:%i", engLines);
            [_commScroll setContentSize:CGSizeMake(320, engLines*engHight)];
            [_senLabel setFrame:CGRectMake(10, 0, 300, engLines*engHight)];
            [_senLabel setText:[[NSString alloc] initWithFormat:@"%@", [_lyricArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)]]];
            [_senLabel setFont:Courier];
        } else {
            UIFont *Courier = [UIFont systemFontOfSize: fontSize - 2];
            float cnHight = [@"赵" sizeWithFont:Courier].height;
            int cnLines = [[_lyricCnArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)] length];
            int cnLineNumber = 300/([@"赵" sizeWithFont:Courier].width-1);//21
            //        NSLog(@"width:%lf,height:%lf",[@" " sizeWithFont:Courier].width,[@" " sizeWithFont:Courier].height);
            //        NSLog(@"闪退textScroll：%f", textScroll.frame.size.width-1);
            //        NSLog(@"闪退*cnLines：%i   cnLineNumber：%i",*cnLines,cnLineNumber);
            if ((cnLines % cnLineNumber)>0) {
                //            NSLog(@"闪退cnLineNumber：%i",cnLineNumber);
                cnLines = (cnLines / cnLineNumber) +1;//35:当前每行所放字母的数目  每个字母9pix n个字母总宽度9*n+1
            }else
            {
                cnLines = cnLines / cnLineNumber;
            }
            
            [_commScroll setContentSize:CGSizeMake(320, cnLines*cnHight)];
            [_senLabel setFrame:CGRectMake(10, 0, 300, cnLines*cnHight)];
            [_senLabel setText:[[NSString alloc] initWithFormat:@"%@", [_lyricCnArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)]]];
            [_senLabel setFont:Courier];
        }
    } else {
        if (isEng) {
            UIFont *Courier = [UIFont systemFontOfSize:fontSize];
            int engHight = [@"a" sizeWithFont:Courier].height;
            //        NSLog(@"height1:%f height2:%f",engHight,[@"a" sizeWithFont:Courier constrainedToSize:CGSizeMake(textScroll.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
            int engLines = [[_lyricArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)] sizeWithFont:Courier constrainedToSize:CGSizeMake(700, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
            //        NSLog(@"engLines:%i", engLines);
            [_commScroll setContentSize:CGSizeMake(768, engLines*engHight)];
            [_senLabel setFrame:CGRectMake(34, 0, 700, engLines*engHight)];
            [_senLabel setText:[[NSString alloc] initWithFormat:@"%@", [_lyricArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)]]];
            [_senLabel setFont:Courier];
        } else {
            UIFont *Courier = [UIFont systemFontOfSize: fontSize - 2];
            float cnHight = [@"赵" sizeWithFont:Courier].height;
            int cnLines = [[_lyricCnArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)] length];
            int cnLineNumber = 700/([@"赵" sizeWithFont:Courier].width-1);//21
            //        NSLog(@"width:%lf,height:%lf",[@" " sizeWithFont:Courier].width,[@" " sizeWithFont:Courier].height);
            //        NSLog(@"闪退textScroll：%f", textScroll.frame.size.width-1);
            //        NSLog(@"闪退*cnLines：%i   cnLineNumber：%i",*cnLines,cnLineNumber);
            if ((cnLines % cnLineNumber)>0) {
                //            NSLog(@"闪退cnLineNumber：%i",cnLineNumber);
                cnLines = (cnLines / cnLineNumber) +1;//35:当前每行所放字母的数目  每个字母9pix n个字母总宽度9*n+1
            }else
            {
                cnLines = cnLines / cnLineNumber;
            }
            
            [_commScroll setContentSize:CGSizeMake(768, cnLines*cnHight)];
            [_senLabel setFrame:CGRectMake(34, 0, 700, cnLines*cnHight)];
            [_senLabel setText:[[NSString alloc] initWithFormat:@"%@", [_lyricCnArray objectAtIndex:(senID-2 > -1 ? senID-2: 0)]]];
            [_senLabel setFont:Courier];
        }
    }
}

#pragma mark - MyLabelDelegate
- (void)touchUpInside: (NSSet *)touches mylabel:(MyLabel *)mylabel {
    int lineHeight = [@"a" sizeWithFont:mylabel.font].height;
    int LineStartlocation = 0;
    if (mylabel.tag == 2000) {
        [_explainView setHidden:YES];
        [_myHighLightWord setHidden:YES];
        return;
    }
    if (![_explainView isHidden]) {
        [_explainView setHidden:YES];
        [_myHighLightWord setHidden:YES];
    }
    if (mylabel.tag == 1010) {
        if (!videoView.isEng) {
            return;
        }
    }
    //    NSLog(@"取词:%@",mylabel.text);
    NSString * WordIFind = nil;
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:mylabel];
    
    int tagetline = ceilf((point.y)/lineHeight);
    //    CGSize maxSize = CGSizeMake(textScroll.frame.size.width, CGFLOAT_MAX);
    CGSize maxSize = CGSizeMake(mylabel.frame.size.width, CGFLOAT_MAX);
    
    NSString * sepratorString = @", ，。.?!:\"“”-()'‘";
    //    NSString * text = @"...idowrhu wpe gre dddd.. 'eow.ei, we u";
    NSCharacterSet * sepratorSet = [NSCharacterSet characterSetWithCharactersInString:sepratorString];
    
    NSArray * splitStr = [mylabel.text componentsSeparatedByCharactersInSet:sepratorSet];
    
    int WordIndex = 0;
    int count = [splitStr count];
    BOOL WordFound = NO;
    NSString * string = @"";
    NSString * string2 = @"";
    
    for (int i = 0; i < count && !WordFound; i++) {
        //        NSLog(@"我在找");
        @try {//??
            string = [string stringByAppendingString:[NSString stringWithFormat:@"%@.",[splitStr objectAtIndex:i]]];
            //            NSString * substr = [mylabel.text substringWithRange:[string length]];
            NSString * substr = [mylabel.text substringWithRange:NSMakeRange(LineStartlocation, ([string length]>[mylabel.text length]?[mylabel.text length]:[string length]))];
            CGSize mysize = [substr sizeWithFont:mylabel.font constrainedToSize:maxSize lineBreakMode:mylabel.lineBreakMode];
            //            NSLog(@"0->mysize.height/lineHeight:%f;tagetline:%d", mysize.height/lineHeight, tagetline);
            if (mysize.height/lineHeight == tagetline && !WordFound) {
                //                LineStartlocation = (([string length] - [[splitStr objectAtIndex:i] length] - 1)>-1?([string length] - [[splitStr objectAtIndex:i] length] - 1):0);
                LineStartlocation = [string length] - [[splitStr objectAtIndex:i] length] - 1;
                for (; i < count; i++) {
                    
                    string2 = [string2 stringByAppendingString:[NSString stringWithFormat:@"%@.",[splitStr objectAtIndex:i]]];
                    NSString * substr2 = nil;
                    @try {
                        //                        substr2 = [mylabel.text substringWithRange:NSMakeRange(LineStartlocation, [string2 length])];
                        substr2 = [mylabel.text substringWithRange:NSMakeRange(LineStartlocation, ([string2 length]>[mylabel.text length]?[mylabel.text length]:[string2 length]))];
                    }
                    @catch (NSException *exception) {
                        
                        return;
                    }
                    
                    CGSize thissize = [substr2 sizeWithFont:mylabel.font constrainedToSize:maxSize lineBreakMode:mylabel.lineBreakMode];
                    if (thissize.height/lineHeight > 1) {
                        return;
                    }
                    
                    //                    if (thissize.width > (readRecord? (isiPhone? point.x-670:point.x-1636):point.x)) {
                    if (thissize.width > point.x) {
                        //                         NSLog(@"找到了");
                        WordIndex = i;
                        WordFound = YES;
                        break;
                    }
                }
            }
        }
        @catch (NSException *exception) {
        }
    }
    if (WordFound) {
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"catchPause"] && [videoView isPlaying]) {
            [videoView pause];
        }
        WordIFind = [splitStr objectAtIndex:WordIndex];
        if ([WordIFind isEqualToString:@""] || WordIFind == nil) {//??
            return ;
        }
        CGFloat pointY = (tagetline -1 ) * lineHeight;
        CGFloat width = [[splitStr objectAtIndex:WordIndex] sizeWithFont:mylabel.font].width;
        
        NSRange Range1 = [string2 rangeOfString:[splitStr objectAtIndex:WordIndex] options:NSBackwardsSearch];
        
        
        NSString * str = [string2 substringToIndex:Range1.location];
        int i = 0;
        while ([[str substringToIndex:i] isEqual:@"."]) {
            str = [str substringFromIndex:i+1];
            i++;
            
        }
        
        CGFloat pointX = [str sizeWithFont:mylabel.font].width;
        //        if (readRecord) {
        //            pointX = [str sizeWithFont:mylabel.font].width;
        //        }
        
        //        if (wordBack) {
        //            [wordBack removeFromSuperview];
        //            wordBack = nil;
        //        }
        
        LocalWord *word = [LocalWord findByKey:WordIFind];
        _myWord.wordId = [VOAWord findLastId]+1;
        if (!_isFree && word) {
//            NSLog(@"找到");
            _myWord.key = word.key;
            _myWord.audio = word.audio;
            _myWord.pron = [NSString stringWithFormat:@"%@",word.pron] ;
            if (_myWord.pron == nil) {
                _myWord.pron = @" ";
            }
            _myWord.def = [[word.def stringByReplacingOccurrencesOfRegex:@"\\s+" withString:@""]stringByReplacingOccurrencesOfString:@"null" withString:@""];
            [word release];
            [self wordExistDisplay];
        } else {
//            NSLog(@"没找到");
            kNetTest;
            if (kNetIsExist) {
                //            NSLog(@"有网");
                [self catchWords:WordIFind];
            } else {
                _myWord.key = WordIFind;
                _myWord.audio = @"";
                _myWord.pron = @" ";
                _myWord.def = @"";
                [self wordNoDisplay];
            }
        }
        //        if (readRecord) {
        CGPoint windowPoint = [mylabel convertPoint:mylabel.bounds.origin toView:self.view];
        [_myHighLightWord setFrame:CGRectMake(windowPoint.x+pointX, windowPoint.y+pointY, width, lineHeight)];
        
        
        [_myHighLightWord setHighlighted:YES];
        [_myHighLightWord setHighlightedTextColor:[UIColor whiteColor]];
        
        [_myHighLightWord setHidden:NO];
        
    }
    
}

- (void)touchUpInsideLong: (NSSet *)touches mylabel:(MyLabel *)mylabel {
    if (![_explainView isHidden]) {
        [_explainView setHidden:YES];
        [_myHighLightWord setHidden:YES];
    }
    
    //    NSLog(@"x:%f, y:%f", windowPoint.x, windowPoint.y);
    if (mylabel.tag > 199 && mylabel.tag < 400) {
        CGPoint windowPoint = [mylabel convertPoint:mylabel.bounds.origin toView:self.view];
        [videoView.player seekToTime:CMTimeMakeWithSeconds([[_timeArray objectAtIndex:mylabel.tag - 200] unsignedIntValue], NSEC_PER_SEC)];
        videoView.sen_num = mylabel.tag - 200 + 1; //###
        //        shareStr = [mylabel text];
        CGRect senRect = [mylabel frame];
        for (UIView *sView in [_textScroll subviews]) {
            if ([sView isKindOfClass:[UIImageView class]]) {
                [sView removeFromSuperview];
            }
        }
        _senImage = [[UIImageView alloc] initWithFrame:senRect];
        
        [_senImage setImage:[LyricSynClass screenshot:CGRectMake(windowPoint.x, windowPoint.y+ 20, senRect.size.width, senRect.size.height)]];
        [_textScroll addSubview:_senImage];
        [_senImage release];
        
        //        for (UIView *sView in [myScroll subviews]) {
        //            if (sView.tag == 1111) {
        //                [sView removeFromSuperview];
        //            }
        //        }
        //        CGPoint scrollPoint = [mylabel convertPoint:mylabel.bounds.origin toView:myScroll];
        //        starImage = [[UIImageView alloc] initWithImage:(isiPhone? [UIImage imageNamed:@"starMy.png"]: [UIImage imageNamed:@"starMyP.png"])];
        //        [starImage setFrame:(isiPhone? CGRectMake(scrollPoint.x+senRect.size.width/2-25, scrollPoint.y+senRect.size.height/2-25, 50, 50): CGRectMake(scrollPoint.x+senRect.size.width/2-40, scrollPoint.y+senRect.size.height/2-40, 80, 80))];
        //        [starImage setAlpha:0.0];
        //        [starImage setTag:1111];
        //        [myScroll addSubview:starImage];
        //        [starImage release];
        
        [UIView beginAnimations:@"SwitchOne" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.5];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 2.0;
        //        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"rippleEffect";
        [[mylabel layer] addAnimation:animation forKey:@"animation"];
        [_senImage setFrame:CGRectMake(senRect.origin.x + senRect.size.width/2, senRect.origin.y + senRect.size.height/2, 1,1)];
        //        [shareSenBtn setFrame:CGRectMake(620, 200, 20, 20)];
        [UIView commitAnimations];
        //        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(starAni) userInfo:nil repeats:NO];
    }
}

#pragma mark - Http connect
- (void)catchDetails:(VOAView *) voaid
{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/textChangSuApi.jsp?voaid=%d&format=xml",voaid._voaid];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"detail"];
    [request setTag:voaid._voaid];
    [request startSynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
    if ([request.username isEqualToString:@"detail"]) {
        kNetDisable;
        UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:kPlayEight message:kNewSix delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [netAlert show];
        [netAlert release];
    } else if ([request.username isEqualToString:@"comment"]) {
        kNetDisable;
        [self.commTableView setFrame:(_isiPhone? CGRectMake(0, 0, 320, 0) : CGRectMake(0, 0, 768, 0))];
    } else if ([request.username isEqualToString:@"BackupVoa"]) {
        [VOAView clearDownload:request.tag];
        UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:kPlayFive message:[NSString stringWithFormat:@"%d.mp4%@", request.tag,kPlayFive] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        if (request.tag == voa._voaid) {
            [_collectButton setHidden:NO];
            [_downloadingFlg setHidden:YES];
            [_downloadFlg setHidden:YES];
        }
        [netAlert show];
        [netAlert release];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request{
//    _isExisitNet = YES;
    //    rightCharacter = NO;
    kNetEnable;
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"detail"]) {
        NSArray *items = [doc nodesForXPath:@"data/voatext" error:nil];
        if (items) {
            voa._isRead = @"1";
            for (DDXMLElement *obj in items) {
                VOADetail *newVoaDetail = [[VOADetail alloc] init];
                newVoaDetail._voaid = request.tag ;
                //                    NSLog(@"id:%d",newVoaDetail._voaid);
                newVoaDetail._paraid = [[[obj elementForName:@"ParaId"] stringValue]integerValue];
                newVoaDetail._idIndex = [[[obj elementForName:@"IdIndex"] stringValue]integerValue];
                newVoaDetail._timing = [[[obj elementForName:@"Timing"] stringValue]integerValue];
                newVoaDetail._sentence = [[[[obj elementForName:@"Sentence"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"]stringByReplacingOccurrencesOfString:@"<b>" withString:@""];
                newVoaDetail._imgWords = [[[obj elementForName:@"ImgWords"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"];
                newVoaDetail._imgPath = [[obj elementForName:@"ImgPath"] stringValue];
                newVoaDetail._sentence_cn = [[[[[obj elementForName:@"sentence_cn"] stringValue]stringByReplacingOccurrencesOfString:@"\"" withString:@"”"] stringByReplacingOccurrencesOfString:@"<b>" withString:@""] stringByReplacingOccurrencesOfString:@"</b>" withString:@""];
                if ([newVoaDetail insert]) {
                    //                        NSLog(@"插入%d成功",newVoaDetail._voaid);
                }
                [newVoaDetail release],newVoaDetail = nil;
            }
            
        }
        [doc release],doc = nil;
//        _HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
//        [self.view.window addSubview:_HUD];
        _HUD = [[MBProgressHUD alloc] initWithWindow:[UIApplication sharedApplication].keyWindow ];
        [[UIApplication sharedApplication].keyWindow addSubview:_HUD];
        _HUD.delegate = self;
        _HUD.labelText = @"Loading";
        [_HUD show:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self initialize];
            });
        });
    } else if ([request.username isEqualToString:@"comment" ]) {
        /////解析
        NSArray *items = [doc nodesForXPath:@"response" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                _nowPage = [[[obj elementForName:@"pageNumber"] stringValue] integerValue] ;
                
                //                NSLog(@"pageNumber:%d",pageNumber);
                
                
                if (_nowPage == 1) {
                    [_commArray removeAllObjects];
                    //                    NSInteger commcount = [[[obj elementForName:@"counts"] stringValue] integerValue] ;
                    _totalPage = [[[obj elementForName:@"totalPage"] stringValue] integerValue] ;
                    //                    NSLog(@"commcount:%d",commcount);
                    //                    commArray = [[NSMutableArray alloc]initWithCapacity:4*commcount];
                    //                    struct comment comms[commNumber];
                }
            }
        }
        items = [doc nodesForXPath:@"response/row" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                [_commArray addObject:[[obj elementForName:@"userName"] stringValue]];
                //                NSLog(@"userName:%@",[[obj elementForName:@"userName"] stringValue]);
                [_commArray addObject:[[obj elementForName:@"imgSrc"] stringValue]];
                [_commArray addObject:[[obj elementForName:@"shuoShuo"] stringValue]];
                [_commArray addObject:[[obj elementForName:@"createDate"] stringValue]];
                //                comms[commNumber].userName = [[obj elementForName:@"userName"] stringValue];
                //                VOAView *newVoa = [[VOAView alloc] init];
                //                newVoa._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                //                if (lastId<newVoa._voaid) {
                //                    lastId = newVoa._voaid;
                //                }
            }
        }
        //         NSLog(@"评论数：%i---表高:%f", [commArray count], [commArray count]*kCommTableHeightPh);
        _commCellNum = [_commArray count]/4;
        if(kIsLandscapeTest) {
            if (_isiPhone) { //动态改变表的大小，防止背景出现灰色
                if (_commCellNum<(_isFree?3 :4)) {
                    [self.commTableView setFrame:CGRectMake(0, 0, kScreenHeight, _commCellNum*kCommTableHeightPh)];
                    //                NSLog(@"表高:%f", [commArray count]/4*kCommTableHeightPh);
                }
                else {
                    [self.commTableView setFrame:CGRectMake(0, 0, kScreenHeight, (_isFree?140:190))];
                }
            } else {
                if (_commCellNum<(_isFree? 7: 8)) {
                    [self.commTableView setFrame:CGRectMake(0, 0, 1024, _commCellNum*kCommTableHeightPa)];
                    //                NSLog(@"表高:%f", [commArray count]/4*80.0f);
                }
                else {
                    [self.commTableView setFrame:CGRectMake(0, 0, 1024, (_isFree?488:578))];
                }
            }
        } else {
            if (_isiPhone) { //动态改变表的大小，防止背景出现灰色
                if (_commCellNum<(_isFree?(_isFive?7:6):(_isFive?8:6))) {
                    [self.commTableView setFrame:CGRectMake(0, 0, 320, _commCellNum*kCommTableHeightPh)];
                    //                NSLog(@"表高:%f", [commArray count]/4*kCommTableHeightPh);
                }
                else {
                    [self.commTableView setFrame:CGRectMake(0, 0, 320, (_isFree?300:350) + kFiveAdd)];
                }
            } else {
                if (_commCellNum<(_isFree? 10: 11)) {
                    [self.commTableView setFrame:CGRectMake(0, 0, 768, _commCellNum*kCommTableHeightPa)];
                    //                NSLog(@"表高:%f", [commArray count]/4*80.0f);[_commArray count]/4
                }
                else {
                    [self.commTableView setFrame:CGRectMake(0, 0, 768, (_isFree?740:834))];
                }
            }
        }
        
        [_commTableView reloadData];
        if (_isNewComm) {
            [self.commTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            _isNewComm = NO;
        }

        [doc release], doc = nil;
    } else if ([request.username isEqualToString:@"send" ]) {
        //        [commArray removeAllObjects];
        _isNewComm = YES;
        //        NSLog(@"1111");
        [_textView setText:@""];
        [self catchComments:1];
        [doc release], doc = nil;
    } else if ([request.username isEqualToString:@"BackupVoa"]) {
        kNetEnable;
        NSData *responseData = [request responseData];
        //    if ([request.username isEqualToString:@"sound"]) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //创建audio份目录在Documents文件夹下，not to back up
        NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];
        NSFileManager *fm = [NSFileManager defaultManager];
        _userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4", request.tag]];
        
        NSLog(@"备份服务器下载完成");
        if ([fm createFileAtPath:_userPath contents:responseData attributes:nil]) {
        }
        if (request.tag == voa._voaid) {
            _localFileExist = YES;
            _downloaded = YES;
            //            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"recordRead"]) {
            [_downloadFlg setHidden:NO];
            //            }
            [_collectButton setHidden:YES];
            [_downloadingFlg setHidden:YES];
        }
        [VOAFav alterCollect:request.tag];
        if (contentMode == 2 && _playMode == 3) {
            _flushList = YES;
        }
        [fm release];
        [VOAView clearDownload:request.tag];
        
    }
}

- (void)QueueDownloadVoa
{
    //    NSLog(@"Queue 预备: %d",voa._voaid);
    NSOperationQueue *myQueue = [PlayerViewController sharedQueue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.iyuba.com/video/voa/%i.mp4", voa._voaid]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    //    if (request.tag == voa._voaid) {
    [_downloadFlg setHidden:YES];
    [_collectButton setHidden:YES];
    [_downloadingFlg setHidden:NO];
    //    }
    [request setDelegate:self];
    //    [request setUsername:@"sound"];
    [request setTag:voa._voaid];
    [request setDidStartSelector:@selector(requestSoundStarted:)];
    [request setDidFinishSelector:@selector(requestSoundDone:)];
    [request setDidFailSelector:@selector(requestSoundWentWrong:)];
    [myQueue addOperation:request]; //queue is an NSOperationQueue
    
}

- (void)catchBackupVoa:(NSInteger) voaid
{
    NSString *url = [NSString stringWithFormat:@"http://video.iyuba.com/voa/%i.mp4", voaid];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"BackupVoa"];
    [request setTag:voaid];
    [request startAsynchronous];
}

- (void)requestSoundStarted:(ASIHTTPRequest *)request
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //创建audio份目录在Documents文件夹下，not to back up
	NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];;
    _userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d.mp4", request.tag]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:_userPath]) {
        [request cancel];
    }
    
    [VOAView alterDownload:request.tag];
    //    if (request.tag == voa._voaid) {
    //        [downloadFlg setHidden:YES];
    //        [collectButton setHidden:YES];
    //        [downloadingFlg setHidden:NO];
    //    }
    //    NSLog(@"Queue 开始: %d",request.tag);
}

- (void)requestSoundDone:(ASIHTTPRequest *)request{
//    _isExisitNet = YES;
    kNetEnable;
    NSData *responseData = [request responseData];
    //    if ([request.username isEqualToString:@"sound"]) {
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //创建audio份目录在Documents文件夹下，not to back up
    NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];
    NSFileManager *fm = [NSFileManager defaultManager];
    _userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp4", request.tag]];
    
    //    NSLog(@"requestFinished。大小：%d", [responseData length]);
    if ([fm createFileAtPath:_userPath contents:responseData attributes:nil]) {
    }
    if (request.tag == voa._voaid) {
        _localFileExist = YES;
        _downloaded = YES;
        //            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"recordRead"]) {
        [_downloadFlg setHidden:NO];
        //            }
        [_collectButton setHidden:YES];
        [_downloadingFlg setHidden:YES];
    }
    [VOAFav alterCollect:request.tag];
    if (contentMode == 2 && _playMode == 3) {
        _flushList = YES;
    }
    [fm release];
    [VOAView clearDownload:request.tag];
    //    }
}

- (void)requestSoundWentWrong:(ASIHTTPRequest *)request
{
    [self catchBackupVoa:request.tag];
    //    if ([request.username isEqualToString:@"sound"]) {
//    [VOAView clearDownload:request.tag];
//    UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:kPlayFive message:[NSString stringWithFormat:@"%d.mp4%@", request.tag,kPlayFive] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    if (request.tag == voa._voaid) {
//        [_collectButton setHidden:NO];
//        [_downloadingFlg setHidden:YES];
//        [_downloadFlg setHidden:YES];
//    }
//    [netAlert show];
//    [netAlert release];
}

//- (void)catchNetA
//{
//    //    NSString *url = @"http://www.baidu.com";
//    //    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    //    request.delegate = self;
//    //    [request setUsername:@"catchnet"];
//    //    [request startAsynchronous];
//    
//    NSOperationQueue *myQueue = [PlayerViewController sharedQueue];
//    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    [request setDelegate:self];
//    [request setUsername:@"catchnet"];
//    //    [request setDidStartSelector:@selector(requestStarted:)];
//    [request setDidFinishSelector:@selector(requestDone:)];
//    [request setDidFailSelector:@selector(requestWentWrong:)];
//    [myQueue addOperation:request]; //queue is an NSOperationQueue
//}

- (void)catchWords:(NSString *) word
{
    NSOperationQueue *myQueue = [PlayerViewController sharedQueue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://word.iyuba.com/words/apiWord.jsp?q=%@",word]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setUsername:word];
    //    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [myQueue addOperation:request]; //queue is an NSOperationQueue
}

- (void)catchComments:(NSInteger)pages{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/updateShuoShuo.jsp?groupName=iyuba&mod=select&topicId=%i&pageNumber=%i&pageCounts=15",voa._voaid,pages];
    //    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"comment"];
    [request startAsynchronous];
}

- (void)sendComments{
    
    NSInteger uid = [[NSUserDefaults standardUserDefaults] integerForKey:@"nowUser"];
    //    NSLog(@"$$$:%d", uid);
    if (uid>0) {
        NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/updateShuoShuo.jsp?userId=%i&groupName=ios&mod=insert&topicId=%i&comment=%@",uid, voa._voaid, [[_textView text] URLEncodedString]];
        //        ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
        ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
        request.delegate = self;
        [request setUsername:@"send"];
        [request startAsynchronous];
    } else {
        LogController *myLog = [[LogController alloc]init];
        [self.navigationController  pushViewController:myLog animated:YES];
        
        //        id nextResponder = [self.view nextResponder];
        //        UIView *test = [[UIView alloc] init];
        //        tes
        //        [[(UIView *)self.view firstViewController:self.view] presentModalViewController:myLog animated:YES];
        [myLog release];
        //        PlayViewController *player = [PlayViewController sharedPlayer];
        //        [player.navigationController pushViewController:myLog animated:YES];
    }
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
//    _isExisitNet = NO;
    kNetDisable;
    if ([request.username isEqualToString:@"catchnet"]) {
        //        NSLog(@"有网络");
        return;
    }
    [_myWord init];
    _myWord.wordId = [VOAWord findLastId]+1;
    _myWord.checks = 0;
    _myWord.remember = 0;
    _myWord.key = request.username;
    _myWord.audio = @"";
    _myWord.pron = @" ";
    _myWord.def = @"";
    _myWord.userId = _nowUserId;
    for (UIView *sView in [_explainView subviews]) {
        if (![sView isKindOfClass:[UIImageView class]]) {
            [sView removeFromSuperview];
        }
    }
    UIFont *Courier = [UIFont systemFontOfSize:15];
    UIFont *CourierT = [UIFont boldSystemFontOfSize:15];
    UIFont *CourierD = [UIFont systemFontOfSize:18];
    UIFont *CourierTD = [UIFont boldSystemFontOfSize:18];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    UILabel *wordLabel = [[UILabel alloc]init];
    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, _explainView.frame.size.width, 70)];
    if (_isiPhone) {
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
        [addButton setFrame:CGRectMake(10, 5, 30, 30)];
        [wordLabel setFrame:CGRectMake(40, 5, [_myWord.key sizeWithFont:CourierT].width+10, 30)];
        [wordLabel setFont :CourierT];
        [defLabel setFont :Courier];
    } else {
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
        [addButton setFrame:CGRectMake(10, 5, 40, 40)];
        [wordLabel setFrame:CGRectMake(60, 5, [_myWord.key sizeWithFont:CourierTD].width+10, 40)];
        [wordLabel setFont :CourierTD];
        [defLabel setFont :CourierD];
    }
    
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [_explainView addSubview:addButton];
    
    
    
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    [wordLabel setTextColor:[UIColor blackColor]];
    wordLabel.text = _myWord.key;
    wordLabel.backgroundColor = [UIColor clearColor];
    [_explainView addSubview:wordLabel];
    [wordLabel release];
    
    
    
    defLabel.backgroundColor = [UIColor clearColor];
    [defLabel setTextColor:[UIColor blackColor]];
    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
    [defLabel setNumberOfLines:1];
    defLabel.text = kPlaySix;
    //    NSLog(@"未联网无法查看释义!");
    [_explainView addSubview:defLabel];
    [defLabel release];
    //    [explainView setAlpha:1];
    
    [_explainView setHidden:NO];
}

- (void)requestDone:(ASIHTTPRequest *)request{
//    _isExisitNet = YES;
    kNetEnable;
    if ([request.username isEqualToString:@"catchnet"]) {
        //        NSLog(@"有网络");
        return;
    }
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];;
    [_myWord init];
    int result = 0;
    NSArray *items = [doc nodesForXPath:@"data" error:nil];
    if (items) {
        for (DDXMLElement *obj in items) {
            _myWord.wordId = [VOAWord findLastId]+1;
            _myWord.checks = 0;
            _myWord.remember = 0;
            _myWord.userId = _nowUserId;
            result = [[obj elementForName:@"result"] stringValue].intValue;
            if (result) {
                _myWord.key = [[obj elementForName:@"key"] stringValue];
                _myWord.audio = [[obj elementForName:@"audio"] stringValue];
                _myWord.pron = [[obj elementForName:@"pron"] stringValue];
                if (_myWord.pron == nil) {
                    _myWord.pron = @" ";
                }
                _myWord.def = [[[[obj elementForName:@"def"] stringValue] stringByReplacingOccurrencesOfRegex:@"\\s+" withString:@""]stringByReplacingOccurrencesOfString:@"null" withString:@""];
                [self wordExistDisplay];
                
            }else
            {
                _myWord.key = request.username;
                _myWord.audio = @"";
                _myWord.pron = @" ";
                _myWord.def = @"";
                [self wordNoDisplay];
                
            }
        }
    }
    [doc release];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://新浪微博
            // 微博分享：
            [self shareAll];
            break;
        case 1:
            //人人分享：
            [self ShareThisQuestion];
            break;
        default:
            break;
    }
}

#pragma mark - Picker Data Source Methods
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == kHourComponent?[self.hoursArray count]:(component == kMinComponent?[self.minsArray count]:[self.secsArray count]);
}

#pragma mark - Picker Delegate Methods
- (NSString *) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return component == kHourComponent?[self.hoursArray objectAtIndex:row]:(component == kMinComponent?[self.minsArray objectAtIndex:row]:[self.secsArray objectAtIndex:row]);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    [self.view endEditing:YES];
    if (![_explainView isHidden]) {
        [_explainView setHidden:YES];
        [_myHighLightWord setHidden:YES];
    }
}

#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
    return ([_commArray count]/4 + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (row == [_commArray count]/4) {
        static NSString *ThirdLevelCell= @"NewCellTwo";
        UITableViewCell *cellThree = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ThirdLevelCell];
        if (!cellThree) {
            cellThree = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ThirdLevelCell] autorelease];
        }
        [cellThree setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cellThree setHidden:YES];
        if (_nowPage < _totalPage) {
            [self catchComments:++_nowPage];
        }
        return cellThree;
    } else {
        UIFont *Courier = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:12];
        UIFont *CourierF = [UIFont systemFontOfSize:12];
        UIFont *Couriera = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:15];
        UIFont *CourieraF = [UIFont systemFontOfSize:15];
        static NSString *FirstLevelCell= @"CommentCell";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        if (!cell) {
            if (_isiPhone) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell] autorelease];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 120, 15)];
                [nameLabel setBackgroundColor:[UIColor clearColor]];
                [nameLabel setFont:Courier];
                [nameLabel setTag:1];
                [nameLabel setTextColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
                [nameLabel setNumberOfLines:2];
                [cell addSubview:nameLabel];
                [nameLabel release];
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 65, 15)];
                [dateLabel setBackgroundColor:[UIColor clearColor]];
                [dateLabel setFont:CourierF];
                [dateLabel setTag:2];
                [dateLabel setTextColor:[UIColor colorWithRed:0.492f green:0.608f blue:0.48f alpha:1.0f]];
                [dateLabel setNumberOfLines:2];
                [cell addSubview:dateLabel];
                [dateLabel release];
                
                UILabel *comLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 15, 240, 45)];
                [comLabel setBackgroundColor:[UIColor clearColor]];
                [comLabel setFont:CourierF];
                [comLabel setTag:3];
                [comLabel setTextColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0f]];
                [comLabel setNumberOfLines:4];
                [comLabel setLineBreakMode:UILineBreakModeWordWrap];
                [cell addSubview:comLabel];
                [comLabel release];
            }else {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell] autorelease];
                
                UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 120, 20)];
                [nameLabel setBackgroundColor:[UIColor clearColor]];
                [nameLabel setFont:Couriera];
                [nameLabel setTag:1];
                [nameLabel setTextColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
                [nameLabel setNumberOfLines:2];
                [cell addSubview:nameLabel];
                [nameLabel release];
                
                UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(648, 0, 120, 20)];
                [dateLabel setBackgroundColor:[UIColor clearColor]];
                [dateLabel setFont:CourieraF];
                [dateLabel setTag:2];
                [dateLabel setTextColor:[UIColor colorWithRed:0.492f green:0.608f blue:0.48f alpha:1.0f]];
                [dateLabel setNumberOfLines:2];
                [cell addSubview:dateLabel];
                [dateLabel release];
                
                UILabel *comLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 20, 648, 60)];
                [comLabel setBackgroundColor:[UIColor clearColor]];
                [comLabel setFont:CourieraF];
                [comLabel setTag:3];
                [comLabel setTextColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0f]];
                [comLabel setNumberOfLines:4];
                [comLabel setLineBreakMode:UILineBreakModeWordWrap];
                [cell addSubview:comLabel];
                [comLabel release];
            }
        }
        for (UIView *nLabel in [cell subviews]) {
            if (nLabel.tag == 1) {
                [(UILabel*)nLabel setText:[_commArray objectAtIndex:row*4]];
            }
            if (nLabel.tag == 2) {
                [(UILabel*)nLabel setText:[_commArray objectAtIndex:row*4+3]];
            }
            if (nLabel.tag == 3) {
                [(UILabel*)nLabel setText:[_commArray objectAtIndex:row*4+2]];
            }
        }
        
        [cell.imageView setImageWithURL:[_commArray objectAtIndex:row*4+1] placeholderImage:[UIImage imageNamed:@"acquiesce.png"]];
//        NSLog(@"%@",[_commArray objectAtIndex:row*4+1]);
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    //    }
    
    return nil;
}

#pragma mark -
#pragma mark TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([indexPath row] < [_commArray count]/4 ? (_isiPhone?kCommTableHeightPh:kCommTableHeightPa) : 1);
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    if ([keyCommFd isFirstResponder]) {
    [self.view endEditing:YES];
    //    }
    if (![_explainView isHidden]) {
        [_explainView setHidden:YES];
        [_myHighLightWord setHidden:YES];
    }
}

#pragma mark - HPGrowingTextViewDelegate
//-(void)resignTextView
//{
//	[textView resignFirstResponder];
//}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
//    NSLog(@"键盘出");
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.myScroll convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.myScroll.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height) - (_isiPhone? (_isFree? -50:(_keyboardFlg? (kIsLandscapeTest? 52:64): 20.0f)): (_isFree?-90:(_keyboardFlg?64:20)));
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    //    [UIView setAnimationCurve:[curve intValue]];(_keyboardFlg? (kIsLandscapeTest? 2:14): 0)
	
	// set views with new info
	_containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = _containerView.frame;
    containerFrame.origin.y = self.myScroll.bounds.size.height - containerFrame.size.height - (_isFree? ([Constants isPad]&&!kIsLandscapeTest?4:0):([Constants isPad]? (_keyboardFlg?64:20):(_keyboardFlg? (kIsLandscapeTest? 52:64): 20)));
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    //    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	_containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = _containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	_containerView.frame = r;
}

- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView {
    int nowUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
    if ([[growingTextView text] isEqualToString:@"写评论"]) {
        [growingTextView setText:@""];
    }
    if (nowUserID > 0) {
        if ([[growingTextView text] length] > 0) {
            [self sendComments];
        }
    } else {
        [growingTextView setText:@""];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    //    NSLog(@"touch");
    if (_fixTimeView.alpha > 0.5) {
        [UIView beginAnimations:@"Switch" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.5];
        [_fixTimeView setAlpha:0];
        [UIView commitAnimations];
    }
    
    if (![_explainView isHidden]) {
        [_explainView setHidden:YES];
        [_myHighLightWord setHidden:YES];
    }
}

#pragma mark - AVAudioSessionDelegate
- (void)beginInterruption
{
//    NSLog(@"beginInterruption");
    //    if (localFileExist) {
    [videoView pause];
}

#pragma mark - Background Player Control
/**
 * 接受外部音频控制
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {
    if (event.type == UIEventTypeRemoteControl) {
        
        switch (event.subtype) {
                
            case UIEventSubtypeRemoteControlTogglePlayPause:
                if ([videoView isPlaying]) {
                    [videoView pause];
                } else {
                    [videoView play];
                }
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
//                NSLog(@"上一篇");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                //                [self aftPlay:nextButton];
//                NSLog(@"下一篇");
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark background
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
//    NSLog(@"EnterBackground");
    if ([videoView isPlaying]) {
        [videoView pause];
    }
    
    //    [lyricSynTimer invalidate];
    //    [sliderTimer invalidate];
    //    PlayViewController *play = [PlayViewController sharedPlayer];
    //    [play stopRecord];
    //    NSLog(@"appplicationWillResignActive");
    ////    [controller stopRecord];
    ////    [controller myStopRecord];
    //    if ([controller isRecording]) {
    ////        controller.recorder->StopRecord();
    //        [controller stopRecord];
    //    }
    //    controller.recorder->StopRecord();
}

#pragma mark - Motion
/*
 * 检测振动，控制播放
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    //    NSLog(@"%d",[[NSUserDefaults standardUserDefaults] boolForKey:@"shakeCtrlPlay"]);
    if ((motion == UIEventSubtypeMotionShake)&&([[NSUserDefaults standardUserDefaults] boolForKey:@"shakeCtrlPlay"]))
    {
        if ([videoView isPlaying]) {
            [videoView pause];
        } else {
            [videoView play];
        }
    }
}

#pragma mark AudioSession listeners
void audioRouteChangeListenerCallback (void *                  inClientData,
                                       AudioSessionPropertyID	inID,
                                       UInt32                  inDataSize,
                                       const void *            inData)
{
    PlayerViewController *THIS = (PlayerViewController*)inClientData;
	if (inID == kAudioSessionProperty_AudioRouteChange)
	{
		CFDictionaryRef routeDictionary = (CFDictionaryRef)inData;
		//CFShow(routeDictionary);
		CFNumberRef reason = (CFNumberRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
		SInt32 reasonVal;
		CFNumberGetValue(reason, kCFNumberSInt32Type, &reasonVal);
		if (reasonVal != kAudioSessionRouteChangeReason_CategoryChange)
		{
			/*CFStringRef oldRoute = (CFStringRef)CFDictionaryGetValue(routeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_OldRoute));
             if (oldRoute)
             {
             printf("old route:\n");
             CFShow(oldRoute);
             }
             else
             printf("ERROR GETTING OLD AUDIO ROUTE!\n");
             
             CFStringRef newRoute;
             UInt32 size; size = sizeof(CFStringRef);
             OSStatus error = AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &size, &newRoute);
             if (error) printf("ERROR GETTING NEW AUDIO ROUTE! %d\n", error);
             else
             {
             printf("new route:\n");
             CFShow(newRoute);
             }*/
            
			if (reasonVal == kAudioSessionRouteChangeReason_OldDeviceUnavailable)//拔耳机时响应
			{
                //                NSLog(@"插拔耳机");
                [THIS.videoView pause];
                //                [THIS.videoView.playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
                
                //				if (![THIS.videoView isPlaying]) {
                //                    [THIS.videoView.playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
                ////                    _isPlaying = NO;
                ////					[THIS pausePlayQueue];
                ////					[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:THIS];
                //				}
			}
            
            //			// stop the queue if we had a non-policy route change
            //			if (THIS->recorder->IsRunning()) {
            //				[THIS stopRecord];
            //			}
		}
	}
    //	else if (inID == kAudioSessionProperty_AudioInputAvailable)
    //	{
    //		if (inDataSize == sizeof(UInt32)) {
    //			UInt32 isAvailable = *(UInt32*)inData;
    //			// disable recording if input is not available
    //			THIS->btn_record.enabled = (isAvailable > 0) ? YES : NO;
    //		}
    //	}
}


@end