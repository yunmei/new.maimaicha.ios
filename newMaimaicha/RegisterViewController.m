//
//  RegisterViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-3.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "RegisterViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "UserModel.h"
@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize registerTableView;
@synthesize usernameTextField;
@synthesize passwordTextField;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"用户注册";
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"注册"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(userRegister)];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.registerTableView];
    [self.usernameTextField becomeFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell addSubview:self.usernameTextField];
        } else if (indexPath.row == 1) {
            [cell addSubview:self.passwordTextField];
        }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        //        RegisterViewController *registerViewController = [[RegisterViewController alloc]init];
        //        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
        //        [self.navigationController pushViewController:registerViewController animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)userRegister
{
    NSString *regEx = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    NSRange r = [usernameTextField.text rangeOfString:regEx options:NSRegularExpressionSearch];
    
    UIAlertView *alertView = [[UIAlertView alloc]init];
    if ([usernameTextField.text isEqualToString:@""] || usernameTextField.text == nil) {
        [usernameTextField becomeFirstResponder];
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写您的注册邮箱！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    } else if (r.location == NSNotFound) {
        [usernameTextField becomeFirstResponder];
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您填写的邮箱不合法！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
        
    } else if ([passwordTextField.text isEqualToString:@""] || passwordTextField.text == nil) {
        [passwordTextField becomeFirstResponder];
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写您的密码！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    } else if ([passwordTextField.text length] < 6) {
        [passwordTextField becomeFirstResponder];
        alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"为了您的密码安全，请填写6位以上的密码！" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil];
        [alertView show];
    } else {
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:@"user_register" forKey:@"act"];
        [params setObject:usernameTextField.text forKey:@"email"];
        [params setObject:passwordTextField.text forKey:@"password"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            NSLog(@"completedString%@",[completedOperation responseString]);
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                UserModel *user = [[UserModel alloc]init];
                user.userId = [[obj objectForKey:@"result"] objectForKey:@"userId"];
                user.session = [[obj objectForKey:@"result"] objectForKey:@"session"];
                user.userName = [[obj objectForKey:@"result"] objectForKey:@"userName"];
                user.point = [[obj objectForKey:@"result"] objectForKey:@"point"];
                user.advance = [[obj objectForKey:@"result"] objectForKey:@"advance"];
                if([user addUser])
                {
                    NSLog(@"add yes");
                    UIAlertView *registerAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"恭喜你,注册成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    registerAlert.delegate = self;
                    registerAlert.tag = 1;
                    [registerAlert show];
                }
            }else{
                UIAlertView *registerAlert = [[UIAlertView alloc]initWithTitle:@"提示" message:[obj objectForKey:@"errorMessage"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [registerAlert show];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }

    
    
//    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
//    [params setObject:@"user_login" forKey:@"act"];
//    [params setObject:usernameTextField.text forKey:@"email"];
//    [params setObject:passwordTextField.text forKey:@"password"];
//    MKNetworkOperation *op = [YMGlobal getOperation:params];
//    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
//        NSLog(@"completed:%@",[completedOperation responseString]);
//    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
//        NSLog(@"%@",error);
//    }];
//    [ApplicationDelegate.engine enqueueOperation:op];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

- (void)userCancel
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserRespondsLogin" object:self userInfo:[NSMutableDictionary dictionaryWithObject:@"cancel" forKey:@"cancel"]];
    // [self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 初始化操作
- (UITableView *)registerTableView
{
    if (registerTableView == nil) {
        registerTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height - 64) style:UITableViewStyleGrouped];
        registerTableView.delegate = self;
        registerTableView.dataSource = self;
        registerTableView.backgroundView = nil;
        registerTableView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    }
    return registerTableView;
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
        usernameTextField.placeholder = @"请输入有效的用户邮箱";
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
        passwordTextField.placeholder = @"请输入6-10位用户密码";
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
        [self userRegister];
    }
    return YES;
}
@end
