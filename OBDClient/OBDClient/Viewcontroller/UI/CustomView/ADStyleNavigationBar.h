//
//  ADNavigationBar.h
//  OBDClient
//
//  Created by Holyen Zou on 13-6-19.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADStyleNavigationBar : UINavigationBar

@property (nonatomic, strong) UIImage *backgroundImage UI_APPEARANCE_SELECTOR;

@property (nonatomic, assign, getter = isDropShadowEnabled) BOOL dropShadowEnabled; // default is YES

@property (nonatomic, assign, getter = isTopRoundedCornersEnabled) BOOL topRoundedCornersEnabled; // default is YES

@property (nonatomic, assign) CGFloat cornerRadius; // default is 5

@property (nonatomic, assign) CGFloat dropShadowOpacity; // default is 0.85

@property (nonatomic, assign) CGFloat dropShadowRadius; // default is 3.0

@property (nonatomic, assign) CGFloat dropShadowOffset; // default is 1.0

// these methods below only support iOS 5.0 and later
@property (nonatomic, strong) UIFont *titleFont;

@property (nonatomic, strong) UIColor *titleColor;

@property (nonatomic, strong) UIColor *titleShadowColor;

@property (nonatomic, assign) UIOffset titleShadowOffset;

@end
