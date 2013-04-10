//
//  FGalleryVideoView.m
//  FirstAVPlayer
//
//  Created by Yuichi Fujiki on 10/7/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FGalleryVideoView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>

@implementation FGalleryVideoView
@synthesize isEng = _isEng;
@synthesize lanBtn = _lanBtn;
@synthesize timeArray = _timeArray;
@synthesize sen_num = _sen_num;
@synthesize isPlaying = _isPlaying;
@synthesize playerFlag = _playerFlag;
@synthesize notValid = _notValid;
@synthesize showPic = _showPic;
@synthesize totalTimeLabel = _totalTimeLabel;
@synthesize currentTimeLabel = _currentTimeLabel;
@synthesize sliderTimer = _sliderTimer;
@synthesize loadProgress = _loadProgress;
@synthesize timeSlider = _timeSlider;
@synthesize videoDelegate = _videoDelegate;
@synthesize playbackButton = _playbackButton;
//@synthesize noTouch = _noTouch;
@synthesize hideTimer = _hideTimer;
@synthesize hideSec = _hideSec;

- (id) initWithFrame:(CGRect)frame 
{
    if(self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+44)])
    {
        initialFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height+64);
        _isNomal = YES;
        _isPlaying = NO;
//        _noTouch = YES;
        _notValid = YES;
        _isEng = YES;
//        _timeArray
        [self initHideTimer];
        NSLog(@"height1:%f", self.frame.size.height);
        _currentTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, initialFrame.size.height-49, 40, 25)];
        _totalTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, initialFrame.size.height-49, 80, 25)];
        [_currentTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_currentTimeLabel setTextColor:[UIColor whiteColor]];
        [_totalTimeLabel setBackgroundColor:[UIColor clearColor]];
        [_totalTimeLabel setTextColor:[UIColor whiteColor]];
        [_currentTimeLabel setFont:[UIFont systemFontOfSize:14]];
        [_totalTimeLabel setFont:[UIFont systemFontOfSize:14]];
        _timeSlider = [[UISlider alloc] initWithFrame:CGRectMake(186, initialFrame.size.height-48, ([Constants isPad] ? frame.size.width-100: 200), 8)];
        
//        UIImage *timeMin = [UIImage imageNamed:@"sliderTimeMinBBC.png"];
//        UIImage *timeMinImg = [timeMin stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        UIImage *sliderLu = [UIImage imageNamed:@"sliderLu.png"];
//        UIImage *sliderLuImg = [sliderLu stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        UIImage *sliderBbc = [UIImage imageNamed:@"sliderBBC.png"];
//        UIImage *sliderBbcImg = [sliderBbc stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        UIImage *loadMin = [UIImage imageNamed:@"sliderLoadMinBBC.png"];
//        UIImage *loadMinImg = [loadMin stretchableImageWithLeftCapWidth:5 topCapHeight:5];
//        [_timeSlider setMinimumTrackImage:timeMinImg forState:UIControlStateNormal];
//        [_timeSlider setMaximumTrackImage:sliderLuImg forState:UIControlStateNormal];
//        [_timeSlider setThumbImage:[UIImage imageNamed:@"thumbBBC.png"] forState:UIControlStateNormal];
//        _loadProgress = [[SevenProgressBar alloc] initWithFrame:CGRectMake(89, initialFrame.size.height-42, ([Constants isPad] ? 600: 200), 12) andbackImg:sliderBbcImg frontimg:loadMinImg];
        
        
        [_timeSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderFront.png"] forState:UIControlStateNormal];
        [_timeSlider setMaximumTrackImage:[UIImage imageNamed:@"sliderLu.png"] forState:UIControlStateNormal];
        [_timeSlider setThumbImage:[UIImage imageNamed:@"dragPoint.png"] forState:UIControlStateNormal];
        _loadProgress = [[SevenProgressBar alloc] initWithFrame:CGRectMake(189, initialFrame.size.height-42, ([Constants isPad] ? frame.size.width-100: 200), 8) andbackImg:[UIImage imageNamed:@"sliderBBC.png"] frontimg:[UIImage imageNamed:@"sliderMin.png"]];
        [[_timeSlider layer] setCornerRadius:5.0f];
        [[_timeSlider layer] setMasksToBounds:YES];
        [[_loadProgress layer] setCornerRadius:5.0f];
        [[_loadProgress layer] setMasksToBounds:YES];
        [_timeSlider addTarget:self action:@selector(sliderChanged) forControlEvents:UIControlEventValueChanged];
        _timeSlider.autoresizesSubviews = YES;
        _timeSlider.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        _loadProgress.autoresizesSubviews = YES;
        _loadProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
        
        
        self.backgroundColor = [UIColor blackColor];
                        
        self.playbackButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [self setFrame:frame];
        self.playbackButton.frame = CGRectMake(self.frame.size.width / 2 - 32, self.frame.size.height / 2 - 32, 64, 64);
        [self.playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        [self.playbackButton addTarget:self action:@selector(togglePlayback:) forControlEvents:UIControlEventTouchUpInside];
        
        self.lanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [self setFrame:frame];
        if ([Constants isPad]) {
            self.lanBtn.frame = CGRectMake(self.frame.size.width - 30, self.frame.size.height - 30, 30, 30);
            [self.lanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
        } else {
            self.lanBtn.frame = CGRectMake(self.frame.size.width - 20, self.frame.size.height - 20, 20, 20);
            [self.lanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        }
        [self.lanBtn setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f]];
        [self.lanBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [self.lanBtn setTitle:@"英" forState:UIControlStateNormal];
        [self.lanBtn setShowsTouchWhenHighlighted:YES];
//        [self.lanBtn setBackgroundImage:[UIImage imageNamed:@"changeLan.png"] forState:UIControlStateNormal];
//        [self.lanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [[self.lanBtn layer] setCornerRadius:8.0f];
        [[self.lanBtn layer] setMasksToBounds:YES];
        [self.lanBtn addTarget:self action:@selector(changeLanguage) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_timeSlider];
        [self insertSubview:_loadProgress belowSubview:_timeSlider];
        [self addSubview:_currentTimeLabel];
        [self addSubview:_totalTimeLabel];
        [self addSubview:_playbackButton];
        [self addSubview:_lanBtn];
        [_timeSlider release];
        [_loadProgress release];
        [_currentTimeLabel release];
        [_totalTimeLabel release];
        _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                        target:self
                                                      selector:@selector(updateSlider)
                                                      userInfo:nil
                                                       repeats:YES];
    }
    return self;
}

- (void)enableTimer {
    _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                    target:self
                                                  selector:@selector(updateSlider)
                                                  userInfo:nil
                                                   repeats:YES];
}

- (void)disableTimer {
    [_sliderTimer invalidate];
}

- (void)changeLanguage {
    if (_isEng) {
        _isEng = NO;
        [self.lanBtn setTitle:@"中" forState:UIControlStateNormal];
    } else {
        _isEng = YES;
        [self.lanBtn setTitle:@"英" forState:UIControlStateNormal];
    }
    if([self.videoDelegate respondsToSelector:@selector(playSenID:isEng:)])
        [self.videoDelegate playSenID:_sen_num isEng:_isEng];
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
//    NSLog(@"wodth:%f", frame.size.width-100);
    initialFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height);
    if (kIsLandscapeTest || !_isNomal) {
        [self.lanBtn setHidden:YES];
    } else {
        [self.lanBtn setHidden:NO];
        if ([Constants isPad]) {
            self.lanBtn.frame = CGRectMake(frame.size.width - 30, frame.size.height - 30, 30, 30);
        } else {
            self.lanBtn.frame = CGRectMake(frame.size.width - 20, frame.size.height - 20, 20, 20);
        }
    }
    
    self.playbackButton.frame = CGRectMake(frame.size.width / 2 - 32, frame.size.height / 2 - 32, 64, 64);
    
    if (_isNomal) {
        self.timeSlider.frame = CGRectMake(88, initialFrame.size.height-15, frame.size.width-120, 8);
//        self.loadProgress.frame = CGRectMake(89, initialFrame.size.height-15, frame.size.width-100, 8);
        [self.loadProgress setBarFrame:CGRectMake(89, initialFrame.size.height-15, frame.size.width-120, 8)];
    } else {
        self.timeSlider.frame = CGRectMake(88, initialFrame.size.height-15, frame.size.width-100, 8);
//        self.loadProgress.frame = CGRectMake(89, initialFrame.size.height-15, ([Constants isPad] ? frame.size.width-100: 200), 8);
        [self.loadProgress setBarFrame:CGRectMake(89, initialFrame.size.height-15, frame.size.width-100, 8)];
//        self.timeSlider.frame = CGRectMake((kIsLandscapeTest? self.window.frame.size.height/2-([Constants isPad] ? 400: 100): 88), initialFrame.size.height-15, ([Constants isPad] ? frame.size.width-100: 200), 8);
//        self.loadProgress.frame = CGRectMake((kIsLandscapeTest? self.window.frame.size.height/2-([Constants isPad] ? 399: 99): 89), initialFrame.size.height-15, ([Constants isPad] ? frame.size.width-100: 200), 8);
    }
    
//    self.timeSlider.frame = CGRectMake(88, initialFrame.size.height-15, ([Constants isPad] ? 600: 200), 12);
//    self.loadProgress.frame = CGRectMake(89, initialFrame.size.height-15, ([Constants isPad] ? 600: 200), 12);
    self.currentTimeLabel.frame = CGRectMake(0, initialFrame.size.height-22, 40, 25);
    self.totalTimeLabel.frame = CGRectMake(40, initialFrame.size.height-22, 80, 25);
}

- (void) changeSliderFrame {
//     [self setFrame:CGRectMake(self.superview.frame.origin.x+(kIsLandscapeTest? self.window.frame.size.height : self.window.frame.size.width), self.superview.frame.origin.y, self.superview.frame.size.width, self.superview.frame.size.height)];
    NSLog(@"y:%f width:%f", (kIsLandscapeTest? self.window.frame.size.width : self.window.frame.size.height)-15, (kIsLandscapeTest? self.window.frame.size.height : self.window.frame.size.width)-100);
    self.timeSlider.frame = CGRectMake(88, initialFrame.size.height-15, self.frame.size.width-100, 8);
//    self.loadProgress.frame = CGRectMake(89, initialFrame.size.height-15, ([Constants isPad] ? self.frame.size.width-100: 200), 8);
    [self.loadProgress setBarFrame:CGRectMake(89, initialFrame.size.height-15, self.frame.size.width-100, 8)];
//    self.timeSlider.frame = CGRectMake((kIsLandscapeTest? self.window.frame.size.height/2-([Constants isPad] ? 400: 100): 88), initialFrame.size.height-15, ([Constants isPad] ? self.frame.size.width-100: 200), 8);
//    self.loadProgress.frame = CGRectMake((kIsLandscapeTest? self.window.frame.size.height/2-([Constants isPad] ? 399: 99): 89), initialFrame.size.height-15, ([Constants isPad] ? self.frame.size.width-100: 200), 8);
//    self.timeSlider.frame = CGRectMake((kIsLandscapeTest? (kIsLandscapeTest? self.window.frame.size.height : self.window.frame.size.width)/2-100: 88), (kIsLandscapeTest? self.window.frame.size.width : self.window.frame.size.height)-15, (kIsLandscapeTest? self.window.frame.size.height : self.window.frame.size.width)-100, 12);
//    self.loadProgress.frame = CGRectMake((kIsLandscapeTest? (kIsLandscapeTest? self.window.frame.size.height : self.window.frame.size.width)-100: 88), (kIsLandscapeTest? self.window.frame.size.width : self.window.frame.size.height)-15, ((kIsLandscapeTest? self.window.frame.size.height : self.window.frame.size.width)-100), 12);
}

+ (Class)layerClass
{
	return [AVPlayerLayer class];
}

- (BOOL)isPlaying
{
//    NSLog(@"player rate = %lf %d",[[self player] rate], [[self player] rate] != 0.f);
	return [[self player] rate] != 0.f;
}

- (AVPlayer*)player
{
	return [(AVPlayerLayer*)[self layer] player];
}

- (void)setPlayer:(AVPlayer*)player
{
	[(AVPlayerLayer*)[self layer] setPlayer:player];
}

/* Specifies how the video is displayed within a player layer’s bounds. 
 (AVLayerVideoGravityResizeAspect is default) */
- (void)setVideoFillMode:(NSString *)fillMode
{
	AVPlayerLayer *playerLayer = (AVPlayerLayer*)[self layer];
	playerLayer.videoGravity = fillMode;
}

- (void)togglePlayback:(id)sender 
{
//    _noTouch = NO;
    [self initHideTimer];
    if(!_isPlaying)
    {
        [self play];
    }
    else
    {
        [self pause];
    }
}

- (CMTime)playerItemDuration
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.3){
        /*
         * ios4.3以上使用下面的
         */
        AVPlayerItem *playerItem = [self.player currentItem];
        return([playerItem duration]);
    }
    else {
        NSArray* seekRanges = [self.player.currentItem seekableTimeRanges];
        if (seekRanges.count > 0)
        {
            CMTimeRange range = [[seekRanges objectAtIndex:0] CMTimeRangeValue];
            double duration = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
            return CMTimeMakeWithSeconds(duration, NSEC_PER_SEC);
        }
        return CMTimeMakeWithSeconds(0.f, NSEC_PER_SEC);
    }
    
}

- (void) sliderChanged{
//    CMTime playerProgress = [[self player] currentTime];
//    double progress = CMTimeGetSeconds(playerProgress);
//    [self setButtonImage:loadingImage];
//    _noTouch = NO;
    [self initHideTimer];
    [[self player] seekToTime:CMTimeMakeWithSeconds(_timeSlider.value, NSEC_PER_SEC)];
    CMTime playerProgress = [self.player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    int i = 0;
//    NSLog(@"调用换内容1");
    for (; i < [_timeArray count]; i++) {
        if ((int)progress < [[_timeArray objectAtIndex:i] unsignedIntValue]) {
            _sen_num = i+1;//跟读标识句子号
//            NSLog(@"调用换内容2");
            if([self.videoDelegate respondsToSelector:@selector(playSenID:isEng:)])
//                NSLog(@"调用换内容3");
                [self.videoDelegate playSenID:_sen_num isEng:_isEng];
            break;
        }
    }
}

// Update the slider about the music time
- (void)updateSlider {
    CMTime playerProgress = [self.player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    double duration = CMTimeGetSeconds([self playerItemDuration]);
    //    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.3){
    //        //        NSLog(@"Version>=4.3");
    //    }else {
    if ([self isPlaying]) {//刷新播放按钮图片
        [_playbackButton setBackgroundImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        _isPlaying = YES;
    } else {
        [_playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        _isPlaying = NO;
        [self showControls:NO];
    }
    NSArray* loadedRanges = self.player.currentItem.loadedTimeRanges;
    if (loadedRanges.count > 0 && _playerFlag == 1)
    {
        CMTimeRange range = [[loadedRanges objectAtIndex:0] CMTimeRangeValue];
        double loaded = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
        //        NSLog(@"loaded:%g", loaded);
        if (duration>0.f) {
            [_loadProgress setProgress:(loaded/duration)];
        }
    }
    if (!_showPic&&(loadedRanges.count > 0 || _playerFlag == 0)) {
        [self.player seekToTime:CMTimeMakeWithSeconds(0.3, NSEC_PER_SEC)];
        _showPic = YES;
//        _noTouch = YES;
//        _hideSec = 5;
        if (duration > 0.f) {
            _totalTimeLabel.text = [NSString stringWithFormat:@"/ %@", [timeSwitchClass timeToSwitchAdvance:duration]];
        }
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoPlay"]) {
            [self.player play];
        }
    }
    if (progress > 0.f) {
        _totalTimeLabel.text = [NSString stringWithFormat:@"/ %@", [timeSwitchClass timeToSwitchAdvance:duration]];
        self.timeSlider.maximumValue = duration;
        
        if (progress < duration) {
            self.timeSlider.value = progress;
            _currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:progress];
        } else {
            self.timeSlider.value = duration;
            _currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
        }
        
        if (_sen_num < [_timeArray count] + 1 && progress > [[_timeArray objectAtIndex:_sen_num-1] floatValue]) {
            _sen_num++;
//            NSLog(@"_sen_num:%i",_sen_num);
            if([self.videoDelegate respondsToSelector:@selector(playSenID:isEng:)])
                [self.videoDelegate playSenID:_sen_num isEng:_isEng];
        }
    }
    
    
    //    NSArray* loadedRanges = player.currentItem.loadedTimeRanges;
    //    if (loadedRanges.count > 0 && playerFlag == 1)
    //    {
    //        CMTimeRange range = [[loadedRanges objectAtIndex:0] CMTimeRangeValue];
    //        double loaded = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);
    //        //        NSLog(@"loaded:%g", loaded);
    //        if (duration>0.f) {
    //            [loadProgress setProgress:(loaded/duration)];
    //        }
    //    }
    
    //        noBuffering = YES;
    
}

- (void) play
{
    [[((AVPlayerLayer *)[self layer]) player] play];
//    CMTime playerProgress = [self.player currentTime];
//    double progress = CMTimeGetSeconds(playerProgress);
//    if (progress > 0.0f) {
    [_playbackButton setBackgroundImage:[UIImage imageNamed:@"PauseButton.png"] forState:UIControlStateNormal];
        //    [self hideControls:YES];
    _isPlaying = YES;
    
    
    if (_notValid) {
        _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                        target:self
                                                      selector:@selector(autoHideControls)
                                                      userInfo:nil
                                                       repeats:YES];
        _notValid = NO;
    }
    
//    }
    
    
//    [self.videoDelegate didTapVideoView:self];
}

- (void)initHideTimer {
    _hideSec = 3;
}

- (void)autoHideControls {
    _hideSec--;
    if (_hideSec < 1) {
        _notValid = YES;
        [_sliderTimer invalidate];
        if ([self isPlaying]) {
            [self hideControls:NO];
        }
    }
}

- (void) pause
{
    if (_isPlaying) {
        [[((AVPlayerLayer *)[self layer]) player] pause];
        [_playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
        _isPlaying = NO;
//        if (!_notValid) {
//            [_sliderTimer invalidate];
//            _notValid = YES;
//        }
    }
    
}

- (void)toggleControls 
{
    if(_playbackButton.alpha == 0)
    {
        [self showControls:NO];
//        initialFrame
        
    }
    else
    {
        
        [self hideControls:NO];
    }
}

- (void)toggleScreenControls //切换全屏和正常模式的控件摆放
{
    
//    if(self.frame.size.height == initialFrame.size.height)
    if(_isNomal)
    {
        _isNomal = NO;
//        [self.superview setFrame:self.window.frame];
//        [self setFrame:self.window.frame];
//        [self setFrame:self.superview.frame];
//        NSLog(@"window width:%f", self.window.frame.size.width);
        [self setFrame:CGRectMake(self.superview.frame.origin.x+(kIsLandscapeTest? self.window.frame.size.height : self.window.frame.size.width), self.superview.frame.origin.y, self.superview.frame.size.width, self.superview.frame.size.height)];
//        NSLog(@"height:%f y:%f", self.frame.size.height, self.frame.origin.y);
//        self.timeSlider.frame = CGRectMake(88, self.window.frame.size.height-22, 200, 12);
//        self.loadProgress.frame = CGRectMake(89, self.window.frame.size.height-22, 200, 12);
//        self.currentTimeLabel.frame = CGRectMake(0, self.window.frame.size.height-29, 40, 25);
//        self.totalTimeLabel.frame = CGRectMake(40, self.window.frame.size.height-29, 80, 25);
        
    }
    else
    {
        _isNomal = YES;
        if ([Constants isPad]) {
            [self setFrame:kIsLandscapeTest? CGRectMake(1109, 39, 700, 450+20): CGRectMake(802, 42, 700, 450+64+20)];
        } else {
            [self setFrame:kIsLandscapeTest? ([[NSUserDefaults standardUserDefaults] boolForKey:kBePro]? CGRectMake(kScreenHeight + 50, 0, 380 + kFiveAdd, 230+20): CGRectMake(kScreenHeight + 50, 0,  380 + kFiveAdd, 180+20)): CGRectMake(330, 10, 300, 190+64+20)];
        }
        
//        NSLog(@"height:%f", self.frame.size.height); 
//        self.timeSlider.frame = CGRectMake(88, initialFrame.size.height-24-15, 200, 12);
//        self.loadProgress.frame = CGRectMake(89, initialFrame.size.height-24-15, 200, 12);
//        self.currentTimeLabel.frame = CGRectMake(0, initialFrame.size.height-24-22, 40, 25);
//        self.totalTimeLabel.frame = CGRectMake(40, initialFrame.size.height-24-22, 80, 25);
    }
}

- (void)showControls:(BOOL)animated {
//    _noTouch = YES;
    [self initHideTimer];
    if (_notValid) {
        _sliderTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                        target:self
                                                      selector:@selector(autoHideControls)
                                                      userInfo:nil
                                                       repeats:YES];
        _notValid = NO;
    }
    NSTimeInterval duration = (animated) ? 0.5 : 0;
    
    [UIView animateWithDuration:duration animations:^() {
        _playbackButton.alpha = 1;
        _timeSlider.alpha = 1;
        _loadProgress.alpha = 1;
        _currentTimeLabel.alpha = 1;
        _totalTimeLabel.alpha = 1;
    }];    
}



- (void)hideControls:(BOOL)animated {
    NSTimeInterval duration = (animated) ? 0.5 : 0;
    [UIView animateWithDuration:duration animations:^() {
        _playbackButton.alpha = 0;
        _timeSlider.alpha = 0;
        _loadProgress.alpha = 0;
        _currentTimeLabel.alpha = 0;
        _totalTimeLabel.alpha = 0;
    }];
}

- (void)zeroAfterEnd
{
    NSLog(@"归0");
    [_timeSlider setValue:0.f];
    _sen_num = 1;
    _currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:0];
    [_playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
}

- (void)hideSelf:(id)sender {
    NSTimeInterval duration = (sender) ? 0.5 : 0;
    
    [UIView animateWithDuration:duration animations:^ {
        self.alpha = 0;
    }];
}

- (void)showSelf:(id)sender {
    NSTimeInterval duration = (sender) ? 0.5 : 0;
    
    [UIView animateWithDuration:duration animations:^ {
        self.alpha = 1;
    }];
        
    [self hideControls:NO];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    [_videoDelegate playerItemDidReachEnd:self];
//    NSLog(@"会调用协议么？");
//    [[((AVPlayerLayer *)[self layer]) player] seekToTime:kCMTimeZero];
//    [_playbackButton setBackgroundImage:[UIImage imageNamed:@"PlayButton.png"] forState:UIControlStateNormal];
//    _isPlaying = NO;
//    
//    [self showControls:YES];
}

#pragma mark - touch event
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    if(touch.tapCount == 1)
    {
        [self toggleControls];
        
        
    }
    
    if(touch.tapCount == 2)
    {
        // tell the controller
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:kBePro]) {
            if([self.videoDelegate respondsToSelector:@selector(didTapVideoView:)])
                [self.videoDelegate didTapVideoView:self];
//        } else {
//            UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:kColFour message: delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [netAlert show];
//            [netAlert release];
//        }
        
    }
}

#pragma mark - AVAudioSessionDelegate
//- (void)beginInterruption
//{
////    //    NSLog(@"beginInterruption");
//    //    if (localFileExist) {
//    [[self player] pause];
//    
//    //    if (readRecord) {
//    //        NSLog(@"后台");
//    //        [controller stopRecord];
//    //    }
//    //    }
//    //    else {
//    //        [player pause];
//    ////        [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
//    //    }
//    //    [playButton setImage:[UIImage imageNamed:@"PpausePressed.png"] forState:UIControlStateNormal];
//    //    [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
//}
//
//- (void)endInterruption
//{
//    [[self player] play];
////    if (readRecord) {
////        [player play];
////        if (isiPhone) {
////            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBC.png"] forState:UIControlStateNormal];
////        } else {
////            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBC@2x.png"] forState:UIControlStateNormal];
////        }
////    }
//    //     NSLog(@"endInterruption");
//    //    if (localFileExist) {
//    //        [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
//    //        [localPlayer play];
//    //    }else {
//    ////        [player pause];
//    //    }
//}

@end
