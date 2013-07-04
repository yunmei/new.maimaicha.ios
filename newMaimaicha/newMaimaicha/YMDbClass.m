//
//  YMDbClass.m
//  yunmei.967067
//
//  Created by bevin chen on 12-12-12.
//  Copyright (c) 2012年 bevin chen. All rights reserved.
//

#import "YMDbClass.h"

@implementation YMDbClass

@synthesize link;

// 获取数据库文件路径
- (NSString *)dataFilePath:(NSString *)dbname
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    return [documentDirectory stringByAppendingPathComponent:dbname];
}

// 连接数据库
- (BOOL)connect
{
    if (sqlite3_open([[self dataFilePath:DB_NAME] UTF8String], &link) != SQLITE_OK) {
        sqlite3_close(self.link);
        return NO;
    }
    return YES;
}

// 执行Sql语句
- (BOOL)exec:(NSString *)sql
{
    char *errorMsg;
    if (sqlite3_exec(link, [sql UTF8String], NULL, NULL, &errorMsg) != SQLITE_OK) {
        return NO;
    }
    return YES;
}

// 返回记录总数
-(NSString *)count:(NSString *)tableName
{
    NSString *sql=[NSString stringWithFormat:@"SELECT COUNT(*) count FROM %@", tableName];
    NSMutableDictionary *result = [self fetchOne:sql];
    return [result objectForKey:@"count"];
}

// 返回记录总和
-(NSString *)count_sum:(NSString *)tableName tablefiled:(NSString *)tablefiled
{
    NSString *sql=[NSString stringWithFormat:@"SELECT sum(%@) sum FROM %@",tablefiled, tableName];
    NSMutableDictionary *result = [self fetchOne:sql];
    if ([[result objectForKey:@"sum"] isEqualToString:@""]) {
        return nil;
    }
    return [result objectForKey:@"sum"];
}

// 获取一条记录
- (NSMutableDictionary *)fetchOne:(NSString *)sql
{
    sqlite3_stmt *statement;
    NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
    if(sqlite3_prepare_v2(link, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        if (sqlite3_step(statement) == SQLITE_ROW) {
            int count = sqlite3_column_count(statement);
            NSString *value = [[NSString alloc]init];
            NSString *columnName = [[NSString alloc]init];
            int type;
            for (int i=0; i<count; i++) {
                type = sqlite3_column_type(statement, i);
                if (type == SQLITE_INTEGER) {
                    value = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)];
                } else if (type == SQLITE_TEXT) {
                    value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                } else {
                    value = @"";
                }
                columnName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_name(statement, i)];
                [dicData setObject:value forKey:columnName];
            }
        }
        sqlite3_finalize(statement);
    }
    return dicData;
}

// 获取多条记录
- (NSMutableArray *)fetchAll:(NSString *)sql
{
    sqlite3_stmt *statement;
    NSMutableArray *dicArray = [[NSMutableArray alloc]init];
    if(sqlite3_prepare_v2(link, [sql UTF8String], -1, &statement, nil) == SQLITE_OK) {
        NSMutableDictionary *dicData = [[NSMutableDictionary alloc]init];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dicData = [[NSMutableDictionary alloc]init];
            int count = sqlite3_column_count(statement);
            NSString *value = [[NSString alloc]init];
            NSString *columnName = [[NSString alloc]init];
            int type;
            for (int i=0; i<count; i++) {
                type = sqlite3_column_type(statement, i);
                if (type == SQLITE_INTEGER) {
                    value = [NSString stringWithFormat:@"%d", sqlite3_column_int(statement, i)];
                } else if (type == SQLITE_TEXT) {
                    value = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, i)];
                } else if (type == SQLITE_FLOAT) {
                    value = [NSString stringWithFormat:@"%f", sqlite3_column_double(statement, i)];
                } else {
                    value = nil;
                }
                columnName = [NSString stringWithFormat:@"%s", (char *)sqlite3_column_name(statement, i)];
                [dicData setObject:value forKey:columnName];
            }
            [dicArray addObject:dicData];
        }
        sqlite3_finalize(statement);
    }
    return dicArray;
}

// 关闭数据库
- (void)close
{
    sqlite3_close(link);
}
@end
