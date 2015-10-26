//
//  ADGeofenceViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-9.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADGeofenceCell.h"
#import "ADGeofenceModel.h"
#import "ADSingletonUtil.h"
#import "ADDeviceBase.h"
#import "IVToastHUD.h"
#import "ADGeofenceUpdateViewController.h"
#import "ADMenuBaseViewController.h"


@interface ADGeofenceViewController :ADMenuBaseViewController  <UITableViewDelegate, UITableViewDataSource>
{
    ADGeofenceModel *_geofenceModel;
    ADDeviceBase *_deviceBase;
}

@property(strong,nonatomic)UITableView* tableView;


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
           deviceBase:(ADDeviceBase *)aDeviceBase;

@end
