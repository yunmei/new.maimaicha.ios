//
//  OrderSubmitViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-8.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "OrderSubmitViewController.h"
#import "UserModel.h"
#import "goodsModel.h"
#import "AddrListViewController.h"
@interface OrderSubmitViewController ()

@end

@implementation OrderSubmitViewController
@synthesize orderTable = _orderTable;
@synthesize goodsList = _goodsList;
@synthesize userId = _userId;
@synthesize addrArray = addrArray;
@synthesize defaultAddr;
@synthesize payOnlineButton;
@synthesize reachPayButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.goodsList = [goodsModel fetchGoodsList];
    NSLog(@"goodsList:%@",self.goodsList);
    NSLog(@"addr:::%@",self.defaultAddr);
    [self.orderTable reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib
 [self.view addSubview:self.orderTable];
    PAYONLINE = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        if(self.defaultAddr != nil)
        {
            NSString *addrString = [self.defaultAddr objectForKey:@"addr"];
            CGSize size = [addrString sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(230, 1000)];
            return 80+size.height;
        }
         return 60;
    }else if (indexPath.row == 1){
         return 30+70*self.goodsList.count;
    }else if (indexPath.row == 2){
        return 60;
    }else if(indexPath.row == 3){
        return 40;
    }else{
        return 50;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSLog(@"orderSubmitreload");
    if(indexPath.row == 0)
    {
        UILabel *addrtabLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 2100, 16)];
        [addrtabLabel setText:@"收货信息"];
        [addrtabLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:addrtabLabel];
        if(self.defaultAddr == nil)
        {
            UILabel *addrtabLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 35, 2100, 15)];
            [addrtabLabel setText:@"没有售货地址，快去添加吧！"];
            [addrtabLabel setFont:[UIFont systemFontOfSize:13.0]];
            [cell.contentView addSubview:addrtabLabel];
        }else{
            UILabel *addrtabLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 35, 15)];
            [addrtabLabel setText:[NSString stringWithFormat:@"地址 : "]];
            [addrtabLabel setFont:[UIFont systemFontOfSize:12.0]];
            [cell.contentView addSubview:addrtabLabel];
            
            NSString *addrString = [self.defaultAddr objectForKey:@"addr"];
            CGSize size = [addrString sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(230, 1000)];
            UILabel *addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 30, 230, size.height)];
            [addrLabel setText:[NSString stringWithFormat:@"%@",[self.defaultAddr objectForKey:@"addr"]]];
            [addrLabel setNumberOfLines:0];
            [addrLabel setFont:[UIFont systemFontOfSize:12.0]];
            [cell.contentView addSubview:addrLabel];
            
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, size.height+30+5, 200, 15)];
            [nameLabel setText:[NSString stringWithFormat:@"姓名 : %@",[self.defaultAddr objectForKey:@"name"]]];
            [nameLabel setFont:[UIFont systemFontOfSize:12.0]];
            [cell.contentView addSubview:nameLabel];
            
            UILabel *mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, nameLabel.frame.origin.y+20, 250, 15)];
            [mobileLabel setText:[NSString stringWithFormat:@"电话 : %@",[self.defaultAddr objectForKey:@"mobile"]]];
            [mobileLabel setFont:[UIFont systemFontOfSize:12.0]];
            [cell.contentView addSubview:mobileLabel];
        }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row == 1){
        UILabel *infotabLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 210, 15)];
        [infotabLabel setText:@"商品信息"];
        [infotabLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:infotabLabel];
        int i=0;
        for(id o in self.goodsList){
            NSMutableDictionary *goods = o;
            UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 70*i+35, 300, 15)];
            nameLabel.text = [NSString stringWithFormat:@"%@",[goods objectForKey:@"name"]];
            nameLabel.font = [UIFont systemFontOfSize:13.0];
            [cell.contentView addSubview:nameLabel];
            UILabel *bnLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 70*i+55, 300, 15)];
            bnLabel.text = [NSString stringWithFormat:@"商品编号 : %@",[goods objectForKey:@"goodsBn"]];
            bnLabel.font = [UIFont systemFontOfSize:12.0];
            [bnLabel setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:bnLabel];
            UILabel *numTab = [[UILabel alloc]initWithFrame:CGRectMake(5, 70*i+75, 40, 15)];
            [numTab setFont:[UIFont systemFontOfSize:13.0]];
            [numTab setText:@"数量 :"];
            [numTab setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:numTab];
            UILabel *numLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 70*i+75, 20, 15)];
            [numLabel setFont:[UIFont systemFontOfSize:13.0]];
            [numLabel setText:[NSString stringWithFormat:@"%@",[goods objectForKey:@"goods_count"]]];
            [numLabel setTextColor:[UIColor redColor]];
            [cell.contentView addSubview:numLabel];
            UILabel *priceTab = [[UILabel alloc]initWithFrame:CGRectMake(70, 70*i+75, 40, 15)];
            [priceTab setFont:[UIFont systemFontOfSize:13.0]];
            [priceTab setText:@"合计 : "];
            [priceTab setTextColor:[UIColor grayColor]];
            [cell.contentView addSubview:priceTab];
            UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 70*i+75, 90, 15)];
            [priceLabel setFont:[UIFont systemFontOfSize:13.0]];
            float totalAmount = [[goods objectForKey:@"goods_count"] floatValue]*[[goods objectForKey:@"price"] floatValue];
            [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",totalAmount]];
            [priceLabel setTextColor:[UIColor redColor]];
            [cell.contentView addSubview:priceLabel];
            i++;
        }
    }else if (indexPath.row == 2){
        UILabel *addrtabLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 13, 80, 30)];
        [addrtabLabel setText:@"支付方式 :"];
        [addrtabLabel setFont:[UIFont systemFontOfSize:15.0]];
        [cell.contentView addSubview:addrtabLabel];
        self.payOnlineButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.payOnlineButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.payOnlineButton.tag = 1;
        if(PAYONLINE){
            [self.payOnlineButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
        }else{
            [self.payOnlineButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        }
        [self.payOnlineButton setFrame:CGRectMake(85, 20, 20, 20)];
        UIButton *payLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [payLabelBtn setTitle:@"在线支付" forState:UIControlStateNormal];
        [payLabelBtn setFrame:CGRectMake(105, 15, 60, 30)];
        payLabelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [payLabelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        payLabelBtn.tag = 1;
        [payLabelBtn addTarget:self action:@selector(labelPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.reachPayButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.reachPayButton.tag = 2;
        [self.reachPayButton addTarget:self action:@selector(payButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        if(PAYONLINE){
            [self.reachPayButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        }else{
            [self.reachPayButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
        }
        [self.reachPayButton setFrame:CGRectMake(180, 20, 20, 20)];
        UIButton *reachLabelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reachLabelBtn setTitle:@"活到付款" forState:UIControlStateNormal];
        [reachLabelBtn setFrame:CGRectMake(200, 15, 60, 30)];
        reachLabelBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [reachLabelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        reachLabelBtn.tag =2;
        [reachLabelBtn addTarget:self action:@selector(labelPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:self.payOnlineButton];
        [cell.contentView addSubview:payLabelBtn];
        [cell.contentView addSubview:self.reachPayButton];
        [cell.contentView addSubview:reachLabelBtn];
    }else if (indexPath.row == 3){
        UILabel *addrtabLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 80, 20)];
        [addrtabLabel setText:@"配送方式 : "];
        [addrtabLabel setFont:[UIFont systemFontOfSize:15.0]];
        UILabel *shipLabel = [[UILabel alloc]initWithFrame:CGRectMake(85, 5, 80, 30)];
        [shipLabel setText:@"买买茶配送 "];
        [shipLabel setFont:[UIFont systemFontOfSize:13.0]];
        [cell.contentView addSubview:addrtabLabel];
        [cell.contentView addSubview:shipLabel];
    }else{
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddrListViewController *addrListVC = [[AddrListViewController alloc]init];
    addrListVC.delegate = self;
    UIBarButtonItem *backBar = [[UIBarButtonItem alloc]init];
    [backBar setTintColor:[UIColor colorWithRed:169/255.0 green:217/255.0 blue:110/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = backBar;
    [self.navigationController pushViewController:addrListVC animated:YES];

}

- (UITableView *)orderTable
{
    if(_orderTable == nil)
    {
        CGFloat height = 0;
        if(self.defaultAddr !=nil)
        {
            NSString *addrString = [self.defaultAddr objectForKey:@"addr"];
            CGSize size = [addrString sizeWithFont:[UIFont systemFontOfSize:12.0] constrainedToSize:CGSizeMake(230, 1000)];

             height = 180+70*self.goodsList.count+80+size.height;
        }else{
             height = 180+70*self.goodsList.count+60;
        }
        _orderTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,height)];
        UIScrollView *selfView = (UIScrollView *)self.view;
        [selfView setContentSize:CGSizeMake(320, height+500)];
        _orderTable.dataSource = self;
        _orderTable.delegate = self;
        _orderTable.scrollEnabled = NO;
    }
    return _orderTable;
}

- (NSMutableArray *)goodsList
{
    if(_goodsList == nil)
    {
        _goodsList = [goodsModel fetchGoodsList];
    }
    return _goodsList;
}

-(void)passVlaue:(NSMutableDictionary *)value
{
    self.defaultAddr = value;
    [self.orderTable reloadData];
}


- (void)labelPressed:(id)sender
{
    UIButton *selectBtn = sender;
    if(selectBtn.tag == 1){
        PAYONLINE = YES;
        [self.payOnlineButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
        [self.reachPayButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
    }else{
        PAYONLINE = NO;
        [self.payOnlineButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        [self.reachPayButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    }
}

- (void)payButtonPressed:(id)sender
{
    UIButton *payButton = sender;
    if(payButton.tag == 1){
        PAYONLINE = YES;
        [self.payOnlineButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
        [self.reachPayButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
    }else{
        PAYONLINE = NO;
        [self.payOnlineButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Unselected.png"] forState:UIControlStateNormal];
        [self.reachPayButton setBackgroundImage:[UIImage imageNamed:@"RadioButton-Selected.png"] forState:UIControlStateNormal];
    }
}
@end
