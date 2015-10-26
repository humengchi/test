//
//  ADBaseCellBackgroundView.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADBaseCellBackgroundView : UIView

@property (nonatomic, strong) UIColor *topColor;
@property (nonatomic, strong) UIColor *bottomColor;

@property (nonatomic, strong) UIImage *topImage;
@property (nonatomic, strong) UIImage *bottomImage;

@property (nonatomic, assign) CGFloat separatorMargin;

- (id)initWithTopImage:(UIImage *)aTopImage
           bottomImage:(UIImage *)aBottomImage;

- (id)initWithTopColor:(UIColor *)topColor
           bottomColor:(UIColor *)bottomColor;

@end
