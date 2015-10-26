//
//  IVRenderHelper.h
//  Vision
//
//  Created by Hank Bao on 12-6-18.
//  Copyright (c) 2012年 PPTV Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IVRenderHelper : NSObject

+ (UIImage *)imageFromView:(UIView *)view;

+ (UIImage *)imageFromView:(UIView *)view withRect:(CGRect)frame;

+ (UIImage *)imageFromView:(UIView *)view withRect:(CGRect)frame
         transparentInsets:(UIEdgeInsets)insets;

+ (UIImage *)imageForAntialiasing:(UIImage *)image
                       withInsets:(UIEdgeInsets)insets;

+ (UIImage *)imageForAntialiasing:(UIImage *)image;

@end
