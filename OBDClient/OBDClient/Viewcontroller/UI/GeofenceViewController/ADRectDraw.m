//
//  ADRectDraw.m
//  OBDClient
//
//  Created by hys on 23/9/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADRectDraw.h"
#import <QuartzCore/QuartzCore.h>

@implementation ADRectDraw

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2.0);//线的宽度
    UIColor *color = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.3];
    CGContextSetFillColorWithColor(context, color.CGColor);//填充颜色
    color = [UIColor blueColor];
    CGContextSetStrokeColorWithColor(context, color.CGColor);//线框颜色
    CGContextAddRect(context,CGRectMake(2, 2, self.frame.size.width-4.0, self.frame.size.width-4.0));//画方框
    CGContextDrawPath(context, kCGPathFillStroke);//绘画路径
}


@end
