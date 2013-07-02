//
//  GoodsIntroViewController.m
//  newMaimaicha
//
//  Created by ken on 13-7-2.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "GoodsIntroViewController.h"
#import "SBJson.h"
#import "YMGlobal.h"
#import "AppDelegate.h"

@interface GoodsIntroViewController ()

@end

@implementation GoodsIntroViewController
@synthesize contentWebView = _contentWebView;
@synthesize goodsId;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:self.contentWebView];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:@"goods_getIntroByGoodsId" forKey:@"act"];
    [params setObject:self.goodsId forKey:@"goodsId"];
    MKNetworkOperation *op = [YMGlobal getOperation:params];
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        SBJsonParser *parser = [[SBJsonParser alloc]init];
        NSMutableDictionary *obj = [parser objectWithData:[completedOperation responseData]];
        if([[obj objectForKey:@"errorCode"]isEqualToString:@"0"])
        {
            NSString *content = [[[obj objectForKey:@"result"] objectAtIndex:0] objectForKey:@"intro"];
            [self.contentWebView loadHTMLString:content baseURL:nil];
        }
    } errorHandler:^(MKNetworkOperation *completedOperation, NSError *error) {
        NSLog(@"%@",error);
    }];
    [ApplicationDelegate.engine enqueueOperation:op];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UIWebView *)contentWebView
{
    if(_contentWebView == nil)
    {
        _contentWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 44, self.view.frame.size.width,self.view.frame.size.height)];
    
    }
    return _contentWebView;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    CGRect frame = webView.frame;
    NSString *fitHeight = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    NSString *fitWidth = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"];
    frame.size.height = [fitHeight floatValue];
     frame.size.width = [fitWidth floatValue];
    webView.frame = frame;

}

- (IBAction)goBack:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
