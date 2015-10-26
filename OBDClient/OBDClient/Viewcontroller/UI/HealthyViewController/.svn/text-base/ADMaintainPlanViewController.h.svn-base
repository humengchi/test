//
//  ADMaintainPlanViewController.h
//  OBDClient
//
//  Created by hys on 5/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADGetMaintainListModel.h"
#import "ADSingletonUtil.h"
#import "IVToastHUD.h"

#include "ADDefine.h"

@interface ADMaintainPlanViewController : UIViewController<ADGetMaintainListDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property(strong,nonatomic)ADGetMaintainListModel* getMaintainListModel;

@property(strong,nonatomic)NSArray* maintainListArray;

@property(strong,nonatomic)NSArray* maintainItemsArray;

@property(nonatomic)int maintainListNum;

@property(nonatomic)int maintainItemsNum;

@property(strong,nonatomic)UIScrollView* leftScrollView;

@property(strong,nonatomic)UIScrollView* rightScrollView;

@property(strong,nonatomic)UITableView* leftTableView;

@property(strong,nonatomic)UITableView* rightTableView;

@end
