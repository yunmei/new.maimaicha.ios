//
//  SecCategoryViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-26.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecCategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong,nonatomic)NSMutableArray *secCatArray;
@property (strong, nonatomic)NSString *catName;
@end
