//
//  ADGaugeView.m
//  GaugesDemo
//
//  Created by Holyen Zou on 13-4-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGaugeView.h"
#define DEGREE_TO_RADIAN(x)  (x * M_PI / 180)
#define BOUNDS_WIDTH self.bounds.size.width
#define BOUNDS_HEIGHT self.bounds.size.height

@implementation ADGaugeView

- (id)initWithFrame:(CGRect)frame
            bgImage:(UIImage *)aBGImage
       pointerImage:(UIImage *)aPointerImage
        pointerSize:(CGSize)aPointerSize
     pointerYOffset:(CGFloat)aYValue
{
    if (self = [super initWithFrame:frame])
    {
        if (aBGImage) {
            _gaugeBGImageView = [[UIImageView alloc] initWithImage:aBGImage];
            CGRect bgImageFrame = _gaugeBGImageView.frame;
            bgImageFrame.size = frame.size;
            _gaugeBGImageView.frame = bgImageFrame;
            [self addSubview:_gaugeBGImageView];
        }

        if (aPointerImage) {
            _pointerImageView = [[UIImageView alloc] initWithImage:aPointerImage];
            _pointerImageView.layer.anchorPoint = CGPointMake(0.5, 1);

//            NSLog(@"bounds_width:%f &&& bounds_height:%f",BOUNDS_WIDTH,BOUNDS_HEIGHT);
            CGRect pointerFrame = CGRectMake((BOUNDS_WIDTH - 5) / 2, (BOUNDS_HEIGHT/2) - aPointerSize.height, aPointerSize.width, aPointerSize.height);
            pointerFrame.origin.y = aYValue == NSNotFound ? pointerFrame.origin.y : aYValue;
            _pointerImageView.frame = pointerFrame;
            
            [self addSubview:_pointerImageView];            
        }
    }
    return self;
}

/** 暂时实现这个方法 */
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
     pointerYOffset:(CGFloat)aYValue
{
    self = [self initWithFrame:frame
                       bgImage:aBGImage //400 X 400
                  pointerImage:aPointerImage
                   pointerSize:aPointerSize
                pointerYOffset:aYValue];//5X55
    if (self)
    {
        _minValue = aMinValue;
        _maxValue = aMaxValue;
        _minDegree = aMinDegree;
        _maxDegree = aMaxDegree;
        _totalMarks = aTotalMarks;
        _totalDegree = _maxDegree - _minDegree;
        _centerOfCircle = CGPointMake(BOUNDS_WIDTH / 2, BOUNDS_HEIGHT / 2);
        _diameter = BOUNDS_HEIGHT;
        _beginRadian = -145;
        _endRadian = 140;
        _degreePreValue = _totalDegree / (_maxValue - _minValue);
        _currentRotate = [self rotateByValue:aInitValue];
        _pointerImageView.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIAN(_currentRotate));
    }
    return self;
}

- (float)rotateByValue:(float)aValue
{
    if (aValue > _maxValue) {
        aValue = _maxValue;
    } else if (aValue < _minValue) {
        aValue = _minValue;
    }
//    NSLog(@"%f",_minDegree + (aValue * _degreePreValue));
    return _minDegree + (aValue * _degreePreValue);
}

- (void)initGauge
{
    //_pointerImageView.layer.transform = CATransform3DRotate(CATransform3DIdentity, CONVERT(_beginRadian), 0, 0, 1);
}

- (void)runToValue:(CGFloat)aToValue
          animated:(BOOL)aAnimated
         hasEffect:(BOOL)aHasEffect
{
    _fromRotate = _currentRotate;// = [self rotateByValue:aFromValue];
    _destinationRotate = [self rotateByValue:aToValue];
    //_currentRotate = 0;
    _currentRotate = (_destinationRotate > _fromRotate ? _fromRotate + 1 : _fromRotate - 1);
    [_pointerImageView.layer removeAllAnimations];
    [self startAnimation];
}

- (void)startAnimation
{
    [UIView beginAnimations:@"rotateAnimate" context:nil];
    [UIView setAnimationDuration:0.001];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(endAnimation)];
//    NSLog(@"Rotate:%f",DEGREE_TO_RADIAN(_currentRotate));
    _pointerImageView.transform = CGAffineTransformMakeRotation(DEGREE_TO_RADIAN(_currentRotate));
    [UIView commitAnimations];
}

- (void)endAnimation
{
    _currentRotate += (_destinationRotate > _fromRotate ? 1 : -1);
    BOOL isChange = _destinationRotate > _fromRotate;
    
    if (isChange) {
        if (_currentRotate >= _destinationRotate) {
            //end
        }
        else
            [self startAnimation];
    } else {
        if (_currentRotate <= _destinationRotate) {
            //end
        }
        else
            [self startAnimation];
    }
}

@end
