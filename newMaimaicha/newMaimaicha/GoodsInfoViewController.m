//
//  GoodsInfoViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-28.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "GoodsInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "YMGlobal.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "GoodsIntroViewController.h"
#import "UILabelStrikeThrough.h"
#import "CommentsViewController.h"
#import "YMDbClass.h"
@interface GoodsInfoViewController ()

@end

@implementation GoodsInfoViewController
@synthesize goodsId;
@synthesize goodsName;
@synthesize flowView = _flowView;
@synthesize goodsModel = _goodsModel;
@synthesize propertyTableView = _propertyTableView;
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
    UIScrollView *selfview = (UIScrollView *)self.view;
    [selfview setContentSize:CGSizeMake(320, 560)];
    selfview.showsVerticalScrollIndicator = NO;
    selfview.bounces = NO;
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = self.goodsName;
    [self.view addSubview:self.flowView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 170, 320, 1)];
    [lineView setBackgroundColor:[UIColor colorWithRed:215/255.0 green:215/255.0 blue:215/255.0 alpha:1.0]];
    [self.view addSubview:lineView];
    
    //goodsName
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 181, 270, 40)];
    [nameLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.view addSubview:nameLabel];
    //price
    UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 241, 80, 40)];
    [priceLabel setFont:[UIFont systemFontOfSize:19.0]];
    [priceLabel setTextColor:[UIColor redColor]];
    [self.view addSubview:priceLabel];
    
    //mktPrice
    UILabelStrikeThrough *mktLabel = [[UILabelStrikeThrough alloc]initWithFrame:CGRectMake(95, 247, 80, 40)];
    [mktLabel setFont:[UIFont systemFontOfSize:12.0]];
    mktLabel.strikeThroughEnabled = YES;
    [mktLabel setTextColor:[UIColor grayColor]];
    
    [self.view addSubview:mktLabel];
    
    //store
    UILabel *storeLabel = [[UILabel alloc]initWithFrame:CGRectMake(240, 245, 80, 40)];
    [storeLabel setFont:[UIFont systemFontOfSize:14.0]];
    [storeLabel setTextColor:[UIColor grayColor]];
    [self.view addSubview:storeLabel];
    
    //buy
    UIButton *buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyButton setFrame:CGRectMake(56, 290, 208, 41)];
    [buyButton setBackgroundImage:[UIImage imageNamed:@"quickBuyBtn.png"] forState:UIControlStateNormal];
    [buyButton addTarget:self action:@selector(buy:) forControlEvents:UIControlEventTouchUpInside];
    [buyButton setEnabled:NO];
    [self.view addSubview:buyButton];

    //property tableView
    [self.view addSubview:self.propertyTableView];
    
    //network loading...
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"goods_getInfoByGoodsId" forKey:@"act"];
    [params setObject:self.goodsId forKey:@"goodsId"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"respon:%@",[completedOperation responseString]);
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            NSMutableDictionary *goodsInfo = [[obj objectForKey:@"result"] objectAtIndex:0];
            self.goodsModel.name = [goodsInfo objectForKey:@"name"];
            CGSize size = [self.goodsModel.name sizeWithFont:[UIFont systemFontOfSize:16.0] constrainedToSize:CGSizeMake(270, 1000)];
            [nameLabel setFrame:CGRectMake(10, 180, size.width, size.height)];
            [nameLabel setNumberOfLines:0];
            [nameLabel setText:self.goodsModel.name];
            self.goodsModel.price = [NSString stringWithFormat:@"%.2f",[[goodsInfo objectForKey:@"price"] floatValue]];
            self.goodsModel.mktPrice = [NSString stringWithFormat:@"%.2f",[[goodsInfo objectForKey:@"mktPrice"] floatValue]];
            self.goodsModel.imageArray = [goodsInfo objectForKey:@"imageUrls"];
            self.goodsModel.property = [goodsInfo objectForKey:@"property"];
            self.goodsModel.store =[goodsInfo objectForKey:@"store"];
            self.goodsModel.goodsId = self.goodsId;
            self.goodsModel.buyCount = @"1";
            [priceLabel setText:[NSString stringWithFormat:@"￥%@",self.goodsModel.price]];
            [priceLabel setFrame:CGRectMake(5, nameLabel.frame.size.height+nameLabel.frame.origin.y+5, 90, 40)];
            [mktLabel setText:[NSString stringWithFormat:@"市场价:￥%@",self.goodsModel.price]];
            [mktLabel setFrame:CGRectMake(95, nameLabel.frame.size.height+nameLabel.frame.origin.y+6, 100, 40)];
            [storeLabel setText:[NSString stringWithFormat:@"库存量:%@",self.goodsModel.store]];
            [storeLabel setFrame:CGRectMake(240, nameLabel.frame.size.height+nameLabel.frame.origin.y+6, 80, 40)];
            [buyButton setFrame:CGRectMake(56, priceLabel.frame.size.height+priceLabel.frame.origin.y+15, 208, 41)];
            [buyButton setEnabled:YES];
            [self.propertyTableView setFrame:CGRectMake(0, buyButton.frame.origin.y+buyButton.frame.size.height+20, 320, 220)];
            [self.propertyTableView reloadData];
            [self.flowView reloadData];
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



#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(SBPageFlowView *)flowView{
    return 2;

}

- (CGSize)sizeForPageInFlowView:(SBPageFlowView *)flowView;{
    return CGSizeMake(150, 150);
}

//返回给某列使用的View
- (UIView *)flowView:(SBPageFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    UIImageView *imageView = (UIImageView *)[flowView dequeueReusableCell];
    if (!imageView) {
        imageView = [[UIImageView alloc] init];
        imageView.layer.masksToBounds = YES;
        imageView.layer.borderColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0].CGColor;
        imageView.layer.borderWidth = 2;
    }
    imageView.image = [UIImage imageNamed:@"goods_default.png"];
    if((self.goodsModel.imageArray !=nil)&&([self.goodsModel.imageArray count]>0))
    {
        [YMGlobal loadImage:[[self.goodsModel.imageArray objectAtIndex:index] objectForKey:@"url"] andImageView:imageView];
    }
        return imageView;
}

#pragma mark - PagedFlowView Delegate
- (void)didReloadData:(UIView *)cell cellForPageAtIndex:(NSInteger)index
{
    UIImageView *imageView = (UIImageView *)cell;
     imageView.image = [UIImage imageNamed:@"goods_default.png"];
    if(self.goodsModel.imageArray !=nil)
    {
        [YMGlobal loadImage:[[self.goodsModel.imageArray objectAtIndex:index] objectForKey:@"url"] andImageView:imageView];
    }
}

- (SBPageFlowView *)flowView
{
    if(_flowView == nil)
    {
        _flowView = [[SBPageFlowView alloc] initWithFrame:CGRectMake(0, 10, self.view.bounds.size.width, 150)];
        _flowView.delegate = self;
        _flowView.dataSource = self;
        _flowView.minimumPageAlpha = 0.4;
        _flowView.minimumPageScale = 0.8;
        _flowView.backgroundColor = [UIColor whiteColor];
        _flowView.defaultImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_default.png"]];
        [_flowView reloadData];
    }
    return _flowView;
}

 - (goodsModel *)goodsModel
{
    if(_goodsModel == nil)
    {
        _goodsModel = [[goodsModel alloc]init];
    }
    return _goodsModel;
}

- (void)buy:(id)sender
{
    [goodsModel creatTable];
    [goodsModel AddCar:self.goodsModel];
    [self statisCart];
}

- (UITableView *)propertyTableView
{
    if(_propertyTableView == nil)
    {
        _propertyTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 370, 320, 400) style:UITableViewStyleGrouped];
        _propertyTableView.delegate = self;
        _propertyTableView.dataSource = self;
        _propertyTableView.backgroundView = nil;
        _propertyTableView.showsVerticalScrollIndicator = NO;
        _propertyTableView.scrollEnabled = NO;
    }
    return _propertyTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        return 80;
    }else if (indexPath.section == 1){
        return 40;
    }else{
        return 40;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        static NSString *identifier = @"property";
         UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if(self.goodsModel.name !=nil)
        {
            //name
            UILabel *weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 7, 300, 15)];
            weightLabel.font = [UIFont systemFontOfSize:13.0];
            weightLabel.text = [NSString stringWithFormat:@"商品重量: %@g",[self.goodsModel.property objectForKey:@"goodsWeight"]];
            [weightLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:weightLabel];
            //sn
            UILabel *snLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 25, 300, 15)];
            snLabel.font = [UIFont systemFontOfSize:13.0];
            snLabel.text = [NSString stringWithFormat:@"商品货号: %@",[self.goodsModel.property objectForKey:@"goodsBn"]];
            [snLabel setBackgroundColor:[UIColor clearColor]];
             [cell.contentView addSubview:snLabel];
            //brand
            UILabel *brandLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 43, 300, 15)];
            brandLabel.font = [UIFont systemFontOfSize:13.0];
            brandLabel.text = [NSString stringWithFormat:@"商品品牌: %@",[self.goodsModel.property objectForKey:@"goodsBrand"]];
            [brandLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:brandLabel];
            //unit
            UILabel *unitLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 300, 15)];
            unitLabel.font = [UIFont systemFontOfSize:13.0];
            unitLabel.text = [NSString stringWithFormat:@"源产地: %@",[self.goodsModel.property objectForKey:@"goodsUnit"]];
            [unitLabel setBackgroundColor:[UIColor clearColor]];
            [cell.contentView addSubview:unitLabel];
        }
        return cell; 
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"info"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
         cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = @"商品详情";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;

    }else {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
         cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.text = @"商品评论";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        GoodsIntroViewController *introVC = [[GoodsIntroViewController alloc]init];
        introVC.goodsId = self.goodsId;
        [self presentViewController:introVC animated:NO completion:nil];
    }else if (indexPath.section == 2){
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
       [backItem setTintColor:[UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0]];
        CommentsViewController *commentVC = [[CommentsViewController alloc]init];
        commentVC.goodsId = self.goodsId;
        self.navigationItem.backBarButtonItem = backItem;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}


- (void)statisCart
{
    YMDbClass *db = [[YMDbClass alloc]init];
    if([db connect])
    {
        [[self.tabBarController.tabBar.items objectAtIndex:2] setBadgeValue:[db count_sum:@"goodslist_car" tablefiled:@"goods_count"]];
    }
    [db close];
}
@end
