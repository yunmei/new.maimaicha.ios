//
//  GoodsInfoViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPageFlowView.h"
#import "goodsModel.h"
@interface GoodsInfoViewController : UIViewController<SBPageFlowViewDataSource,SBPageFlowViewDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong ,nonatomic)NSString *goodsId;
@property (strong ,nonatomic)NSString *goodsName;
@property (strong ,nonatomic)SBPageFlowView *flowView;
@property (strong ,nonatomic)goodsModel *goodsModel;
@property (strong ,nonatomic)UITableView *propertyTableView;
@end
