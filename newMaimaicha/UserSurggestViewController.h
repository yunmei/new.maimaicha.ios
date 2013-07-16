//
//  UserSurggestViewController.h
//  yunmei.967067
//
//  Created by ken on 13-1-23.
//  Copyright (c) 2013年 bevin chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "YMGlobal.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "AppDelegate.h"
@interface UserSurggestViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextView *contentField;

- (IBAction)backPressed:(id)sender;
@end
