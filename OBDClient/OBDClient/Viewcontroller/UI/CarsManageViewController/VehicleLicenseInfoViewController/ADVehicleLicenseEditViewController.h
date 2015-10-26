//
//  ADVehicleLicenseEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ADMenuBaseViewController.h"
@class ADVehicleLicenseEditViewController;
@protocol ADEditVehicleInfoDelegate <NSObject>

- (void) editContactViewController:(ADVehicleLicenseEditViewController *) vehicleLicenseEditViewController didEditContact:(NSArray * ) contact;

@end

@interface ADVehicleLicenseEditViewController :ADBaseViewController<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) id<ADEditVehicleInfoDelegate> delegate;

@end
