//
//  ADBaseCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseCell.h"

@implementation ADBaseCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageMargin = 10;
        _labelMargin = 50;
        _detailLabelMargin = _labelMargin;
    }
    return self;
}

- (void)prepareForReuse
{
    _userInfo = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!CGSizeEqualToSize(_imageSize, CGSizeZero)) {
        [self.imageView resizeTo:_imageSize];
    }
    
    CGRect frame = self.imageView.frame;
    frame.origin.x = _imageMargin;
    self.imageView.frame = frame;
    
    frame = self.textLabel.frame;
    frame.size.height -= 2;
    frame.origin.x = _labelMargin;
    frame.origin.y += 1;
    self.textLabel.frame = frame;
    frame = self.detailTextLabel.frame;
    frame.origin.x = _detailLabelMargin;
    self.detailTextLabel.frame = frame;
}

- (void)setCellBackgroundColor:(UIColor *)backgroundColor
       selectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    self.backgroundColor = backgroundColor;
    self.imageView.backgroundColor = backgroundColor;
    self.textLabel.backgroundColor = backgroundColor;
    self.detailTextLabel.backgroundColor = backgroundColor;
    
    self.backgroundView.backgroundColor = backgroundColor;
    self.selectedBackgroundView.backgroundColor = selectedBackgroundColor;
}

- (void)setSeparatorWithTopImage:(UIImage *)topImage
                     bottomImage:(UIImage *)bottomImage
{
    self.backgroundView = [[ADBaseCellBackgroundView alloc] initWithTopImage:topImage
                                                                 bottomImage:bottomImage];
}

- (void)setSeparatorWithTopColor:(UIColor *)topColor bottomColor:(UIColor *)bottomColor
{
    self.backgroundView = [[ADBaseCellBackgroundView alloc] initWithTopColor:topColor
                                                                 bottomColor:bottomColor];
}

- (void)setSelectedSeparatorWithTopImage:(UIImage *)topImage
                             bottomImage:(UIImage *)bottomImage
{
    self.selectedBackgroundView = [[ADBaseCellBackgroundView alloc] initWithTopImage:topImage
                                                                         bottomImage:bottomImage];
}

- (void)setSelectedSeparatorWithTopColor:(UIColor *)topColor
                             bottomColor:(UIColor *)bottomColor
{
    self.selectedBackgroundView = [[ADBaseCellBackgroundView alloc] initWithTopColor:topColor
                                                                         bottomColor:bottomColor];
}

@end
