//
//  NetTest.m
//  AEHTS
//
//  Created by zhao song on 12-11-30.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "NetTest.h"

@implementation NetTest
@synthesize isExisitNet = _isExisitNet;
@synthesize shouldAutorotate = _shouldAutorotate;
@synthesize nowOrientation = _nowOrientation;
@synthesize isExisitPLayer = _isExisitPLayer;

#pragma mark - static method
+ (NetTest *)sharedNet
{
    static NetTest *sharedNet;
    
    @synchronized(self)
    {
        if (!sharedNet){
            sharedNet = [[NetTest alloc] init];
            sharedNet.isExisitNet = YES;
            sharedNet.shouldAutorotate = YES;
            sharedNet.isExisitPLayer = NO;
        }
        else{
        }
        return sharedNet;
    }
}

#pragma mark - Orientation Method
- (BOOL)isAutorotate {
    return _shouldAutorotate;
}
- (void)autorotateEnable {
    _shouldAutorotate = YES;
}

- (void)autorotateDisable {
    _shouldAutorotate = NO;
}

- (BOOL)isOrientationLandscapeTest {
//    NSLog(@"检查方向");
    _nowOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (_nowOrientation == UIDeviceOrientationLandscapeLeft || _nowOrientation == UIDeviceOrientationLandscapeRight) {
//        NSLog(@"横向");
        return YES;
    }
//    UIDevice *device = [UIDevice currentDevice];
//    _nowOrientation = device.orientation;
//    if (device.orientation == UIDeviceOrientationLandscapeLeft || device.orientation == UIDeviceOrientationLandscapeRight) {
//        NSLog(@"横向");
//        return YES;
//    }
    return NO;
}

- (BOOL)isOrientationLandscape {
    if (_nowOrientation == UIDeviceOrientationLandscapeLeft || _nowOrientation == UIDeviceOrientationLandscapeRight)
        return YES;
    return NO;
}

+ (BOOL)isLandscape : (UIInterfaceOrientation)interfaceOrientation {
    if (interfaceOrientation == UIDeviceOrientationLandscapeLeft || interfaceOrientation == UIDeviceOrientationLandscapeRight)
        return YES;
    return NO;
}


#pragma mark - Net Method
- (void)netEnable
{
    _isExisitNet = YES;
}

- (void)netDisable
{
    _isExisitNet = NO;
}

#pragma mark - ASI Delegate
- (void)catchNet
{
    NSString *url = @"http://www.apple.com";
    ASIHTTPRequest * request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"catchnet"];
    [request startAsynchronous];
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request.username isEqualToString:@"catchnet"]) {
//        NSLog(@"专有网络");
        _isExisitNet = YES;
        return;
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"catchnet"]) {
//        NSLog(@"专无网络");
        _isExisitNet = NO;
        return;
    }
}

@end
