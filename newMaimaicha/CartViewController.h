//
//  CartViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)UITableView *goodsTableView;
@property (strong, nonatomic)NSMutableArray *goodsInfoArray;
@property (strong, nonatomic)UIView *cartNullView;

@end
