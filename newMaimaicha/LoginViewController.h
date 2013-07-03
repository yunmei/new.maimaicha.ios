//
//  LoginViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-3.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
@property (strong, nonatomic) UITableView *loginTableView;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@end
