//
//  GoodsListViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-27.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "GoodsListViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "GoodsListCell.h"
#import "GoodsInfoViewController.h"
@interface GoodsListViewController ()

@end

@implementation GoodsListViewController
@synthesize goodsListTableView = _goodsListTableView;
@synthesize goodsListArray;
@synthesize headBgView;
@synthesize catId;
@synthesize catName;
@synthesize priceButton = _priceButton;
@synthesize buyCountButton = _buyCountButton;
@synthesize viewCountButton = _viewCountButton;
@synthesize orderBy;
@synthesize sort;
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
    self.navigationItem.title = self.catName;
    self.headBgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    [headBgView setBackgroundColor:[UIColor whiteColor]];
    [headBgView setUserInteractionEnabled:YES];
    [self.view addSubview:self.headBgView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, 320, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:0.5]];
    [self.headBgView addSubview:lineView];
    [self.headBgView addSubview:self.priceButton];
    [self.headBgView addSubview:self.buyCountButton];
    [self.headBgView addSubview:self.viewCountButton];
    [self.view addSubview:self.goodsListTableView];
    
    [self.view bringSubviewToFront:self.headBgView];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [param setObject:self.catId forKey:@"catId"];
    [param setObject:@"goods_getListByCatId" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [hud hide:YES];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.goodsListArray = [obj objectForKey:@"result"];
            NSLog(@"goodsListArray:%@",self.goodsListArray);
            [self.goodsListTableView reloadData];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
        [hud hide:YES];
    }];
    [ApplicationDelegate.engine enqueueOperation:op];   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.goodsListArray != nil)
    {
        return [self.goodsListArray count];
    }else{
        return 0;
    }
}
//goodsId   goodsName   goodsPrice  imageUrl

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    GoodsListCell *cell = (GoodsListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[GoodsListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.goodsListArray != nil)
    {
        NSString *urlString = [[self.goodsListArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"];
        [YMGlobal loadFlipImage:urlString andImageView:cell.goodsImageView];
        NSString *nameString = [[self.goodsListArray objectAtIndex:indexPath.row] objectForKey:@"goodsName"];
        CGSize nameLabelSize =  [nameString sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(190, 1000.0)];
        cell.goodsNameLabel.numberOfLines = 0;
        [cell.goodsNameLabel setFrame:CGRectMake(120, 0, nameLabelSize.height, nameLabelSize.width)];
        cell.goodsNameLabel.text = nameString;
        cell.goodsNameLabel.font = [UIFont systemFontOfSize:13.0];
        cell.goodsNameLabel.textAlignment = NSTextAlignmentCenter;
        [cell.goodsNameLabel setFrame:CGRectMake(100, 15, nameLabelSize.width, nameLabelSize.height)];
        [cell.goodsPriceLabel setFrame:CGRectMake(100, 50, 100, 20)];
        [cell.goodsPriceLabel setFont:[UIFont systemFontOfSize:13.0]];
        cell.goodsPriceLabel.textColor = [UIColor redColor];
        NSString *detailString = [NSString stringWithFormat:@"￥%.2f",[[[self.goodsListArray objectAtIndex:indexPath.row]objectForKey:@"goodsPrice"] floatValue]];
        cell.goodsPriceLabel.text = detailString;
    }
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.goodsListTableView tableViewDidDragging];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int state = [self.goodsListTableView tableViewDidEndDragging];
    int countPage = (int)ceil([goodsListArray count]/10);
    if(state == k_RETURN_LOADMORE){
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"goods_getListByCatId" forKey:@"act"];
        [params setObject:self.catId forKey:@"catId"];
        [params setObject:[NSString stringWithFormat:@"%i",countPage+1] forKey:@"page"];
        if(self.orderBy != nil)
        [params setObject:self.sort forKey:self.orderBy];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [HUD hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                NSMutableArray *temArry = [obj objectForKey:@"result"];
                if([temArry count]>5)
                {
                    for(id o in temArry)
                    {
                        [self.goodsListArray addObject:o];
                    }
                    [self.goodsListTableView reloadData:YES];
                }else{
                    [self.goodsListTableView reloadData:NO];
                }
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",error);
            [HUD hide:YES];
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }else if (state == k_RETURN_REFRESH){
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"goods_getListByCatId" forKey:@"act"];
        [params setObject:self.catId forKey:@"catId"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [HUD hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                self.goodsListArray = [obj objectForKey:@"result"];
                if([self.goodsListArray count]>0)
                {
                    [self.goodsListTableView reloadData:YES];
                }else{
                    [self.goodsListTableView reloadData:NO];
                }
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",error);
            [HUD hide:YES];
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }
}

- (PullToRefreshTableView *)goodsListTableView
{
    if(_goodsListTableView == nil)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _goodsListTableView = [[PullToRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, 320, size.height-120)];
        _goodsListTableView.delegate = self;
        _goodsListTableView.dataSource = self;
        _goodsListTableView.showsVerticalScrollIndicator = NO;
    }
    return _goodsListTableView;
}

//↓↑

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *goodsId = [[self.goodsListArray objectAtIndex:indexPath.row] objectForKey:@"goodsId"];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]init];
    goodsInfoVC.goodsId = goodsId;
    goodsInfoVC.goodsName = self.catName;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backItem setTintColor:[UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

-(UIButton *)priceButton
{
    if(_priceButton == nil)
    {
        _priceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_priceButton setBackgroundImage:[UIImage imageNamed:@"android_sort_left.png"] forState:UIControlStateNormal];
        [_priceButton setFrame:CGRectMake(20,5,90, 25)];
        [_priceButton addTarget:self action:@selector(priceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        _priceButton.tag = 0;
        [_priceButton setTitle:@"价格" forState:UIControlStateNormal];
        [_priceButton setTintColor:[UIColor blackColor]];
        _priceButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_priceButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _priceButton;
}

-(UIButton *)buyCountButton
{
    if(_buyCountButton == nil)
    {
        _buyCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buyCountButton setBackgroundImage:[UIImage imageNamed:@"android_sort_middle.png"] forState:UIControlStateNormal];
        [_buyCountButton setFrame:CGRectMake(110,5,90, 25)];
        [_buyCountButton addTarget:self action:@selector(buyCountButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_buyCountButton setTitle:@"销量" forState:UIControlStateNormal];
        [_buyCountButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _buyCountButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    }
    return _buyCountButton;
}

-(UIButton *)viewCountButton
{
    if(_viewCountButton == nil)
    {
        _viewCountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_viewCountButton setBackgroundImage:[UIImage imageNamed:@"android_sort_right.png"] forState:UIControlStateNormal];
        [_viewCountButton setFrame:CGRectMake(200,5,90, 25)];
        [_viewCountButton addTarget:self action:@selector(viewCountButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_viewCountButton setTitle:@"人气" forState:UIControlStateNormal];
        [_viewCountButton setTintColor:[UIColor blackColor]];
        _viewCountButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
        [_viewCountButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    return _viewCountButton;
}

- (void)priceButtonPressed:(id)sender
{
    [self.viewCountButton setBackgroundImage:[UIImage imageNamed:@"android_sort_right.png"] forState:UIControlStateNormal];
    [self.buyCountButton setBackgroundImage:[UIImage imageNamed:@"android_sort_middle.png"] forState:UIControlStateNormal];
    UIButton *pressedButton = sender;
    if(pressedButton.tag == 0){
        self.orderBy = @"priceOrder";
        self.sort = @"asc";
        pressedButton.tag = 1;
        [pressedButton setBackgroundImage:[UIImage imageNamed:@"price_up.png"] forState:UIControlStateNormal];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"goods_getListByCatId" forKey:@"act"];
        [params setObject:self.catId forKey:@"catId"];
        [params setObject:@"asc" forKey:@"priceOrder"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [HUD hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                self.goodsListArray = [obj objectForKey:@"result"];
                [self.goodsListTableView reloadData];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [HUD hide:YES];
            NSLog(@"%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }else if (pressedButton.tag == 2){
        pressedButton.tag = 1;
        self.orderBy = @"priceOrder";
        self.sort = @"asc";
        [pressedButton setBackgroundImage:[UIImage imageNamed:@"price_up.png"] forState:UIControlStateNormal];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"goods_getListByCatId" forKey:@"act"];
        [params setObject:self.catId forKey:@"catId"];
        [params setObject:@"asc" forKey:@"priceOrder"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [HUD hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                self.goodsListArray = [obj objectForKey:@"result"];
                [self.goodsListTableView reloadData];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [HUD hide:YES];
            NSLog(@"%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }else{
        self.orderBy = @"priceOrder";
        self.sort = @"desc";
        pressedButton.tag = 2;
        [pressedButton setBackgroundImage:[UIImage imageNamed:@"price_down.png"] forState:UIControlStateNormal];
        MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"goods_getListByCatId" forKey:@"act"];
        [params setObject:self.catId forKey:@"catId"];
        [params setObject:@"desc" forKey:@"priceOrder"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [HUD hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                self.goodsListArray = [obj objectForKey:@"result"];
                [self.goodsListTableView reloadData];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [HUD hide:YES];
            NSLog(@"%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }
}
- (void)buyCountButtonPressed:(id)sender
{
    self.orderBy = @"buyCount";
    self.sort = @"desc";
    [self.priceButton setBackgroundImage:[UIImage imageNamed:@"android_sort_left.png"] forState:UIControlStateNormal];
    [self.viewCountButton setBackgroundImage:[UIImage imageNamed:@"android_sort_right.png"] forState:UIControlStateNormal];
    UIButton *pressedButton = sender;
    [pressedButton setBackgroundImage:[UIImage imageNamed:@"android_sort_middle_pressed.png"] forState:UIControlStateNormal];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"goods_getListByCatId" forKey:@"act"];
    [params setObject:self.catId forKey:@"catId"];
    [params setObject:@"desc" forKey:@"buyCount"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [HUD hide:YES];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.goodsListArray = [obj objectForKey:@"result"];
            [self.goodsListTableView reloadData];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [HUD hide:YES];
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];

}
- (void)viewCountButtonPressed:(id)sender
{
    self.orderBy = @"viewCount";
    self.sort  = @"desc";
    [self.priceButton setBackgroundImage:[UIImage imageNamed:@"android_sort_left.png"] forState:UIControlStateNormal];
    [self.buyCountButton setBackgroundImage:[UIImage imageNamed:@"android_sort_middle.png"] forState:UIControlStateNormal];
    UIButton *pressedButton = sender;
    [pressedButton setBackgroundImage:[UIImage imageNamed:@"android_sort_right_pressed.png"] forState:UIControlStateNormal];
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"goods_getListByCatId" forKey:@"act"];
    [params setObject:self.catId forKey:@"catId"];
    [params setObject:@"desc" forKey:@"viewCount"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [HUD hide:YES];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.goodsListArray = [obj objectForKey:@"result"];
            [self.goodsListTableView reloadData];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [HUD hide:YES];
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}
@end
