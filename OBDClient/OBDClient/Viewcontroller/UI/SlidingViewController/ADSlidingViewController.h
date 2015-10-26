//
//  ADSlidingViewController.h
//  ECSlidingViewControllerDemo
//
//  Created by Holyen Zou on 13-4-25.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"

/** Notification that gets posted when the left back view will appear */
extern NSString * const ADSlidingViewBackLeftWillAppearNotification;

/** Notification that gets posted when the right back view will appear */
extern NSString * const ADSlidingViewBackRightWillAppearNotification;

/** Notification that gets posted when the front view is anchored to the left side of the screen */
extern NSString * const ADSlidingViewFrontDidAnchorLeftNotification;

/** Notification that gets posted when the front view is anchored to the right side of the screen */
extern NSString * const ADSlidingViewFrontDidAnchorRightNotification;

/** Notification that gets posted when the front view is centered on the screen */
extern NSString * const ADSlidingViewFrontDidResetNotification;

typedef enum {
    /** Back view will take up the full width of the screen */
    LAYOUT_WIDTH_FULL = ECFullWidth,
    /** Back view will have a fixed width equal to anchor RightRevealAmount or anchorLeftRevealAmount. */
    LAYOUT_WIDTH_REVEAL_FIXED = ECFixedRevealWidth,
    /** Back view will have a variable width depending on rotation equal to the screen's width - anchorRightPeekAmount or anchorLeftPeekAmount. */
    LAYOUT_WIDTH_REVEAL_VARIABLE = ECVariableRevealWidth
} ADSlidingBackViewLayout;

typedef enum {
    SIDE_LEFT = ECLeft,
    SIDE_RIGHT = ECRight
} ADSlidingSide;

typedef enum {
    /** No reset strategy will be used */
    RESET_NONE = ECNone,
    /** Tapping the front view will reset it. */
    RESET_TAP = ECTapping,
    /** Panning will be enabled on the front view. If it's panned and released towards the reset position it will reset, otherwise it will silde towards the anchored position. */
    RESET_PAN = ECPanning
} ADSlidingResetMethod;

@interface ADSlidingViewController : ECSlidingViewController

@property (nonatomic, strong) UIViewController *leftBackViewController;

@property (nonatomic, strong) UIViewController *rightBackViewController;

@property (nonatomic, strong) UIViewController *frontViewController;

@property (nonatomic, assign) CGFloat anchorLeftPeekAmount;

@property (nonatomic, assign) CGFloat anchorRightPeekAmount;

@property (nonatomic, assign) CGFloat anchorLeftRevealAmount;

@property (nonatomic, assign) CGFloat anchorRightRevealAmount;

@property (nonatomic, assign) BOOL shouldAllowUserInteractionsWhenAnchored;

@property (nonatomic, assign) BOOL shouldAddPanGestureRecognizerToFrontViewSnapshot;

@property (nonatomic, assign) ADSlidingBackViewLayout leftBackViewLayout;

@property (nonatomic, assign) ADSlidingBackViewLayout rightBackViewLayout;

@property (nonatomic, assign) ADSlidingResetMethod resetMethod;

- (UIPanGestureRecognizer *)panGesture;

- (void)anchorFrontViewTo:(ADSlidingSide)side;

- (void)anchorFrontViewTo:(ADSlidingSide)side animations:(void(^)())animations
               onComplete:(void(^)())complete;

- (void)anchorFrontViewOffScreenTo:(ADSlidingSide)side;

- (void)anchorFrontViewOffScreenTo:(ADSlidingSide)side
                        animations:(void(^)())animations
                        onComplete:(void(^)())complete;

- (void)resetFrontView;

- (void)resetFrontViewWithAnimations:(void(^)())animations
                          onComplete:(void(^)())complete;

- (BOOL)leftBackViewShowing;

- (BOOL)rightBackViewShowing;

- (BOOL)isFrontViewOffScreen;

@end

@interface UIViewController (ADSlidingViewController)

- (ADSlidingViewController *)slidingController;

@end