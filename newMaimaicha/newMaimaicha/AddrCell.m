//
//  ;
//  newMaimaicha
//
//  Created by ken on 13-7-9.
//  Copyright (c) 2013年 maimaicha. All rights reserved.
//

#import "AddrCell.h"

@implementation AddrCell
@synthesize nameLabel = _nameLabel;
@synthesize addrLabel = _addrLabel;
@synthesize mobileLabel = _mobileLabel;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.addrLabel];

        [self.contentView addSubview:self.mobileLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UILabel *)nameLabel
{
    if(_nameLabel == nil)
    {
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 220, 15)];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_nameLabel setBackgroundColor:[UIColor clearColor]];
    }
    return _nameLabel;
}

- (UILabel *)addrLabel
{
    if(_addrLabel == nil)
    {
        _addrLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 30, 220, 30)];
        [_addrLabel setFont:[UIFont systemFontOfSize:12.0]];
        [_addrLabel setBackgroundColor:[UIColor clearColor]];
        [_addrLabel setNumberOfLines:0];
    }
    return _addrLabel;
}

- (UILabel *)mobileLabel
{
        if(_mobileLabel == nil)
        {
            _mobileLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 65, 220, 15)];
            [_mobileLabel setFont:[UIFont systemFontOfSize:12.0]];
            [_mobileLabel setBackgroundColor:[UIColor clearColor]];
            [_mobileLabel setNumberOfLines:0];
        }
    return _mobileLabel;
}
@end
