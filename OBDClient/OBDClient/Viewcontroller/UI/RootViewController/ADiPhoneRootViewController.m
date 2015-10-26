//
//  ADiPhoneRootViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADiPhoneRootViewController.h"

@implementation ADiPhoneRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)loadLeftBackViewController
{
    self.anchorRightPeekAmount = 60.f;
    _menuViewController = [[ADiPhoneMenuViewController alloc] initWithNibName:nil bundle:nil];
    self.leftBackViewController = _menuViewController;
}

- (void)loadRightBackViewController
{
    
}

@end
