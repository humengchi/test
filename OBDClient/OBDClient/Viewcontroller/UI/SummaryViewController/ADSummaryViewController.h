//
//  ADSummaryViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//
#import "ADDTCBase.h"
#import "ADDTCsModel.h"
#import "ADGaugeView.h"
#import <BaiduMapAPI/BMapKit.h>

#import "ADHistoryPoint.h"
#import "ADHistoryModel.h"

#import "ADAlertCell.h"
#import "ADDTCCell.h"

#import <QuartzCore/QuartzCore.h>
#import "CarAssistantViewController.h"
#import "ADDevicesModel.h"



@interface ADSummaryViewController : ADMenuBaseViewController<BMKMapViewDelegate, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>
{
    ADGaugeView *_oilGaugeView;
    ADGaugeView *_batteryView;
    IBOutlet BMKMapView *_mapView;
    CLLocationManager *_locationManager;
    UIButton *_buttonMileage;
    UIButton *_buttonIgn;
    UILabel *_locationLabel;
    
    ADDTCsModel *_dtcsModel;
    ADHistoryModel *_historyModel;
    ADDevicesModel *_devicesModel;
    UITableView *_tableViewOfAlerts;
    UITableView *_tableViewOfDTCs;
}

@property(strong,nonatomic)UIView* editMileageView;

@property(strong,nonatomic)UITextField* mileageTextField;

@end
