//
//  RegistViewController.m
//  VOA
//
//  Created by song zhao on 12-3-14.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "RegistViewController.h"

@implementation RegistViewController
@synthesize logTable;
@synthesize userF;
@synthesize userL;
@synthesize codeF;
@synthesize codeL;
@synthesize codeAgainF;
@synthesize codeAgainL;
@synthesize mailF;
@synthesize mailL;
@synthesize registBtn;
@synthesize alert;
@synthesize isiPhone;
@synthesize returnBtn;

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
//
//- (BOOL)isPad {
//	BOOL isPad = NO;
//#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 30200)
//	isPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
//#endif
//	return isPad;
//}

#pragma mark - My action
- (void) goBack:(UIButton *)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

- (void) doRegist
{
    if (userF.textColor == [UIColor blackColor] && codeF.textColor == [UIColor blackColor] && codeAgainF.textColor == [UIColor blackColor] && mailF.textColor == [UIColor blackColor]) {
        [self catchRegists];
    }
}


#pragma mark - View lifecycle
- (void)viewWillAppear:(BOOL)animated
{
//    [registBtn setUserInteractionEnabled:NO];
}

- (void)viewDidLoad
{
    self.view.autoresizesSubviews = YES;
    
    
    isiPhone = ![Constants isPad];
//    UIImageView *backgroundView = Nil;
    registBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
//    [registBtn setBackgroundColor:[UIColor colorWithRed:0.427f green:0.753f blue:0.172f alpha:1.0f]];
    [registBtn setBackgroundColor:[UIColor colorWithRed:1.0/255 green:151.0/255 blue:211.0/255 alpha:1]];
    [registBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registBtn setShowsTouchWhenHighlighted:YES];
    [registBtn addTarget:self action:@selector(doRegist) forControlEvents:UIControlEventTouchUpInside];
    
    returnBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
    [returnBtn setImage:[UIImage imageNamed:@"greenReturnBBC.png"] forState:UIControlStateNormal];
    [returnBtn setShowsTouchWhenHighlighted:YES];
    [returnBtn addTarget:self action:@selector(goBack:) forControlEvents:UIControlEventTouchUpInside];
    if (isiPhone) {
//        backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
        
//        [registBtn setImage:[UIImage imageNamed:@"myRegistBBC.png"] forState:UIControlStateNormal];
        
        [registBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [registBtn setFrame:CGRectMake(130, 211, 60, 30)];
        [[registBtn layer] setCornerRadius:8.0f];
        [[registBtn layer] setMasksToBounds:YES];
        [returnBtn setFrame:CGRectMake(5, 5, 45, 35)];
        logTable = [[UITableView alloc] initWithFrame:CGRectMake(10.0f, 30.0f, 300.0f, 180.0f) style:UITableViewStylePlain];
        logTable.delegate = self;
        logTable.dataSource = self;
        
        [logTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [logTable setBackgroundColor:[UIColor clearColor]];
        [logTable setSeparatorColor:[UIColor colorWithRed:1.0/255 green:151.0/255 blue:211.0/255 alpha:1]];
//        [logTable setSeparatorColor:[UIColor colorWithRed:0.482f green:0.596f blue:0.471f alpha:1.0f]];
        
    }else {
//        [self.view setFrame:CGRectMake(0, 0, 768, 1024)];
        logTable = [[UITableView alloc] initWithFrame:CGRectMake(134, 50, 500, 240) style:UITableViewStylePlain];
        [logTable setBackgroundColor:[UIColor clearColor]];
        [logTable setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        [logTable setSeparatorColor:[UIColor colorWithRed:1.0/255 green:151.0/255 blue:211.0/255 alpha:1]];
        logTable.delegate = self;
        logTable.dataSource = self;
        [registBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
        [registBtn setFrame:CGRectMake(334, 300, 80, 45)];
        [[registBtn layer] setCornerRadius:10.0f];
        [[registBtn layer] setMasksToBounds:YES];
        [returnBtn setFrame:CGRectMake(10, 10, 80, 60)];
//        [self.view addSubview:logTable];
//        [logTable release];
//        [self.view addSubview:registBtn];
//        [self.view addSubview:returnBtn];
//        backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 200)];
    }
    logTable.autoresizesSubviews = YES;
    logTable.autoresizingMask = UIViewAutoresizingFlexibleWidth ;
    registBtn.autoresizesSubviews = YES;
    registBtn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:logTable];
    [logTable release];
    [self.view addSubview:registBtn];
    [self.view addSubview:returnBtn];
    
    
    
//    [backgroundView setImage:[UIImage imageNamed:@"bgRg.png"]];
//    [logTable addSubview:backgroundView];
//    [logTable sendSubviewToBack:backgroundView];
//    [backgroundView release];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
//    UITableView *logTable;
//    @property (nonatomic, retain) UILabel *userL;
//    @property (nonatomic, retain) UILabel *codeL;
//    @property (nonatomic, retain) UILabel *codeAgainL;
//    @property (nonatomic, retain) UILabel *mailL;
//    @property (nonatomic, retain) UITextField *userF;
//    @property (nonatomic, retain) UITextField *codeF;
//    @property (nonatomic, retain) UITextField *codeAgainF;
//    @property (nonatomic, retain) UITextField *mailF;
//    @property (nonatomic, retain) UIButton *registBtn;
//    @property (nonatomic, retain) UIButton *returnBtn;
//    @property (nonatomic, retain) UIAlertView *alert;
//    [logTable release], logTable = nil;
//    [userL release], userL = nil;
//    [self.codeL release], codeL = nil;
//    [self.codeAgainL release], codeAgainL = nil;
//    [self.mailL release], mailL = nil;
//    [self.userF release], userF = nil;
//    [self.codeF release], codeF = nil;
//    [self.codeAgainF release], codeAgainF = nil;
//    [self.mailF release], mailF = nil;
    
//    NSLog(@"2");
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
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    NSString *identifier = [NSString stringWithFormat:@"RegistCell%d",[indexPath row]];
    cell = [logTable dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier] autorelease];
//        UIImageView *backgroundView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 300, 40)];
//        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 39, 300, 1)];
        switch ([indexPath row]) {
            case 0:
//                [backgroundView setImage:[UIImage imageNamed:@"cellBgOne.png"]];
//                [cell addSubview:backgroundView];
//                [cell sendSubviewToBack:backgroundView];
//                [lineView setImage:[UIImage imageNamed:@"lineSep.png"]];
//                [cell addSubview:lineView];
//                [cell sendSubviewToBack:lineView];
                userL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
                [userL setFont:[UIFont fontWithName:@"Arial" size:18]];
                [userL setBackgroundColor:[UIColor clearColor]];
                [userL setTextAlignment:UITextAlignmentLeft];
                [userL setText:kLogFive];
                [cell addSubview:userL];
                [userL release];
                
                userF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 30)];
                [userF setFont:[UIFont fontWithName:@"Arial" size:15]];
                [userF setBackgroundColor:[UIColor clearColor]];
                [userF setTextAlignment:UITextAlignmentLeft];
                [userF setPlaceholder:kRegOne];
                [userF setDelegate:self];
                [userF setTag:0];
                userF.autocapitalizationType = UITextAutocapitalizationTypeNone;
                [cell addSubview:userF];
                [userF release];
                break;
                
            case 1: 
//                [backgroundView setImage:[UIImage imageNamed:@"cellBgTwo.png"]];
//                [cell addSubview:backgroundView];
//                [cell sendSubviewToBack:backgroundView];
//                [lineView setImage:[UIImage imageNamed:@"lineSep.png"]];
//                [cell addSubview:lineView];
//                [cell sendSubviewToBack:lineView];
                codeL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
                [codeL setFont:[UIFont fontWithName:@"Arial" size:18]];
                [codeL setBackgroundColor:[UIColor clearColor]];
                [codeL setTextAlignment:UITextAlignmentLeft];
                [codeL setText:kLogSeven];
                [cell addSubview:codeL];
                [codeL release];
                
                codeF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 30)];
                [codeF setFont:[UIFont fontWithName:@"Arial" size:15]];
                [codeF setBackgroundColor:[UIColor clearColor]];
                [codeF setTextAlignment:UITextAlignmentLeft];
                [codeF setPlaceholder:kLogEight];
                [codeF setSecureTextEntry:YES];
                [codeF setDelegate:self];
                [codeF setTag:1];
                codeF.autocapitalizationType = UITextAutocapitalizationTypeNone;
                [cell addSubview:codeF];
                [codeF release];
                break;
                
            case 2:
//                [backgroundView setImage:[UIImage imageNamed:@"cellBgThree.png"]];
//                [cell addSubview:backgroundView];
//                [cell sendSubviewToBack:backgroundView];
//                [lineView setImage:[UIImage imageNamed:@"lineSep.png"]];
//                [cell addSubview:lineView];
//                [cell sendSubviewToBack:lineView];
                codeAgainL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
                [codeAgainL setFont:[UIFont fontWithName:@"Arial" size:18]];
                [codeAgainL setBackgroundColor:[UIColor clearColor]];
                [codeAgainL setTextAlignment:UITextAlignmentLeft];
                [codeAgainL setText:kRegTwo];
                [cell addSubview:codeAgainL];
                [codeAgainL release];
                
                codeAgainF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 30)];
                [codeAgainF setFont:[UIFont fontWithName:@"Arial" size:15]];
                [codeAgainF setBackgroundColor:[UIColor clearColor]];
                [codeAgainF setTextAlignment:UITextAlignmentLeft];
                [codeAgainF setPlaceholder:kRegThree];
                [codeAgainF setSecureTextEntry:YES];
                [codeAgainF setDelegate:self];
                [codeAgainF setTag:2];
                codeAgainF.autocapitalizationType = UITextAutocapitalizationTypeNone;
                [cell addSubview:codeAgainF];
                [codeAgainF release];
                break;
                
            case 3:
//                [backgroundView setImage:[UIImage imageNamed:@"cellBgLast.png"]];
//                [cell addSubview:backgroundView];
//                [cell sendSubviewToBack:backgroundView];
//                [lineView setImage:[UIImage imageNamed:@"lineSep.png"]];
//                [cell addSubview:lineView];
//                [cell sendSubviewToBack:lineView];
                mailL = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 80, 30)];
                [mailL setFont:[UIFont fontWithName:@"Arial" size:18]];
                [mailL setBackgroundColor:[UIColor clearColor]];
                [mailL setTextAlignment:UITextAlignmentLeft];
                [mailL setText:@"Email:"];
                [cell addSubview:mailL];
                [mailL release];
                
                mailF = [[UITextField alloc]initWithFrame:CGRectMake(90, 10, 220, 30)];
                [mailF setFont:[UIFont fontWithName:@"Arial" size:15]];
                [mailF setBackgroundColor:[UIColor clearColor]];
                [mailF setTextAlignment:UITextAlignmentLeft];
                [mailF setPlaceholder:kRegFour];
                [mailF setDelegate:self];
                [mailF setTag:3];
                mailF.autocapitalizationType = UITextAutocapitalizationTypeNone;
                [cell addSubview:mailF];
                [mailF release];
                break;
                
//            case 4:
//                registBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
//                [registBtn setImage:[UIImage imageNamed:@"myRegistBBC.png"] forState:UIControlStateNormal];
//                [registBtn addTarget:self action:@selector(doRegist) forControlEvents:UIControlEventTouchUpInside];
//                [registBtn setFrame:CGRectMake(105, 5, 80, 30)];
//                [cell addSubview:registBtn];
//                break;
            default:
                break;
        }
    }else
    {
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    [cell setBackgroundColor:[UIColor clearColor]];
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
- (void)catchRegists
{
    NSString *url = [NSString stringWithFormat:@"http://api.iyuba.com/mobile/ios/voa/regist.xml?"];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [request setPostValue:mailF.text forKey:@"email"];
    [request setPostValue:userF.text   forKey:@"username"];
    [request setPostValue:codeF.text   forKey:@"password"];
    [request setPostValue:@"0"   forKey:@"md5status"];
    request.delegate = self;
    [request setUsername:@"regist"];
    [request startSynchronous];
}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    alert = [[UIAlertView alloc] initWithTitle:kRegFive message:kRegSix delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    [alert release];    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *myData = [request responseData];
    DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:myData options:0 error:nil];
    if ([request.username isEqualToString:@"regist" ]) {
        NSArray *items = [doc nodesForXPath:@"response" error:nil];
        if (items) {
            for (DDXMLElement *obj in items) {
                NSString *status = [[obj elementForName:@"status"] stringValue];
                //                NSLog(@"status:%@",status);
                if ([status isEqualToString:@"OK"]) {
                    MyUser *user = [[MyUser alloc]init];
                    user._userName = [userF text];
                    user._code = [codeF text];
                    user._mail = [mailF text];
                    //                    NSString *msg = [[obj elementForName:@"msg"] stringValue] ;
                    //                    NSLog(@"msg:%@",msg);
                    NSInteger userId = [[[obj elementForName:@"data"] stringValue] integerValue] ;
                    //                    NSLog(@"userId:%d",userId);
                    user._userId = userId;
                    [user insert];
                    [user release],user = nil;
                    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",kRegSeven,[userF text]] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    
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
                    NSInteger nowId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"nowUser"] integerValue];
                    //    NSLog(@"生词本添加用户：%d",userId);
                    if (nowId<=0) {
                        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userId] forKey:@"nowUser"];
                    }
                    [self dismissModalViewControllerAnimated:YES];
                }else
                {
                    NSString *msg = [[obj elementForName:@"msg"] stringValue] ;
                    //                    NSLog(@"msg:%@",msg);
                    alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@%@",kRegEight,msg] message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil, nil];
                    
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
    }
    [doc release],doc = nil;
}

-(void)c
{
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    [alert release];
}

//-(BOOL) isExistenceNetwork:(NSInteger)choose
//{
//	BOOL isExistenceNetwork;
//	Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
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
//                
//                break;
//            case 1:
//                myalert = [[UIAlertView alloc] initWithTitle:kInfoTwo message:kRegNine delegate:nil cancelButtonTitle:kFeedbackFive otherButtonTitles:nil,nil];
//                [myalert show];
//                [myalert release];
//                break;
//            default:
//                break;
//        }
//	}
//	return isExistenceNetwork;
//}


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
    if (textField.tag == 1 || textField.tag == 2) {
        [textField setSecureTextEntry:YES];
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
        case 2:
            if ([textField.text isEqualToString:codeF.text]) {
                [textField setSecureTextEntry:YES];
            }else{
                [textField setSecureTextEntry:NO];
                [textField setText:kRegTen];
                [textField setTextColor:[UIColor redColor]];
            }
             break;
        case 3:
//            if ([textField.text isMatchedByRegex:@"^(\\w+((-\\w+)|(\\.\\w+))*)\\+\\w+((-\\w+)|(\\.\\w+))*\\@[A-Za-z0-9]+((\\.|-)[A-Za-z0-9]+)*\\.[A-Za-z0-9]+$"]){
            if ([textField.text isMatchedByRegex:@"^([a-zA-Z0-9_\\.\\-])+\\@(([a-zA-Z0-9\\-])+\\.)+([a-zA-Z0-9]{2,4})+$"]){    
            }else{
                [textField setText:kRegEleven];
                [textField setTextColor:[UIColor redColor]];
            }
        default:
            break;
    }
}

@end
