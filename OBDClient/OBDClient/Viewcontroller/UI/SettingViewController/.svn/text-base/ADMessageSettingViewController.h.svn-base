//
//  ADMessageSettingViewController.h
//  OBDClient
//
//  Created by hys on 10/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSettingItemViewController.h"
#import "ADGetMessageNotifactionSwitchModel.h"
#import "ADSetMessageNotifactionSwitchModel.h"
#import "ADSingletonUtil.h"
#import "NotificationStatusCell.h"
#import "ADBaseViewController.h"

@interface ADMessageSettingViewController : ADBaseViewController<ADGetMessageNotifactionSwitchDelegate,ADSetMessageNotifactionSwitchDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)ADGetMessageNotifactionSwitchModel* getMessageNotifactionSwitchModel;

@property(strong,nonatomic)ADSetMessageNotifactionSwitchModel* setMessageNotifactionSwitchModel;

@property(strong,nonatomic)UITableView* statusTableView;

@property(strong,nonatomic)NSMutableArray* dataArray;

@property(strong,nonatomic)NSMutableArray* statusArray;

@end
