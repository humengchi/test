//
//  ADVehicleSafeSettingViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADVehiclesModel.h"

@interface ADVehicleSafeSettingViewController : ADBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) ADVehiclesModel *vehiclesModel;

@end
