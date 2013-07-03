//
//  CartViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic)UITableView *goodsTableView;
@property (strong, nonatomic)NSMutableArray *goodsInfoArray;
@property (strong, nonatomic)UIView *cartNullView;
@property (strong, nonatomic)NSMutableArray *textFieldArray;
@property (strong, nonatomic)NSMutableArray *labelArray;
@end
