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
@interface GoodsListViewController ()

@end

@implementation GoodsListViewController
@synthesize goodsListTableView = _goodsListTableView;
@synthesize goodsListArray;
@synthesize headBgView;
@synthesize segControl;
@synthesize catId;
@synthesize catName;
@synthesize sort;
@synthesize orderBy;
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
    [self.view addSubview:self.goodsListTableView];
    self.headBgView.layer.borderWidth = 1;
    self.headBgView.layer.borderColor = [UIColor grayColor].CGColor;
    [self.headBgView setFrame:CGRectMake(-0.5, 0, 321, 43)];
    [self.view bringSubviewToFront:self.headBgView];
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],UITextAttributeTextColor,[UIFont systemFontOfSize:12.0],UITextAttributeFont,[UIColor clearColor],UITextAttributeTextShadowColor,nil];
    [self.segControl setTintColor:[UIColor colorWithRed:228/255.0 green:244/255.0 blue:174/255.0 alpha:1.0]];
    [self.segControl setTitleTextAttributes:attribute forState:UIControlStateNormal];
    [self.segControl addTarget:self action:@selector(contrlSelected:) forControlEvents:UIControlEventValueChanged];
    
    [self.view bringSubviewToFront:self.segControl];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:self.catId forKey:@"catId"];
    [param setObject:@"goods_getListByCatId" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
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
    }
    if(self.goodsListArray != nil)
    {
        NSString *urlString = [[self.goodsListArray objectAtIndex:indexPath.row] objectForKey:@"imageUrl"];
        [YMGlobal loadFlipImage:urlString andImageView:cell.imageView];
        NSString *nameString = [[self.goodsListArray objectAtIndex:indexPath.row] objectForKey:@"goodsName"];
        CGSize nameLabelSize =  [nameString sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(190, 1000.0)];
        cell.goodsNameLabel.numberOfLines = 0;
        [cell.goodsNameLabel setFrame:CGRectMake(120, 0, nameLabelSize.height, nameLabelSize.width)];
        cell.goodsNameLabel.text = nameString;
        cell.goodsNameLabel.font = [UIFont systemFontOfSize:13.0];
        [cell.goodsNameLabel setFrame:CGRectMake(100, 15, nameLabelSize.width, nameLabelSize.height)];
        [cell.goodsPriceLabel setFrame:CGRectMake(100, 60, 100, 20)];
        [cell.goodsPriceLabel setFont:[UIFont systemFontOfSize:13.0]];
        cell.goodsPriceLabel.textColor = [UIColor redColor];
        NSString *detailString = [NSString stringWithFormat:@"￥%@",[[self.goodsListArray objectAtIndex:indexPath.row]objectForKey:@"goodsPrice"]];
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
        [params setObject:self.sort forKey:self.orderBy];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [HUD hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                NSMutableArray *temArry = [obj objectForKey:@"result"];
                if([temArry count]>0)
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
        _goodsListTableView = [[PullToRefreshTableView alloc]initWithFrame:CGRectMake(0, 44, 320, self.view.frame.size.height-200)];
        _goodsListTableView.delegate = self;
        _goodsListTableView.dataSource = self;
        _goodsListTableView.showsVerticalScrollIndicator = NO;
    }
    return _goodsListTableView;
}

//↓↑
- (void)contrlSelected:(id)sender
{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"goods_getListByCatId" forKey:@"act"];
    [params setObject:self.catId forKey:@"catId"];
    UISegmentedControl *seg = sender;
    if([seg selectedSegmentIndex] == 0)
    {
        self.orderBy = @"priceOrder";
        if([self.sort isEqualToString:@"desc"])
        {
            self.sort = @"asc";
            [params setObject:self.sort forKey:self.orderBy];
            [seg setTitle:@"价格 ↑" forSegmentAtIndex:0];
        }else if ([self.sort isEqualToString:@"asc"]){
            self.sort = @"desc";
            [params setObject:self.sort forKey:self.orderBy];
            [seg setTitle:@"价格 ↓" forSegmentAtIndex:0];
        }else{
            self.sort = @"asc";
            [params setObject:self.sort forKey:self.orderBy];
            [seg setTitle:@"价格 ↑" forSegmentAtIndex:0];
        }
    }else if ([seg selectedSegmentIndex] == 1){
        self.sort = @"desc";
        self.orderBy = @"buyCount";
        [params setObject:self.sort forKey:self.orderBy];
        [seg setTitle:@"价格" forSegmentAtIndex:0];
    }else{
        self.sort = @"desc";
        self.orderBy = @"viewCount";
        [params setObject:self.sort forKey:self.orderBy];
        [seg setTitle:@"人气" forSegmentAtIndex:0];
    }
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
