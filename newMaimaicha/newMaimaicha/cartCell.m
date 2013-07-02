//
//  cartCell.m
//  newMaimaicha
//
//  Created by ken on 13-7-2.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "cartCell.h"

@implementation cartCell
@synthesize  nameLabel = _nameLabel;
@synthesize bnLabel = _bnLabel;
@synthesize buyCountField = _buyCountField;
@synthesize priceLabel = _priceLabel;
@synthesize numberLabel = _numberLabel;
@synthesize buyCountLabel = _buyCountLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self addSubview:self.numberLabel];
        [self addSubview:self.nameLabel];
        [self addSubview:self.buyCountField];
        [self addSubview:self.priceLabel];
        [self addSubview:self.bnLabel];
        [self addSubview:self.buyCountLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UITextField *)buyCountField
{
    if(_buyCountField == nil)
    {
        _buyCountField = [[UITextField alloc]initWithFrame:CGRectMake(40, 53, 40, 20)];
        _buyCountField.hidden = YES;
    }
    return _buyCountField;
}

- (UILabel *)nameLabel
{
    if(_nameLabel == nil)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 20)];
        [_nameLabel setFont:[UIFont systemFontOfSize:13.0]];
    }
    return _nameLabel;
}

- (UILabel *)bnLabel
{
    if(_bnLabel == nil)
    {
        _bnLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, 300, 20)];
        _bnLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _bnLabel;
}

- (UILabel *)numberLabel
{
    if(_numberLabel == nil)
    {
        _numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 53, 35, 20)];
        [_numberLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_numberLabel setText:@"数量: "];
    }
    return _numberLabel;
}

- (UILabel *)priceLabel
{
    if(_priceLabel == nil)
    {
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(120, 53, 100, 20)];
        [_priceLabel setTextColor:[UIColor redColor]];
        [_priceLabel setFont:[UIFont systemFontOfSize:12.0]];
    }
    return _priceLabel;
}

- (UILabel *)buyCountLabel
{
    if(_buyCountLabel == nil)
    {
        _buyCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 53, 40, 20)];
        _buyCountLabel.hidden = NO;
        _buyCountLabel.font = [UIFont systemFontOfSize:12.0];
    }
return _buyCountLabel;
}
@end
