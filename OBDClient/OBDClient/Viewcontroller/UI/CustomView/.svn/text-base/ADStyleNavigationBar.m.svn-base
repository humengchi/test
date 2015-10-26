//
//  ADNavigationBar.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-19.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADStyleNavigationBar.h"
#import <QuartzCore/QuartzCore.h>

@interface ADStyleNavigationBar ()
{
    UIImage *_backgroundImage;
    
    BOOL _dropShadowEnabled;
    BOOL _topRoundedCornersEnabled;
}

@end

@implementation ADStyleNavigationBar

- (void)enableDropShadow
{
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = _dropShadowOpacity;
    self.layer.shadowOffset = CGSizeMake(0.0f, _dropShadowOffset);
    self.layer.shadowRadius = _dropShadowRadius;
}

- (void)disableDropShadow
{
    self.layer.shadowColor = nil;
    self.layer.shadowPath = nil;
    self.layer.shadowOpacity = 1;
    self.layer.shadowOffset = CGSizeZero;
    self.layer.shadowRadius = 0;
}

- (void)enableTopRoundedCorners
{
    CGRect bounds = self.bounds;
    bounds.size.height += 10.0f;
    NSUInteger rounding = UIRectCornerTopLeft | UIRectCornerTopRight;
    CGSize radii = {_cornerRadius, _cornerRadius};
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds
                                                   byRoundingCorners:rounding
                                                         cornerRadii:radii];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)disableTopRoundedCorners
{
    self.layer.mask = nil;
}

#pragma mark - property implementation
- (UIImage *)backgroundImage
{
    return _backgroundImage;
}

- (void)setBackgroundImage:(UIImage *)backgroundImage
{
    if (backgroundImage == _backgroundImage) {
        return;
    }
    _backgroundImage = backgroundImage;
    if ([self respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        [self setBackgroundImage:_backgroundImage forBarMetrics:UIBarMetricsDefault];
    } else {
        [self setNeedsDisplay];
    }
}

- (BOOL)isDropShadowEnabled
{
    return _dropShadowEnabled;
}

- (void)setDropShadowEnabled:(BOOL)dropShadowEnabled
{
    if (dropShadowEnabled == _dropShadowEnabled) {
        return;
    }
    
    _dropShadowEnabled = dropShadowEnabled;
    _dropShadowEnabled ? [self enableDropShadow] : [self disableDropShadow];
}

- (BOOL)isTopRoundedCornersEnabled
{
    return _topRoundedCornersEnabled;
}

- (void)setTopRoundedCornersEnabled:(BOOL)topRoundedCornersEnabled
{
    if (topRoundedCornersEnabled == _topRoundedCornersEnabled) {
        return;
    }
    _topRoundedCornersEnabled = topRoundedCornersEnabled;
    _topRoundedCornersEnabled ? [self enableTopRoundedCorners] : [self disableTopRoundedCorners];
}

- (UIFont *)titleFont
{
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        return [self.titleTextAttributes objectForKey:UITextAttributeFont];
    }
    return nil;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (!titleFont) {
        return;
    }
    
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        NSMutableDictionary *txtAttrs = [self.titleTextAttributes mutableCopy];
        if (!txtAttrs) {
            txtAttrs = [NSMutableDictionary dictionary];
        }
        [txtAttrs setObject:titleFont forKey:UITextAttributeFont];
        self.titleTextAttributes = txtAttrs;
    }
    
}

- (UIColor *)titleColor
{
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        return [self.titleTextAttributes objectForKey:UITextAttributeTextColor];
    }
    return nil;
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if (!titleColor) {
        return;
    }
    
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        NSMutableDictionary *txtAttrs = [self.titleTextAttributes mutableCopy];
        if (!txtAttrs) {
            txtAttrs = [NSMutableDictionary dictionary];
        }
        [txtAttrs setObject:titleColor forKey:UITextAttributeTextColor];
        self.titleTextAttributes = txtAttrs;
    }
}

- (UIColor *)titleShadowColor
{
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        return [self.titleTextAttributes objectForKey:UITextAttributeTextShadowColor];
    }
    return nil;
}

- (void)setTitleShadowColor:(UIColor *)titleShadowColor
{
    if (!titleShadowColor)
        return;
    
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        NSMutableDictionary *txtAttrs = [self.titleTextAttributes mutableCopy];
        if (!txtAttrs) {
            txtAttrs = [NSMutableDictionary dictionary];
        }
        [txtAttrs setObject:titleShadowColor forKey:UITextAttributeTextShadowColor];
        self.titleTextAttributes = txtAttrs;
    }
}

- (UIOffset)titleShadowOffset
{
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        return [(NSValue *)[self.titleTextAttributes objectForKey:UITextAttributeTextShadowOffset]
                UIOffsetValue];
    }
    return UIOffsetMake(0.0f, 0.0f);
}

- (void)setTitleShadowOffset:(UIOffset)titleShadowOffset
{
    if ([self respondsToSelector:@selector(titleTextAttributes)]) {
        NSMutableDictionary *txtAttrs = [self.titleTextAttributes mutableCopy];
        if (!txtAttrs) {
            txtAttrs = [NSMutableDictionary dictionary];
        }
        [txtAttrs setObject:[NSValue valueWithUIOffset:titleShadowOffset]
                     forKey:UITextAttributeTextShadowOffset];
        self.titleTextAttributes = txtAttrs;
    }
}

#pragma mark - override

- (void)_init
{
    _dropShadowOpacity = 0.85;
    _dropShadowRadius = 3.0f;
    _dropShadowOffset = 1.0f;
    _cornerRadius = 5.f;
    
    self.dropShadowEnabled = YES;
    self.topRoundedCornersEnabled = YES;
    
    self.clipsToBounds = NO;
    self.layer.shouldRasterize = YES;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        [self _init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)aFrame
{
    if ((self = [super initWithFrame:aFrame])) {
        [self _init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    if (_backgroundImage) {
        [_backgroundImage drawInRect:[self bounds]];
    } else {
        [super drawRect:rect];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_dropShadowEnabled) {
        self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    }
    
    if (_topRoundedCornersEnabled) {
        [self enableTopRoundedCorners];
    }
}

@end
