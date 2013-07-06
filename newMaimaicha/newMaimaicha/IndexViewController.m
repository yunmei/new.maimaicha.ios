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
@interface IndexViewController ()

@end

@implementation IndexViewController
@synthesize adScrollView = _adScrollView;
@synthesize adPageView = _adPageView;
@synthesize adPageProgressView = _adPageProgressView;
@synthesize commendGoodsList;
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
        
        UIImageView *rightView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 30)];
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
    // Do any additional setup after loading the view from its nib.
    UIScrollView *rootView = (UIScrollView *)self.view;
    [rootView setContentSize:CGSizeMake(320, 664)];
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 131, 320, 43)];
    UIImageView *searchBgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 43)];
    [searchBgImageView setImage:[UIImage imageNamed:@"search_bg"]];
    [searchView addSubview:searchBgImageView];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 5, 207, 31)];
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"search_btn"] forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:searchBtn];
    UIButton *tdbBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, 4, 91, 32)];
    [tdbBtn setBackgroundImage:[UIImage imageNamed:@"tdc_btn"] forState:UIControlStateNormal];
    [tdbBtn addTarget:self action:@selector(dbItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:tdbBtn];
    [self.view addSubview:searchView];
   //初始化广告
    [self.view addSubview:self.adScrollView];
    [self.view addSubview:self.adPageView];
    [self.adPageView addSubview:self.adPageProgressView];
    //添加最新最热
    [self addNewHot];
    //添加推荐商品列表
    [self addCommentList];
    // 获取广告
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObject:@"ad_getAdList" forKey:@"act"];
    MKNetworkOperation* op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *object = [parser objectWithData:[completedOperation responseData]];
        if([[object objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.adListArray = [object objectForKey:@"result"];
            [self loadAdList];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"Error:%@", error);
    }];
    [ApplicationDelegate.engine enqueueOperation: op];
    

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
    
    UIButton *hotImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 174, 160, 80)];
    UIButton *newImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(160, 174, 160, 80)];
    [hotImageBtn setBackgroundImage:[UIImage imageNamed:@"ad_default.png"] forState:UIControlStateNormal];
    [newImageBtn setBackgroundImage:[UIImage imageNamed:@"ad_default.png"] forState:UIControlStateNormal];
    [self.view addSubview:hotImageBtn];
    [self.view addSubview:newImageBtn];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"ad_getNHImage" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"] isEqualToString:@"0"])
        {
            NSLog(@"obj%@",obj);
            NSArray *imageURLArray = [obj objectForKey:@"result"];
            [YMGlobal loadImage:[[imageURLArray objectAtIndex:0] objectForKey:@"imageUrl"] andButton:hotImageBtn andControlState:UIControlStateNormal];
            [YMGlobal loadImage:[[imageURLArray objectAtIndex:1] objectForKey:@"imageUrl"] andButton:newImageBtn andControlState:UIControlStateNormal];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}

//添加推荐商品列表
- (void)addCommentList
{
    NSMutableArray *btnArray = [[NSMutableArray alloc]init];
    NSMutableArray *labelArray = [[NSMutableArray alloc]init];
    for (int i=0; i<9; i++) {
       float x = i%3*(320/3);
       float y = floor(i/3)*(320/3+30)+254;
        UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(x, y, 107, 320/3+30)];
        UIButton *goodsBtn = [[UIButton alloc]initWithFrame:CGRectMake(3.5, 3, 100, 90)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 95, 97, 42)];
        label.tag = i;
        [labelArray addObject:label];
        btnView.layer.borderWidth = 0.5;
        btnView.layer.borderColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1.0].CGColor;
        [goodsBtn setBackgroundImage:[UIImage imageNamed:@"goods_default.png"] forState:UIControlStateNormal];
        goodsBtn.tag = i;
        [goodsBtn addTarget:self action:@selector(goodsPressed:) forControlEvents:UIControlEventTouchUpInside];
        [btnView addSubview:goodsBtn];
        [btnView addSubview:label];
        [self.view addSubview:btnView];
        [btnArray addObject:goodsBtn];
    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"goods_getRecommendList" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            NSMutableArray *goodsArray = [obj objectForKey:@"result"];
            int i=0;
            for (id o in goodsArray) {
                NSMutableDictionary *goods = o;
                NSString *urlString = [goods objectForKey:@"imageUrl"];
                UILabel *nameLabel = [labelArray objectAtIndex:i];
                //[nameLabel setText:[goods objectForKey:@"goodsName"]];
                NSString *labelString = [goods objectForKey:@"goodsName"];
                CGSize size = [labelString sizeWithFont:[UIFont systemFontOfSize:11.0] constrainedToSize:CGSizeMake(97, 1000)];
                [nameLabel setFrame:CGRectMake(5, 95, size.width, size.height)];
                nameLabel.numberOfLines = 0;
                nameLabel.text = labelString;
                [nameLabel setFont:[UIFont systemFontOfSize:11.0]];
                [nameLabel setTextColor:[UIColor blackColor]];
                UIButton *goodsBtn = [btnArray objectAtIndex:i];
                
                [YMGlobal loadFlipImage:urlString andButton:goodsBtn andControlState:UIControlStateNormal];
                i++;
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
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
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 129)];
        [imageView setImage:[UIImage imageNamed:@"ad_default.png"]];
        [imageView setBackgroundColor:[UIColor blackColor]];
        [_adScrollView addSubview:imageView];
    }
    return _adScrollView;
}
- (UIView *)adPageView
{
    if(_adPageView == nil)
    {
        _adPageView = [[UIView alloc]initWithFrame:CGRectMake(0, 129, 320, 2)];
        [_adPageView setBackgroundColor:[UIColor colorWithRed:167/255.0 green:216/255.0 blue:100/255.0 alpha:1]];
    }
    return _adPageView;
}

-(UIView *)adPageProgressView
{
    if (_adPageProgressView == nil) {
        _adPageProgressView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320/3, 2)];
        [_adPageProgressView setBackgroundColor:[UIColor colorWithRed:128/255.0 green:181/255.0 blue:73/255.0 alpha:0.8]];
    }
    return _adPageProgressView;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.tag == 1)
    {
        CGFloat contentoffset = scrollView.contentOffset.x;
        int i = floor(contentoffset/320);
        CGFloat progressLength = 320/(scrollView.contentSize.width/320);
        [self.adPageProgressView setFrame:CGRectMake(i*progressLength, 0, progressLength, 2)];
    }
}

//点击推荐商品的时候
- (void)goodsPressed:(id)sender
{
    
}

@end
