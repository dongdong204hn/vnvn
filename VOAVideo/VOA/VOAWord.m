//
//  VOAWord.m
//  VOA
//
//  Created by song zhao on 12-2-24.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import "VOAWord.h"
#import "favdatabase.h"

@implementation VOAWord
@synthesize userId;
@synthesize wordId;
@synthesize key;
@synthesize lang;
@synthesize audio;
@synthesize pron;
@synthesize def;
@synthesize date;
@synthesize checks;
@synthesize remember;
@synthesize engArray;
@synthesize chnArray;
@synthesize flag;
@synthesize synchroFlg;
- (id) initWithVOAWord:(NSInteger) _wordId key:(NSString *) _key audio:(NSString *) _audio pron:(NSString *) _pron def:(NSString *) _def date:(NSString *) _date  checks:(NSInteger) _checks remember:(NSInteger) _remember  userId:(NSInteger)_userId flag:(NSInteger) _flag
{
    if (self = [super init]) {
        self.wordId = _wordId;
        self.key = [_key retain];
//        self.lang = [_lang retain];
        self.audio = [_audio retain];
        self.pron = [_pron retain];
        self.def = [_def retain];
        self.date = [_date retain];
        self.checks = _checks;
        self.remember = _remember;
        self.userId = _userId;
        self.flag = _flag;
    }
    return self;
}



//+ (NSArray *) findAll{
//	PLSqliteDatabase *dataBase = [favdatabase setup];
//	
//	id<PLResultSet> rs;
//	rs = [dataBase executeQuery:@"SELECT * FROM fav order by date desc"];
//    
//	//定义一个数组存放所有信息
//	NSMutableArray *voaFavs = [[NSMutableArray alloc] init];
//	
//	//把rs中的数据库信息遍历到voaViews数组
//	while ([rs next]) {
//        NSString *voaid = [rs objectForColumn:@"voaid"];
//        NSString *collect = [rs objectForColumn:@"collect"];
//        NSString *date = [rs objectForColumn:@"date"];
//        //        NSString *title_cn = [rs objectForColumn:@"title_cn"];
//        //        NSString *title_jp = [rs objectForColumn:@"title_jp"];
//        //		NSString *collect = [rs objectForColumn:@"collect"];
//        
//        VOAFav *voaFav = [[VOAFav alloc] initWithVoaId:voaid collect:collect date:date];
//		[voaFavs addObject:voaFav];
//		
//		[voaFav release];  
//	}
//	//关闭数据库
//	[rs close];
//    //	[dataBase close];//
//	return voaFavs;
//}

/*
//根据voaid获取对象的方法
+ (id) find:(NSString *) key userId:(NSInteger)userId{
	PLSqliteDatabase *dataBase = [favdatabase setup];
    //    const char *myVoaid = [voaid UTF8String];//NSString转变为字符数组
    //    int myVoaid = voaid.intValue;//NSString转变为整型
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select * FROM favword WHERE key = \"%@\" and userId= %d" , key, userId];
	rs = [dataBase executeQuery:findSql];
	
	VOAWord *word = nil;
	
	if([rs next]) {
        NSInteger wordId = [rs intForColumn:@"wordId"];
        NSString *key = [rs objectForColumn:@"key"];
//        NSString *lang = [rs objectForColumn:@"lang"];
        NSString *audio = [rs objectForColumn:@"audio"];
        NSString *pron = [rs objectForColumn:@"pron"];
        NSString *def = [rs objectForColumn:@"def"];
        NSString *date = [rs objectForColumn:@"date"];
        NSInteger checks = [rs intForColumn:@"checks"];
        NSInteger remember = [rs intForColumn:@"remember"];
        NSInteger userId = [rs intForColumn:@"userId"];
        NSInteger flag = [rs intForColumn:@"flg"];
        word = [[VOAWord alloc] initWithVOAWord:wordId key:key audio:audio pron:pron def:def date:date checks:checks remember:remember userId:userId flag:flag];
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
	}
	
	[rs close];
    //	[dataBase close];//
	return word;	
}*/

- (BOOL) isExisit
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select * FROM favword WHERE key = \"%@\" and userId = %d ", self.key,self.userId];
	rs = [dataBase executeQuery:findSql];
	
	BOOL myflag = NO;
	
	if([rs next]) {
        myflag = YES;
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
	}
	
	[rs close];
    //	[dataBase close];//
	return myflag;
}

- (BOOL) alterCollect{
    PLSqliteDatabase *dataBase = [favdatabase setup];
    NSString* myDate;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    myDate = [formatter stringFromDate:[NSDate date]];
//    NSLog(@"%@",myDate);
    BOOL flg;
    if (![self isExisit]) {
        NSString *findSql = [NSString stringWithFormat:@"insert into favword(wordId,key,audio,pron,def,date,checks,remember,userId,flg,synchroFlg) values(%d,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%d,%d,%d,1,0);",wordId,key,audio,pron,def,myDate,checks,remember,userId];
        if([dataBase executeUpdate:findSql]) {
//            NSLog(@"--success!");
        }
        else {
            UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [errAlert show];
            [errAlert release];
        }
        flg = YES;
    }else
    {
        UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:kVoaWordOne message:kVoaWordTwo delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [errAlert show];
        [errAlert release];
        flg = NO;
    }
    [formatter release],formatter = nil;
    return flg;
}

+ (void) addCheck:(NSInteger) _wordId userId:(NSInteger)_userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"update favword set checks = checks+1 WHERE wordId = %d and userId = %d ;",_wordId,_userId];
	if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[errAlert show];
//        [errAlert release];
	}
}
- (void) addRemember
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"update favword set remember = remember+1 WHERE key = \"%@\" and userId = %d ;",key, userId];
	if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[errAlert show];
//        [errAlert release];
	}
}

+ (NSMutableArray *) findDelWords:(NSInteger)userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	
	id<PLResultSet> rs;
	rs = [dataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM favword where userId = %d and flg==-1 ", userId]];
    
	//定义一个数组存放所有信息
	NSMutableArray *words = [[NSMutableArray alloc] init];
	
	//把rs中的数据库信息遍历到voaViews数组
	while ([rs next]) {
        NSInteger wordId = [rs intForColumn:@"wordId"];
        NSString *key = [rs objectForColumn:@"key"];
        //        NSString *lang = [rs objectForColumn:@"lang"];
        NSString *audio = [rs objectForColumn:@"audio"];
        NSString *pron = [rs objectForColumn:@"pron"];
        NSString *def = [rs objectForColumn:@"def"];
        NSString *date = [rs objectForColumn:@"date"];
        NSInteger checks = [rs intForColumn:@"checks"];
        NSInteger remember = [rs intForColumn:@"remember"];
        NSInteger userId = [rs intForColumn:@"userId"];
        NSInteger flag = [rs intForColumn:@"flg"];
        VOAWord *word = [[VOAWord alloc] initWithVOAWord:wordId key:key audio:audio pron:pron def:def date:date checks:checks remember:remember userId:userId flag:flag];
		[words addObject:word];
		[word release];  
	}
	//关闭数据库
	[rs close];
    //	[dataBase close];//
	return words;
}

+ (NSArray *) findWords:(NSInteger)userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	
	id<PLResultSet> rs;
	rs = [dataBase executeQuery:[NSString stringWithFormat:@"SELECT * FROM favword where userId = %d and flg>-1 order by remember,checks desc", userId]];
    
	//定义一个数组存放所有信息
	NSMutableArray *words = [[NSMutableArray alloc] init];
	
	//把rs中的数据库信息遍历到voaViews数组
	while ([rs next]) {
        NSInteger wordId = [rs intForColumn:@"wordId"];
        NSString *key = [rs objectForColumn:@"key"];
        //        NSString *lang = [rs objectForColumn:@"lang"];
        NSString *audio = [rs objectForColumn:@"audio"];
        NSString *pron = [rs objectForColumn:@"pron"];
        NSString *def = [rs objectForColumn:@"def"];
        NSString *date = [rs objectForColumn:@"date"];
        NSInteger checks = [rs intForColumn:@"checks"];
        NSInteger remember = [rs intForColumn:@"remember"];
        NSInteger userId = [rs intForColumn:@"userId"];
        NSInteger flag = [rs intForColumn:@"flg"];
        VOAWord *word = [[VOAWord alloc] initWithVOAWord:wordId key:key audio:audio pron:pron def:def date:date checks:checks remember:remember userId:userId flag:flag];
		[words addObject:word];
		[word release];  
	}
	//关闭数据库
	[rs close];
    //	[dataBase close];//
	return words;
}


+ (void) deleteWord:(NSString*) key userId:(NSInteger) userId{
	PLSqliteDatabase *dataBase = [favdatabase setup];
    //	NSString* date;
    //    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"YYYY-MM-dd-HH-mm-ss"];
    //    date = [formatter stringFromDate:[NSDate date]];
    //    NSLog(@"%@",date);
//	NSString *findSql = [NSString stringWithFormat:@"delete from favword WHERE key = \"%@\" and userId = %d ;",key,userId];
    NSString *findSql = [NSString stringWithFormat:@"update favword set flg = -1  WHERE key = \"%@\" and userId = %d ;",key, userId];
	if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[errAlert show];
        [errAlert release];
	}
}

+ (NSInteger) findLastId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select max(wordId) last from favword"];
	rs = [dataBase executeQuery:findSql];
    int last = 0;
	if([rs next]) {
        last = [rs intForColumn:@"last"];
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
	}	
	[rs close];
    //	[dataBase close];//
	return last;	
    
}

+ (VOAWord *) findById:(NSInteger) wordId userId:(NSInteger) userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select * from favword where wordId = %d and userId = %d", wordId,userId];
	rs = [dataBase executeQuery:findSql];
    VOAWord *word = nil;
	if([rs next]) {
        NSInteger wordId = [rs intForColumn:@"wordId"];
        NSString *key = [rs objectForColumn:@"key"];
        //        NSString *lang = [rs objectForColumn:@"lang"];
        NSString *audio = [rs objectForColumn:@"audio"];
        NSString *pron = [rs objectForColumn:@"pron"];
        NSString *def = [rs objectForColumn:@"def"];
        NSString *date = [rs objectForColumn:@"date"];
        NSInteger checks = [rs intForColumn:@"checks"];
        NSInteger remember = [rs intForColumn:@"remember"];
        NSInteger userId = [rs intForColumn:@"userId"];
        NSInteger flag = [rs intForColumn:@"flg"];
        word = [[VOAWord alloc] initWithVOAWord:wordId key:key audio:audio pron:pron def:def date:date checks:checks remember:remember userId:userId flag:flag];
	}
	else {
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[errAlert show];
	}	
	[rs close];
    //	[dataBase close];//
	return word;	
    
}

+ (void) updateBykey:(NSString *) key audio:(NSString *) _audio pron:(NSString *) _pron def:(NSString *) _def userId:(NSInteger) _userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"update favword set pron = \"%@\",audio = \"%@\",def = \"%@\" WHERE key = \"%@\" and userId= %d;",_pron,_audio,_def,key,_userId];
	if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[errAlert show];
//        [errAlert release];
//        NSLog(@"updateById失败。");
	}

}

- (void) update
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"update favword set pron = \"%@\",audio = \"%@\",def = \"%@\" WHERE wordId = %d ;",self.pron,self.audio,self.def,self.wordId];
	if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
        //        [errAlert release];
//        NSLog(@"updateById失败。");
	}
    
}



+ (void) updateFlgByKey:(NSString *) key userId:(NSInteger) _userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"update favword set flg = 0 WHERE key = \"%@\" and userId= %d;",key,_userId];
	if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
        //        [errAlert release];
//        NSLog(@"updateFlgById失败。");
	}
}

/*
+ (NSInteger) findCountByUserId:(NSInteger)userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select count(key) count from favword where userId = %d",userId];
	rs = [dataBase executeQuery:findSql];
    NSInteger count = 0;
	if([rs next]) {
        count = [rs intForColumn:@"count"];
//        NSLog(@"%@", count);
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
	}	
	[rs close];
    //	[dataBase close];//
	return count;	
    
}*/

+ (void) deleteByKey:(NSString *) key userId:(NSInteger) userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"delete from favword where userId = %d and key = \"%@\"",userId,key];
    if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
	}	
    //	[dataBase close];//
}

+ (void) deleteByUserId:(NSInteger) userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"delete from favword where userId = %d",userId];
    if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
	}	
    //	[dataBase close];//
}

+ (void) clearSynchro
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"update favword set synchroFlg = 0;"];
    if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
        
	}
}

- (void) alterSynchroCollect
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
    NSString* myDate;
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    myDate = [formatter stringFromDate:[NSDate date]];
//    NSLog(@"%@",myDate);
    if (![self isExisit]) {
        NSString *findSql = [NSString stringWithFormat:@"insert into favword(wordId,key,audio,pron,def,date,checks,remember,userId,flg,synchroFlg) values(%d,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%d,%d,%d,1,1);",wordId,key,audio,pron,def,myDate,checks,remember,userId];
        if([dataBase executeUpdate:findSql]) {
//            NSLog(@"--success!");
        }
        else {
            
        }
    }else
    {
        NSString *findSql = [NSString stringWithFormat:@"update favword set synchroFlg = 1 WHERE key = \"%@\" and userId= %d;",key,userId];
        if([dataBase executeUpdate:findSql]) {
//            NSLog(@"--success!");
        }
    }
    [formatter release],formatter = nil;
}

+ (void) deleteSynchro:(NSInteger) userId
{
    PLSqliteDatabase *dataBase = [favdatabase setup];
	NSString *findSql = [NSString stringWithFormat:@"delete from favword where synchroFlg = 0 and userId = %d;", userId];
    if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
	}
}

@end
