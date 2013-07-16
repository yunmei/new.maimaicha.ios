//
//  MoreViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "MoreViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "HelpWebViewController.h"
#import "UserSurggestViewController.h"
@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"更多";
        self.navigationItem.title = @"更多";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_more_unselected.png"];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_more.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_more_unselected.png"]];
        }
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0)
    {
        return 1;
    }else if (section ==1){
        return 2;
    }else if (section ==2){
        return 3;
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
    {
        return @"官方网址";
    }else if (section ==1){
        return @"设置";
    }else if (section ==2){
        return @"帮助";
    }else{
        return @"客服电话";
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel setFont:[UIFont systemFontOfSize:12.0]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(indexPath.section == 0)
    {
        cell.textLabel.text = @"http://www.maimaicha.com";
    }else if (indexPath.section ==1){
        if(indexPath.row == 0){
            cell.textLabel.text = @"清空缓存";
        }else{
            cell.textLabel.text = @"退出";
        }
    }else if (indexPath.section ==2){
        if(indexPath.row == 0){
            cell.textLabel.text = @"帮助手册";
        }else if (indexPath.row ==1){
            cell.textLabel.text = @"检查更新";
        }else {
            cell.textLabel.text = @"意见反馈";
        }
    }else{
        cell.textLabel.text = @"客服电话 : 4006180177";
        [cell.textLabel setFont:[UIFont systemFontOfSize:14.0]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1)
    {
        if(indexPath.row ==0)
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"缓存已清除" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            if([UserModel checkLogin])
            {
                [UserModel clearTable];
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"当前用户已退出!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您并没有登陆，不需要退出!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }
        }
    }else if (indexPath.section ==2)
    {
        if(indexPath.row == 0)
        {
            HelpWebViewController *helplistView = [[HelpWebViewController alloc]init];
            helplistView.requestString = [[NSURL alloc]initWithString:URL_HELP];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
            [backItem setTintColor:[UIColor colorWithRed:169/255.0 green:217/255.0 blue:110/255.0 alpha:1.0]];
            self.navigationItem.backBarButtonItem  = backItem;
            [self.navigationController pushViewController:helplistView animated:YES];
        }else if (indexPath.row ==1){
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"user_getIOSVersion",@"act", nil];
            MKNetworkOperation *op = [YMGlobal getOperation:params];
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
                if([[obj objectForKey:@"errorMessage"]isEqualToString:@"success"])
                {
                    NSMutableDictionary *data = [obj objectForKey:@"result"];
                    NSLog(@"%@",data);
                    if([[data objectForKey:@"version"]isEqualToString:SYS_VERSION])
                    {
                        UIAlertView *alert1 = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的版本已是最新" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert1.tag =1;
                        [alert1 show];
                    }else{
                        self.downloadURl = [NSString stringWithFormat:@"%@",[data objectForKey:@"downloadUrl"]];
                        UIAlertView *alert2 = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"检测到新版本，是否更新？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        alert2.tag =2;
                        [alert2 show];
                    }
                }
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                NSLog(@"%@",[completedOperation responseData]);
            }];
            [ApplicationDelegate.engine enqueueOperation:op];
        }else{
            UserSurggestViewController *userSurggestView = [[UserSurggestViewController alloc]init];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
            [backItem setTintColor:[UIColor colorWithRed:169/255.0 green:217/255.0 blue:110/255.0 alpha:1.0]];
            self.navigationItem.backBarButtonItem = backItem;
            [self.navigationController pushViewController:userSurggestView animated:YES];
        }
    }else if (indexPath.section == 0){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.maimaicha.com"]];
    }else{
        UIAlertView *alert  = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"你确定要拨打客服电话吗？"
                                                      delegate:self
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:@"取消", nil];
        alert.tag = 5;
        [alert show];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downloadURl]];
    }else if (alertView.tag == 5){
        if(buttonIndex == 0){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006180177"]];
        }
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

@end
