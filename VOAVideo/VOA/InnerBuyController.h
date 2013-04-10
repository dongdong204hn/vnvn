//
//  InnerBuyController.h
//  BBC
//
//  Created by song zhao on 12-9-6.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h> //操作layer
#import "SVStoreKit.h"
#import "MBProgressHUD.h"



@interface InnerBuyController : UIViewController <SVStoreKitDelegate> {
    BOOL isIphone;
    UILabel *intro;
    UIButton *buyBtn;
    UIButton *recoverBtn;
    SVStoreKit *storeKit;
    MBProgressHUD *HUD;
}

@property (nonatomic) BOOL isIphone;
@property (nonatomic, retain) UILabel *intro;
@property (nonatomic, retain) UIButton *buyBtn;
@property (nonatomic, retain) UIButton *recoverBtn;
@property (nonatomic, retain) SVStoreKit *storeKit;
@property (nonatomic, retain) MBProgressHUD *HUD;

@end
