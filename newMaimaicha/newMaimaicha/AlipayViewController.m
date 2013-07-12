//
//  AlipayViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-12.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AlipayViewController.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "AlixPayOrder.h"
#import "AlixPayResult.h"
#import "AlixPay.h"
#import "MBProgressHUD.h"
@interface AlipayViewController ()

@end

@implementation AlipayViewController
@synthesize orderId;
@synthesize totalAmount;
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
    self.payTypeTable.backgroundView = nil;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"   手机在线支付";
    titleLabel.textColor = [UIColor colorWithRed:154/255.0 green:206/255.0 blue:84/255.0 alpha:1.0];
    [titleLabel setFont:[UIFont boldSystemFontOfSize:17.0]];
    return titleLabel;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"支付宝无线支付";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"手机在线支付";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"sign_getAlipaySign" forKey:@"act"];
    [param setObject:self.totalAmount forKey:@"totalFee"];
    [param setObject:self.orderId forKey:@"tradeNumber"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        [hud hide:YES];
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"] isEqualToString:@"0"])
        {
            NSMutableDictionary *returnData = [obj objectForKey:@"result"];
            NSString *orderString1 = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",[returnData objectForKey:@"codeSign"],[returnData objectForKey:@"signData"],@"RSA"];
            NSString *appScheme = @"com.company.maimaicha.newMaimaicha";
            AlixPay * alixpay = [AlixPay shared];
            int ret = [alixpay pay:orderString1 applicationScheme:appScheme];
            if (ret == kSPErrorAlipayClientNotInstalled) {
                UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                     message:@"您还没有安装支付宝快捷支付，请先安装。"
                                                                    delegate:self
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                [alertView setTag:123];
                [alertView show];
            }
            else if (ret == kSPErrorSignError) {
                NSLog(@"签名错误！");
            }
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        [hud hide:YES];
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (alertView.tag == 123) {
		NSString * URLString = @"http://itunes.apple.com/cn/app/id535715926?mt=8";
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:URLString]];
	}
}
@end
