//
//  HotListViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-16.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "HotListViewController.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "GoodsListCell.h"
#import "GoodsInfoViewController.h"
@interface HotListViewController ()

@end

@implementation HotListViewController
@synthesize hotList;
@synthesize hotTable;
@synthesize title;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:@"goods_getHotList" forKey:@"act"];
    MKNetworkOperation *op = [YMGlobal getOperation:param];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        NSLog(@"compeleteHotlist%@",[completedOperation responseString]);
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"] isEqualToString:@"0"])
        {
            self.hotList = [obj objectForKey:@"result"];
            [self.hotTable reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.hotList.count;
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
    if(self.hotList != nil)
    {
        NSString *urlString = [[self.hotList objectAtIndex:indexPath.row] objectForKey:@"imageUrl"];
        [YMGlobal loadFlipImage:urlString andImageView:cell.goodsImageView];
        NSString *nameString = [[self.hotList objectAtIndex:indexPath.row] objectForKey:@"goodsName"];
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
        NSString *detailString = [NSString stringWithFormat:@"￥%.2f",[[[self.hotList objectAtIndex:indexPath.row]objectForKey:@"goodsPrice"] floatValue]];
        cell.goodsPriceLabel.text = detailString;
    }
    return  cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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
    NSString *goodsId = [[self.hotList objectAtIndex:indexPath.row] objectForKey:@"goodsId"];
    GoodsInfoViewController *goodsInfoVC = [[GoodsInfoViewController alloc]init];
    goodsInfoVC.goodsId = goodsId;
    goodsInfoVC.goodsName = @"热销商品";
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:nil action:nil];
    [backItem setTintColor:[UIColor colorWithRed:167/255.0 green:216/255.0 blue:106/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem = backItem;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

@end
