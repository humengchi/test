//
//  ADVehicleSettingConfigEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"

@class ADVehicleSettingConfigEditViewController;
@protocol ADEditVehicleSettingConfigDelegate <NSObject>

- (void) editContactViewController:(ADVehicleSettingConfigEditViewController *) vehicleSettingConfigEditViewController didEditContact:(NSArray * ) contact;

@end

@interface ADVehicleSettingConfigEditViewController : ADMenuBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) id<ADEditVehicleSettingConfigDelegate> delegate;

@property (nonatomic) NSArray *settingConfigItems;
@property (nonatomic) NSMutableArray *settingConfigItemsDefaultValues;

@end
