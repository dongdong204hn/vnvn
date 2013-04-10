//
//  AppSettingsAppDelegate.m
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "AppSettingsAppDelegate.h"
#import "FlurryAnalytics.h"

@implementation AppSettingsAppDelegate

@synthesize windowOne;
@synthesize windowTwo;
@synthesize rootControllerOne;
@synthesize rootControllerTwo;
@synthesize myView;
@synthesize scrollView;
@synthesize pageControl;

- (void)changePage:(UIPageControl *)sender
{
    int page = pageControl.currentPage;
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:YES];  
}


void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}

/**
 *  注册推送成功时调用
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    NSString * tokenAsString = [[[deviceToken description] 
                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] 
                                stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:tokenAsString forKey:@"DeviceTokenStringBBCF"];
    [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"pushToken"];
    [self pushToken:tokenAsString];
}

/**
 *  注册推送失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
     NSLog(@"error:regist failture");
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置Flurry
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    [FlurryAnalytics startSession:@"VWRHC5N7KWK2J4CG8X6H"];
//    [[NSUserDefaults standardUserDefaults] setFloat:1.0f forKey:@"appVersion"];
//    float appVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appVersionBBCF"] floatValue];
//    NSLog(@"appVersion:%f",appVersion);
//    if (appVersion < 1.1f) { //新版本的一些新设置等
//        [VOAView updateData:[VOAView findLastId]];
//        [[NSUserDefaults standardUserDefaults] setFloat:1.1f forKey:@"appVersionBBCF"];
//    }
    //注册消息推送
//    if(!application.enabledRemoteNotificationTypes){ 
////        NSLog(@"注册推送"); 
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge)]; 
//    } else {
////        NSLog(@"已注册推送");
//    }
    
//已添加推送的机器可以获取token
//    NSString *deviceTokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTokenStringVOAC"];
//    NSLog(@"deviceToken:%@",deviceTokenStr);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0]; //badgeNumber清零
    
//回到后台前可以利用此方法进行一些操作
//    [[NSNotificationCenter defaultCenter]        
//     addObserver:self        
//     selector:@selector(applicationWillResignActive:)        
//     name:UIApplicationWillResignActiveNotification
//     object:nil];
    
    kNetTest;//测试网络连接
    kLandscapeTest;//测试屏幕旋转方向
    [VOAView clearAllDownload];//取消所有正在下载的状态
    
    /* 显示状态栏并设为黑色*/
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    if ([Constants isPad]) {
//        NSLog(@"ipad");
//        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pbg-ipad.png"]];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PbgBBCP.png"]];
        img.frame = self.windowTwo.frame;
        self.rootControllerTwo.wantsFullScreenLayout = YES;
        [self.windowTwo addSubview:img];
        [img release], img = nil;
//        [self.windowTwo addSubview:rootControllerTwo.view];
        self.windowTwo.rootViewController = rootControllerTwo;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] == nil) {//初次安装时进行的操作和展示
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"firstLaunch"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"synContext"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"keepScreenLight"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:2] forKey:@"mulValueColor"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:20] forKey:@"mulValueFont"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hightlightLoc"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"shakeCtrlPlay"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"recordRead"];
            [[NSUserDefaults standardUserDefaults] setFloat:1.2f forKey:@"appVersion"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"playMode"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"autoDownload"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"autoPlay"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"catchPause"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:kBePro];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"haveScore"];
            
            //展示帮助界面
            numOfPages = 5;
            scrollView = [[UIScrollView alloc] initWithFrame:self.windowTwo.bounds];
            scrollView.pagingEnabled = YES;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.scrollEnabled = YES;
            scrollView.clipsToBounds = YES;
            scrollView.delegate = self;
            pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(334, 960, 100, 40)];
            pageControl.numberOfPages = 5;
            [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
            for (NSUInteger i = 1; i <= numOfPages; i++)
            {
                NSString *imageName = [NSString stringWithFormat:@"help%d@2x.png", i];
                UIView * pageView = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * (i-1), 0, scrollView.frame.size.width, scrollView.frame.size.height)];
                UIImage *image = [UIImage imageNamed:imageName];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
                imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
                pageView.tag = i;	// tag our images for later use when we place them in serial fashion
                [pageView addSubview:imageView];
                [scrollView addSubview:pageView];
                [imageView release],imageView = nil;
                [pageView release], pageView = nil;
            }
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * numOfPages, scrollView.frame.size.height)];
            myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.windowTwo.frame.size.width, self.windowTwo.frame.size.height)];
            [myView setBackgroundColor:[UIColor blackColor]];
            [myView addSubview:scrollView];
            [scrollView release];
            [myView addSubview:pageControl];
            [pageControl release];
            [self.windowTwo addSubview:myView];
        } else {
            if(!application.enabledRemoteNotificationTypes){
                //                NSLog(@"注册推送");
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
            } else {
                //                NSLog(@"已注册推送");
            }
            float appVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"] floatValue];
            if (appVersion < 1.2f) { //新版本的一些新设置等
                [[NSUserDefaults standardUserDefaults] setFloat:1.2f forKey:@"appVersion"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"haveScore"];
            }
            
            int lunchTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"firstLaunch"];
            if (lunchTime < 5) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:lunchTime+1] forKey:@"firstLaunch"];
                //                NSLog(@"lunchTime:%i", lunchTime+1);
            } else {
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"haveScore"]) {
                    UIAlertView *scoreAlert = [[UIAlertView alloc] initWithTitle:nil message:kAppOne delegate:self cancelButtonTitle:kAppThree otherButtonTitles:kAppTwo,nil];
                    [scoreAlert setTag:1];
                    [scoreAlert show];
                }
            }
        }
        
        [self.windowTwo makeKeyAndVisible];//最后两句基本都一样
    }else {
//        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Pbg.png"]];
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PbgBBC.png"]];
        img.frame = self.windowOne.frame;
        self.rootControllerOne.wantsFullScreenLayout = YES;
        [self.windowOne addSubview:img];
        [img release], img = nil;
//        [self.windowOne addSubview:rootControllerOne.view];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) self.windowOne.rootViewController = rootControllerOne;
//        else [self.windowOne addSubview:rootControllerOne.view];
        self.windowOne.rootViewController = rootControllerOne;
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"] == nil) {
            //        NSLog(@"first");
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"firstLaunch"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"synContext"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"keepScreenLight"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:2] forKey:@"mulValueColor"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:15] forKey:@"mulValueFont"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"hightlightLoc"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"shakeCtrlPlay"];
//            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"recordRead"];
            [[NSUserDefaults standardUserDefaults] setFloat:1.2f forKey:@"appVersion"];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"playMode"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"autoDownload"];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"autoPlay"];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"catchPause"];
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:kBePro];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"haveScore"];
            numOfPages = 5;
            
            //        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height)];
            scrollView = [[UIScrollView alloc] initWithFrame:self.windowOne.bounds];
            scrollView.pagingEnabled = YES;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.scrollEnabled = YES;
            scrollView.clipsToBounds = YES;
            scrollView.delegate = self;
            
            pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(110, 450, 100, 40)];
            pageControl.numberOfPages = 5;
            [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
            
            for (NSUInteger i = 1; i <= numOfPages; i++)
            {
                NSString *imageName = [NSString stringWithFormat:@"help%d.png", i];
                UIView * pageView = [[UIView alloc] initWithFrame:CGRectMake(scrollView.frame.size.width * (i-1), 0, scrollView.frame.size.width, scrollView.frame.size.height)];
                UIImage *image = [UIImage imageNamed:imageName];
                UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
                // setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
                imageView.frame = CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height);
                pageView.tag = i;	// tag our images for later use when we place them in serial fashion
                [pageView addSubview:imageView];
                [scrollView addSubview:pageView];
                [imageView release],imageView = nil;
                [pageView release], pageView = nil;
            }
            [scrollView setContentSize:CGSizeMake(scrollView.frame.size.width * numOfPages, scrollView.frame.size.height)];
            
            myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.windowOne.frame.size.width, self.windowOne.frame.size.height)];
            [myView setBackgroundColor:[UIColor blackColor]];
            [myView addSubview:scrollView];
            [scrollView release];
            [myView addSubview:pageControl];
            [pageControl release];
//            self.windowOne.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.windowOne addSubview:myView];
        } else {
            if(!application.enabledRemoteNotificationTypes){
                //                NSLog(@"注册推送");
                [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeBadge)];
            } else {
                //                NSLog(@"已注册推送");
            }
            float appVersion = [[[NSUserDefaults standardUserDefaults] objectForKey:@"appVersion"] floatValue];
            if (appVersion < 1.2f) { //新版本的一些新设置等
                [[NSUserDefaults standardUserDefaults] setFloat:1.2f forKey:@"appVersion"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"haveScore"];
            }
            int lunchTime = [[NSUserDefaults standardUserDefaults] integerForKey:@"firstLaunch"];
            if (lunchTime < 5) {
                [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:lunchTime+1] forKey:@"firstLaunch"];
                //                NSLog(@"lunchTime:%i", lunchTime+1);
            } else {
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"haveScore"]) {
                    UIAlertView *scoreAlert = [[UIAlertView alloc] initWithTitle:nil message:kAppOne delegate:self cancelButtonTitle:kAppThree otherButtonTitles:kAppTwo,nil];
                    [scoreAlert setTag:1];
                    [scoreAlert show];
                }
            }
        }
        
        [self.windowOne makeKeyAndVisible];//最后两句基本都一样
    }
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"pushToken"]){
        NSString *deviceTokenStr = [[NSUserDefaults standardUserDefaults] objectForKey:@"DeviceTokenStringBBCF"];
        [self pushToken:deviceTokenStr];
    }
    
    return YES;
}

//- (NSUInteger)supportedInterfaceOrientations{
//    //    return UIInterfaceOrientationMaskAllButUpsideDown;
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotate {
//    return NO;//支持转屏
//}

/**
 *  程序进入后台之前调用
 */
- (void)applicationWillResignActive:(UIApplication *)application
{
//     NSLog(@"EnterBackground");
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];//取消屏幕常亮
//    PlayViewController *play = [PlayViewController sharedPlayer];
//    //    [play stopRecord];
//    [play.controller myStopRecord];
//    [play.controller ];
}

/**
 *  程序进入后台时调用
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
//    NSLog(@"EnterBackground");
//    PlayViewController *play = [PlayViewController sharedPlayer];
////    [play stopRecord];
//    [play.controller stopRecord];
//    [play stopRecordPlay];
//    NSDate *date = [NSDate date];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *comps;
//    
//    // 年月日获得
//    comps = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) 
//                        fromDate:date];
//    NSInteger year = [comps year];
//    NSInteger month = [comps month];
//    NSInteger day = [comps day];
//    NSLog(@"year: %d month: %d, day: %d", year, month, day);
//    NSLog(@"date:%@",[NSString stringWithFormat:@"%d-%d-%d",year,month,day]);
    
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:3];
}

/**
 *  程序进入后台之前调用
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

/**
 *  程序回到前台时调用
 */
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    kNetTest;
//    NSLog(@"applicationDidBecomeActive");
//    AudioSessionSetActive(true);
}

/**
 *  程序退出时调用
 */
- (void)applicationWillTerminate:(UIApplication *)application
{
//    [self disconnect];
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
//    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}


- (void)dealloc {
    [myView release], myView = nil;
    if ([Constants isPad]) {
        [rootControllerTwo release];
        [windowTwo release];
    }else {
        [rootControllerOne release];
        [windowOne release];
    }
    [super dealloc];
}

#pragma mark - AlertDelegate
- (void)modalView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {//点击确定下载为0，取消为1
        //        if (alertView.tag == 1) {
        //        }
        //        else if (alertView.tag == 2){
        //        }
        //        else if (alertView.tag == 3)
        //        {
        //            LogController *myLog = [[LogController alloc]init];
        //            [self.navigationController pushViewController:myLog animated:YES];
        //            [myLog release], myLog = nil;
        //        }
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"firstLaunch"];
    } else if (buttonIndex == 1) {
        if (alertView.tag == 1){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"haveScore"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=588949119"]];
        }
    }
    [alertView release];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    pageControl.currentPage = page;
    if (scrollView.contentOffset.x>(pageWidth*(numOfPages-0.9))) {
        [myView removeFromSuperview];
    }
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

#pragma mark - Http connect
- (void)pushToken:(NSString *) token
{
    NSString *url = [NSString stringWithFormat:@"http://apps.iyuba.com/voa/phoneToken.jsp?token=%@&appID=588949119",token];
//    NSLog(@"token:%@", token);
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"token"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    NSData *myData = [request responseData];
    NSString *returnData = [[NSString alloc] initWithData:myData encoding:NSUTF8StringEncoding];
    for (NSString *matchOne in [returnData componentsMatchedByRegex:@"\\d"]) {
//        NSLog(@"request:%i",[matchOne integerValue]);
        if ([matchOne integerValue] > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"pushToken"];
//            NSLog(@"da");
        } else {
            [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"pushToken"];
//            NSLog(@"xiao");
        }
    }
    [returnData release],returnData = nil;
}

@end
