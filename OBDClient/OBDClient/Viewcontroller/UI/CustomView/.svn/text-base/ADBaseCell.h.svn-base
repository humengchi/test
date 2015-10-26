//
//  ADBaseCell.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Helper.h"
#import "ADBaseCellBackgroundView.h"

@interface ADBaseCell : UITableViewCell

@property (nonatomic) CGSize imageSize;

@property (nonatomic) CGFloat imageMargin;

@property (nonatomic) CGFloat labelMargin;

@property (nonatomic) CGFloat detailLabelMargin;

@property (nonatomic, strong) id userInfo;

- (void)setCellBackgroundColor:(UIColor *)backgroundColor
       selectedBackgroundColor:(UIColor *)selectedBackgroundColor;

- (void)setSeparatorWithTopImage:(UIImage *)topImage
                     bottomImage:(UIImage *)bottomImage;

- (void)setSeparatorWithTopColor:(UIColor *)topColor
                     bottomColor:(UIColor *)bottomColor;

- (void)setSelectedSeparatorWithTopImage:(UIImage *)topImage
                             bottomImage:(UIImage *)bottomImage;

- (void)setSelectedSeparatorWithTopColor:(UIColor *)topColor
                             bottomColor:(UIColor *)bottomColor;

@end
