//
//  SearchViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<UISearchBarDelegate,
                                                UISearchDisplayDelegate,
                                                UITableViewDataSource,
                                                UITableViewDelegate,
                                                UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *hotKeywordsArray;
- (IBAction)backView:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *keywordsTableView;
@property (strong,nonatomic)UIView *superView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *viewSegmentCtrl;
@property (strong, nonatomic) NSMutableArray *searchDbArray;
@end
