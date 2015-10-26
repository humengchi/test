//
//  ADGreenDriveGraphicViewController.h
//  OBDClient
//
//  Created by hys on 8/8/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADCountCenterModel.h"
#import "ADSingletonUtil.h"

#include "ADDefine.h"
#import "PNLineChartView.h"
#import "PNPlot.h"
#import "IVToastHUD.h"

@interface ADGreenDriveGraphicViewController : UIViewController<ADCountCenterDeleagte>

@property(strong,nonatomic)NSDateComponents* component;

@property(strong,nonatomic)NSCalendar* cal;

@property(strong,nonatomic)NSString* currentShowDateStr;

@property(strong,nonatomic)NSDate* currentShowDate;

@property(strong,nonatomic)NSDateFormatter* formatter;

@property(strong,nonatomic)UILabel* showCalendarLabel;



@property(strong,nonatomic)ADCountCenterModel* countCenterModel;

@property(strong,nonatomic)UIImageView* scoreImgView;

@property(strong,nonatomic)UILabel* scoreLabel;

@property(strong,nonatomic)UILabel* averageLabel;

@property (strong, nonatomic) IBOutlet PNLineChartView *lineChartView;

@property (strong, nonatomic) UIButton *currentSelectedBtn;

@property (strong, nonatomic) IBOutlet UIView *btnsView;

@property (strong, nonatomic) NSMutableDictionary *resultDict;

@property (strong, nonatomic) IBOutlet UIImageView *graphicColorImage;

@end
