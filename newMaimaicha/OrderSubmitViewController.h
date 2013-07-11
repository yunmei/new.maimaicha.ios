//
//  OrderSubmitViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-8.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddrListViewController.h"
@interface OrderSubmitViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PassValueDelegate>{
    BOOL PAYONLINE;
}
@property (strong ,nonatomic)UITableView *orderTable;
@property (strong,nonatomic)NSMutableArray *goodsList;
@property (strong,nonatomic)NSString *userId;
@property (strong,nonatomic)NSMutableArray *addrArray;
@property (strong,nonatomic)NSMutableDictionary *defaultAddr;
@property (strong,nonatomic)UIButton *payOnlineButton;
@property (strong,nonatomic)UIButton *reachPayButton;
@end
