//
//  RegistViewController.h
//  VOA
//
//  Created by song zhao on 12-3-14.
//  Copyright (c) 2012年 buaa. All rights reserved.
//
#import "ASIFormDataRequest.h"
#import "Reachability.h"//isExistenceNetwork
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "MyUser.h"
#import "RegexKitLite.h"
#import <QuartzCore/QuartzCore.h>

@interface RegistViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate,UITableViewDataSource>
{
    UITableView *logTable;
    UILabel *userL;
    UILabel *codeL;
    UILabel *codeAgainL;
    UILabel *mailL;
    UITextField *userF;
    UITextField *codeF;
    UITextField *codeAgainF;
    UITextField *mailF;
    UIButton *registBtn;
    UIButton *returnBtn;
    UIAlertView *alert;
    BOOL isiPhone;
}

@property (nonatomic, retain) UITableView *logTable;
@property (nonatomic, retain) UILabel *userL;
@property (nonatomic, retain) UILabel *codeL;
@property (nonatomic, retain) UILabel *codeAgainL;
@property (nonatomic, retain) UILabel *mailL;
@property (nonatomic, retain) UITextField *userF;
@property (nonatomic, retain) UITextField *codeF;
@property (nonatomic, retain) UITextField *codeAgainF;
@property (nonatomic, retain) UITextField *mailF;
@property (nonatomic, retain) UIButton *registBtn;
@property (nonatomic, retain) UIButton *returnBtn;
@property (nonatomic, retain) UIAlertView *alert;
@property (nonatomic) BOOL isiPhone;

- (void) goBack:(UIButton *)sender;
- (void)catchRegists;

@end
