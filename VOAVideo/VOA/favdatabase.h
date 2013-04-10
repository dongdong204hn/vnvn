//
//  favdatabase.h
//  VOA
//
//  Created by song zhao on 12-2-8.
//  Copyright (c) 2012年 buaa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PlausibleDatabase/PlausibleDatabase.h>
@interface favdatabase : NSObject
+ (PLSqliteDatabase *) setup;

+ (void) close;
@end
