//
//  GoodsListViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-27.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullToRefreshTableView.h"
@interface GoodsListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (strong, nonatomic) PullToRefreshTableView *goodsListTableView;
@property (strong, nonatomic) NSMutableArray *goodsListArray;
@property (strong, nonatomic) IBOutlet UIImageView *headBgView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segControl;
@property (strong, nonatomic) NSString *catId;
@property (strong, nonatomic) NSString *catName;
//esc  desc
@property (strong, nonatomic) NSString *sort;
//priceOrder  buyCount  viewCount
@property (strong, nonatomic) NSString *orderBy;
@end
