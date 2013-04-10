//
//  InforController.h
//  VOA
//
//  Created by song zhao on 12-3-31.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

@interface InforController : UIViewController
{    
    UIWebView *             _webView;
    BOOL isiPhone;
}

@property (nonatomic, retain) IBOutlet UIWebView *          webView;
@property (nonatomic) BOOL isiPhone;

@end
