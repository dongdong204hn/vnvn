//
//  PlayerViewController.h
//  AEHTS
//
//  Created by zhao song on 12-10-31.
//  Copyright (c) 2012年 zhao song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VOAView.h"
#import "FGalleryVideoView.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import "timeSwitchClass.h"
#import "MyUIViewController.h"
#import "GADBannerView.h"
#import "TextScrollView.h"
#import "MyPageControl.h"
#import "MyLabel.h"
#import "DataBaseClass.h"
#import "LyricSynClass.h"
#import "LocalWord.h"
#import "VOAWord.h"
#import "ASIFormDataRequest.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "ShareToCNBox.h"
#import "SVShareTool.h"
#import "LogController.h"
#import "VOADetail.h"
#import "HPGrowingTextView.h"//评论的自动放大的输入框
#import "NSString+URLEncoding.h"
//#import "MBProgressHUD.h"

#define kHourComponent 0
#define kMinComponent 1
#define kSecComponent 2
#define kCommTableHeightPh 60.0
#define kCommTableHeightPa 80.0
#define kIphoneWidth 480.0
#define kIphone5Width 568.0
#define kAddOne 88.0
#define kAddTwo 44.0
#define kAddThree 22.0

@interface PlayerViewController : UIViewController <FGalleryVideoViewDelegate, MyLabelDelegate, ASIHTTPRequestDelegate,UIActionSheetDelegate, MBProgressHUDDelegate,UIPickerViewDelegate,UIPickerViewDataSource,AVAudioSessionDelegate,UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,HPGrowingTextViewDelegate>{
    VOAView *voa;
    
//    UIImageView *thumbnailImg;
    
    FGalleryVideoView *videoView;
    
    CGRect initMyscrollFrame;
//    UILabel			*totalTimeLabel;//总时间
//	UILabel			*currentTimeLabel;//当前时间
    
//    UISlider		*timeSlider;
    
//    NSTimer			*sliderTimer;
    
    BOOL _isPlaying;
    
    BOOL _isFullscreen;
    
    BOOL newFile;
    
//    BOOL timerInValid;
    
    NSString *caption;
    
    NSInteger contentMode;
    
    UIButton *pre;
    
    UIButton *aft;
    
    
}
//@property (nonatomic, retain) IBOutlet UISlider		*timeSlider;

//@property (nonatomic, retain) IBOutlet UILabel			*totalTimeLabel;
//@property (nonatomic, retain) IBOutlet UILabel			*currentTimeLabel;//当前时间
@property (nonatomic, retain) IBOutlet UIButton *pre;
@property (nonatomic, retain) IBOutlet UIButton *aft;
@property (nonatomic, retain) IBOutlet UIImageView *RoundBack;
@property (nonatomic, retain) IBOutlet UIView *fixTimeView;
@property (nonatomic, retain) IBOutlet UIPickerView *myPick;
@property (nonatomic, retain) IBOutlet UIButton  *fixButton;
@property (nonatomic, retain) IBOutlet UIButton *btnOne;
@property (nonatomic, retain) IBOutlet UIButton *btnTwo;
@property (nonatomic, retain) IBOutlet UIButton *btnThree;
@property (nonatomic, retain) IBOutlet UIButton *btnFour;
@property (nonatomic, retain) IBOutlet UIButton  *displayModeBtn;

@property (nonatomic, retain) IBOutlet TextScrollView	*myScroll;
@property (nonatomic, retain) IBOutlet UITextView *titleWords;
@property (nonatomic, retain) IBOutlet MyPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIView *titleView;
@property (nonatomic, retain) IBOutlet UIView *btnView;


@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) UITableView *commTableView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) UIView *myView;
@property (nonatomic, retain) HPGrowingTextView *textView;
@property (nonatomic, retain) VOAView *voa;
@property (nonatomic, retain) UITextView *imgWords;//文章简介
@property (nonatomic, retain) TextScrollView	*textScroll;//显示文章内容
@property (nonatomic, retain) TextScrollView	*commScroll;
@property (nonatomic, retain) UIImageView     *myImageView;//显示图片
@property (nonatomic, retain) UIButton * playbackButton;
@property (nonatomic, retain) UIButton    *modeBtn;//播放模式按钮
@property (nonatomic, retain) UIButton      *downloadFlg;//已下载
@property (nonatomic, retain) UIButton      *downloadingFlg;//下载中
@property (nonatomic, retain) UIButton		*collectButton;//下载按钮
@property (nonatomic, retain) UIButton        *clockButton;//定时按钮
//@property (nonatomic, retain) UIButton		*shareSenBtn;//下载按钮

@property (nonatomic, retain) UILabel     *myHighLightWord;

@property (nonatomic, retain) MyLabel *explainView;
@property (nonatomic, retain) MyLabel *senLabel;

@property (nonatomic, retain) NSArray         *hoursArray;
@property (nonatomic, retain) NSArray         *minsArray;
@property (nonatomic, retain) NSArray         *secsArray;

@property (nonatomic, retain) NSMutableArray	*lyricArray;
@property (nonatomic, retain) NSMutableArray	*lyricCnArray;
@property (nonatomic, retain) NSMutableArray	*timeArray;
@property (nonatomic, retain) NSMutableArray	*indexArray;
@property (nonatomic, retain) NSMutableArray	*lyricLabelArray;
@property (nonatomic, retain) NSMutableArray	*lyricCnLabelArray;
@property (nonatomic, retain) NSMutableArray    *listArray;//播放列表
@property (nonatomic, retain) NSMutableArray    *commArray;

@property (nonatomic, retain) FGalleryVideoView *videoView;
@property (nonatomic, retain) GADBannerView *bannerView;
@property (nonatomic, retain) MBProgressHUD *HUD;

@property (nonatomic, retain) VOAWord *myWord;
@property (nonatomic, retain) AVPlayer	*wordPlayer;
@property (nonatomic, retain) UIImageView *senImage;

@property (nonatomic, retain) NSTimer         *fixTimer;

@property (nonatomic, retain) NSString *userPath;

@property (nonatomic) BOOL newFile;
@property (nonatomic) BOOL isFree;
@property (nonatomic) BOOL isiPhone;
@property (nonatomic) BOOL needFlushAdv;
//@property (nonatomic) BOOL isExisitNet;
@property (nonatomic) BOOL flushList;
@property (nonatomic) BOOL localFileExist;
@property (nonatomic) BOOL downloaded;
@property (nonatomic) BOOL isFixing;
@property (nonatomic) BOOL isNewComm;
@property (nonatomic) BOOL keyboardFlg;
@property (nonatomic) BOOL isFive;

@property (nonatomic) NSInteger contentMode;
@property (nonatomic) NSInteger nowUserId;
@property (nonatomic) NSInteger playMode;
@property (nonatomic) NSInteger playIndex;//当前播放位置
@property (nonatomic) NSInteger nowPage;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger commCellNum;
@property (nonatomic) NSInteger category;
@property (nonatomic) int		engLines;
@property (nonatomic) int		cnLines;
@property (nonatomic) int       fixSeconds;




//@property (nonatomic, retain) AVPlayer * player;
void audioRouteChangeListenerCallback ( void     *inUserData,
                                       AudioSessionPropertyID    inPropertyID,
                                       UInt32                    inPropertyValueSize,
                                       const void                *inPropertyValue );

+ (PlayerViewController *)sharedPlayer ;

- (void) toggleFullScreen;

@end
