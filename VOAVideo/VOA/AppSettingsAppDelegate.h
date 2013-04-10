//
//  AppSettingsAppDelegate.h
//  VOA
//
//  Created by song zhao on 12-2-2.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "RegexKitLite.h"
#import "VOAView.h"

@interface AppSettingsAppDelegate : UIResponder <UIApplicationDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate> 
{
    UIView * myView;
    
    UIWindow *windowOne, *windowTwo;
    
    UITabBarController  *rootControllerOne, *rootControllerTwo;
    
    UIScrollView * scrollView;
    
    UIPageControl * pageControl;
    
    NSUInteger numOfPages;
}

@property (retain, nonatomic) IBOutlet UIWindow *windowOne;
@property (retain, nonatomic) IBOutlet UIWindow *windowTwo;
@property (retain, nonatomic) IBOutlet UITabBarController  *rootControllerOne;
@property (retain, nonatomic) IBOutlet UITabBarController  *rootControllerTwo;
@property (retain, nonatomic) UIView *myView;
@property (retain, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIPageControl * pageControl;

/**
 *  设置Flurry需要实现的方法
 */
void uncaughtExceptionHandler(NSException *exception);

@end 
