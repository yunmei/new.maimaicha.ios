//
//  AppDelegate.h
//  newMaimaicha
//
//  Created by ken on 13-6-21.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKNetworkKit.h"
#import "Constants.h"
#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MKNetworkEngine *engine;
@property (strong, nonatomic) UITabBarController *tabBarctrl;
@end
