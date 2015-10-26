//
//  ADVehicleLicenseInfoViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBaseViewController.h"
#import "ADVehiclesModel.h"
@interface ADVehicleLicenseInfoViewController : ADBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, readonly) ADVehiclesModel *vehiclesModel;
@end
