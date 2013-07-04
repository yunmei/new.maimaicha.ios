//
//  GoodsIntroViewController.h
//  newMaimaicha
//
//  Created by ken on 13-7-2.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsIntroViewController : UIViewController<UIWebViewDelegate>
@property (strong,nonatomic)UIWebView *contentWebView;
@property (strong,nonatomic)NSString *goodsId;
- (IBAction)goBack:(id)sender;
@end
