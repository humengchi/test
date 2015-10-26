//
//  ADVehiclePidInfoViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-11.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "ADVehiclePidInfoCell.h"
#import "ADiPhoneLoginViewController.h"

@interface ADVehiclePidInfoViewController : ADMenuBaseViewController<UITableViewDataSource,UITableViewDelegate>

@property(strong,nonatomic)NSMutableArray* heightArray;

@end
