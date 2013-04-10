//
//  LogViewController.m
//  VOA
//
//  Created by song zhao on 12-3-14.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "LogController.h"
#import "Constants.h"

@implementation LogController
@synthesize logTable;
@synthesize registBtnTwo;
@synthesize nowUser;
@synthesize logBtnTwo;
@synthesize logOutBtn;
@synthesize remCode;
@synthesize remCodeL;
@synthesize afterLog;
@synthesize yubNumBtn;
@synthesize yubBtn;
@synthesize userF;
@synthesize userL;
@synthesize codeF;
@synthesize codeL;
@synthesize isiPhone;
//@synthesize isExisitNet;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    isiPhone = ![Constants isPad];
	if (isiPhone) {
        self = [super initWithNibName:@"LogController" bundle:nibBundleOrNil];
	}else {
        self = [super initWithNibName:@"LogController-iPad" bundle:nibBundleOrNil];
    }
    if (self) {
        //        NSLog(@"%@",nibNameOrNil);
        
    }
    return self;
}

- (id)init
{
    return [self initWithNibName:@"LogController" bundle:nil];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

//- (BOOL)isPad {
//	BOOL isPad = NO;
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
//	isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//#endif
//	return isPad;
//}


#pragma mark - My action
- (IBAction) doRem:(UIButton *)sender{
    NSInteger rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"remCode"] integerValue];
    if (rem==1) {
        [remCode setImage:[UIImage imageNamed:@"rememCodeNot.png"] forState:0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:@"remCode"];
    }else
    {
        [remCode setImage:[UIImage imageNamed:@"rememCode.png"] forState:0];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:1] forKey:@"remCode"];
    }
}

- (IBAction) doRegist:(UIButton *)sender
{
    if ([self isExistenceNetwork:1]) {
        RegistViewController *myRegist = [[RegistViewController  alloc]init];
        [self presentModalViewController:myRegist animated:YES];
        [myRegist release], myRegist = nil;
    }
}

- (IBAction) doCatchYub:(UIButton *)sender {
    int nowUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
//    NSLog(@"yub:%d",nowUserID);
    if ([self isExistenceNetwork:1]&& (nowUserID > 0)) {
        [self catchYub:[NSString stringWithFormat:@"%d",nowUserID]];
    }
}

- (IBAction) doLog:(UIButton *)sender
{
    NSString *code =[MyUser findCodeByName:[userF text]];
    if ([code isEqualToString:[codeF text]]) {
//        NSLog(@"本地已有");
        int userId = [MyUser findIdByName:[userF text]];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userId] forKey:@"nowUser"];
        [self catchYub:[NSString stringWithFormat:@"%d",userId]];
        [userF resignFirstResponder];
        [codeF resignFirstResponder];
        [nowUser setText:[NSString stringWithFormat:@"%@%@",kLogOne,userF.text]];
        [nowUser setHidden:NO];
        [afterLog setHidden:NO];
        [logOutBtn setHidden:NO];
        [yubBtn setHidden:NO];
        [yubNumBtn setHidden:NO];
        [logBtnTwo setHidden:YES];
        [logTable setHidden:YES];
        [remCodeL setHidden:YES];
        [remCode setHidden:YES];
        
        NSInteger rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"remCode"] integerValue];
        if (rem==1) {
            [MyUser acceptRem:userF.text];
        }else
        {
            [MyUser cancelRem:userF.text];
        }
        
        alert = [[UIAlertView alloc] initWithTitle:kLogTwo message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
        
        [alert setBackgroundColor:[UIColor clearColor]];
        
        [alert setContentMode:UIViewContentModeScaleAspectFit];
        
        [alert show];
        
        UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        active.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height-40);
        
        [alert addSubview:active];
        
        [active startAnimating];
        
        [active release];
        
        NSTimer *timer = nil;
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(c) userInfo:nil repeats:NO];
    }else
    {
//        NSLog(@"联网登录");
        if (userF.text.length > 0 && codeF.text.length > 0 && userF.textColor == [UIColor blackColor] && codeF.textColor == [UIColor blackColor]) {
            [userF resignFirstResponder];
            [codeF resignFirstResponder];
            [self catchLogs];
        }
    }
    
}

- (IBAction) doLogout:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:@"nowUser"];
    [nowUser setHidden:YES];
    [afterLog setHidden:YES];
    [logOutBtn setHidden:YES];
    [yubBtn setHidden:YES];
    [yubNumBtn setHidden:YES];
    [logBtnTwo setHidden:NO];
    [logTable setHidden:NO];
    [remCodeL setHidden:NO];
    [remCode setHidden:NO];
    [userF setText:@""];
    [codeF setText:@""];
}


#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated
{
//    [self catchNetA];
    kNetTest;
    self.navigationController.navigationBarHidden = NO;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:@"remCode"];
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
//    NSLog(@"生词本添加用户：%d",userId);
    if (userId>0) {
        [nowUser setHidden:NO];
        [afterLog setHidden:NO];
        [nowUser setText:[NSString stringWithFormat:@"%@%@",kLogOne,[MyUser findNameById:userId]]];
        [logOutBtn setHidden:NO];
        [yubNumBtn setHidden:NO];
        [yubBtn  setHidden:NO];
        [logBtnTwo setHidden:YES];
        [logTable setHidden:YES];
        [remCodeL setHidden:YES];
        [remCode setHidden:YES];
    }
    else
    {
        [nowUser setHidden:YES];
        [afterLog setHidden:YES];
        [yubNumBtn setHidden:YES];
        [yubBtn  setHidden:YES];
        [logBtnTwo setHidden:NO];
        [logTable setHidden:NO];
        [remCodeL setHidden:NO];
        [remCode setHidden:NO];
        [logOutBtn setHidden:YES];
    }
    int nowUserID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
//    NSLog(@"yub:%d",nowUserID);
    if (nowUserID > 0) {
        [self catchYub:[NSString stringWithFormat:@"%d",nowUserID]];
    }
}

- (void)viewDidLoad
{
    [self.navigationItem setTitle:kLogFour];
//    isExisitNet = NO;
    kNetTest;
    [[logBtnTwo layer] setCornerRadius:8.0f];
    [[logBtnTwo layer] setMasksToBounds:YES];
    [[logOutBtn layer] setCornerRadius:8.0f];
    [[logOutBtn layer] setMasksToBounds:YES];
    [[registBtnTwo layer] setCornerRadius:8.0f];
    [[registBtnTwo layer] setMasksToBounds:YES];
//    [[logBtnTwo layer] setBorderWidth:1.0];
//    [[logBtnTwo layer] setBorderColor:[[UIColor colorWithRed:0.427 green:0.753 blue:0.172 alpha:1.0] CGColor]];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.logTable = nil;
    self.registBtnTwo = nil;
    self.logBtnTwo = nil;
    self.logOutBtn = nil;
    self.remCode = nil;
    self.remCodeL = nil;
    self.afterLog = nil;
    self.yubBtn = nil;
    self.yubNumBtn = nil;
}

- (void) dealloc
{
    [self.logTable release], logTable = nil;
    [self.registBtnTwo release], registBtnTwo  = nil;
    [self.logBtnTwo release], logBtnTwo  = nil;
    [self.logOutBtn release], logOutBtn  = nil;
    [self.remCode release], remCode  = nil;
    [self.remCodeL release], remCodeL  = nil;
    [self.afterLog release], afterLog  = nil;
    [self.yubBtn release], yubBtn  = nil;
    [self.yubNumBtn release], yubNumBtn  = nil;
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    //    return (interfaceOrientation == UIInterfaceOrientationPortrait);
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    kLandscapeTest;
}



#pragma mark -
#pragma mark Table Data Source Methods

- (NSInteger)tableView:(UITableView *)tableView //明确cell数目
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *identifier = [NSString stringWithFormat:@"LogCell%d",[indexPath row]];
    cell = [logTable dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
//        cell = [[UITableViewCell alloc]init];
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
//        UIImageView *backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
//        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 300, 1)];
        
        switch ([indexPath row]) {
            case 0:
//                [backgroundView setImage:[UIImage imageNamed:@"cellBgOne.png"]];
//                [cell addSubview:backgroundView];
//                [cell sendSubviewToBack:backgroundView];
//                [backgroundView release];
//                [lineView setImage:[UIImage imageNamed:@"lineSep.png"]];
//                [cell addSubview:lineView];
//                [cell sendSubviewToBack:lineView];
//                [lineView release];
                
                userL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 30)];
//                [userL setFont:[UIFont fontWithName:@"Arial" size:18]];
                [userL setFont:[UIFont boldSystemFontOfSize:18]];
                [userL setBackgroundColor:[UIColor clearColor]];
                [userL setTextAlignment:UITextAlignmentLeft];
                [userL setText:kLogFive];
                [cell addSubview:userL];
                [userL release];
                
                userF = [[UITextField alloc]initWithFrame:CGRectMake(80, 8, 220, 30)];
//                [userF setFont:[UIFont fontWithName:@"Arial" size:18]];
                [userF setFont:[UIFont systemFontOfSize:16]];
                [userF setBackgroundColor:[UIColor clearColor]];
                [userF setTextAlignment:UITextAlignmentLeft];
                [userF setPlaceholder:kLogSix];
                [codeF setTag:0];
                userF.autocapitalizationType = UITextAutocapitalizationTypeNone;
                [userF setDelegate:self];
                [cell addSubview:userF];
                [userF release];
                break;
            case 1: 
//                [backgroundView setImage:[UIImage imageNamed:@"cellBgLast.png"]];
//                [cell addSubview:backgroundView];
//                [cell sendSubviewToBack:backgroundView];
                codeL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 60, 30)];
//                [codeL setFont:[UIFont fontWithName:@"Arial" size:18]];
                [codeL setFont:[UIFont boldSystemFontOfSize:18]];
                [codeL setBackgroundColor:[UIColor clearColor]];
                [codeL setTextAlignment:UITextAlignmentLeft];
                [codeL setText:kLogSeven];
                [cell addSubview:codeL];
                [codeL release];
                
                codeF = [[UITextField alloc]initWithFrame:CGRectMake(80, 8, 220, 30)];
//                [codeF setFont:[UIFont fontWithName:@"Arial" size:18]];
                [codeF setFont:[UIFont systemFontOfSize:16]];
                [codeF setBackgroundColor:[UIColor clearColor]];
                [codeF setTextAlignment:UITextAlignmentLeft];
                [codeF setPlaceholder:kLogEight];
                [codeF setSecureTextEntry:YES];
                [codeF setTag:1];
                codeF.autocapitalizationType = UITextAutocapitalizationTypeNone;
                [codeF setDelegate:self];
                [cell addSubview:codeF];
                [codeF release];
                break;
            default:
                break;
        }
    }else
    {
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setAlpha:0.8];
//    [cell setBackgroundColor:[UIColor colorWithRed:0.863f green:0.957 blue:0.827 alpha:0.8]];/////
    [cell setBackgroundColor:[UIColor colorWithRed:0.028f green:0.66f blue:0.85f alpha:0.8]];/////
    return cell;
}


#pragma mark -
#pragma mark Table View Delegate Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (isiPhone? 40.0f: 60.0f);
}

#pragma mark - Http connect
//-(BOOL) isExistenceNetwork:(NSInteger)choose
//{
//	BOOL isExistenceNetwork;
//	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//			isExistenceNetwork=FALSE;
//            break;
//        case ReachableViaWWAN:
//			isExistenceNetwork=TRUE;
//            break;
//        case ReachableViaWiFi:
//			isExistenceNetwork=TRUE;    
//            break;
//    }
//	if (!isExistenceNetwork) {
//        UIAlertView *myalert = nil;
//        switch (choose) {
//            case 0:
//                break;
//            case 1:
//                myalert = [[UIAlertView alloc] initWithTitle:kInfoTwo message:kFeedbackFour delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil,nil];
//                [myalert show];
//                [myalert release];
//                break;
//            default:
//                break;
//        }
//	}
//	return isExistenceNetwork;
//}
-(BOOL) isExistenceNetwork:(NSInteger)choose
{
    UIAlertView *myalert = nil;
    kNetTest;
    switch (choose) {
        case 0:
            
            break;
        case 1:
            if (kNetIsExist) {
                
            }else {
                myalert = [[UIAlertView alloc] initWithTitle:kInfoTwo message:kFeedbackFour delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil,nil];
                [myalert show];
                [myalert release];
            }
            break;
        default:
            break;
    }    
	return kNetIsExist;
}

//- (void)catchNetA
//{
//    NSString *url = @"http://www.baidu.com";
////    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
//    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    request.delegate = self;
//    [request setUsername:@"catchnet"];
//    [request startAsynchronous];
//}

- (void)catchYub:(NSString  *)userID
{
    NSString *url = [NSString stringWithFormat:@"http://app.iyuba.com/pay/checkApi.jsp?userId=%@",userID];
//    ASIHTTPRequest * request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:url]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    request.delegate = self;
    [request setUsername:@"yub"];
    [request startAsynchronous];
}

- (void)catchLogs
{
    NSString *url = [NSString stringWithFormat:@"http://api.iyuba.com/mobile/ios/voa/login.xml?"];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:userF.text forKey:@"username"];
    [request setPostValue:codeF.text   forKey:@"password"];
    [request setPostValue:@"0"   forKey:@"md5status"];
    request.delegate = self;
    //    [request setRequestMethod:@"POST"];
    [request setUsername:@"log"];
    [request startSynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    kNetDisable;
    if ([request.username isEqualToString:@"log" ]) {
        alert = [[UIAlertView alloc] initWithTitle:kVoaWordOne message:kLogNine delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if ([request.username isEqualToString:@"catchnet"]) {
        //        NSLog(@"有网络");
        kNetEnable;
        return;
    }
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"log" ]) {
        NSArray *items = [doc nodesForXPath:@"response" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                NSString *status = [[obj elementForName:@"status"] stringValue];
//                s(@"status:%@",status);
                if ([status isEqualToString:@"OK"]) {
                    MyUser *user = [[MyUser alloc]init];
                    user._userName = [userF text];
                    user._code = [codeF text];
//                    NSString *msg = [[obj elementForName:@"msg"] stringValue] ;
//                    NSLog(@"msg:%@",msg);
                    NSInteger userId = [[[obj elementForName:@"data"] stringValue] integerValue] ;
//                    NSLog(@"userId:%d",userId);
                    user._userId = userId;
                    
                    [user insert];
                    [user release],user = nil;
                    [nowUser setText:[NSString stringWithFormat:@"%@%@",kLogOne,[MyUser findNameById:userId]]];
                    [nowUser setHidden:NO];
                    [afterLog setHidden:NO];
                    [logOutBtn setHidden:NO];
                    [yubBtn setHidden:NO];
                    [yubNumBtn setHidden:NO];
                    [logBtnTwo setHidden:YES];
                    [logTable setHidden:YES];
                    [remCodeL setHidden:YES];
                    [remCode setHidden:YES];
                    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userId] forKey:@"nowUser"];
                    NSInteger rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"remCode"] integerValue];
                    if (rem==1) {
                        [MyUser acceptRem:userF.text];
                    }else
                    {
                        [MyUser cancelRem:userF.text];
                    }
                    
                    alert = [[UIAlertView alloc] initWithTitle:kLogTwo message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    
                    [alert setBackgroundColor:[UIColor clearColor]];
                    
                    [alert setContentMode:UIViewContentModeScaleAspectFit];
                    
                    [alert show];
                    
                    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    
                    active.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height-40);
                    
                    [alert addSubview:active];
                    
                    [active startAnimating];
                    
                    [active release];
                    
                    NSTimer *timer = nil;
                    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(c) userInfo:nil repeats:NO];
                    
                }else
                {
                    NSString *msg = [[obj elementForName:@"msg"] stringValue] ;
//                    NSLog(@"msg:%@",msg);
                    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",kLogTen,msg] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    
                    [alert setBackgroundColor:[UIColor clearColor]];
                    
                    [alert setContentMode:UIViewContentModeScaleAspectFit];
                    
                    [alert show];
                    UIActivityIndicatorView *active = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
                    
                    active.center = CGPointMake(alert.bounds.size.width/2, alert.bounds.size.height-40);
                    
                    [alert addSubview:active];
                    
                    [active startAnimating];
                    
                    [active release];
                    
                    NSTimer *timer = nil;
                    timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(c) userInfo:nil repeats:NO];
                }
            }
        }
    } else {
        if ([request.username isEqualToString:@"yub" ]) {
            NSArray *items = [doc nodesForXPath:@"response" error:nil];
            if (items) {
                for (DDXMLElement *obj in items) {
                    NSString *amount = [[obj elementForName:@"amount"] stringValue];
                    [yubNumBtn setTitle:amount forState:UIControlStateNormal];
                }
            }
        }
    }
    [doc release],doc = nil;
}

-(void)c
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [textField setTextColor:[UIColor blackColor]];
    [textField setText:@""];
    if (textField.tag == 1) {
        
        NSString *code = [MyUser findCodeByName:userF.text];
        [textField setSecureTextEntry:YES];
//        NSLog(@"自动密码kai:%@",code);
        if (code) {
            [codeF setText:code];
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            if (textField.text.length <3) {
                [textField setText:kLogEleven];
                [textField setTextColor:[UIColor redColor]];
            }else{
                [textField setTextColor:[UIColor blackColor]];
                NSString *code = [MyUser findCodeByName:textField.text];
//                NSLog(@"自动密码wan:%@",code);
                if (code) {
                    [codeF setText:code];
                }
            }
            break;
        case 1:
            if (textField.text.length == 0) {
                [textField setSecureTextEntry:NO];
                [textField setText:kLogEight];
                [textField setTextColor:[UIColor redColor]];
            }else{
                [textField setSecureTextEntry:YES];
            }
            break;
        default:
            break;
    }
}

@end
