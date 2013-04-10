//
//  VOAContent.h
//  VOA
//
//  Created by song zhao on 12-2-14.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VOAContent : NSObject
{
    NSInteger _voaid;
    NSString *_content;
    NSString *_title;
    NSString *_creattime;
    NSString *_pic;
    NSInteger _number;
    NSInteger _titleNum;
}

@property NSInteger _voaid;
@property (nonatomic,retain) NSString *_content;
@property (nonatomic,retain) NSString *_title;
@property (nonatomic,retain) NSString *_creattime;
@property (nonatomic,retain) NSString *_pic;
@property NSInteger _number;
@property NSInteger _titleNum;

- (id) initWithVoaId:(NSInteger) voaid content:(NSString *) content title:(NSString *) title creattime:(NSString *) creattime pic:(NSString *) pic number:(NSInteger) number titleNum:(NSInteger) titleNum ;
-(NSComparisonResult) compareNumber: (VOAContent *) p;
@end
