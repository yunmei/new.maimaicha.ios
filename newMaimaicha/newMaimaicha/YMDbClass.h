//
//  YMDbClass.h
//  yunmei.967067
//
//  Created by bevin chen on 12-12-12.
//  Copyright (c) 2012年 bevin chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Constants.h"

@interface YMDbClass : NSObject

@property (nonatomic) sqlite3 *link;

- (NSString *)dataFilePath:(NSString *)filename;    // 获取数据库文件路径
- (BOOL)connect;                                    // 连接数据库
- (BOOL)exec:(NSString *)sql;                       // 执行Sql语句
- (NSMutableDictionary *)fetchOne:(NSString *)sql;  // 获取一条记录
- (NSMutableArray *)fetchAll:(NSString *)sql;       // 获取多条记录
- (NSString *)count:(NSString *)tableName;          // 返回总数
- (NSString *)count_sum:(NSString *)tableName tablefiled:(NSString *)tablefiled; //返回纪录总和
- (void)close;                                      // 关闭连接

@end
