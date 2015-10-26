//
//  SpeedDialViewController.h
//  OBDClient
//
//  Created by hys on 30/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeedDialCell.h"
#import "ADSingletonUtil.h"

#include "ADDefine.h"

#import "ADVehiclesModel.h"

@interface SpeedDialViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, SpeedDialCellDelegate>

@property(strong,nonatomic)UITableView* speedDialTableView;

@property (nonatomic) ADVehiclesModel *vehiclesModel;

@end
