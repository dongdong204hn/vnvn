//
//  LyricSyn.m
//  VOA
//
//  Created by song zhao on 12-2-6.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "LyricSynClass.h"


@implementation LyricSynClass
@synthesize delegate;

+ (void)lyricSyn : (NSMutableArray *)lyricLabelArray
lyricCnLabelArray: (NSMutableArray *)lyricCnLabelArray 
		   index : (NSMutableArray *)indexArray
			time : (NSMutableArray *)timeArray
	   localPlayer : (AVPlayer *)mp3Player 
		  scroll : (TextScrollView *)textScroll {
	
    //  防止实例被释放	
	[lyricLabelArray retain];
    [lyricCnLabelArray retain];
	[indexArray retain];
	[timeArray retain];
	[mp3Player retain];
	[textScroll retain];
//	NSLog(@"4");
    CMTime playerProgress = [mp3Player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    //  歌词的内容，时间；通过比对时间来高亮label
    
    NSInteger myColor = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueColor"];
    UIColor *swColor = [UIColor redColor];
    switch (myColor) {
        case 1:
            swColor = [UIColor colorWithRed:0.78f green:0.078f blue:0.11f alpha:1.0];
            break;
        case 2:
//            swColor = [UIColor colorWithRed:0.153f green:0.012f blue:0.518f alpha:1.0];
            swColor = [UIColor colorWithRed:1.0/255 green:151.0/255 blue:211.0/255 alpha:1];
            break;
        case 3:
            swColor = [UIColor colorWithRed:0.384f green:0.247f blue:0.157f alpha:1.0];                    
            break;
        case 4:
            swColor = [UIColor colorWithRed:1.0f green:0.4f blue:0.192 alpha:1.0];
            break;
        case 5:
            swColor = [UIColor colorWithRed:0.435f green:0.106f blue:0.361f alpha:1.0];
            break;
        case 6:
            swColor = [UIColor colorWithRed:0.421f green:0.753f blue:0.173f alpha:1.0];
            break;
        default:
            break;
    }
    
	for (int i = 0; i < [indexArray count] - 1; i++) {
		
        MyLabel *lyricLabel = [lyricLabelArray objectAtIndex:i];
		[lyricLabel retain];
        UILabel *lyricCnLabel = [lyricCnLabelArray objectAtIndex:i];
		[lyricCnLabel retain];

 		if ((int)progress >= [[timeArray objectAtIndex:i] unsignedIntValue] && 
			(int)progress < [[timeArray objectAtIndex:i+1] unsignedIntValue]) {
			
			lyricLabel.highlighted = YES;
			lyricLabel.highlightedTextColor = swColor;
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hightlightLoc"] == nil){
                if ([Constants isPad]) {
                    MyLabel *preLabel = nil;
                    if (i>1) {
                        preLabel = [lyricLabelArray objectAtIndex:i-2];
                    }else {
                        preLabel = [lyricLabelArray objectAtIndex:0];
                    }
                    CGPoint offSet =  CGPointMake(0, preLabel.frame.origin.y);
                    [textScroll setContentOffset:offSet animated:YES];
                }else {
                    MyLabel *preLabel = nil;
                    if (i>0) {
                        preLabel = [lyricLabelArray objectAtIndex:i-1];
                    }else {
                        preLabel = [lyricLabelArray objectAtIndex:0];
                    }
                    CGPoint offSet =  CGPointMake(0, preLabel.frame.origin.y);
                    [textScroll setContentOffset:offSet animated:YES];
                }
            }else {
                BOOL highlightLoc = [[NSUserDefaults standardUserDefaults] boolForKey:@"hightlightLoc"];
                if (highlightLoc) {
                    if ([Constants isPad]) {
                        MyLabel *preLabel = nil;
                        if (i>1) {
                            preLabel = [lyricLabelArray objectAtIndex:i-2];
                        }else {
                            preLabel = [lyricLabelArray objectAtIndex:0];
                        }
                        CGPoint offSet =  CGPointMake(0, preLabel.frame.origin.y);
                        [textScroll setContentOffset:offSet animated:YES];
                    }else {
                        MyLabel *preLabel = nil;
                        if (i>0) {
                            preLabel = [lyricLabelArray objectAtIndex:i-1];
                        }else {
                            preLabel = [lyricLabelArray objectAtIndex:0];
                        }
                        CGPoint offSet =  CGPointMake(0, preLabel.frame.origin.y);
                        [textScroll setContentOffset:offSet animated:YES];
                    }
                }else {
                    CGPoint offSet =  CGPointMake(0, lyricLabel.frame.origin.y);
                    [textScroll setContentOffset:offSet animated:YES];
                }
            }
            
            
            lyricCnLabel.highlighted = YES;
			lyricCnLabel.highlightedTextColor = swColor;
            
		}//end if
		else {
			
			lyricLabel.highlighted = NO;
			lyricCnLabel.highlighted = NO;
		}//end else
		
		[lyricLabel release];
        [lyricCnLabel release];
		
	}//end for
//	NSLog(@"5");
    MyLabel *lyricLabel = [lyricLabelArray objectAtIndex:[indexArray count] - 1];
	[lyricLabel retain];
    UILabel *lyricCnLabel = [lyricCnLabelArray objectAtIndex:[indexArray count] - 1];
	[lyricCnLabel retain];
	
	if ((int)progress >= [[timeArray objectAtIndex:[indexArray count] - 1] unsignedIntValue]){
          
		lyricLabel.highlighted = YES;
		lyricLabel.highlightedTextColor = swColor;
		CGPoint offSet =  CGPointMake(0, lyricLabel.frame.origin.y);
		[textScroll setContentOffset:offSet];
        lyricCnLabel.highlighted = YES;
		lyricCnLabel.highlightedTextColor = swColor;
		
	}//end if
	else {
		lyricLabel.highlighted = NO;
        lyricCnLabel.highlighted = NO;
	}//end else
	
	[lyricLabel release];
	[lyricCnLabel release];
    //  释放引用		
	[lyricLabelArray release];
    [lyricCnLabelArray release];
	[indexArray release];
	[timeArray release];
	[mp3Player release];
	[textScroll release];
}

+ (int)lyricView : (NSMutableArray *)lyricLabelArray 
lyricCnLabelArray: (NSMutableArray *)lyricCnLabelArray 
           index : (NSMutableArray *)indexArray 
           lyric : (NSMutableArray *)lyricArray
         lyricCn : (NSMutableArray *)lyricCnArray   
          scroll : (TextScrollView *)textScroll 
  myLabelDelegate: (id <MyLabelDelegate>) myLabelDelegate
        engLines : (int *)engLines 
         cnLines : (int *)cnLines {
    
    //  防止实例被释放	
	[lyricLabelArray retain];
    [lyricCnLabelArray retain];
	[indexArray retain];
	[lyricArray retain];
    [lyricCnArray retain];
	[textScroll retain];
	
    //  歌词信息在ViewScroll中显示
	int  offSetY = 0;
    double engHight = 0.f;
    double cnHight = 0.f;
    int fontSize = 15;
    if ([Constants isPad]) {
        fontSize = 20;
    }
    int mulValueFont = [[NSUserDefaults standardUserDefaults] integerForKey:@"mulValueFont"];
    if (mulValueFont > 0) {
        fontSize = mulValueFont;
    }
//    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:fontSize] forKey:@"nowValueFont"];
//    UIFont *Courier = [UIFont fontWithName:@"Courier" size:fontSize];//初始15
    UIFont *Courier = [UIFont systemFontOfSize:fontSize];//初始15
    UIFont *CourierTwo = [UIFont systemFontOfSize:fontSize-2]; 
//    BOOL isPad = [Constants isPad];
//    if (isPad) {
////        Courier = [UIFont fontWithName:@"Courier" size:fontSize];//初始20
//        Courier = [UIFont systemFontOfSize:fontSize];
//        CourierTwo = [UIFont systemFontOfSize:fontSize-2]; 
//    }
	for (int i = 0; i <= [indexArray count] - 1; i++) {
//        UIFont *CourierTwo = [UIFont fontWithName:@"arial" size:13];         
        
        //	计算每行字符长度。
        engHight = [@"a" sizeWithFont:Courier].height;
//        NSLog(@"height1:%f height2:%f",engHight,[@"a" sizeWithFont:Courier constrainedToSize:CGSizeMake(textScroll.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height);
        cnHight = [@"赵" sizeWithFont:CourierTwo].height;
		*engLines = [[lyricArray objectAtIndex:i] sizeWithFont:Courier constrainedToSize:CGSizeMake(textScroll.frame.size.width, CGFLOAT_MAX) lineBreakMode:UILineBreakModeWordWrap].height / engHight;
        *cnLines = [[lyricCnArray objectAtIndex:i] length];
        
        int cnLineNumber = (textScroll.frame.size.width-1)/([@"赵" sizeWithFont:CourierTwo].width-1);//21
//        NSLog(@"width:%lf,height:%lf",[@" " sizeWithFont:Courier].width,[@" " sizeWithFont:Courier].height);
//        NSLog(@"闪退textScroll：%f", textScroll.frame.size.width-1);
//        NSLog(@"闪退*cnLines：%i   cnLineNumber：%i",*cnLines,cnLineNumber);
        if ((*cnLines % cnLineNumber)>0) {
//            NSLog(@"闪退cnLineNumber：%i",cnLineNumber);
            *cnLines = (*cnLines / cnLineNumber) +1;//35:当前每行所放字母的数目  每个字母9pix n个字母总宽度9*n+1
        }else
        {
            *cnLines = (*cnLines / cnLineNumber);
        }
        
		MyLabel *lyricLabel = [[MyLabel alloc] initWithFrame:
							   CGRectMake(0, offSetY, textScroll.frame.size.width, *engLines * engHight)];
        lyricLabel.delegate = myLabelDelegate;
        NSString *labelText = [[NSString alloc] initWithFormat:@"%@", [lyricArray objectAtIndex:i]];
        lyricLabel.text = labelText;
        [labelText release];
        lyricLabel.tag = 200 + i;
        [lyricLabel setFont:Courier];
        [lyricLabel setTextColor:[UIColor grayColor]];
        lyricLabel.backgroundColor = [UIColor clearColor];
        [lyricLabel setLineBreakMode:UILineBreakModeWordWrap];
        [lyricLabel setNumberOfLines:*engLines];
		[textScroll addSubview:lyricLabel];
        [lyricLabel release];
        
		[lyricLabelArray addObject:lyricLabel];	
//        [lyricLabel release];//!!切记release不能多次，一次足以，否则一边释放掉会导致其他地方也用不了
		offSetY += *engLines * engHight;
        
        
        UILabel *lyricCnLabel = [[UILabel alloc] initWithFrame:
                                 CGRectMake(0, offSetY, textScroll.frame.size.width, *cnLines * cnHight)];
        if (![[lyricCnArray objectAtIndex:i] isEqualToString:@"null"] && ![[lyricCnArray objectAtIndex:i] isEqualToString:@""] && ![[lyricCnArray objectAtIndex:i] isEqualToString:@"test"]) {
            
            NSString *labelText = [[NSString alloc] initWithFormat:@"%@", [lyricCnArray objectAtIndex:i]];
            lyricCnLabel.text = labelText;
            [labelText release];
            
        }else
        {
//            lyricCnLabel.text = kLyricOne;//没有翻译就空着吧。。 隐藏了"暂未更新"
        }
        
		lyricCnLabel.tag = i;
        [lyricCnLabel setFont:CourierTwo];
        [lyricCnLabel setTextColor:[UIColor grayColor]];
        lyricCnLabel.backgroundColor = [UIColor clearColor];
        [lyricCnLabel setLineBreakMode:UILineBreakModeWordWrap];
        [lyricCnLabel setNumberOfLines:*cnLines];
		[textScroll addSubview:lyricCnLabel];
        [lyricCnLabel release];
		[lyricCnLabelArray addObject:lyricCnLabel];	
//        [lyricCnLabel release];//!!切记release不能多次，一次足以，否则一边释放掉会导致其他地方也用不了
		offSetY += *cnLines * cnHight;
        
	}//end for
	
	//  释放
	[lyricLabelArray release];
    [lyricCnLabelArray release];
	[indexArray release];
    [lyricArray release];
	[lyricCnArray release];
	[textScroll release];
    return offSetY;
}

+ (void)preLyricSyn: (NSMutableArray *)timeArray
          localPlayer : (AVPlayer *)mp3Player
{
    CMTime playerProgress = [mp3Player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    int i = 0;
    for (; i < [timeArray count]; i++) {
        if ((int)progress < [[timeArray objectAtIndex:i] unsignedIntValue]) {
            if ((i-2)>=0) {
                [mp3Player seekToTime:CMTimeMakeWithSeconds([[timeArray objectAtIndex:i-2] unsignedIntValue], NSEC_PER_SEC)];
            }
            return ;
        }
    }
    [mp3Player seekToTime:CMTimeMakeWithSeconds([[timeArray objectAtIndex:[timeArray count]-2] unsignedIntValue], NSEC_PER_SEC)];
}

+ (void)aftLyricSyn: (NSMutableArray *)timeArray
          localPlayer : (AVPlayer *)mp3Player
{
    CMTime playerProgress = [mp3Player currentTime];
    double progress = CMTimeGetSeconds(playerProgress);
    int i = 0;
    for (; i < [timeArray count]; i++) {
        if ((int)progress < [[timeArray objectAtIndex:i] unsignedIntValue]) {
            [mp3Player seekToTime:CMTimeMakeWithSeconds([[timeArray objectAtIndex:i] unsignedIntValue], NSEC_PER_SEC)];
            break;
        }
    }   
}

+ (UIImage*)screenshot:(CGRect) senRect
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    //    CGSize imageSize = ViewController.navigationController.view.bounds.size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, YES, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGRect contentRectToCrop = senRect;
    if ([[UIScreen mainScreen]scale]>1.1) {
        contentRectToCrop = CGRectMake(senRect.origin.x*2, senRect.origin.y*2, senRect.size.width*2, senRect.size.height*2);
    }
//    if ([Constants isPad]) {
//        contentRectToCrop = CGRectMake(0, 20, 768, 1004);
//        if ([[UIScreen mainScreen]scale]>1.1) {
//            contentRectToCrop = CGRectMake(0, 20, 768*2, 2008);
//        }
//    }
    //    UIImage *imageout = UIGraphicsGetImageFromCurrentImageContext();
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], contentRectToCrop);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    return croppedImage;
}

@end
