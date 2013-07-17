//
//  MyViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface MyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(strong ,nonatomic)UITableView *userInfoTable;
@property (strong, nonatomic)UserModel *user;
@end
