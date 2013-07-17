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
@property (strong, nonatomic) UIImageView *headBgView;
@property (strong, nonatomic) NSString *catId;
@property (strong, nonatomic) NSString *catName;
@property (strong, nonatomic) UIButton *priceButton;
@property (strong, nonatomic) UIButton *buyCountButton;
@property (strong, nonatomic) UIButton *viewCountButton;
@property (strong, nonatomic) NSString *orderBy;
@property (strong, nonatomic)NSString *sort;
@end
