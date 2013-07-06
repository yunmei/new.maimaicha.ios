//
//  ViewController.m
//  testIcarouse
//
//  Created by ken on 13-7-5.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "ViewController.h"
#define NUMBER_OF_ITEMS  12
#define NUMBER_OF_VISIBLE_ITEMS 25
#define ITEM_SPACING 210.0f
@interface ViewController ()

@end

@implementation ViewController
@synthesize carousel;
@synthesize items;



- (void)setUp
{
	//set up data
	self.items = [NSMutableArray array];
	for (int i = 0; i < NUMBER_OF_ITEMS; i++)
	{
		[items addObject:[NSNumber numberWithInt:i]];
	}
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setUp];
    carousel.type = iCarouselTypeCylinder;
    carousel.contentOffset = CGSizeMake(0, -110);
    carousel.viewpointOffset = CGSizeMake(0, -124);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark iCarousel methods

- (NSUInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return 10;
}

- (NSUInteger)numberOfVisibleItemsInCarousel:(iCarousel *)carousel
{
    //limit the number of items views loaded concurrently (for performance reasons)
    //this also affects the appearance of circular-type carousels
    return 10;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSUInteger)index reusingView:(UIView *)view
{
	UILabel *label = nil;
	
	//create new view if no view is available for recycling
	if (view == nil)
	{
		view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]];
        NSLog(@"height:%f,width:%f",view.frame.size.height,view.frame.size.width);
        [view setFrame:CGRectMake(0, 0, 240, 300)];
		label = [[UILabel alloc] initWithFrame:view.bounds];
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = NSTextAlignmentCenter;
		label.font = [label.font fontWithSize:50];
		[view addSubview:label];
	}
	else
	{
		label = [[view subviews] lastObject];
	}
	
    //set label
	label.text = @"11";
	
	return view;
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    //usually this should be slightly wider than the item views
    return 210.0f;
}


@end
