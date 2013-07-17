//
//  goodsModel.m
//  newMaimaicha
//
//  Created by ken on 13-6-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "goodsModel.h"
#import "YMDbClass.h"
@implementation goodsModel
@synthesize goodsId;
@synthesize imageArray;
@synthesize name;
@synthesize price;
@synthesize mktPrice;
@synthesize store;
@synthesize property;
@synthesize buyCount;

//创建表goodslist_car
+(void)creatTable
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [db exec:@"CREATE TABLE IF NOT EXISTS goodslist_car('id','name','price','store','goodsBn','goods_count');"];
        [db close];
    }
}

+(void)creatSC
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [db exec:@"CREATE TABLE IF NOT EXISTS goodsSC('id','name','price','image_url');"];
        [db close];
    }
}

+(BOOL)AddSC:(NSMutableDictionary *)goodsSCInfo
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *querysql = [NSString stringWithFormat:@"goodsSC where id = '%@'",[goodsSCInfo objectForKey:@"goodsId"]];
        NSString *resultCount = [db count:querysql];
        if([resultCount isEqualToString:@"0"])
        {
            querysql = [NSString stringWithFormat:@"INSERT INTO goodsSC ('id','name','price','image_url')VALUES('%@','%@','%@','%@');",[goodsSCInfo objectForKey:@"goodsId"],[goodsSCInfo objectForKey:@"goodsName"],[goodsSCInfo objectForKey:@"goodsPrice"],[goodsSCInfo objectForKey:@"imageUrl"]];
            if([db exec:querysql])
            {
                return YES;
            }else{
                return NO;
            }
                [db close];
            
        }else{
            return NO;
        }

        
    }else{
        return NO;
    }
}

+(NSMutableArray *)fetchSCList
{
    YMDbClass *db = [[YMDbClass alloc]init];
    NSMutableArray *resultArray;
    if([db connect])
    {
        NSString *query = @"select * from goodsSC";
        resultArray = [db fetchAll:query];
    }
    return resultArray;
}

+(void)AddCar:(goodsModel *)goodsItem
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *querysql = [NSString stringWithFormat:@"goodslist_car where id = '%@'",goodsItem.goodsId];
        NSString *resultCount = [db count:querysql];
        if([resultCount isEqualToString:@"0"])
        {
            querysql = [NSString stringWithFormat:@"INSERT INTO goodslist_car (id,name,price,store,goodsBn,goods_count)VALUES('%@','%@','%@','%@','%@','%@');",goodsItem.goodsId,goodsItem.name,goodsItem.price,goodsItem.store,[goodsItem.property objectForKey:@"goodsBn"],goodsItem.buyCount];
        }else{
            querysql = [NSString stringWithFormat:@"UPDATE goodslist_car SET goods_count = goods_count+'%i' WHERE id = '%@';",goodsItem.buyCount.integerValue,goodsItem.goodsId];
        }
        [db exec:querysql];
        [db close];
    }
}


+(NSInteger)countGoods
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *resultCount = [db count_sum:@"goodslist_car" tablefiled:@"goods_count"];
        return resultCount.integerValue;
    }else{
        return 0;
    }
}

+(NSMutableArray *)fetchGoodsList
{
    YMDbClass *db = [[YMDbClass alloc]init];
    NSMutableArray *resultArray;
    if([db connect])
    {
        NSString *query = @"select * from goodslist_car";
        resultArray = [db fetchAll:query];
    }
    return resultArray;
}

+(BOOL)updateCartData:(NSString *)goodsId
           goodsCount:(NSString *)goodsCount
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *query = [NSString stringWithFormat:@"update goodslist_car set goods_count = '%@' where id = '%@'",goodsCount,goodsId];;
        if([db exec:query])
        {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

+(BOOL)deleteCartData:(NSString *)goodsId
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *query = [NSString stringWithFormat:@"delete from goodslist_car where id = '%@'",goodsId];;
        if([db exec:query])
        {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

+(BOOL)clearCart
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *query = [NSString stringWithFormat:@"delete from goodslist_car"];
        if([db exec:query])
        {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

+(BOOL)clearSC
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *query = [NSString stringWithFormat:@"delete from goodsSC"];
        if([db exec:query])
        {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}
@end
