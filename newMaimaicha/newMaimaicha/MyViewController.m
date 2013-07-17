//
//  MyViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "AddrListViewController.h"
#import "OrderListViewController.h"
#import "SCViewController.h"
#import "goodsModel.h"
@interface MyViewController ()

@end

@implementation MyViewController
@synthesize userInfoTable = _userInfoTable;
@synthesize user;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"我的商城";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_my_unselected.png"];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_my.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_my_unselected.png"]];
        }
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(deleteLogin)];
        [buttonItem setTintColor:[UIColor colorWithRed:131/255.0 green:187/255.0 blue:72/255.0 alpha:1.0]];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(![UserModel checkLogin])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"INeedLogin" object:nil];
    }else{
        self.user = [UserModel getUserModel];
        [self.view addSubview:self.userInfoTable];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
        return 1;
    }else{
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 80;
    }else{
        return 40;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pic"];
        cell.backgroundColor = [UIColor whiteColor];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *picView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        [picView setImage:[UIImage imageNamed:@"user_image.png"]];
        [cell.contentView addSubview:picView];
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 15, 200, 15)];
        [nameLabel setFont:[UIFont systemFontOfSize:13.0]];
        [nameLabel setText:[NSString stringWithFormat:@"用户 : %@",self.user.userName]];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 35, 200, 15)];
        [scoreLabel setFont:[UIFont systemFontOfSize:13.0]];
        [scoreLabel setText:[NSString stringWithFormat:@"积分 : %@",self.user.point]];
        [scoreLabel  setBackgroundColor:[UIColor clearColor]];
        UILabel *advanceLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 55, 200, 15)];
        [advanceLabel setFont:[UIFont systemFontOfSize:13.0]];
        [advanceLabel setText:[NSString stringWithFormat:@"余额 : %@",self.user.advance]];
        [advanceLabel  setBackgroundColor:[UIColor clearColor]];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:scoreLabel];
        [cell.contentView addSubview:advanceLabel];
        return cell;
    }else{        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info"];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(indexPath.row == 0)
        {
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.text = @"我的订单";
        }else if (indexPath.row == 1){
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.text = @"我的收藏";
        }else{
            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
            cell.textLabel.text = @"收货地址管理";
        }
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  if(indexPath.section == 1)
  {
      if(indexPath.row == 0)
      {
          OrderListViewController *orderListVC = [[OrderListViewController alloc]init];
          UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
          [backItem setTintColor:[UIColor colorWithRed:160/255.0 green:210/255.0 blue:94/255.0 alpha:1.0]];
          self.navigationItem.backBarButtonItem = backItem;
          [self.navigationController pushViewController:orderListVC animated:YES];
      }else if (indexPath.row == 1){
          SCViewController *scVC = [[SCViewController alloc]init];
          NSMutableArray *goodsArray = [goodsModel fetchSCList];
          scVC.scList = goodsArray;
          UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
          [backItem setTintColor:[UIColor colorWithRed:160/255.0 green:210/255.0 blue:94/255.0 alpha:1.0]];
          self.navigationItem.backBarButtonItem = backItem;
          [self.navigationController pushViewController:scVC animated:YES];
      }else{
          AddrListViewController *addListVC = [[AddrListViewController alloc]init];
          addListVC.comeFrom = @"userCenter";
          UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
          [backItem setTintColor:[UIColor colorWithRed:160/255.0 green:210/255.0 blue:94/255.0 alpha:1.0]];
          self.navigationItem.backBarButtonItem = backItem;
          [self.navigationController pushViewController:addListVC animated:NO];
      }
  }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)deleteLogin
{
    [UserModel clearTable];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"INeedLogin" object:nil];
}

- (UITableView *)userInfoTable
{
    if(_userInfoTable == nil)
    {
        _userInfoTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 400) style:UITableViewStyleGrouped];
        _userInfoTable.delegate = self;
        _userInfoTable.dataSource = self;
        _userInfoTable.backgroundView = nil;
    }
    return _userInfoTable;
}
@end
