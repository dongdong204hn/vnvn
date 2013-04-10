//
//  VOAFav.h
//  VOA
//
//  Created by song zhao on 12-2-8.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "favdatabase.h"
#import "VOAView.h"
@interface VOAFav : NSObject
{
    NSInteger _voaid;
    NSString *_collect;
    NSString *_date;
}
@property NSInteger _voaid;
@property (nonatomic, retain) NSString *_collect;
@property (nonatomic, retain) NSString *_date;
- (id) initWithVoaId:(NSInteger ) voaid collect:(NSString *) collect date:(NSString *) date ;
+ (void) alterCollect:(NSInteger ) voaid;
+ (void) deleteCollect:(NSInteger) voaid;
////查找并返回全部对象
//+ (NSMutableArray *) findAll;
//查找并返回指定id的对象
+ (id) find:(NSInteger ) voaid;
+ (BOOL) isCollected:(NSInteger) voaid;
+ (NSMutableArray *) findCollect;
//+ (NSMutableArray *) getListBeforeVoaid:(NSInteger)voaid listArray:(NSMutableArray *)listArray;
+ (NSArray *) getList:(NSMutableArray *)listArray;
+ (BOOL) isExist:(NSInteger) voaid;
@end
