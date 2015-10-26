//
//  ADVehicleSellInfoViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADVehiclesModel.h"

@interface ADVehicleSellInfoViewController : ADBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong, readonly) ADVehiclesModel *vehiclesModel;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataItems;
@end
