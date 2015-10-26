//
//  ADRootViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADRootViewController.h"

@implementation ADRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.shouldAddPanGestureRecognizerToFrontViewSnapshot = YES;
    ADNavigationController *navController;
    if([_isCarAssistantVC isEqualToString:@"no"]){
    //初始化用户中心的导航栏，并初始化导航栏的rootviewcontroller为用户中心的视图类
    navController = [ADNavigationController navigationControllerWithRootViewController:[[ADiPhoneUserManageViewController alloc] initWithNibName:nil bundle:nil]];
    }else{
    //跳过选择车辆界面，直接进入用车助手
    navController = [ADNavigationController navigationControllerWithRootViewController:[[CarAssistantViewController alloc] initWithNibName:nil bundle:nil]];
    }
    [self setFrontViewController:navController];
    [self loadLeftBackViewController];
    [self loadRightBackViewController];
}

- (void)loadLeftBackViewController
{
    //implement this method in subclasses
}

- (void)loadRightBackViewController
{
    //implement this method in subclasses
}

@end