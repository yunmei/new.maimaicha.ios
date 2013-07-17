//
//  RegisterViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-3.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) UITableView *registerTableView;
@property (strong, nonatomic) UITextField *usernameTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@end
