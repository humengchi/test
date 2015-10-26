//
//  ADCarsShowView.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADCarsShowView.h"
#import "ADSingletonUtil.h"
@implementation ADCarsShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        _devices = [ADSingletonUtil sharedInstance].devices;
        }
    return self;
}


- (void)drawRect:(CGRect)rect
{
     _devices = [ADSingletonUtil sharedInstance].devices;
    _rectOfPicture = self.bounds;
    CGFloat offsetWidth = 50;
    CGFloat offsetHeight = 50;
    
    _rectOfPicture.size.width -= offsetWidth;
    _rectOfPicture.size.height -= offsetHeight;
    _rectOfPicture.origin.x = offsetWidth / 2;
    _rectOfPicture.origin.y = offsetHeight / 2;
    _imageView = [[UIImageView alloc] initWithFrame:_rectOfPicture];
    _imageView.image = [UIImage imageNamed:@"user_default_selected_car.png"];
    [self addSubview:_imageView];
    
    _carImageButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _carImageButton.frame=_imageView.frame;
    [_carImageButton setBackgroundColor:[UIColor clearColor]];
    [_carImageButton addTarget:self action:@selector(TransToSummary) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_carImageButton];

    _leftArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftArrowButton addTarget:self action:@selector(leftArrowButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    _leftArrowButton.frame = CGRectMake(0, 55, 30, 30);
    [_leftArrowButton setBackgroundImage:[UIImage imageNamed:@"user_car_show_left_arrow.png"] forState:UIControlStateNormal];
    [self addSubview:_leftArrowButton];
    
    _rightArrowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightArrowButton addTarget:self action:@selector(rightArrowButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    _rightArrowButton.frame = CGRectMake(250, 55, 30, 30);
    [_rightArrowButton setBackgroundImage:[UIImage imageNamed:@"user_car_show_right_arrow.png"] forState:UIControlStateNormal];
    [self addSubview:_rightArrowButton];
    
    _carNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, offsetHeight / 2)];
    _carNameLabel.textAlignment = UITextAlignmentCenter;
    _carNameLabel.text = @"1号车";
    

    _carNameLabel.font = [UIFont systemFontOfSize:15];
    _carNameLabel.backgroundColor = [UIColor clearColor];
    _carNameLabel.textColor = DEFAULT_LABEL_COLOR;
    [self addSubview:_carNameLabel];
    
    _carPositionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - offsetHeight/2, self.bounds.size.width, offsetHeight / 2)];
    _carPositionLabel.textAlignment = UITextAlignmentCenter;
    _carPositionLabel.text = @"中国上海浦东张江高科";
    _carPositionLabel.font = [UIFont systemFontOfSize:15];
    _carPositionLabel.backgroundColor = [UIColor clearColor];
    _carPositionLabel.textColor = DEFAULT_LABEL_COLOR;
    [self addSubview:_carPositionLabel];
}

- (void)updateUIByIndex:(NSUInteger)aIndex isManual:(BOOL)aIsManual
{
    _currentIndex = aIndex;
    if (_delegate) {
        [_delegate ADCarsShowView:self selectedChanged:_currentIndex isManual:aIsManual];    //如果aIsManual为1则跳转到仪表界面
    }
    ADDeviceBase *deviceBase = [_devices objectAtIndex:_currentIndex];
    _carNameLabel.text = deviceBase.nickname;
    _leftArrowButton.enabled = YES;
    _rightArrowButton.enabled = YES;
    if (aIndex == 0) {
        _leftArrowButton.enabled = NO;
    }
    if (aIndex + 1 >= [_devices count]) {
        _rightArrowButton.enabled = NO;
    }
}

- (void)TransToSummary{
    [self updateUIByIndex:_currentIndex isManual:YES];
    
}
- (void)setDevices:(NSArray *)devices
{
    _devices = devices;
    _currentIndex = 0;
    [self updateUIByIndex:_currentIndex isManual:NO];
}


- (IBAction)leftArrowButtonTap:(id)sender
{
    int changeIndex = _currentIndex - 1;
    if (changeIndex < 0) {
        changeIndex = 0;
        return;
    }
    [self updateUIByIndex:changeIndex isManual:NO];
}

- (IBAction)rightArrowButtonTap:(id)sender
{
    int changeIndex = _currentIndex + 1;
    if (changeIndex >= [_devices count]) {
        changeIndex = _currentIndex;
        return;
    }
    [self updateUIByIndex:changeIndex isManual:NO];
}

@end
