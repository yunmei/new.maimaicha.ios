//
//  YMGlobal.m
//  yunmei.967067
//
//  Created by bevin chen on 12-11-13.
//  Copyright (c) 2012年 bevin chen. All rights reserved.
//

#import "YMGlobal.h"
#import "Constants.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
@implementation YMGlobal

+ (MKNetworkOperation *)getOperation:(NSMutableDictionary *)params
{
    [params setObject:@"2.0" forKey:@"api_version"];
    [params setObject:@"2" forKey:@"return_data"];
    return [ApplicationDelegate.engine operationWithPath:API_BASEURL params:params httpMethod:API_METHOD ssl:NO];
}

+ (void)loadImage:(NSString *)imageUrl andImageView:(UIImageView *)imageView
{
    [ApplicationDelegate.engine imageAtURL:[NSURL URLWithString:imageUrl] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        [imageView setImage:fetchedImage];
    }];
}
//已翻滚效果载入图片
+ (void)loadImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState
{
    [ApplicationDelegate.engine imageAtURL:[NSURL URLWithString:imageUrl] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache){
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transtion setType:kCATransitionFade];
        [transtion setSubtype:kCATransitionFromRight];
        [button.layer addAnimation:transtion forKey:@"transtionKey"];
        [button setBackgroundImage:fetchedImage forState:buttonState];
    }];
}
//以淡入方式载入图片
+ (void)loadFlipImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState
{
    [ApplicationDelegate.engine imageAtURL:[NSURL URLWithString:imageUrl] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transtion setType:kCATransitionFade];
        [transtion setSubtype:kCATransitionFromRight];
        [button.layer addAnimation:transtion forKey:@"transtionKey"];
        [button setBackgroundImage:fetchedImage forState:buttonState];
    }];
}

+ (void)loadFlipImage:(NSString *)imageUrl andImageView:(UIImageView *)imageView
{
    [ApplicationDelegate.engine imageAtURL:[NSURL URLWithString:imageUrl] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache) {
            CATransition *transtion = [CATransition animation];
            transtion.duration = 0.5;
            [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
            [transtion setType:kCATransitionFade];
            [transtion setSubtype:kCATransitionFromRight];
            [imageView.layer addAnimation:transtion forKey:@"transtionKey"];
            [imageView setImage:fetchedImage];
    }];
}


+ (void)loadButtonImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState
{
    [ApplicationDelegate.engine imageAtURL:[NSURL URLWithString:imageUrl] onCompletion:^(UIImage *fetchedImage, NSURL *url, BOOL isInCache){
        CATransition *transtion = [CATransition animation];
        transtion.duration = 0.5;
        [transtion setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [transtion setType:kCATransitionFade];
        [transtion setSubtype:kCATransitionFromRight];
        [button.layer addAnimation:transtion forKey:@"transtionKey"];
        [button setImage:fetchedImage forState:buttonState];
    }];
}

@end
