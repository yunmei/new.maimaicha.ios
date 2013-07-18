//
//  OrderSuccessViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-12.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderSuccessViewController : UIViewController
@property (strong,nonatomic)NSString *orderId;
@property (strong, nonatomic) IBOutlet UILabel *orderIdLabel;
@property (strong,nonatomic)NSString *totalFee;

@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) NSString *payType;
@end
