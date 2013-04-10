//
//  PlayViewControl.h
//  VOA
//
//  Created by song zhao on 12-2-6.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "VOAView.h"
#import "VOAFav.h"
#import "VOADetail.h"
#import "UIImageView+WebCache.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "timeSwitchClass.h"
#import "DataBaseClass.h"
#import "LyricSynClass.h"
#import "MP3PlayerClass.h"
#import "VOAContent.h"
#import "ASIFormDataRequest.h"
#import "TextScrollView.h"
#import "MyLabel.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "VOAWord.h"
#import "MBProgressHUD.h"
#import "Reachability.h"//isExistenceNetwork
#import "LogController.h"
#import "MyPageControl.h"
#import "GADBannerView.h"
#import "SevenProgressBar.h"
#import "ShareToCNBox.h"
//#import "SVShareTool.h"

#include <AudioToolbox/AudioToolbox.h>
#import "NSString+URLEncoding.h"
#import <QuartzCore/QuartzCore.h> //操作layer
#import "HPGrowingTextView.h"//评论的自动放大的输入框
#import "LocalWord.h"
#import "CL_AudioRecorder.h"

//#include <sys/xattr.h>

@class timeSwitchClass;
//@class SpeakHereController;
@class AQLevelMeter;

#define kHourComponent 0
#define kMinComponent 1
#define kSecComponent 2
#define kCommTableHeightPh 60.0
#define kRecorderDirectory [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]  stringByAppendingPathComponent:@"Recorders"]

@interface PlayViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate, AVAudioPlayerDelegate,ASIHTTPRequestDelegate,MyLabelDelegate,UIScrollViewDelegate,AVAudioSessionDelegate,UIActionSheetDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,MBProgressHUDDelegate,HPGrowingTextViewDelegate>
{
    CL_AudioRecorder* audioRecoder;
    BOOL              m_isRecording;
    AVAsset *avSet;
    CMTime nowTime;
    
    VOAView *voa;
    
    MBProgressHUD *HUD;
    
    UIView *fixTimeView;
    UIView *containerView;
    UIImageView *senImage;
    UIImageView *starImage;
    
    HPGrowingTextView *textView;
    
    UIPickerView *myPick;
    
    UIImageView     *myImageView;
//    UIImageView     *wordFrame;
    UIImage     *playImage;
    UIImage     *pauseImage;
    UIImage     *loadingImage;
    
    UIButton		*collectButton;
    UIButton		*downloadFlg;
    UIButton      *downloadingFlg;
//    UIButton        *switchBtn;
    UIButton		*playButton;
    UIButton        *preButton;
    UIButton        *nextButton;
    UIButton        *fixButton;
    UIButton        *clockButton;
    UIButton        *modeBtn;
    UIButton        *displayModeBtn;
    UIButton        *shareSenBtn;
    
//    UILabel      *downloadFlg;
//    UILabel      *downloadingFlg;
    UILabel			*totalTimeLabel;//总时间
	UILabel			*currentTimeLabel;//当前时间
    UILabel     *myHighLightWord;
    UILabel *lyricCnLabel;
    UILabel *recordLabel;
    MyLabel *explainView;
    MyLabel *lyricLabel;
    MyLabel *queLabel;
    
    TextScrollView	*textScroll;
    TextScrollView	*myScroll;
    
//    timeSwitchClass *timeSwitch;
    
	UISlider		*timeSlider;//时间滑块
    SevenProgressBar  *loadProgress;//缓冲进度
    
    NSTimer			*sliderTimer;
	NSTimer			*lyricSynTimer;
    NSTimer         *fixTimer;
    NSTimer         *recordTimer;
    NSTimer         *playRecordTimer;
//    NSTimer         *loadTimer;
    
    NSMutableArray	*lyricArray;
    NSMutableArray	*lyricCnArray;
	NSMutableArray	*timeArray;
	NSMutableArray	*indexArray;
	NSMutableArray	*lyricLabelArray;
    NSMutableArray	*lyricCnLabelArray;
    NSMutableArray    *listArray;
    NSArray         *hoursArray;
    NSArray         *minsArray;
    NSArray         *secsArray;
    NSMutableData* mp3Data;
    
	int				engLines;
    int				cnLines;
    int             playerFlag;
    int             fixSeconds;
    int             recordSeconds;
    int             nowRecordSeconds;
    int             recordTime;
//    int myTimer;
    NSInteger nowUserId;
    NSInteger sen_num;
    NSInteger contentMode;
    NSInteger playMode;
    NSInteger playIndex;
    
    AVPlayer	*player;
    AVPlayer	*wordPlayer;
    
	NSURL			*mp3Url;
    
    BOOL localFileExist;
    BOOL downloaded;
    BOOL newFile;
    BOOL switchFlg;
    BOOL needFlush;
    BOOL needFlushAdv;
    BOOL isExisitNet;
    BOOL noBuffering;
    BOOL isiPhone;
    BOOL readRecord;
    BOOL isFixing;
    BOOL flushList;
    BOOL notValid;
    BOOL isShareSen;
//    BOOL isHeadphone;
    
    NSString *userPath;
    NSString *lyEn;
    NSString *lyCn;
    NSString *shareStr;
    
    VOAWord *myWord;
    
    UITextView *imgWords;
    UITextView *titleWords;
    
    double myStop;
    double seekTo;
    
    UIAlertView *alert;
    
    NSNotificationCenter *myCenter;
    
    MyPageControl *pageControl;
    
//    GADBannerView *bannerView_;
    
//    SpeakHereController *controller;
    
    UIFont *CourierOne;
    UIFont *CourierTwo;
    
//    UITextField  *keyCommFd;
    
//    UIToolbar *comTool;
//    CFURLRef		soundFileURLRef;
//	SystemSoundID	soundFileObject;
//    
//    float time_total;
}
//@property (nonatomic, retain) IBOutlet SpeakHereController *controller;

@property (nonatomic, retain) IBOutlet UIButton        *preButton;
@property (nonatomic, retain) IBOutlet UIButton        *nextButton;
@property (nonatomic, retain) IBOutlet UIButton		*btnOne;
@property (nonatomic, retain) IBOutlet UIButton        *btnTwo;
@property (nonatomic, retain) IBOutlet UIButton        *btnThree;
@property (nonatomic, retain) IBOutlet UIButton        *btnFour;
@property (nonatomic, retain) IBOutlet UIButton        *btnFive;
@property (nonatomic, retain) IBOutlet UIButton        *btnSix;
@property (nonatomic, retain) UIButton        *clockButton;
@property (nonatomic, retain) IBOutlet TextScrollView	*myScroll;
@property (nonatomic, retain) IBOutlet MyPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UILabel			*totalTimeLabel;//总时间
@property (nonatomic, retain) IBOutlet UILabel			*currentTimeLabel;//当前时间
@property (nonatomic, retain) IBOutlet UILabel *recordLabel;
@property (nonatomic, retain) IBOutlet UISlider		*timeSlider;//时间滑块
@property (nonatomic, retain) IBOutlet UIButton		*playButton;
@property (nonatomic, retain) IBOutlet UITextView *titleWords;
@property (nonatomic, retain) IBOutlet UIImageView *RoundBack;
@property (nonatomic, retain) UILabel *lyricCnLabel; 
@property (nonatomic, retain) MyLabel *lyricLabel;
@property (nonatomic, retain) MyLabel *queLabel;
@property (nonatomic, retain) UIFont *CourierOne;
@property (nonatomic, retain) UIFont *CourierTwo;
@property (nonatomic, retain) UIButton      *downloadFlg;
@property (nonatomic, retain) UIButton      *downloadingFlg;
@property (nonatomic, retain) UIButton		*collectButton;
@property (nonatomic, retain) IBOutlet UIView *fixTimeView;
@property (nonatomic, retain) IBOutlet UIPickerView *myPick;
@property (nonatomic, retain) IBOutlet UIButton  *fixButton;
@property (nonatomic, retain) IBOutlet UIButton    *modeBtn;
@property (nonatomic, retain) IBOutlet UIButton  *displayModeBtn;
//@property (nonatomic, retain) IBOutlet AQLevelMeter		*lvlMeter_in;
@property (nonatomic, retain) IBOutlet UIButton		*btn_record;
@property (nonatomic, retain) IBOutlet UIButton		*btn_play;
@property (nonatomic, retain) NSArray         *hoursArray;
@property (nonatomic, retain) NSArray         *minsArray;
@property (nonatomic, retain) NSArray         *secsArray;
//@property (readwrite)	CFURLRef		soundFileURLRef;
//@property (readonly)	SystemSoundID	soundFileObject;
@property (nonatomic, retain) SevenProgressBar  *loadProgress;//缓冲进度
//@property (nonatomic, retain) GADBannerView *bannerView_;
@property (nonatomic, retain) VOAView *voa;
@property (nonatomic, retain) UITableView   *wordTableView;
@property (nonatomic, retain) UIImageView     *myImageView;
@property (nonatomic, retain) UIImageView *senImage;
@property (nonatomic, retain) UIImageView *starImage;
//@property (nonatomic, retain) UIImageView     *wordFrame;
//@property (nonatomic, retain) UIButton        *switchBtn;
@property (nonatomic, retain) UIButton        *aButton;
@property (nonatomic, retain) UIButton        *bButton;
@property (nonatomic, retain) UIButton        *cButton;
@property (nonatomic, retain) UIButton        *shareSenBtn;
@property (nonatomic, retain) NSTimer			*sliderTimer;
@property (nonatomic, retain) NSTimer			*lyricSynTimer;
@property (nonatomic, retain) NSTimer         *fixTimer;
@property (nonatomic, retain) NSMutableArray	*lyricArray;
@property (nonatomic, retain) NSMutableArray	*lyricCnArray;
@property (nonatomic, retain) NSMutableArray	*timeArray;
@property (nonatomic, retain) NSMutableArray	*indexArray;
@property (nonatomic, retain) NSMutableArray	*lyricLabelArray;
@property (nonatomic, retain) NSMutableArray	*lyricCnLabelArray;
@property (nonatomic, retain) NSMutableArray     *listData;
@property (nonatomic, retain) NSMutableArray    *answerData;
@property (nonatomic, retain) NSMutableArray    *listArray;
@property (nonatomic) NSInteger commNumber;
@property (nonatomic) NSInteger nowPage;
@property (nonatomic) NSInteger totalPage;
@property (nonatomic) NSInteger nowUserId;
@property (nonatomic) NSInteger contentMode;
@property (nonatomic) NSInteger playMode;
@property (nonatomic) NSInteger playIndex;
@property (nonatomic) int				engLines;
@property (nonatomic) int				cnLines;
@property (nonatomic) int				playerFlag;//0:local 1:net
//@property (nonatomic) int               myTimer;
@property (nonatomic) int             fixSeconds;
@property (nonatomic) double myStop;
@property (nonatomic) BOOL localFileExist;
@property (nonatomic) BOOL downloaded;
@property (nonatomic) BOOL newFile;
@property (nonatomic) BOOL switchFlg;
@property (nonatomic) BOOL isExisitNet;
@property (nonatomic) BOOL isNewComm;
@property (nonatomic) BOOL isFixing;
@property (nonatomic) BOOL flushList;
//@property (nonatomic) BOOL isHeadphone;
@property (nonatomic, retain) AVPlayer	*player;
@property (nonatomic, retain) AVPlayer	*wordPlayer;
@property (nonatomic, retain) UILabel     *myHighLightWord;
@property (nonatomic, retain) UIView      *myView;
@property (nonatomic, retain) NSMutableData* mp3Data;
@property (nonatomic, retain) NSString *userPath;
@property (nonatomic, retain) MyLabel *explainView;
@property (nonatomic, retain) VOAWord *myWord;
@property (nonatomic, retain) TextScrollView	*textScroll;
@property (nonatomic, retain) UITextView *imgWords;
@property (nonatomic, retain) UIImage *playImage;
@property (nonatomic, retain) UIImage *pauseImage;
@property (nonatomic, retain) UIImage *loadingImage;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic, retain) NSNotificationCenter *myCenter;
@property (nonatomic, retain) NSString *lyEn;
@property (nonatomic, retain) NSString *lyCn;
@property (nonatomic, retain) UITableView *commTableView;
@property (nonatomic, retain) NSMutableArray *commArray;
//@property (nonatomic, retain) UITextField *inputText;
@property (nonatomic, retain) MBProgressHUD *HUD;
//@property (nonatomic, retain) UITextField  *keyCommFd;
//@property (nonatomic, retain) UIToolbar *comTool;
@property (nonatomic, retain) HPGrowingTextView *textView;
@property (nonatomic, retain) UIView *containerView;
@property (nonatomic, retain) NSTimer         *recordTimer;
@property (nonatomic) int             recordTime;
@property (nonatomic) int             recordSeconds;
@property (nonatomic) int             nowRecordSeconds;

void RouteChangeListener(	void *                  inClientData,
                         AudioSessionPropertyID	inID,
                         UInt32                  inDataSize,
                         const void *            inData);
- (IBAction) playButtonPressed:(UIButton *)sender;
- (void) collectButtonPressed:(UIButton *)sender;
- (IBAction) sliderChanged:(UISlider *)sender;
- (IBAction) goBack:(UIButton *)sender;
- (IBAction) prePlay:(id)sender;
- (IBAction) aftPlay:(id)sender;
- (IBAction) shareTo:(id)sender;
- (IBAction) changeView:(id)sender;
- (IBAction)changePage:(UIPageControl *)sender;
- (void) showFix:(id)sender;
- (IBAction) doFix:(id)sender;
- (IBAction) changeMode:(UIButton *)sender;
- (void) touchAnswerBtn:(UIButton*)sender;
//- (IBAction) shareText;
//- (void) shareAll;
//- (IBAction) showComments:(id)sender;
- (void) QueueDownloadVoa;
- (void)catchWords:(NSString *) word;
+ (PlayViewController *)sharedPlayer;
+ (NSOperationQueue *)sharedQueue;
-(BOOL) isExistenceNetwork:(NSInteger)choose;
//-(void)updateCurrentTimeForPlayer:(AVPlayer *)p;
- (void)setButtonImage:(UIImage *)image;
- (void)spinButton;
- (CMTime)playerItemDuration;

@end
