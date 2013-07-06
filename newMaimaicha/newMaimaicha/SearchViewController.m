//
//  SearchViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "SearchViewController.h"
#import "YMGlobal.h"
#import "YMDbClass.h"
#import "SBJson.h"
#import "AppDelegate.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize hotKeywordsArray = _hotKeywordsArray;
@synthesize keywordsTableView;
@synthesize superView = _superView;
@synthesize viewSegmentCtrl;
@synthesize searchDbArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,[UIFont systemFontOfSize:12.0],UITextAttributeFont,[UIColor clearColor],UITextAttributeTextShadowColor,nil];
    [self.viewSegmentCtrl setTitleTextAttributes:attribute forState:UIControlStateNormal];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"goods_getHotKeyWords" forKey:@"act"];
    [viewSegmentCtrl addTarget:self action:@selector(segmentChange:) forControlEvents:UIControlEventValueChanged];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *data = [parser objectWithData:[completedOperation responseData]];
        self.hotKeywordsArray = [data objectForKey:@"result"];
        [self.keywordsTableView reloadData];
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag ==1)
    {
        if(self.hotKeywordsArray == nil)
        {
            return 0;
        }else{
            return [self.hotKeywordsArray count];
        }
    }else{
        if(self.searchDbArray == nil)
        {
            return 0;
        }else{
            return [self.searchDbArray count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView.tag == 1)
    {
        static NSString *identifier = @"hotKeywords";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(self.hotKeywordsArray !=nil)
        {
            cell.textLabel.text = [self.hotKeywordsArray objectAtIndex:indexPath.row];
        }
        return cell;
    }else{
        static NSString *identifier = @"histroy";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.textLabel.font = [UIFont systemFontOfSize:17];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        if(self.searchDbArray !=nil)
        {
            cell.textLabel.text = [[self.searchDbArray objectAtIndex:indexPath.row] objectForKey:@"skey"];
        }
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
  if(tableView.tag ==2)
  {
      if([self.searchDbArray count] == 0)
      {
          UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
          UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(100, 100, 150, 40)];
          [textLabel setText:@"没有历史搜索记录"];
          [textLabel setBackgroundColor:[UIColor clearColor]];
          [textLabel setFont:[UIFont systemFontOfSize:14.0]];
          [footView addSubview:textLabel];
          return footView;
      }else{
          UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
          UIButton *clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
          [clearButton setFrame:CGRectMake(130, 5, 61, 30)];
          [clearButton setTitle:@"清除" forState:UIControlStateNormal];
          [clearButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
          [clearButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
          [clearButton setBackgroundImage:[UIImage imageNamed:@"clear_button.png"] forState:UIControlStateNormal];
          [clearButton addTarget:self action:@selector(clearSeachHistroy:) forControlEvents:UIControlEventTouchUpInside];
          [footView addSubview:clearButton];
          return footView;
      }

  }else{
      return nil;
  }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView.tag == 1)
    {
        return 0;
    }else{
        if([self.searchDbArray count] ==0)
        {
            return 400;
        }else{
            return 100;
        }
        
    }
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.view addSubview:self.superView];
    searchBar.showsCancelButton = YES;
    for(id cc in [self.searchBar subviews])
    {
        if([cc isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cc;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
            break;
        }
    }
}
// 点击搜索时
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.superView removeFromSuperview];
    [self.searchBar setShowsCancelButton:NO];
    [self.searchBar resignFirstResponder];
    NSString *searchContent = self.searchBar.text;
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [db exec:@" CREATE TABLE IF NOT EXISTS search ('skey','create_time');"];
        NSString *query = [NSString stringWithFormat:@"search where skey = '%@'",searchContent];
        NSString *resultCount = [db count:query];
        NSString *querysql;
        if(resultCount.intValue >0)
        {
            querysql = [NSString stringWithFormat:@"UPDATE search SET create_time=datetime('now','localtime') WHERE skey = '%@'",searchContent];
        }else{
            querysql = [NSString stringWithFormat:@"INSERT INTO search ('skey','create_time') VALUES ('%@',datetime('now','localtime'));",searchContent];
        }
        if([db exec:querysql])
        {
            NSLog(@"搜索记录添加成功");
        }
        [db close];
    }
}
//点击取消
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.superView removeFromSuperview];
    [self.searchBar resignFirstResponder];
    [self.searchBar setText:@""];
    [self.searchBar setShowsCancelButton:NO];
}


- (UIView *)superView
{
    if(_superView == nil)
    {
        _superView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44)];
        _superView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];

    }
    return _superView;
}
- (void)segmentChange:(id)sender
{
    UISegmentedControl *segControl = (UISegmentedControl *)sender;
    if(segControl.selectedSegmentIndex ==0)
    {
        self.keywordsTableView.tag = 1;
        [self.keywordsTableView reloadData];
    }else{
        YMDbClass *db = [[YMDbClass alloc]init];
        if([db connect])
        {
            self.searchDbArray = [db fetchAll:@"select * from search;"];
            NSLog(@"self.searchDb:%@",self.searchDbArray);
            self.keywordsTableView.tag =2;
            [self.keywordsTableView reloadData];
        }
        [db close];
    }
}

- (void)clearSeachHistroy:(id)sender
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        NSString *query = @"delete from search";
        [db exec:query];
        self.searchDbArray = [db fetchAll:@"select * from search;"];
        [db close];
        [self.keywordsTableView reloadData];
    }
}
@end
