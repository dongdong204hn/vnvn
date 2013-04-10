//
//  MyUIViewController.m
//  AEHTS
//
//  Created by zhao song on 12-11-21.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "MyUIViewController.h"

@interface MyUIViewController ()

@end

@implementation MyUIViewController

- (NSUInteger)supportedInterfaceOrientations{
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate {
    return NO;//支持转屏
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
