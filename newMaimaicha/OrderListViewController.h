//
//  OrderListViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-13.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *OrderListTable;
@property (strong, nonatomic)   NSMutableArray *orderList;
@end
