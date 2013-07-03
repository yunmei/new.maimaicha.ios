//
//  UserModel.m
//  newMaimaicha
//
//  Created by ken on 13-7-3.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "UserModel.h"
#import "YMDbClass.h"
@implementation UserModel
@synthesize session;
@synthesize userId;
//创建表goodslist_car
+(void)creatTable
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [db exec:@"CREATE TABLE IF NOT EXISTS user('userId','session');"];
        [db close];
    }
}

+ (BOOL)checkLogin
{
    UserModel *userModel = [UserModel getUserModel];
    if (userModel.session && userModel.userId) {
        return true;
    } else {
        return false;
    }
}

+ (void)clearTable
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [db exec:@"delete from user;"];
        [db close];
    }
}

+ (UserModel *)getUserModel
{
    UserModel *userModel = [[UserModel alloc]init];
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc]init];
        dictionary = [db fetchOne:@"select * from user"];
        userModel.userId = [dictionary objectForKey:@"userId"];
        userModel.session = [dictionary objectForKey:@"session"];
        [db close];
    }
    return userModel;
}
+(void)dropTable
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [db exec:@"drop table if exists user;"];
        [db close];
    }
}

- (BOOL)addUser
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [UserModel clearTable];
        NSString *sql = [NSString stringWithFormat:@"insert into user values ('%@','%@');", self.userId, self.session];
        if([db exec:sql])
        {
            return YES;
        }else{
            return NO;
        }
        [db close];
    }else{
        return NO;
    }

}
@end
