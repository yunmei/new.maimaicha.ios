//
//  AlipayViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-12.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlipayViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *payTypeTable;
@property (strong, nonatomic)NSString *orderId;
@property (strong, nonatomic)NSString *totalAmount;
@end
