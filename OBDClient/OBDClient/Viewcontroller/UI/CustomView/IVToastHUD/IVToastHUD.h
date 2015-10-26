//
//  IVToastHUD.h
//  Vision
//
//  Created by Jieson Wu on 12-9-14.
//  Copyright (c) 2012年 Innovation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SVProgressHUD.h"

typedef enum {
    IV_TOAST_HUD_MASK_TYPE_NONE = SVProgressHUDMaskTypeNone,
    IV_TOAST_HUD_MASK_TYPE_CLEAR = SVProgressHUDMaskTypeClear,
    IV_TOAST_HUD_MASK_TYPE_BLACK = SVProgressHUDMaskTypeBlack,
    IV_TOAST_HUD_MASK_TYPE_GRADIENT = SVProgressHUDMaskTypeGradient,
} IV_TOAST_HUD_MASK_TYPE;

typedef enum {
    IV_TOAST_REQUEST_FIAL = 0,
    IV_TOAST_REQUEST_SUCCESS = 1,
    IV_TOAST_REQUEST_TIMEOUT = 2
} IVToastRequestResultType;

//*************************************/
// inherit the SVProgressHUD to support that the HUD will be dismiss when the HUD is clicked.
//*************************************/
@interface IVToastHUD : SVProgressHUD
+ (void)show;
+ (void)showWithMaskType:(IV_TOAST_HUD_MASK_TYPE)maskType;

+ (void)showWithStatus:(NSString*)status;
+ (void)showWithStatus:(NSString*)status maskType:(IV_TOAST_HUD_MASK_TYPE)maskType;

// stops the activity indicator, shows a glyph + status, and dismisses HUD 1s later
+ (void)showSuccessWithStatus:(NSString*)string;
+ (void)showErrorWithStatus:(NSString *)string;
+ (void)showImage:(UIImage*)image status:(NSString*)status; // use 28x28 white pngs

+ (void)showAsToastWithStatus:(NSString*)status;

// stops the activity indicator, shows a glyph + status, and dismisses HUD 3s later
+ (void)showAsToastSuccessWithStatus:(NSString*)string;
+ (void)showAsToastErrorWithStatus:(NSString *)string;
+ (void)showAsToastWithImage:(UIImage*)image status:(NSString*)status; // use 28x28 white pngs

+ (void)endRequestWithResultType:(IVToastRequestResultType)aResultType message:(NSString *)aMessage;

@end