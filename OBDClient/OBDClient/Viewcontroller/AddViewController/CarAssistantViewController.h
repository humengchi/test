//
//  CarAssistantViewController.h
//  V3ViewController
//
//  Created by hys on 11/9/13.
//  Copyright (c) 2013年 hys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherViewController.h"
#import "PeripheralViewController.h"
#import "LatestInformationViewController.h"

#import "ADChatTabBarViewController.h"

#import "MessageViewController.h"
#import "ADCalendarModel.h"
#import "IVToastHUD.h"
#import "ADVehiclesModel.h"
#import "ADRemindModel.h"
#import "ADUserLocationSettingViewController.h"
#import "ADLocationViewController.h"
#import "ADSummaryViewController.h"
#import "SpeedDialViewController.h"
#import "ADOilPriceModel.h"
#import "ADReserveViewController.h"
#import "ADLimitLineModel.h"
#import "ADWebNewsViewController.h"

#import "ADDetailVehicleConditionViewController.h"
#import "ADVehicleConditionDetailViewController.h"

#import "ADGetMessageGroupModel.h"
#import "ADWarnListViewController.h"
#import "ADWarnDetailViewController.h"
#import "ADGetNewsModel.h"
#import "ADSummaryFinalViewController.h"
#include "ADDefine.h"

#import <QuartzCore/QuartzCore.h>

extern NSString* const ADWeatherDataNotification;
extern NSString* const ADSendToWeatherCurrentSelectedCityNotification;
extern NSString* const ADGetNewsIDNotification;
extern NSString* const ADDetailVehicleConditionResultNotification;

@interface CarAssistantViewController : ADMenuBaseViewController<ADCalendarWeatherDelegate,ADRemindDelegate,UIScrollViewDelegate,ADOilPriceDelegate,ADLimitLineDelegate,UITableViewDelegate,UITableViewDataSource,ADGetMessageGroupDelegate,ADGetNewsDelegate,UIWebViewDelegate>
{
    ADGetMessageGroupModel* GetMessageGroupModel;
}

@property (nonatomic) ADVehiclesModel *vehiclesModel;

@property(strong,nonatomic)ADRemindModel* dailyReminderModel;

@property(strong,nonatomic)ADLimitLineModel* limitLineModel;

@property(strong,nonatomic)ADGetMessageGroupModel* GetMessageGroupModel;

@property(strong,nonatomic)ADGetNewsModel* getNewsModel;

@property(strong,nonatomic)UIButton* carAssistantButton;

@property(strong,nonatomic)UITableView* dailyReminderTableView;

@property(strong,nonatomic)NSArray* remindArray;

@property(strong,nonatomic)UIView* calendarView;

//@property(strong,nonatomic)UIView* oilPriceView;

@property(strong,nonatomic)UILabel* dayOliPriceLabel;

@property(strong,nonatomic)UILabel* currentCityLabel;

@property(strong,nonatomic)UILabel* washLabel;

@property(strong,nonatomic)UILabel* limtLabel;

@property(strong,nonatomic)UIImageView* todayImgView;

@property(strong,nonatomic)UIImageView* tomorrowImgView;

@property(strong,nonatomic)UIImageView* afterImgView;

@property(strong,nonatomic)UILabel* todayTemperatureLabel;

@property(strong,nonatomic)UILabel* tomorrowTemperatureLabel;

@property(strong,nonatomic)UILabel* afterTemperatureLabel;

@property(strong,nonatomic)NSString* todayString;

@property(strong,nonatomic)NSString* tomorrowString;

@property(strong,nonatomic)NSString* afterString;

@property(strong,nonatomic)UIScrollView* scroll;

@property(strong,nonatomic)UIPageControl* pageController;

//@property(strong,nonatomic)ADNetWorkingManager* netWorkingManager;

@property(strong,nonatomic)ADOilPriceModel* oilPriceModel;

@property(strong,nonatomic)ADCalendarModel* CalendarModel;

@property(strong,nonatomic)NSString* currentSelectedCity;

@property(nonatomic)UILabel *label1;

@property(strong,nonatomic)UILabel* label2;

@property(strong,nonatomic)UILabel* label3;

@property(strong,nonatomic)UILabel* label4;

@property(strong,nonatomic)UILabel* label5;

@property(strong,nonatomic)UILabel* label6;

@property(strong,nonatomic)UILabel* label7;

@property(strong,nonatomic)UILabel* label8;

@property(strong,nonatomic)UILabel* label9;

@property(strong,nonatomic)NSString* totalPoints;

@property(strong,nonatomic)UILabel* scoreLabel;

@property(strong,nonatomic)NSArray* transmitDictionary;// NSDictionary* transmitDictionary;

@property(strong,nonatomic)UIImageView* ballImgView;

@property(strong,nonatomic)UIImageView* arcImgView;

@property(strong,nonatomic)UIScrollView* vehicleConditionScrollView;

@property(strong,nonatomic)UIButton* detectButton;

@property(strong,nonatomic)UIButton* vehicleConditionBtn;

@property(strong,nonatomic)NSArray* sendToDetailArray;

@property(strong,nonatomic)NSTimer* myTimer;

@property(strong,nonatomic)UIImageView* chachaImgView;

@property(strong,nonatomic)UIImageView* dialogboxImgView;

@property(strong,nonatomic)UIImageView* dialogboxImgView_receiveNews;  //接收到新的消息  redpoint.png

@property(strong,nonatomic)UIWebView* webViewOne;

@property(strong,nonatomic)UIWebView* webViewTwo;

@property(strong,nonatomic)UIWebView* webViewThree;

@property(strong,nonatomic)NSArray* newsDataArray;

@property(strong,nonatomic)UIButton* calendarButton;

@property(nonatomic)int flag;

@property(strong,nonatomic)UIView* checkingView; //正在查询时，添加view阻止用户点击其它按钮

@property(nonatomic,assign)NSInteger isCarAssistantView;


@end
