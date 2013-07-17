//
//  HelpWebViewController.h
//  yunmei.967067
//
//  Created by ken on 13-1-22.
//  Copyright (c) 2013年 bevin chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpWebViewController : UIViewController<UIWebViewDelegate>
@property (strong, nonatomic) IBOutlet UIWebView *helpListWebView;

@property(strong,nonatomic)NSURL *requestString;
@end
