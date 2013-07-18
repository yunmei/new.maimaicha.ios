//
//  SCViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-17.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "SCViewController.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "GoodsListCell.h"
#import "GoodsInfoViewController.h"
#import "goodsModel.h"
@interface SCViewController ()

@end

@implementation SCViewController
@synthesize scListTable;
@synthesize scList;
@synthesize title;
@synthesize emptyView = _emptyView;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.scList = [goodsModel fetchSCList];
    if(self.scList.count < 1)
    {
        [self.view addSubview:self.emptyView];
    }else{
        [self.emptyView removeFromSuperview];
        [self.scListTable reloadData];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc]initWithTitle:@"清除" style:UIBarButtonItemStyleBordered target:self action:@selector(delete:)];
    [rightBar setTintColor:[UIColor colorWithRed:160/255.0 green:210/255.0 blue:94/255.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = rightBar;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.scList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    GoodsListCell *cell = (GoodsListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil)
    {
        cell = [[GoodsListCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if(self.scList != nil)
    {
        NSString *urlString = [[self.scList objectAtIndex:indexPath.row] objectForKey:@"image_url"];
        [YMGlobal loadFlipImage:urlString andImageView:cell.goodsImageView];
        NSString *nameString = [[self.scList objectAtIndex:indexPath.row] objectForKey:@"name"];
        CGSize nameLabelSize =  [nameString sizeWithFont:[UIFont systemFontOfSize:13.0] constrainedToSize:CGSizeMake(190, 1000.0)];
        cell.goodsNameLabel.numberOfLines = 0;
        [cell.goodsNameLabel setFrame:CGRectMake(120, 0, nameLabelSize.height, nameLabelSize.width)];
        cell.goodsNameLabel.text = nameString;
        cell.goodsNameLabel.font = [UIFont systemFontOfSize:13.0];
        cell.goodsNameLabel.textAlignment = NSTextAlignmentCenter;
        [cell.goodsNameLabel setFrame:CGRectMake(100, 15, nameLabelSize.width, nameLabelSize.height)];
        [cell.goodsPriceLabel setFrame:CGRectMake(100, 50, 100, 20)];
        [cell.goodsPriceLabel setFont:[UIFont systemFontOfSize:13.0]];
        cell.goodsPriceLabel.textColor = [UIColor redColor];
        NSString *detailString = [NSString stringWithFormat:@"￥%.2f",[[[self.scList objectAtIndex:indexPath.row]objectForKey:@"price"] floatValue]];
        cell.goodsPriceLabel.text = detailString;
    }
    return  cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

 // Override to support conditional editing of the table view.
// - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
// {
// // Return NO if you do not want the specified item to be editable.
//     return YES;
// }


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
     NSString *goodsId = [[self.scList objectAtIndex:indexPath.row] objectForKey:@"id"];
     if([goodsModel deleteSCData:goodsId])
     {
         self.scList = [goodsModel fetchSCList];
     }
     [self.scListTable reloadData];
     if(self.scList.count <1)
     {
         [self.view addSubview:self.emptyView];
     }
 }
  }
 

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *goodsId = [[self.scList objectAtIndex:indexPath.row] objectForKey:@"id"];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]init];
    goodsInfoVC.goodsId = goodsId;
    goodsInfoVC.goodsName = [[self.scList objectAtIndex:indexPath.row] objectForKey:@"name"] ;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backItem setTintColor:[UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)delete:(id)sender
{
    [goodsModel clearSC];
    self.scList = [goodsModel fetchSCList];
    [self.scListTable reloadData];
    [self.view addSubview:self.emptyView];
}


-(UIView *)emptyView
{
    if(_emptyView == nil)
    {
        _emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width)];
        [_emptyView setBackgroundColor:[UIColor whiteColor]];
        UILabel *emptyLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 20)];
        [emptyLabel setText:@"您还没有收藏任何商品!"];
        [emptyLabel setFont:[UIFont systemFontOfSize:15.0]];
        [emptyLabel setTextColor:[UIColor blackColor]];
        [_emptyView addSubview:emptyLabel];
    }
    return _emptyView;
}
@end
