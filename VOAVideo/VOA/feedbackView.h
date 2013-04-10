//
//  feedbackView.h
//  FinalTest
//
//  Created by Seven Lee on 12-2-1.
//  Copyright (c) 2012年 iyuba. All rights reserved.
//

#import "ASIFormDataRequest.h"
#import "DDXML.h"
#import "DDXMLElementAdditions.h"
#import "Reachability.h"//isExistenceNetwork
#import "Constants.h"

@interface feedbackView : UIViewController<ASIHTTPRequestDelegate,UITextFieldDelegate,UITextViewDelegate>{
    UITextView *_feedback;
    UITextField *_mail;
    UIAlertView *_alert;
    BOOL isiPhone;
}

@property(nonatomic,retain) IBOutlet UITextView *feedback;
@property(nonatomic,retain) IBOutlet UITextField *mail;
@property(nonatomic,retain) UIAlertView *alert;
@property(nonatomic) BOOL isiPhone;

- (void)sendFeedback;

@end
