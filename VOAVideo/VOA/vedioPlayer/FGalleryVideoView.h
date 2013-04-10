//
//  FGalleryVideoView.h
//  FirstAVPlayer
//
//  Created by Yuichi Fujiki on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVFoundation/AVPlayer.h"
#import "timeSwitchClass.h"
#import "SevenProgressBar.h"

@protocol FGalleryVideoViewDelegate;

@interface FGalleryVideoView : UIView {
    BOOL _isPlaying;
    BOOL _isNomal;
    CGRect initialFrame;
}

@property (nonatomic, retain) UISlider *timeSlider;
@property (nonatomic, retain) SevenProgressBar  *loadProgress;//缓冲进度
@property (nonatomic, retain) NSTimer			*sliderTimer;
@property (nonatomic, retain) NSTimer			*hideTimer;
@property (nonatomic, retain) UILabel			*totalTimeLabel;
@property (nonatomic, retain) UILabel			*currentTimeLabel;//当前时间
@property (nonatomic,unsafe_unretained) NSObject <FGalleryVideoViewDelegate> *videoDelegate;
@property (nonatomic, retain) UIButton * playbackButton;
@property (nonatomic, retain) UIButton *lanBtn;
@property (nonatomic, retain) AVPlayer * player;
@property (nonatomic, retain) NSMutableArray * timeArray;
@property (nonatomic) BOOL  isPlaying;
@property (nonatomic) BOOL  showPic;//保证视频初始加载好以后跳到0.3秒以显示视频图画
@property (nonatomic) BOOL  notValid;//标志定时器hideTimer当前是否无效
@property (nonatomic) BOOL  isEng;//标志定时器hideTimer当前是否无效
//@property (nonatomic) BOOL  noTouch;//标志是否可以自动隐藏控制栏
@property (nonatomic) int   playerFlag;
@property (nonatomic) NSInteger  hideSec;
@property (nonatomic) NSInteger sen_num; //标记当前正在播放第几句（从1开始）

- (void)setVideoFillMode:(NSString *)fillMode;

- (void)togglePlayback:(id)sender;
- (void)play;
- (void)pause;

- (void)zeroAfterEnd;

- (void)toggleControls;
- (void)toggleScreenControls;
- (void)showControls:(BOOL)animated;
- (void)hideControls:(BOOL)animated;
- (void)hideSelf:(id)sender;
- (void)showSelf:(id)sender;

- (void) changeSliderFrame;

- (void)enableTimer ;

- (void)disableTimer ;

- (void)playerItemDidReachEnd:(NSNotification *)notification;

@end

@protocol FGalleryVideoViewDelegate

// indicates single touch and allows controller repsond and go toggle fullscreen
- (void)didTapVideoView:(FGalleryVideoView*)videoView;
- (void)playerItemDidReachEnd:(FGalleryVideoView*)videoView;
- (void)playSenID:(NSInteger)senID isEng:(BOOL)isEng;

@end
