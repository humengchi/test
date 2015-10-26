//
//  ADMoreInfoViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-29.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADVehiclesModel.h"
#import "ADMoreInfoCell.h"
#import "ADPIDModel.h"
#import "ADiPhoneLoginViewController.h"

#define KVO_CURRENT_PID_PATH_NAME       @"pids"

@interface ADMoreInfoViewController : ADBaseViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)ADVehiclesModel* vehiclesModel;

@property(strong,nonatomic)ADPIDModel* pidModel;

@property(strong,nonatomic)NSArray* statusDeatailArray;

@property(strong,nonatomic)NSMutableArray* obdArray;

@property(strong,nonatomic)UITableView* vehicleStatusTableView;
@end
