//
//  IndexViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "IndexViewController.h"
#import "SearchViewController.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "GoodsInfoViewController.h"
@interface IndexViewController ()

@end

@implementation IndexViewController
@synthesize adScrollView = _adScrollView;
@synthesize commendGoodsList;
@synthesize pageCtrol = _pageCtrol;
@synthesize nhScrollView = _nhScrollView;
@synthesize comScrollView = _comScrollView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIButton *searchView = [UIButton buttonWithType:UIButtonTypeCustom];
        [searchView setImage:[UIImage imageNamed:@"search_ico.png"] forState:UIControlStateNormal];
        [searchView setFrame:CGRectMake(0, 0, 25, 20)];
        [searchView addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:searchView];
        //self.navigationItem.rightBarButtonItem = searchItem;
        UIButton *kongView = [UIButton buttonWithType:UIButtonTypeCustom];
        [kongView setFrame:CGRectMake(0, 0, 5, 20)];
        UIBarButtonItem *kongItem = [[UIBarButtonItem alloc]initWithCustomView:kongView];
        
        UIButton *dbView = [UIButton buttonWithType:UIButtonTypeCustom];
        [dbView setImage:[UIImage imageNamed:@"barcode_ico.png"] forState:UIControlStateNormal];
        [dbView setFrame:CGRectMake(0, 0, 25, 20)];
        [dbView addTarget:self action:@selector(dbItemClick:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *dbItem = [[UIBarButtonItem alloc]initWithCustomView:dbView];
        self.navigationItem.rightBarButtonItems = @[kongItem,searchItem,kongItem,dbItem];
        
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 35)];
        [rightView setImage:[UIImage imageNamed:@"mmc.png"]];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightView];
        self.tabBarItem.title = @"首页";
        [self.tabBarItem setImage:[UIImage imageNamed:@"tabbar_index_unselected.png"]];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_index.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_index_unselected.png"]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIScrollView *rootView = (UIScrollView *)self.view;
    [rootView setContentSize:CGSizeMake(320, 566)];
   //初始化广告
    [self.view addSubview:self.adScrollView];
    
    UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 129, 320, 35)];
    hotLabel.layer.borderWidth = 1.0;
    hotLabel.layer.borderColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:0.5].CGColor;
    hotLabel.text = @"  热销商品";
    hotLabel.textColor = [UIColor colorWithRed:23/255.0 green:132/255.0 blue:17/255.0 alpha:1.0];
    hotLabel.textAlignment = NSTextAlignmentLeft;
    [hotLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:hotLabel];
    
    UILabel *commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 244, 320, 35)];
    commentLabel.layer.borderWidth = 1.0;
    commentLabel.layer.borderColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:0.5].CGColor;
    commentLabel.text = @"  推荐商品";
    commentLabel.textColor = [UIColor colorWithRed:23/255.0 green:132/255.0 blue:17/255.0 alpha:1.0];
    commentLabel.textAlignment = NSTextAlignmentLeft;
    [commentLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:commentLabel];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 408, 320, 35)];
    newLabel.layer.borderWidth = 1.0;
    newLabel.layer.borderColor = [UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:0.5].CGColor;
    newLabel.text = @"  新品上架";
    newLabel.textColor = [UIColor colorWithRed:23/255.0 green:132/255.0 blue:17/255.0 alpha:1.0];
    newLabel.textAlignment = NSTextAlignmentLeft;
    [newLabel setFont:[UIFont systemFontOfSize:17.0]];
    [self.view addSubview:newLabel];
      //添加最新最热
    [self addNewHot];
    // 获取广告
    [self.view addSubview:self.nhScrollView];
    [self.view addSubview:self.comScrollView];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"ad_getAdList" forKey:@"act"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if([[object objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.adListArray = [object objectForKey:@"result"];
            [self loadAdList];
            [self.view addSubview:self.pageCtrol];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
    }];
    [ApplicationDelegate.engine enqueueOperation: op];
    
    [self loadNewList];
    [self loadComList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//开始加载ad
- (void)loadAdList
{
    if([self.adListArray count] >0)
    {
        self.adScrollView.contentSize = CGSizeMake(320*[self.adListArray count], 129);
        int i=0;
        for(id o in self.adListArray)
        {
            UIButton *imageBtn = [[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 320, 129)];
            [imageBtn setBackgroundImage:[UIImage imageNamed:@"ad_default.png"] forState:UIControlStateNormal];
            NSDictionary *obj = (NSDictionary *)o;
            [YMGlobal loadImage:[obj objectForKey:@"imageUrl"] andButton:imageBtn andControlState:UIControlStateNormal];
            [self.adScrollView addSubview:imageBtn];
            i++;
        }
    }
}
//添加最新最热
- (void)addNewHot
{
    
    UIButton *singleImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 164, 160, 80)];
    UIButton *HotImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 164, 160, 80)];
    [singleImageBtn setBackgroundImage:[UIImage imageNamed:@"ad_default.png"] forState:UIControlStateNormal];
    [HotImageBtn setBackgroundImage:[UIImage imageNamed:@"ad_default.png"] forState:UIControlStateNormal];
    [self.view addSubview:singleImageBtn];
    [self.view addSubview:HotImageBtn];
    //加载热销单品
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"ad_getSingleGoodsImage" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"] isEqualToString:@"0"])
        {
            NSMutableDictionary *imageURLDic = [obj objectForKey:@"result"];
            singleImageBtn.tag = [[imageURLDic objectForKey:@"goodsId"] integerValue];
            [singleImageBtn addTarget:self action:@selector(goodsPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [YMGlobal loadImage:[imageURLDic objectForKey:@"imageUrl"] andButton:singleImageBtn andControlState:UIControlStateNormal];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
    //加载第二个热销图片
    NSMutableDictionary *paramhot = [[NSMutableDictionary alloc]init];
    [paramhot setObject:@"ad_getHotImage" forKey:@"act"];
    MKNetworkOperation *opHot = [YMGlobal getOperation:paramhot];
    [opHot addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"hotImage%@",[completedOperation responseString]);
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"] isEqualToString:@"0"])
        {
            NSMutableDictionary *hotDic = [obj objectForKey:@"result"];
            [HotImageBtn addTarget:self action:@selector(hotPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            [YMGlobal loadImage:[hotDic objectForKey:@"imageUrl"] andButton:HotImageBtn andControlState:UIControlStateNormal];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:opHot];
}


//点击搜索
- (void)search:(id)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self presentViewController:searchVC animated:NO completion:nil];
}

//点击二维码
- (void)dbItemClick:(id)sender
{
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    ZBarImageScanner *scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    [self presentViewController:reader animated:YES completion:nil];
}

//解析二维码
 - (void)imagePickerController:(UIImagePickerController *)reader didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [reader dismissViewControllerAnimated:YES completion:nil];
    NSString *url = symbol.data;
    NSString *regEx = @"wap-[0-9]+_1-index";
    NSRange r = [url rangeOfString:regEx options:NSRegularExpressionSearch];
    if (r.location != NSNotFound) {
        NSString *str = [[url substringWithRange:r] stringByReplacingOccurrencesOfString:@"wap-" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"_1-index" withString:@""];
        // 这里还需要进行处理
        // 通过商品编码获取商品id，再加入到购物车里
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"商品的编码是:%@",str] delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有对应的商品" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
    }

}

- (UIScrollView *)adScrollView
{
    if(_adScrollView == nil)
    {
        _adScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 129)];
        _adScrollView.contentSize = CGSizeMake(320, 129);
        _adScrollView.pagingEnabled = true;
        _adScrollView.tag =1;
        _adScrollView.delegate = self;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.bounces = NO;
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 129)];
        [imageView setImage:[UIImage imageNamed:@"ad_default.png"]];
        [imageView setBackgroundColor:[UIColor blackColor]];
        [_adScrollView addSubview:imageView];
    }
    return _adScrollView;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 1)
    {
        CGFloat contentoffset = scrollView.contentOffset.x;
        int i = floor(contentoffset/310);
        [self.pageCtrol setCurrentPage:i];
    }
}

- (UIPageControl *)pageCtrol
{
    if(_pageCtrol == nil)
    {
        _pageCtrol = [[UIPageControl alloc]initWithFrame:CGRectMake(-200, 109, 920, 20)];
        _pageCtrol.numberOfPages = 3;
        _pageCtrol.currentPage = 0;
        [_pageCtrol setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]];
    }
    return _pageCtrol;
}

- (void)teaBtn1Pressed:(id)sender
{
    
}

- (UIScrollView *)nhScrollView
{
    if(_nhScrollView == nil)
    {
        _nhScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 443, 320, 133)];
        _nhScrollView.contentSize = CGSizeMake(320, 129);
       // _nhScrollView.pagingEnabled = true;
        _nhScrollView.tag =1;
        _nhScrollView.delegate = self;
        _nhScrollView.showsHorizontalScrollIndicator = NO;
        _nhScrollView.showsVerticalScrollIndicator = NO;
       // _nhScrollView.bounces = NO;
    }
    return _nhScrollView;
}

- (UIScrollView *)comScrollView
{
    if(_comScrollView == nil)
    {
        _comScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 280, 320, 133)];
        _comScrollView.contentSize = CGSizeMake(320, 150);
       // _comScrollView.pagingEnabled = true;
        _comScrollView.tag =1;
        _comScrollView.delegate = self;
        _comScrollView.showsHorizontalScrollIndicator = NO;
        _comScrollView.showsVerticalScrollIndicator = NO;
        //_comScrollView.bounces = NO;
    }
    return _comScrollView;
}

- (void)loadNewList
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"goods_getNewList" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSLog(@"newList%@",[completedOperation responseString]);
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            NSMutableArray *newListArray = [obj objectForKey:@"result"];
            int count = [newListArray count];
            self.nhScrollView.contentSize = CGSizeMake(107*count, 108);
            for(int k=0;k<count;k++)
            {
                NSMutableDictionary *goods = [newListArray objectAtIndex:k];
                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(k*107, 0, 107, 108)];
                UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [newButton setImage:[UIImage imageNamed:@"goods_default.png"] forState:UIControlStateNormal];
                [newButton setFrame:CGRectMake(15, 10, 77, 67)];
                [newButton setTag:[[goods objectForKey:@"goodsId"] integerValue]];
                [newButton addTarget:self action:@selector(goodsPressed:) forControlEvents:UIControlEventTouchUpInside];
                [YMGlobal loadButtonImage:[goods objectForKey:@"imageUrl"] andButton:newButton andControlState:UIControlStateNormal];
                UILabel *goodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 77, 97, 30)];
                [goodsLabel setNumberOfLines:0];
                [goodsLabel setFont:[UIFont systemFontOfSize:11.0]];
                NSString *nameString = [NSString stringWithFormat:@"%@",[goods objectForKey:@"goodsName"]];
                if([nameString length]>11)
                {
                    nameString = [nameString substringToIndex:11];
                }
                [goodsLabel setText:nameString];
                [goodsLabel setTextColor:[UIColor blackColor]];
                [goodsLabel setBackgroundColor:[UIColor clearColor]];
                [goodsLabel setTextAlignment:NSTextAlignmentCenter];
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 107, 107, 15)];
                priceLabel.font = [UIFont systemFontOfSize:12.0];
                priceLabel.textColor = [UIColor redColor];
                [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[goods objectForKey:@"goodsPrice"] floatValue]]];
                [priceLabel setTextAlignment:NSTextAlignmentCenter];
                [backView addSubview:priceLabel];
                [backView addSubview:newButton];
                [backView addSubview:goodsLabel];
                [self.nhScrollView addSubview:backView];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}


- (void)loadComList
{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"goods_getRecommendList" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            NSMutableArray *newListArray = [obj objectForKey:@"result"];
            int count = [newListArray count];
            int i = ceil(count/3);
            self.comScrollView.contentSize = CGSizeMake(320*i, 108);
            for(int k=0;k<count;k++)
            {
                NSMutableDictionary *goods = [newListArray objectAtIndex:k];
                UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(k*107, 0, 107, 108)];
                UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [newButton setImage:[UIImage imageNamed:@"goods_default.png"] forState:UIControlStateNormal];
                [newButton setFrame:CGRectMake(15, 10, 77, 67)];
                [newButton setTag:[[goods objectForKey:@"goodsId"] integerValue]];
                [newButton addTarget:self action:@selector(goodsPressed:) forControlEvents:UIControlEventTouchUpInside];
                [YMGlobal loadButtonImage:[goods objectForKey:@"imageUrl"] andButton:newButton andControlState:UIControlStateNormal];
                UILabel *goodsLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 77, 97, 30)];
                [goodsLabel setNumberOfLines:0];
                [goodsLabel setFont:[UIFont systemFontOfSize:11.0]];
                NSString *nameString = [NSString stringWithFormat:@"%@",[goods objectForKey:@"goodsName"]];
                if([nameString length]>11)
                {
                    nameString = [nameString substringToIndex:11];
                }
                [goodsLabel setText:nameString];
                [goodsLabel setTextColor:[UIColor blackColor]];
                [goodsLabel setBackgroundColor:[UIColor clearColor]];
                [goodsLabel setTextAlignment:NSTextAlignmentCenter];
                UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 107, 107, 15)];
                priceLabel.font = [UIFont systemFontOfSize:12.0];
                priceLabel.textColor = [UIColor redColor];
                [priceLabel setText:[NSString stringWithFormat:@"￥%.2f",[[goods objectForKey:@"goodsPrice"] floatValue]]];
                [priceLabel setTextAlignment:NSTextAlignmentCenter];
                [backView addSubview:newButton];
                [backView addSubview:goodsLabel];
                [backView addSubview:priceLabel];
                [self.comScrollView addSubview:backView];
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}

- (void)goodsPressed:(id)sender
{
    UIButton *goodsBtn = sender;
    GoodsInfoViewController *goodsInfo = [[GoodsInfoViewController alloc]init];
    goodsInfo.goodsId = [NSString stringWithFormat:@"%i",goodsBtn.tag];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    backItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:goodsInfo animated:YES];
}

- (void)hotPressed:(id)sender
{
    
}
@end
