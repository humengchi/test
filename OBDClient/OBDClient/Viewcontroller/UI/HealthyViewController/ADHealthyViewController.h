//
//  ADHealthyViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "ADMaintainModel.h"
#import "ADMaintainPlanViewController.h"

@interface ADHealthyViewController :ADMenuBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) ADMaintainModel * maintainModel;
- (void)updateUI;
@end
