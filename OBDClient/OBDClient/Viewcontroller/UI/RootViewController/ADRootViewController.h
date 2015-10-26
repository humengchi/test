//
//  ADRootViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSlidingViewController.h"
#import "ADiPhoneSummaryViewController.h"
#import "ADiPhoneMenuViewController.h"
#import "ADNavigationController.h"
#import "ADiPhoneUserManageViewController.h"
#import "CarAssistantViewController.h"

@interface ADRootViewController : ADSlidingViewController

@property (nonatomic, strong) NSString *isCarAssistantVC;

- (void)loadLeftBackViewController;
- (void)loadRightBackViewController;

@end
