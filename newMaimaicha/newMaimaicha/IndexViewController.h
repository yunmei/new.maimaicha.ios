//
//  IndexViewController.h
//  newMaimaicha
//
//  Created by ken on 13-6-22.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
@interface IndexViewController : UIViewController<ZBarReaderDelegate,UIScrollViewDelegate>
@property (strong,nonatomic) NSMutableArray *commendGoodsList;
@property (strong,nonatomic) UIScrollView *nhScrollView;
@property (strong,nonatomic) UIScrollView *comScrollView;
@end
