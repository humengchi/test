//
//  ADGaugeView.h
//  GaugesDemo
//
//  Created by Holyen Zou on 13-4-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ADGaugeView : UIView
{
    UIImageView *_gaugeBGImageView;
    UIImageView *_pointerImageView;
    
    CGFloat _minValue;
    CGFloat _maxValue;
    
    CGFloat _minDegree;
    CGFloat _maxDegree;
    NSInteger _totalMarks;
    CGFloat _totalDegree;
    
    CGPoint _centerOfCircle;
    CGFloat _diameter;
    
    CGFloat _beginRadian;
    CGFloat _endRadian;
    
    CGFloat _currentRotate;
    CGFloat _destinationRotate;
    CGFloat _fromRotate;
    
    CGFloat _degreePreValue;
}

- (id)initWithFrame:(CGRect)frame
           minValue:(CGFloat)aMinValue
           maxValue:(CGFloat)aMaxValue
          minDegree:(CGFloat)aMinDegree
          maxDegree:(CGFloat)aMaxDegree
         totalMarks:(NSInteger)aTotalMarks
        pointerSize:(CGSize)aPointerSize
            bgImage:(UIImage *)aBGImage
       pointerImage:(UIImage *)aPointerImage
          initValue:(float)aInitValue
     pointerYOffset:(CGFloat)aYValue;

- (void)runToValue:(CGFloat)aToValue
          animated:(BOOL)aAnimated
         hasEffect:(BOOL)aHasEffect;

@end
