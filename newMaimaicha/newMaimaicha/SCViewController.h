//
//  SCViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-17.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *scListTable;
@property (strong, nonatomic) NSMutableArray *scList;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIView *emptyView;
@end
