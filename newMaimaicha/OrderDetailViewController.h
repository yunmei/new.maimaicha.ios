//
//  OrderDetailViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-13.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)UITableView *orderTable;
@property (strong,nonatomic)NSMutableDictionary *orderInfo;
@property (strong,nonatomic)NSString *orderId;
@end
