//
//  CategoryViewController.m
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "CategoryViewController.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SearchViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SecCategoryViewController.h"
@interface CategoryViewController ()

@end

@implementation CategoryViewController
@synthesize catTableView;
@synthesize catArray;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"分类";
        // Custom initialization
        self.tabBarItem.title = @"分类";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar_category_unselected.png"];
        if([[[UIDevice currentDevice] systemVersion] floatValue] >=5.0)
        {
            [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"tabbar_category.png"]withFinishedUnselectedImage:[UIImage imageNamed:@"tabbar_category_unselected.png"]];
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.backBarButtonItem.style = UIBarButtonSystemItemReply;
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(search:)];
    searchItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
    self.navigationItem.rightBarButtonItem = searchItem;
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"cat_getList" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.catArray = [obj objectForKey:@"result"];
            [self.catTableView reloadData];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.catArray!=nil)
    {
        return [self.catArray  count];
    }else{
        return 0;
    }
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
    cell.textLabel.text = [[self.catArray objectAtIndex:indexPath.row] objectForKey:@"catName"];
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   if([[self.catArray objectAtIndex:indexPath.row] objectForKey:@"goodsId"] == nil)
   {
       NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
       [param setObject:@"cat_getSubList" forKey:@"act"];
       [param setObject:[[self.catArray objectAtIndex:indexPath.row] objectForKey:@"catId"] forKey:@"parentCatId"];
       MKNetworkOperation *op = [YMGlobal getOperation:param];
       [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
           SBJsonParser *parser = [[SBJsonParser alloc]init];
           NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
           if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
           {
               SecCategoryViewController *secondCatVC = [[SecCategoryViewController alloc]init];
               secondCatVC.secCatArray = [obj objectForKey:@"result"];
               UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
               backItem.tintColor = [UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0];
               self.navigationItem.backBarButtonItem = backItem;
               [self.navigationController pushViewController:secondCatVC animated:YES];
           }
       } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
           NSLog(@"%@",error);
       }];
       [ApplicationDelegate.engine enqueueOperation:op];
   }else{
       
   }
}

- (void)search:(id)sender
{
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self presentViewController:searchVC animated:NO completion:nil];
}
@end
