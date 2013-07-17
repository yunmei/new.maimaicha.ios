//
//  YMGlobal.h
//  yunmei.967067
//
//  Created by bevin chen on 12-11-13.
//  Copyright (c) 2012年 bevin chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKNetworkKit.h"
@interface YMGlobal : NSObject

// 获取MKNetworkOperation
+ (MKNetworkOperation *)getOperation:(NSMutableDictionary *)params;

// 加载图片
+ (void)loadImage:(NSString *)imageUrl andImageView:(UIImageView *)imageView;
+ (void)loadImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState;
+ (void)loadFlipImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState;
+ (void)loadFlipImage:(NSString *)imageUrl andImageView:(UIImageView *)imageView;
+ (void)loadButtonImage:(NSString *)imageUrl andButton:(UIButton *)button andControlState:(UIControlState)buttonState;
@end
