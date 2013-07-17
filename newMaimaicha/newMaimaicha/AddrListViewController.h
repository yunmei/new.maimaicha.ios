//
//  AddrListViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-9.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PassValueDelegate <NSObject>

-(void)passVlaue:(NSMutableDictionary *)value;
@end

@interface AddrListViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    BOOL HASDEFAULT;
}
@property (strong, nonatomic)NSMutableArray *addrList;
@property (strong, nonatomic) IBOutlet UITableView *addListTable;
@property (strong) NSObject <PassValueDelegate>*delegate;
@property (strong, nonatomic)UIView *nullView;
@property (strong, nonatomic)NSString *comeFrom;
@end
