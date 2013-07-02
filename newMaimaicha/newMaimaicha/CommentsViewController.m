//
//  CommentsViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-2.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "CommentsViewController.h"
#import "YMGlobal.h"
#import "SBJson.h"
#import "AppDelegate.h"
@interface CommentsViewController ()

@end

@implementation CommentsViewController
@synthesize goodsId;
@synthesize commentInfo;
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
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"goods_getCommentByGoodsId" forKey:@"act"];
    [params setObject:self.goodsId forKey:@"goodsId"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            self.commentInfo = [obj objectForKey:@"result"];
            UITableView *selfView = (UITableView *)self.view;
            [selfView reloadData];
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
    if(self.commentInfo !=nil){
        return [self.commentInfo count];
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
      UITableViewCell  *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"comment"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setBackgroundColor:[UIColor whiteColor]];
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 280, 15)];
    [authorLabel setText:[NSString stringWithFormat:@"作者 : %@",[[self.commentInfo objectAtIndex:indexPath.row] objectForKey:@"author"]]];
    [authorLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    UILabel *timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 280, 15)];
    [timeLabel setText:[NSString stringWithFormat:@"时间 : %@",[[self.commentInfo objectAtIndex:indexPath.row] objectForKey:@"time"]]];
    [timeLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    UILabel *contentTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 40, 40, 15)];
    [contentTitleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [contentTitleLabel setText:@"内容 : "];

    NSString *commentString = [[self.commentInfo objectAtIndex:indexPath.row] objectForKey:@"comment"];
    CGSize size = [commentString sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(260, 1000)];
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, 40, 250, size.height)];
    [contentLabel setNumberOfLines:0];
    [contentLabel setText:[NSString stringWithFormat:@"%@",[[self.commentInfo objectAtIndex:indexPath.row] objectForKey:@"comment"]]];
    [contentLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    [cell.contentView addSubview:authorLabel];
    [cell.contentView addSubview:timeLabel];
    [cell.contentView addSubview:contentLabel];
    [cell.contentView addSubview: contentTitleLabel];
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.commentInfo != nil)
    {
        NSString *commentString = [[self.commentInfo objectAtIndex:indexPath.row] objectForKey:@"comment"];
        CGSize size = [commentString sizeWithFont:[UIFont systemFontOfSize:14.0] constrainedToSize:CGSizeMake(260, 1000)];
        return size.height+45;
    }else{
        return 0;
    }
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
