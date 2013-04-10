//
//  VOADetail.h
//  VOA
//
//  Created by song zhao on 12-2-3.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOAView.h"
#import "VOAContent.h"
@interface VOADetail : NSObject
{
    NSInteger _voaid;
    NSInteger _paraid;
    NSInteger _idIndex;
    NSInteger _timing;
    NSString *_sentence;
    NSString *_imgWords;
    NSString *_imgPath;
    NSString *_sentence_cn;
//    NSString *_sentence_jp;
}

@property NSInteger _voaid;
@property NSInteger _paraid;
@property NSInteger _idIndex;
@property NSInteger _timing;
@property (nonatomic, retain) NSString *_sentence;
@property (nonatomic, retain) NSString *_imgWords;
@property (nonatomic, retain) NSString *_imgPath;
@property (nonatomic, retain) NSString *_sentence_cn;
//@property (nonatomic, retain) NSString *_sentence_jp;

- (id) initWithVoaId:(NSInteger) voaid paraid:(NSInteger) paraid idIndex:(NSInteger) idIndex timing:(NSInteger) timing sentence:(NSString *)sentence  imgWords:(NSString *) imgWords imgPath:(NSString *) imgPath sentence_cn:(NSString *) sentence_cn;
//+ (NSArray *) findAll;
+ (id) find:(NSInteger) voaid;
+ (BOOL) isExist:(NSInteger) voaid;
- (BOOL) insert;
//+ (NSInteger) findLastId;
//+ (NSString *) findImgWords:(NSInteger) voaid;
+ (void) deleteByVoaid:(NSInteger)voaid ;
@end
