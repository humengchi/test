//
//  IVFeed_SVProgressHUD_Private.h
//  Vision
//
//  Created by Jieson Wu on 12-9-14.
//  Copyright (c) 2012年 Innovation. All rights reserved.
//

#import "SVProgressHUD.h"
@interface SVProgressHUD (Private)

- (void)showWithStatus:(NSString*)string maskType:(SVProgressHUDMaskType)hudMaskType networkIndicator:(BOOL)show;
- (void)showImage:(UIImage *)image status:(NSString *)string duration:(NSTimeInterval)duration;

+ (SVProgressHUD *)sharedView;
- (UIView *)hudView;

@property (nonatomic, strong, readonly) UIWindow *overlayWindow;

@end