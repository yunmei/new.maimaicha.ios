//
//  ViewController.m
//  testTransition
//
//  Created by ken on 13-6-26.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ViewController ()

@end

@implementation ViewController
@synthesize image;
@synthesize imageBtn;
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (IBAction)pressed:(id)sender {
    CATransition *transtion = [CATransition animation];
    transtion.duration = 0.5;
    [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [transtion setType:@"oglFlip"];
    [transtion setSubtype:kCATransitionFromRight];
    
    [imageBtn.layer addAnimation:transtion forKey:@"transtionKey"];
    [imageBtn setBackgroundImage:[UIImage imageNamed:@"goTop"] forState:UIControlStateNormal];
    //[imageBtn setImage:[UIImage imageNamed:@"goTop.png"]];
}
@end
