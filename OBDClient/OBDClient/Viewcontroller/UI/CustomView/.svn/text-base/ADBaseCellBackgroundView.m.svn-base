//
//  ADBaseCellBackgroundView.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseCellBackgroundView.h"

@implementation ADBaseCellBackgroundView

- (id)initWithTopImage:(UIImage *)aTopImage
           bottomImage:(UIImage *)aBottomImage
{
    NSAssert(aTopImage || aBottomImage, @"need at least 1 separator image!");
    
    if (self = [super init]) {
        _topImage = aTopImage;
        _bottomImage = aBottomImage;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (id)initWithTopColor:(UIColor *)topColor
           bottomColor:(UIColor *)bottomColor
{
    NSAssert(topColor || bottomColor, @"need at least 1 separator color!");
    
    if (self = [super init]) {
        _topColor = topColor;
        _bottomColor = bottomColor;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)drawColorLineInRect:(CGRect)rect
{
    UIBezierPath *bezier = [UIBezierPath bezierPath];
    bezier.lineWidth = 1;
    
    if (_topColor) {
        [bezier moveToPoint:CGPointMake(_separatorMargin, self.bounds.size.height - 1)];
        [bezier addLineToPoint:CGPointMake(self.bounds.size.width - _separatorMargin, self.bounds.size.height - 1)];
        [_topColor set];
        [bezier stroke];
    }
    
    if (_bottomColor) {
        [bezier moveToPoint:CGPointMake(_separatorMargin, 0)];
        [bezier addLineToPoint:CGPointMake(self.bounds.size.width - _separatorMargin, 0)];
        [_bottomColor set];
        [bezier stroke];
    }
}

- (void)drawImageLineInRect:(CGRect)rect
{
    CGRect linePos = CGRectMake(_separatorMargin, 0, self.bounds.size.width - _separatorMargin, 1);
    [_topImage drawInRect:linePos];
    linePos.origin.y = self.bounds.size.height - 1;
    [_bottomImage drawInRect:linePos];
}

- (void)drawRect:(CGRect)rect
{
    if (_topImage || _bottomImage) {
        [self drawImageLineInRect:self.bounds];
    } else if (_topColor || _bottomColor) {
        [self drawColorLineInRect:self.bounds];
    } else {
        NSAssert(0, @"invalid draw condition.");
    }
}

@end
