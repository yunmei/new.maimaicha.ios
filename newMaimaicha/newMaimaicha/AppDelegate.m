//
//  AppDelegate.m
//  newMaimaicha
//
//  Created by ken on 13-6-21.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AppDelegate.h"
#import "IndexViewController.h"
#import "CategoryViewController.h"
#import "CartViewController.h"
#import "SearchViewController.h"
#import "MoreViewController.h"
#import "MyViewController.h"
#import "goodsModel.h"
#import "UserModel.h"
#import "LoginViewController.h"
#import "KeyGoodsListViewController.h"
@implementation AppDelegate
@synthesize engine = _engine;
@synthesize tabBarctrl = _tabBarctrl;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
   UINavigationController *indexNav = [[UINavigationController alloc]initWithRootViewController: [[IndexViewController alloc]initWithNibName:@"IndexViewController" bundle:nil]];
    [indexNav.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_bg.png"]]];
   UINavigationController *categoryNav = [[UINavigationController alloc]initWithRootViewController: [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil]];
    [categoryNav.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_bg.png"]]];
    UINavigationController *MoreNav = [[UINavigationController alloc]initWithRootViewController: [[MoreViewController alloc]initWithNibName:@"MoreViewController" bundle:nil]];
    [MoreNav.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_bg.png"]]];
    UINavigationController *cartNav = [[UINavigationController alloc]initWithRootViewController: [[CartViewController alloc]initWithNibName:@"CartViewController" bundle:nil]];
    [cartNav.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_bg.png"]]];
    UINavigationController *myNav = [[UINavigationController alloc]initWithRootViewController:[[MyViewController alloc]initWithNibName:@"MyViewController" bundle:nil]];
    [myNav.navigationBar setTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigation_bar_bg.png"]]];
    self.tabBarctrl.viewControllers = @[indexNav,categoryNav,cartNav,myNav,MoreNav];
    self.window.rootViewController = self.tabBarctrl;
    if([goodsModel countGoods]>0)
    {
        [[self.tabBarctrl.tabBar.items objectAtIndex:2] setBadgeValue:[NSString stringWithFormat:@"%i",[goodsModel countGoods]]];
    }
    [UserModel creatTable];
   // self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    //add NSNotificationCenter
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openLoginView:) name:@"INeedLogin" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginSuccess) name:@"LoginSuccess" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(respondsLogin:) name:@"UserRespondsLogin" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushVC:) name:@"pushKeyVC" object:nil];
    return YES;
}

- (void)openLoginView:(NSNotification *)note
{
    LoginViewController *loginVC = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *loginNav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [loginNav.navigationBar setTintColor:[UIColor colorWithRed:139/255.0 green:192/255.0 blue:52/255.0 alpha:0.9]];
    [self.tabBarctrl.selectedViewController presentViewController:loginNav animated:YES completion:nil];
}

- (void)respondsLogin:(NSNotification *)note
{
    if(self.tabBarctrl.selectedIndex == 3)
    [self.tabBarctrl setSelectedIndex:0];
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (MKNetworkEngine *)engine
{
    if(_engine == nil)
    {
        _engine = [[MKNetworkEngine alloc]initWithHostName:API_HOSTNAME customHeaderFields:nil];
        [_engine useCache];
    }
    return _engine;
}

- (UITabBarController *)tabBarctrl
{
    if(_tabBarctrl == nil)
    {
        _tabBarctrl = [[UITabBarController alloc]init];
        [_tabBarctrl.tabBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg.png"]];

        _tabBarctrl.tabBar.selectionIndicatorImage = [UIImage imageNamed:@"tabbar_selection.png"];
    }
    return _tabBarctrl;
}


- (void)pushVC:(NSNotification *)note
{
    UINavigationController *selectNav = (UINavigationController *)self.tabBarctrl.selectedViewController;
    KeyGoodsListViewController *keyGoodsVC = [[KeyGoodsListViewController alloc]init];
    keyGoodsVC.keywords = [[note userInfo] objectForKey:@"keywords"];
    keyGoodsVC.navigationItem.title = keyGoodsVC.keywords;
    UILabel *itemTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 170, 44)];
    itemTitle.textAlignment = NSTextAlignmentCenter;
    itemTitle.text = [NSString stringWithFormat:@"关键字\"%@\"的产品列表", [[note userInfo] objectForKey:@"keywords"]];
    itemTitle.font = [UIFont systemFontOfSize:15.0];
    itemTitle.backgroundColor = [UIColor clearColor];
    itemTitle.textColor = [UIColor whiteColor];
    keyGoodsVC.navigationItem.titleView = itemTitle;
    [selectNav pushViewController:keyGoodsVC animated:YES];
}
@end
