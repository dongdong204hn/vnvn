//
//  InformationView.h
//  FinalTest
//
//  Created by Seven Lee on 12-1-12.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "InforController.h"
#import "Reachability.h"//isExistenceNetwork
#import "Constants.h"
#import <QuartzCore/QuartzCore.h> //操作layer

@interface InformationView : UIViewController{
    BOOL isiPhone;
    UIButton *urlBtn;
}

@property (nonatomic) BOOL isiPhone;
@property (nonatomic, retain) IBOutlet UIButton *urlBtn;

- (IBAction)goUrl:(id)sender;
- (BOOL) isExistenceNetwork:(NSInteger)choose;

@end
