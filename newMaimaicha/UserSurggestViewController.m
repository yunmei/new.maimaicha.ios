//
//  UserSurggestViewController.m
//  yunmei.967067
//
//  Created by ken on 13-1-23.
//  Copyright (c) 2013年 bevin chen. All rights reserved.
//

#import "UserSurggestViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "UserModel.h"
@interface UserSurggestViewController ()

@end

@implementation UserSurggestViewController
@synthesize nameField;
@synthesize contentField;
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
    self.navigationItem.title = @"意见反馈";
    if([UserModel checkLogin])
    {
        UserModel *user = [UserModel getUserModel];
        self.nameField.text = user.userName;
    }else{
    
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];

}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入您的意见"])
    {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    
    [self.view setFrame:CGRectMake(0, -100, self.view.frame.size.width, self.view.frame.size.height)];
}


- (IBAction)submitSurggest:(id)sender
{
    if([self.contentField.text isEqualToString:@""]||[self.contentField.text isEqualToString:@"请输入您的意见"])
    {
        UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入反馈内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else if ([self.nameField.text isEqualToString:@""]){
        UIAlertView  *alert = [[UIAlertView alloc]initWithTitle:@"警告" message:@"请输入用户名" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        if(![UserModel checkLogin])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"INeedLogin" object:nil];
        }else{
            UserModel *user = [UserModel getUserModel];
            MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
            NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
            [params setObject:@"user_addSuggest" forKey:@"act"];
            [params setObject:user.userId forKey:@"userId"];
            [params setObject:self.contentField.text forKey:@"content"];
            MKNetworkOperation *op = [YMGlobal getOperation:params];
            [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
                SBJsonParser *parser = [[SBJsonParser alloc]init];
                NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
                if([[obj objectForKey:@"errorMessage"]isEqualToString:@"success"])
                {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"反馈提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 1;
                    [alert show];
                    
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"反馈提交失败，请重新提交" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    alert.tag = 2;
                    [alert show];

                }
            } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
                NSLog(@"%@",error);
            }];
            [ApplicationDelegate.engine enqueueOperation:op];
            [hud hide:YES];

        }
           }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)backPressed:(id)sender {
    [self.nameField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    [self.view setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

@end
