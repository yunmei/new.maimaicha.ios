//
//  ViewController.h
//  testIcarouse
//
//  Created by ken on 13-7-5.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
@interface ViewController : UIViewController<iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) IBOutlet iCarousel *carousel;
@property (strong,nonatomic)NSMutableArray *items;
@end
