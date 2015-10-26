//
//  ADHealthyHistoryViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-16.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "ADMaintainModel.h"

@interface ADHealthyHistoryViewController : ADMenuBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) ADMaintainModel * maintainModel;
@property (nonatomic) UITableView *tableView;
@end
