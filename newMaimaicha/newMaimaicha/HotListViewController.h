//
//  HotListViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-16.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HotListViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *hotList;
@property (strong, nonatomic) IBOutlet UITableView *hotTable;
@property (strong, nonatomic) NSString *title;
@end
