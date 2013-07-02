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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"购物车";
        self.navigationItem.title = @"购物车";
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
        NSLog(@"jige:%i",resultArray.count);
        if(resultArray != nil)
        {
            self.goodsInfoArray = resultArray;
            if(self.goodsTableView == nil)
            {
                NSLog(@"add");
                self.goodsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.goodsInfoArray.count*80) style:UITableViewStylePlain];
                self.goodsTableView.dataSource = self;
                self.goodsTableView.delegate = self;
                [self.view addSubview:self.goodsTableView];
            }else{
                NSLog(@"reloadself.goodsINfoArray:%@",self.goodsInfoArray);
                [self.goodsTableView reloadData];
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
    NSLog(@"viewdidload");

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count:%i",self.goodsInfoArray.count);
    return self.goodsInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    cartCell *cell = [[cartCell alloc]init];
    cell.nameLabel.text = [[self.goodsInfoArray objectAtIndex:indexPath.row] objectForKey:@"name"];
    cell.buyCountLabel.text = [[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"goods_count"];
    cell.buyCountField.text = [[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"goods_count"];
    cell.bnLabel.text = [NSString stringWithFormat:@"商品编号: %@",[[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"goodsBn"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"商品价格: ￥%.2f",[[[self.goodsInfoArray objectAtIndex:indexPath.row]objectForKey:@"price"] floatValue]];
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

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSLog(@"deletedelete");
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
    NSLog(@"11");
    [self.tabBarController setSelectedIndex:1];
}

- (void)refreshData
{
    if([goodsModel countGoods]>0)
    {
        NSMutableArray *resultArray = [goodsModel fetchGoodsList];
        if(resultArray != nil)
        {
            self.goodsInfoArray = resultArray;
        }
    }else{
        [self.view addSubview:self.cartNullView];
    }
}


@end
