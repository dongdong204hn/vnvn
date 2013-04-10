//
//  VOAWord.h
//  VOA
//
//  Created by song zhao on 12-2-24.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface VOAWord : NSObject
{
    NSInteger wordId;
    NSInteger userId;
    NSString *key;
    NSString *lang;
    NSString *audio;
    NSString *pron;
    NSString *def;
    NSString *date;
    NSInteger checks;//标记单词在生词本中被用户点击查看释义的次数
    NSInteger remember;//标记单词在生词本某块被显示的次数
    NSInteger flag;//标志增/删 
    NSInteger synchroFlg;//标志服务器同步时是否有此词 0没有 1有
    NSMutableArray *engArray;
    NSMutableArray *chnArray;
}
@property NSInteger wordId;
@property NSInteger userId;
@property(nonatomic,retain) NSString *key;
@property(nonatomic,retain) NSString *lang;
@property(nonatomic,retain) NSString *audio;
@property(nonatomic,retain) NSString *pron;
@property(nonatomic,retain) NSString *def;
@property(nonatomic,retain) NSString *date;
@property NSInteger checks;
@property NSInteger remember;
@property NSInteger flag;
@property NSInteger synchroFlg;
@property(nonatomic,retain) NSMutableArray *engArray;
@property(nonatomic,retain) NSMutableArray *chnArray;

- (id) initWithVOAWord:(NSInteger) wordId key:(NSString *) _key audio:(NSString *) _audio pron:(NSString *) _pron def:(NSString *) _def date:(NSString *) _date  checks:(NSInteger) _checks remember:(NSInteger) _remember  userId:(NSInteger)_userId flag:(NSInteger) _flag;

//+ (id) find:(NSString *) key userId:(NSInteger)userId;
- (BOOL) alterCollect;
- (BOOL) isExisit;
+ (NSMutableArray *) findWords:(NSInteger)userId;
+ (NSMutableArray *) findDelWords:(NSInteger)userId;
+ (void) deleteWord:(NSString *) key userId:(NSInteger) userId;
+ (void) addCheck:(NSInteger) wordId userId:(NSInteger)_userId;
- (void) addRemember;
+ (NSInteger) findLastId;
+ (VOAWord *) findById:(NSInteger) wordId userId:(NSInteger) userId;
+ (void) updateBykey:(NSString *) key audio:(NSString *) _audio pron:(NSString *) _pron def:(NSString *) _def userId:(NSInteger) _userId;
+ (void) updateFlgByKey:(NSString *) key userId:(NSInteger) _userId;
- (void) update;
//+ (NSInteger) findCountByUserId:(NSInteger)userId;
+ (void) deleteByKey:(NSString *) key userId:(NSInteger) userId;
+ (void) deleteByUserId:(NSInteger) userId;
+ (void) deleteSynchro:(NSInteger) userId;
+ (void) clearSynchro;
- (void) alterSynchroCollect;
@end
