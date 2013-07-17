//
//  OrderListViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-13.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "OrderListViewController.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UserModel.h"
#import <QuartzCore/QuartzCore.h>
#import "AlipayViewController.h"
#import "OrderDetailViewController.h"
@interface OrderListViewController ()

@end

@implementation OrderListViewController
@synthesize OrderListTable;
@synthesize orderList;
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
    self.navigationItem.title = @"订单列表";
    OrderListTable.backgroundView = nil;
    OrderListTable.backgroundColor = [UIColor whiteColor];
    if([UserModel checkLogin])
    {
        UserModel *user = [UserModel getUserModel];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:@"order_getOrderTrack" forKey:@"act"];
        [param setObject:user.userId forKey:@"userId"];
        MKNetworkOperation *op = [YMGlobal getOperation:param];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                self.orderList = [obj objectForKey:@"result"];
                [self.OrderListTable reloadData];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"error:%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.orderList != nil)
    {
        NSMutableArray *itemArray = [[self.orderList objectAtIndex:section] objectForKey:@"orderItems"];
        return 2+itemArray.count;
    }else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.orderList.count>0)
    {
        UIBarButtonItem *backBar = [[UIBarButtonItem alloc]init];
        [backBar setTintColor:[UIColor colorWithRed:169/255.0 green:217/255.0 blue:110/255.0 alpha:1.0]];
        self.navigationItem.backBarButtonItem = backBar;
        OrderDetailViewController *orderDetailVC = [[OrderDetailViewController alloc]init];
        orderDetailVC.orderId = [[self.orderList objectAtIndex:indexPath.section] objectForKey:@"orderId"];
        [self.navigationController pushViewController:orderDetailVC animated:NO];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.orderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.orderList != nil)
    {
        if(indexPath.row == 0)
        {
            return 70;
        }else if ((indexPath.row -1) == [[[self.orderList objectAtIndex:indexPath.section] objectForKey:@"orderItems"] count]){
            return 40;
        }else{
            return 80;
        }
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(self.orderList !=nil)
    {
         NSMutableDictionary *order = [self.orderList objectAtIndex:indexPath.section];
        if(indexPath.row == 0)
        {
            UILabel *orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 160, 15)];
            [orderIdLabel setText:[NSString stringWithFormat:@"订单号 : %@",[order objectForKey:@"orderId"]]];
            [orderIdLabel setFont:[UIFont systemFontOfSize:13.0]];
            UILabel *totalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 160, 15)];
            [totalAmountLabel setText:[NSString stringWithFormat:@"订单金额 : ￥%@",[order objectForKey:@"finalAmount"]]];
            [totalAmountLabel setFont:[UIFont systemFontOfSize:13.0]];
            [totalAmountLabel setTextColor:[UIColor redColor]];
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 15)];
            [timeLabel setText:[NSString stringWithFormat:@"下单时间 : %@",[order objectForKey:@"createTime"]]];
            [timeLabel setFont:[UIFont systemFontOfSize:13.0]];
            [timeLabel setTextColor:[UIColor blackColor]];
            [orderIdLabel setBackgroundColor:[UIColor clearColor]];
            [totalAmountLabel setBackgroundColor:[UIColor clearColor]];
            [timeLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:orderIdLabel];
            [cell.contentView addSubview:totalAmountLabel];
            [cell.contentView addSubview:timeLabel];
        }else if((indexPath.row - 1) == [[order objectForKey:@"orderItems"] count]){
            if([[order objectForKey:@"payStatus"] isEqualToString:@"0"]){
                cell.textLabel.text = @"订单状态 : 未支付";
                cell.textLabel.font = [UIFont systemFontOfSize:13.0];
                cell.textLabel.textColor = [UIColor redColor];
                UIButton *goPay = [UIButton buttonWithType:UIButtonTypeCustom];
                [goPay setFrame:CGRectMake(210, 5, 60, 30)];
                [goPay setTitle:@"去支付" forState:UIControlStateNormal];
                [goPay setBackgroundColor:[UIColor colorWithRed:154/255.0 green:206/255.0 blue:84/255.0 alpha:1.0]];
                goPay.titleLabel.font = [UIFont systemFontOfSize:15.0];
                goPay.layer.cornerRadius = 5.0;
                goPay.tag = indexPath.section;
                [goPay addTarget:self action:@selector(goPay:) forControlEvents:UIControlEventTouchUpInside];
                [cell.contentView addSubview:goPay];
                
            }else{
                    cell.textLabel.text = @"订单状态 : 已经支付";
                    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
                    cell.textLabel.textColor = [UIColor blackColor];
                 }
        
        }else{
            NSMutableDictionary *goods = [[order objectForKey:@"orderItems"]objectAtIndex:(indexPath.row -1)];
            cell.imageView.image = [UIImage imageNamed:@"goods_default.png"];
            [YMGlobal loadFlipImage:[goods objectForKey:@"imageUrl"] andImageView:cell.imageView];
            UILabel *goodsNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 5, 200, 50)];
            goodsNameLabel.text = [goods objectForKey:@"goodsName"];
            [goodsNameLabel setFont:[UIFont systemFontOfSize:15.0]];
            [goodsNameLabel setNumberOfLines:0];
            [goodsNameLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:goodsNameLabel];
            }
    return cell;
}
    return cell;
}

- (void)goPay:(id)sender
{
    UIButton *pressedButton = sender;
    AlipayViewController *alipayVC = [[AlipayViewController alloc]init];
    NSMutableDictionary *order = [self.orderList objectAtIndex:pressedButton.tag];
    alipayVC.totalAmount = [NSString stringWithFormat:@"%.2f",[[order objectForKey:@"finalAmount"] floatValue]];
    alipayVC.orderId = [order objectForKey:@"orderId"];
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [rightBar setTintColor:[UIColor colorWithRed:172/255.0 green:219/255.0 blue:115/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = rightBar;
    [self.navigationController pushViewController:alipayVC animated:YES];
}
@end
