//
//  PlayViewControl.m
//  VOA
//
//  Created by song zhao on 12-2-6.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "PlayViewController.h"
//#import "SpeakHereController.h"
#import "AQLevelMeter.h"

@implementation PlayViewController

@synthesize starImage;
@synthesize senImage;
@synthesize shareSenBtn;
@synthesize voa;
@synthesize myImageView;
@synthesize collectButton;
//@synthesize switchBtn;
@synthesize textScroll;
//@synthesize timeSwitch;
@synthesize totalTimeLabel;//总时间
@synthesize currentTimeLabel;//当前时间
@synthesize timeSlider;//时间滑块
@synthesize sliderTimer;
@synthesize lyricSynTimer;
@synthesize lyricArray;
@synthesize timeArray;
@synthesize indexArray;
@synthesize lyricLabelArray;
@synthesize lyricCnLabelArray;
@synthesize lyricCnLabel; 
@synthesize engLines;
@synthesize cnLines;
//@synthesize localPlayer;
@synthesize wordPlayer;
@synthesize lyricCnArray;
@synthesize playButton;
@synthesize myHighLightWord;
@synthesize mp3Data;
@synthesize localFileExist;
@synthesize downloaded;
@synthesize newFile;
@synthesize userPath;
@synthesize myView;
@synthesize explainView;
@synthesize myWord;
@synthesize switchFlg;
@synthesize myScroll;
@synthesize imgWords;
@synthesize titleWords;
@synthesize player;
@synthesize playerFlag;
//@synthesize myTimer;
@synthesize myStop;
@synthesize playImage;
@synthesize pauseImage;
@synthesize loadingImage;
@synthesize alert;
@synthesize myCenter;
@synthesize nowUserId;
@synthesize pageControl;
//@synthesize wordFrame;
@synthesize downloadFlg;
@synthesize downloadingFlg;
@synthesize isExisitNet;
@synthesize preButton;
@synthesize nextButton;
//@synthesize bannerView_;
//@synthesize shareButton;
@synthesize loadProgress;
//@synthesize controller;
@synthesize lyCn;
@synthesize lyEn;
@synthesize RoundBack;
@synthesize btnOne;
@synthesize btnTwo;
@synthesize btnThree;
@synthesize btnFour;
@synthesize btnFive;
@synthesize btnSix;
@synthesize aButton;
@synthesize bButton;
@synthesize cButton;
@synthesize listData;
@synthesize answerData;
@synthesize wordTableView;
@synthesize commArray;
@synthesize commNumber;
@synthesize commTableView;
//@synthesize inputText;
@synthesize isNewComm;
@synthesize nowPage;
@synthesize totalPage;
@synthesize lyricLabel;
@synthesize queLabel;
@synthesize CourierOne;
@synthesize CourierTwo;
@synthesize fixTimeView;
@synthesize myPick;
@synthesize minsArray;
@synthesize hoursArray;
@synthesize fixButton;
@synthesize isFixing;
@synthesize clockButton;
@synthesize fixTimer;
@synthesize secsArray;
@synthesize fixSeconds;
@synthesize flushList;
@synthesize contentMode;
@synthesize playMode;
@synthesize listArray;
@synthesize modeBtn;
@synthesize displayModeBtn;
@synthesize playIndex;
@synthesize HUD;
//@synthesize keyCommFd;
//@synthesize comTool;
@synthesize textView;
@synthesize containerView;
//@synthesize lvlMeter_in;
@synthesize recordLabel;
@synthesize btn_play;
@synthesize btn_record;
@synthesize recordSeconds;
@synthesize recordTime;
@synthesize recordTimer;
@synthesize nowRecordSeconds;
//@synthesize isHeadphone;
//@synthesize commController;
//@synthesize soundFileURLRef;
//@synthesize soundFileObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    isiPhone = ![Constants isPad];
	if (isiPhone) {
        self = [super initWithNibName:@"PlayViewController" bundle:nibBundleOrNil];
	}else {
        self = [super initWithNibName:@"PlayViewController-iPad" bundle:nibBundleOrNil];
    }
    if (self) {
        //        NSLog(@"%@",nibNameOrNil);
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - static method
+ (PlayViewController *)sharedPlayer
{
    static PlayViewController *sharedPlayer;
    
    @synchronized(self)
    {
        if (!sharedPlayer){
            sharedPlayer = [[PlayViewController alloc] init];
            //            sharedPlayer.voa = voa;
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

#pragma mark - instance method
- (IBAction) changeMode:(UIButton *)sender {
    playMode = (playMode + 1 > 3 ? 1 : playMode + 1);
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:playMode] forKey:@"playMode"];
    switch (playMode) {
        case 1:
            if (isiPhone) {
                [modeBtn setImage:[UIImage imageNamed:@"sin.png"] forState:UIControlStateNormal];
            } else {
                [modeBtn setImage:[UIImage imageNamed:@"sinP.png"] forState:UIControlStateNormal];
            }
            
            [displayModeBtn setTitle:@"单曲循环" forState:UIControlStateNormal]; 
            break;
        case 2:
            if (isiPhone) {
                [modeBtn setImage:[UIImage imageNamed:@"seq.png"] forState:UIControlStateNormal];
            } else {
                [modeBtn setImage:[UIImage imageNamed:@"seqP.png"] forState:UIControlStateNormal];
            }
            
            [displayModeBtn setTitle:@"顺序播放" forState:UIControlStateNormal];
            break;
        case 3:
            if (isiPhone) {
                [modeBtn setImage:[UIImage imageNamed:@"ran.png"] forState:UIControlStateNormal];
            } else {
                [modeBtn setImage:[UIImage imageNamed:@"ranP.png"] forState:UIControlStateNormal];
            }
            
            [displayModeBtn setTitle:@"随机播放" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    [UIView beginAnimations:@"Display" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [displayModeBtn setAlpha:0.8];
    [UIView commitAnimations];
    
    [UIView beginAnimations:@"Dismiss" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:2.0];
    [displayModeBtn setAlpha:0];
    [UIView commitAnimations];
}

- (void) showFix:(id)sender
{
    //设置两个View切换时的淡入淡出效果
    [UIView beginAnimations:@"Switch" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:.5];
    [fixTimeView setAlpha:0.6];
    [UIView commitAnimations];
}

- (IBAction) doFix:(id)sender
{
//    [self changeTimer];
    if (isFixing) {
        isFixing = NO;
        [fixButton setTitle:@"开启定时" forState:UIControlStateNormal];
        if (isiPhone) {
            [clockButton setImage:[UIImage imageNamed:@"clockBBC.png"] forState:UIControlStateNormal];
        } else {
            [clockButton setImage:[UIImage imageNamed:@"clockBBCP.png"] forState:UIControlStateNormal];
        }
        
        [self changeTimer];
//        [myPick selectRow:[myPick selectedRowInComponent:kMinComponent]+1 inComponent:kMinComponent animated:YES];
    } else {
        
        NSString *fixHour = [hoursArray objectAtIndex:[myPick selectedRowInComponent:kHourComponent]];
        NSString *fixMinute = [minsArray objectAtIndex:[myPick selectedRowInComponent:kMinComponent]];
        NSString *fixSecond = [minsArray objectAtIndex:[myPick selectedRowInComponent:kSecComponent]];
        fixSeconds = ([fixHour intValue]*60 + [fixMinute intValue])*60 + [fixSecond intValue];
        if (fixSeconds>0) {
            isFixing = YES;
            [fixButton setTitle:@"取消定时" forState:UIControlStateNormal];
            if (isiPhone) {
                [clockButton setImage:[UIImage imageNamed:@"clockedBBC.png"] forState:UIControlStateNormal];
            } else {
                [clockButton setImage:[UIImage imageNamed:@"clockedBBCP.png"] forState:UIControlStateNormal];
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
    if ([fixTimer isValid]) {
        [fixTimer invalidate];
        fixTimer = nil;
    } else {
        fixTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                    target:self
                                                  selector:@selector(handleFixTimer)
                                                  userInfo:nil
                                                   repeats:YES];
    }
    
}

-(void) handleFixTimer {
    fixSeconds--;
    if (fixSeconds != 0) {
        int sec = [myPick selectedRowInComponent:kSecComponent];
        int min = [myPick selectedRowInComponent:kMinComponent];
        int hour = [myPick selectedRowInComponent:kHourComponent];
        if (sec > 0) {
            [myPick selectRow:sec-1 inComponent:kSecComponent animated:YES];
        } else {
            if (min > 0) {
                [myPick selectRow:[self.secsArray count]-1 inComponent:kSecComponent animated:YES];
                [myPick selectRow:min-1 inComponent:kMinComponent animated:YES];
            } else {
                if (hour > 0) {
                    [myPick selectRow:[self.secsArray count]-1 inComponent:kSecComponent animated:YES];
                    [myPick selectRow:[self.minsArray count]-1 inComponent:kMinComponent animated:YES];
                    [myPick selectRow:hour-1 inComponent:kHourComponent animated:YES];
                }
                /*这句话其实可以不用写，为了保险起见就写了吧，。。*/
                else {
                    if ([self isPlaying]) {
                        [self playButtonPressed:playButton];
                    }
                    [myPick selectRow:0 inComponent:kSecComponent animated:YES];
                    [fixTimer invalidate];
                    fixTimer = nil;
                    isFixing = NO;
                    [fixButton setTitle:@"开启定时" forState:UIControlStateNormal];
                    if (isiPhone) {
                        [clockButton setImage:[UIImage imageNamed:@"clockBBC.png"] forState:UIControlStateNormal];
                    } else {
                        [clockButton setImage:[UIImage imageNamed:@"clockBBCP.png"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    } else {
        if ([self isPlaying]) {
            [self playButtonPressed:playButton];
        }
        [myPick selectRow:0 inComponent:kSecComponent animated:YES];
        [fixTimer invalidate];
        fixTimer = nil;
        isFixing = NO;
        [fixButton setTitle:@"开启定时" forState:UIControlStateNormal];
        if (isiPhone) {
            [clockButton setImage:[UIImage imageNamed:@"clockBBC.png"] forState:UIControlStateNormal];
        } else {
            [clockButton setImage:[UIImage imageNamed:@"clockBBCP.png"] forState:UIControlStateNormal];
        }
        
    }
    
    
}

//- (void) stopRecord {
////    [controller record:nil];
//    [controller myStopRecord];
//}
//
//- (void) stopRecordPlay {
//    [controller stopPlayQueue];
//}

//#pragma mark - My action
//
//- (IBAction) showComments:(id)sender {
//    if (isExisitNet) {
//        CommentViewController *voaComment = [[CommentViewController alloc] init];
//        voaComment.voaid = [voa _voaid];
//        [self.navigationController pushViewController:voaComment animated:YES];
//        [voaComment release], voaComment = nil;
//    }
//}

- (IBAction) shareTo:(id)sender {
    
    if (isiPhone) {
        UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"分享当前新闻到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网", nil];
        [share showInView:self.view.window];
    } else {
        UIActionSheet *share = [[UIActionSheet alloc] initWithTitle:@"分享当前新闻到" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"新浪微博",@"人人网", nil];
        [share showInView:self.view];
    }
}


- (void) touchAnswerBtn:(UIButton*)sender {
    NSInteger right = [VOAView getRightByVoaid:voa._voaid];
    if (sender.tag == right) {
//        [sender setTitle:@"right" forState:UIControlStateNormal];
        [sender setImage:[UIImage imageNamed:@"RightTick.png"] forState:UIControlStateNormal];
    } else {
//        [sender setTitle:@"wrong" forState:UIControlStateNormal]; 
        [sender setImage:[UIImage imageNamed:@"WrongX.png"] forState:UIControlStateNormal];
        
        switch (right) {
            case 1:
//                [aButton setTitle:@"right" forState:UIControlStateNormal];
                [aButton setImage:[UIImage imageNamed:@"RightTick.png"] forState:UIControlStateNormal];
                break;
            case 2: 
//                [bButton setTitle:@"right" forState:UIControlStateNormal];
                [bButton setImage:[UIImage imageNamed:@"RightTick.png"] forState:UIControlStateNormal];
                break;
            case 3: 
//                [cButton setTitle:@"right" forState:UIControlStateNormal];
                [cButton setImage:[UIImage imageNamed:@"RightTick.png"] forState:UIControlStateNormal];
                break;
            default:
                break;
        }
    }
}

- (IBAction) changeView:(UIButton *)sender {
    //设置两个View切换时的淡入淡出效果
//    [UIView beginAnimations:@"Switch" context:nil];
//    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//    [UIView setAnimationDuration:.5];
//    [RoundBack setCenter:sender.center];
//    CGFloat pageWidth = myScroll.frame.size.width;
    /* 下取整直接去掉小数位 */
    int page = sender.tag-1;
    CGRect frame = myScroll.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [myScroll scrollRectToVisible:frame animated:YES];
    
//    pageControl.currentPage = page-1;
//    [pageControl updateAfterScroll];
//    
//    [UIView commitAnimations];
}

- (void)shareAll {
//    if (isExisitNet) {
//        NSString * time = [[voa._creatTime componentsMatchedByRegex:@"\\S+"] objectAtIndex:0];
//        NSString * Message = [NSString stringWithFormat:@"@爱语吧 BBC六分钟英语%@的新闻:%@很不错哦,你也来听听吧,试试有木有",time,voa._title];
    NSString * Message = (isShareSen?[NSString stringWithFormat:@"@爱语吧 好喜欢这个句子\\^o^/:%@",shareStr]: [NSString stringWithFormat:@"@爱语吧 BBC六分钟英语的话题:%@是极好的,你也来听听吧,瞧瞧有木有",voa._title]);

        int nowUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
        if (nowUserID > 0) {
//            [ShareToCNBox showWithText:Message link:[NSString stringWithFormat:@"http://apps.iyuba.com/voa/showItem.jsp?voaId=%d&network=weibo&userId=%d",voa._voaid,nowUserID] titleId:voa._voaid];
            [ShareToCNBox showWithText:Message link:[NSString stringWithFormat:@"http://apps.iyuba.com/minutes/showItem.jsp?network=weibo&BbcId=%d&userId=%d",voa._voaid,nowUserID] titleId:voa._voaid];
        } else {
            [ShareToCNBox showWithText:Message link:[NSString stringWithFormat:@"http://apps.iyuba.com/minutes/showItem.jsp?network=weibo&BbcId=%d",voa._voaid] titleId:voa._voaid];
        }
//    } else {
//        UIAlertView * alertShare = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"请您确保已连接网络" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertShare show];
//        [alertShare release];
//    }
//    NSLog(@"retina:%f",[[UIScreen mainScreen]scale]); 
}

/*- (void)ShareThisQuestion{
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
        NSString * Message = [NSString stringWithFormat:@"爱语吧BBC六分钟英语%@的新闻",time];
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
                                     (isShareSen?[NSString stringWithFormat:@"这个句子不错哦\\^o^/:%@",shareStr]: [NSString stringWithFormat:@"\"%@\"这篇文章-哎呦,不错哦!大家都来听听看,有木有。边听边看读新闻,轻松舒畅学英语", voa._title]) ,@"message",
                                     nil];
        //    NSLog(@"param:%@",[params valueForKey:@"action_name"]);
        [shareTool PublishFeedOnRenRen:self WithFeedParam:params TitleId:[NSString stringWithFormat:@"%d",voa._voaid]];
//    } else {
//        UIAlertView * alertShare = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"请您确保已连接网络" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alertShare show];
//        [alertShare release];
//    }
}*/

- (CMTime)playerItemDuration
{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.3){
        /*
         * ios4.3以上使用下面的
         */
        AVPlayerItem *playerItem = [player currentItem];   
        return([playerItem duration]);
    }
    else {
        NSArray* seekRanges = [player.currentItem seekableTimeRanges];
        if (seekRanges.count > 0)  
        {  
            CMTimeRange range = [[seekRanges objectAtIndex:0] CMTimeRangeValue];  
            double duration = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);  
            return CMTimeMakeWithSeconds(duration, NSEC_PER_SEC);
        }
        return CMTimeMakeWithSeconds(0.f, NSEC_PER_SEC);
    }
    
}

//-(void)updateCurrentTimeForPlayer:(AVPlayer *)p
//{
//    if (player.rate != 0.0)
//	{
//        CMTime playerDuration = [self playerItemDuration];
//        double duration = CMTimeGetSeconds(playerDuration);
//        CMTime playerProgress = [player currentTime];
//        double progress = CMTimeGetSeconds(playerProgress);
//		
////		if (duration > 0&&progress<duration-10)
//        if (duration >= 0 && progress <= duration)
//		{
//            [timeSlider setValue:progress];
//			totalTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
//            currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:progress];
//            //            NSLog(@"系统:%@",[timeSwitchClass timeToSwitchAdvance:progress]);
//            timeSlider.maximumValue = duration;
//			[timeSlider setEnabled:YES];
//		}
//		else
//		{
//		}
//        
//	}
//	//NSLog(@"-----lrcDisplay-----%@",[lrc getCurrentLrcWithTime:p.currentTime]);
//	
//}

- (IBAction) goBack:(UIButton *)sender
{
    if (![explainView isHidden]) {
        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
    }
    //    afterRecord = NO;
    [self myStopRecord];
    [self stopPlayRecord];
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)changePage:(UIPageControl *)sender
{
    int page = pageControl.currentPage;
    CGRect frame = myScroll.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [myScroll scrollRectToVisible:frame animated:YES];
}
//- (IBAction)changePage:(UIPageControl *)sender
//{
//    int page = pageControl.currentPage;
//    if (page > 1) {
//        //该代码是设置手机喇叭与麦克风同时工作 iphone 3.0以上版本 播放类型
//        UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
//        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
//        //设置采样率的
//        Float64 smpl=kAudioSessionProperty_CurrentHardwareSampleRate;
//        AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, sizeof(smpl), &smpl);
//        //设置声音输出扬声器 还是默认的接收器kAudioSessionOverrideAudioRoute_None
//        UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker; 
//        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRoute);
//        
//        double engHight = [@"a" sizeWithFont:CourierOne].height;
//        
////        NSLog(@"sen_num1:%d",sen_num);
//        CMTime playerProgress = [player currentTime];
//        double progress = CMTimeGetSeconds(playerProgress);
//        int i = 0;
//        for (; i < [timeArray count]; i++) {
//            if ((int)progress < [[timeArray objectAtIndex:i] unsignedIntValue]) {
//                sen_num = i+1;//跟读标识句子号
//                controller.recordTime = (i > 0 ? [[timeArray objectAtIndex:i] unsignedIntValue] - [[timeArray objectAtIndex:i-1] unsignedIntValue] : [[timeArray objectAtIndex:i] unsignedIntValue]) ;
//                break;
//            }
//        }
//        
//        [lyCn release];
//        [lyEn release];
//        lyEn = [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
//        lyCn = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
//        
//        int eLines = 0;
//        
//        if (isiPhone) {
//            eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
//            [lyricLabel setFrame:CGRectMake(670, 20, 260, eLines * engHight)];
//            [lyricCnLabel setFrame:CGRectMake(670, 20+eLines * engHight, 260, 268-eLines * engHight)];
//        }else {
//            eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(568, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
//            [lyricLabel setFrame:CGRectMake(1636, 50, 568, eLines * engHight)];
//            [lyricCnLabel setFrame:CGRectMake(1636, 50+eLines * engHight, 568, 615-eLines * engHight)];
//            
//        }
//        
//        lyricLabel.text = lyEn;
//        if (![lyCn isEqualToString:@"null"] && ![lyCn isEqualToString:@""] && ![lyCn isEqualToString:@"test"]) {
//            lyricCnLabel.text = lyCn;
//        }else{
//            lyricCnLabel.text = @"";
//        }
//        //        lyricCnLabel.text = lyCn;
//        readRecord = YES;
//        [playButton setHidden:YES];
//        [timeSlider setHidden:YES];
//        [currentTimeLabel setHidden:YES];
//        [totalTimeLabel  setHidden:YES];
//        [loadProgress setHidden:YES];
//        [downloadFlg setHidden:YES];
//        [collectButton setHidden:YES];
//        [downloadingFlg setHidden:YES];
//        [controller.btn_play setHidden:NO];
//        [controller.btn_record setHidden:NO];
//        [controller.lvlMeter_in setHidden:NO];
//    }else {
//        //此种模式下无法播放的同时录音
//        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
//        
//        [controller myStopRecord];
//        readRecord = NO;
//        [playButton setHidden:NO];
//        [timeSlider setHidden:NO];
//        [currentTimeLabel setHidden:NO];
//        [totalTimeLabel  setHidden:NO];
//        [loadProgress setHidden:NO];
//        [controller.btn_play setHidden:YES];
//        [controller.btn_record setHidden:YES];
//        [controller.lvlMeter_in setHidden:YES];
//        if (localFileExist) {
//            [downloadFlg setHidden:NO];
//        } else if ([VOAView isDownloading:voa._voaid]) {
//            [downloadingFlg setHidden:NO];
//        } else {
//            [collectButton setHidden:NO];
//        }
//    }
//    CGRect frame = myScroll.frame;
//    frame.origin.x = frame.size.width * page;
//    frame.origin.y = 0;
//    [myScroll scrollRectToVisible:frame animated:YES];
//}

//- (void)keyboardWillHide:(NSNotification *)note {
    /*NSTimeInterval animationDuration = 0.30f;  
    CGRect frame = myView.frame;   
    if (isiPhone) {
        //        frame.origin.y +=216;        
        //        frame.size.height -=216; 
        //        frame.origin.y +=246;        
        //        frame.size.height -=246; 
        frame.origin.y +=124;        
        frame.size.height -=124; 
    } else {
        //        frame.origin.y +=264;        
        //        frame.size.height -=264; 
        //        frame.origin.y +=294;        
        //        frame.size.height -=294; 
        frame.origin.y +=94;        
        frame.size.height -=94;
    }
    NSLog(@"keyboardWillHide");
//    self.view.frame = frame;  
    //self.view移回原位置  
    if (myView.tag == 1) {
        myView.tag = 0;
        [UIView beginAnimations:@"ResizeView" context:nil];  
        [UIView setAnimationDuration:animationDuration];  
        myView.frame = frame;                  
        [UIView commitAnimations];
    }*/
//}

//- (void)keyboardWillShow:(NSNotification *)note {
//    NSLog(@"yes");
////    // create custom button
////    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
////    doneButton.frame = CGRectMake(0, -20, 106, 53);
////    doneButton.adjustsImageWhenHighlighted = NO;
////    [doneButton setTitle:@"发表" forState:UIControlStateNormal];
////    [doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
////    // locate keyboard view
////    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
////    UIView* keyboard;
////    NSLog(@"number:%i",[tempWindow.subviews count]);
////    for(int i=0; i<[tempWindow.subviews count]; i++) {
////        keyboard = [tempWindow.subviews objectAtIndex:i];
////        // keyboard view found; add the custom button to it
////        if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES) {
////            [keyboard addSubview:doneButton];
////            NSLog(@"keyboard");
////        }
////        
////    }
//    
//    
//    
//}

//- (void) doCancle{
////    if ([keyCommFd isFirstResponder]) {
//        [self.view endEditing:YES];
////        [keyCommFd resignFirstResponder];
////        [inputText resignFirstResponder];
////    }
//}

- (void) doSend{
    if ([[textView text] length] > 0) {
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
    nowUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
//    NSLog(@"生词本添加用户：%d",nowUserId);
    myWord.userId = nowUserId;
    if (nowUserId>0) {
        if ([myWord alterCollect]) {
            alert = [[UIAlertView alloc] initWithTitle:kWordTwo message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            
            [alert setBackgroundColor:[UIColor clearColor]];
            
            [alert setContentMode:UIViewContentModeScaleAspectFit];
            
            [alert show];
            
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

- (void) playWord:(UIButton *)sender
{
    if (wordPlayer) {
        [wordPlayer release];
    }
    wordPlayer =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:myWord.audio]];
    [wordPlayer play];
}

- (BOOL)isPlaying
{
//    NSLog(@"player rate = %lf %d",[player rate], [player rate] != 0.f);
	return [player rate] != 0.f;
}

- (IBAction)prePlay:(id)sender
{
    if (!player) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem  playerItemWithAsset:avSet] ];
        } else{
            player = [[AVPlayer alloc] initWithURL:mp3Url];
        }
        [player seekToTime:nowTime];
        //        afterRecord = NO;
    }
    if (sen_num>2) {
        sen_num--;
    }
    if (readRecord) {
        if (notValid) {
            lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(lyricSyn)
                                                           userInfo:nil
                                                            repeats:YES];
            sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                           target:self
                                                         selector:@selector(updateSlider)
                                                         userInfo:nil
                                                          repeats:YES];
            notValid = NO;
        }
        [self myStopRecord];
        [self stopPlayRecord];
//        double engHight = [@"a" sizeWithFont:CourierOne].height;
        if (![self isPlaying] && sen_num>1) {
            [player seekToTime:CMTimeMakeWithSeconds([[timeArray objectAtIndex:sen_num-1] unsignedIntValue], NSEC_PER_SEC)];
        }
        recordTime = (sen_num > 1 ? [[timeArray objectAtIndex:sen_num-1] unsignedIntValue] - [[timeArray objectAtIndex:sen_num-2] unsignedIntValue] : [[timeArray objectAtIndex:0] unsignedIntValue]) ;
//        NSLog(@"controller.recordTime:%d",controller.recordTime);
        [player play];
        if (isiPhone) {
            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBC.png"] forState:UIControlStateNormal];
        } else {
            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBCP.png"] forState:UIControlStateNormal];
        }
        double engHight = [@"a" sizeWithFont:CourierOne].height;
        [lyCn release];
        [lyEn release];
        lyEn = [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
        lyCn = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
        int eLines = 0;
        
        if (isiPhone) {
            eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
            [lyricLabel setFrame:CGRectMake(670, 20, 260, eLines * engHight)];
            [lyricCnLabel setFrame:CGRectMake(670, 20+eLines * engHight, 260, 300-eLines * engHight)];
        }else {
            eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(568, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
            [lyricLabel setFrame:CGRectMake(1636, 50, 568, eLines * engHight)];
            [lyricCnLabel setFrame:CGRectMake(1636, 50+eLines * engHight, 568, 615-eLines * engHight)];
            
        }
        lyricLabel.text = lyEn;
//        [lyEn release];
        [lyricLabel setNumberOfLines:10];
        if (![lyCn isEqualToString:@"null"] && ![lyCn isEqualToString:@""] && ![lyCn isEqualToString:@"test"]) {
            lyricCnLabel.text = lyCn;
//            [lyCn release];
        }else{
            lyricCnLabel.text = @"";
        }
        //        lyricCnLabel.text = lyCn;
//        [lyricCnLabel setNumberOfLines:cLines];
    }else {
        [LyricSynClass preLyricSyn:timeArray localPlayer:player];
    }
    if ([self isPlaying]) {
        [LyricSynClass preLyricSyn:timeArray localPlayer:player];
    }
}

- (IBAction)aftPlay:(id)sender
{
//    AudioServicesPlaySystemSound (soundFileObject);
    if (!player) {
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem  playerItemWithAsset:avSet] ];
        } else {
            player = [[AVPlayer alloc] initWithURL:mp3Url];
        }
        [player seekToTime:nowTime];
        //        afterRecord = NO;
    }
    if (readRecord) {
        if (notValid) {
            lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(lyricSyn)
                                                           userInfo:nil
                                                            repeats:YES];
            sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                           target:self
                                                         selector:@selector(updateSlider)
                                                         userInfo:nil
                                                          repeats:YES];
            notValid = NO;
        }
        [self myStopRecord];
        [self stopPlayRecord];
        if (sen_num < [timeArray count]+1 && [self isPlaying]) {
            //        if (sen_num < [timeArray count]) {
            sen_num++;
            [player seekToTime:CMTimeMakeWithSeconds([[timeArray objectAtIndex:sen_num-2] unsignedIntValue], NSEC_PER_SEC)];
        }
        if (sen_num == [timeArray count]+1) {
            recordTime = 6;
        } else {
            recordTime = [[timeArray objectAtIndex:sen_num-1] unsignedIntValue] - [[timeArray objectAtIndex:sen_num-2] unsignedIntValue] ;
        }
        [player play];
        if (isiPhone) {
            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBC.png"] forState:UIControlStateNormal];
        } else {
            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBCP.png"] forState:UIControlStateNormal];
        }
        double engHight = [@"a" sizeWithFont:CourierOne].height;
        [lyCn release];
        [lyEn release];
        lyEn = [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
        lyCn = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
        
        int eLines = 0;
        
        if (isiPhone) {
            eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
            [lyricLabel setFrame:CGRectMake(670, 20, 260, eLines * engHight)];
            [lyricCnLabel setFrame:CGRectMake(670, 20+eLines * engHight, 260, 300-eLines * engHight)];
        }else {
            eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(568, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
            [lyricLabel setFrame:CGRectMake(1636, 50, 568, eLines * engHight)];
            [lyricCnLabel setFrame:CGRectMake(1636, 50+eLines * engHight, 568, 615-eLines * engHight)];
            
        }
        
        lyricLabel.text = lyEn;
//        [lyEn release];
        [lyricLabel setNumberOfLines:10];
        if (![lyCn isEqualToString:@"null"] && ![lyCn isEqualToString:@""] && ![lyCn isEqualToString:@"test"]) {
            lyricCnLabel.text = lyCn;
//            [lyCn release];
        }else{
            lyricCnLabel.text = @"";
        }
        //        lyricCnLabel.text = lyCn;
//        [lyricCnLabel setNumberOfLines:cLines];    
    }else {
        [LyricSynClass aftLyricSyn:timeArray localPlayer:player];
    }
}

//- (IBAction) recordButtonPressed:(UIButton *)sender
//{
//    if (localFileExist) {
//        if ([self isPlaying])
//        {
//            [lyricSynTimer invalidate];
//            lyricSynTimer = nil;
//            [self setButtonImage:pauseImage];
//        }
//    }else
//    {
//        if ([self isPlaying])
//        {
//            [lyricSynTimer invalidate];
//            lyricSynTimer = nil;
//            [self setButtonImage:pauseImage];
//        }
//    }
//    [controller record];
//}

- (IBAction) playButtonPressed:(UIButton *)sender
{
    if (!player) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem  playerItemWithAsset:avSet] ];
        } else {
            player = [[AVPlayer alloc] initWithURL:mp3Url];
        }
        [player seekToTime:nowTime];
        //        afterRecord = NO;
    }
    if (localFileExist) {
        playerFlag = 0;
        if(!readRecord && downloaded){
            if (!notValid) {
                [lyricSynTimer invalidate];
                //            lyricSynTimer = nil;
                [sliderTimer invalidate];
                //            sliderTimer = nil;
                notValid = YES;
            }
            
            [loadProgress setProgress:1.0f];
            CMTime timeM = [player currentTime];
            [player pause];
            [player release];
            player = nil;
//            [localPlayer release];
            [playButton.layer removeAllAnimations];
            alert = [[UIAlertView alloc] initWithTitle:kPlayOne message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
            
            [alert setBackgroundColor:[UIColor clearColor]];
            
            [alert setContentMode:UIViewContentModeScaleAspectFit];
            
            [alert show];
            
            NSTimer *timer = nil;
            timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(c) userInfo:nil repeats:NO];
            
            NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            //创建audio份目录在Documents文件夹下，not to back up
            NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];
            
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
                avSet = [AVAsset assetWithURL:[NSURL fileURLWithPath:[audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d.mp3", voa._voaid]]]];
                [avSet retain];
                player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithAsset:avSet]];
            } else {
                mp3Url = [NSURL fileURLWithPath:[audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d.mp3", voa._voaid]]];
                [mp3Url retain];
                player = [[AVPlayer alloc] initWithURL:mp3Url];
            }
            
            [player seekToTime:timeM];
            CMTime playerDuration = [self playerItemDuration];
            double duration = CMTimeGetSeconds(playerDuration);
            
            CMTime playerProgress = [player currentTime];
            double progress = CMTimeGetSeconds(playerProgress);
            //            NSLog(@"download wancheng");  
            //  获取mp3起止时间	
            if (!readRecord) {
                [totalTimeLabel setHidden:NO];
                [currentTimeLabel setHidden:NO];
            }
            currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:progress];
            //            NSLog(@"%@", [timeSwitchClass timeToSwitchAdvance:localPlayer.currentTime]);
            totalTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
            downloaded = NO;
        }
        if ([self isPlaying])
        {
            if (!notValid) {
                [lyricSynTimer invalidate];
                //            lyricSynTimer = nil;
                [sliderTimer invalidate];
                //            sliderTimer = nil;
                notValid = YES;
            }
            [self setButtonImage:pauseImage];
        }else {
            [self setButtonImage:playImage];
            
            if (notValid) {
                lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                 target:self
                                                               selector:@selector(lyricSyn)
                                                               userInfo:nil
                                                                repeats:YES];
                sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                               target:self
                                                             selector:@selector(updateSlider)
                                                             userInfo:nil
                                                              repeats:YES];
                notValid = NO;
            }

        }
        
        CMTime playerDuration = [self playerItemDuration];
        double duration = CMTimeGetSeconds(playerDuration);
        //  Set the maximum value of the UISlider
        timeSlider.maximumValue = duration;
        
        //	Play the audio
        [MP3PlayerClass playButton:playButton 
                       localPlayer:player];
    }
    else
    {
        if ([self isExistenceNetwork:1]) {
            myStop = -1;
            playerFlag = 1;
            if (!readRecord) {
                [currentTimeLabel setHidden:NO];
            }
            if ([self isPlaying])
            {
                if (!notValid) {
                    [lyricSynTimer invalidate];
                    //                lyricSynTimer = nil;
                    [sliderTimer invalidate];
                    //                sliderTimer = nil;
                    notValid = YES;
                }
                [self setButtonImage:pauseImage];
            }else {
                if (notValid) {
                    lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                     target:self
                                                                   selector:@selector(lyricSyn)
                                                                   userInfo:nil
                                                                    repeats:YES];
                    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                                   target:self
                                                                 selector:@selector(updateSlider)
                                                                 userInfo:nil
                                                                  repeats:YES];
                    notValid = NO;
                }
                [self setButtonImage:playImage];
            }
            
            CMTime playerProgress = [player currentTime];
            double progress = CMTimeGetSeconds(playerProgress);
            CMTime playerDuration = [self playerItemDuration];
            double duration = CMTimeGetSeconds(playerDuration);
            currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:progress];
//            NSLog(@"%@", [timeSwitchClass timeToSwitchAdvance:player.progress]);
            totalTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
            timeSlider.maximumValue = duration;
            [MP3PlayerClass playButton:playButton 
                              localPlayer:player];
//            if ([self isPlaying]) {
//                #if 1
//                            lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
//                                                                            target:self 
//                                                                           selector:@selector(lyricSyn) 
//                                                                           userInfo:nil 
//                                                                            repeats:YES];
//                #endif
//            }
            
        }
    }
}

-(void)c
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
}

- (void)setButtonImage:(UIImage *)image
{
	[playButton.layer removeAllAnimations];
	if (!image)
	{
		[playButton setImage:playImage forState:0];
	}
	else
	{
		[playButton setImage:image forState:0];
		
		if ([playButton.currentImage isEqual:loadingImage])
		{
			[self spinButton];
		}
	}
}

- (void)spinButton
{
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    CGRect frame = [playButton frame];
    playButton.layer.anchorPoint = CGPointMake(0.5, 0.5);
    playButton.layer.position = CGPointMake(frame.origin.x + 0.5 * frame.size.width, frame.origin.y + 0.5 * frame.size.height);
    [CATransaction commit];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:120.0] forKey:kCATransactionAnimationDuration];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:120 * M_PI];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    [playButton.layer addAnimation:animation forKey:@"rotationAnimation"];
    [CATransaction commit];
	
}

- (void)collectButtonPressed:(UIButton *)sender {
//    NSLog(@"%d,%@,%@",[voa _voaid],[voa _title],[voa _creatTime]);
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoDownload"]) {
        [self QueueDownloadVoa];
        [collectButton setHidden:YES];
        [downloadFlg setHidden:YES];
        [downloadingFlg setHidden:NO];
    } else {
        UIAlertView *downAlert = [[UIAlertView alloc] initWithTitle:kPlayTwo message:kPlayThree delegate:self cancelButtonTitle:kFeedbackFive otherButtonTitles:kPlayFour,nil];
        [downAlert setTag:1];
        [downAlert show];
    }
	
}

- (IBAction) sliderChanged:(UISlider *)slider{
    noBuffering = NO;
    seekTo = [slider value];
    CMTime playerProgress = [player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    [self setButtonImage:loadingImage];
    [MP3PlayerClass timeSliderChanged:slider 
                        timeSlider:timeSlider 
                        localPlayer:player 
                            button:playButton];
//    [timeSlider setEnabled:NO];
    int i = 0;
    for (; i < [timeArray count]; i++) {
        if ((int)progress < [[timeArray objectAtIndex:i] unsignedIntValue]) {
            sen_num = i;//跟读标识句子号
            return;
        }
    }
}

- (NSInteger) indexOfArray:(NSMutableArray *) array bbcId:(NSInteger)bbcId
{
    NSInteger i = 0;
    for (i = 0; i < [array count]; i++) {
        if ([[array objectAtIndex:i] integerValue] == bbcId) {
            return i;
        }
    }
    return 0;
}

// Update the slider about the music time
- (void)updateSlider {	
    CMTime playerProgress = [player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    double duration = CMTimeGetSeconds([self playerItemDuration]);
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.3){
//        NSLog(@"Version>=4.3");
    }else {
//        NSArray* seekRanges = [player.currentItem seekableTimeRanges];
//        if (seekRanges.count > 0)  
//        {  
//            CMTimeRange range = [[seekRanges objectAtIndex:0] CMTimeRangeValue];  
//            duration = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);  
//            NSLog(@"duration2:%g", duration);  
        totalTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
        timeSlider.maximumValue = duration;
//        }
    }
    
    NSArray* loadedRanges = player.currentItem.loadedTimeRanges;  
    if (loadedRanges.count > 0 && playerFlag == 1)  
    {  
        CMTimeRange range = [[loadedRanges objectAtIndex:0] CMTimeRangeValue];  
        double loaded = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);  
//        NSLog(@"loaded:%g", loaded);
        if (duration>0.f) {
            [loadProgress setProgress:(loaded/duration)];
        }
    }
    
    if (!noBuffering && progress<seekTo && progress > 1) {
        
    }
    else {
        noBuffering = YES;
        if (timeSlider.maximumValue >= progress) { //#$$#
            timeSlider.value = progress;
        }
        
//        NSLog(@"当前进度:%f",progress);
        currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:progress];
        if (progress == 0.f) {
            [player play];
            [playButton.layer removeAllAnimations];
            if (isiPhone) {
                [playButton setImage:[UIImage imageNamed:@"PplayPressedBBC.png"] forState:UIControlStateNormal];
            } else {
                [playButton setImage:[UIImage imageNamed:@"PplayPressedBBCP.png"] forState:UIControlStateNormal];
            }
        }    
//        [player ]
        if (timeSlider.maximumValue-0.3 <= timeSlider.value) {
//            NSLog(@"playMode = %i",playMode);
            if (playMode == 1) {
                [playButton.layer removeAllAnimations];
                [player seekToTime:kCMTimeZero];
                sen_num = 1;
            } else {
                if (playMode == 3) {
                    NSInteger next = arc4random()%[listArray count];
//                    NSLog(@"结束index = %i",next);
                    NSInteger playId = [[listArray objectAtIndex:next] integerValue];
//                    if (contentMode == 1) {
//                        voa = [VOAView find:playId];
//                    } else if (contentMode == 2) {
                    voa = [VOAView find:playId];
//                    }
                    playIndex = [self indexOfArray:listArray bbcId:voa._voaid] ;
                } else {
//                    NSLog(@"playIndex = %i; count = %i", playIndex , [listArray count]);
                    if (playIndex + 1 == [listArray count]) {
                        
                        playIndex = 0;
                    } else {
                        playIndex++;
//                        NSLog(@"结束index = %i",playIndex);
                    }
                    NSInteger playId = [[listArray objectAtIndex:playIndex] integerValue];
//                    if (contentMode == 1) {
//                        voa = [VOAView find:playId];
//                    } else if (contentMode == 2) {
                    voa = [VOAView find:playId];
//                    }
                    if (contentMode == 1) {
                        if (![VOADetail isExist:voa._voaid]) {
                            //                        NSLog(@"内容不全-%d",voa._voaid);
                            [VOADetail deleteByVoaid: voa._voaid];
                            //                        NSLog(@"voaid:%i",voa._voaid);
                            voa._isRead = @"1";
                            [self catchDetails:voa];
                            [self catchBBCWords:voa._voaid];
                            [self catchQue:voa._voaid];
                        }
                    }
                }
                HUD = [[MBProgressHUD alloc] initWithView:self.view.window];
                [self.view.window addSubview:HUD];
                HUD.delegate = self;
                HUD.labelText = @"Loading";
                [HUD show:YES];
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{  
                    
                    dispatch_async(dispatch_get_main_queue(), ^{  
                         [self initialize];
                    });  
                });
               
            }
//            timeSlider.value = 0.f;
//            [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
        }
        
        //跟读的判断
//        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"recordRead"]) {
        if (readRecord) {
            if (sen_num < [timeArray count]+1 && progress >= [[timeArray objectAtIndex:sen_num-1] floatValue]) {
                sen_num++;
                if ([self isPlaying]) {
                    [self playButtonPressed:playButton];
                }
                
                //开启录音
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"recordRead"] && [self hasMicphone]) {
                    [self startToRecord];
                    
                    //                    AudioServicesPlaySystemSound (soundFileObject);
                    //systemSoundID的取值范围在1000-2000
                    //                    [controller record:controller.btn_record];
                    
                }
                
            }
        }
    }
    
}

// 歌词同步
- (void)lyricSyn {
//    NSLog(@"33");
    CMTime playerDuration = [self playerItemDuration];
    double duration = CMTimeGetSeconds(playerDuration);
    
    CMTime playerProgress = [player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    if (!noBuffering && progress<seekTo && progress > 1) {
//        NSLog(@"等待");
        [self setButtonImage:loadingImage];
    }
    else {
        noBuffering = YES;
        if ([self isPlaying])
        {
//            NSLog(@"播放");
            [self setButtonImage:playImage];
        }
        else if (player.status == AVPlayerItemStatusReadyToPlay)
        {
//            NSLog(@"暂停");
            [self setButtonImage:pauseImage];
        }else if (progress<duration&&!localFileExist)
        {
//            NSLog(@"等待");
            [self setButtonImage:loadingImage];
        }
    }
//    NSLog(@"同步");
    [LyricSynClass lyricSyn : (NSMutableArray *)lyricLabelArray
           lyricCnLabelArray: (NSMutableArray *)lyricCnLabelArray 
                      index : (NSMutableArray *)indexArray
                       time : (NSMutableArray *)timeArray
                localPlayer : (AVPlayer *)player 
                     scroll : (TextScrollView *)textScroll];    
//	NSLog(@"lyricLabelArrayretainnumber:%i", [self.lyricLabelArray retainCount]);
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	
//	[playButton setTitle:@"播放" forState:UIControlStateNormal];
    //	Music completed 
    //	这段加上之后,播放结束时会自动退出，不知原因?
#if 0
	
	if (flag) {
		
		[sliderTimer invalidate];
	}
	
#endif
	
}

- (void)modalView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//点击确定下载为0，取消为1
        if (alertView.tag == 1) {
            [self QueueDownloadVoa];
            [collectButton setHidden:YES];
//            [downloadFlg setHidden:YES];
//            [downloadingFlg setHidden:NO];
        }
        else if (alertView.tag == 2){
            
            [myWord alterCollect];
        }else if (alertView.tag == 3)
        {
            LogController *myLog = [[LogController alloc]init];
            [self.navigationController pushViewController:myLog animated:YES];
            [myLog release], myLog = nil;
        }
    }
    [alertView release];
}

-(BOOL) isExistenceNetwork:(NSInteger)choose
{
    UIAlertView *myalert = nil;
    switch (choose) {
        case 0:
            
            break;
        case 1:
            if (isExisitNet) {
                
            }else {
                myalert = [[UIAlertView alloc] initWithTitle:kInfoTwo message:kRegNine delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil,nil];
                [myalert show];
                [myalert release];
            }
            break;
        default:
            break;
    }    
	return isExisitNet;
}

- (void)wordExistDisplay {
    for (UIView *sView in [explainView subviews]) {
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
    if (isiPhone) {
        [addButton setFrame:CGRectMake(5, 0, 25, 25)];
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierT].width+10, 20)];
        [pronLabel setFrame:CGRectMake(40+[myWord.key sizeWithFont:CourierT].width, 5, [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width+10, 20)];
        [defTextView setFrame:CGRectMake(0, 22, explainView.frame.size.width, 80)];
        [audioButton setFrame:CGRectMake(50+[myWord.key sizeWithFont:CourierT].width + [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width, 5, 20, 20)];
        [wordLabel setFont :CourierT];
        [pronLabel setFont :Courier];
        [defTextView setFont :Courier];
    } else {
        [addButton setFrame:CGRectMake(10, 5, 20, 20)];
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierTD].width+10, 20)];
        [pronLabel setFrame:CGRectMake(40+[myWord.key sizeWithFont:CourierTD].width, 5, [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:CourierD].width+10, 20)];
        [defTextView setFrame:CGRectMake(0, 22, explainView.frame.size.width, 80)];
        [audioButton setFrame:CGRectMake(50+[myWord.key sizeWithFont:CourierTD].width + [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:CourierD].width, 5, 20, 20)];
        [wordLabel setFont :CourierTD];
        [pronLabel setFont :CourierD];
        [defTextView setFont :CourierD];
    }
    
    //                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
    //                [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    [explainView addSubview:addButton];
    
    //                UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:Courier].width+10, 20)];
    //                [wordLabel setFont :Courier];
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    [wordLabel setTextColor:[UIColor whiteColor]];
    wordLabel.text = myWord.key;
    wordLabel.backgroundColor = [UIColor clearColor];
    [explainView addSubview:wordLabel];
    [wordLabel release];
    
    
    
    [pronLabel setTextColor:[UIColor whiteColor]];
    [pronLabel setTextAlignment:UITextAlignmentLeft];
    if ([myWord.pron isEqualToString:@" "]) {
        pronLabel.text = @"";
    }else
    {
        pronLabel.text = [NSString stringWithFormat:@"[%@]", myWord.pron];
    }
    pronLabel.backgroundColor = [UIColor clearColor];
    [explainView addSubview:pronLabel];
    [pronLabel release];
    
    if (wordPlayer) {
        [wordPlayer release];
    }
    wordPlayer =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:myWord.audio]];
    [wordPlayer play];
    
    
    [audioButton setImage:[UIImage imageNamed:@"wordSound.png"] forState:UIControlStateNormal];
    [audioButton addTarget:self action:@selector(playWord:) forControlEvents:UIControlEventTouchUpInside];
    
    [explainView addSubview:audioButton];
    
    
    if ([myWord.def isEqualToString:@" "]) {
        defTextView.text = kPlaySeven;
        //                    NSLog(@"未联网无法查看释义!");             
    }else{
        defTextView.text = myWord.def;
    }
    [defTextView setEditable:NO];
    
    [defTextView setTextColor:[UIColor whiteColor]];
    defTextView.backgroundColor = [UIColor clearColor];
    [explainView addSubview:defTextView];  
    [defTextView release];
    //                [explainView setAlpha:1];
    [explainView setHidden:NO];
}

- (void)wordNoDisplay {
    for (UIView *sView in [explainView subviews]) {
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
    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, explainView.frame.size.width, 80)];
    if (isiPhone) {
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierT].width+10, 20)];
        [wordLabel setFont :CourierT];
        [defLabel setFont :Courier];
    } else {
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierTD].width+10, 20)];
        [wordLabel setFont :CourierTD];
        [defLabel setFont :CourierD];
    }
    
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(10, 5, 30, 30)];
    [explainView addSubview:addButton];
    
    
    
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    [wordLabel setTextColor:[UIColor whiteColor]];
    wordLabel.text = myWord.key;
    wordLabel.backgroundColor = [UIColor clearColor];
    [explainView addSubview:wordLabel];
    [wordLabel release];
    
    
    
    defLabel.backgroundColor = [UIColor clearColor];
    [defLabel setTextColor:[UIColor whiteColor]];
    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
    [defLabel setNumberOfLines:1];
    defLabel.text = kPlaySix;
    //    NSLog(@"未联网无法查看释义!");
    [explainView addSubview:defLabel];
    [defLabel release];
    
    [explainView setHidden:NO]; 
}

/*检测声音输入设备(即有无麦克风)*/
- (BOOL)hasMicphone {  
    return [[AVAudioSession sharedInstance] inputIsAvailable];  
} 

/*检测是否有插耳机*/
- (BOOL)hasHeadset {  
#if TARGET_IPHONE_SIMULATOR  
//#warning *** Simulator mode: audio session code works only on a device  
    return NO;  
#else   
    CFStringRef route;  
    UInt32 propertySize = sizeof(CFStringRef);  
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route);  
    if((route == NULL) || (CFStringGetLength(route) == 0)){  
        // Silent Mode  
//        NSLog(@"AudioRoute: SILENT, do nothing!");  
    } else {  
        NSString* routeStr = (NSString*)route;  
//        NSLog(@"AudioRoute: %@", routeStr);  
        /* Known values of route:  
         * "Headset"  
         * "Headphone"  
         * "Speaker"  
         * "SpeakerAndMicrophone"  
         * "HeadphonesAndMicrophone"  
         * "HeadsetInOut"  
         * "ReceiverAndMicrophone"  
         * "Lineout"  
         */  
        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];  
        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];  
        if (headphoneRange.location != NSNotFound) {  
            return YES;  
        } else if(headsetRange.location != NSNotFound) {  
            return YES;  
        }  
    }  
    return NO;  
#endif  
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
- (void) initialize 
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:contentMode] forKey:@"contentMode"];
//    NSLog(@"%@",[[UIDevice currentDevice] model]);
    
    [btn_record setEnabled:YES];
    switch (playMode) {
        case 1:
            if (isiPhone) {
                [modeBtn setImage:[UIImage imageNamed:@"sin.png"] forState:UIControlStateNormal];
            } else {
                [modeBtn setImage:[UIImage imageNamed:@"sinP.png"] forState:UIControlStateNormal];
            }
            
//            [displayModeBtn setTitle:@"单曲循环" forState:UIControlStateNormal]; 
            break;
        case 2:
            if (isiPhone) {
                [modeBtn setImage:[UIImage imageNamed:@"seq.png"] forState:UIControlStateNormal];
            } else {
                [modeBtn setImage:[UIImage imageNamed:@"seqP.png"] forState:UIControlStateNormal];
            }
            
//            [displayModeBtn setTitle:@"顺序播放" forState:UIControlStateNormal];
            break;
        case 3:
            if (isiPhone) {
                [modeBtn setImage:[UIImage imageNamed:@"ran.png"] forState:UIControlStateNormal];
            } else {
                [modeBtn setImage:[UIImage imageNamed:@"ranP.png"] forState:UIControlStateNormal];
            }
            
//            [displayModeBtn setTitle:@"随机播放" forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
//    if ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]) {
//        [self.lvlMeter_in setFrame:CGRectMake(150.0f, 420.0f, 92.0f, 32.0f)];
//        [self.btn_record setFrame:CGRectMake(35.0f, 425.0f, 40.0f, 40.0f)];
//        [self.btn_play setFrame:CGRectMake(75.0f, 425.0f, 40.0f, 40.0f)];
//    }
    
    if (![self hasMicphone]) {
        [btn_record setEnabled:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"recordRead"];
        [btn_play setEnabled:NO];
    }
    [aButton setImage:nil forState:UIControlStateNormal];
    [bButton setImage:nil forState:UIControlStateNormal];
    [cButton setImage:nil forState:UIControlStateNormal];
//    NSInteger myColor = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueColor"];
//    UIColor *swColor = [UIColor redColor];
//    switch (myColor) {
//        case 1:
//            swColor = [UIColor colorWithRed:0.78f green:0.078f blue:0.11f alpha:1.0];
//            break;
//        case 2:
//            swColor = [UIColor colorWithRed:0.153f green:0.012f blue:0.518f alpha:1.0];
//            break;
//        case 3:
//            swColor = [UIColor colorWithRed:0.384f green:0.247f blue:0.157f alpha:1.0];                    
//            break;
//        case 4:
//            swColor = [UIColor colorWithRed:1.0f green:0.4f blue:0.192 alpha:1.0];
//            break;
//        case 5:
//            swColor = [UIColor colorWithRed:0.435f green:0.106f blue:0.361f alpha:1.0];
//            break;
//        case 6:
//            swColor = [UIColor colorWithRed:0.421f green:0.753f blue:0.173f alpha:1.0];
//            break;
//        default:
//            break;
//    }
//    [lyricLabel setTextColor:swColor];
    sen_num = 1;
    //        time_total = 0.f;
    needFlush = NO;
    noBuffering = YES;
    commNumber = 0;
    nowPage = 1;
    totalPage = 1;
    [self catchComments:1];
    [btn_play setHidden:YES];
    [btn_record setHidden:YES];
//    [lvlMeter_in setHidden:YES];
    //        commController.voaid = voa._voaid;
    //        [commController refresh];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:self.voa._voaid] forKey:@"lastPlay"];
    //        [[NSNotificationCenter defaultCenter]removeObserver:self name:ASStatusChangedNotification object:player];
    [playButton.layer removeAllAnimations];
//    myTimer = 0;
    [VOAView alterRead:voa._voaid];
    downloaded = NO;
//    if (player) {
        [player pause];
        [player release];
        player = nil;
//    }
    if (!notValid) {
        [lyricSynTimer invalidate];
        [sliderTimer invalidate];
        notValid = YES;
    }
    timeSlider.maximumValue = 1.0f;//#$$#
    timeSlider.value = 0.0f;
    [loadProgress setProgress:0.f];
    
    NSString *que = [VOAView getQueByVoaid:voa._voaid];
    [queLabel setText:que];
    [queLabel setBackgroundColor:[UIColor clearColor]];
    int engHight = [@"a" sizeWithFont:queLabel.font].height;
    int eLines = [que sizeWithFont:queLabel.font constrainedToSize:CGSizeMake(queLabel.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
    [queLabel setNumberOfLines:eLines];
    if (isiPhone) {
        [queLabel setFrame:CGRectMake(320*3+20,5, 280, eLines * engHight)];
        aButton.frame = CGRectMake(320*3+20, eLines * engHight + 5, 280, (myScroll.frame.size.height - eLines * engHight)/3);
        bButton.frame = CGRectMake(320*3+20, eLines * engHight + (myScroll.frame.size.height - eLines * engHight)/3, 280, (myScroll.frame.size.height - eLines * engHight)/3);
        cButton.frame = CGRectMake(320*3+20, eLines * engHight + 2*(myScroll.frame.size.height - eLines * engHight)/3, 280, (myScroll.frame.size.height - eLines * engHight)/3);
    }else {
        [queLabel setFrame:CGRectMake(768*3+100, 50, 568, eLines * engHight)];
    }
    
    self.navigationController.navigationBarHidden = YES;
    //初始化字体大小
    int fontSize = 15;
    if ([Constants isPad]) {
        fontSize = 20;
    }
    int mulValueFont = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueFont"];
    if (mulValueFont > 0) {
        fontSize = mulValueFont;
    }
    CourierOne = [UIFont systemFontOfSize:fontSize];//初始15
    CourierTwo = [UIFont systemFontOfSize:fontSize-2]; 
    [lyricLabel setFont:CourierOne];
    [lyricCnLabel setFont:CourierTwo];
    answerData = [VOAView getAnsByVoaid:voa._voaid];
    [aButton setTitle:[NSString stringWithFormat:@"A:%@", [answerData objectAtIndex:0]] forState:UIControlStateNormal];
    [bButton setTitle:[NSString stringWithFormat:@"B:%@", [answerData objectAtIndex:1]] forState:UIControlStateNormal];
    [cButton setTitle:[NSString stringWithFormat:@"C:%@", [answerData objectAtIndex:2]] forState:UIControlStateNormal];
    [answerData release];
    
    NSArray *words = [VOAView getWordByVoaid:voa._voaid];
    [listData removeAllObjects];
    for (NSString* fav in words) {
        [listData addObject:fav];
        //            NSLog(@"word:%@", fav);
    }
    [self.wordTableView reloadData];
    [words release], words = nil;
    
    CGPoint startOffet = CGPointMake(0, 0);
    //        UIFont *Courier = [UIFont fontWithName:@"Arial" size:24];
    //        [titleWords setFont:Courier];
    [titleWords setText:voa._title];
    [titleWords setContentOffset:startOffet];
    NSURL *url = [NSURL URLWithString: voa._pic];
    [myImageView setImageWithURL:url placeholderImage:[UIImage imageNamed:@"acquiesce.png"]];
    //        [imgWords setTextColor:[UIColor darkTextColor]];
    [imgWords setTextAlignment:UITextAlignmentLeft];
    [imgWords setContentOffset:startOffet];
    [imgWords setText:voa._descCn];
    //刚进入页面时让歌词显示在开头
    [textScroll setContentOffset:startOffet];
    [myScroll setContentOffset:startOffet];
    [timeSlider addTarget:self
                   action:@selector(sliderChanged:) 
         forControlEvents:UIControlEventValueChanged];
    [playButton addTarget:self 
                   action:@selector(playButtonPressed:) 
         forControlEvents:UIControlEventTouchUpInside];
    //        [playButton addTarget:self 
    //                       action:@selector(playButtonPressed:) 
    //             forControlEvents:UIEventSubtypeMotionShake];
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //创建audio份目录在Documents文件夹下，not to back up
    NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];;
    userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d.mp3", voa._voaid]];
    localFileExist = [[NSFileManager defaultManager] fileExistsAtPath:userPath];
//    mp3Url = [NSURL fileURLWithPath:userPath];
    player = nil;
    if (localFileExist) {
        [loadProgress setProgress:1.f];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            avSet = [AVAsset assetWithURL:[NSURL fileURLWithPath:userPath]];
            [avSet retain];
            player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithAsset:avSet]];
        } else {
            mp3Url = [NSURL fileURLWithPath:userPath];
            [mp3Url retain];
            player = [[AVPlayer alloc] initWithURL:mp3Url];
        }
        playerFlag = 0;
        //            [player release];
        //            player = nil;
        [downloadFlg setHidden:NO];
        [collectButton setHidden:YES];
        [downloadingFlg setHidden:YES];
        //            NSLog(@"cunzai");  
        //  获取mp3起止时间	
        [totalTimeLabel setHidden:NO];
        [currentTimeLabel setHidden:NO];
        CMTime playerDuration = [self playerItemDuration];
        double duration = CMTimeGetSeconds(playerDuration);
        
        CMTime playerProgress = [player currentTime];
        double progress = CMTimeGetSeconds(playerProgress);
        if (duration > 0.0f) {
            currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:progress];
            //            NSLog(@"%@", [timeSwitchClass timeToSwitchAdvance:localPlayer.currentTime]);
            totalTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
            timeSlider.maximumValue = duration;
            [self setButtonImage:loadingImage];
            [player play];
        }
        //            [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
    }else
    {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
            avSet = [AVAsset assetWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://static.iyuba.com/sounds/minutes/%@", voa._sound]]];
            [avSet retain];
            player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithAsset:avSet]];//
        } else {
            mp3Url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.iyuba.com/sounds/minutes/%@", voa._sound]];
            [mp3Url retain];
            player = [[AVPlayer alloc] initWithURL:mp3Url];
        }
        playerFlag = 1;
        //            NSLog(@"2");
        if ([VOAView isDownloading:voa._voaid]) {
            [downloadingFlg setHidden:NO];
            [downloadFlg setHidden:YES];
            [collectButton setHidden:YES];
        }else {
            [downloadingFlg setHidden:YES];
            [downloadFlg setHidden:YES];
            [collectButton setHidden:NO];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"autoDownload"]) {
                [self collectButtonPressed:collectButton];
            }
        }
        //            NSLog(@"3");
        [totalTimeLabel setHidden:YES];
        [currentTimeLabel setHidden:YES];
        
        //            NSLog(@"开始取时间");
        //            CMTime playerDuration = [self playerItemDuration];
        //            double duration = CMTimeGetSeconds(playerDuration);
        ////            double duration = CMTimeGetSeconds([[player currentItem] duration]);
        //            NSLog(@"duration1:%lf",duration);
        
        //            NSArray* loadedRanges = player.currentItem.loadedTimeRanges;  
        //            if (loadedRanges.count > 0)  
        //            {  
        //                CMTimeRange range = [[loadedRanges objectAtIndex:0] CMTimeRangeValue];  
        //                double duration = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);  
        //                NSLog(@"duration2:%g", duration);  
        //            }
        //
        //            CMTime playerProgress = [player currentTime];
        //            double progress = CMTimeGetSeconds(playerProgress);
        ////            NSLog(@"progress:%lf",progress);
        
        if (isExisitNet) {
            [player play];
            //                NSArray* loadedRanges = player.currentItem.seekableTimeRanges; 
            //                double duration;
            //                if (loadedRanges.count > 0)  
            //                {  
            //                    CMTimeRange range = [[loadedRanges objectAtIndex:0] CMTimeRangeValue];  
            //                    duration = CMTimeGetSeconds(range.start) + CMTimeGetSeconds(range.duration);  
            //                    NSLog(@"duration2:%g", duration);  
            //                }
            
            CMTime playerProgress = [player currentTime];
            double progress = CMTimeGetSeconds(playerProgress);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.3){
                //                    NSLog(@"Version>=4.3");
                CMTime playerDuration = [self playerItemDuration];
                double duration = CMTimeGetSeconds(playerDuration);
                if (duration > 0.0f) {//#$$#
                    totalTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
                    timeSlider.maximumValue = duration;
                    timeSlider.value = progress;
                }
                
            }else {
                
            }
            //            NSLog(@"progress:%lf",progress);
            
            [totalTimeLabel setHidden:NO];
            [currentTimeLabel setHidden:NO];
            currentTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:progress];
            //                totalTimeLabel.text = [timeSwitchClass timeToSwitchAdvance:duration];
            //                timeSlider.maximumValue = duration;
            //#$$#
            [self setButtonImage:loadingImage];
        }else
        {
            needFlush = YES;
        }
        downloaded = NO;
    }
    //缓冲进度显示
    
    //时间可调
    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                   target:self
                                                 selector:@selector(updateSlider)
                                                 userInfo:nil 
                                                  repeats:YES];
    [lyricArray removeAllObjects];
    [timeArray removeAllObjects];
    [indexArray removeAllObjects];
    [lyricCnArray removeAllObjects];
    [DataBaseClass querySQL:(NSMutableArray *)lyricArray 
            lyricCnResultIn:(NSMutableArray *)lyricCnArray 
               timeResultIn:(NSMutableArray *)timeArray 
              indexResultIn:(NSMutableArray *)indexArray
                voaResultIn:(VOAView *)voa];
    //        NSLog(@"lyricArraynumber:%i", [lyricArray count]);
    //        time_total += [[timeArray objectAtIndex:0] intValue];
    
    for (UIView *deleteView in [textScroll subviews]) {
        [deleteView removeFromSuperview];
    }
    
    //        NSLog(@"重复1");
    //        NSLog(@"lyricLabelArrayretainnumber:%i", [self.lyricLabelArray retainCount]);
    
    
    /*
     *  清空lyricLabelArray与lyricCnLabelArray两个数组
     */
    for (UIView *deleteView in lyricLabelArray) {
        [deleteView removeFromSuperview];
    }
    for (UIView *deleteView in lyricCnLabelArray) {
        [deleteView removeFromSuperview];
    }
    [lyricLabelArray removeAllObjects];
    [lyricCnLabelArray removeAllObjects];
    
    
    //
    //        NSLog(@"lyricLabelArrayretainnumber:%i", [self.lyricLabelArray retainCount]);
    /*
     *  释放lyricLabelArray与lyricCnLabelArray两个数组，重新创建。
     */
    //        [lyricLabelArray release], lyricLabelArray = nil;
    //        [lyricCnLabelArray release], lyricCnLabelArray = nil;
    //        lyricLabelArray = [[NSMutableArray alloc] init];
    //        lyricCnLabelArray = [[NSMutableArray alloc] init];
    
    //        NSLog(@"重复2");
    
    int setY = [LyricSynClass lyricView : (NSMutableArray *)lyricLabelArray 
                       lyricCnLabelArray: (NSMutableArray *)lyricCnLabelArray 
                                  index : (NSMutableArray *)indexArray 
                                  lyric : (NSMutableArray *)lyricArray
                                lyricCn : (NSMutableArray *)lyricCnArray   
                                 scroll : (TextScrollView *)textScroll 
                         myLabelDelegate: (id <MyLabelDelegate>) self
                               engLines : (int *)&engLines 
                                cnLines : (int *)&cnLines];
    //        NSLog(@"lyricLabelArrayretainnumber:%i", [self.lyricLabelArray retainCount]);
    CGSize newSize = CGSizeMake(textScroll.frame.size.width, setY); 
    [textScroll setContentSize:newSize]; 
    //        NSLog(@"lyricLabelArraynumber:%i", [lyricLabelArray count]);
    //        NSLog(@"lyricLabelArray:%@", lyricLabelArray);
    
    NSInteger engChn = [[NSUserDefaults standardUserDefaults] boolForKey:@"synContext"] ;
    //        NSLog(@"同步设置:%d",engChn);
    if (engChn) {
        //            NSLog(@"no ......");
        self.switchFlg = NO;
        //            [switchBtn setTitle:@"开" forState:UIControlStateNormal] ;
        for (UIView *hideView in textScroll.subviews) {
            if (hideView.tag < 200) {
                [hideView setHidden:NO]; 
                //                    NSLog(@"hide1");
            }
        }
    }else
    {
        //            NSLog(@"1");
        self.switchFlg = YES;
        //            [switchBtn setTitle:@"关" forState:UIControlStateNormal] ;
        for (UIView *hideView in textScroll.subviews) {
            if (hideView.tag < 200) {
                [hideView setHidden:YES]; 
                //                    NSLog(@"show1");
            }
        }
    }
    //        NSLog(@"2");
//    if (needFlushAdv && isExisitNet) {
//        needFlushAdv = NO;
//        [bannerView_ loadRequest:[GADRequest request]];
//    }
    
    //        NSLog(@"3");
    //  歌词同步的实现
#if 1
    lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 
                                                     target:self 
                                                   selector:@selector(lyricSyn) 
                                                   userInfo:nil 
                                                    repeats:YES];
#endif
    notValid = NO;
    //        NSLog(@"4");
    [HUD hide:YES]; 
    
    int page = pageControl.currentPage ;
    CGRect frame = myScroll.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [myScroll scrollRectToVisible:frame animated:YES];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];  
//    NSLog(@"字体大小：%d",[[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueFont"]);
//    NSLog(@"字体颜色：%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"mulValueColor"]);
//    NSLog(@"app");
//    //开启外部控制音频播放
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];  
//    [self becomeFirstResponder]; 

    [[UIApplication sharedApplication] setIdleTimerDisabled:[[NSUserDefaults standardUserDefaults] boolForKey:@"keepScreenLight"]];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"nightMode"]) {
        [self.view setBackgroundColor:[UIColor colorWithRed:0.196f green:0.31f blue:0.521f alpha:5.0]];
    } else {
        [self.view setBackgroundColor:[UIColor clearColor]];
    }
    nowUserId = 0;
    nowUserId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
    
    [timeSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderMin.png"] forState:UIControlStateNormal];
    [timeSlider setThumbImage:[UIImage imageNamed:@"dragPoint.png"] forState:UIControlStateNormal];

    if ([VOAFav isCollected:voa._voaid]) {
        [downloadFlg setHidden:NO];
        [collectButton setHidden:YES];
        [downloadingFlg setHidden:YES];
    } else if([VOAView isDownloading:voa._voaid]) {
        [downloadFlg setHidden:YES];
        [collectButton setHidden:YES];
        [downloadingFlg setHidden:NO];
    } else {
        [downloadFlg setHidden:YES];
        [collectButton setHidden:NO];
        [downloadingFlg setHidden:YES];
    }
    
    NSInteger myColor = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueColor"];
    UIColor *swColor = [UIColor redColor];
    switch (myColor) {
        case 1:
            swColor = [UIColor colorWithRed:0.78f green:0.078f blue:0.11f alpha:1.0];
            break;
        case 2:
            swColor = [UIColor colorWithRed:0.153f green:0.012f blue:0.518f alpha:1.0];
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
    [lyricLabel setTextColor:swColor];
    
    if (flushList) {
        if (contentMode == 1) {
            //            if (playMode == 2) {
            //                [listArray removeAllObjects];
            //                [VOAView getListBeforeVoaid:voa._voaid listArray:listArray];
            //            } else if (playMode == 3) {
//            [listArray removeAllObjects];
            [VOAView getList:listArray];
            
            //            }
        } else if (contentMode == 2) {
            //            if (playMode == 2) {
            //                [listArray removeAllObjects];
            //                [VOAFav getListBeforeVoaid:voa._voaid listArray:listArray];
            //            } else if (playMode == 3) {
//            [listArray removeAllObjects];
            [VOAFav getList:listArray];
            //            }
        }
        flushList = NO;
        
        //        int i = 0;
        //        for (NSString *str in listArray) {
        //            NSLog(@"%i:%@",i++,str);
        //        }
        //        NSLog(@"flushList playIndex=%i",playIndex);
    }
    playIndex = [self indexOfArray:listArray bbcId:voa._voaid];
//    NSLog(@"刷新列表后index = %i， count = %i",playIndex ,[listArray count]);
//    NSLog(@"list:%@", listArray);
    if (newFile == NO && (needFlush == NO || (needFlush == YES && isExisitNet == NO))) {
        if (notValid) {
            lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                             target:self
                                                           selector:@selector(lyricSyn)
                                                           userInfo:nil
                                                            repeats:YES];
            sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                           target:self
                                                         selector:@selector(updateSlider)
                                                         userInfo:nil
                                                          repeats:YES];
            notValid = NO;
        }
        self.navigationController.navigationBarHidden = YES;
    }else{
        [self initialize];
    }
    
//    if ([self hasMicphone]) {
//        NSLog(@"有麦克风");
//    }else {
//        NSLog(@"无麦克风");
//    }
//    
//    if ([self hasHeadset]) {
//        NSLog(@"插着耳机");
//    } else {
//        NSLog(@"没插耳机");
//    }
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated]; 
    newFile = NO;
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
//    //有关外部控制音频播放
//    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];  
    [self resignFirstResponder]; 
}

/*检测当前声音输出设备*/
/*void audioRouteChangeListenerCallback (
                                       void *inUserData,
                                       AudioSessionPropertyID inID,
                                       UInt32 inDataSize,
                                       const void *inData)
{
    UInt32 propertySize = sizeof(CFStringRef);
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    CFStringRef state = nil;
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute
                            ,&propertySize,&state);
    NSLog(@"%@",(NSString *)state);//return @"Headphone" or @"Speaker" and so on.
}*/

- (void)viewDidLoad
{
    notValid = YES;
    isExisitNet = YES;
    readRecord = NO;
    isFixing = NO;
    flushList = YES;
    isShareSen = NO;
    [[fixButton layer] setCornerRadius:8.0f];
    [[fixButton layer] setMasksToBounds:YES];
    [btn_play setEnabled:NO];
    
    playMode = [[NSUserDefaults standardUserDefaults] integerForKey:@"playMode"];
    if (playMode == 0) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"playMode"];
        playMode = 1;
    }
    m_isRecording = NO;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone || UIUserInterfaceIdiomPad)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        NSError *error;
        if ([audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
        {
            if ([audioSession setActive:YES error:&error])
            {
                //        AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
            }
            else
            {
                NSLog(@"Failed to set audio session category: %@", error);
            }
        }
        else
        {
            NSLog(@"Failed to set audio session category: %@", error);
        }
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,sizeof(audioRouteOverride),&audioRouteOverride);
    }
    audioRecoder = [[CL_AudioRecorder alloc] initWithFinishRecordingBlock:^(CL_AudioRecorder *recorder, BOOL success) {
        //NSLog(@"%@,%@",success?@"YES":@"NO",recorder.recorderingPath);
    } encodeErrorRecordingBlock:^(CL_AudioRecorder *recorder, NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    } receivedRecordingBlock:^(CL_AudioRecorder *recorder, float peakPower, float averagePower, float currentTime) {
        NSLog(@"%f,%f,%f",peakPower,averagePower,currentTime);
    }];
    
    //此种模式下无法播放的同时录音
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //该代码是设置手机喇叭与麦克风同时工作 iphone 3.0以上版本 播放类型
//    UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
    
//    //设置采样率的
//    Float64 smpl=kAudioSessionProperty_CurrentHardwareSampleRate;
//    AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, sizeof(smpl), &smpl);
//    //设置声音输出扬声器 还是默认的接收器kAudioSessionOverrideAudioRoute_None
//    UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker; 
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRoute);
    
    //开启外部控制音频播放
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];  
    [self becomeFirstResponder]; 
    
    /*监听插拔耳机*/
    /*OSStatus status = AudioSessionAddPropertyListener(
                                                      kAudioSessionProperty_AudioRouteChange,
                                                      audioRouteChangeListenerCallback,self);
    if(status == 0){//ok;
    }*/
    
//    //进入后台前的提醒
//    [[NSNotificationCenter defaultCenter]        
//     addObserver:self        
//     selector:@selector(applicationWillResignActive:)        
//     name:UIApplicationWillResignActiveNotification
//     object:nil];
    
//    // Create the URL for the source audio file. The URLForResource:withExtension: method is
//    //    new in iOS 4.0.
//    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"begin_record"
//                                                withExtension: @"caf"];
////    NSURL *tapSound   = [[NSBundle mainBundle] URLForResource: @"tap"
////                                                withExtension: @"aif"];
//    
//    // Store the URL as a CFURLRef instance
//    soundFileURLRef = (CFURLRef) [tapSound retain];
//    
//    // Create a system sound object representing the sound file.
//    AudioServicesCreateSystemSoundID (
//                                      
//                                      soundFileURLRef,
//                                      &soundFileObject
//                                      );
    
    localFileExist = NO;
    switchFlg = YES;
//    [shareButton setBackgroundImage:[UIImage imageNamed:@"sinaLogo.png"] forState:UIControlStateNormal];
    
    isiPhone = ![Constants isPad];
    if (isiPhone) {
//        loadProgress = [[SevenProgressBar alloc] initWithFrame:CGRectMake(55, 358, 210, 12) andbackImg:[UIImage imageNamed:@"slider.png"] frontimg:[UIImage imageNamed:@"sliderMin.png"]];
        loadProgress = [[SevenProgressBar alloc] initWithFrame:CGRectMake(42, 443, 190, 12) andbackImg:[UIImage imageNamed:@"sliderBBC.png"] frontimg:[UIImage imageNamed:@"sliderMin.png"]];
        
    }else {
        loadProgress = [[SevenProgressBar alloc] initWithFrame:CGRectMake(102, 976, 490, 12) andbackImg:[UIImage imageNamed:@"sliderBBC.png"] frontimg:[UIImage imageNamed:@"sliderMin.png"]];
    }
    [timeSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderMin.png"] forState:UIControlStateNormal];
    [timeSlider setMaximumTrackImage:[UIImage imageNamed:@"sliderLu.png"] forState:UIControlStateNormal];
    [timeSlider setThumbImage:[UIImage imageNamed:@"dragPoint.png"] forState:UIControlStateNormal];
    
    [self.view insertSubview:loadProgress belowSubview:timeSlider];
    [loadProgress release];
//    [timeSlider setFrame:CGRectMake(55, 360, 204, 9)];
    
    pageControl.backgroundColor = [UIColor clearColor];
	[pageControl setImagePageStateNormal:[UIImage imageNamed:@"GreenPoint.png"]];
	[pageControl setImagePageStateHightlighted:[UIImage imageNamed:@"WhitePoint.png"]];
    
//    [loadProgress setTrackImage:[UIImage imageNamed:@"slider.png"]];
//    [loadProgress setProgressImage:[UIImage imageNamed:@"sliderMin.png"]];

//    [timeSlider setMinimumTrackImage:[UIImage imageNamed:@"sliderMin.png"] forState:UIControlStateNormal];
    
    
    [[timeSlider layer] setCornerRadius:5.0f];
    [[timeSlider layer] setMasksToBounds:YES];
    [[loadProgress layer] setCornerRadius:5.0f];
    [[timeSlider layer] setMasksToBounds:YES];
    
//    /*有关设置定时器的组件*/
//    fixTimeView = [[UIView alloc]initWithFrame:self.view.frame];
//    myPick = [UIPickerView alloc] initWithFrame:CGRectMake(0, fixTimeView.frame.size.height/2-108, <#CGFloat width#>, <#CGFloat height#>);
    
//    UIFont *CourierOne = [UIFont systemFontOfSize:15];
//    UIFont *CourierTwo = [UIFont systemFontOfSize:20];
//    UIFont *tFont = [UIFont fontWithName:[[UIFont fontNamesForFamilyName:@"AppleGothic"] objectAtIndex:0] size:20];
    
    int fontSize = 15;
    if ([Constants isPad]) {
        fontSize = 20;
    }
    int mulValueFont = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueFont"];
    if (mulValueFont > 0) {
        fontSize = mulValueFont;
    }
    CourierOne = [UIFont systemFontOfSize:fontSize];//初始15
    CourierTwo = [UIFont systemFontOfSize:fontSize-2]; 
    
//    double engHight = 0.f;
//    double cnHight = 0.f;
//    engHight = [@"a" sizeWithFont:CourierOne].height;
//    cnHight = [@"赵" sizeWithFont:CourierTwo].height;
//    lyEn = [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:sen_num-1]];
//    lyCn = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:sen_num-1]];
//    UIView *answerView;
//    MyLabel *queLabel = [[MyLabel alloc] init];
    queLabel = [[MyLabel alloc] init];
    [queLabel setDelegate:self];
    [queLabel setTextColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
    
    aButton = [UIButton buttonWithType:UIButtonTypeCustom];
    bButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cButton = [UIButton buttonWithType:UIButtonTypeCustom];
    if (isiPhone) {
        textScroll = [[TextScrollView alloc]initWithFrame:CGRectMake(354, 10, 253, 350)];
        [textScroll setTag:1];
        [textScroll setDelegate:self];

        myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 50, 270, 90)];//图片尺寸
        imgWords = [[UITextView alloc] initWithFrame:CGRectMake(30, 150, 260, 150)];//描述文字
        collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectButton setImage:[UIImage imageNamed:@"PcollectPressedBBC.png"] forState:UIControlStateNormal];
        [collectButton setFrame:CGRectMake(25, 105, 35, 35)];
        [collectButton addTarget:self action:@selector(collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        shareSenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareSenBtn setImage:[UIImage imageNamed:@"shareSen.png"] forState:UIControlStateNormal];
        [shareSenBtn setFrame:CGRectMake(610, 150, 65, 50)];
        [shareSenBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
        [shareSenBtn setEnabled:NO];
        [shareSenBtn setShowsTouchWhenHighlighted:YES];
        
        downloadFlg = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadFlg setImage:[UIImage imageNamed:@"downloadedBBC.png"] forState:UIControlStateNormal];
        [downloadFlg setFrame:CGRectMake(25, 105, 35, 35)];
//        downloadingFlg  = [[UIButton alloc]init];
        downloadingFlg = [UIButton buttonWithType:UIButtonTypeCustom];
         [downloadingFlg setImage:[UIImage imageNamed:@"downloadingBBC.png"] forState:UIControlStateNormal];
//        [downloadingFlg.titleLabel setTextColor:[UIColor whiteColor]];
        [downloadingFlg setFrame:CGRectMake(25, 105, 35, 35)];
        
        clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clockButton setImage:[UIImage imageNamed:@"clockBBC.png"] forState:UIControlStateNormal];
        [clockButton setFrame:CGRectMake(255, 100, 40, 40)];
        [clockButton addTarget:self action:@selector(showFix:) forControlEvents:UIControlEventTouchUpInside];
        [clockButton setBackgroundColor:[UIColor clearColor]];
//        [[clockButton layer] setCornerRadius:20.0f];
//        [[clockButton layer] setMasksToBounds:YES];
        //        [downloadingFlg.titleLabel setTextColor:[UIColor whiteColor]];
        
        
        [imgWords setFont:[UIFont systemFontOfSize:15]];
        
        [myScroll setContentSize:CGSizeMake(1920, 350)];
//        [myScroll setContentSize:CGSizeMake(960+320, 288)];
        
//        int eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
//        int cLines = (288-eLines * engHight-70) / engHight;
        lyricLabel = [[MyLabel alloc] initWithFrame:
                      CGRectMake(670, 20, 260, 154)];
        lyricCnLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(670, 174, 260, 154)];
//        lyricLabel.text = lyEn;
//        lyricLabel.text = @"2012-07-17 17:08:57.955 VOA[8614:11603] appVersion:2.100000";
        //    lyricLabel.tag = 200 + i;
        [lyricLabel setFont:CourierOne];
        [lyricLabel setDelegate:self];
        
        lyricLabel.backgroundColor = [UIColor clearColor];
        [lyricLabel setLineBreakMode:UILineBreakModeWordWrap];
        [lyricLabel setNumberOfLines:0];
        
//        lyricCnLabel.text = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:sen_num-1]];
//        lyricCnLabel.text = lyCn;
//        lyricCnLabel.text = @"2012-07-17 17:08:57.994 VOA[8614:11603] deviceToken:(null)";
//        lyricCnLabel.tag = 199;
//        [lyricCnLabel setDelegate:self];
        [lyricCnLabel setFont:CourierTwo];
        [lyricCnLabel setTextColor:[UIColor grayColor]];
        lyricCnLabel.backgroundColor = [UIColor clearColor];
        [lyricCnLabel setLineBreakMode:UILineBreakModeWordWrap];
        [lyricCnLabel setNumberOfLines:0];
        
        wordTableView = [[UITableView alloc]initWithFrame:CGRectMake(320*4,0 , 320, 350) style:UITableViewStylePlain];
        [wordTableView setDelegate:self];
        [wordTableView setDataSource:self];
        [wordTableView setTag:1];
        [wordTableView setBackgroundColor:[UIColor clearColor]];
        [myScroll addSubview:wordTableView];
        //    [wordTableView release];
        
//        answerView = [[UIView alloc]initWithFrame:CGRectMake(320*3, 0, 320, 268)];
        
        [queLabel setFrame:CGRectMake(320*3+20, 20, 280, 100)];
        [queLabel setFont:[UIFont boldSystemFontOfSize:16]];
        
        
        aButton.frame = CGRectMake(320*3+20, 100, 280, 56);
        bButton.frame = CGRectMake(320*3+20, 140, 280, 56);
        cButton.frame = CGRectMake(320*3+20, 180, 280, 56);
        [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [bButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [cButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
        
        myView = [[UIView alloc] initWithFrame:CGRectMake(320*5, 0, 320, 350)];
        commTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 310) style:UITableViewStylePlain];
        [commTableView setTag:2];
//        inputText = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    }else {
        textScroll = [[TextScrollView alloc]initWithFrame:CGRectMake(808, 10, 688, 795)];
        [textScroll setTag:1];
        [textScroll setDelegate:self];
//        myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(114, 25, 540, 360)];
//        imgWords = [[UITextView alloc] initWithFrame:CGRectMake(140, 440, 488, 225)];
        myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 668, 240)];
        imgWords = [[UITextView alloc] initWithFrame:CGRectMake(140, 400, 488, 275)];
        [imgWords setFont:[UIFont systemFontOfSize:18]];
        [myScroll setContentSize:CGSizeMake(4608, 795)];
//        [myScroll setContentSize:CGSizeMake(2304+768, 665)];
        collectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [collectButton setImage:[UIImage imageNamed:@"PcollectPressedBBCP.png"] forState:UIControlStateNormal];
        [collectButton setFrame:CGRectMake(50, 271, 69, 69)];
        [collectButton addTarget:self action:@selector(collectButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        shareSenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareSenBtn setImage:[UIImage imageNamed:@"shareSenP.png"] forState:UIControlStateNormal];
        [shareSenBtn setFrame:CGRectMake(1481, 300, 130, 100)];
        [shareSenBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
        [shareSenBtn setEnabled:NO];
        [shareSenBtn setShowsTouchWhenHighlighted:YES];
        
        downloadFlg = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadFlg setImage:[UIImage imageNamed:@"downloadedBBCP.png"] forState:UIControlStateNormal];
        [downloadFlg setFrame:CGRectMake(50, 271, 69, 69)];
        //        downloadingFlg  = [[UIButton alloc]init];
        downloadingFlg = [UIButton buttonWithType:UIButtonTypeCustom];
        [downloadingFlg setImage:[UIImage imageNamed:@"downloadingBBCP.png"] forState:UIControlStateNormal];
        //        [downloadingFlg.titleLabel setTextColor:[UIColor whiteColor]];
        [downloadingFlg setFrame:CGRectMake(50, 271, 69, 69)];
        
        clockButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [clockButton setImage:[UIImage imageNamed:@"clockBBCP.png"] forState:UIControlStateNormal];
        [clockButton setFrame:CGRectMake(649, 271, 69, 69)];
        [clockButton addTarget:self action:@selector(showFix:) forControlEvents:UIControlEventTouchUpInside];
        [clockButton setBackgroundColor:[UIColor clearColor]];
        
        lyricLabel = [[MyLabel alloc] initWithFrame:
                      CGRectMake(1636, 50, 568, 340)];
        lyricCnLabel = [[UILabel alloc] initWithFrame:
                        CGRectMake(1636, 390, 568, 340)];

        [lyricLabel setFont:CourierOne];
        [lyricLabel setDelegate:self];
        [lyricLabel setTextColor:[UIColor purpleColor]];
        lyricLabel.backgroundColor = [UIColor clearColor];
        [lyricLabel setLineBreakMode:UILineBreakModeWordWrap];
        [lyricLabel setNumberOfLines:0];
        
        [lyricCnLabel setFont:CourierTwo];
        [lyricCnLabel setTextColor:[UIColor grayColor]];
        lyricCnLabel.backgroundColor = [UIColor clearColor];
        [lyricCnLabel setLineBreakMode:UILineBreakModeWordWrap];
        [lyricCnLabel setNumberOfLines:0];
        
        wordTableView = [[UITableView alloc]initWithFrame:CGRectMake(768*4,0 , 768, 795) style:UITableViewStylePlain];
        [wordTableView setDelegate:self];
        [wordTableView setDataSource:self];
        [wordTableView setTag:1];
        [wordTableView setBackgroundColor:[UIColor clearColor]];
        [myScroll addSubview:wordTableView];
        //    [wordTableView release];
        
//        answerView = [[UIView alloc]initWithFrame:CGRectMake(768*3, 0, 768, 665)];
        
        [queLabel setFrame:CGRectMake(768*3+100, 50, 568, 165)];
        [queLabel setFont:[UIFont systemFontOfSize:20]];
        
        aButton.frame = CGRectMake(768*3+100, 215, 568, 100);
        bButton.frame = CGRectMake(768*3+100, 365, 568, 100);
        cButton.frame = CGRectMake(768*3+100, 515, 568, 100);
        [aButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [bButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [cButton.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        
        myView = [[UIView alloc] initWithFrame:CGRectMake(768*5, 0, 768, 795)];
        commTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 768, 755) style:UITableViewStylePlain];
        [commTableView setTag:2];
//        inputText = [[UITextField alloc] initWithFrame:CGRectMake(0, 600, 768, 65)];
    }
    
//    commController.voaid = voa._voaid;
//    [myScroll addSubview:commController.view];
    
//    [inputText setDelegate:self];
//    [inputText setBackgroundColor:[UIColor whiteColor]];
    
    [imgWords setTextColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0]];
    [imgWords setTextAlignment:UITextAlignmentLeft];
    
    [commTableView setBackgroundColor:[UIColor clearColor]];
    [commTableView setDelegate:self];
    [commTableView setDataSource:self];
//    [inputText setPlaceholder:@"写下您的评论。\"轻松学外语,快乐交朋友\""];
    [myView addSubview:commTableView];
    [commTableView release];
//    [myView addSubview:inputText];
    [myScroll addSubview:myView];
    [myView release];
    commArray = [[NSMutableArray alloc]init];
    isNewComm = NO;
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UIToolbar * keyBoradTopView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [keyBoradTopView setBarStyle:UIBarStyleBlackTranslucent];
//    [keyBoradTopView setBarStyle:UIBarStyleDefault];
//    UIBarButtonItem * cancelSendButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleDone target:self action:@selector(doCancle)];
//    UIBarButtonItem * spaceButtonOne = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      
//                                     UIBarButtonSystemItemFlexibleSpace target:self action:nil];
//    //    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"Send" style:UIBarButtonItemStylePlain target:self action:@selector(doSend)];
    
    keyCommFd = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 250, 20)];
    [keyCommFd setPlaceholder:@"写评论"];
    [keyCommFd setDelegate:self];
    [keyCommFd setBackgroundColor:[UIColor whiteColor]];
    UIBarButtonItem * textButton = [[UIBarButtonItem alloc] initWithCustomView:keyCommFd];
    [keyCommFd release];
    
    UIBarButtonItem * spaceButtonTwo = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:      
                                        UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem * sendButton = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:
                                    UIBarButtonItemStyleDone target:self action:@selector(doSend)];
    NSArray *keyBoradTopArray = [NSArray arrayWithObjects:textButton,spaceButtonTwo,sendButton,nil];
//    [cancelSendButton release];
//    [spaceButtonOne release];
    [textButton release];
    [spaceButtonTwo release];
    [sendButton release];
    [keyBoradTopView setItems:keyBoradTopArray];
    [inputText setInputAccessoryView:keyBoradTopView];
    [keyBoradTopView release];
    
    comTool = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 242, 320, 40)];
    [comTool setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem * textButtonTwo = [[UIBarButtonItem alloc] initWithCustomView:inputText];
    [inputText release];
    NSArray *comToolArray = [NSArray arrayWithObjects:textButtonTwo,nil];
//    [spaceButtonOne release];
    [textButtonTwo release];
//    [spaceButtonTwo release];
    [comTool setItems:comToolArray];
    [myView addSubview:comTool];
    [comTool release];
    
    */
    
    [aButton setTitleColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0f] forState:UIControlStateNormal];
    [aButton addTarget:self action:@selector(touchAnswerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [aButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [aButton.titleLabel setNumberOfLines:0];
    [bButton setTitleColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0f] forState:UIControlStateNormal];
    [bButton addTarget:self action:@selector(touchAnswerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [bButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [bButton.titleLabel setNumberOfLines:0];
    [cButton setTitleColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0f] forState:UIControlStateNormal];
    [cButton addTarget:self action:@selector(touchAnswerBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [cButton.titleLabel setNumberOfLines:0];
    
//    [answerData release];
//    [abutton setTitle:@"A" forState:UIControlStateNormal];
//    [abutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [abutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    
//    [bbutton setTitle:@"B" forState:UIControlStateNormal];
//    [bbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [bbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    
//    [cbutton setTitle:@"C" forState:UIControlStateNormal];
//    [cbutton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
//    [cbutton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    
//    [answerView addSubview:queLabel];
//    [queLabel release];
//    [answerView addSubview:aButton];
//    [answerView addSubview:bButton];
//    [answerView addSubview:cButton];
//    [myScroll addSubview:answerView];
//    [answerView release];
    
    [myScroll addSubview:queLabel];
//    [queLabel release];
    [myScroll addSubview:aButton];
    [myScroll addSubview:bButton];
    [myScroll addSubview:cButton];
    
    [myScroll addSubview:lyricLabel];
    [lyricLabel release];
    [myScroll addSubview:lyricCnLabel];
    [lyricCnLabel release];
    
    [imgWords setBackgroundColor:[UIColor clearColor]];
    [imgWords setEditable:NO];
    textScroll.showsVerticalScrollIndicator = NO;
    [textScroll setBackgroundColor:[UIColor clearColor]];
    
//    senImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wordFrame.png"]];
//    [senImage setFrame:CGRectMake(0, 0, 0, 0)];
//    [textScroll addSubview:senImage];
    
    [myScroll addSubview:myImageView];
    [myImageView release];
    [myScroll addSubview:imgWords];
    [imgWords release];
    [myScroll addSubview:shareSenBtn];
    [myScroll addSubview:collectButton];
    [myScroll addSubview:downloadFlg];
    [myScroll addSubview:downloadingFlg];
    [myScroll addSubview:clockButton];
    
    [imgWords setTextAlignment:UITextAlignmentCenter];
    [myScroll addSubview:textScroll];
    [textScroll release];
    
    if (isiPhone) {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(5*320, self.myScroll.frame.size.height - 40, 320, 40)];
        
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 240, 40)];
    } else {
        containerView = [[UIView alloc] initWithFrame:CGRectMake(5*768, self.myScroll.frame.size.height - 40, 768, 40)];
        
        textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(6, 3, 650, 40)];
    }
    
    textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    
	textView.minNumberOfLines = 1;
	textView.maxNumberOfLines = 6;
    [textView setText:@"写评论"];
	textView.returnKeyType = UIReturnKeyNext; //just as an example
	textView.font = [UIFont systemFontOfSize:15.0f];
	textView.delegate = self;
    textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    textView.backgroundColor = [UIColor whiteColor];
    
    // textView.text = @"test\n\ntest";
	// textView.animateHeightChange = NO; //turns off animation
    
    [self.myScroll addSubview:containerView];
	
    UIImage *rawEntryBackground = [UIImage imageNamed:@"MessageEntryInputField.png"];
    UIImage *entryBackground = [rawEntryBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
    if (isiPhone) {
        entryImageView.frame = CGRectMake(5, 0, 248, 40);
    } else {
        entryImageView.frame = CGRectMake(5, 0, 658, 40);
    }
    
    entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UIImage *rawBackground = [UIImage imageNamed:@"MessageEntryBackground.png"];
    UIImage *background = [rawBackground stretchableImageWithLeftCapWidth:13 topCapHeight:22];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
    imageView.frame = CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    // view hierachy
    [containerView addSubview:imageView];
    [containerView addSubview:textView];
    [containerView addSubview:entryImageView];
    
    UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
    
	UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	doneBtn.frame = CGRectMake(containerView.frame.size.width - 69, 8, 63, 27);
    doneBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
	[doneBtn setTitle:@"发表" forState:UIControlStateNormal];
    
    [doneBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
    doneBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[doneBtn addTarget:self action:@selector(doSend) forControlEvents:UIControlEventTouchUpInside];
    [doneBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
    [doneBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
	[containerView addSubview:doneBtn];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    
    if (isiPhone) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PplayPressedBBC" ofType:@"png"];
        playImage = [[UIImage alloc] initWithContentsOfFile:path];
        path = [[NSBundle mainBundle] pathForResource:@"PpausePressedBBC" ofType:@"png"];
        pauseImage = [[UIImage alloc] initWithContentsOfFile:path];
        path = [[NSBundle mainBundle] pathForResource:@"PloadingBBC" ofType:@"png"];
        loadingImage = [[UIImage alloc] initWithContentsOfFile:path];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"PplayPressedBBCP" ofType:@"png"];
        playImage = [[UIImage alloc] initWithContentsOfFile:path];
        path = [[NSBundle mainBundle] pathForResource:@"PpausePressedBBCP" ofType:@"png"];
        pauseImage = [[UIImage alloc] initWithContentsOfFile:path];
        path = [[NSBundle mainBundle] pathForResource:@"PloadingBBCP" ofType:@"png"];
        loadingImage = [[UIImage alloc] initWithContentsOfFile:path];
    }
    lyCn = [[NSString alloc]init];
    lyEn = [[NSString alloc]init];
    myWord = [[VOAWord alloc]init];
    userPath = [[NSString alloc] init];
    mp3Data = [[NSMutableData alloc] initWithLength:0];
    lyricArray = [[NSMutableArray alloc] init];
    lyricCnArray = [[NSMutableArray alloc] init];
	timeArray = [[NSMutableArray alloc] init];
	indexArray = [[NSMutableArray alloc] init];
    explainView = [[MyLabel alloc]init];
    lyricLabelArray = [[NSMutableArray alloc] init];
    lyricCnLabelArray = [[NSMutableArray alloc] init];
    listData = [[NSMutableArray alloc] init];
    listArray = [[NSMutableArray alloc] init];
    
    NSArray *myHrsArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23", nil];
    self.hoursArray = myHrsArray;
    [myHrsArray release];
    
    NSArray *myMesArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    self.minsArray = myMesArray;
    [myMesArray release];
    
    NSArray *mySesArray = [[NSArray alloc] initWithObjects:@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",nil];
    self.secsArray = mySesArray;
    [mySesArray release];
    
//    NSLog(@"lyricLabelArrayretainnumber:%i", [lyricLabelArray retainCount]);
    explainView.tag = 2000;
    explainView.delegate = self;
    if (isiPhone) {
        [explainView setFrame:CGRectMake(20, 250, 280, 100)];
    }else {
        [explainView setFrame:CGRectMake(184, 600, 400, 200)];
    }
    explainView.layer.cornerRadius = 10.0;
    [explainView setBackgroundColor:[UIColor colorWithRed:0.29f green:0.459f blue:0.271f alpha:1]];
    [explainView setAlpha:0.8f];

    [explainView setHidden:YES];
    [self.view addSubview:explainView];
    [explainView release];
    //    wordFrame = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, explainView.frame.size.width, explainView.frame.size.height)];
    //    [wordFrame setImage:[UIImage imageNamed:@"PwordFrame.png"]];
    //    [explainView addSubview:wordFrame];
    //    [wordFrame release];
    
    myHighLightWord = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [myHighLightWord setHidden:YES];
    [myHighLightWord setTag:1000];
    [myHighLightWord setBackgroundColor:[UIColor colorWithRed:0.427f green:0.753f blue:0.173 alpha:1.0]];
    [myHighLightWord setAlpha:0.5];
    [self.view addSubview:myHighLightWord];
    [myHighLightWord release];
    
//    starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star.png"]];
//    [starImage setTag:1111];
//    [self.view addSubview:starImage];
//    [starImage release];
    // Create a view of the standard size at the bottom of the screen.
    
//    if (isiPhone) {
//        bannerView_ = [[GADBannerView alloc]
//                       initWithFrame:CGRectMake(0.0,
//                                                self.view.frame.size.height -
//                                                GAD_SIZE_320x50.height,
//                                                GAD_SIZE_320x50.width,
//                                                GAD_SIZE_320x50.height)];
//    }else{
//        bannerView_ = [[GADBannerView alloc]
//                       initWithFrame:CGRectMake(20.0,
//                                                self.view.frame.size.height -
//                                                GAD_SIZE_728x90.height,
//                                                GAD_SIZE_728x90.width,
//                                                GAD_SIZE_728x90.height)];
//    }
//    
//    
//    // Specify the ad's "unit identifier." This is your AdMob Publisher ID.
//    bannerView_.adUnitID = @"a14f752011a39fd";
//    
//    // Let the runtime know which UIViewController to restore after taking
//    // the user wherever the ad goes and add it to the view hierarchy.
//    bannerView_.rootViewController = self;
//    [self.view addSubview:bannerView_];
//    [bannerView_ release];
//    
//    // Initiate a generic request to load it with an ad.
//    [bannerView_ loadRequest:[GADRequest request]];
////    [bannerView_ setBackgroundColor:[UIColor blueColor]];
//    if (!isExisitNet) {
//        needFlushAdv = YES;
//    }
//    [bannerView_ setHidden:NO];
//    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];//开启接受外部控制音频播放

    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
//    NSLog(@"bbbb");
    //有关外部控制音频播放
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];  
    [self resignFirstResponder]; 
//    self.controller = nil;
//    self.collectButton = nil;
    self.preButton = nil;
    self.nextButton = nil;
	self.myScroll = nil;
	self.pageControl = nil;
    self.totalTimeLabel = nil;
    self.currentTimeLabel = nil;
    self.timeSlider = nil;
    self.playButton = nil;
//    self.downloadFlg = nil;
//    self.downloadingFlg = nil;
    self.titleWords = nil;
    self.RoundBack = nil;
    self.btnOne = nil;
    self.btnTwo = nil;
    self.btnThree = nil;
    self.btnFour = nil;
    self.btnFive = nil;
    self.btnSix = nil;
    self.fixButton = nil;
    self.fixTimeView = nil;
    self.myPick = nil;
    self.clockButton = nil;
    self.modeBtn = nil;
}

/**
 * 外部控制音频播放所需重置
 */
- (BOOL)canBecomeFirstResponder  
{  
    return YES;  
} 

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
//    NSLog(@"aaaa");
//    [self.controller release], controller = nil;
//    [self.collectButton release], collectButton = nil;
    [self.preButton release], preButton = nil;
    [self.nextButton release], nextButton = nil;
	[self.myScroll release], myScroll = nil;
	[self.pageControl release], pageControl = nil;
    [self.totalTimeLabel release], totalTimeLabel = nil;
    [self.currentTimeLabel release], currentTimeLabel = nil;
    [self.timeSlider release], timeSlider = nil;
    [self.playButton release], playButton = nil;
//    [self.downloadFlg release], downloadFlg = nil;
//    [self.downloadingFlg release], downloadingFlg = nil;
    [self.titleWords release], titleWords = nil;
    [self.RoundBack release], RoundBack = nil;
    [self.fixButton release], fixButton = nil;
    [self.fixTimeView release], fixTimeView = nil;
    [self.myPick release], myPick = nil;
    [self.clockButton release], clockButton = nil;
    [self.modeBtn release], modeBtn = nil;
    
    [self.sliderTimer invalidate], sliderTimer = nil;
    [self.lyricSynTimer invalidate], lyricSynTimer = nil;
    [self.fixTimer invalidate], fixTimer = nil;
    [self.answerData release], answerData = nil;
//    [self.bannerView_ release], bannerView_ = nil;
    [self.btnFive release], btnFive = nil;
    [self.btnFour release], btnFour = nil;
    [self.btnOne release], btnOne = nil;
    [self.btnSix release], btnSix = nil; 
    [self.btnThree release], btnThree = nil;
    [self.btnTwo release], btnTwo = nil;
//    [self.collectButton release], collectButton = nil;
    [self.commArray release], commArray = nil;
    [self.commTableView  release], commTableView = nil;
//    [self.downloadFlg release], downloadFlg = nil;
//    [self.downloadingFlg release], downloadingFlg = nil;
    [self.explainView release], explainView = nil;
    [self.hoursArray release], hoursArray = nil;
    [self.indexArray release], indexArray = nil;
    [self.imgWords release], imgWords = nil;
//    [self.inputText release], inputText = nil;
    [self.listArray release], listArray = nil;
    [self.listData release], listData = nil;
    [self.loadingImage release], loadingImage = nil;
    [self.loadProgress release], loadProgress = nil;
    [self.lyEn release], lyEn = nil;
    [self.lyCn release], lyCn = nil;
    [self.lyricArray release], lyricArray = nil;
    [self.lyricCnArray release], lyricCnArray = nil;
    [self.lyricCnLabel release], lyricCnLabel = nil;
    [self.lyricCnLabelArray release], lyricCnLabelArray = nil;
    [self.lyricLabel release], lyricLabel = nil;
    [self.lyricLabelArray release], lyricLabelArray = nil;
    [self.minsArray release], minsArray = nil;
    [self.mp3Data release], mp3Data = nil;
    [self.myHighLightWord release], myHighLightWord = nil;
    [self.myImageView release], myImageView = nil;
    [self.myWord release], myWord = nil;
    [self.myView release], myView = nil;
    [self.pauseImage release], pauseImage = nil;
    [self.player release], player = nil;
    [self.playImage release], playImage = nil;
    [self.queLabel release], queLabel = nil;
    [self.secsArray release], secsArray = nil;
    [self.textScroll release], textScroll = nil;
    [self.timeArray release], timeArray = nil;
    [self.userPath release], userPath = nil;
//    [self.wordFrame release], wordFrame = nil;
    [self.wordPlayer release], wordPlayer = nil;
    [self.wordTableView release], wordTableView = nil;
    [super dealloc];
}



#pragma mark - Http connect
- (void)catchDetails:(VOAView *) voaid
{
    //    NSLog(@"获取内容-%d",voaid._voaid);
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/minutes/textApi.jsp?bbcid=%d&format=xml",voaid._voaid];
    //    NSLog(@"catch:%d",voaid._voaid);
    //    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"detail"];
    [request setTag:voaid._voaid];
    [request startSynchronous];
    //    [request release];
}
- (void)catchBBCWords:(NSInteger) voaid
{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/minutes/bbcwordsApi.jsp?bbcid=%d&format=xml", voaid];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setUsername:@"bbcwords"];
    [request startSynchronous];
}

- (void)catchQue:(NSInteger) voaid
{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/minutes/questionApi.jsp?bbcid=%d&format=xml", voaid];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    [request setDelegate:self];
    [request setUsername:@"question"];
    [request startSynchronous];
}

- (void)QueueDownloadVoa
{
//    NSLog(@"Queue 预备: %d",voa._voaid);
    NSOperationQueue *myQueue = [PlayViewController sharedQueue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://static.iyuba.com/sounds/minutes/%@", voa._sound]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//    if (request.tag == voa._voaid) {
        [downloadFlg setHidden:YES];
        [collectButton setHidden:YES];
        [downloadingFlg setHidden:NO];
//    }
    [request setDelegate:self];
//    [request setUsername:@"sound"];
    [request setTag:voa._voaid];
    [request setDidStartSelector:@selector(requestSoundStarted:)];
    [request setDidFinishSelector:@selector(requestSoundDone:)];
    [request setDidFailSelector:@selector(requestSoundWentWrong:)];
    [myQueue addOperation:request]; //queue is an NSOperationQueue
    
}

- (void)requestSoundStarted:(ASIHTTPRequest *)request
{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    //创建audio份目录在Documents文件夹下，not to back up
	NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];;
    userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%d.mp3", request.tag]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:userPath]) {
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
    NSData *responseData = [request responseData]; 
//    if ([request.username isEqualToString:@"sound"]) {
        NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //创建audio份目录在Documents文件夹下，not to back up
        NSString *audioPath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"audio"]];
        NSFileManager *fm = [NSFileManager defaultManager];
        userPath = [audioPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.mp3", request.tag]];
        
        //    NSLog(@"requestFinished。大小：%d", [responseData length]);
        if ([fm createFileAtPath:userPath contents:responseData attributes:nil]) {
        }
        if (request.tag == voa._voaid) {
            localFileExist = YES;
            downloaded = YES;
//            if (![[NSUserDefaults standardUserDefaults] boolForKey:@"recordRead"]) {
                [downloadFlg setHidden:NO];
//            }
            [collectButton setHidden:YES];
            [downloadingFlg setHidden:YES];
        }
        [VOAFav alterCollect:request.tag];
    if (contentMode == 2 && playMode == 3) {
        flushList = YES;
    }
        [fm release];
        [VOAView clearDownload:request.tag];
//    } 
}

- (void)requestSoundWentWrong:(ASIHTTPRequest *)request
{
    
//    if ([request.username isEqualToString:@"sound"]) {
        [VOAView clearDownload:request.tag];
        UIAlertView *netAlert = [[UIAlertView alloc] initWithTitle:kPlayFive message:[NSString stringWithFormat:@"%d.mp3%@", request.tag,kPlayFive] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        if (request.tag == voa._voaid) {
            [collectButton setHidden:NO];
            [downloadingFlg setHidden:YES];
            [downloadFlg setHidden:YES];
        }
        [netAlert show];
        [netAlert release];
//    } 
//    else {
//        if ([request.username isEqualToString:@"bbcwords"]) {
//            <#statements#>
//        }
//    }
}

- (void)catchNetA
{
//    NSString *url = @"http://www.baidu.com";
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:@"catchnet"];
//    [request startAsynchronous];
    
    NSOperationQueue *myQueue = [PlayViewController sharedQueue];
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setUsername:@"catchnet"];
//    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [myQueue addOperation:request]; //queue is an NSOperationQueue
}


- (void)catchWords:(NSString *) word
{
//    NSString *url = [NSString stringWithFormat:@"http://word.iyuba.com/words/apiWord.jsp?q=%@",word];
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:word];
//    [request startAsynchronous];
    
    NSOperationQueue *myQueue = [PlayViewController sharedQueue];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://word.iyuba.com/words/apiWord.jsp?q=%@",word]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDelegate:self];
    [request setUsername:word];
//    [request setDidStartSelector:@selector(requestStarted:)];
    [request setDidFinishSelector:@selector(requestDone:)];
    [request setDidFailSelector:@selector(requestWentWrong:)];
    [myQueue addOperation:request]; //queue is an NSOperationQueue
}

- (void)requestWentWrong:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"catchnet"]) {
//        NSLog(@"有网络");
        isExisitNet = NO;
        return;
    }
    [myWord init];
    myWord.wordId = [VOAWord findLastId]+1;
    myWord.checks = 0;
    myWord.remember = 0;
    myWord.key = request.username;
    myWord.audio = @"";
    myWord.pron = @" ";
    myWord.def = @"";
    myWord.userId = nowUserId;
    for (UIView *sView in [explainView subviews]) {
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
    UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, explainView.frame.size.width, 80)];
    if (isiPhone) {
        [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierT].width+10, 20)];
        [wordLabel setFont :CourierT];
        [defLabel setFont :Courier];
    } else {
        [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
        [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierTD].width+10, 20)];
        [wordLabel setFont :CourierTD];
        [defLabel setFont :CourierD];
    }
    
    [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setFrame:CGRectMake(10, 5, 30, 30)];
    [explainView addSubview:addButton];
    
    
    
    [wordLabel setTextAlignment:UITextAlignmentCenter];
    [wordLabel setTextColor:[UIColor whiteColor]];
    wordLabel.text = myWord.key;
    wordLabel.backgroundColor = [UIColor clearColor];
    [explainView addSubview:wordLabel];
    [wordLabel release];
    
    
    
    defLabel.backgroundColor = [UIColor clearColor];
    [defLabel setTextColor:[UIColor whiteColor]];
    [defLabel setLineBreakMode:UILineBreakModeWordWrap];
    [defLabel setNumberOfLines:1];
    defLabel.text = kPlaySix;
//    NSLog(@"未联网无法查看释义!");
    [explainView addSubview:defLabel];
    [defLabel release];
//    [explainView setAlpha:1];

    [explainView setHidden:NO];
}

- (void)requestDone:(ASIHTTPRequest *)request{
    if ([request.username isEqualToString:@"catchnet"]) {
//        NSLog(@"有网络");
        isExisitNet = YES;
        return;
    }
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];;
    [myWord init];
    int result = 0;
    NSArray *items = [doc nodesForXPath:@"data" error:nil];
    if (items) {
        for (DDXMLElement *obj in items) {
            myWord.wordId = [VOAWord findLastId]+1;
            myWord.checks = 0;
            myWord.remember = 0;
            myWord.userId = nowUserId;
            result = [[obj elementForName:@"result"] stringValue].intValue;
            if (result) {
                myWord.key = [[obj elementForName:@"key"] stringValue];
                myWord.audio = [[obj elementForName:@"audio"] stringValue];
                myWord.pron = [[obj elementForName:@"pron"] stringValue];
                if (myWord.pron == nil) {
                    myWord.pron = @" ";
                }
                myWord.def = [[[[obj elementForName:@"def"] stringValue] stringByReplacingOccurrencesOfRegex:@"\\s+" withString:@""]stringByReplacingOccurrencesOfString:@"null" withString:@""];
                [self wordExistDisplay];
//                for (UIView *sView in [explainView subviews]) {
//                    if (![sView isKindOfClass:[UIImageView class]]) {
//                        [sView removeFromSuperview];
//                    }
//                }
//
//                UIFont *Courier = [UIFont systemFontOfSize:15];
//                UIFont *CourierT = [UIFont boldSystemFontOfSize:15];
//                UIFont *CourierD = [UIFont systemFontOfSize:18];
//                UIFont *CourierTD = [UIFont boldSystemFontOfSize:18];
//                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//                UILabel *wordLabel = [[UILabel alloc]init];
//                UILabel *pronLabel = [[UILabel alloc]init];
//                UITextView *defTextView = [[UITextView alloc] init];
//                UIButton *audioButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//                if (isiPhone) {
//                    [addButton setFrame:CGRectMake(5, 0, 25, 25)];
//                    [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
//                    [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierT].width+10, 20)];
//                    [pronLabel setFrame:CGRectMake(40+[myWord.key sizeWithFont:CourierT].width, 5, [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width+10, 20)];
//                    [defTextView setFrame:CGRectMake(0, 22, explainView.frame.size.width, 80)];
//                    [audioButton setFrame:CGRectMake(50+[myWord.key sizeWithFont:CourierT].width + [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:Courier].width, 5, 20, 20)];
//                    [wordLabel setFont :CourierT];
//                    [pronLabel setFont :Courier];
//                    [defTextView setFont :Courier];
//                } else {
//                    [addButton setFrame:CGRectMake(10, 5, 20, 20)];
//                    [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
//                    [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierTD].width+10, 20)];
//                    [pronLabel setFrame:CGRectMake(40+[myWord.key sizeWithFont:CourierTD].width, 5, [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:CourierD].width+10, 20)];
//                    [defTextView setFrame:CGRectMake(0, 22, explainView.frame.size.width, 80)];
//                    [audioButton setFrame:CGRectMake(50+[myWord.key sizeWithFont:CourierTD].width + [[NSString stringWithFormat:@"[%@]", myWord.pron] sizeWithFont:CourierD].width, 5, 20, 20)];
//                    [wordLabel setFont :CourierTD];
//                    [pronLabel setFont :CourierD];
//                    [defTextView setFont :CourierD];
//                }
//                
////                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
////                [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
//                [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
//                
//                [explainView addSubview:addButton];
//                
////                UILabel *wordLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:Courier].width+10, 20)];
////                [wordLabel setFont :Courier];
//                [wordLabel setTextAlignment:UITextAlignmentCenter];
//                [wordLabel setTextColor:[UIColor whiteColor]];
//                wordLabel.text = myWord.key;
//                wordLabel.backgroundColor = [UIColor clearColor];
//                [explainView addSubview:wordLabel];
//                [wordLabel release];
//                
//                
//                
//                [pronLabel setTextColor:[UIColor whiteColor]];
//                [pronLabel setTextAlignment:UITextAlignmentLeft];
//                if ([myWord.pron isEqualToString:@" "]) {
//                    pronLabel.text = @"";
//                }else
//                {
//                    pronLabel.text = [NSString stringWithFormat:@"[%@]", myWord.pron];
//                }
//                pronLabel.backgroundColor = [UIColor clearColor];
//                [explainView addSubview:pronLabel];
//                [pronLabel release];
//                
//                if (wordPlayer) {
//                    [wordPlayer release];
//                }
//                wordPlayer =[[AVPlayer alloc]initWithURL:[NSURL URLWithString:myWord.audio]];
//                [wordPlayer play];
//                
//                
//                [audioButton setImage:[UIImage imageNamed:@"wordSound.png"] forState:UIControlStateNormal];
//                [audioButton addTarget:self action:@selector(playWord:) forControlEvents:UIControlEventTouchUpInside];
//                
//                [explainView addSubview:audioButton];
//                
//                
//                if ([myWord.def isEqualToString:@" "]) {
//                    defTextView.text = kPlaySeven;
////                    NSLog(@"未联网无法查看释义!");             
//                }else{
//                    defTextView.text = myWord.def;
//                }
//                [defTextView setEditable:NO];
//                
//                [defTextView setTextColor:[UIColor whiteColor]];
//                defTextView.backgroundColor = [UIColor clearColor];
//                [explainView addSubview:defTextView];  
//                [defTextView release];
////                [explainView setAlpha:1];
//                [explainView setHidden:NO];
                
            }else
            {
                myWord.key = request.username;
                myWord.audio = @"";
                myWord.pron = @" ";
                myWord.def = @"";
                [self wordNoDisplay];
//                for (UIView *sView in [explainView subviews]) {
//                    if (![sView isKindOfClass:[UIImageView class]]) {
//                        [sView removeFromSuperview];
//                    }
//                }
//                
//                UIFont *Courier = [UIFont systemFontOfSize:15];
//                UIFont *CourierT = [UIFont boldSystemFontOfSize:15];
//                UIFont *CourierD = [UIFont systemFontOfSize:18];
//                UIFont *CourierTD = [UIFont boldSystemFontOfSize:18];
//                UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom] ;
//                UILabel *wordLabel = [[UILabel alloc]init];
//                UILabel *defLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 22, explainView.frame.size.width, 80)];
//                if (isiPhone) {
//                    [addButton setImage:[UIImage imageNamed:@"addWordBBC.png"] forState:UIControlStateNormal];
//                    [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierT].width+10, 20)];
//                    [wordLabel setFont :CourierT];
//                    [defLabel setFont :Courier];
//                } else {
//                    [addButton setImage:[UIImage imageNamed:@"addWordBBCP.png"] forState:UIControlStateNormal];
//                    [wordLabel setFrame:CGRectMake(30, 5, [myWord.key sizeWithFont:CourierTD].width+10, 20)];
//                    [wordLabel setFont :CourierTD];
//                    [defLabel setFont :CourierD];
//                }
//                
//                [addButton addTarget:self action:@selector(addWordPressed:) forControlEvents:UIControlEventTouchUpInside];
//                [addButton setFrame:CGRectMake(10, 5, 30, 30)];
//                [explainView addSubview:addButton];
//                
//                
//                
//                [wordLabel setTextAlignment:UITextAlignmentCenter];
//                [wordLabel setTextColor:[UIColor whiteColor]];
//                wordLabel.text = myWord.key;
//                wordLabel.backgroundColor = [UIColor clearColor];
//                [explainView addSubview:wordLabel];
//                [wordLabel release];
//                
//                
//                
//                defLabel.backgroundColor = [UIColor clearColor];
//                [defLabel setTextColor:[UIColor whiteColor]];
//                [defLabel setLineBreakMode:UILineBreakModeWordWrap];
//                [defLabel setNumberOfLines:1];
//                defLabel.text = kPlaySix;
//                //    NSLog(@"未联网无法查看释义!");
//                [explainView addSubview:defLabel];
//                [defLabel release];
//                
//                [explainView setHidden:NO]; 
            }
        }
    }
    [doc release];
}

- (void)catchComments:(NSInteger)pages{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/minutes/updateShuoShuo.jsp?groupName=iyuba&mod=select&topicId=%i&pageNumber=%i&pageCounts=15",voa._voaid,pages];
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
        NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/minutes/updateShuoShuo.jsp?userId=%i&groupName=ios&mod=insert&topicId=%i&comment=%@",uid, voa._voaid, [[textView text] URLEncodedString]];
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

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"comment"]) {
        [self.commTableView setFrame:(isiPhone? CGRectMake(0, 0, 320, 0) : CGRectMake(0, 0, 768, 0))];
    }
    [self catchNetA];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"comment" ]) {
        /////解析
        NSArray *items = [doc nodesForXPath:@"response" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                nowPage = [[[obj elementForName:@"pageNumber"] stringValue] integerValue] ;
                
                //                NSLog(@"pageNumber:%d",pageNumber);
                
                
                if (nowPage == 1) {
                    [commArray removeAllObjects];
                    //                    NSInteger commcount = [[[obj elementForName:@"counts"] stringValue] integerValue] ;
                    totalPage = [[[obj elementForName:@"totalPage"] stringValue] integerValue] ;
                    //                    NSLog(@"commcount:%d",commcount);
                    //                    commArray = [[NSMutableArray alloc]initWithCapacity:4*commcount];
                    //                    struct comment comms[commNumber];
                }
            }
        }
        items = [doc nodesForXPath:@"response/row" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                [commArray addObject:[[obj elementForName:@"userName"] stringValue]];
                //                NSLog(@"userName:%@",[[obj elementForName:@"userName"] stringValue]);
                [commArray addObject:[[obj elementForName:@"imgSrc"] stringValue]];
                [commArray addObject:[[obj elementForName:@"shuoShuo"] stringValue]];
                [commArray addObject:[[obj elementForName:@"createDate"] stringValue]];
                //                comms[commNumber].userName = [[obj elementForName:@"userName"] stringValue];
                //                VOAView *newVoa = [[VOAView alloc] init];
                //                newVoa._voaid = [[[obj elementForName:@"voaid"] stringValue] integerValue] ;
                //                if (lastId<newVoa._voaid) {
                //                    lastId = newVoa._voaid;
                //                }
            }
        }
//         NSLog(@"评论数：%i---表高:%f", [commArray count], [commArray count]*kCommTableHeightPh);
        if (isiPhone) { //动态改变表的大小，防止背景出现灰色
            if ([commArray count]/4<6) {
                [self.commTableView setFrame:CGRectMake(0, 0, 320, [commArray count]/4*kCommTableHeightPh)];
//                NSLog(@"表高:%f", [commArray count]/4*kCommTableHeightPh);
            }
            else {
                [self.commTableView setFrame:CGRectMake(0, 0, 320, 310)];
            }
        } else {
            if ([commArray count]/4<10) {
                [self.commTableView setFrame:CGRectMake(0, 0, 768, [commArray count]/4*80.0f)];
//                NSLog(@"表高:%f", [commArray count]/4*80.0f);
            }
            else {
                [self.commTableView setFrame:CGRectMake(0, 0, 768, 755)];
            }
        }
        
        [commTableView reloadData];
        if (isNewComm) {
            [self.commTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
            isNewComm = NO;
        } 
        //        int i = 0;
        //        NSLog(@"count：%i",[commArray count]);
        //        for (; i< [commArray count]; i++) {
        //            NSLog(@"%i:%@",i,[commArray objectAtIndex:i]);
        //        }
    } else if ([request.username isEqualToString:@"send" ]) {
        //        [commArray removeAllObjects];
        isNewComm = YES;
//        NSLog(@"1111");
        [textView setText:@""];
        [self catchComments:1];
    } else if ([request.username isEqualToString:@"detail"]) {
        NSArray *items = [doc nodesForXPath:@"data/bbctext" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
//                rightCharacter = YES;
                //                NSLog(@"222");
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
    }  else if ([request.username isEqualToString:@"question"]) {
            //            NSArray *items = [doc nodesForXPath:@"data" error:nil];
            //        if (items) {
            //            for (DDXMLElement *obj in items) {
            //                NSInteger total = [[[obj elementForName:@"total"] stringValue] integerValue] ;
            //                NSLog(@"total:%d",total);
            //            }
            //        }
            NSArray *items = [doc nodesForXPath:@"data/bbcquestion" error:nil];
            if (items) {
                for (DDXMLElement *obj in items) {
                    NSInteger bbcId = [[[obj elementForName:@"BbcId"] stringValue] integerValue];
                    //                    NSInteger indexId = [[[obj elementForName:@"IndexId"] stringValue] integerValue] ;
                    NSString *que = [[obj elementForName:@"Question"] stringValue] ;
                    NSString *ansOne = [[obj elementForName:@"Answer1"] stringValue];
                    NSString *ansTwo = [[obj elementForName:@"Answer2"] stringValue];
                    NSString *ansThree = [[obj elementForName:@"Answer3"] stringValue];
                    NSString *ans = [[obj elementForName:@"Answer"] stringValue];
                    [VOAView insertQuesTion:bbcId que:que answerOne:ansOne answerTwo:ansTwo answerThree:ansThree answer:ans];
                }
            }
    }
    [doc release], doc = nil;
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
//    NSLog(@"touch");
    if (fixTimeView.alpha > 0.5) {
        [UIView beginAnimations:@"Switch" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.5];
        [fixTimeView setAlpha:0];
        [UIView commitAnimations];
    }
//    if ([keyCommFd isFirstResponder]) {
//        [self.view endEditing:YES];
//        return ;
//    }
    if (![explainView isHidden]) {
        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
    }else
    {
        if (switchFlg) {
            self.switchFlg = NO;
//            [switchBtn setTitle:@"开" forState:UIControlStateNormal] ;
            for (UIView *hideView in textScroll.subviews) {
                if (hideView.tag < 200) {
                    [hideView setHidden:YES]; 
                }
            }
            [lyricCnLabel setHidden:YES];
        }else{
            self.switchFlg = YES;
//            [switchBtn setTitle:@"关" forState:UIControlStateNormal] ;
            for (UIView *hideView in textScroll.subviews) {
                if (hideView.tag < 200) {
                    [hideView setHidden:NO]; 
                }
            }
            [lyricCnLabel setHidden:NO];
        }
        
    }
}

#pragma mark - Background Player Control
/**
 * 接受外部音频控制
 */
- (void)remoteControlReceivedWithEvent:(UIEvent *)event {  
    if (event.type == UIEventTypeRemoteControl) {  
        
        switch (event.subtype) {  
                
            case UIEventSubtypeRemoteControlTogglePlayPause: 
                if (!readRecord) {
                    [self playButtonPressed:playButton];
                }
                break;  
                
            case UIEventSubtypeRemoteControlPreviousTrack:  
                [self prePlay:preButton];  
                break;  
                
            case UIEventSubtypeRemoteControlNextTrack:  
                [self aftPlay:nextButton];  
                break;  
                
            default:  
                break;  
        }  
    } 
    
}

#pragma mark - MyLabelDelegate
- (void)touchUpInside: (NSSet *)touches mylabel:(MyLabel *)mylabel {
    int lineHeight = [@"a" sizeWithFont:mylabel.font].height;
    int LineStartlocation = 0;
    if (mylabel.tag == 2000) {
        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
        return;
    }
    if (![explainView isHidden]) {
        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
    }
//    NSLog(@"取词:%@",mylabel.text);
    NSString * WordIFind = nil;
    UITouch *touch = [touches anyObject]; 
//    CGPoint point = [touch locationInView:self.textScroll];
    CGPoint point = [touch locationInView:mylabel];
//    NSLog(@"X1:%f; Y1:%f",point.x, point.y);
//    CGPoint pointT = [touch locationInView:self.view];
//    NSLog(@"X:%f; Y:%f",pointT.x, pointT.y);
//    int tagetline = ceilf((point.y- mylabel.frame.origin.y)/lineHeight);
    int tagetline = ceilf((point.y)/lineHeight);
//    CGSize maxSize = CGSizeMake(textScroll.frame.size.width, CGFLOAT_MAX);
    CGSize maxSize = CGSizeMake(mylabel.frame.size.width, CGFLOAT_MAX);
//    if (readRecord) {
////        point = [touch locationInView:self.myScroll];
//        point = [touch locationInView:mylabel];
//        if (isiPhone) {
////            tagetline = ceilf((point.y- 20)/lineHeight);
//            tagetline = ceilf((point.y)/lineHeight);
//            maxSize = CGSizeMake(260, CGFLOAT_MAX);
//        } else {
//            tagetline = ceilf((point.y- 50)/lineHeight);
//            maxSize = CGSizeMake(568, CGFLOAT_MAX);
//        }
//        
//    }
//    NSLog(@"x:%f,y:%f",point.x,point.y);
//    int fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"nowValueFont"];
//    NSLog(@"nowValueFont:%d",fontSize);
//    UIFont *Courier = [UIFont fontWithName:@"Courier" size:fontSize];
    
    //    int numberoflines = self.frame.size.height / lineHeight;
//    int tagetline = ceilf((point.y- mylabel.frame.origin.y)/lineHeight);
    NSString * sepratorString = @", ，。.?!:\"“”-()'‘";
    //    NSString * text = @"...idowrhu wpe gre dddd.. 'eow.ei, we u";
    NSCharacterSet * sepratorSet = [NSCharacterSet characterSetWithCharactersInString:sepratorString];
//    NSLog(@"text:%@", mylabel.text);
//    NSString *test = [NSString stringWithFormat:@"%@.", mylabel.text];
//    NSArray * splitStr = [test componentsSeparatedByCharactersInSet:sepratorSet];
    NSArray * splitStr = [mylabel.text componentsSeparatedByCharactersInSet:sepratorSet];
    //    NSArray * splitStr = [self.text componentsSeparatedByString:@" "];
    
//    for (NSString *test in splitStr) {
//        NSLog(@"%@ ", test);
//    }

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
        if (word) {
            myWord.key = word.key;
            myWord.audio = word.audio;
            myWord.pron = [NSString stringWithFormat:@"%@",word.pron] ;
            if (myWord.pron == nil) {
                myWord.pron = @" ";
            }
            myWord.def = [[word.def stringByReplacingOccurrencesOfRegex:@"\\s+" withString:@""]stringByReplacingOccurrencesOfString:@"null" withString:@""];
            [word release];
            [self wordExistDisplay];
        } else {
            if (isExisitNet) {
                //            NSLog(@"有网");
                [self catchWords:WordIFind];
            } else {
                myWord.key = WordIFind;
                myWord.audio = @"";
                myWord.pron = @" ";
                myWord.def = @"";
                [self wordNoDisplay];
            }
        }
//        if (readRecord) {
        CGPoint windowPoint = [mylabel convertPoint:mylabel.bounds.origin toView:self.view];
        [myHighLightWord setFrame:CGRectMake(windowPoint.x+pointX, windowPoint.y+pointY, width, lineHeight)];
//        [myHighLightWord setFrame:CGRectMake(pointX, pointY, width, lineHeight)];
//        [myHighLightWord setFrame:CGRectMake(pointT.x, pointT.y, width, lineHeight)];
//        }else {
//            [myHighLightWord setFrame:CGRectMake(pointX, mylabel.frame.origin.y + pointY, width, lineHeight)];
//        }
        
        [myHighLightWord setHighlighted:YES];
        [myHighLightWord setHighlightedTextColor:[UIColor whiteColor]];
//        [myHighLightWord setBackgroundColor:[UIColor blueColor]];
//        if (readRecord) {
//            [mylabel addSubview:myHighLightWord];//$$$
//        [myHighLightWord release];
//        }else {
//            [textScroll addSubview:myHighLightWord];
//        }
        [myHighLightWord setHidden:NO];
//        wordBack = [[UIView alloc] initWithFrame:CGRectMake(pointX, pointY, width, lineHeight)];
//        wordBack.backgroundColor = [UIColor colorWithRed:1.0 green:0.651 blue:0.098 alpha:0.5];
//        [self insertSubview:wordBack atIndex:0];
//        [self GetExplain:WordIFind];
    }   
    
}

- (void)touchUpInsideLong: (NSSet *)touches mylabel:(MyLabel *)mylabel {
    if (![explainView isHidden]) {
        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
    }
    CGPoint windowPoint = [mylabel convertPoint:mylabel.bounds.origin toView:self.view];
//    NSLog(@"x:%f, y:%f", windowPoint.x, windowPoint.y);
    if (mylabel.tag > 199) {
        [player seekToTime:CMTimeMakeWithSeconds([[timeArray objectAtIndex:mylabel.tag - 200] unsignedIntValue], NSEC_PER_SEC)];
        shareStr = [mylabel text];
        CGRect senRect = [mylabel frame];
        for (UIView *sView in [textScroll subviews]) {
            if ([sView isKindOfClass:[UIImageView class]]) {
                [sView removeFromSuperview];
            }
        }
//        CATransition *animation = [CATransition animation];
//        animation.delegate = self;
//        animation.duration = 0.5;
//        //        animation.timingFunction = UIViewAnimationCurveEaseInOut;
//        animation.type = @"rippleEffect";
//        [[mylabel layer] addAnimation:animation forKey:@"animation"];
        
        
//        UIImageView *senImage = [[UIImageView alloc] initWithFrame:senRect];
        senImage = [[UIImageView alloc] initWithFrame:senRect];
//        [senImage setImage:[UIImage imageNamed:@"wordFrameMyOne.png"]];
//        CGPoint windowPoint = [mylabel convertPoint:mylabel.bounds.origin toView:self.view];
        [senImage setImage:[LyricSynClass screenshot:CGRectMake(windowPoint.x, windowPoint.y+ 20, senRect.size.width, senRect.size.height)]];
        [textScroll addSubview:senImage];
        [senImage release];
        
        for (UIView *sView in [myScroll subviews]) {
            if (sView.tag == 1111) {
                [sView removeFromSuperview];
            }
        }
        CGPoint scrollPoint = [mylabel convertPoint:mylabel.bounds.origin toView:myScroll];
        starImage = [[UIImageView alloc] initWithImage:(isiPhone? [UIImage imageNamed:@"starMy.png"]: [UIImage imageNamed:@"starMyP.png"])];
        [starImage setFrame:(isiPhone? CGRectMake(scrollPoint.x+senRect.size.width/2-25, scrollPoint.y+senRect.size.height/2-25, 50, 50): CGRectMake(scrollPoint.x+senRect.size.width/2-40, scrollPoint.y+senRect.size.height/2-40, 80, 80))];
        [starImage setAlpha:0.0];
        [starImage setTag:1111];
        [myScroll addSubview:starImage];
        [starImage release];
        
        [UIView beginAnimations:@"SwitchOne" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:1.5];
        CATransition *animation = [CATransition animation];
        animation.delegate = self;
        animation.duration = 2.0;
        //        animation.timingFunction = UIViewAnimationCurveEaseInOut;
        animation.type = @"rippleEffect";
        [[mylabel layer] addAnimation:animation forKey:@"animation"];
        [senImage setFrame:CGRectMake(senRect.origin.x + senRect.size.width/2, senRect.origin.y + senRect.size.height/2, 1,1)];
//        [shareSenBtn setFrame:CGRectMake(620, 200, 20, 20)];
        [UIView commitAnimations];
        [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(starAni) userInfo:nil repeats:NO];
    }
}

- (void)starAni {
//    NSLog(@"xingxinglaile");
//    for (UIView *sView in [myScroll subviews]) {
//        if (sView.tag == 1111) {
//            [sView removeFromSuperview];
//        }
//    }
//    
//    starImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"starMy.png"]];
//    [starImage setFrame:(isiPhone? CGRectMake(320+myScroll.frame.size.width/3, myScroll.frame.size.height/3, 1, 1): CGRectMake(768+myScroll.frame.size.width/3, myScroll.frame.size.height/3, 1, 1))];
//    [starImage setTag:1111];
//    [myScroll addSubview:starImage];
//    [starImage release];
    [UIView beginAnimations:@"SwitchTwo" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [starImage setAlpha:0.5];
//    [starImage setFrame:(isiPhone? CGRectMake(320+myScroll.frame.size.width/3-25, myScroll.frame.size.height/3-25, 50, 50): CGRectMake(768+myScroll.frame.size.width/3-40, myScroll.frame.size.height/3-40, 80, 80))];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    starImage.layer.anchorPoint = CGPointMake(0.5, 0.5);
    starImage.layer.position = CGPointMake(starImage.frame.origin.x + 0.5 * starImage.frame.size.width, starImage.frame.origin.y + 0.5 * starImage.frame.size.height);
    [CATransaction commit];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanFalse forKey:kCATransactionDisableActions];
    [CATransaction setValue:[NSNumber numberWithFloat:120.0] forKey:kCATransactionAnimationDuration];
    
    CABasicAnimation *animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:120 * M_PI];
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionLinear];
    animation.delegate = self;
    [starImage.layer addAnimation:animation forKey:@"rotationAnimation"];
    [CATransaction commit];
    
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(starMoveAni) userInfo:nil repeats:NO];
//    [starImage setFrame:CGRectMake(380, 100, 50, 50)];
}

- (void)starMoveAni {
    [UIView beginAnimations:@"SwitchThree" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.2];
    [starImage setFrame:(isiPhone? CGRectMake(608, 165, 20, 20): CGRectMake(1475, 335, 30, 30))];
    [UIView commitAnimations];
    [NSTimer scheduledTimerWithTimeInterval:1.2 target:self selector:@selector(showSenShareBtn) userInfo:nil repeats:NO];
}

- (void)showSenShareBtn {
    [UIView beginAnimations:@"SwitchFive" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [shareSenBtn setFrame:(isiPhone? CGRectMake(575, 150, 65, 50): CGRectMake(1411, 300, 130, 100))];
    [starImage setFrame:(isiPhone? CGRectMake(573, 165, 20, 20): CGRectMake(1405, 335, 30, 30))];
    [UIView commitAnimations];
    [shareSenBtn setEnabled:YES];
    isShareSen = YES;
    [NSTimer scheduledTimerWithTimeInterval:3.5 target:self selector:@selector(hideSenShareBtn) userInfo:nil repeats:NO];
}

- (void)hideSenShareBtn {
    [starImage.layer removeAllAnimations]; 
    [UIView beginAnimations:@"SwitchSix" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:1.0];
    [shareSenBtn setFrame:(isiPhone? CGRectMake(610, 150, 65, 50): CGRectMake(1481, 300, 130, 100))];
    [starImage setFrame:(isiPhone? CGRectMake(608, 165, 20, 20): CGRectMake(1475, 335, 30, 30))];
    [starImage setAlpha:0.0];
    [UIView commitAnimations];
    [shareSenBtn setEnabled:NO];
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(setShareBtnInvalid) userInfo:nil repeats:NO];
    
}

- (void)setShareBtnInvalid {
    isShareSen = NO;
}

//- (void)touchUpInside: (NSSet *)touches mylabel:(MyLabel *)mylabel {
//    if (mylabel.tag == 2000) {
//        [explainView setHidden:YES];
//        [myHighLightWord setHidden:YES];
//        return;
//    }
//    if (![explainView isHidden]) {
//        [explainView setHidden:YES];
//        [myHighLightWord setHidden:YES];
//    }
//    UITouch *touch = [touches anyObject];    
//    CGPoint touchPoint = [touch locationInView:self.textScroll];
//    int fontSize = [[NSUserDefaults standardUserDefaults] integerForKey:@"nowValueFont"];
//    NSLog(@"nowValueFont:%d",fontSize);
//    UIFont *Courier = [UIFont fontWithName:@"Courier" size:fontSize];
//    //    if (!isiPhone) {
//    //        Courier = [UIFont fontWithName:@"Courier" size:fontSize];
//    //    }
//    double engHight = [@"a" sizeWithFont:Courier].height;
//    float single = [@" " sizeWithFont:Courier].width ;//每个字符宽度，为9
//    NSLog(@"single:%f single:%f",single,[@" " sizeWithFont:Courier constrainedToSize:CGSizeMake(textScroll.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].width);
//    //    float enHeight = [@"a" sizeWithFont:Courier].height - 1;
//    float space = 0.f;
//    //    NSLog(@"space:%f",space);
//    //    NSLog(@"single:%f",single);
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0) {
//        //        space = 9;
//        space = [@" " sizeWithFont:Courier].width-1;
//    }else {
//        space = [@" " sizeWithFont:Courier].width+1;
//    }
//    int rowOne = (touchPoint.y - mylabel.frame.origin.y)/engHight + 1;
//    
//    //    NSLog(@"row:%d",rowOne);
//    //    NSLog(@"触摸：%f %f", touchPoint.x,touchPoint.y);
//    int rowTwo = 1;
//    int location = 0;
//    
//    float total = textScroll.frame.size.width;
////    NSLog(@"total:%f",textScroll.frame.size.width);
//    float myWith =-space;
//    float compare = -space;
//    float add = -space;
//    BOOL flg = YES;
//    BOOL firstFlg = NO;
//    int i = 0;
//    NSString *regEx = @"\\S+";
//    NSString *wordEx = @"\\w+";
//    NSString *nonWordEx = @"\\W+";
//    for(NSString *matchOne in [mylabel.text componentsMatchedByRegex:regEx]) {
//        //        NSLog(@"正则后one： %@ %d", matchOne,[matchOne length]);
//        i  = 0;
//        location = 0;
//        add = matchOne.length*single + space;
//        firstFlg = NO;
//        if ([matchOne isEqualToString:@"--"]&&(myWith+2*single)>(total-space)&&(myWith+2*single)<(total)) {
//            rowTwo++;
//            myWith=space;
//            continue;
//        }
//        for(NSString *matchTwo in [matchOne componentsMatchedByRegex:wordEx]) {
//            firstFlg = YES;
//            NSRange substr = [matchOne rangeOfString:matchTwo];
//            flg = (matchTwo.length == matchOne.length);
//            for(NSString *matchThree in [matchOne componentsMatchedByRegex:nonWordEx]) {
//                if (([matchThree isEqualToString:@"‘"]||[matchThree isEqualToString:@"’"]||[matchThree isEqualToString:@"“"]||[matchThree isEqualToString:@"”"])&&(myWith+single+matchOne.length*single>total)) {
//                    rowTwo++;
//                    //                        NSLog(@"0myWith:%f", myWith);
//                    myWith=-space;
//                    break;
//                }
//            }   
//            //                NSLog(@"flg:%d",flg);
//            if (flg) {
//                if ((myWith+space+matchTwo.length*single)>total) {
//                    rowTwo++;
//                    //                    NSLog(@"1width:%f", myWith);
//                    myWith = -space;
//                    //                    NSLog(@"1width:%f", myWith);
//                }
//                add = matchTwo.length*single + space;
//                compare = myWith + space;
//            }
//            else{
//                if (i==0) {
//                    myWith += substr.location*single+ space;
//                    //                    NSLog(@"width:%f, %d %d",myWith, location, substr.location);
//                }
//                else
//                {
//                    //                    NSLog(@"width1.%d:%f", i,myWith);
//                    //                    NSLog(@"hahahah : %c",[matchOne characterAtIndex:(substr.location-1)]);
//                    if ([matchOne characterAtIndex:(substr.location-1)] == '-') {
//                        myWith += (substr.location - location-1)*single+space;
//                    }else
//                    {
//                        myWith += (substr.location - location)*single;
//                    }
//                    //                    NSLog(@"width1.%d:%f, %d %d",i,myWith, location, substr.location);
//                }
//                char cc;
//                if ((substr.location+matchTwo.length)<matchOne.length) {
//                    cc = [matchOne characterAtIndex:(substr.location+matchTwo.length)];
//                    if ((cc=='.'||cc=='-'||cc==',')&&(myWith+matchTwo.length*single+space) > total)
//                    {
//                        rowTwo++;
//                        myWith=0;
//                    }
//                }
//                if ((myWith + matchTwo.length*single) > total) 
//                {
//                    rowTwo++;
//                    //                    NSLog(@"3width:%f", myWith);
//                    myWith=0;
//                }
//                location = substr.location;
//                compare = myWith;
//            }
//            i++;
//            if ((rowOne==rowTwo)&&(touchPoint.x>compare)&&(touchPoint.x<(compare+matchTwo.length*single))) {
//                //                NSLog(@"正则后two： %@ %d", matchTwo,[matchTwo length]);
//                //                NSLog(@"我找到了！词为:%@,x:%f,y:%f,width:%f,height:20.0", matchTwo, compare, mylabel.frame.origin.y + (rowTwo-1)*19.0, [matchTwo length] * single);
//                [self catchWords:matchTwo];
//                
//                
//                [myHighLightWord setFrame:CGRectMake(compare, mylabel.frame.origin.y + (rowTwo-1)*engHight, [matchTwo length] * single, engHight)];
//                [myHighLightWord setAlpha:0.5];
//                [myHighLightWord setHighlighted:YES];
//                [myHighLightWord setHighlightedTextColor:[UIColor whiteColor]];
//                [myHighLightWord setBackgroundColor:[UIColor blueColor]];
//                [textScroll addSubview:myHighLightWord];
//                [myHighLightWord setHidden:NO];
//                return;
//            }
//            if (rowTwo > rowOne) {
//                return;
//            }
//            
//        }
//        if (firstFlg) {
//            if (flg) {
//                
//                myWith+=add;
//                //                NSLog(@"5width:%f", myWith);
//            }
//            else
//            {
//                myWith += (matchOne.length - location)*single;
//                //                NSLog(@"6width:%f", myWith);
//            }
//        } else{
//            myWith += matchOne.length*single + space;
//        }
//        
//    }    
//    
//}


#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)sender
//{
//    
////    NSLog(@"111");
//}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (![myHighLightWord isHidden]) {
        //        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
    }
    if (scrollView.tag != 1) {
        [self.view endEditing:YES];
        if (![explainView isHidden]) {
            [explainView setHidden:YES];
            [myHighLightWord setHidden:YES];
        }
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = myScroll.frame.size.width;
        int page = floor((myScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        //    if (page == 3) {
        //        //该代码是设置手机喇叭与麦克风同时工作 iphone 3.0以上版本 播放类型
        //        UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
        //        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
        //        //设置采样率的
        //        Float64 smpl=kAudioSessionProperty_CurrentHardwareSampleRate;
        //        AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, sizeof(smpl), &smpl);
        //        //设置声音输出扬声器 还是默认的接收器kAudioSessionOverrideAudioRoute_None
        //        UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
        //        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRoute);
        ////        page = 1;
        //        if (isiPhone) {
        //            [myScroll scrollRectToVisible:CGRectMake(640, 0, 320, 288) animated:YES];
        //        } else {
        //            [myScroll scrollRectToVisible:CGRectMake(1536, 0, 768, 665) animated:NO];
        //        }
        //        [self aftPlay:nextButton];
        //        return;
        //    }
        if (page == 1) {
            [shareSenBtn setHidden:NO];
        } else {
            [shareSenBtn setHidden:YES];
        }
        
        if (page == 2) {
            //        [lyricCnLabel setNumberOfLines:cLines];
            //        [lyricLabel setNumberOfLines:eLines];
            //        NSLog(@"progress:%f",progress);
            //        NSLog(@"sen_num2:%d",sen_num);
            //        int cLines = (288-eLines * engHight-70) / engHight;
            if ([self hasMicphone]) {
                //该代码是设置手机喇叭与麦克风同时工作 iphone 3.0以上版本 播放类型
                UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
                AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
                //设置采样率的
                Float64 smpl=kAudioSessionProperty_CurrentHardwareSampleRate;
                AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, sizeof(smpl), &smpl);
            }
            if (![self hasHeadset]) {
                //设置声音输出扬声器 还是默认的接收器kAudioSessionOverrideAudioRoute_None
                UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
                AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRoute);
            }
            double engHight = [@"a" sizeWithFont:CourierOne].height;
            
            //        NSLog(@"sen_num1:%d",sen_num);
            CMTime playerProgress = [player currentTime];
            double progress = CMTimeGetSeconds(playerProgress);
            int i = 0;
            for (; i < [timeArray count]; i++) {
                if ((int)progress < [[timeArray objectAtIndex:i] unsignedIntValue]) {
                    sen_num = i+1;//跟读标识句子号
                    recordTime = (i > 0 ? [[timeArray objectAtIndex:i] unsignedIntValue] - [[timeArray objectAtIndex:i-1] unsignedIntValue] : [[timeArray objectAtIndex:i] unsignedIntValue]) ;
                    break;
                }
            }
            //        NSLog(@"lyCnretain1:%i", [lyCn retainCount]);
            [lyCn release];
            [lyEn release];
            lyEn = [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
            lyCn = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
            
            int eLines = 0;
            
            if (isiPhone) {
                eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
                [lyricLabel setFrame:CGRectMake(670, 20, 260, eLines * engHight)];
                [lyricCnLabel setFrame:CGRectMake(670, 20+eLines * engHight, 260, 350-eLines * engHight)];
//                if ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]) {
//                    [preButton setFrame:CGRectMake(5, 430, 30, 30)];
//                    [nextButton setFrame:CGRectMake(115, 430, 30, 30)];
//                } else {
                    [preButton setFrame:CGRectMake(35, 10, 30, 30)];
                    [nextButton setFrame:CGRectMake(255, 10, 30, 30)];
//                }
                
                //                if (isiPhone) {
                //                    [preButton setImage:[UIImage imageNamed:@"preSen@2x.png"] forState:UIControlStateNormal];
                //                    [nextButton setImage:[UIImage imageNamed:@"nextSen@2x.png"] forState:UIControlStateNormal];
                //                }
            }else {
                eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(568, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
                [lyricLabel setFrame:CGRectMake(1636, 50, 568, eLines * engHight)];
                [lyricCnLabel setFrame:CGRectMake(1636, 50+eLines * engHight, 568, 705-eLines * engHight)];
                
                [preButton setFrame:CGRectMake(100, 945, 50, 58)];
                [nextButton setFrame:CGRectMake(618, 945, 50, 58)];
            }
            
            lyricLabel.text = lyEn;
            //        [lyEn release];
            
            if (![lyCn isEqualToString:@"null"] && ![lyCn isEqualToString:@""] && ![lyCn isEqualToString:@"test"]) {
                lyricCnLabel.text = lyCn;
                //            [lyCn release];
            }else{
                lyricCnLabel.text = @"";
            }
            //        NSLog(@"lyCnretain2:%i", [lyCn retainCount]);
            readRecord = YES;
            [playButton setHidden:YES];
            [timeSlider setHidden:YES];
            [currentTimeLabel setHidden:YES];
            [totalTimeLabel  setHidden:YES];
            [loadProgress setHidden:YES];
            [downloadFlg setHidden:YES];
            [collectButton setHidden:YES];
            [downloadingFlg setHidden:YES];
            [btn_play setHidden:NO];
            [btn_record setHidden:NO];
//            [lvlMeter_in setHidden:NO];
            [recordLabel setHidden:NO];
//            [clockButton setHidden:YES];
            [modeBtn setHidden:YES];
            if ([self hasMicphone]) {
                [btn_play setEnabled:YES];
                [btn_record setEnabled:YES];
            }
        }else {
            
            
            //此种模式下无法播放的同时录音
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            if (isiPhone) {
                [preButton setFrame:CGRectMake(230, 3, 30, 30)];
                [nextButton setFrame:CGRectMake(290, 3, 30, 30)];
                //                if (isiPhone) {
                //                    [preButton setImage:[UIImage imageNamed:@"preSenBBC.png"] forState:UIControlStateNormal];
                //                    [nextButton setImage:[UIImage imageNamed:@"nextSenBBC.png"] forState:UIControlStateNormal];
                //                }
            } else {
                [preButton setFrame:CGRectMake(600, 945, 50, 50)];
                [nextButton setFrame:CGRectMake(700, 945, 50, 50)];
            }
            
            [self myStopRecord];
            [self stopPlayRecord];
            
            if ([self isPlaying]) {
                if (notValid) {
                    lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                     target:self
                                                                   selector:@selector(lyricSyn)
                                                                   userInfo:nil
                                                                    repeats:YES];
                    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                                   target:self
                                                                 selector:@selector(updateSlider)
                                                                 userInfo:nil
                                                                  repeats:YES];
                    notValid = NO;
                }
            }
            readRecord = NO;
            [playButton setHidden:NO];
            [timeSlider setHidden:NO];
            [currentTimeLabel setHidden:NO];
            [totalTimeLabel  setHidden:NO];
            [loadProgress setHidden:NO];
            [btn_play setHidden:YES];
            [btn_record setHidden:YES];
            [recordLabel setHidden:YES];
            [modeBtn setHidden:NO];
            if ([self hasMicphone]) {
                [btn_play setEnabled:NO];
                [btn_record setEnabled:NO];
            }
            if (localFileExist) {
                [downloadFlg setHidden:NO];
            } else if ([VOAView isDownloading:voa._voaid]) {
                [downloadingFlg setHidden:NO];
            } else {
                [collectButton setHidden:NO];
            }
        }
        
        pageControl.currentPage = page;
        
        [UIView beginAnimations:@"Switch" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.5];
        switch (page) {
            case 0:
                [RoundBack setCenter:CGPointMake(btnOne.center.x, btnOne.center.y+(isiPhone?5:10))];
                break;
            case 1:
                [RoundBack setCenter:CGPointMake(btnTwo.center.x, btnTwo.center.y+(isiPhone?5:10))];
                break;
            case 2:
                [RoundBack setCenter:CGPointMake(btnThree.center.x, btnThree.center.y+(isiPhone?5:10))];
                break;
            case 3:
                [RoundBack setCenter:CGPointMake(btnFour.center.x, btnFour.center.y+(isiPhone?5:10))];
                break;
            case 4:
                [RoundBack setCenter:CGPointMake(btnFive.center.x, btnFive.center.y+(isiPhone?5:10))];
                break;
            case 5:
                [RoundBack setCenter:CGPointMake(btnSix.center.x, btnSix.center.y+(isiPhone?5:10))];
                break;
            default:
                break;
        }
        
        [UIView commitAnimations];
        
        [pageControl updateAfterScroll];
        
        /**
         *  更新系统的pageControl图片时用如下方法.
         */
        /*NSArray *subView = pageControl.subviews;     // UIPageControl的每个点
         for (int i = 0; i < [subView count]; i++) {
         UIImageView *dot = [subView objectAtIndex:i];
         dot.image = (pageControl.currentPage == i ? [UIImage imageNamed:@"RedPoint.png"] : [UIImage imageNamed:@"BluePoint.png"]);
         }*/
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (![myHighLightWord isHidden]) {
        //        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
    }
    if (scrollView.tag != 1) {
        [self.view endEditing:YES];
        if (![explainView isHidden]) {
            [explainView setHidden:YES];
            [myHighLightWord setHidden:YES];
        }
        // Switch the indicator when more than 50% of the previous/next page is visible
        CGFloat pageWidth = myScroll.frame.size.width;
        int page = floor((myScroll.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        //    if (page == 3) {
        //        //该代码是设置手机喇叭与麦克风同时工作 iphone 3.0以上版本 播放类型
        //        UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
        //        AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
        //        //设置采样率的
        //        Float64 smpl=kAudioSessionProperty_CurrentHardwareSampleRate;
        //        AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, sizeof(smpl), &smpl);
        //        //设置声音输出扬声器 还是默认的接收器kAudioSessionOverrideAudioRoute_None
        //        UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
        //        AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRoute);
        ////        page = 1;
        //        if (isiPhone) {
        //            [myScroll scrollRectToVisible:CGRectMake(640, 0, 320, 288) animated:YES];
        //        } else {
        //            [myScroll scrollRectToVisible:CGRectMake(1536, 0, 768, 665) animated:NO];
        //        }
        //        [self aftPlay:nextButton];
        //        return;
        //    }
        if (page == 1) {
            [shareSenBtn setHidden:NO];
        } else {
            [shareSenBtn setHidden:YES];
        }
        if (page == 2) {
            //        [lyricCnLabel setNumberOfLines:cLines];
            //        [lyricLabel setNumberOfLines:eLines];
            //        NSLog(@"progress:%f",progress);
            //        NSLog(@"sen_num2:%d",sen_num);
            //        int cLines = (288-eLines * engHight-70) / engHight;
            if ([self hasMicphone]) {
                //该代码是设置手机喇叭与麦克风同时工作 iphone 3.0以上版本 播放类型
                UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
                AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory);
                //设置采样率的
                Float64 smpl=kAudioSessionProperty_CurrentHardwareSampleRate;
                AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareSampleRate, sizeof(smpl), &smpl);
            }
            if (![self hasHeadset]) {
                //设置声音输出扬声器 还是默认的接收器kAudioSessionOverrideAudioRoute_None
                UInt32 audioRoute = kAudioSessionOverrideAudioRoute_Speaker;
                AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(UInt32), &audioRoute);
            }
            double engHight = [@"a" sizeWithFont:CourierOne].height;
            
            //        NSLog(@"sen_num1:%d",sen_num);
            CMTime playerProgress = [player currentTime];
            double progress = CMTimeGetSeconds(playerProgress);
            int i = 0;
            for (; i < [timeArray count]; i++) {
                if ((int)progress < [[timeArray objectAtIndex:i] unsignedIntValue]) {
                    sen_num = i+1;//跟读标识句子号
                    recordTime = (i > 0 ? [[timeArray objectAtIndex:i] unsignedIntValue] - [[timeArray objectAtIndex:i-1] unsignedIntValue] : [[timeArray objectAtIndex:i] unsignedIntValue]) ;
                    break;
                }
            }
            //        NSLog(@"lyCnretain1:%i", [lyCn retainCount]);
            [lyCn release];
            [lyEn release];
            lyEn = [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
            lyCn = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:(sen_num>2?sen_num-2:0)]];
            
            int eLines = 0;
            
            if (isiPhone) {
                eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(260, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
                [lyricLabel setFrame:CGRectMake(670, 20, 260, eLines * engHight)];
                [lyricCnLabel setFrame:CGRectMake(670, 20+eLines * engHight, 260, 350-eLines * engHight)];
                //                if ([[[UIDevice currentDevice] model] isEqualToString:@"iPod touch"]) {
                //                    [preButton setFrame:CGRectMake(5, 430, 30, 30)];
                //                    [nextButton setFrame:CGRectMake(115, 430, 30, 30)];
                //                } else {
                [preButton setFrame:CGRectMake(35, 10, 30, 30)];
                [nextButton setFrame:CGRectMake(255, 10, 30, 30)];
                //                }
                
                //                if (isiPhone) {
                //                    [preButton setImage:[UIImage imageNamed:@"preSen@2x.png"] forState:UIControlStateNormal];
                //                    [nextButton setImage:[UIImage imageNamed:@"nextSen@2x.png"] forState:UIControlStateNormal];
                //                }
            }else {
                eLines = [lyEn sizeWithFont:CourierOne constrainedToSize:CGSizeMake(568, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
                [lyricLabel setFrame:CGRectMake(1636, 50, 568, eLines * engHight)];
                [lyricCnLabel setFrame:CGRectMake(1636, 50+eLines * engHight, 568, 705-eLines * engHight)];
                
                [preButton setFrame:CGRectMake(100, 945, 50, 58)];
                [nextButton setFrame:CGRectMake(618, 945, 50, 58)];
            }
            
            lyricLabel.text = lyEn;
            //        [lyEn release];
            
            if (![lyCn isEqualToString:@"null"] && ![lyCn isEqualToString:@""] && ![lyCn isEqualToString:@"test"]) {
                lyricCnLabel.text = lyCn;
                //            [lyCn release];
            }else{
                lyricCnLabel.text = @"";
            }
            //        NSLog(@"lyCnretain2:%i", [lyCn retainCount]);
            readRecord = YES;
            [playButton setHidden:YES];
            [timeSlider setHidden:YES];
            [currentTimeLabel setHidden:YES];
            [totalTimeLabel  setHidden:YES];
            [loadProgress setHidden:YES];
//            [downloadFlg setHidden:YES];
//            [collectButton setHidden:YES];
//            [downloadingFlg setHidden:YES];
            [btn_play setHidden:NO];
            [btn_record setHidden:NO];
            //            [lvlMeter_in setHidden:NO];
            [recordLabel setHidden:NO];
            //            [clockButton setHidden:YES];
            [modeBtn setHidden:YES];
            if ([self hasMicphone]) {
                [btn_play setEnabled:YES];
                [btn_record setEnabled:YES];
            }
        }else {
            
            
            //此种模式下无法播放的同时录音
            [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
            if (isiPhone) {
                [preButton setFrame:CGRectMake(230, 3, 30, 30)];
                [nextButton setFrame:CGRectMake(290, 3, 30, 30)];
                //                if (isiPhone) {
                //                    [preButton setImage:[UIImage imageNamed:@"preSenBBC.png"] forState:UIControlStateNormal];
                //                    [nextButton setImage:[UIImage imageNamed:@"nextSenBBC.png"] forState:UIControlStateNormal];
                //                }
            } else {
                [preButton setFrame:CGRectMake(600, 945, 50, 50)];
                [nextButton setFrame:CGRectMake(700, 945, 50, 50)];
            }
            
            [self myStopRecord];
            [self stopPlayRecord];
            
            if ([self isPlaying]) {
                if (notValid) {
                    lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                                     target:self
                                                                   selector:@selector(lyricSyn)
                                                                   userInfo:nil
                                                                    repeats:YES];
                    sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
                                                                   target:self
                                                                 selector:@selector(updateSlider)
                                                                 userInfo:nil
                                                                  repeats:YES];
                    notValid = NO;
                }
            }
            readRecord = NO;
            [playButton setHidden:NO];
            [timeSlider setHidden:NO];
            [currentTimeLabel setHidden:NO];
            [totalTimeLabel  setHidden:NO];
            [loadProgress setHidden:NO];
            [btn_play setHidden:YES];
            [btn_record setHidden:YES];
            [recordLabel setHidden:YES];
            [modeBtn setHidden:NO];
            if ([self hasMicphone]) {
                [btn_play setEnabled:NO];
                [btn_record setEnabled:NO];
            }
            if (localFileExist) {
                [downloadFlg setHidden:NO];
            } else if ([VOAView isDownloading:voa._voaid]) {
                [downloadingFlg setHidden:NO];
            } else {
                [collectButton setHidden:NO];
            }
        }
        
        pageControl.currentPage = page;
        
        [UIView beginAnimations:@"Switch" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:.5];
        switch (page) {
            case 0:
                [RoundBack setCenter:CGPointMake(btnOne.center.x, btnOne.center.y+(isiPhone?5:10))];
                break;
            case 1:
                [RoundBack setCenter:CGPointMake(btnTwo.center.x, btnTwo.center.y+(isiPhone?5:10))];
                break;
            case 2:
                [RoundBack setCenter:CGPointMake(btnThree.center.x, btnThree.center.y+(isiPhone?5:10))];
                break;
            case 3:
                [RoundBack setCenter:CGPointMake(btnFour.center.x, btnFour.center.y+(isiPhone?5:10))];
                break;
            case 4:
                [RoundBack setCenter:CGPointMake(btnFive.center.x, btnFive.center.y+(isiPhone?5:10))];
                break;
            case 5:
                [RoundBack setCenter:CGPointMake(btnSix.center.x, btnSix.center.y+(isiPhone?5:10))];
                break;
            default:
                break;
        }
        
        [UIView commitAnimations];
        
        [pageControl updateAfterScroll];
        
        /**
         *  更新系统的pageControl图片时用如下方法.
         */
        /*NSArray *subView = pageControl.subviews;     // UIPageControl的每个点
         for (int i = 0; i < [subView count]; i++) {
         UIImageView *dot = [subView objectAtIndex:i];
         dot.image = (pageControl.currentPage == i ? [UIImage imageNamed:@"RedPoint.png"] : [UIImage imageNamed:@"BluePoint.png"]);
         }*/
    }
}

#pragma mark - AVAudioSessionDelegate
- (void)beginInterruption
{
    NSLog(@"beginInterruption");
//    if (localFileExist) {
    [player pause];
    if (isiPhone) {
        [playButton setImage:[UIImage imageNamed:@"PpausePressedBBC.png"] forState:UIControlStateNormal];
    } else {
        [playButton setImage:[UIImage imageNamed:@"PpausePressedBBC@2x.png"] forState:UIControlStateNormal];
    }
        
//    if (readRecord) {
//        NSLog(@"后台");
//        [controller stopRecord];
//    }
//    }
//    else {
//        [player pause];
////        [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
//    }
//    [playButton setImage:[UIImage imageNamed:@"PpausePressed.png"] forState:UIControlStateNormal];
//    [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
}

- (void)endInterruption
{
    if (readRecord) {
        [player play];
        if (isiPhone) {
            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBC.png"] forState:UIControlStateNormal];
        } else {
            [playButton setImage:[UIImage imageNamed:@"PplayPressedBBC@2x.png"] forState:UIControlStateNormal];
        }
    }
//     NSLog(@"endInterruption");
//    if (localFileExist) {
//        [playButton setImage:[UIImage imageNamed:@"PplayPressed.png"] forState:UIControlStateNormal];
//        [localPlayer play];
//    }else {
////        [player pause];
//    }
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
//        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"title" message:@"this is a test." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [servicesDisabledAlert show];
//        [servicesDisabledAlert release];
        if (readRecord) {
//            [player pause];
//            [playButton setImage:[UIImage imageNamed:@"PpausePressed.png"] forState:UIControlStateNormal];
        } else {
            [self playButtonPressed:playButton]; 
        }
    }
}

//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
//{
//    if (motion == UIEventSubtypeMotionShake)
//    {
//        UIAlertView *servicesDisabledAlert = [[UIAlertView alloc] initWithTitle:@"title" message:@"this is a test." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [servicesDisabledAlert show];
//        [servicesDisabledAlert release];
//    }
//}
#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0://新浪微博
            // 微博分享：
            [self shareAll];
            break;
        case 1:
            //人人分享：
//            [self ShareThisQuestion];
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
    return (tableView.tag==1?listData.count/2:([commArray count]/4 + 1));
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    if (tableView.tag==1) {
        if (![explainView isHidden]) {
            [explainView setHidden:YES];
            [myHighLightWord setHidden:YES];
        }
        UIFont *defFo = [UIFont systemFontOfSize:14];
        UIFont *defFoPad = [UIFont systemFontOfSize:18];
        UIFont *wordFo = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16];
        UIFont *wordFoPad = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:20];
        static NSString *FirstLevelCell= @"AnswerCell";
        UITableViewCell *tablecell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
        if (!tablecell) {
            tablecell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell] autorelease];
//            UILabel *defLabel = [[UILabel alloc] init];
//            UILabel *wordLabel = [[UILabel alloc] init];
            MyLabel *defLabel = [[MyLabel alloc] init];
            MyLabel *wordLabel = [[MyLabel alloc] init];
            defLabel.delegate = self;
            wordLabel.delegate = self;
            if (isiPhone) {
                [wordLabel setFrame:CGRectMake(30, 0, 290, 20)];
                [defLabel setFrame:CGRectMake(30, 20, 290, 40)];
                [wordLabel setFont:wordFo];
                [defLabel setFont:defFo];
            } else {
                [wordLabel setFrame:CGRectMake(100, 0, 568, 30)];
                [defLabel setFrame:CGRectMake(100, 30, 568, 70)];
                [wordLabel setFont:wordFoPad];
                [defLabel setFont:defFoPad];
            }
            
            [wordLabel setBackgroundColor:[UIColor clearColor]];
            [wordLabel setTag:1];
            [wordLabel setTextColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.2f alpha:1.0f]];
//            [wordLabel setTextColor:[UIColor colorWithRed:0.112f green:0.112f blue:0.112f alpha:1.0f]];
            [wordLabel  setLineBreakMode:UILineBreakModeClip];
            [wordLabel setNumberOfLines:1];
            [tablecell addSubview:wordLabel];
            [wordLabel release];

            [defLabel setBackgroundColor:[UIColor clearColor]];
            [defLabel setTag:2];
            [defLabel setTextColor:[UIColor colorWithRed:0.28f green:0.28f blue:0.28f alpha:1.0f]];
            [defLabel setLineBreakMode:UILineBreakModeClip];
            [defLabel setNumberOfLines:3];
            [tablecell addSubview:defLabel];
            [defLabel release];
            
        }
        
        for (UIView *nLabel in [tablecell subviews]) {
            
            if (nLabel.tag == 1) {
                [(MyLabel*)nLabel setText:[listData objectAtIndex:row*2]];
            }
            if (nLabel.tag == 2) {
                MyLabel *myDef = (MyLabel*)nLabel ;
                NSString *que = [listData objectAtIndex:1+row*2];
                [myDef setText:que];
                [myDef setBackgroundColor:[UIColor clearColor]];
                int engHight = [@"a" sizeWithFont:myDef.font].height;
                int eLines = [que sizeWithFont:myDef.font constrainedToSize:CGSizeMake(myDef.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
                [myDef setNumberOfLines:eLines];
                if (isiPhone) {
                    [myDef setFrame:CGRectMake(30, 20, 290, eLines * engHight)];
                }else {
                    [myDef setFrame:CGRectMake(100, 30, 568, eLines * engHight)];
                }
                
                [(UILabel*)nLabel setText:[listData objectAtIndex:1+row*2]];
            }
            
        }
        [tablecell setBackgroundColor:[UIColor clearColor]];
        [tablecell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return tablecell;
    } else {
        if (row == [commArray count]/4) {
            static NSString *ThirdLevelCell= @"NewCellTwo";
            UITableViewCell *cellThree = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:ThirdLevelCell];
            if (!cellThree) {
                cellThree = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ThirdLevelCell] autorelease];
            }
            [cellThree setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cellThree setHidden:YES];
            if (nowPage < totalPage) {
                [self catchComments:++nowPage];
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
                if (isiPhone) {
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
                    [(UILabel*)nLabel setText:[commArray objectAtIndex:row*4]];
                }
                if (nLabel.tag == 2) {
                    [(UILabel*)nLabel setText:[commArray objectAtIndex:row*4+3]];
                }
                if (nLabel.tag == 3) {
                    [(UILabel*)nLabel setText:[commArray objectAtIndex:row*4+2]];
                }
            }
            
            [cell.imageView setImageWithURL:[commArray objectAtIndex:row*4+1] placeholderImage:[UIImage imageNamed:@"acquiesceUBBC.png"]];
            
            [cell setBackgroundColor:[UIColor clearColor]];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    
    return nil;
}

#pragma mark -
#pragma mark TableView Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (tableView.tag==1? (isiPhone?100.0f:140.0f):([indexPath row] < [commArray count]/4 ? (isiPhone?kCommTableHeightPh:80.0f) : 1));
}

- (void)tableView:(UITableView *)tableView 
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if ([keyCommFd isFirstResponder]) {
        [self.view endEditing:YES];
//    }
    if (![explainView isHidden]) {
        [explainView setHidden:YES];
        [myHighLightWord setHidden:YES];
    }
}

//#pragma mark - TableViewDelegate and DataSource
//- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
// numberOfRowsInSection:(NSInteger)section {
//    return listData.count/2;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
//    NSInteger row = [indexPath row];
//    UIFont *defFo = [UIFont systemFontOfSize:14];
//    UIFont *wordFo = [UIFont fontWithName:@"AmericanTypewriter-Bold" size:16];
//    static NSString *FirstLevelCell= @"AnswerCell";
//    UITableViewCell *tablecell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:FirstLevelCell];
//    if (!tablecell) {
//        tablecell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FirstLevelCell] autorelease];
//        
//        UILabel *wordLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 290, 20)];
//        [wordLabel setBackgroundColor:[UIColor clearColor]];
//        [wordLabel setFont:wordFo];
//        [wordLabel setTag:1];
//        [wordLabel setTextColor:[UIColor blackColor]];
//        [wordLabel  setLineBreakMode:UILineBreakModeClip];
//        [wordLabel setNumberOfLines:1];
//        [tablecell addSubview:wordLabel];
//        [wordLabel release];
//        
//        UILabel *defLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 290, 40)];
//        [defLabel setBackgroundColor:[UIColor clearColor]];
//        [defLabel setFont:defFo];
//        [defLabel setTag:2];
//        [defLabel setTextColor:[UIColor blackColor]];
//        [defLabel setLineBreakMode:UILineBreakModeClip];
//        [defLabel setNumberOfLines:3];
//        [tablecell addSubview:defLabel];
//        [defLabel release];
//        
//    }
//    
//    for (UIView *nLabel in [tablecell subviews]) {
//        
//        if (nLabel.tag == 1) {
//            [(UILabel*)nLabel setText:[listData objectAtIndex:row*2]];
//        }
//        if (nLabel.tag == 2) {
//            [(UILabel*)nLabel setText:[listData objectAtIndex:1+row*2]];
//        }
//        
//    }
//    [tablecell setBackgroundColor:[UIColor clearColor]];
//    [tablecell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    return tablecell;
//    
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 60.0f;
//}

#pragma mark - HPGrowingTextViewDelegate
//-(void)resignTextView
//{
//	[textView resignFirstResponder];
//}

//Code from Brett Schumann
-(void) keyboardWillShow:(NSNotification *)note{
    // get keyboard size and loctaion
	CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue: &keyboardBounds];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    // Need to translate the bounds to account for rotation.
    keyboardBounds = [self.myScroll convertRect:keyboardBounds toView:nil];
    
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.myScroll.bounds.size.height - (keyboardBounds.size.height + containerFrame.size.height) + (isiPhone? 40.0f: 79.0f);
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
	
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

-(void) keyboardWillHide:(NSNotification *)note{
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
	
	// get a rect for the textView frame
	CGRect containerFrame = containerView.frame;
    containerFrame.origin.y = self.myScroll.bounds.size.height - containerFrame.size.height;
	
	// animations settings
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
//    [UIView setAnimationCurve:[curve intValue]];
    
	// set views with new info
	containerView.frame = containerFrame;
	
	// commit animations
	[UIView commitAnimations];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height
{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = containerView.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	containerView.frame = r;
}


#pragma mark - UITextFieldDelegate
//- (void)textFieldDidBeginEditing:(UITextField *)textField  
//{ //当点触textField内部，开始编辑都会调用这个方法。textField将成为first responder   
//    /*
//    //    NSDictionary *info = [notification userInfo];  
//    //    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;  
//    //    CGFloat distanceToMove = kbSize.height - normalKeyboardHeight; 
//    NSTimeInterval animationDuration = 0.30f;      
//    CGRect frame = myView.frame; 
//    if (isiPhone) {
//        //        frame.origin.y -=216;        
//        //        frame.size. height +=216; 
////        frame.origin.y -=246;        
////        frame.size. height +=246; 
//        frame.origin.y -=124;        
//        frame.size. height +=124; 
//    } else {
//        //        frame.origin.y -=264;        
//        //        frame.size. height +=264; 
//        //        frame.origin.y -=294;        
//        //        frame.size. height +=294; 
//        frame.origin.y -=94;        
//        frame.size. height +=94; 
//    }  
//    myView.tag = 1;
////    self.view.frame = frame;  
//    [UIView beginAnimations:@"ResizeView" context:nil];  
//    [UIView setAnimationDuration:animationDuration];  
//    myView.frame = frame;                  
//    [UIView commitAnimations];    
//     */
////    [inputText resignFirstResponder];
////    [keyCommFd becomeFirstResponder];
//}  
//
- (BOOL)textFieldShouldReturn:(UITextField *)textField   
{//当用户按下ruturn，把焦点从textField移开那么键盘就会消失了  
    //    NSTimeInterval animationDuration = 0.30f;  
    //    CGRect frame = self.view.frame; 
    //    if (isiPhone) {
    //        frame.origin.y +=216;        
    //        frame.size. height -=216; 
    //    } else {
    //        frame.origin.y +=264;        
    //        frame.size. height -=264; 
    //    }     
    //    self.view.frame = frame;  
    //    //self.view移回原位置    
    //    [UIView beginAnimations:@"ResizeView" context:nil];  
    //    [UIView setAnimationDuration:animationDuration];  
    //    self.view.frame = frame;                  
    //    [UIView commitAnimations];  
//    [textField resignFirstResponder]; 
    [self.view endEditing:YES];
    return YES;
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

#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    [HUD release];
	HUD = nil;
}

#pragma mark HPGrowingTextViewDelegate methods
//- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView {
//    [growingTextView setText:@""];
//    return YES;
//}
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

#pragma mark background
//- (void)applicationWillResignActive:(UIApplication *)application
//{
//    /*
//     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
//     */
//    NSLog(@"EnterBackground");
////    [lyricSynTimer invalidate];
////    [sliderTimer invalidate];
//    //    PlayViewController *play = [PlayViewController sharedPlayer];
//    //    [play stopRecord];
////    NSLog(@"appplicationWillResignActive");
//////    [controller stopRecord];
//////    [controller myStopRecord];
////    if ([controller isRecording]) {
//////        controller.recorder->StopRecord();
////        [controller stopRecord];
////    }
////    controller.recorder->StopRecord();
//}

#pragma mark Record action

- (IBAction)recordTouch:(UIButton *)sender
{
    NSLog(@"录音");
    if ([sender.titleLabel.text isEqualToString:@"recording"]) {
        [btn_record setTitle:@"record" forState:UIControlStateNormal];
        
        [self stopRecord];
    } else {
        [btn_record setTitle:@"recording" forState:UIControlStateNormal];
        [self startToRecord];
    }
}

- (void) myStopRecord {
    if (m_isRecording) {
        m_isRecording = NO;
//        [btn_record setImage:[UIImage imageNamed:@"startRecord.png"] forState:UIControlStateNormal];
        if (isiPhone) {
            [btn_record setImage:[UIImage imageNamed:@"startRecordBBC.png"] forState:UIControlStateNormal];
            } else {
            [btn_record setImage:[UIImage imageNamed:@"startRecordBBCP.png"] forState:UIControlStateNormal];
        }
        //    [self changeRecordTimer];
        [self stopRecordTimer];
        dispatch_queue_t stopQueue;
        stopQueue = dispatch_queue_create("stopQueue", NULL);
        dispatch_async(stopQueue, ^(void){
            //run in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [audioRecoder stopRecord];
                [btn_play setEnabled:YES];
                
            });
        });
        dispatch_release(stopQueue);
    }
}

- (void) stopRecord {
    NSLog(@"结束录音");
    if (m_isRecording) {
        m_isRecording = NO;
        //    if (isiPhone) {
        //        [btn_record setImage:[UIImage imageNamed:@"startRecordBBC.png"] forState:UIControlStateNormal];
        //    } else {
        //        [btn_record setImage:[UIImage imageNamed:@"startRecordBBCP.png"] forState:UIControlStateNormal];
        //    }
//        [btn_record setImage:[UIImage imageNamed:@"startRecord.png"] forState:UIControlStateNormal];
        if (isiPhone) {
            [btn_record setImage:[UIImage imageNamed:@"startRecordBBC.png"] forState:UIControlStateNormal];
        } else {
            [btn_record setImage:[UIImage imageNamed:@"startRecordBBCP.png"] forState:UIControlStateNormal];
        }
        [self stopRecordTimer];
        dispatch_queue_t stopQueue;
        stopQueue = dispatch_queue_create("stopQueue", NULL);
        dispatch_async(stopQueue, ^(void){
            //run in main thread
            dispatch_async(dispatch_get_main_queue(), ^{
                [audioRecoder stopRecord];
                [btn_play setEnabled:YES];
            });
        });
        dispatch_release(stopQueue);
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"recordRead"]) {
            [btn_play setTitle:@"stop" forState:UIControlStateNormal];
            [self performSelector:@selector(playRecord) withObject:nil afterDelay:0.5f];
            //        [self playRecord];
        }
        //#if 1
        //        lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
        //                                                         target:self
        //                                                       selector:@selector(lyricSyn)
        //                                                       userInfo:nil
        //                                                        repeats:YES];
        //#endif
        //#if 1
        //        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
        //                                                       target:self
        //                                                     selector:@selector(updateSlider)
        //                                                     userInfo:nil
        //                                                      repeats:YES];
        //#endif
    }
    //    if ([lyricSynTimer isValid]) {
    //
    //    }else {
    //#if 1
    //        lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
    //                                                         target:self
    //                                                       selector:@selector(lyricSyn)
    //                                                       userInfo:nil
    //                                                        repeats:YES];
    //#endif
    //    }
    //
    //    if ([sliderTimer isValid]) {
    //
    //    }else {
    //#if 1
    //        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
    //                                                       target:self
    //                                                     selector:@selector(updateSlider)
    //                                                     userInfo:nil
    //                                                      repeats:YES];
    //#endif
    //    }
    //    AVAudioSession *session = [AVAudioSession sharedInstance];
    //    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //
    //    player = [[AVPlayer alloc] initWithPlayerItem:[AVPlayerItem  playerItemWithAsset:avSet] ];
    
}

//- (void) stopRecordPlay {
//    //    [controller stopPlayQueue];
//}

- (void)startToRecord
{
    NSLog(@"开始录音");
    
    
    if (player) {
        nowTime = [player currentTime];
        [player release];
        player = nil;
    }
    if (wordPlayer) {
        [wordPlayer release];
        wordPlayer = nil;
    }
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    if (m_isRecording == NO)
    {
        if (!notValid) {
            //        if ([lyricSynTimer isValid]) {
            [lyricSynTimer invalidate];
            //        }
            //        if ([sliderTimer isValid]) {
            [sliderTimer invalidate];
            //        }
            notValid = YES;
        }
        
        m_isRecording = YES;
        NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                         [NSString stringWithFormat:@"recordAudio.wav"]];
        //        NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:
        //                                         [NSString stringWithFormat:@"recordAudio.caf"]];
        NSLock* tempLock = [[NSLock alloc]init];
        [tempLock lock];
        if ([[NSFileManager defaultManager] fileExistsAtPath:recordAudioFullPath])
        {
            [[NSFileManager defaultManager] removeItemAtPath:recordAudioFullPath error:nil];
        }
        [tempLock unlock];
        //        afterRecord = YES;
        if (isiPhone) {
            [btn_record setImage:[UIImage imageNamed:@"stopRecordBBC.png"] forState:UIControlStateNormal];
        } else {
            [btn_record setImage:[UIImage imageNamed:@"stopRecordBBCP.png"] forState:UIControlStateNormal];
        }
//        [btn_record setImage:[UIImage imageNamed:@"stopRecord.png"] forState:UIControlStateNormal];
        
        [self changeRecordTimer];
        [audioRecoder startRecord];
        [btn_play setEnabled:NO];
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"recordRead"]) {
            NSTimer *timer = nil;
            timer = [NSTimer scheduledTimerWithTimeInterval:(isiPhone?(recordTime+1):((recordTime+1)>7?(recordTime+1):8)) target:self selector:@selector(stopRecord) userInfo:nil repeats:NO];
        }
        if (!isiPhone) { //ipad版本需要最少录制八秒才可播放
            [btn_record setEnabled:NO];
            NSTimer *timer = nil;
            timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(recordEnable) userInfo:nil repeats:NO];
        }
    }
    
}

- (void)recordEnable
{
    [btn_record setEnabled:YES];
}

- (IBAction)recordPlayTouch:(UIButton *)sender
{
    NSLog(@"播放录音");
    if ([sender.titleLabel.text isEqualToString:@"stop"]) {
        [btn_play setTitle:@"play" forState:UIControlStateNormal];
        [self stopPlayRecord];
    } else {
        [btn_play setTitle:@"stop" forState:UIControlStateNormal];
        [self playRecord];
    }
}

- (void)playRecord
{
    NSLog(@"play");
    NSString *recordAudioFullPath = [kRecorderDirectory stringByAppendingPathComponent:
                                     [NSString stringWithFormat:@"recordAudio.wav"]];
    ////    NSLock* tempLock = [[NSLock alloc]init];
    ////    [tempLock lock];
    if ([[NSFileManager defaultManager] fileExistsAtPath:recordAudioFullPath])
    {
        //        NSLog(@"文件存在");
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (wordPlayer) {
            [wordPlayer release];
            wordPlayer = nil;
        }
        
        wordPlayer = [[AVPlayer alloc] initWithURL:[NSURL fileURLWithPath:[kRecorderDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"recordAudio.wav"]]]];
        [self changePlayRecordTimer];
        [wordPlayer play];
        
        if (isiPhone) {
            [btn_play setImage:[UIImage imageNamed:@"PplayPressedBBC.png"] forState:UIControlStateNormal];
        } else {
            [btn_play setImage:[UIImage imageNamed:@"PplayPressedBBCP.png"] forState:UIControlStateNormal];
        }
//        [btn_play setImage:[UIImage imageNamed:@"stopPlayRecord.png"] forState:UIControlStateNormal];
        
    }else {
        //        NSLog(@"文件不存在");
    }
    //    [tempLock unlock];
    //    player = [AVPlayer playerWithURL:[NSURL URLWithString:[kRecorderDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"recordAudio.aac"]]]];
    
}

- (void)stopPlayRecord
{
    if (isiPhone) {
        [btn_play setImage:[UIImage imageNamed:@"playingBBC.png"] forState:UIControlStateNormal];
    } else {
        [btn_play setImage:[UIImage imageNamed:@"playingBBCP.png"] forState:UIControlStateNormal];
    }
//    [btn_play setImage:[UIImage imageNamed:@"playRecord.png"] forState:UIControlStateNormal];

    [self stopPlayRecordTimer];
    [wordPlayer pause];
    //    if ([lyricSynTimer isValid]) {
    //
    //    }else {
    //#if 1
    //        lyricSynTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
    //                                                         target:self
    //                                                       selector:@selector(lyricSyn)
    //                                                       userInfo:nil
    //                                                        repeats:YES];
    //#endif
    //    }
    ////
    //    if ([sliderTimer isValid]) {
    //
    //    }else {
    //#if 1
    //        sliderTimer = [NSTimer scheduledTimerWithTimeInterval:0.2
    //                                                       target:self
    //                                                     selector:@selector(updateSlider)
    //                                                     userInfo:nil
    //                                                      repeats:YES];
    //#endif
    //    }
}

-(void)changeRecordTimer
{
    //    //时间间隔
    //    NSTimeInterval timeInterval =1.0 ;
    //定时器
    if ([recordTimer isValid]) {
        [recordTimer invalidate];
        //        recordTimer = nil;
    } else {
        [self stopPlayRecord];
        recordSeconds = 0 ;
        [recordLabel setText:[timeSwitchClass timeToSwitchAdvance:0]];
        recordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(handleRecordTimer)
                                                     userInfo:nil
                                                      repeats:YES];
    }
}

-(void)stopRecordTimer
{
    //    //时间间隔
    //    NSTimeInterval timeInterval =1.0 ;
    //定时器
    if ([recordTimer isValid]) {
        [recordTimer invalidate];
        recordTimer = nil;
    }
}

-(void) handleRecordTimer {
    recordSeconds++;
    [recordLabel setText:[timeSwitchClass timeToSwitchAdvance:recordSeconds]];
}

-(void)changePlayRecordTimer
{
    //    //时间间隔
    //    NSTimeInterval timeInterval =1.0 ;
    //定时器
    if ([playRecordTimer isValid]) {
        [playRecordTimer invalidate];
        playRecordTimer = nil;
        [recordLabel setText:[timeSwitchClass timeToSwitchAdvance:0]];
    }
    nowRecordSeconds = recordSeconds;
    [recordLabel setText:[timeSwitchClass timeToSwitchAdvance:nowRecordSeconds]];
    playRecordTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                       target:self
                                                     selector:@selector(handlePlayRecordTimer)
                                                     userInfo:nil
                                                      repeats:YES];
}

-(void)stopPlayRecordTimer
{
    //    //时间间隔
    //    NSTimeInterval timeInterval =1.0 ;
    //定时器
    if ([playRecordTimer isValid]) {
        [playRecordTimer invalidate];
        playRecordTimer = nil;
        [recordLabel setText:[timeSwitchClass timeToSwitchAdvance:0]];
    }
}

-(void) handlePlayRecordTimer {
    
    nowRecordSeconds--;
    //    NSLog(@"%d", recordSeconds);
    [recordLabel setText:[timeSwitchClass timeToSwitchAdvance:nowRecordSeconds]];
    if (nowRecordSeconds < 1) {
        if (isiPhone) {
            [btn_play setImage:[UIImage imageNamed:@"playingBBC.png"] forState:UIControlStateNormal];
        } else {
            [btn_play setImage:[UIImage imageNamed:@"playingBBCP.png"] forState:UIControlStateNormal];
        }
//        [btn_play setImage:[UIImage imageNamed:@"playRecord.png"] forState:UIControlStateNormal];
        if ([playRecordTimer isValid]) {
            [playRecordTimer invalidate];
            playRecordTimer = nil;
            [recordLabel setText:[timeSwitchClass timeToSwitchAdvance:0]];
        }
    }
}

@end
