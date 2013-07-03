//
//  CartViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "CartViewController.h"
#import "goodsModel.h"
#import "cartCell.h"
@interface CartViewController ()

@end

@implementation CartViewController
@synthesize goodsInfoArray;
@synthesize goodsTableView = _goodsTableView;
@synthesize cartNullView = _cartNullView;
@synthesize textFieldArray = _textFieldArray;
@synthesize labelArray = _labelArray;
@synthesize footerView = _footerView;
@synthesize totalAmount;
@synthesize amountLabel;
@synthesize footerFirstLabel;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"购物车";
        self.navigationItem.title = @"购物车";
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(edit:)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0]];
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_cart_unselected.png"];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_cart.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_cart_unselected.png"]];
        }

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if([goodsModel countGoods]>0)
    {
        [self.cartNullView removeFromSuperview];
        NSMutableArray *resultArray = [goodsModel fetchGoodsList];
        if(resultArray != nil)
        {
            self.goodsInfoArray = resultArray;
            float amount = 0;
            for(id o in self.goodsInfoArray)
            {
                float count = [[o objectForKey:@"goods_count"] floatValue];
                float price = [[o objectForKey:@"price"] floatValue];
                amount += count*price;
            }
            self.totalAmount = [NSString stringWithFormat:@"%.2f",amount];
            BOOL isTableViewOn = NO;
            self.goodsInfoArray = resultArray;
            for(UIView *oneView in self.view.subviews)
            {
                if([oneView isKindOfClass:[self.goodsTableView class]])
                {
                    isTableViewOn = YES;
                    break;
                }else{
                     isTableViewOn = NO;
                }
            }
            if(!isTableViewOn)
            {
                self.goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.goodsInfoArray.count*80) style:UITableViewStylePlain];
                self.goodsTableView.dataSource = self;
                self.goodsTableView.delegate = self;
                self.goodsTableView.scrollEnabled = NO;
                [self.view addSubview:self.goodsTableView];
                [self.view addSubview:self.footerView];
                UIScrollView *selfScrollView = (UIScrollView *)self.view;
                selfScrollView.contentSize = CGSizeMake(320, self.goodsTableView.frame.size.height+100);
            }else{
                [self.goodsTableView reloadData];
                [self.goodsTableView setFrame:CGRectMake(0, 0, 320, self.goodsInfoArray.count*80)];
                [self.footerView setFrame:CGRectMake(0, self.goodsInfoArray.count*80, 320, 100)];
                [self.amountLabel setText:[NSString stringWithFormat:@"￥%@",self.totalAmount]];
                [self.footerFirstLabel setText:[NSString stringWithFormat:@"原始金额 : ￥%@ - 返现 : ￥0.00",self.totalAmount]];
                 UIScrollView *selfScrollView = (UIScrollView *)self.view;
                selfScrollView.contentSize = CGSizeMake(320, self.goodsTableView.frame.size.height+100);
            }

        }
    }else{
        [self.view addSubview:self.cartNullView];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [tableView setFrame:CGRectMake(0, 0, 320, self.goodsInfoArray.count*80)];
    [self.amountLabel setText:[NSString stringWithFormat:@"￥%@",self.totalAmount]];
    [self.footerFirstLabel setText:[NSString stringWithFormat:@"原始金额 : ￥%@ - 返现 : ￥0.00",self.totalAmount]];
    [self.footerView setFrame:CGRectMake(0, self.goodsInfoArray.count*80, 320, 100)];
    return self.goodsInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cartCell *cell = [[cartCell alloc]init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.row%2>0)
    {
        cell.contentView.backgroundColor = [UIColor colorWithRed:209/255.0 green:241/255.0 blue:133/255.0 alpha:0.4];
    }
    cell.nameLabel.text = [[self.goodsInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.buyCountLabel.text = [[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"goods_count"];
    cell.buyCountLabel.tag = indexPath.row;
    [self.labelArray addObject:cell.buyCountLabel];
    cell.buyCountField.text = [[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"goods_count"];
    cell.buyCountField.tag = indexPath.row;
    cell.buyCountField.delegate = self;
    [self.textFieldArray addObject:cell.buyCountField];
    cell.bnLabel.text = [NSString stringWithFormat:@"商品编号: %@",[[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"goodsBn"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"价格: ￥%.2f",[[[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"price"] floatValue]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
        return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSString *goodsId = [[self.goodsInfoArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        if([goodsModel deleteCartData:goodsId])
        {
            [self refreshData];
            [self.goodsTableView reloadData];
        }
    }
}
- (UIView *)cartNullView
{
    if(_cartNullView == nil){
        _cartNullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [_cartNullView setUserInteractionEnabled:YES];
        UIImageView *emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(60, 50, 200, 200)];
        [emptyImageView setImage:[UIImage imageNamed:@"empty.jpg"]];
        [_cartNullView addSubview:emptyImageView];
        UILabel *stringLabel = [[UILabel alloc]initWithFrame:CGRectMake(75,260, 200, 30)];
        [stringLabel setText:@"购物车里是空的,快去选购吧！"];
        [stringLabel setFont:[UIFont systemFontOfSize:13.0]];
        [stringLabel setTextColor:[UIColor grayColor]];
        [_cartNullView addSubview:stringLabel];
        UIButton *goBuyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [goBuyButton setBackgroundImage:[UIImage imageNamed:@"lightYellow.png"] forState:UIControlStateNormal];
        [goBuyButton setFrame:CGRectMake(110, 290, 100, 40)];
        [goBuyButton setTitle:@"去逛逛" forState:UIControlStateNormal];
        [goBuyButton addTarget:self action:@selector(goBuy:) forControlEvents:UIControlEventTouchUpInside];
        [_cartNullView addSubview:goBuyButton];
    }
    return _cartNullView;
}

- (void)goBuy:(id)sender
{
    [self.tabBarController setSelectedIndex:1];
}

- (void)refreshData
{
    if([goodsModel countGoods]>0)
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2]setBadgeValue:[NSString stringWithFormat:@"%i",[goodsModel countGoods]]];
        NSMutableArray *resultArray = [goodsModel fetchGoodsList];
        if(resultArray != nil)
        {
            self.goodsInfoArray = resultArray;
            float amount = 0;
            for(id o in self.goodsInfoArray)
            {
                float count = [[o objectForKey:@"goods_count"] floatValue];
                float price = [[o objectForKey:@"price"] floatValue];
                amount += count*price;
            }
            self.totalAmount = [NSString stringWithFormat:@"%.2f",amount];
        }
    }else{
        [[self.tabBarController.tabBar.items objectAtIndex:2]setBadgeValue:nil];
        [self.goodsTableView removeFromSuperview];
        [self.footerView removeFromSuperview];
        [self.view addSubview:self.cartNullView];
    }
}

- (void)edit:(id)sender
{
    [self.goodsTableView setEditing:!self.goodsTableView.editing animated:YES];
    if(self.goodsTableView.editing)
    {
        self.navigationItem.rightBarButtonItem.title = @"完成";
        for(id o in self.labelArray)
        {
            UILabel *countLabel = (UILabel *)o;
            [countLabel setHidden:YES];
        }
        for(id i in self.textFieldArray)
        {
            UITextField *countTextField = (UITextField *)i;
            [countTextField setHidden:NO];
        }
    }else{
        for(id i in self.textFieldArray)
        {
            UITextField *countTextField = (UITextField *)i;
            if(![countTextField.text isEqualToString:@""])
            {
                NSInteger k = countTextField.tag;
                NSMutableDictionary *record = [self.goodsInfoArray objectAtIndex:k];
                NSString *goodsId = [record objectForKey:@"id"];
               if([goodsModel updateCartData:goodsId goodsCount:countTextField.text])
               {
                   [self refreshData];
                   [self.goodsTableView reloadData];
               }
            }
        }
        self.navigationItem.rightBarButtonItem.title = @"编辑";
    }
}

- (NSMutableArray *)textFieldArray
{
    if(_textFieldArray == nil)
    {
        _textFieldArray = [[NSMutableArray alloc]init];
    }
    return _textFieldArray;
}

- (NSMutableArray *)labelArray
{
    if(_labelArray == nil)
    {
        _labelArray = [[NSMutableArray alloc]init];
    }
    return _labelArray;
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
   if([string isEqualToString:@"0"])
   {
       return NO;
   }else{
       return YES;
   }
}

- (UIView *)footerView
{
    if(_footerView == nil)
    {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0,self.goodsTableView.frame.size.height, 320, 100)];
        self.footerFirstLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 20)];
        [self.footerFirstLabel setText:[NSString stringWithFormat:@"原始金额 : ￥%@ - 返现 : ￥0.00",self.totalAmount]];
        [self.footerFirstLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_footerView addSubview:self.footerFirstLabel];
        UILabel *gongji = [[UILabel alloc]initWithFrame:CGRectMake(110, 35, 35, 20)];
        [gongji setFont:[UIFont systemFontOfSize:12.0]];
        [gongji setText:@"共计 : "];
        [_footerView addSubview:gongji];
        self.amountLabel = [[UILabel alloc]initWithFrame:CGRectMake(145, 35, 50, 20)];
        [self.amountLabel setTextColor:[UIColor redColor]];
        [self.amountLabel setFont:[UIFont systemFontOfSize:12.0]];
        [self.amountLabel setText:[NSString stringWithFormat:@"￥%@",self.totalAmount]];
        [_footerView addSubview:self.amountLabel];
        UIButton *payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [payButton setBackgroundImage:[UIImage imageNamed:@"carBuy.png"] forState:UIControlStateNormal];
        [payButton setFrame:CGRectMake(56, 60, 209, 40)];
        [payButton addTarget:self action:@selector(pay:) forControlEvents:UIControlEventTouchUpInside];
        [_footerView addSubview:payButton];
    }
    return _footerView;
}

- (void)pay:(id)sender
{
    
}
@end
