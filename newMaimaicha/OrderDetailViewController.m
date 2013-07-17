//
//  OrderDetailViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-13.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "AlipayViewController.h"
@interface OrderDetailViewController ()

@end

@implementation OrderDetailViewController
@synthesize orderTable = _orderTable;
@synthesize orderInfo;
@synthesize orderId;
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
    self.navigationItem.title = @"订单详情";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithTitle:@"去支付" style:UIBarButtonItemStyleBordered target:self action:@selector(goPay:)];
    [rightItem setTintColor:[UIColor colorWithRed:169/255.0 green:217/255.0 blue:110/255.0 alpha:1.0]];
    [self.view addSubview:self.orderTable];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"order_getOrderItems" forKey:@"act"];
    [param setObject:self.orderId forKey:@"orderId"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"completeRes%@",[completedOperation responseString]);
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.orderInfo = [obj objectForKey:@"result"];
            [self.orderTable reloadData];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"error%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 3){
        if(self.orderInfo != nil)
        {
            return  [[self.orderInfo objectForKey:@"orderItem"] count];
        }else{
            return 1;
        }
    }else if (section == 4){
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0)
    {
        if(self.orderInfo != nil)
        {
            UILabel *orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 160, 15)];
            [orderIdLabel setText:[NSString stringWithFormat:@"订单号 : %@",[self.orderInfo objectForKey:@"orderId"]]];
            [orderIdLabel setFont:[UIFont systemFontOfSize:13.0]];
            UILabel *totalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 160, 15)];
            [totalAmountLabel setText:[NSString stringWithFormat:@"订单金额 : ￥%@",[self.orderInfo objectForKey:@"finalAmount"]]];
            [totalAmountLabel setFont:[UIFont systemFontOfSize:13.0]];
            [totalAmountLabel setTextColor:[UIColor redColor]];
            UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 15)];
            [timeLabel setText:[NSString stringWithFormat:@"下单时间 : %@",[self.orderInfo objectForKey:@"createTime"]]];
            [timeLabel setFont:[UIFont systemFontOfSize:13.0]];
            [timeLabel setTextColor:[UIColor blackColor]];
            [orderIdLabel setBackgroundColor:[UIColor clearColor]];
            [totalAmountLabel setBackgroundColor:[UIColor clearColor]];
            [timeLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:orderIdLabel];
            [cell.contentView addSubview:totalAmountLabel];
            [cell.contentView addSubview:timeLabel];
        }
    }else if (indexPath.section == 1){
        if(self.orderInfo != nil)
        {
            if([[self.orderInfo objectForKey:@"payStatus"]isEqualToString:@"0"])
            {
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
        }
    }else if (indexPath.section == 2){
            if(self.orderInfo !=nil)
            {
                UILabel *orderIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 15)];
                [orderIdLabel setText:[NSString stringWithFormat:@"详细地址 : %@",[self.orderInfo objectForKey:@"shipAddr"]]];
                [orderIdLabel setFont:[UIFont systemFontOfSize:13.0]];
                UILabel *totalAmountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 160, 15)];
                [totalAmountLabel setText:[NSString stringWithFormat:@"收货人 : %@",[self.orderInfo objectForKey:@"shipName"]]];
                [totalAmountLabel setFont:[UIFont systemFontOfSize:13.0]];
                UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 45, 200, 15)];
                [timeLabel setText:[NSString stringWithFormat:@"联系电话 : %@",[self.orderInfo objectForKey:@"shipMobile"]]];
                [timeLabel setFont:[UIFont systemFontOfSize:13.0]];
                [timeLabel setTextColor:[UIColor blackColor]];
                [orderIdLabel setBackgroundColor:[UIColor clearColor]];
                [totalAmountLabel setBackgroundColor:[UIColor clearColor]];
                [timeLabel setBackgroundColor:[UIColor clearColor]];
                [cell.contentView addSubview:orderIdLabel];
                [cell.contentView addSubview:totalAmountLabel];
                [cell.contentView addSubview:timeLabel];
            }
    }else if (indexPath.section == 3){
        if(self.orderInfo != nil)
        {
            NSMutableArray *goodsArray = [self.orderInfo objectForKey:@"orderItem"];
            NSMutableDictionary *goods = [goodsArray objectAtIndex:indexPath.row];
            cell.imageView.image = [UIImage imageNamed:@"goods_default.png"];
            [YMGlobal loadFlipImage:[goods objectForKey:@"imageUrl"] andImageView:cell.imageView];
            cell.textLabel.text = [goods objectForKey:@"goodsName"];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
            NSString *priceString = [NSString stringWithFormat:@"价格 : %@    购买数量 : %@",[goods objectForKey:@"price"],[goods objectForKey:@"buyCount"]];
            cell.detailTextLabel.text = priceString;
            cell.detailTextLabel.textColor = [UIColor redColor];
        }
    }else{
        if(indexPath.row == 0)
        {
            cell.textLabel.text = [NSString stringWithFormat:@"支付方式 : 支付宝无线支付"];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
            
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"配送方式 : 买买茶配送"];
            cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        }
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
        if(indexPath.section == 0)
        {
            return 65;
        }else if (indexPath.section == 1){
            return 40;
        }else if (indexPath.section ==2){
            return 70;
        }else if (indexPath.section == 3){
            if(self.orderInfo !=nil)
            {
                return 70;
            }else{
                return 0;
            }
        }else {
            return 40;
        }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if(section == 4){
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 320, 30)];
        [priceLabel setFont:[UIFont systemFontOfSize:13.0]];
        [priceLabel setTextColor:[UIColor redColor]];
        [priceLabel setText:[NSString stringWithFormat:@"订单总金额 : ￥%@",[self.orderInfo objectForKey:@"finalAmount"]]];
        [priceLabel setTextAlignment:NSTextAlignmentRight];
        return priceLabel;
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(section == 4)
    {
        return 40;
    }else{
        return 0;
    }
}
- (UITableView *)orderTable
{
    if(_orderTable == nil)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _orderTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, size.height-100) style:UITableViewStyleGrouped];
        _orderTable.backgroundView = nil;
        _orderTable.dataSource = self;
        _orderTable.delegate = self;
        _orderTable.backgroundColor = [UIColor whiteColor];
    }
    return _orderTable;
}


- (void)goPay:(id)sender
{
    if(self.orderInfo != nil)
    {
        AlipayViewController *alipayVC = [[AlipayViewController alloc]init];
        alipayVC.totalAmount = [NSString stringWithFormat:@"%.2f",[[self.orderInfo objectForKey:@"finalAmount"] floatValue]];
        alipayVC.orderId = [self.orderInfo objectForKey:@"orderId"];
        UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
        [rightBar setTintColor:[UIColor colorWithRed:172/255.0 green:219/255.0 blue:115/255.0 alpha:1.0]];
        self.navigationItem.backBarButtonItem = rightBar;
        [self.navigationController pushViewController:alipayVC animated:YES];
    }
}
@end
