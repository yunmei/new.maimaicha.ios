//
//  MoreViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface MoreViewController : UIViewController<
UITableViewDataSource,
UITableViewDelegate,
UIAlertViewDelegate>

@property(strong,nonatomic)NSString *downloadURl;
@end
