//
//  ViewController.h
//  testTransition
//
//  Created by ken on 13-6-26.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
- (IBAction)pressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UIButton *imageBtn;
@end
