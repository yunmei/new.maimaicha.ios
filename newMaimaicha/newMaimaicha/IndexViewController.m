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
@interface IndexViewController ()

@end

@implementation IndexViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"买买茶";
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
    //顶部搜索按钮
    UIBarButtonItem *seachItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    [seachItem setTintColor:[UIColor colorWithRed:130/255.0 green:183/255.0 blue:34/255.0 alpha:1.0]];
    //顶部二维码按钮
    UIBarButtonItem *dbItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(dbItemClick:)];
    [dbItem setTintColor:[UIColor colorWithRed:130/255.0 green:183/255.0 blue:34/255.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItems = @[seachItem,dbItem];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
