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
@end
