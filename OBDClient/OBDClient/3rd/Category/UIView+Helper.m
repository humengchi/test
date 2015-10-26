//
//  UIView+Helper.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (Helper)

- (void)resizeTo:(CGSize)newSize
{
    CGPoint center = self.center;
    CGRect frame = self.frame;
    frame.size = newSize;
    self.frame = frame;
    self.center = center;
}

- (void)resizeTo:(CGSize)newSize onEdge:(CGRectEdge)edge
{
    CGRect frame = self.frame;
    CGPoint origin = frame.origin;
    CGSize size = frame.size;
    
    [self resizeTo:newSize];
    
    switch (edge) {
        case CGRectMinXEdge:
            frame = self.frame;
            frame.origin.x = origin.x;
            break;
            
        case CGRectMinYEdge:
            frame = self.frame;
            frame.origin.y = origin.y;
            break;
            
        case CGRectMaxXEdge:
            frame = self.frame;
            origin = frame.origin;
            origin.x += (size.width - frame.size.width) / 2;
            frame.origin = origin;
            break;
            
        case CGRectMaxYEdge:
            frame = self.frame;
            origin = frame.origin;
            origin.y += (size.height - frame.size.height) / 2;
            frame.origin = origin;
            break;
            
        default:
            NSAssert(0, @"invalid CGRectEdge value");
            return;
    }
    
    self.frame = frame;
}

@end
