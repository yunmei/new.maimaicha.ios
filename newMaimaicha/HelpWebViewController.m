//
//  HelpWebViewController.m
//  yunmei.967067
//
//  Created by ken on 13-1-22.
//  Copyright (c) 2013年 bevin chen. All rights reserved.
//

#import "HelpWebViewController.h"

@interface HelpWebViewController ()

@end

@implementation HelpWebViewController
@synthesize helpListWebView;
@synthesize requestString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"帮助";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:self.requestString];
    [self.helpListWebView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setHelpListWebView:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
