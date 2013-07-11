//
//  MyViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "MyViewController.h"
#import "LoginViewController.h"
#import "UserModel.h"
@interface MyViewController ()

@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.tabBarItem.title = @"我的商城";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_my_unselected.png"];
        if([[[UIDevice currentDevice] systemVersion] floatValue]>=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_my.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_my_unselected.png"]];
        }
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithTitle:@"注销"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(deleteLogin)];
        [buttonItem setTintColor:[UIColor colorWithRed:131/255.0 green:187/255.0 blue:72/255.0 alpha:1.0]];
        self.navigationItem.rightBarButtonItem = buttonItem;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(![UserModel checkLogin])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"INeedLogin" object:nil];
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

- (void)deleteLogin
{
    [UserModel clearTable];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"INeedLogin" object:nil];
}
@end
