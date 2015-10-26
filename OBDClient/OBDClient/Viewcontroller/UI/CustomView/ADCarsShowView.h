//
//  ADCarsShowView.h
//  OBDClient
//
//  Created by Holyen Zou on 13-6-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtil.h"
#import "ADDeviceBase.h"

@class ADCarsShowView;
@protocol ADCarShowViewDelegate <NSObject>
@required
- (void)ADCarsShowView:(ADCarsShowView *)carsShowView selectedChanged:(NSUInteger)aIndex isManual:(BOOL)aIsManual;

@end

@interface ADCarsShowView : UIView
{
    CGRect _rectOfPicture;
    UIImageView *_imageView;
    
    UIButton *_leftArrowButton;
    UIButton *_rightArrowButton;
    
    UIButton *_carImageButton;
    
    UILabel *_carNameLabel;
    UILabel *_carPositionLabel;
    int _currentIndex;
}

@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, weak) id <ADCarShowViewDelegate> delegate;

- (void)updateUIByIndex:(NSUInteger)aIndex isManual:(BOOL)aIsManual;


@end
