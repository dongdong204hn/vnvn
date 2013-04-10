//
//  MyUITabBarController.m
//  AEHTS
//
//  Created by zhao song on 12-11-21.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "MyUITabBarController.h"

@interface MyUITabBarController ()

@end

@implementation MyUITabBarController

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
//    NSLog(@"检测tabbar");
//    [self.navigationController.view setNeedsLayout];//关键函数 保证界面的整齐
    return YES;
}

//这些方法父类别定义 会影响子类方法调用
//- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    kLandscapeTest;
//}
//
- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
//    return UIInterfaceOrientationMaskPortrait;
}
//
- (BOOL)shouldAutorotate {
//    NSLog(@"应该转？");
    return kIsAutorotate;//支持转屏
}

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//	// Do any additional setup after loading the view.
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}


@end
