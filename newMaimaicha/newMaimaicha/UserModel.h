//
//  UserModel.h
//  newMaimaicha
//
//  Created by ken on 13-7-3.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong, nonatomic)NSString *userId;
@property (strong, nonatomic)NSString *session;
@property (strong, nonatomic)NSString *userName;
@property (strong, nonatomic)NSString *point;
@property (strong, nonatomic)NSString *advance;
+(void)creatTable;
+ (void)clearTable;
+ (UserModel *)getUserModel;
+(void)dropTable;
+ (BOOL)checkLogin;
- (BOOL)addUser;
@end
