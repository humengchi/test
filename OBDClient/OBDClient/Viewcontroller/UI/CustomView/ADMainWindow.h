//
//  ADMainWindow.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADRootViewController.h"
#import "ADUserGuideViewController.h"

@interface ADMainWindow : UIWindow

- (void)setRootViewController:(UIViewController *)rootViewController
                     animated:(BOOL)animated;

- (void)transitionToMainViewController;

- (void)transitionToLoginViewController;

- (void)transitionToCarAssistantViewController;

@end
