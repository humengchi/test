//
//  ADSlidingViewController.m
//  ECSlidingViewControllerDemo
//
//  Created by Holyen Zou on 13-4-25.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSlidingViewController.h"

NSString * const ADSlidingViewBackLeftWillAppearNotification    = @"ECSlidingViewUnderLeftWillAppear";
NSString * const ADSlidingViewBackRightWillAppearNotification   = @"ECSlidingViewUnderRightWillAppear";
NSString * const ADSlidingViewFrontDidAnchorLeftNotification    = @"ECSlidingViewTopDidAnchorLeft";
NSString * const ADSlidingViewFrontDidAnchorRightNotification   = @"ECSlidingViewTopDidAnchorRight";
NSString * const ADSlidingViewFrontDidResetNotification         = @"ECSlidingViewTopDidReset";

@implementation ADSlidingViewController

- (UIViewController *)leftBackViewController
{
    return self.underLeftViewController;
}

- (void)setLeftBackViewController:(UIViewController *)leftBackViewController
{
    self.underLeftViewController = leftBackViewController;
}

- (UIViewController *)rightBackViewController
{
    return self.underRightViewController;
}

- (void)setRightBackViewController:(UIViewController *)rightBackViewController
{
    self.underRightViewController = rightBackViewController;
}

- (UIViewController *)frontViewController
{
    return self.topViewController;
}

- (void)setFrontViewController:(UIViewController *)frontViewController
{
    self.topViewController = frontViewController;
}

- (CGFloat)anchorLeftPeekAmount
{
    return [super anchorLeftPeekAmount];
}

- (void)setAnchorLeftPeekAmount:(CGFloat)anchorLeftPeekAmount
{
    [super setAnchorLeftPeekAmount:anchorLeftPeekAmount];
}

- (CGFloat)anchorRightPeekAmount
{
    return [super anchorRightPeekAmount];
}

- (void)setAnchorRightPeekAmount:(CGFloat)anchorRightPeekAmount
{
    [super setAnchorRightPeekAmount:anchorRightPeekAmount];
}

- (CGFloat)anchorLeftRevealAmount
{
    return [super anchorLeftRevealAmount];
}

- (void)setAnchorLeftRevealAmount:(CGFloat)anchorLeftRevealAmount
{
    [super setAnchorLeftRevealAmount:anchorLeftRevealAmount];
}

- (CGFloat)anchorRightRevealAmount
{
    return [super anchorRightRevealAmount];
}

- (void)setAnchorRightRevealAmount:(CGFloat)anchorRightRevealAmount
{
    [super setAnchorRightRevealAmount:anchorRightRevealAmount];
}

- (BOOL)shouldAllowUserInteractionsWhenAnchored
{
    return [super shouldAllowUserInteractionsWhenAnchored];
}

- (void)setShouldAllowUserInteractionsWhenAnchored:(BOOL)shouldAllowUserInteractionsWhenAnchored
{
    [super setShouldAllowUserInteractionsWhenAnchored:shouldAllowUserInteractionsWhenAnchored];
}

- (BOOL)shouldAddPanGestureRecognizerToFrontViewSnapshot
{
    return [super shouldAddPanGestureRecognizerToTopViewSnapshot];
}

- (void)setShouldAddPanGestureRecognizerToFrontViewSnapshot:(BOOL)shouldAddPanGestureRecognizerToFrontViewSnapshot
{
    [super setShouldAddPanGestureRecognizerToTopViewSnapshot:shouldAddPanGestureRecognizerToFrontViewSnapshot];
}

- (ADSlidingBackViewLayout)leftBackViewLayout
{
    return (ADSlidingBackViewLayout)self.underLeftWidthLayout;
}

- (void)setLeftBackViewLayout:(ADSlidingBackViewLayout)leftBackViewLayout
{
    self.underLeftWidthLayout = leftBackViewLayout;
}

- (ADSlidingBackViewLayout)rightBackViewLayout
{
    return (ADSlidingBackViewLayout)self.underRightWidthLayout;
}

- (void)setRightBackViewLayout:(ADSlidingBackViewLayout)rightBackViewLayout
{
    self.underRightWidthLayout = rightBackViewLayout;
}

- (ADSlidingResetMethod)resetMethod
{
    return (ADSlidingResetMethod)self.resetStrategy;
}

- (void)setResetMethod:(ADSlidingResetMethod)resetMethod
{
    self.resetStrategy = resetMethod;
}

- (UIPanGestureRecognizer *)panGesture
{
    return [super panGesture];
}

- (void)anchorFrontViewTo:(ADSlidingSide)side;
{
    [self anchorTopViewTo:(ECSide)side];
}

- (void)anchorFrontViewTo:(ADSlidingSide)side
               animations:(void(^)())animations
               onComplete:(void(^)())complete
{
    [self anchorTopViewTo:(ECSide)side animations:animations onComplete:complete];
}

- (void)anchorFrontViewOffScreenTo:(ADSlidingSide)side
{
    [self anchorTopViewOffScreenTo:(ECSide)side];
}

- (void)anchorFrontViewOffScreenTo:(ADSlidingSide)side
                        animations:(void(^)())animations
                        onComplete:(void(^)())complete;
{
    [self anchorTopViewOffScreenTo:(ECSide)side animations:animations onComplete:complete];
}

- (void)resetFrontView
{
    [self resetTopView];
}

- (void)resetFrontViewWithAnimations:(void(^)())animations onComplete:(void(^)())complete
{
    [self resetTopViewWithAnimations:animations onComplete:complete];
}

- (BOOL)leftBackViewShowing
{
    return [self underLeftShowing];
}

- (BOOL)rightBackViewShowing
{
    return [self underRightShowing];
}

- (BOOL)isFrontViewOffScreen
{
    return [self topViewIsOffScreen];
}

@end

@implementation UIViewController (ADSlidingViewController)

- (ADSlidingViewController *)slidingController
{
    return (ADSlidingViewController *) [self slidingViewController];
}

@end