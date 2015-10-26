//
//  ADAlertViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHistoryModel.h"
#include "ADDefine.h"
#import "ADAlertCell.h"
#import "NSDate+Helper.h"
#import "ADDevicesModel.h"
#import "IVToastHUD.h"
#import "ADBaseViewController.h"
#import "ADiPhoneLoginViewController.h"


@interface ADAlertViewController : ADBaseViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    ADHistoryModel *_historyModel;
    UIView *_infoView;
}

@property (nonatomic) ADDevicesModel *devicesModel;

@end
