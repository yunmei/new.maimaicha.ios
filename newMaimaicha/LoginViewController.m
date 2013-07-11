//
//  LoginViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-3.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "LoginViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#import "UserModel.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginTableView;
@synthesize usernameTextField;
@synthesize passwordTextField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"用户登陆";
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"登陆"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(userLogin)];
        self.navigationItem.rightBarButtonItem = buttonItem;
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                     style:UIBarButtonItemStyleBordered
                                                                    target:self
                                                                    action:@selector(userCancel)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.loginTableView];
    [self.usernameTextField becomeFirstResponder];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell addSubview:self.usernameTextField];
        } else if (indexPath.row == 1) {
            [cell addSubview:self.passwordTextField];
        }
    } else if (indexPath.section == 1) {
        cell.textLabel.text = @"马上去注册";
        cell.textLabel.font = [UIFont systemFontOfSize:14.0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        [self.navigationController pushViewController:registerViewController animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userLogin
{
     UIAlertView *alertView = [[UIAlertView alloc]init];
    if(usernameTextField.text.length < 1)
    {
        [usernameTextField becomeFirstResponder];
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写您的账号或邮箱！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }else if(passwordTextField.text.length <1){
        [passwordTextField becomeFirstResponder];
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写您的密码！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    }else{
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"user_login" forKey:@"act"];
        [params setObject:usernameTextField.text forKey:@"email"];
        [params setObject:passwordTextField.text forKey:@"password"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSLog(@"result:%@",[completedOperation responseString]);
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                NSMutableDictionary *data = [obj objectForKey:@"result"];
                UserModel *user = [[UserModel alloc]init];
                user.userId = [data objectForKey:@"userId"];
                user.session = [data objectForKey:@"session"];
                user.userName = [data objectForKey:@"userName"];
                user.point = [data objectForKey:@"point"];
                user.advance = [data objectForKey:@"advance"];
                if([user addUser])
                {
                    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
                }
                
            }else{
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:[obj objectForKey:@"errorMessage"] delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
                [alertView show];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
        }
    }

- (void)userCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRespondsLogin" object:self userInfo:[NSMutableDictionary dictionaryWithObject:@"cancel" forKey:@"cancel"]];
    // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 初始化操作
- (UITableView *)loginTableView
{
    if (loginTableView == nil) {
        loginTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
        loginTableView.delegate = self;
        loginTableView.dataSource = self;
        loginTableView.backgroundView = nil;
        loginTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return loginTableView;
}
- (UITextField *)usernameTextField
{
    if (usernameTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        leftLabel.text = @"邮箱　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        leftLabel.textAlignment = NSTextAlignmentRight;
        usernameTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        usernameTextField.placeholder = @"邮箱";
        usernameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        usernameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        usernameTextField.leftViewMode = UITextFieldViewModeAlways;
        usernameTextField.font = [UIFont systemFontOfSize:14.0];
        usernameTextField.leftView = leftLabel;
        usernameTextField.returnKeyType = UIReturnKeyNext;
        usernameTextField.tag = 1;
        usernameTextField.delegate = self;
    }
    return usernameTextField;
}
- (UITextField *)passwordTextField
{
    if (passwordTextField == nil) {
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
        leftLabel.text = @"密码　";
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14.0];
        leftLabel.textAlignment = NSTextAlignmentRight;
        passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(10, 5, 300, 40)];
        passwordTextField.placeholder = @"密码";
        passwordTextField.secureTextEntry = YES;
        passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        passwordTextField.leftViewMode = UITextFieldViewModeAlways;
        passwordTextField.font = [UIFont systemFontOfSize:14.0];
        passwordTextField.leftView = leftLabel;
        passwordTextField.returnKeyType = UIReturnKeyDone;
        passwordTextField.tag =2;
        passwordTextField.delegate = self;
    }
    return passwordTextField;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"return");
    if(textField.tag == 1)
    {
        [passwordTextField becomeFirstResponder];
    }else{
        [self userLogin];
    }
    return YES;
}
@end
