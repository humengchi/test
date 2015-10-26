//
//  ADNavigationController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-19.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADNavigationController.h"

static NSString * const kADiPhoneStyleXIB   =   @"ADNavigationController_iPhone";
static NSString * const kADiPadStyleXIB     =   @"ADNavigationController_iPad";

@interface ADNavigationController ()

@end

@implementation ADNavigationController

+ (ADNavigationController *)navigationControllerWithRootViewController:(UIViewController *)rootViewController
{
    if (!rootViewController) {
        NSAssert(0, @"root view controller can't be nil!");
        return nil;
    }
    
    BOOL isPhone = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone;
    NSString *xibName = isPhone ? kADiPhoneStyleXIB : kADiPadStyleXIB;
    UINib *navNib = [UINib nibWithNibName:xibName bundle:nil];
    NSAssert(navNib, @"failed to load nav nib.");
    
    ADNavigationController *navController = [[navNib instantiateWithOwner:nil options:nil] lastObject];
    NSAssert(navController, @"failed to load nav controller from nib.");
    NSAssert([navController isKindOfClass:[ADNavigationController class]], @"type error in nib top object.");
    
    navController.viewControllers = [NSArray arrayWithObject:rootViewController];
    return navController;
}

- (ADStyleNavigationBar *)styleNavigationBar
{
    if (![self.navigationBar isKindOfClass:[ADStyleNavigationBar class]]) {
        NSAssert(0, @"can not get a style navbar from a regular nav controller.");
        return nil;
    }
    return (ADStyleNavigationBar *)self.navigationBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

@end
