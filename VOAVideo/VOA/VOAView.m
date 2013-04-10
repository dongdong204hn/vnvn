//
//  VOAView.m
//  VOA
//
//  Created by song zhao on 12-2-3.
//  Copyright (c) 2012年 buaa. All rights reserved.
//


#import "VOAView.h"
#import "database.h"

@implementation VOAView

@synthesize _voaid;
@synthesize _title;
@synthesize _descCn;
@synthesize _descJp;
@synthesize _title_Cn;
@synthesize _title_Jp;
@synthesize _category;
@synthesize _sound;
@synthesize _url;
@synthesize _pic;
@synthesize _creatTime;
@synthesize _publishTime;
@synthesize _readCount;
@synthesize _hotFlg;
@synthesize _isRead;
@synthesize _downloading;
//@synthesize _title_jp;
//@synthesize _collect;

- (id) initWithVoaId:(NSInteger ) voaid title:(NSString *) title descCn:(NSString *) descCn descJp:(NSString *) descJp title_Cn:(NSString *)title_Cn  title_Jp:(NSString *) title_Jp category:(NSString *) category sound:(NSString *) sound url:(NSString *) url pic:(NSString *) pic creatTime:(NSString *) creatTime publishTime:(NSString *) publishTime readcount:(NSString *) readCount hotFlg:(NSString *) hotFlg  isRead:(NSString *) isRead{
	if (self = [super init]) {
		_voaid = voaid;
        _title = [title retain];
        _descCn = [descCn retain];
        _descJp = [descJp retain];
        _title_Cn = [title_Cn retain];
        _title_Jp = [title_Jp retain];
        _category = [category retain];
        _sound = [sound retain];
        _url = [url retain];
        _pic = [pic retain];
        _creatTime = [creatTime retain];
        _pulishTime = [publishTime retain];
        _readCount = [readCount retain];
        _hotFlg = [hotFlg retain];
        _isRead = [isRead retain];
//        _title_cn = [title_cn retain];
//        _title_jp = [title_jp retain];
//        _collect = [collect retain];
	}
	return self;
}

- (BOOL) insert
{
    PLSqliteDatabase *dataBase = [database setup];
    //    const char *myDate = [date UTF8String];//NSString转变为字符数组
    //    date 显示为 2011-11-01%2012:12:12
	NSString *findSql = [NSString stringWithFormat:@"insert into bbc(voaid,Title,DescCn,DescJp,Title_jp,Title_cn,Category,sound,Url,Pic,CreatTime,PublishTime,ReadCount,HotFlg,IsRead) values(%d,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%@,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",%@,%@,%@) ;",self._voaid,self._title,self._descCn,self._descJp,self._title_Jp,self._title_Cn,self._category,self._sound,self._url,self._pic,self._creatTime,self._publishTime,self._readCount,self._hotFlg,self._isRead];
    
	if([dataBase executeUpdate:findSql]) {
//        NSLog(@"--success!");
        return YES;
	}
	else {
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[errAlert show];
//        [errAlert release];
	}
    return NO;
}


 
 
+ (NSArray *) findNew:(NSInteger)offset  newVoas:(NSMutableArray *) newVoas{
	PLSqliteDatabase *dataBase = [database setup];
	
	id<PLResultSet> rs;
    NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM bbc ORDER BY voaid desc LIMIT 10 offset %d;",offset];
	rs = [dataBase executeQuery:findSql];
//    NSLog(@"sql:%@",findSql);
    
    
	//定义一个数组存放所有信息
//	NSMutableArray *voaViews = [[NSMutableArray alloc] init];
	
	//把rs中的数据库信息遍历到voaViews数组
	while ([rs next]) {
        NSInteger voaid = [rs intForColumn:@"voaid"];
        NSString *title = [rs objectForColumn:@"title"];
        NSString *descCn = [rs objectForColumn:@"descCn"];
        NSString *descJp = [rs objectForColumn:@"descJp"];
        NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
        NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
        NSString *category = [rs objectForColumn:@"category"];
        NSString *sound = [rs objectForColumn:@"sound"];
        NSString *url = [rs objectForColumn:@"url"];
        NSString *pic = [rs objectForColumn:@"pic"];
//        NSString *creatTime = [rs objectForColumn:@"creatTime"];
        NSString *publishTime = [rs objectForColumn:@"publishTime"];
        NSString *readCount = [rs objectForColumn:@"readCount"];
        NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
        NSString *isRead = [rs objectForColumn:@"isRead"];
        NSString *creatTime = nil;
        NSString *regEx = @"\\S+";
        for(NSString *matchOne in [[rs objectForColumn:@"creatTime"] componentsMatchedByRegex:regEx]) {
            creatTime = matchOne;
            break;
        }
//        NSString *title_cn = [rs objectForColumn:@"Title_cn"];
//        NSString *title_jp = [rs objectForColumn:@"title_jp"];
        //		NSString *collect = [rs objectForColumn:@"collect"];
        
        VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];
//		[voaViews addObject:voaView];
		[newVoas addObject:voaView];
		[voaView release],voaView = nil;  
	}
	//关闭数据库
	[rs close];
    //	[dataBase close];//
	return newVoas;
}

+ (NSArray *) findNewByCategory:(NSInteger)offset category:(NSInteger)category myArray:(NSMutableArray *) myArray{
	PLSqliteDatabase *dataBase = [database setup];
	
	id<PLResultSet> rs;
    NSString *findSql = [NSString stringWithFormat:@"SELECT * FROM bbc where category = %d ORDER BY voaid desc LIMIT 10 offset %d;",category,offset];
	rs = [dataBase executeQuery:findSql];
//    NSLog(@"sql:%@",findSql);
    
    
	//定义一个数组存放所有信息
//	NSMutableArray *voaViews = [[NSMutableArray alloc] init];
	
	//把rs中的数据库信息遍历到voaViews数组
	while ([rs next]) {
        NSInteger voaid = [rs intForColumn:@"voaid"];
        NSString *title = [rs objectForColumn:@"title"];
        NSString *descCn = [rs objectForColumn:@"descCn"];
        NSString *descJp = [rs objectForColumn:@"descJp"];
        NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
        NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
        NSString *category = [rs objectForColumn:@"category"];
        NSString *sound = [rs objectForColumn:@"sound"];
        NSString *url = [rs objectForColumn:@"url"];
        NSString *pic = [rs objectForColumn:@"pic"];
//        NSString *creatTime = [rs objectForColumn:@"creatTime"];
        NSString *publishTime = [rs objectForColumn:@"publishTime"];
        NSString *readCount = [rs objectForColumn:@"readCount"];
        NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
        NSString *isRead = [rs objectForColumn:@"isRead"];
        NSString *creatTime = nil;
        NSString *regEx = @"\\S+";
        for(NSString *matchOne in [[rs objectForColumn:@"creatTime"] componentsMatchedByRegex:regEx]) {
            creatTime = matchOne;
            break;
        }
        
        VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];
		[myArray addObject:voaView];
		
		[voaView release],voaView = nil;  
	}
	//关闭数据库
	[rs close];
    //	[dataBase close];//
	return myArray;
}

//根据voaid获取对象的方法
+ (id) find:(NSInteger ) voaid{
	PLSqliteDatabase *dataBase = [database setup];
//    const char *myVoaid = [voaid UTF8String];//NSString转变为字符数组
//    int myVoaid = voaid.intValue;//NSString转变为整型
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select * FROM bbc WHERE voaid = %d", voaid];
	rs = [dataBase executeQuery:findSql];
	
	VOAView *voaView = nil;
	
	if([rs next]) {
        NSInteger voaid = [rs intForColumn:@"voaid"];
        NSString *title = [rs objectForColumn:@"title"];
        NSString *descCn = [rs objectForColumn:@"descCn"];
        NSString *descJp = [rs objectForColumn:@"descJp"];
        NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
        NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
        NSString *category = [rs objectForColumn:@"category"];
        NSString *sound = [rs objectForColumn:@"sound"];
        NSString *url = [rs objectForColumn:@"url"];
        NSString *pic = [rs objectForColumn:@"pic"];
//        NSString *creatTime = [rs objectForColumn:@"creatTime"];
        NSString *publishTime = [rs objectForColumn:@"publishTime"];
        NSString *readCount = [rs objectForColumn:@"readCount"];
        NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
        NSString *isRead = [rs objectForColumn:@"isRead"];
        NSString *creatTime = nil;
        NSString *regEx = @"\\S+";
        for(NSString *matchOne in [[rs objectForColumn:@"creatTime"] componentsMatchedByRegex:regEx]) {
            creatTime = matchOne;
            break;
        }
        
        voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];//接收返回值的变量会释放这块内存
	}
	else {
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[errAlert show];
	}
	
	[rs close];
//	[dataBase close];//
	return voaView;	
}



+ (BOOL) isSimilar:(NSInteger) voaid search:(NSString *) search
{
    PLSqliteDatabase *dataBase = [database setup];
	id<PLResultSet> rs;
    NSString *nowSearch = [[NSString alloc] initWithFormat:@"\"%%%@%%\"", search];
//    NSLog(@"%@", nowSearch);
	NSString *findSql = [NSString stringWithFormat:@"select * FROM bbcdetail WHERE voaid = %d and sentence like %@ order by paraid ", voaid, nowSearch];
//    NSLog(@"%@", findSql);
	rs = [dataBase executeQuery:findSql];
	if ([rs next]) {
//        NSString *sentence = [rs objectForColumn:@"sentence"];
//        NSLog(@"%@", sentence);
        [rs close];
        return YES;
	}	
	[nowSearch release];
	return NO;	
}

+ (NSString *) getTitleContent:(NSInteger) voaid search:(NSString *) search
{
    PLSqliteDatabase *dataBase = [database setup];
	id<PLResultSet> rs;
    NSString *findSql = [NSString stringWithFormat:@"select title FROM bbc WHERE voaid = %d;", voaid];
	rs = [dataBase executeQuery:findSql];
    NSString *sentence = @"";
	if ([rs next]) {
        sentence = [rs objectForColumn:@"title"];
//        content = [content stringByAppendingString: sentence];
	}
    
	[rs close];
	return sentence;
}

+ (NSString *) getContent:(NSInteger) voaid search:(NSString *) search
{
    PLSqliteDatabase *dataBase = [database setup];
	id<PLResultSet> rs;
    NSString *findSql = [NSString stringWithFormat:@"select sentence FROM bbcdetail WHERE voaid = %d order by paraid ", voaid];
	rs = [dataBase executeQuery:findSql];
    NSString *content = @"";
	while ([rs next]) {
        NSString *sentence = [rs objectForColumn:@"sentence"];
        content = [content stringByAppendingString: sentence];
	}
    
	[rs close];
	return content;
}

+ (int) numberOfMatch:(NSString *) sentence search:(NSString *)search
{
//    NSMutableString *source = [[NSMutableString alloc] init];
    NSMutableString *source = [NSMutableString stringWithString:sentence]; 
    NSRange substr = [source rangeOfString:search options:NSCaseInsensitiveSearch];   
    int number = 0;
    while (substr.location != NSNotFound) { 
//        NSLog(@"有！");
        [source replaceCharactersInRange:substr withString:@""]; 
        substr = [source rangeOfString:search options:NSCaseInsensitiveSearch]; 
        number++;
    } //字符串查找,可以判断字符串中是否有 
//       NSLog(@"%d", number);
    return number;
}


+ (NSArray *) findFavSimilar:(NSArray *) favsArray search:(NSString *) search 
{
    
    NSMutableArray *voaContents = [[NSMutableArray alloc] init];
    //    voaContents = nil;
    VOAView *voa = nil;
    NSInteger titleNum = 0;
    NSInteger number = 0;
    for (VOAFav *fav in favsArray) {
//        NSLog(@"%d", fav._voaid);
        voa = [VOAView find:fav._voaid];
        //		[voasArray addObject:voa];
        if ([self isSimilar:voa._voaid search:search]) {
            NSString *content = [self getContent:voa._voaid search:search];
            NSString *titleCon = [self getTitleContent:voa._voaid search:search];
            //            NSLog(@"%@", content);
            number = [self numberOfMatch:content search:search];
            titleNum = [self numberOfMatch:titleCon search:search];
            VOAContent *voaContent = [[VOAContent alloc] initWithVoaId:voa._voaid content:content title:[voa _title] creattime:[voa _creatTime] pic:[voa _pic] number:number titleNum:titleNum];
            [voaContents addObject:voaContent];
            [voaContent release], voaContent = nil;
        }
    }
    [voa release];
    [voaContents sortUsingSelector:@selector(compareNumber:)];//对数组进行排序 
    return voaContents;
    //    return [self QuickSort:voaContents left:0 right:([voaContents count]-1)];
    //    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setProgress:) userInfo: repeats:<#(BOOL)#>]
    //    
}

+ (NSInteger) findLastId
{
    PLSqliteDatabase *dataBase = [database setup];
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select max(voaid) last from bbc"];
	rs = [dataBase executeQuery:findSql];
    NSString *last = @"0";
	if([rs next]) {
        last = [rs objectForColumn:@"last"];
//        NSLog(@"%@", last);
	}
	else {
//		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Can not find!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[errAlert show];
        return 0;
	}	
	[rs close];
    //	[dataBase close];//
	return last.integerValue;	

}

+ (void) alterRead:(NSInteger)voaid
{
    PLSqliteDatabase *dataBase = [database setup];
    if ([self find:voaid]) {
        NSString *findSql = [NSString stringWithFormat:@"update bbc set IsRead = 1 WHERE voaid = %d ;",voaid];
        if([dataBase executeUpdate:findSql]) {
//            NSLog(@"--success!");
        }
        else {
//            UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//            [errAlert show];
        }
    }
}



+ (void) alterDownload:(NSInteger)voaid
{
    PLSqliteDatabase *dataBase = [database setup];
    if ([self find:voaid]) {
        NSString *findSql = [NSString stringWithFormat:@"update bbc set Downloading = 1 WHERE voaid = %d ;",voaid];
        if([dataBase executeUpdate:findSql]) {
//            NSLog(@"--success!");
        }
    }
}

+ (void) deleteByVoaid:(NSInteger)voaid {
//    NSLog(@"删除标题-%d",voaid);
    PLSqliteDatabase *dataBase = [database setup];
    if ([self find:voaid]) {
        NSString *findSql = [NSString stringWithFormat:@"delete from bbc where voaid = %d ;",voaid];
        if([dataBase executeUpdate:findSql]) {
            //            NSLog(@"--success!");
        }
    }
}

+ (void) clearDownload:(NSInteger)voaid
{
    PLSqliteDatabase *dataBase = [database setup];
    if ([self find:voaid]) {
        NSString *findSql = [NSString stringWithFormat:@"update bbc set Downloading = 0 WHERE voaid = %d ;",voaid];
        if([dataBase executeUpdate:findSql]) {
//            NSLog(@"--success!");
        }
    }
}

+ (void) clearAllDownload
{
    PLSqliteDatabase *dataBase = [database setup];
    NSString *findSql = @"update bbc set Downloading = 0 WHERE Downloading = 1;";
    if([dataBase executeUpdate:findSql]) {
        //            NSLog(@"--success!");
    }
}

+ (BOOL) isDownloading:(NSInteger)voaid
{
    PLSqliteDatabase *dataBase = [database setup];
    id<PLResultSet> rs;
    NSString *findSql = [NSString stringWithFormat:@"select Downloading FROM bbc WHERE voaid = %d", voaid];
    rs = [dataBase executeQuery:findSql];
    BOOL downLoad = NO;
    if([rs next]) {
        NSString *Downloading = [rs objectForColumn:@"Downloading"];
        downLoad = [Downloading isEqualToString:@"1"];
    }
    
    [rs close];
    return downLoad;
}


+ (BOOL) isExist:(NSInteger) voaid{
    PLSqliteDatabase *dataBase = [database setup];
    
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select * FROM bbc WHERE voaid = %d", voaid];
	rs = [dataBase executeQuery:findSql];
	BOOL flg = NO;
	if([rs next]) {
        flg = YES;
	}
	else {
	}
	
	[rs close];
	return flg;	
}

+ (NSArray *) getWordByVoaid: (NSInteger) Voaid{
    PLSqliteDatabase *dataBase = [database setup];
    id<PLResultSet>rs;
    rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from bbcwords WHERE Voaid = %d",Voaid]];
    
    NSMutableArray *WordsAndDef = [[NSMutableArray alloc] init];
    
    while([rs next]){
        NSString * _Words = [rs objectForColumn:@"Words"];
        NSString *_Def = [rs objectForColumn:@"Def"];
        
        
        [WordsAndDef addObject:_Words];
        [WordsAndDef addObject: _Def];
    }
    [rs close];
    return WordsAndDef;
}

+ (NSString *) getQueByVoaid : (NSInteger) Voaid{
    PLSqliteDatabase *dataBase = [database setup];
    id<PLResultSet>rs;
    NSString *findSql = [NSString stringWithFormat:@"select Question from bbcanswer WHERE Voaid = %d",Voaid];
    rs = [dataBase executeQuery:findSql];
    
    NSString * _Question = [[NSString alloc]init];
    if([rs next]) {
         _Question = [rs objectForColumn:@"Question"];
    }
    [rs close];
    return _Question;
    
}

+ (NSArray *) getAnsByVoaid: (NSInteger) Voaid{
    PLSqliteDatabase *dataBase = [database setup];
    id<PLResultSet>rs;
    rs = [dataBase executeQuery:[NSString stringWithFormat:@"select * from bbcanswer WHERE Voaid = %d",Voaid]];
    
    NSMutableArray *answers = [[NSMutableArray alloc] init];
    
    while([rs next]){
        //         NSInteger  _Voaid = [rs intForColumn:@"Voaid"];
        NSString * _Answer1 = [rs objectForColumn:@"Answer1"];
        NSString * _Answer2 = [rs objectForColumn:@"Answer2"];
        NSString * _Answer3 = [rs objectForColumn:@"Answer3"];
        //        BBCanswer *answer = [[BBCanswer alloc]initWithVoaid:_Voaid Answer1:_Answer1 Answer2 : _Answer2 Answer3:_Answer3];
        //  NSLog(@"%@",_Answer1);
        [answers addObject:_Answer1];
        [answers addObject:_Answer2];
        [answers addObject:_Answer3];
    }
    [rs close];
    return answers;
}

+ (NSInteger) getRightByVoaid : (NSInteger) Voaid{
    PLSqliteDatabase *dataBase = [database setup];
	id<PLResultSet> rs;
	NSString *findSql = [NSString stringWithFormat:@"select Answer from bbcanswer where Voaid = %d",Voaid];
	rs = [dataBase executeQuery:findSql];
    
    NSString *RightAnswer = nil;
    NSInteger Right = 0;
    
	if([rs next]) {
        RightAnswer = [rs objectForColumn :@"Answer"];
        if ([RightAnswer isEqualToString:@"A"] || [RightAnswer isEqualToString:@"a"])
        {Right = 1;}
        else {
            if ([RightAnswer isEqualToString:@"B"] || [RightAnswer isEqualToString:@"b"])
            {Right = 2;}
            else {
                if ([RightAnswer isEqualToString:@"C"] || [RightAnswer isEqualToString:@"c"])
                {Right = 3;}
            }
            
        }
        
	}
    [rs close];
	return Right;
}

+ (BOOL) insertQuesTion:(NSInteger)voaid que:(NSString *)que answerOne:(NSString*)answerOne answerTwo:(NSString*)answerTwo answerThree:(NSString*)answerThree answer:(NSString*)answer
{
    PLSqliteDatabase *dataBase = [database setup];
    //    const char *myDate = [date UTF8String];//NSString转变为字符数组
    //    date 显示为 2011-11-01%2012:12:12
	NSString *findSql = [NSString stringWithFormat:@"insert into bbcanswer(voaid,IndexId,Question,Answer1,Answer2,Answer3,Answer) values(%d, 1,\"%@\",\"%@\",\"%@\",\"%@\",\"%@\") ;", voaid, que, answerOne, answerTwo, answerThree, answer];
    
	if([dataBase executeUpdate:findSql]) {
        //        NSLog(@"--success!");
        return YES;
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
        //        [errAlert release];
	}
    return NO;
}

+ (BOOL) insertWords:(NSInteger)voaid indexId:(NSInteger)indexId word:(NSString*)word def:(NSString*)def 
{
    PLSqliteDatabase *dataBase = [database setup];
    //    const char *myDate = [date UTF8String];//NSString转变为字符数组
    //    date 显示为 2011-11-01%2012:12:12
	NSString *findSql = [NSString stringWithFormat:@"insert into bbcwords(voaid,IndexId,Words,Def) values(%d, %d,\"%@\",\"%@\") ;", voaid, indexId, word, def];
    
	if([dataBase executeUpdate:findSql]) {
        //        NSLog(@"--success!");
        return YES;
	}
	else {
        //		UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"Update failture!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //		[errAlert show];
        //        [errAlert release];
	}
    return NO;
}

+ (NSArray *) getList:(NSMutableArray *)listArray
{
    PLSqliteDatabase *dataBase = [database setup];
    id<PLResultSet>rs;
    rs = [dataBase executeQuery:[NSString stringWithFormat:@"select voaid from bbc order by voaid desc"]];
    [listArray removeAllObjects];
    while([rs next]){
        NSString * temp = [rs objectForColumn:@"voaid"];
//        NSLog(@"song id:%@", temp);
        [listArray addObject:temp];
    }
    [rs close];
    return listArray;
}

+ (void) updateData:(NSInteger)voaid
{
    PLSqliteDatabase *dataBase = [database setup];
    //    const char *myDate = [date UTF8String];//NSString转变为字符数组
    //    date 显示为 2011-11-01%2012:12:12
    int i = 1;
    for (; i <= voaid; i++) {
        NSString *findSql = [NSString stringWithFormat:@"update bbc set Pic = \"%@\" WHERE voaid = %d ;", [NSString stringWithFormat:@"http://static.iyuba.com/images/minutes/%i.jpg", i],i];
        if([dataBase executeUpdate:findSql]) {
            //            NSLog(@"--success!");
        }
    }
}

+ (NSArray *) getList:(NSMutableArray *)listArray category:(NSInteger)category
{
    PLSqliteDatabase *dataBase = [database setup];
    id<PLResultSet>rs;
    NSLog(@"获取列表:%i", category);
    if (category > 0) {
        rs = [dataBase executeQuery:[NSString stringWithFormat:@"select voaid from bbc where category = %i order by voaid desc", category]];
    } else {
        rs = [dataBase executeQuery:[NSString stringWithFormat:@"select voaid from bbc order by voaid desc"]];
    }
    [listArray removeAllObjects];
    while([rs next]){
        NSString * temp = [rs objectForColumn:@"voaid"];
        [listArray addObject:temp];
    }
    [rs close];
    return listArray;
}

+ (BOOL) isRead:(NSInteger)voaid
{
    PLSqliteDatabase *dataBase = [database setup];
    id<PLResultSet> rs;
    NSString *findSql = [NSString stringWithFormat:@"select IsRead FROM bbc WHERE voaid = %d", voaid];
    rs = [dataBase executeQuery:findSql];
    BOOL isRead = NO;
    if([rs next]) {
        NSString *Downloading = [rs objectForColumn:@"IsRead"];
        isRead = [Downloading isEqualToString:@"1"];
    }
    
    [rs close];
    return isRead;
}

//+ (NSArray *) getListBeforeVoaid:(NSInteger)voaid listArray:(NSMutableArray *)listArray
//{
//    PLSqliteDatabase *dataBase = [database setup];
//    id<PLResultSet>rs;
//    rs = [dataBase executeQuery:[NSString stringWithFormat:@"select voaid from bbcanswer where Voaid <= %i order by voaid desc",voaid]];
//    [listArray removeAllObjects];
//    while([rs next]){
//        //         NSInteger  _Voaid = [rs intForColumn:@"Voaid"];
//        NSString * temp = [rs objectForColumn:@"voaid"];
//        //        BBCanswer *answer = [[BBCanswer alloc]initWithVoaid:_Voaid Answer1:_Answer1 Answer2 : _Answer2 Answer3:_Answer3];
//        //  NSLog(@"%@",_Answer1);
//        [listArray addObject:temp];
//    }
//    [rs close];
//    return listArray;
//}

/*
 + (NSArray *) findDateByCategory:(NSString *) category
 {
 PLSqliteDatabase *dataBase = [database setup];
 
 id<PLResultSet> rs;
 rs = [dataBase executeQuery:[NSString stringWithFormat:@"SELECT distinct creattime FROM voa WHERE category = %@  ORDER BY CreatTime desc ", category]];
 
 //定义一个数组存放所有信息
 NSMutableArray *dates = [[NSMutableArray alloc] init];
 
 NSString *buffer = @"";
 
 //把rs中的数据库信息遍历到voaViews数组
 while ([rs next]) {
 //        NSString *voaid = [rs objectForColumn:@"voaid"];
 //        NSString *title = [rs objectForColumn:@"title"];
 //        NSString *descCn = [rs objectForColumn:@"descCn"];
 //        NSString *descJp = [rs objectForColumn:@"descJp"];
 //        NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 //        NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 //        NSString *category = [rs objectForColumn:@"category"];
 //        NSString *sound = [rs objectForColumn:@"sound"];
 //        NSString *url = [rs objectForColumn:@"url"];
 //        NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 //        NSString *publishTime = [rs objectForColumn:@"publishTime"];
 //        NSString *readCount = [rs objectForColumn:@"readCount"];
 //        NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 //        NSString *title_cn = [rs objectForColumn:@"title_cn"];
 //        NSString *title_jp = [rs objectForColumn:@"title_jp"];
 //		NSString *collect = [rs objectForColumn:@"collect"];
 
 //        VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg ];
 //        NSLog(@"%@", creatTime);
 //        NSString *regEx = @"{3}-[0-9]{3}-[0-9]{4}";
 NSString *regEx = @"[0-9]{4}-[0-9]{2}";
 //        for(NSString *matchOne in [creatTime componentsMatchedByRegex:regEx]) {
 //            NSLog(@"正则后one： %@", matchOne);
 //            [dates addObject:creatTime];
 //        }
 NSString *matchTwo = [creatTime stringByMatching:regEx];
 if ([buffer isEqualToString:matchTwo] == NO) {
 buffer = matchTwo;
 //            NSLog(@"正则后two： %@", matchTwo);
 [dates addObject:matchTwo];
 }
 
 }
 //关闭数据库
 [rs close];
 //	[dataBase close];//
 return dates;
 
 }*/

/*
 + (NSArray *) findDate
 {
 PLSqliteDatabase *dataBase = [database setup];
 
 id<PLResultSet> rs;
 rs = [dataBase executeQuery:@"SELECT distinct creattime FROM voa ORDER BY CreatTime desc "];
 
 //定义一个数组存放所有信息
 NSMutableArray *dates = [[NSMutableArray alloc] init];
 
 NSString *buffer = @"";
 
 //把rs中的数据库信息遍历到voaViews数组
 while ([rs next]) {
 //        NSString *voaid = [rs objectForColumn:@"voaid"];
 //        NSString *title = [rs objectForColumn:@"title"];
 //        NSString *descCn = [rs objectForColumn:@"descCn"];
 //        NSString *descJp = [rs objectForColumn:@"descJp"];
 //        NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 //        NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 //        NSString *category = [rs objectForColumn:@"category"];
 //        NSString *sound = [rs objectForColumn:@"sound"];
 //        NSString *url = [rs objectForColumn:@"url"];
 //        NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 //        NSString *publishTime = [rs objectForColumn:@"publishTime"];
 //        NSString *readCount = [rs objectForColumn:@"readCount"];
 //        NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 //        NSString *title_cn = [rs objectForColumn:@"title_cn"];
 //        NSString *title_jp = [rs objectForColumn:@"title_jp"];
 //		NSString *collect = [rs objectForColumn:@"collect"];
 
 //        VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg ];
 //        NSLog(@"%@", creatTime);
 //        NSString *regEx = @"{3}-[0-9]{3}-[0-9]{4}";
 NSString *regEx = @"[0-9]{4}-[0-9]{2}";
 //        for(NSString *matchOne in [creatTime componentsMatchedByRegex:regEx]) {
 //            NSLog(@"正则后one： %@", matchOne);
 //            [dates addObject:creatTime];
 //        }
 NSString *matchTwo = [creatTime stringByMatching:regEx];
 if ([buffer isEqualToString:matchTwo] == NO) {
 buffer = matchTwo;
 //            NSLog(@"正则后two： %@", matchTwo);
 [dates addObject:matchTwo];
 }
 
 }
 //关闭数据库
 [rs close];
 //	[dataBase close];//
 return dates;
 
 }*/

/*
 + (NSArray *) findByDate:(NSString *) Date
 {
 PLSqliteDatabase *dataBase = [database setup];
 //    const char *myVoaid = [voaid UTF8String];//NSString转变为字符数组
 //    int myVoaid = voaid.intValue;//NSString转变为整型
 id<PLResultSet> rs;
 NSString *findSql = [NSString stringWithFormat:@"select * FROM voa ORDER BY voaid desc "];
 rs = [dataBase executeQuery:findSql];
 NSMutableArray *voaViews = [[NSMutableArray alloc] init];
 NSString *regEx = @"[0-9]{4}-[0-9]{2}";
 while([rs next]) {
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *matchTwo = [creatTime stringByMatching:regEx];
 //        NSLog(@"正则后two： %@", matchTwo);
 
 if ([matchTwo isEqualToString:Date]) {
 //            NSLog(@"--->正则后two： %@", matchTwo);
 NSInteger voaid = [rs intForColumn:@"voaid"];
 NSString *title = [rs objectForColumn:@"title"];
 NSString *descCn = [rs objectForColumn:@"descCn"];
 NSString *descJp = [rs objectForColumn:@"descJp"];
 NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 NSString *category = [rs objectForColumn:@"category"];
 NSString *sound = [rs objectForColumn:@"sound"];
 NSString *url = [rs objectForColumn:@"url"];
 NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *publishTime = [rs objectForColumn:@"publishTime"];
 NSString *readCount = [rs objectForColumn:@"readCount"];
 NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 NSString *isRead = [rs objectForColumn:@"isRead"];
 VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];
 [voaViews addObject:voaView];
 
 [voaView release];  
 }
 
 }
 
 [rs close];
 //	[dataBase close];//
 return voaViews;	
 
 }*/

/*
 + (NSInteger) findNumberByDate:(NSString *) Date
 {
 PLSqliteDatabase *dataBase = [database setup];
 id<PLResultSet> rs;
 NSInteger number = 0;
 NSString *findSql = [NSString stringWithFormat:@"select * FROM voa ORDER BY voaid desc "];
 rs = [dataBase executeQuery:findSql];
 NSString *regEx = @"[0-9]{4}-[0-9]{2}";
 while([rs next]) {
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *matchTwo = [creatTime stringByMatching:regEx];
 if ([matchTwo isEqualToString:Date]) {
 number++;
 }
 }
 [rs close];
 return number;
 }*/

/*
 + (NSArray *) findAll{
 PLSqliteDatabase *dataBase = [database setup];
 
 id<PLResultSet> rs;
 rs = [dataBase executeQuery:@"SELECT * FROM voa ORDER BY voaid desc "];
 
 //定义一个数组存放所有信息
 NSMutableArray *voaViews = [[NSMutableArray alloc] init];
 
 //把rs中的数据库信息遍历到voaViews数组
 while ([rs next]) {
 NSInteger voaid = [rs intForColumn:@"voaid"];
 NSString *title = [rs objectForColumn:@"title"];
 NSString *descCn = [rs objectForColumn:@"descCn"];
 NSString *descJp = [rs objectForColumn:@"descJp"];
 NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 NSString *category = [rs objectForColumn:@"category"];
 NSString *sound = [rs objectForColumn:@"sound"];
 NSString *url = [rs objectForColumn:@"url"];
 NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *publishTime = [rs objectForColumn:@"publishTime"];
 NSString *readCount = [rs objectForColumn:@"readCount"];
 NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 NSString *isRead = [rs objectForColumn:@"isRead"];
 //        NSString *title_cn = [rs objectForColumn:@"title_cn"];
 //        NSString *title_jp = [rs objectForColumn:@"title_jp"];
 //		NSString *collect = [rs objectForColumn:@"collect"];
 
 VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];
 [voaViews addObject:voaView];
 
 [voaView release];  
 }
 //关闭数据库
 [rs close];
 //	[dataBase close];//
 return voaViews;
 }*/

/*
 + (NSArray *) findAfterByCategory:(NSInteger)voaid
 {
 PLSqliteDatabase *dataBase = [database setup];
 
 id<PLResultSet> rs;
 NSString *findSql = [NSString stringWithFormat:@"select * from voa where voaid <%d ORDER BY voaid desc ",voaid];
 rs = [dataBase executeQuery:findSql];
 //    NSLog(@"sql:%@",findSql);
 
 
 //定义一个数组存放所有信息
 NSMutableArray *voaViews = [[NSMutableArray alloc] init];
 
 //把rs中的数据库信息遍历到voaViews数组
 while ([rs next]) {
 NSInteger voaid = [rs intForColumn:@"voaid"];
 NSString *title = [rs objectForColumn:@"title"];
 NSString *descCn = [rs objectForColumn:@"descCn"];
 NSString *descJp = [rs objectForColumn:@"descJp"];
 NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 NSString *category = [rs objectForColumn:@"category"];
 NSString *sound = [rs objectForColumn:@"sound"];
 NSString *url = [rs objectForColumn:@"url"];
 NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *publishTime = [rs objectForColumn:@"publishTime"];
 NSString *readCount = [rs objectForColumn:@"readCount"];
 NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 NSString *isRead = [rs objectForColumn:@"isRead"];
 //        NSString *title_cn = [rs objectForColumn:@"Title_cn"];
 //        NSString *title_jp = [rs objectForColumn:@"title_jp"];
 //		NSString *collect = [rs objectForColumn:@"collect"];
 
 VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];
 [voaViews addObject:voaView];
 
 [voaView release];  
 }
 //关闭数据库
 [rs close];
 //	[dataBase close];//
 return voaViews;
 }*/

/*
 + (NSArray *) findVoaBetween:(NSInteger)max mix:(NSInteger)mix
 {
 PLSqliteDatabase *dataBase = [database setup];
 //	NSLog(@"%d %d",max,mix);
 id<PLResultSet> rs;
 NSString *findSql = [NSString stringWithFormat:@"select * from voa where voaid>%d and voaid <=%d ORDER BY voaid desc ",mix,max];
 rs = [dataBase executeQuery:findSql];
 //    NSLog(@"sql:%@",findSql);
 
 
 //定义一个数组存放所有信息
 NSMutableArray *voaViews = [[NSMutableArray alloc] init];
 
 //把rs中的数据库信息遍历到voaViews数组
 while ([rs next]) {
 NSInteger voaid = [rs intForColumn:@"voaid"];
 NSString *title = [rs objectForColumn:@"title"];
 NSString *descCn = [rs objectForColumn:@"descCn"];
 NSString *descJp = [rs objectForColumn:@"descJp"];
 NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 NSString *category = [rs objectForColumn:@"category"];
 NSString *sound = [rs objectForColumn:@"sound"];
 NSString *url = [rs objectForColumn:@"url"];
 NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *publishTime = [rs objectForColumn:@"publishTime"];
 NSString *readCount = [rs objectForColumn:@"readCount"];
 NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 NSString *isRead = [rs objectForColumn:@"isRead"];
 //        NSString *title_cn = [rs objectForColumn:@"Title_cn"];
 //        NSString *title_jp = [rs objectForColumn:@"title_jp"];
 //		NSString *collect = [rs objectForColumn:@"collect"];
 
 VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];
 [voaViews addObject:voaView];
 
 [voaView release];  
 }
 //关闭数据库
 [rs close];
 //	[dataBase close];//
 return voaViews;
 }*/
/*
 + (NSArray *) findByCategory:(NSString *) category{
 PLSqliteDatabase *dataBase = [database setup];
 
 id<PLResultSet> rs;
 //    const char *mycategory = [category UTF8String];//NSString转变为字符数组
 NSString *findSql = [NSString stringWithFormat:@"select * FROM voa WHERE category = %@ order by voaid desc", category           ];
 //    NSString *findSql = [NSString stringWithFormat:@"select voaid to_char(creattime, 'yyyy-MM-dd') y_time from voaview order by y_time ; ", mycategory];
 
 rs = [dataBase executeQuery:findSql];
 
 NSMutableArray *voaViews = [[NSMutableArray alloc] init];
 
 while([rs next]) {
 NSInteger voaid = [rs intForColumn:@"voaid"];
 NSString *title = [rs objectForColumn:@"title"];
 NSString *descCn = [rs objectForColumn:@"descCn"];
 NSString *descJp = [rs objectForColumn:@"descJp"];
 NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 NSString *category = [rs objectForColumn:@"category"];
 NSString *sound = [rs objectForColumn:@"sound"];
 NSString *url = [rs objectForColumn:@"url"];
 NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *publishTime = [rs objectForColumn:@"publishTime"];
 NSString *readCount = [rs objectForColumn:@"readCount"];
 NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 NSString *isRead = [rs objectForColumn:@"isRead"];
 //        NSString *title_cn = [rs objectForColumn:@"title_cn"];
 //        NSString *title_jp = [rs objectForColumn:@"title_jp"];
 //        NSString *collect = [rs objectForColumn:@"collect"];
 
 VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];	
 [voaViews addObject:voaView];
 
 [voaView release];  
 
 }
 
 [rs close];
 //	[dataBase close];//
 return voaViews;	
 }
 
 + (NSArray *) findByCategoryDate:(NSString *) Date category:(NSString *) category
 {
 PLSqliteDatabase *dataBase = [database setup];
 //    const char *myVoaid = [voaid UTF8String];//NSString转变为字符数组
 //    int myVoaid = voaid.intValue;//NSString转变为整型
 id<PLResultSet> rs;
 NSString *findSql = [NSString stringWithFormat:@"select * FROM voa WHERE category = %@ order by voaid desc", category];
 rs = [dataBase executeQuery:findSql];
 NSMutableArray *voaViews = [[NSMutableArray alloc] init];
 NSString *regEx = @"[0-9]{4}-[0-9]{2}";
 while([rs next]) {
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *matchTwo = [creatTime stringByMatching:regEx];
 //        NSLog(@"正则后two： %@", matchTwo);
 
 if ([matchTwo isEqualToString:Date]) {
 //            NSLog(@"--->正则后two： %@", matchTwo);
 NSInteger voaid = [rs intForColumn:@"voaid"];
 NSString *title = [rs objectForColumn:@"title"];
 NSString *descCn = [rs objectForColumn:@"descCn"];
 NSString *descJp = [rs objectForColumn:@"descJp"];
 NSString *title_Cn = [rs objectForColumn:@"title_Cn"];
 NSString *title_Jp = [rs objectForColumn:@"title_Jp"];
 NSString *category = [rs objectForColumn:@"category"];
 NSString *sound = [rs objectForColumn:@"sound"];
 NSString *url = [rs objectForColumn:@"url"];
 NSString *pic = [rs objectForColumn:@"pic"];
 NSString *creatTime = [rs objectForColumn:@"creatTime"];
 NSString *publishTime = [rs objectForColumn:@"publishTime"];
 NSString *readCount = [rs objectForColumn:@"readCount"];
 NSString *hotFlg = [rs objectForColumn:@"hotFlg"];
 NSString *isRead = [rs objectForColumn:@"isRead"];
 VOAView *voaView = [[VOAView alloc] initWithVoaId:voaid title:title descCn:descCn descJp:descJp title_Cn:title_Cn title_Jp:title_Jp category:category sound:sound url:url pic:pic creatTime:creatTime publishTime:publishTime readcount:readCount hotFlg:hotFlg isRead:isRead];
 [voaViews addObject:voaView];
 
 [voaView release];  
 }
 
 }
 
 [rs close];
 //	[dataBase close];//
 return voaViews;	
 
 }*/
/*
 + (BOOL) isTitleSimilar:(NSInteger) voaid search:(NSString *) search
 {
 PLSqliteDatabase *dataBase = [database setup];
 id<PLResultSet> rs;
 NSString *nowSearch = [[NSString alloc] initWithFormat:@"\"%%%@%%\"", search];
 //    NSLog(@"%@", nowSearch);
 NSString *findSql = [NSString stringWithFormat:@"select voaid FROM voa WHERE title like %@;", voaid, nowSearch];
 //    NSLog(@"%@", findSql);
 rs = [dataBase executeQuery:findSql];
 if ([rs next]) {
 //        NSString *sentence = [rs objectForColumn:@"sentence"];
 //        NSLog(@"%@", sentence);
 [rs close];
 return YES;
 }	
 
 return NO;	
 }*/
//+ (NSArray *) QuickSort:(NSArray *) voaContents left:(NSInteger) left right:(NSInteger) right
//{
//    NSInteger i = left;
//    NSInteger j = right;
//    NSInteger middle = 0;
//    NSInteger iTemp = 0;
//    NSLog(@"%d", (left+right)/2);
//    middle = [[voaContents objectAtIndex:(left+right)/2] _number];//求中间值
//    do {
//        while (([[voaContents objectAtIndex:i] _number]<middle)&&(i<right)) {
//            i++;
//        }
//        while (([[voaContents objectAtIndex:j] _number]>middle)&&(j>left)) {
//            j--;
//        }
//        if(i<=j){
//            iTemp = [[voaContents objectAtIndex:i] _number];
//            [[voaContents objectAtIndex:j] set_number:[[voaContents objectAtIndex:i] _number]];
//            [[voaContents objectAtIndex:i] set_number:iTemp];
//            i++;
//            j--;
//        }
//    } while (i<=j);
//    if(left<j){
//        [self QuickSort:voaContents left:left right:j];
//    }
//    //当右边部分有值（right>i），递归右半边
//    if(right>i){
//        [self QuickSort:voaContents left:i right:right];
//    }
//}
//　　int main()
//　　{
//    　　int data[]={10,9,8,7,6,5,4};
//    　　const int count(6);
//    　　QuickSort(data,0,count);
//    　　for(int i(0);i!=7;++i){
//        　　cout<<data[i]<<；“ ”<<flush;
//        　　}
//    　　cout<<endl;
//    　　return 0;
//    　　}

/*
 + (NSArray *) findSimilar:(NSArray *) voasArray search:(NSString *) search 
 {
 
 NSMutableArray *voaContents = [[NSMutableArray alloc] init];
 //    voaContents = nil;
 VOAView *voa =[VOAView alloc];
 NSInteger number = 0;
 NSInteger titleNum = 0;
 for ( voa in voasArray) {
 //        NSLog(@"%d", voa._voaid);
 //		[voasArray addObject:voa];
 if ([self isSimilar:voa._voaid search:search]) {
 NSString *content = [self getContent:voa._voaid search:search];
 NSString *titleCon = [self getTitleContent:voa._voaid search:search];
 //            NSLog(@"%@", content);
 number = [self numberOfMatch:content search:search];
 titleNum = [self numberOfMatch:titleCon search:search];
 VOAContent *voaContent = [[VOAContent alloc] initWithVoaId:voa._voaid content:content title:[voa _title] creattime:[voa _creatTime] pic:[voa _pic] number:number titleNum:titleNum];
 [voaContents addObject:voaContent];
 [voaContent release], voaContent = nil;
 }
 }
 [voa release];
 [voaContents sortUsingSelector:@selector(compareNumber:)];//对数组进行排序 
 return voaContents;
 //    return [self QuickSort:voaContents left:0 right:([voaContents count]-1)];
 //    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(setProgress:) userInfo: repeats:<#(BOOL)#>]
 //    
 }*/

@end
