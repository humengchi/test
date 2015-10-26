//
//  ADAuthManageViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehiclesModel.h"
#import "ADBaseViewController.h"

@interface ADAuthManageViewController : ADBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) ADVehiclesModel *vehiclesModel;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *itemDatas;

@end
