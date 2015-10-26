//
//  ADNavigationController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-6-19.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADStyleNavigationBar.h"

@interface ADNavigationController : UINavigationController

@property (nonatomic) BOOL shouldAutorotate;
@property (nonatomic) NSUInteger supportedInterfaceOrientations;

+ (ADNavigationController *)navigationControllerWithRootViewController:(UIViewController *)rootViewController;
- (ADStyleNavigationBar *)styleNavigationBar;

@end
