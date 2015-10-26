//
//  ADGeofenceDraw.m
//  OBDClient
//
//  Created by lbs anydata on 14-2-20.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADGeofenceDraw.h"
#import <QuartzCore/QuartzCore.h> 

#define PI 3.14159265358979323846 

@implementation ADGeofenceDraw

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

/// 覆盖drawRect方法，你可以在此自定义绘画和动画
- (void)drawRect:(CGRect)rect
{
//    NSLog(@"draw:%f--%f",rect.size.height,rect.size.width);
    NSLog(@"draw:%f--%f",self.frame.size.height,self.frame.size.width);
    //An opaque type that represents a Quartz 2D drawing environment.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    /*画圆*/
    //边框圆
//    CGContextSetRGBStrokeColor(context,0,0,1,0.5);//画笔线的颜色
//    CGContextSetLineWidth(context, 4.0);//线的宽度
    //void CGContextAddArc(CGContextRef c,CGFloat x, CGFloat y,CGFloat radius,CGFloat startAngle,CGFloat endAngle, int clockwise)1弧度＝180°/π （≈57.3°） 度＝弧度×180°/π 360°＝360×π/180 ＝2π 弧度
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针。
    UIColor*aColor = [UIColor colorWithRed:0 green:1 blue:1 alpha:0.3];
    CGContextSetFillColorWithColor(context, aColor.CGColor);//填充颜色
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, (self.frame.size.width)/2, 0, 2*PI, 0); //添加一个圆
    CGContextDrawPath(context, kCGPathFill);//绘制填充
//    CGContextDrawPath(context, kCGPathEOFillStroke);
//    CGContextDrawPath(context, kCGPathStroke); //绘制路径
    
    
}
@end
