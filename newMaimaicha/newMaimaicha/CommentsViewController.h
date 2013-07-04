//
//  CommentsViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-2.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentsViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic)NSString *goodsId;
@property (strong, nonatomic)NSMutableArray *commentInfo;
@end
