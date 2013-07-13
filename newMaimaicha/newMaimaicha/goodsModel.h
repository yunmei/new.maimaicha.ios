//
//  goodsModel.h
//  newMaimaicha
//
//  Created by ken on 13-6-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface goodsModel : NSObject
@property (strong,nonatomic)NSMutableArray *imageArray;
@property (strong,nonatomic)NSString *goodsId;
@property (strong,nonatomic)NSString *name;
@property (strong,nonatomic)NSString *price;
@property (strong,nonatomic)NSString *mktPrice;
@property (strong,nonatomic)NSString *store;
// goodsBn   goodsWeight  goodsBrand goodsUnit
@property (strong,nonatomic)NSMutableDictionary *property;
@property (strong,nonatomic)NSString *buyCount;
@property (strong,nonatomic)NSString *goodsBn;
+(void)creatTable;
+(void)AddCar:(goodsModel *)goodsItem;
+(NSInteger)countGoods;
+(NSMutableArray *)fetchGoodsList;

+(BOOL)updateCartData:(NSString *)goodsId
           goodsCount:(NSString *)goodsCount;
+(BOOL)deleteCartData:(NSString *)goodsId;
+(BOOL)clearCart;
@end
