//
//  ADiPhoneMenuViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADiPhoneMenuViewController.h"
#import "ADiPhoneUserManageViewController.h"
#import "ADUserManageViewController.h"
#import "ADRootViewController.h"
#import "ADMainWindow.h"
@interface ADiPhoneMenuViewController ()

@end

@implementation ADiPhoneMenuViewController

- (void)tableViewSelectedHandleInSubClasses:(NSString *)className
{        
    UIViewController *viewController = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
    //把viewController设置为navigationController的视图
    ADNavigationController *navigationController = [ADNavigationController navigationControllerWithRootViewController:viewController];
    [self.slidingController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
    CGRect frame = self.slidingController.topViewController.view.frame;
        
    self.slidingController.topViewController = navigationController;
    self.slidingController.topViewController.view.frame = frame;
    [self.slidingController resetTopView];
      }];
}

@end
