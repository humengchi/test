//
//  ADHistoryFinalViewController.h
//  OBDClient
//
//  Created by hys on 6/3/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "UIUtil.h"
#import "ADHistoryModel.h"
#import "ADHistoryCell.h"
#import "ADHistroyMapViewController.h"

#include "ADDefine.h"
#define TAG_BUTTON_MILEAGE                       65200

#import "ADRecentHistroyViewController.h"

@interface ADHistoryFinalViewController : ADMenuBaseViewController<UITableViewDelegate,UITableViewDataSource, ADRecentHistroyDelegate>

@property(strong,nonatomic)UITableView* tableView;

@property(strong,nonatomic)NSArray* dataSource;

@property(strong,nonatomic)ADHistoryModel* historyModel;

@property(strong,nonatomic)UIButton* buttonMileage;

@property(strong,nonatomic)UIView* viewOfUpdateInfo;

@property(strong,nonatomic)NSDate* currentDate;

@property(strong,nonatomic)UIView* viewOfBottom;

@property(strong,nonatomic)UILabel* timeLabel;

@property(nonatomic)NSInteger year;

@property(nonatomic)NSInteger month;

@property(nonatomic)NSInteger day;

@property(strong,nonatomic)NSDateFormatter* formatter;

@property(strong,nonatomic)UIDatePicker* datePicker;

@property(strong,nonatomic)UIView* dateView;




- (void)updateUIByDataSource:(NSArray *)aDataSource;

@end
