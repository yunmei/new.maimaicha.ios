//
//  SecCategoryViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-26.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "SecCategoryViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
#import "GoodsListViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface SecCategoryViewController ()

@end

@implementation SecCategoryViewController
@synthesize secCatArray;
@synthesize catName;
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
    self.navigationItem.title = self.catName;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.secCatArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [[self.secCatArray objectAtIndex:indexPath.row] objectForKey:@"catName"];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoodsListViewController *goodsListVC = [[GoodsListViewController alloc]init];
    goodsListVC.catName = [[self.secCatArray objectAtIndex:indexPath.row]objectForKey:@"catName" ];
    goodsListVC.catId = [[self.secCatArray objectAtIndex:indexPath.row]objectForKey:@"catId" ];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backItem setTintColor:[UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = backItem;
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transtion setType:@"oglFlip"];
    [transtion setSubtype:kCATransitionFromRight];
    [self.navigationController.view.layer addAnimation:transtion forKey:@"transtionKey"];    
    [self.navigationController pushViewController:goodsListVC animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
