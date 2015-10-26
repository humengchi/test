//
//  IVToastHUD.m
//  Vision
//
//  Created by Jieson Wu on 12-9-14.
//  Copyright (c) 2012年 Innovation. All rights reserved.
//

#import "IVToastHUD.h"
#import "SVProgressHUD+Private.h"

static UITapGestureRecognizer *tapRecognizer = nil;

@implementation IVToastHUD

#pragma mark - Private Method
+ (void)addTapRecognizerEnableUserOperation
{
    [IVToastHUD sharedView].userInteractionEnabled = YES;
    [IVToastHUD sharedView].overlayWindow.userInteractionEnabled = YES;
    UIView *view = [IVToastHUD sharedView].hudView;
    view.userInteractionEnabled = YES;
    if (view && !tapRecognizer) {
        tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:[SVProgressHUD sharedView]
                                                                action:@selector(dismiss)];
        [tapRecognizer setNumberOfTapsRequired:1];
    }
    
    [view addGestureRecognizer:tapRecognizer];
}

+ (void)removeCurrentTapRecognizer
{
    if (tapRecognizer) {
        [tapRecognizer.view removeGestureRecognizer:tapRecognizer];
    } 
}

+ (void)endRequestWithResultType:(IVToastRequestResultType)aResultType message:(NSString *)aMessage
{
    switch (aResultType) {
        case IV_TOAST_REQUEST_SUCCESS:
            [IVToastHUD dismiss];
            break;
        case IV_TOAST_REQUEST_FIAL:
            [IVToastHUD showErrorWithStatus:aMessage];
            break;
        case IV_TOAST_REQUEST_TIMEOUT:
            [IVToastHUD showErrorWithStatus:aMessage];
            break;
        default:
            break;
    }
}

#pragma mark - Super Method
+ (void)show
{
    [IVToastHUD removeCurrentTapRecognizer];
    [SVProgressHUD show];
}

+ (void)showWithMaskType:(IV_TOAST_HUD_MASK_TYPE)maskType
{    
    [IVToastHUD removeCurrentTapRecognizer];
    [SVProgressHUD showWithMaskType:maskType];
}

+ (void)showWithStatus:(NSString*)status
{
    [IVToastHUD removeCurrentTapRecognizer];
    [SVProgressHUD showWithStatus:status];
}

+ (void)showWithStatus:(NSString*)status maskType:(IV_TOAST_HUD_MASK_TYPE)maskType
{
    [IVToastHUD removeCurrentTapRecognizer];
    [SVProgressHUD showWithStatus:status maskType:maskType];
}

// stops the activity indicator, shows a glyph + status, and dismisses HUD 1s later
+ (void)showSuccessWithStatus:(NSString*)string
{
    [IVToastHUD removeCurrentTapRecognizer];
    [SVProgressHUD showSuccessWithStatus:string];
}

+ (void)showErrorWithStatus:(NSString *)string
{
    [IVToastHUD removeCurrentTapRecognizer];
    [SVProgressHUD showErrorWithStatus:string];
}

+ (void)showImage:(UIImage*)image status:(NSString*)status // use 28x28 white pngs
{
    [IVToastHUD removeCurrentTapRecognizer];
    [SVProgressHUD showImage:image status:status];
}

#pragma mark - Public Method

+ (void)showAsToastWithStatus:(NSString*)status
{
    [[IVToastHUD sharedView] showWithStatus:status maskType:SVProgressHUDMaskTypeClear networkIndicator:NO];
    [IVToastHUD addTapRecognizerEnableUserOperation];
}

// stops the activity indicator, shows a glyph + status, and dismisses HUD 3s later
+ (void)showAsToastSuccessWithStatus:(NSString*)string
{
    [[IVToastHUD sharedView] showImage:[UIImage imageNamed:@"SVProgressHUD.bundle/success.png"] status:string duration:3];
    [IVToastHUD addTapRecognizerEnableUserOperation];
}

+ (void)showAsToastErrorWithStatus:(NSString *)string
{
    [[IVToastHUD sharedView] showImage:[UIImage imageNamed:@"SVProgressHUD.bundle/error.png"] status:string duration:3];
    [IVToastHUD addTapRecognizerEnableUserOperation];
}

+ (void)showAsToastWithImage:(UIImage*)image status:(NSString*)status
{
    [[IVToastHUD sharedView] showImage:image status:status duration:3];
    [IVToastHUD addTapRecognizerEnableUserOperation];
}

@end