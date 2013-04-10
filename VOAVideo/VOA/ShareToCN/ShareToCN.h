//
//  ShareToCN.h
//  ShareToCN
//
//  Created by Haoxiang on 7/6/11.
//  Copyright 2011 mr.pppoe All rights reserved.
//

#import <UIKit/UIKit.h>
//< Currently, We only Support Sina Weibo
//#define kShareToCNKey       @"4166745698"
//#define kShareToCNSecret    @"5b2faa4ceac4a0e87fc035402edd6762"
//#define kShareToCNKey       @"3389098703"
//#define kShareToCNSecret    @"006e2b5940d9134d76cd97756f8dfdd4"

//#define kShareToCNKey       @"1205219068"
//#define kShareToCNSecret    @"e53981d92d86cc6ce2e52e5acc338faa"

//#define kShareToCNKey       @"1567257548"
//#define kShareToCNSecret    @"5284c8c3e03ad4b2e88eb550f91dd6da"

#define kShareToCNKey       @"3642812657"
#define kShareToCNSecret    @"6130491311e5ee70cafc1fc466ae65d6"

//1567257548 5284c8c3e03ad4b2e88eb550f91dd6da
@class WBEngine;
@class WBAuthorize;

@protocol ShareToCNDelegate 

- (void)shareFailedWithError:(NSError *)error;
- (void)shareSucceed;

@end

@interface ShareToCN : NSObject {

    WBEngine *_engine;
    WBAuthorize *_autho;
    UIWebView *_webView;
    UIView *_containerView;
    
    NSString *_text;
    UIImage *_image;
    
    id<ShareToCNDelegate> _delegate; 
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, assign) id<ShareToCNDelegate> delegate;
@property (nonatomic, assign) WBEngine *_engine;
@property (nonatomic, assign) WBAuthorize *_autho;

+ (void)shareText:(NSString *)text;
+ (void)shareText:(NSString *)text WithImage:(UIImage *)image;

+ (void)shareText:(NSString *)text withDelegate:(id<ShareToCNDelegate>)delegate;
+ (void)shareText:(NSString *)text WithImage:(UIImage *)image withDelegate:(id<ShareToCNDelegate>)delegate;

+ (void)logoutSn;
@end
