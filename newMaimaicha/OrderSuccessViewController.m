//
//  OrderSuccessViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-12.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "OrderSuccessViewController.h"
#import "AlipayViewController.h"
@interface OrderSuccessViewController ()

@end

@implementation OrderSuccessViewController
@synthesize orderId;
@synthesize totalFee;
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
    [self.orderIdLabel setText:self.orderId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goPay:(id)sender {
    UIBarButtonItem * rightBar = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:nil];
    [rightBar setTintColor:[UIColor colorWithRed:172/255.0 green:219/255.0 blue:115/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = rightBar;
    AlipayViewController *alipay = [[AlipayViewController alloc]init];
    alipay.orderId = self.orderId;
    alipay.totalAmount = self.totalFee;
    [self.navigationController pushViewController:alipay animated:YES];
    
}
@end
