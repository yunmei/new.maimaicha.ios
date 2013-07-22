//
//  AddrListViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-9.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AddrListViewController.h"
#import "YMGlobal.h"
#import "AppDelegate.h"
#import "SBJson.h"
#import "UserModel.h"
#import "AddrCell.h"
#import "AddrAddViewController.h"
#import "MBProgressHUD.h"
@interface AddrListViewController ()

@end

@implementation AddrListViewController
@synthesize addrList;
@synthesize addListTable;
@synthesize delegate;
@synthesize nullView = _nullView;
@synthesize comeFrom;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"收货地址列表";
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAddr:)];
    [right setTintColor:[UIColor colorWithRed:169/255.0 green:217/255.0 blue:110/255.0 alpha:1.0]];
    self.navigationItem.rightBarButtonItem = right;
    if(![UserModel checkLogin])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"INeedLogin" object:nil];
    }else{
        UserModel *user = [UserModel getUserModel];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:user.userId forKey:@"userId"];
        [param setObject:@"addr_getAddrs" forKey:@"act"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
        MKNetworkOperation *op = [YMGlobal getOperation:param];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [hud hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                NSLog(@"addrlist%@",[completedOperation responseString]);
                self.addrList = [obj objectForKey:@"result"];
                for(id o in self.addrList)
                {
                    NSMutableDictionary *addr = o;
                    if([[addr objectForKey:@"default"]isEqualToString:@"1"])
                    {
                        HASDEFAULT = YES;
                    }
                }
                if(!HASDEFAULT){
                    [[self.addrList objectAtIndex:0] setObject:@"1" forKey:@"default"];
                }
                [self.nullView removeFromSuperview];
                [self.addListTable reloadData];
            }else{
                [self.view addSubview:self.nullView];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [hud hide:YES];
            NSLog(@"%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }
    

}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.addrList.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AddrCell *cell = (AddrCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[AddrCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
       
    }
    if(self.addrList.count >0){
        cell.nameLabel.text = [[self.addrList objectAtIndex:indexPath.row] objectForKey:@"name"];
        cell.addrLabel.text = [[self.addrList objectAtIndex:indexPath.row] objectForKey:@"addr"];
        cell.mobileLabel.text = [[self.addrList objectAtIndex:indexPath.row] objectForKey:@"mobile"];
        if([[[self.addrList objectAtIndex:indexPath.row] objectForKey:@"default"] isEqualToString:@"1"])
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else{
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    if([self.comeFrom isEqualToString:@"userCenter"])
    {
        NSMutableDictionary  * selectAddr = [self.addrList objectAtIndex:indexPath.row];
        NSString *addrId = [selectAddr objectForKey:@"addrId"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:addrId forKey:@"addrId"];
        [params setObject:@"addr_setAddrDef" forKey:@"act"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [hud hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([obj objectForKey:@"errorCode"])
            {
                int i = 0;
                for(id o in self.addrList)
                {
                  NSMutableDictionary *addr = o;
                  if(indexPath.row == i)
                  {
                      [addr setObject:@"1" forKey:@"default"];
                  }else{
                      [addr setObject:@"0" forKey:@"default"];
                  }
                    i++;
                }
                [self.addListTable reloadData];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",error);
            [hud hide:YES];
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
    }else{
          MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        NSMutableDictionary  * selectAddr = [self.addrList objectAtIndex:indexPath.row];
        NSString *addrId = [selectAddr objectForKey:@"addrId"];
        NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
        [params setObject:addrId forKey:@"addrId"];
        [params setObject:@"addr_setAddrDef" forKey:@"act"];
        MKNetworkOperation *op = [YMGlobal getOperation:params];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [hud hide:YES];
            NSLog(@"completesetDefault:%@",[completedOperation responseString]);
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([obj objectForKey:@"errorCode"])
            {
                [self.delegate passVlaue:[obj objectForKey:@"result"]];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            NSLog(@"%@",error);
            [hud hide:YES];
        }];
        [ApplicationDelegate.engine enqueueOperation:op];
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


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UserModel *user = [UserModel getUserModel];
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:user.userId forKey:@"userId"];
        [param setObject:@"addr_deleteAddr" forKey:@"act"];
        [param setObject:[[self.addrList objectAtIndex:indexPath.row] objectForKey:@"addrId"] forKey:@"addrId"];
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:NO];
        MKNetworkOperation *op = [YMGlobal getOperation:param];
        [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
            [hud hide:YES];
            SBJsonParser *parser = [[SBJsonParser alloc]init];
            NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
            if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
            {
                [self.addrList removeObjectAtIndex:indexPath.row];
                if(self.addrList.count < 1)
                {
                    [self.addListTable reloadData];
                    [self.view addSubview:self.nullView];
                }else{
                    [self.addListTable reloadData];
                }

            }
        } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
            [hud hide:YES];
            NSLog(@"%@",error);
        }];
        [ApplicationDelegate.engine enqueueOperation:op];

              }
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
- (void)addAddr:(id)sender
{
    AddrAddViewController *addVC = [[AddrAddViewController alloc]init];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]init];
    [backItem setTintColor:[UIColor colorWithRed:169/255.0 green:217/255.0 blue:110/255.0 alpha:1.0]];
    self.navigationItem.backBarButtonItem  = backItem;
    [self.navigationController pushViewController:addVC animated:YES];
    
}

- (UIView *)nullView
{
    if(_nullView == nil)
    {
        _nullView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
        [_nullView setBackgroundColor:[UIColor whiteColor]];
        UILabel *nullLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 300, 30)];
        [nullLabel setText:@"您还没有收货地址，快去添加吧!"];
        [_nullView addSubview:nullLabel];
    }
    return _nullView;
}

@end
