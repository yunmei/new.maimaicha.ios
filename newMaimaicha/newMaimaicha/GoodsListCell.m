//
//  GoodsListCell.m
//  newMaimaicha
//
//  Created by ken on 13-6-27.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "GoodsListCell.h"
#import <QuartzCore/QuartzCore.h>
@implementation GoodsListCell
@synthesize goodsNameLabel = _goodsNameLabel;
@synthesize goodsPriceLabel = _goodsPriceLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.goodsNameLabel];
        [self addSubview:self.goodsPriceLabel];
        [self.imageView setImage:[UIImage imageNamed:@"goods_default.png"]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (UILabel *)goodsNameLabel
{
    if(_goodsNameLabel == nil)
    {
        _goodsNameLabel = [[UILabel alloc]init];
    }
    return _goodsNameLabel;
}

- (UILabel *)goodsPriceLabel
{
    if(_goodsPriceLabel == nil)
    {
        _goodsPriceLabel = [[UILabel alloc]init];
    }
    return _goodsPriceLabel;
}
@end
