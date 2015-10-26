//
//  ADSummaryFinalViewController.h
//  OBDClient
//
//  Created by hys on 7/1/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "ADDTCBase.h"
#import "ADDTCsModel.h"
#import "ADGaugeView.h"
#import "ADHistoryPoint.h"
#import "ADHistoryModel.h"

#import <QuartzCore/QuartzCore.h>
#import "CarAssistantViewController.h"

#import "ADSingletonUtil.h"

#import "ADDevicesModel.h"
#import "ADVehiclesModel.h"
#import "ADLocationViewController.h"
#import "ADSummaryModel.h"

#define KVO_DEVICE_DETAIL_PATH_NAME     @"deviceDetail"
#define KVO_VEHICLE_SETTING_CONFIG_PATH_NAME    @"vehicleSettingConfig"
#define KVO_ALERT_PATH_NAME                @"alerts"
#define KVO_DTCS_PATH_NAME              @"dtcs"

@interface ADSummaryFinalViewController : ADMenuBaseViewController<ADSummaryDelegate,UITextFieldDelegate>{
    int alertNum;
    int dtcNum;
    int locNum;
    int newsNum;
    NSTimer *myTimer;
    
}
@property(strong,nonatomic) NSMutableDictionary *theResultDict;

@property(strong,nonatomic)ADGaugeView* summaryView;

@property(strong,nonatomic)ADDevicesModel* devicesModel;

@property(strong,nonatomic)ADVehiclesModel* vehiclesModel;

@property(strong,nonatomic)ADHistoryModel* historyModel;

@property(strong,nonatomic)ADSummaryModel* summaryModel;

@property(strong,nonatomic)ADDTCsModel* dtcsModel;

@property(strong,nonatomic)UIButton* buttonMileage;

@property(strong,nonatomic)UILabel* labelOfDate;

@property(strong,nonatomic)UIImageView* obdImgView;

@property(strong,nonatomic)UIImageView* dtcImgView;

@property(strong,nonatomic)UIImageView* oilImgView;

@property(strong,nonatomic)UIImageView* temperatureImgView;

@property(strong,nonatomic)UIImageView* engineImgView;

@property(strong,nonatomic)UIImageView* RMPImgView;

@property(strong,nonatomic)UIImageView* batteryImgView;

@property(strong,nonatomic)UILabel* RMPLabel;

@property(strong,nonatomic)UILabel* batteryLabel;

@property(strong,nonatomic)UIColor* blueColor;

@property(strong,nonatomic)UIColor* redColor;

@property(nonatomic)float oilNum;

@property(nonatomic)float tempNum;

@property(nonatomic)float RMPNum;

@property(nonatomic)float batteryNum;

@property(nonatomic)BOOL bol;

@property(strong,nonatomic)UIButton* selectBtn;

@property(strong,nonatomic)UILabel* currentLabel;

@property(strong,nonatomic)UILabel* lab1;

@property(strong,nonatomic)UILabel* lab2;

@property(strong,nonatomic)UILabel* lab3;

@property(strong,nonatomic)UILabel* lab4;

@property(strong,nonatomic)UILabel* lab5;

@property(strong,nonatomic)UILabel* lab6;

@property(strong,nonatomic)UILabel* lab7;

@property(strong,nonatomic)UILabel* lab8;

@property(strong,nonatomic)UIView* editMileageView;

@property(strong,nonatomic)UITextField* mileageTextField;

@end
