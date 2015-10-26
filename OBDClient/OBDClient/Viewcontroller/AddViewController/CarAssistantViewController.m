//
//  CarAssistantViewController.m
//  V3ViewController
//
//  Created by hys on 11/9/13.
//  Copyright (c) 2013年 hys. All rights reserved.
//

#import "CarAssistantViewController.h"

#import "ADUserManageViewController.h"

#import "ADAppDelegate.h"


extern NSString* const ADWeatherDataNotification = @"ADWeatherDataNotification";
extern NSString* const ADSendToWeatherCurrentSelectedCityNotification = @"ADSendToWeatherCurrentSelectedCityNotification";
extern NSString* const ADGetNewsIDNotification   = @"ADGetNewsIDNotification";
extern NSString* const ADDetailVehicleConditionResultNotification =@"ADDetailVehicleConditionResultNotification";

#define degreesToRadians(x) (M_PI*(x)/180.0)


@interface CarAssistantViewController ()
{
    ADDevicesModel *devicesModel;
}

@end

@implementation CarAssistantViewController
@synthesize isCarAssistantView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        
//        _netWorkingManager=[ADNetWorkingManager sharedManager];
        
        _oilPriceModel=[[ADOilPriceModel alloc]init];
        
        _CalendarModel=[[ADCalendarModel alloc]init];
        
        _dailyReminderModel=[[ADRemindModel alloc]init];
        
        _limitLineModel=[[ADLimitLineModel alloc]init];
        
        _GetMessageGroupModel=[[ADGetMessageGroupModel alloc]init];
        
        _getNewsModel=[[ADGetNewsModel alloc]init];
        
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VCEHICLE_DETECTION_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VCEHICLE_DETECTION_INDEED_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestVehicleDetectionFail:)
                                                     name:ADVehiclesModelrequestVehicleDetectionFailNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateUnreadNotification:) name:ADWarnListReadFlagNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateUnreadNotification:) name:ADWarnDetailReadFlagNotification object:nil];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleGetVehicleConditionTimeOut:) name:ADVehiclesModelGetConditionTimeOutNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeCitySuccess:)
                                                     name:ADSendToCarAssistantCurrentSelectedCityNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVehicleConditionNotification:) name:ADDetailVehicleConditionToCarNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(isCarAssistantViewController) name:@"isCarAssistantView" object:nil];
    }
    return self;
}
- (void)isCarAssistantViewController
{
    isCarAssistantView = 1;
}
//- (void)viewWillDisappear:(BOOL)animated{
//    _CalendarModel.weatherDelegate=nil;
//    _netWorkingManager.netDelegate=nil;
//    _dailyReminderModel.remindDelegate=nil;
//}
- (void)viewDidAppear:(BOOL)animated{
    if (_flag==1) {
        [_arcImgView setHidden:NO];
        CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        animation.toValue=[NSNumber numberWithFloat:degreesToRadians(12000)];
        animation.duration=70.0f;
        animation.cumulative=YES;
        [_arcImgView.layer addAnimation:animation forKey:nil];
    }
}
- (void)dealloc{
    
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VCEHICLE_DETECTION_PATH_NAME];
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VCEHICLE_DETECTION_INDEED_PATH_NAME];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:ADCalendarModelRequestDataErrorNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:ADCalendarModelRequestFailNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:ADCalendarModelRequestSuccessNotification
//                                                  object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:ADCalendarModelRequestTimeoutNotification
//                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"isCarAssistantView"
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADVehiclesModelrequestVehicleDetectionFailNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADVehiclesModelGetConditionTimeOutNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"GETNEWINFO_ALLNUMBER"
                                                  object:nil];
    
    
    [_vehiclesModel cancel];
    
    [_CalendarModel cancel];
    
    [_oilPriceModel cancel];
    
    [_limitLineModel cancel];
}

- (void)showAlert
{
//    [IVToastHUD showAsToastErrorWithStatus:@"正在检测中....."];
}

- (void)viewDidDisappear:(BOOL)animated
{
//    isCarAssistantView = 0;
//    [_myTimer setFireDate:[NSDate distantFuture]];
//    [_myTimer invalidate];
//    [_myTimer invalidate];
//    _myTimer = nil;
}

- (void)upDateUI_main
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString* allNumberChats = [NSString stringWithFormat:@"%@_ALLNUMBERCHAT", [self xmppStream].myJID.user];
    if([userDefault objectForKey:allNumberChats]){
        if([[userDefault objectForKey:allNumberChats] integerValue] > 0){
            _dialogboxImgView_receiveNews.hidden = NO;
        }else if([[userDefault objectForKey:allNumberChats] integerValue] == 0){
            _dialogboxImgView_receiveNews.hidden = YES;
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self upDateUI_main];
}

#pragma mark -ADAppDelegate
-(ADAppDelegate *)appDelegate{
    return (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateUI_main) name:@"GETNEWINFO_ALLNUMBER" object:nil];
    
    isCarAssistantView = 1;
    _flag=0;
    self.title=NSLocalizedStringFromTable(@"carAssistantKey",@"MyString", @"");;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
	// Do any additional setup after loading the view.
    /********************************************************************************************/
    NSDate *  todayDate=[NSDate date];
    NSTimeInterval oneDay=24*60*60;
    
    NSCalendar* caltest=[NSCalendar currentCalendar];
    
    NSUInteger  unitFlagstest=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponenttest= [caltest components:unitFlagstest fromDate:todayDate];
    NSInteger yeartest=[conponenttest year];
    NSInteger monthtest=[conponenttest month];
    NSInteger daytest=[conponenttest day];

//    NSDateFormatter* dataformatter=[[NSDateFormatter alloc]init];
//    [dataformatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    [dataformatter setDateFormat:@"YYYYMMdd"];
    _todayString=[NSString stringWithFormat:@"%d%02d%02d",yeartest,monthtest,daytest];   //2013 12 28
    
    
    NSDate* tomorrowDate=[NSDate dateWithTimeIntervalSinceNow:oneDay];

    conponenttest= [caltest components:unitFlagstest fromDate:tomorrowDate];
    yeartest=[conponenttest year];
    monthtest=[conponenttest month];
    daytest=[conponenttest day];

    _tomorrowString=[NSString stringWithFormat:@"%d%02d%02d",yeartest,monthtest,daytest];
    
    NSDate* afterDate=[NSDate dateWithTimeIntervalSinceNow:oneDay*2];
    conponenttest=[caltest components:unitFlagstest fromDate:afterDate];
    yeartest=[conponenttest year];
    monthtest=[conponenttest month];
    daytest=[conponenttest day];
    _afterString=[NSString stringWithFormat:@"%d%02d%02d",yeartest,monthtest,daytest];
    
    NSCalendar* cal=[NSCalendar currentCalendar];
    
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:todayDate];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    
    conponent =[cal components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit) fromDate:todayDate];
    NSInteger weekday = [conponent weekday];
    
    
    
    _calendarView=[[UIView alloc]initWithFrame:CGRectMake(0, 1, WIDTH, 120)];
    UIImageView* calendarLayer=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, WIDTH-10, 110)];
    calendarLayer.image=[UIImage imageNamed:@"carassistantrect.png"];
    [_calendarView addSubview:calendarLayer];
    
    UIImageView* calendarImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 70, 103)];
    calendarImgView.image=[UIImage imageNamed:@"calendarlayer.png"];
    [_calendarView addSubview:calendarImgView];
    
    
    UILabel* monthLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 17, 70, 13)];
    switch (month) {
        case 1:
            monthLabel.text=NSLocalizedStringFromTable(@"JanuaryKey",@"MyString", @"");
            break;
        case 2:
            monthLabel.text=NSLocalizedStringFromTable(@"FebruaryKey",@"MyString", @"");
            break;
        case 3:
            monthLabel.text=NSLocalizedStringFromTable(@"MarchKey",@"MyString", @"");
            break;
        case 4:
            monthLabel.text=NSLocalizedStringFromTable(@"AprilKey",@"MyString", @"");
            break;
        case 5:
            monthLabel.text=NSLocalizedStringFromTable(@"MayKey",@"MyString", @"");
            break;
        case 6:
            monthLabel.text=NSLocalizedStringFromTable(@"JuneKey",@"MyString", @"");
            break;
        case 7:
            monthLabel.text=NSLocalizedStringFromTable(@"JulyKey",@"MyString", @"");
            break;
        case 8:
            monthLabel.text=NSLocalizedStringFromTable(@"AugustKey",@"MyString", @"");
            break;
        case 9:
            monthLabel.text=NSLocalizedStringFromTable(@"SeptemberKey",@"MyString", @"");
            break;
        case 10:
            monthLabel.text=NSLocalizedStringFromTable(@"OctoberKey",@"MyString", @"");
            break;
        case 11:
            monthLabel.text=NSLocalizedStringFromTable(@"NovemberKey",@"MyString", @"");
            break;
        case 12:
            monthLabel.text=NSLocalizedStringFromTable(@"DecemberKey",@"MyString", @"");
            break;

            
        default:
            break;
    }
    monthLabel.textAlignment=NSTextAlignmentCenter;
    monthLabel.textColor=[UIColor whiteColor];
    [monthLabel setFont:[UIFont systemFontOfSize:16]];
    [monthLabel setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:monthLabel];
    
    UILabel* dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 25, 70, 70)];
    dayLabel.text=[NSString stringWithFormat:@"%d",day];
    dayLabel.textAlignment=NSTextAlignmentCenter;
    dayLabel.textColor=[UIColor whiteColor];
    [dayLabel setFont:[UIFont systemFontOfSize:50]];
    [dayLabel setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:dayLabel];
    
    UILabel* weekDayLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, 93, 50, 10)];
    NSString* weekD=@"";
   
    if (weekday==1) {
        weekD=NSLocalizedStringFromTable(@"SundayKey",@"MyString", @"");
    }else if (weekday==2){
        weekD=NSLocalizedStringFromTable(@"MondayKey",@"MyString", @"");
    }else if (weekday==3){
        weekD=NSLocalizedStringFromTable(@"TuesdayKey",@"MyString", @"");
    }else if (weekday==4){
        weekD=NSLocalizedStringFromTable(@"WednesdayKey",@"MyString", @"");
    }else if (weekday==5){
        weekD=NSLocalizedStringFromTable(@"ThursdayKey",@"MyString", @"");
    }else if (weekday==6){
        weekD=NSLocalizedStringFromTable(@"FridayKey",@"MyString", @"");
    }else if (weekday==7){
        weekD=NSLocalizedStringFromTable(@"SaturdayKey",@"MyString", @"");
    }



    weekDayLabel.text=weekD;
    weekDayLabel.textAlignment=NSTextAlignmentCenter;
    weekDayLabel.textColor=[UIColor whiteColor];
    [weekDayLabel setFont:[UIFont systemFontOfSize:8]];
    [weekDayLabel setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:weekDayLabel];
    
 

    /********************************************************************************************/    
    
    
    _dayOliPriceLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 10, 160, 15)];
    [_dayOliPriceLabel setBackgroundColor:[UIColor clearColor]];
    [_dayOliPriceLabel setFont:[UIFont systemFontOfSize:10]];
    [_calendarView addSubview:_dayOliPriceLabel];
    
    _currentCityLabel=[[UILabel alloc]initWithFrame:CGRectMake(230, 10, 30, 15)];
    [_currentCityLabel setBackgroundColor:[UIColor clearColor]];
    [_currentCityLabel setFont:[UIFont systemFontOfSize:10]];
    _currentCityLabel.textColor=[UIColor whiteColor];
    [_calendarView addSubview:_currentCityLabel];
    
    
    
    _washLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 28, 110, 15)];
    [_washLabel setBackgroundColor:[UIColor clearColor]];
    [_washLabel setFont:[UIFont systemFontOfSize:10]];
    [_calendarView addSubview:_washLabel];
    
    _limtLabel=[[UILabel alloc]initWithFrame:CGRectMake(210, 28, 110, 15)];
    [_limtLabel setBackgroundColor:[UIColor clearColor]];
    [_limtLabel setFont:[UIFont systemFontOfSize:10]];
    [_calendarView addSubview:_limtLabel];
    
    
    _todayImgView=[[UIImageView alloc]initWithFrame:CGRectMake(90, 50, 40, 45)];
    [_calendarView addSubview:_todayImgView];
    
    UILabel* today=[[UILabel alloc]initWithFrame:CGRectMake(130, 80, 20, 15)];
    today.text=weekD;
    today.textColor=[UIColor whiteColor];
    today.textAlignment=NSTextAlignmentCenter;
    today.font=[UIFont systemFontOfSize:6];
    [today setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:today];
    
    _todayTemperatureLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 95, 60, 15)];
    _todayTemperatureLabel.numberOfLines=0;
    [_todayTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:_todayTemperatureLabel];
    
    _tomorrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(170, 50, 40, 45)];
    [_calendarView addSubview:_tomorrowImgView];
    
    UILabel* tomorrow=[[UILabel alloc]initWithFrame:CGRectMake(210, 80, 20, 15)];
    NSInteger tomorrowweekday=weekday+1;
    NSString* tomorrowweekD=@"";
    if (tomorrowweekday>7) {
        tomorrowweekday=tomorrowweekday-7;
    }
    if (tomorrowweekday==1) {
        tomorrowweekD=NSLocalizedStringFromTable(@"SundayKey",@"MyString", @"");
    }else if (tomorrowweekday==2){
        tomorrowweekD=NSLocalizedStringFromTable(@"MondayKey",@"MyString", @"");
    }else if (tomorrowweekday==3){
        tomorrowweekD=NSLocalizedStringFromTable(@"TuesdayKey",@"MyString", @"");
    }else if (tomorrowweekday==4){
        tomorrowweekD=NSLocalizedStringFromTable(@"WednesdayKey",@"MyString", @"");
    }else if (tomorrowweekday==5){
        tomorrowweekD=NSLocalizedStringFromTable(@"ThursdayKey",@"MyString", @"");
    }else if (tomorrowweekday==6){
        tomorrowweekD=NSLocalizedStringFromTable(@"FridayKey",@"MyString", @"");
    }else if (tomorrowweekday==7){
        tomorrowweekD=NSLocalizedStringFromTable(@"SaturdayKey",@"MyString", @"");
    }

    tomorrow.text=tomorrowweekD;
    tomorrow.textColor=[UIColor whiteColor];
    tomorrow.textAlignment=NSTextAlignmentCenter;
    tomorrow.font=[UIFont systemFontOfSize:6];
    [tomorrow setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:tomorrow];

    
    _tomorrowTemperatureLabel=[[UILabel alloc]initWithFrame:CGRectMake(170, 95, 60, 15)];
    _tomorrowTemperatureLabel.numberOfLines=0;
    [_tomorrowTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:_tomorrowTemperatureLabel];
    
    _afterImgView=[[UIImageView alloc]initWithFrame:CGRectMake(250, 50, 40, 45)];
    [_calendarView addSubview:_afterImgView];
    
    UILabel* after=[[UILabel alloc]initWithFrame:CGRectMake(290, 80, 20, 15)];
    NSInteger afterweekday=tomorrowweekday+1;
    NSString* afterweekD=@"";
    if (afterweekday>7) {
        afterweekday=afterweekday-7;
    }
    if (afterweekday==1) {
        afterweekD=NSLocalizedStringFromTable(@"SundayKey",@"MyString", @"");
    }else if (afterweekday==2){
        afterweekD=NSLocalizedStringFromTable(@"MondayKey",@"MyString", @"");
    }else if (afterweekday==3){
        afterweekD=NSLocalizedStringFromTable(@"TuesdayKey",@"MyString", @"");
    }else if (afterweekday==4){
        afterweekD=NSLocalizedStringFromTable(@"WednesdayKey",@"MyString", @"");
    }else if (afterweekday==5){
        afterweekD=NSLocalizedStringFromTable(@"ThursdayKey",@"MyString", @"");
    }else if (afterweekday==6){
        afterweekD=NSLocalizedStringFromTable(@"FridayKey",@"MyString", @"");
    }else if (afterweekday==7){
        afterweekD=NSLocalizedStringFromTable(@"SaturdayKey",@"MyString", @"");
    }
    

    after.text=afterweekD;
    after.textColor=[UIColor whiteColor];
    after.textAlignment=NSTextAlignmentCenter;
    after.font=[UIFont systemFontOfSize:6];
    [after setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:after];

    
    _afterTemperatureLabel=[[UILabel alloc]initWithFrame:CGRectMake(250, 95, 60, 15)];
    _afterTemperatureLabel.numberOfLines=0;
    [_afterTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    [_calendarView addSubview:_afterTemperatureLabel];
    
       
       
    
    
    /********************************************************************************************/    
    _calendarButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 44, WIDTH, 96)];
    [_calendarButton setBackgroundColor:[UIColor clearColor]];
    [_calendarButton addTarget:self action:@selector(calendarButton:) forControlEvents:UIControlEventTouchUpInside];
    [_calendarView addSubview:_calendarButton];
    [self.view addSubview:_calendarView];
    
    
    /********************************************************************************************/        
    
    
    
    /********************************************************************************************/    
    
    
   
    
    
    UIButton* locationButton=[[UIButton alloc]initWithFrame:CGRectMake(4, 255, 52, 65)];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"locationnormal.png"] forState:UIControlStateNormal];
    [locationButton setBackgroundImage:[UIImage imageNamed:@"locationpress.png"] forState:UIControlStateHighlighted];
    [locationButton addTarget:self action:@selector(locationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:locationButton];
    
    UILabel* locationLabel=[[UILabel alloc]initWithFrame:CGRectMake(4, 288, 52, 15)];
    locationLabel.text=NSLocalizedStringFromTable(@"locationKey",@"MyString", @"");
    locationLabel.font=[UIFont systemFontOfSize:10];
    locationLabel.textAlignment=NSTextAlignmentCenter;
    locationLabel.textColor=[UIColor whiteColor];
    [locationLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:locationLabel];
    
    
    
    UIButton* summaryButton=[[UIButton alloc]initWithFrame:CGRectMake(56, 255, 52, 65)];
    [summaryButton setBackgroundImage:[UIImage imageNamed:@"summarynormal.png"] forState:UIControlStateNormal];
    [summaryButton setBackgroundImage:[UIImage imageNamed:@"summarypress.png"] forState:UIControlStateHighlighted];
    [summaryButton addTarget:self action:@selector(summaryButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:summaryButton];
    
    UILabel* summaryLabel=[[UILabel alloc]initWithFrame:CGRectMake(56, 288, 52, 15)];
    summaryLabel.text=NSLocalizedStringFromTable(@"summaryKey",@"MyString", @"");
    summaryLabel.font=[UIFont systemFontOfSize:10];
    summaryLabel.textAlignment=NSTextAlignmentCenter;
    summaryLabel.textColor=[UIColor whiteColor];
    [summaryLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:summaryLabel];
    
    
   

        
    UIButton* messageButton=[[UIButton alloc]initWithFrame:CGRectMake(108, 255, 52, 65)];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"messagenormal.png"] forState:UIControlStateNormal];
    [messageButton setBackgroundImage:[UIImage imageNamed:@"messagepress.png"] forState:UIControlStateHighlighted];
    [messageButton addTarget:self action:@selector(messageButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:messageButton];
    
    UILabel* messageLabel=[[UILabel alloc]initWithFrame:CGRectMake(108, 288, 52, 15)];
    messageLabel.text=NSLocalizedStringFromTable(@"messageKey",@"MyString", @"");
    messageLabel.font=[UIFont systemFontOfSize:10];
    messageLabel.textAlignment=NSTextAlignmentCenter;
    messageLabel.textColor=[UIColor whiteColor];
    [messageLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:messageLabel];
    
    

    
    
    UIButton* informationButton=[[UIButton alloc]initWithFrame:CGRectMake(160, 255, 52, 65)];
    [informationButton setBackgroundImage:[UIImage imageNamed:@"informationnormal.png"] forState:UIControlStateNormal];
    [informationButton setBackgroundImage:[UIImage imageNamed:@"informationpress.png"] forState:UIControlStateHighlighted];
    [informationButton addTarget:self action:@selector(informationButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:informationButton];
    
    UILabel* informationLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 288, 52, 15)];
#ifndef HMC
    informationLabel.text=NSLocalizedStringFromTable(@"informationKey",@"MyString", @"");
#else
    informationLabel.text = @"车友";
#endif
    informationLabel.font=[UIFont systemFontOfSize:10];
    informationLabel.textAlignment=NSTextAlignmentCenter;
    informationLabel.textColor=[UIColor whiteColor];
    [informationLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:informationLabel];
    
    
    
    
    
    UIButton* speeddialButton=[[UIButton alloc]initWithFrame:CGRectMake(212, 255, 52, 65)];
    [speeddialButton setBackgroundImage:[UIImage imageNamed:@"speeddialnormal.png"] forState:UIControlStateNormal];
    [speeddialButton setBackgroundImage:[UIImage imageNamed:@"speeddialpress.png"] forState:UIControlStateHighlighted];
    [speeddialButton addTarget:self action:@selector(rescueButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:speeddialButton];

    UILabel* speeddialLabel=[[UILabel alloc]initWithFrame:CGRectMake(212, 288, 52, 15)];
    speeddialLabel.text=NSLocalizedStringFromTable(@"speedDialKey",@"MyString", @"");
    speeddialLabel.font=[UIFont systemFontOfSize:10];
    speeddialLabel.textAlignment=NSTextAlignmentCenter;
    speeddialLabel.textColor=[UIColor whiteColor];
    [speeddialLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:speeddialLabel];
    
    

    
    UIButton* reserveButton=[[UIButton alloc]initWithFrame:CGRectMake(264, 255, 52, 65)];
    [reserveButton setBackgroundImage:[UIImage imageNamed:@"rescuenormal.png"] forState:UIControlStateNormal];
    [reserveButton setBackgroundImage:[UIImage imageNamed:@"rescuepress.png"] forState:UIControlStateHighlighted];
    [reserveButton addTarget:self action:@selector(reserveButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reserveButton];

    UILabel* reserveLabel=[[UILabel alloc]initWithFrame:CGRectMake(264, 288, 52, 15)];
    reserveLabel.text=NSLocalizedStringFromTable(@"reserveKey",@"MyString", @"");
    reserveLabel.font=[UIFont systemFontOfSize:10];
    reserveLabel.textAlignment=NSTextAlignmentCenter;
    reserveLabel.textColor=[UIColor whiteColor];
    [reserveLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:reserveLabel];
    
    
    //车况检测
    UIImageView* bottomImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 310, WIDTH-10, 95)];
    bottomImgView.image=[UIImage imageNamed:@"bottomrect.png"];
    [self.view addSubview:bottomImgView];
    
    
    _vehicleConditionScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(5, 315, 185, 70)];
    _vehicleConditionScrollView.contentSize=CGSizeMake(185, 210);
    
    _vehicleConditionScrollView.showsHorizontalScrollIndicator=NO;
    _vehicleConditionScrollView.showsVerticalScrollIndicator=NO;
    _vehicleConditionScrollView.pagingEnabled=YES;
    _vehicleConditionScrollView.scrollEnabled=YES;
    _vehicleConditionScrollView.delegate=self;
    
    _label1=[[UILabel alloc]initWithFrame:CGRectMake(5, 0, 160, 20)];
    _label2=[[UILabel alloc]initWithFrame:CGRectMake(5, 25, 160, 20)];
    _label3=[[UILabel alloc]initWithFrame:CGRectMake(5, 50, 160, 20)];
    _label4=[[UILabel alloc]initWithFrame:CGRectMake(5, 70, 160, 20)];
    _label5=[[UILabel alloc]initWithFrame:CGRectMake(5, 95, 160, 20)];
    _label6=[[UILabel alloc]initWithFrame:CGRectMake(5, 120, 160, 20)];
    _label7=[[UILabel alloc]initWithFrame:CGRectMake(5, 140, 160, 20)];
    _label8=[[UILabel alloc]initWithFrame:CGRectMake(5, 165, 160, 20)];
    _label9=[[UILabel alloc]initWithFrame:CGRectMake(5, 190, 160, 20)];
    
    _label1.text=[NSString stringWithFormat:@"%@: %@%@",NSLocalizedStringFromTable(@"conditionIndexKey",@"MyString", @""),[ADSingletonUtil sharedInstance].currentDeviceBase.vehicleIndex,NSLocalizedStringFromTable(@"markKey",@"MyString", @"")];

    NSDateFormatter* dataformatterT=[[NSDateFormatter alloc]init];
    [dataformatterT setDateFormat:@"YYYY.MM.dd"];
    NSString* time=[dataformatterT stringFromDate:todayDate];
    _label2.text=[NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"updateTimeKey",@"MyString", @""),time];

    _label3.text=@"";
    _label4.text=@"";
    _label5.text=@"";
    _label6.text=@"";
    _label7.text=@"";
    _label8.text=@"";
    _label9.text=@"";

    _label1.textColor=[UIColor whiteColor];
    _label2.textColor=[UIColor whiteColor];
    _label3.textColor=[UIColor whiteColor];
    _label4.textColor=[UIColor whiteColor];
    _label5.textColor=[UIColor whiteColor];
    _label6.textColor=[UIColor whiteColor];
    _label7.textColor=[UIColor whiteColor];
    _label8.textColor=[UIColor whiteColor];
    _label9.textColor=[UIColor whiteColor];
    
    [_label1 setBackgroundColor:[UIColor clearColor]];
    [_label2 setBackgroundColor:[UIColor clearColor]];
    [_label3 setBackgroundColor:[UIColor clearColor]];
    [_label4 setBackgroundColor:[UIColor clearColor]];
    [_label5 setBackgroundColor:[UIColor clearColor]];
    [_label6 setBackgroundColor:[UIColor clearColor]];
    [_label7 setBackgroundColor:[UIColor clearColor]];
    [_label8 setBackgroundColor:[UIColor clearColor]];
    [_label9 setBackgroundColor:[UIColor clearColor]];
    
    
    _label1.font=[UIFont systemFontOfSize:12];
    _label2.font=[UIFont systemFontOfSize:12];
    _label3.font=[UIFont systemFontOfSize:12];
    _label4.font=[UIFont systemFontOfSize:12];
    _label5.font=[UIFont systemFontOfSize:12];
    _label6.font=[UIFont systemFontOfSize:12];
    _label7.font=[UIFont systemFontOfSize:12];
    _label8.font=[UIFont systemFontOfSize:12];
    _label9.font=[UIFont systemFontOfSize:12];
    
    [_vehicleConditionScrollView addSubview:_label1];
    [_vehicleConditionScrollView addSubview:_label2];
    [_vehicleConditionScrollView addSubview:_label3];
    [_vehicleConditionScrollView addSubview:_label4];
    [_vehicleConditionScrollView addSubview:_label5];
    [_vehicleConditionScrollView addSubview:_label6];
    [_vehicleConditionScrollView addSubview:_label7];
    [_vehicleConditionScrollView addSubview:_label8];
    [_vehicleConditionScrollView addSubview:_label9];
    
    [self.view addSubview:_vehicleConditionScrollView];
    
    _vehicleConditionBtn=[[UIButton alloc]initWithFrame:CGRectMake(5, 315, 185, 70)];
    [_vehicleConditionBtn setBackgroundColor:[UIColor clearColor]];
    [_vehicleConditionBtn addTarget:self action:@selector(vehicleConditionDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    [_vehicleConditionBtn setHidden:YES];
    [self.view addSubview:_vehicleConditionBtn];
    
   
    

    
    
    _ballImgView=[[UIImageView alloc]initWithFrame:CGRectMake(210, 315, 85, 85)];
    int i=[[ADSingletonUtil sharedInstance].currentDeviceBase.vehicleIndex intValue];
    if (i<60) {
        _ballImgView.image=[UIImage imageNamed:@"redball.png"];
    }else{
        _ballImgView.image=[UIImage imageNamed:@"main_circle_bg_scan.png"];
    }
    [self.view addSubview:_ballImgView];
    
    
    _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(210, 333, 85, 45)];
    _scoreLabel.text=[NSString stringWithFormat:@"%@%@",[ADSingletonUtil sharedInstance].currentDeviceBase.vehicleIndex,NSLocalizedStringFromTable(@"markKey",@"MyString", @"")];
    _scoreLabel.textColor=[UIColor whiteColor];
    _scoreLabel.textAlignment=NSTextAlignmentCenter;
//    [_scoreLabel setAlpha:0.35];
    [_scoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [_scoreLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_scoreLabel];
    
    
    
    //体检按钮
    _detectButton=[[UIButton alloc]initWithFrame:CGRectMake(210, 315, 90, 80)];
    _detectButton.backgroundColor=[UIColor clearColor];
    [_detectButton addTarget:self action:@selector(detectTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_detectButton];
    
    
    
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSLog(@"%@",[defaults objectForKey:@"city"]);
    if ([defaults objectForKey:@"city"]==nil) {
        _currentSelectedCity=[ADSingletonUtil sharedInstance].globalUserBase.organName;
    }else{
        _currentSelectedCity=[defaults objectForKey:@"city"];
    }
    
    _currentCityLabel.text=_currentSelectedCity;
    
    
    _dialogboxImgView=[[UIImageView alloc]initWithFrame:CGRectMake(148, 265, 9, 9)];
    _dialogboxImgView.image=[UIImage imageNamed:@"redpoint.png"];
    [_dialogboxImgView setHidden:YES];
    [self.view addSubview:_dialogboxImgView];
    
    
    //车友按钮右上角的红点
    _dialogboxImgView_receiveNews=[[UIImageView alloc]initWithFrame:CGRectMake(158, 265, 9, 9)];
    _dialogboxImgView_receiveNews.image=[UIImage imageNamed:@"redpoint.png"];
    [_dialogboxImgView_receiveNews setHidden:YES];
    [self.view addSubview:_dialogboxImgView_receiveNews];
    
    _arcImgView=[[UIImageView  alloc]initWithFrame:CGRectMake(208, 317, 85, 85)];
    _arcImgView.image=[UIImage imageNamed:@"leida.png"];
    [self.view addSubview:_arcImgView];
    [_arcImgView setHidden:YES];
    
    
    float width = (WIDTH-8)/6;
    [_calendarView setFrame:CGRectMake(0, 75, WIDTH, 123)];
    [locationButton setFrame:CGRectMake(4, 349, width, 65)];
    [locationLabel setFrame:CGRectMake(4, 382, width, 15)];
    [summaryButton setFrame:CGRectMake(4+width, 349, width, 65)];
    [summaryLabel setFrame:CGRectMake(4+width, 382, width, 15)];
    [messageButton setFrame:CGRectMake(4+width*2, 349, width, 65)];
    [messageLabel setFrame:CGRectMake(4+width*2, 382, width, 15)];
    [informationButton setFrame:CGRectMake(4+width*3, 349, width, 65)];
    [informationLabel setFrame:CGRectMake(4+width*3, 382, width, 15)];
    [speeddialButton setFrame:CGRectMake(4+width*4, 349, width, 65)];
    [speeddialLabel setFrame:CGRectMake(4+width*4, 382, width, 15)];
    [reserveButton setFrame:CGRectMake(4+width*5, 349, width, 65)];
    [reserveLabel setFrame:CGRectMake(4+width*5, 382, width, 15)];
    
    float start_y = reserveLabel.frame.origin.y+reserveLabel.frame.size.height+20;//HEIGHT-150
    [bottomImgView setFrame:CGRectMake(5, start_y-10, WIDTH-10, HEIGHT-start_y+10)];
    [_vehicleConditionScrollView setFrame:CGRectMake(5, start_y, 185, HEIGHT-start_y)];
    [_vehicleConditionBtn setFrame:CGRectMake(5, start_y, 185, 70)];
    [_ballImgView setFrame:CGRectMake(WIDTH-100, start_y, 85, 85)];
    [_scoreLabel setFrame:CGRectMake(WIDTH-100, start_y+18, 85, 45)];
    [_detectButton setFrame:CGRectMake(WIDTH-100, start_y, 90, 80)];//210
    [_dialogboxImgView setFrame:CGRectMake(14+width*2, start_y-57, 9, 9)];
    [_dialogboxImgView_receiveNews setFrame:CGRectMake(WIDTH-90, start_y-57, 9, 9)];
    [_arcImgView setFrame:CGRectMake(WIDTH-100, start_y+2, 85, 85)];


    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_CalendarModel startCallWithArguments:[NSArray arrayWithObjects:_currentSelectedCity,nil]];
    _CalendarModel.weatherDelegate=self;
    
//    [_netWorkingManager oilRequest];
//    _netWorkingManager.netDelegate=self;
    NSString* organID=[ADSingletonUtil sharedInstance].globalUserBase.organID;
    NSString* oilType=[ADSingletonUtil sharedInstance].currentDeviceBase.oilType;
    [_oilPriceModel startCallWithArguments:[NSArray arrayWithObjects:organID,oilType, nil]];
    _oilPriceModel.oilPriceDelegate=self;
    
    NSString* uid=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_dailyReminderModel startCallWithArguments:[NSArray arrayWithObjects:uid, nil]];
    _dailyReminderModel.remindDelegate=self;
    
    
    NSString* licenseNum=[ADSingletonUtil sharedInstance].currentDeviceBase.licenseNumber;
    [_limitLineModel startCallWithArguments:[NSArray arrayWithObjects:organID,licenseNum, nil]];
    _limitLineModel.limitLineDelegate=self;
    
    
    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_GetMessageGroupModel startCallWithArguments:[NSArray arrayWithObjects:uID, nil]];
    _GetMessageGroupModel.getMessageGroupDelegate=self;
    
    [_getNewsModel startRequestGetNewsWithArguments:[NSArray arrayWithObjects:@"3", nil]];
    _getNewsModel.getNewsDelegate=self;
    
//    NSLog(@"Retain count is %ld", CFGetRetainCount((__bridge CFTypeRef)self));
    
//    UISwipeGestureRecognizer *rightRecognizer=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
//    [rightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
//    [self.view addGestureRecognizer:rightRecognizer];
    
    _myTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(scrollScrollView:) userInfo:nil repeats:YES];
    [_myTimer setFireDate:[NSDate distantFuture]];
    
//hmc:修改界面
    
    UIButton *chooseVehicle = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseVehicle setFrame:CGRectMake(0, 0, 65, 23)];
    if([ADSingletonUtil sharedInstance].currentDeviceBase.licenseNumber){
        [chooseVehicle setTitle:[ADSingletonUtil sharedInstance].currentDeviceBase.licenseNumber
                   forState:UIControlStateNormal];
        chooseVehicle.titleLabel.font = [UIFont systemFontOfSize:13.0f];
//        chooseVehicle.backgroundColor = [UIColor colorWithRed:0.13 green:0.13 blue:0.13 alpha:0.5f];
//        [chooseVehicle.layer setCornerRadius:3.0f];
//        [chooseVehicle.layer setBorderWidth:0.5];
    }else{
        [chooseVehicle setImage:[UIImage imageNamed:@"setFriend.png"] forState:UIControlStateNormal];
    }
//    [chooseVehicle setImage:[UIImage imageNamed:@"setFriend.png"] forState:UIControlStateNormal];
    [chooseVehicle addTarget:self action:@selector(gotoChooseVehicleButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:chooseVehicle];
    self.navigationItem.rightBarButtonItem = right;
    
}
//hmc:修改界面 -- 进入选择车辆界面
- (IBAction)gotoChooseVehicleButtonPressed:(id)sender
{
    ADUserManageViewController *userManageVC = [[ADUserManageViewController alloc] init];
    [self.navigationController pushViewController:userManageVC animated:YES];
}

#pragma mark -Roll
- (void)scrollScrollView:(NSTimer *)timer{
    CGPoint newContentOffset=_vehicleConditionScrollView.contentOffset;
    newContentOffset.y+=70;
    [_vehicleConditionScrollView setContentOffset:newContentOffset];
    if (newContentOffset.y==140) {
        [_myTimer setFireDate:[NSDate distantFuture]];
        [_arcImgView.layer removeAllAnimations];
        [_arcImgView setHidden:YES];
       
        int i=[_totalPoints intValue];
        if (i<60) {
            _ballImgView.image=[UIImage imageNamed:@"redball.png"];
        }
        if ([_totalPoints isEqualToString:@""]) {
            _scoreLabel.text=NSLocalizedStringFromTable(@"checkTimeOutKey",@"MyString", @"");
        }else{
            _scoreLabel.text=[NSString stringWithFormat:@"%@%@",_totalPoints,NSLocalizedStringFromTable(@"markKey",@"MyString", @"")];
        }
        _checkingView.hidden = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        [_detectButton setHidden:NO];
        [_vehicleConditionBtn setHidden:NO];
        _flag=0;
    }
}

- (IBAction)detectTap:(id)sender{
    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
        return;
    }
    _flag=1;
    _checkingView.hidden = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    [_detectButton setHidden:YES];
    [_vehicleConditionBtn setHidden:YES];
    _ballImgView.image=[UIImage imageNamed:@"main_circle_bg_scan.png"];
    _scoreLabel.text=@"";

     CGPoint newContentOffset=_vehicleConditionScrollView.contentOffset;
    if (newContentOffset.y!=0) {
        newContentOffset.y-=140;
    }
    [_vehicleConditionScrollView setContentOffset:newContentOffset];
    [_arcImgView setHidden:NO];
    
    CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.toValue=[NSNumber numberWithFloat:degreesToRadians(12000)];
    animation.duration=70.0f;
    animation.cumulative=YES;
    animation.repeatCount=0;
    //在图片边缘添加一个像素的透明区域，去图片锯齿
    CGRect imageRrect = CGRectMake(0, 0,_arcImgView.frame.size.width, _arcImgView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
    [_arcImgView.image drawInRect:CGRectMake(1,1,_arcImgView.frame.size.width-2,_arcImgView.frame.size.height-2)];
    _arcImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //********************************
    
    [_arcImgView.layer addAnimation:animation forKey:nil];
    
    _label1.text=NSLocalizedStringFromTable(@"checkingKey",@"MyString", @"");
    _label2.text=@"";
    _label3.text=@"";
    
    [_vehiclesModel requestVehicleDetectionInfoWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];   //返回一个heartbeat_interval timestamp of now
}

//Key-Value Observing (简写为KVO)：当指定的对象的属性被修改了，允许对象接受到通知的机制。每次指定的被观察对象的属性被修改的时候，KVO都会自动的去通知相应的观察者。

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(isCarAssistantView == 1){
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VCEHICLE_DETECTION_PATH_NAME]) {
            NSDictionary *dic=_vehiclesModel.vehicleConditionCheck;
            NSString *timestamp = [dic objectForKey:@"now"];
            [_vehiclesModel requestVehicleDetectionIndeedWithArguments:[NSArray arrayWithObjects:
                                                                        timestamp,[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin, nil] continue:YES];
            return;
        }else if ([keyPath isEqualToString:KVO_VCEHICLE_DETECTION_INDEED_PATH_NAME]){
            _sendToDetailArray=(NSArray*)_vehiclesModel.vehicleConditionCheckResult;
            
            
            NSDictionary* enginePRMdic=[[_sendToDetailArray objectAtIndex:0] properties];
            NSString* enginePRM=[enginePRMdic objectForKey:@"factorName"];
            NSString* enginePRMresult=[enginePRMdic objectForKey:@"result"];
            
            NSDictionary* battleveldic=[[_sendToDetailArray objectAtIndex:1] properties];
            NSString* battlevel=[battleveldic objectForKey:@"factorName"];
            NSString* battleveldicresult=[battleveldic objectForKey:@"result"];
            
            NSDictionary* fuelleveldic=[[_sendToDetailArray objectAtIndex:2] properties];
            NSString* fuellevel=[fuelleveldic objectForKey:@"factorName"];
            NSString* fuellevelresult=[fuelleveldic objectForKey:@"result"];
            
            NSDictionary* DTCALARTdic=[[_sendToDetailArray objectAtIndex:3] properties];
            NSString* DTCALART=[DTCALARTdic objectForKey:@"factorName"];
            NSString* DTCALARTresult=[DTCALARTdic objectForKey:@"result"];
            
            NSDictionary* Maintenancedic=[[_sendToDetailArray objectAtIndex:4] properties];
            NSString* Maintenance=[Maintenancedic objectForKey:@"factorName"];
            NSString* Maintenanceresult=[Maintenancedic objectForKey:@"result"];

            
            NSDictionary* totalpointdic=[[_sendToDetailArray objectAtIndex:5] properties];
            NSString* totalpoint=[totalpointdic objectForKey:@"factorName"];
            NSString* totalresult=[totalpointdic objectForKey:@"result"];
            
            NSDictionary* totalpointdic1=[[_sendToDetailArray objectAtIndex:6] properties];
//            NSString* totalpoint1=[totalpointdic1 objectForKey:@"factorName"];
            _totalPoints=[totalpointdic1 objectForKey:@"result"];
        

            _label1.text=NSLocalizedStringFromTable(@"areInTheExamination,PleaseWaitKey",@"MyString", @"");
            _label2.text=[NSString stringWithFormat:@"%@ is %@",enginePRM,enginePRMresult];
            _label3.text=[NSString stringWithFormat:@"%@ is %@",battlevel,battleveldicresult];
            _label4.text=[NSString stringWithFormat:@"%@ is %@",fuellevel,fuellevelresult];
            _label5.text=[NSString stringWithFormat:@"%@ is %@",DTCALART,DTCALARTresult];
            _label6.text=[NSString stringWithFormat:@"%@ is %@",Maintenance,Maintenanceresult];
            _label7.text=[NSString stringWithFormat:@"%@ is %@",totalpoint,totalresult];
            _label8.text=NSLocalizedStringFromTable(@"theEndOfTheExaminationKey",@"MyString", @"");
            _label9.text=@"";
            [_myTimer setFireDate:[NSDate distantPast]];

           
            return;
        }
    }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


//- (void)handleSwipeFrom:(UISwipeGestureRecognizer*)recognizer
//{
//    //    NSLog(@"SUcces");
//    if (recognizer.direction==UISwipeGestureRecognizerDirectionRight) {
//        CATransition *animation=[CATransition animation];
//        animation.duration=1.5f;
//        animation.timingFunction=UIViewAnimationCurveEaseInOut;
//        animation.type=@"rippleEffect";
//        animation.subtype=kCATransitionFromLeft;
////        CarAssistantViewController *middle=[[CarAssistantViewController alloc]init];
////        [middle.view setFrame:CGRectMake(0, 0, WIDTH, 480)];
//        ADSummaryViewController* summary=[[ADSummaryViewController alloc]init];
//        [self.view.superview.layer addAnimation:animation forKey:nil];
//        [self.navigationController pushViewController:summary animated:YES];
//        [self.navigationController setNavigationBarHidden:NO];
//    }
//}


#pragma mark -Button Action
-(void)hiddenRemind:(id)sender{
    UIButton* btn=(UIButton*)sender;
    [btn setHidden:YES];
    [_dailyReminderTableView setHidden:YES];
    [_chachaImgView setHidden:YES];
    
}
-(void)vehicleConditionDetailButton:(id)sender{
    ADVehicleConditionDetailViewController* detail=[[ADVehicleConditionDetailViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDetailVehicleConditionResultNotification object:_sendToDetailArray];
    isCarAssistantView = 0;
    
}

-(void)getNewsButton:(id)sender{
    ADWebNewsViewController* webNews=[[ADWebNewsViewController alloc]init];
    [self.navigationController pushViewController:webNews animated:NO];

    UIButton* btn=(UIButton*)sender;
    int tag=btn.tag;
    NSString* StrTag=[NSString stringWithFormat:@"%d",tag];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADGetNewsIDNotification object:StrTag];
}

-(void)reserveButton:(id)sender{
    ADReserveViewController* reserve=[[ADReserveViewController alloc]initWithNibName:@"ADReserveViewController" bundle:nil];;
    [self.navigationController pushViewController:reserve animated:NO];
}
-(void)messageButton:(id)sender{
    MessageViewController* message=[[MessageViewController alloc]init];
    [self.navigationController pushViewController:message animated:NO];
//    [[NSNotificationCenter defaultCenter] postNotificationName:ADShowCityWeatherNotification object:_transmitDictionary];
}

-(void)rescueButton:(id)sender{
    SpeedDialViewController* rescue=[[SpeedDialViewController alloc]init];
    [self.navigationController pushViewController:rescue animated:NO];
}

-(void)informationButton:(id)sender{
#ifdef HMC
    [self chatTabBarButton:sender];
    return;
#endif

    LatestInformationViewController* latest=[[LatestInformationViewController alloc]init];
    [self.navigationController pushViewController:latest animated:NO];
}

//车友聊天
-(void)chatTabBarButton:(id)sender{
    ADChatTabBarViewController* chatTabBar=[[ADChatTabBarViewController alloc]init];
    [self.navigationController pushViewController:chatTabBar animated:NO];
}
-(void)summaryButton:(id)sender{
    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
        return;
    }
    [ADSingletonUtil sharedInstance].selectMenuIndex=4;
    [self navigateToViewControllerByClassName:@"ADSummaryFinalViewController"];
//    ADSummaryViewController* summary=[[ADSummaryViewController alloc]init];
//    [self.navigationController pushViewController:summary animated:NO];
}

-(void)locationButton:(id)sender
{
    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
        return;
    }
    [ADSingletonUtil sharedInstance].selectMenuIndex=1;
    [self navigateToViewControllerByClassName:@"ADLocationViewController"];
//    ADLocationViewController* location=[[ADLocationViewController alloc]init];
//    [self.navigationController setNavigationBarHidden:NO];
//    [self.navigationController pushViewController:location animated:NO];

}

- (void)navigateToViewControllerByClassName:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
    ADNavigationController *navigationController = [ADNavigationController navigationControllerWithRootViewController:viewController];
    CGRect frame = self.slidingController.topViewController.view.frame;
    self.slidingController.topViewController = navigationController;
    self.slidingController.topViewController.view.frame = frame;
    [self.slidingController resetTopView];
}

//-(void)carAssistantButton:(id)sender
//{
//    [self.navigationController popViewControllerAnimated:NO];
//}
-(void)calendarButton:(id)sender
{
    WeatherViewController* weather=[[WeatherViewController alloc]init];
    [self.navigationController pushViewController:weather animated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:ADWeatherDataNotification object:_transmitDictionary];
    [[NSNotificationCenter defaultCenter]postNotificationName:ADSendToWeatherCurrentSelectedCityNotification object:_currentSelectedCity];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Request handle
-(void)handleMessageGroupData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        NSArray* dataArray=[dictionary objectForKey:@"data"];
        if ([dataArray count]!=0) {
            int sum=0;
            for (NSDictionary* dic in dataArray) {
                NSString* toReadNum=[dic objectForKey:@"toReadNum"];
                int read=[toReadNum intValue];
                sum+=read;
            }
            if (sum>0) {
                
                [_dialogboxImgView setHidden:NO];
//                UILabel* sumLabel=[[UILabel alloc]initWithFrame:CGRectMake(146, 264, 10, 10)];
//                [sumLabel setBackgroundColor:[UIColor clearColor]];
//                sumLabel.text=[NSString stringWithFormat:@"%d",sum];
//                sumLabel.textAlignment=NSTextAlignmentCenter;
//                sumLabel.textColor=[UIColor redColor];
//                sumLabel.font=[UIFont systemFontOfSize:8];
//                [self.view addSubview:sumLabel];
            }else{
                [_dialogboxImgView setHidden:YES];
            }
        }else{
            NSLog(@"用车助手没有获取到消息列表");
        }

    }else{
        NSLog(@"用车助手消息列表系统错误");
    }
}

- (void)handleGetNewsData:(NSDictionary *)dictionary{
    if ([[dictionary objectForKey:@"resultCode"] isEqual:@"200"]) {
        _newsDataArray=[dictionary objectForKey:@"data"];
        _scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(10, 121, WIDTH-20, 135)];
        _scroll.contentSize=CGSizeMake((WIDTH-20)*[_newsDataArray count], 120);
        _scroll.showsHorizontalScrollIndicator=NO;
        _scroll.showsVerticalScrollIndicator=NO;
        _scroll.pagingEnabled=YES;
        _scroll.delegate=self;
        [self.view addSubview:_scroll];
        
        _checkingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        _checkingView.backgroundColor = [UIColor clearColor];
        _checkingView.hidden = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlert)];
        tap.numberOfTapsRequired = 1;
        [_checkingView addGestureRecognizer:tap];
        [self.view addSubview:_checkingView];
        
        _pageController=[[UIPageControl alloc]initWithFrame:CGRectMake(60, 235, WIDTH-120, 20)];
        _pageController.numberOfPages=[_newsDataArray count];
        _pageController.currentPage=0;
        [_pageController addTarget:self action:@selector(PageTurn:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:_pageController];
       
        [_scroll setFrame:CGRectMake(10, 205, WIDTH-20, 135)];
        [_pageController setFrame:CGRectMake(60, 319, WIDTH-120, 20)];
       
        for (int i=0; i<[_newsDataArray count]; i++) {
            UIWebView* webView=[[UIWebView alloc]initWithFrame:CGRectMake(self.scroll.frame.size.width*i, 0, self.scroll.frame.size.width, 135)];
            webView.contentMode=UIViewContentModeCenter;
            webView.delegate=self;
            [webView setScalesPageToFit:YES];
            NSDictionary* dic=[_newsDataArray objectAtIndex:i];
            NSString* picUrl=[dic objectForKey:@"picUrl"];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *server_url = [defaults objectForKey:@"server_url"];
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",server_url,picUrl]]];
            [webView loadRequest:request];
            [_scroll addSubview:webView];
            
            UIButton* Btn=[[UIButton alloc]initWithFrame:webView.frame];
            Btn.tag=i;
            [Btn setBackgroundColor:[UIColor clearColor]];
            [Btn addTarget:self action:@selector(getNewsButton:) forControlEvents:UIControlEventTouchUpInside];
            [_scroll addSubview:Btn];

        }
         [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(PageChange:) userInfo:nil repeats:YES];

    }else{
        NSLog(@"获取图片失败");
    }
    
}

#pragma mark-handle Notification
- (void)handleVehicleConditionNotification:(NSNotification *)aNoti{
    if(isCarAssistantView == 1){
    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
        return;
    }
    _checkingView.hidden = NO;
        self.navigationItem.leftBarButtonItem.enabled = NO;
    [_detectButton setHidden:YES];
    [_vehicleConditionBtn setHidden:YES];
    _ballImgView.image=[UIImage imageNamed:@"main_circle_bg_scan.png"];
    _scoreLabel.text=@"";
    
    CGPoint newContentOffset=_vehicleConditionScrollView.contentOffset;
    if (newContentOffset.y!=0) {
        newContentOffset.y-=140;
    }
    [_vehicleConditionScrollView setContentOffset:newContentOffset];
    [_arcImgView setHidden:NO];
    
    CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    animation.toValue=[NSNumber numberWithFloat:degreesToRadians(12000)];
    animation.duration=70.0f;
    animation.cumulative=YES;
    animation.repeatCount=0;
    
    [_arcImgView.layer addAnimation:animation forKey:nil];
    
    _label1.text=NSLocalizedStringFromTable(@"checkingKey",@"MyString", @"");
    _label2.text=@"";
    _label3.text=@"";
    [_vehiclesModel requestVehicleDetectionInfoWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];   //返回一个heartbeat_interval timestamp of now

    }
}

- (void)handleUpdateUnreadNotification:(NSNotification *)aNoti{
    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_GetMessageGroupModel startCallWithArguments:[NSArray arrayWithObjects:uID, nil]];
}

- (void)changeCitySuccess:(NSNotification *)aNoti
{
    _currentSelectedCity=(NSString*)[aNoti object];
    _currentCityLabel.text=_currentSelectedCity;
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    [defaults setObject:_currentSelectedCity forKey:@"city"];
    [_CalendarModel startCallWithArguments:[NSArray arrayWithObjects:_currentSelectedCity, nil]];
}

- (void)requestVehicleDetectionFail:(NSNotification *)aNoti{
//    [_arcImgView.layer removeAllAnimations];
//    [_arcImgView setHidden:YES];
//    _ballImgView.image=[UIImage imageNamed:@"redball.png"];
    if(isCarAssistantView == 1){
    _scoreLabel.text=@"";
    _label1.text=NSLocalizedStringFromTable(@"checkTimeOutPleaseRestartKey",@"MyString", @"");
//    [_detectButton setHidden:NO];
    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    [_vehiclesModel requestGetVehicleConditionCheckTimeOut:[NSArray arrayWithObjects:vin, nil]];
    }
}

-(void)handleGetVehicleConditionTimeOut:(NSNotification *)aNoti{
    if(isCarAssistantView == 1){
    NSDictionary* dic=(NSDictionary*)[aNoti object];
    _sendToDetailArray=[dic objectForKey:@"data"];
    
    NSDictionary* enginePRMdic=[[_sendToDetailArray objectAtIndex:0] properties];
    NSString* enginePRM=[enginePRMdic objectForKey:@"factorName"];
    NSString* enginePRMresult=[enginePRMdic objectForKey:@"result"];
    
    NSDictionary* battleveldic=[[_sendToDetailArray objectAtIndex:1] properties];
    NSString* battlevel=[battleveldic objectForKey:@"factorName"];
    NSString* battleveldicresult=[battleveldic objectForKey:@"result"];
    
    NSDictionary* fuelleveldic=[[_sendToDetailArray objectAtIndex:2] properties];
    NSString* fuellevel=[fuelleveldic objectForKey:@"factorName"];
    NSString* fuellevelresult=[fuelleveldic objectForKey:@"result"];
    
    NSDictionary* DTCALARTdic=[[_sendToDetailArray objectAtIndex:3] properties];
    NSString* DTCALART=[DTCALARTdic objectForKey:@"factorName"];
    NSString* DTCALARTresult=[DTCALARTdic objectForKey:@"result"];
    
    NSDictionary* Maintenancedic=[[_sendToDetailArray objectAtIndex:4] properties];
    NSString* Maintenance=[Maintenancedic objectForKey:@"factorName"];
    NSString* Maintenanceresult=[Maintenancedic objectForKey:@"result"];
    
    
//    NSDictionary* totalpointdic=[[_sendToDetailArray objectAtIndex:5] properties];
//    NSString* totalpoint=[totalpointdic objectForKey:@"factorName"];
//    _totalPoints=[totalpointdic objectForKey:@"result"];
////    _totalPoints=[totalpointdic objectForKey:@"value"];
    
    NSDictionary* totalpointdic=[[_sendToDetailArray objectAtIndex:5] properties];
    NSString* totalpoint=[totalpointdic objectForKey:@"factorName"];
    NSString* totalresult=[totalpointdic objectForKey:@"result"];
    
    NSDictionary* totalpointdic1=[[_sendToDetailArray objectAtIndex:6] properties];
    //            NSString* totalpoint1=[totalpointdic1 objectForKey:@"factorName"];
    _totalPoints=[totalpointdic1 objectForKey:@"result"];
    
    
    _label1.text=NSLocalizedStringFromTable(@"areInTheExamination,PleaseWaitKey",@"MyString", @"");
    _label2.text=[NSString stringWithFormat:@"%@ is %@",enginePRM,enginePRMresult];
    _label3.text=[NSString stringWithFormat:@"%@ is %@",battlevel,battleveldicresult];
    _label4.text=[NSString stringWithFormat:@"%@ is %@",fuellevel,fuellevelresult];
    _label5.text=[NSString stringWithFormat:@"%@ is %@",DTCALART,DTCALARTresult];
    _label6.text=[NSString stringWithFormat:@"%@ is %@",Maintenance,Maintenanceresult];
    _label7.text=[NSString stringWithFormat:@"%@ is %@",totalpoint,totalresult];
    _label8.text=NSLocalizedStringFromTable(@"theEndOfTheExaminationKey",@"MyString", @"");
    _label9.text=@"";

    
    if(_flag == 0){
        [_myTimer setFireDate:[NSDate distantFuture]];
    }else{
        [_myTimer setFireDate:[NSDate distantPast]];   //定时器开始
    }

    }
}

-(void)handleLimitLineData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"200"]) {
         _limtLabel.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"limitLineIndexKey",@"MyString", @""),NSLocalizedStringFromTable(@"noLimitLineKey",@"MyString", @"")];
    }else{
        _limtLabel.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"limitLineIndexKey",@"MyString", @""),NSLocalizedStringFromTable(@"limitLineKey",@"MyString", @"")];
    }
    _limtLabel.textColor=[UIColor whiteColor];
    [_limtLabel setBackgroundColor:[UIColor clearColor]];

}

-(void)handleRemindData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
        _remindArray=[dictionary objectForKey:@"data"];
        if ([_remindArray count]==0) {
            NSLog(@"用车助手首页无提醒");
        }else{
            
        
            
            _dailyReminderTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 15) style:UITableViewStylePlain];
            [_dailyReminderTableView setBackgroundColor:[UIColor colorWithRed:61.0/255.0 green:99.0/255.0 blue:144.0/255.0 alpha:1.0]];
            _dailyReminderTableView.separatorStyle=UITableViewCellAccessoryNone;
            _dailyReminderTableView.delegate=self;
            _dailyReminderTableView.dataSource=self;
            [_dailyReminderTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
            [_dailyReminderTableView setAlpha:0.8];
            [self.view addSubview:_dailyReminderTableView];
            
            
            _chachaImgView=[[UIImageView alloc]initWithFrame:CGRectMake(290, -3, 25, 20)];
            _chachaImgView.image=[UIImage imageNamed:@"chacha.png"];
            [self.view addSubview:_chachaImgView];
            
            UIButton* cancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(280, 0, 40, 40)];
            [cancleBtn addTarget:self action:@selector(hiddenRemind:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:cancleBtn];
            
            if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
                [_dailyReminderTableView setFrame:CGRectMake(0, 64, WIDTH, 15)];
                [_chachaImgView setFrame:CGRectMake(290, 61, 25, 20)];
                [cancleBtn setFrame:CGRectMake(300, 64, 20, 20)];
            }
            
            if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
            }
            
            if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
                [_dailyReminderTableView setFrame:CGRectMake(0, 64, WIDTH, 15)];
                [_chachaImgView setFrame:CGRectMake(290, 61, 25, 20)];
                [cancleBtn setFrame:CGRectMake(300, 64, 20, 20)];
            }

            [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(Scoll:) userInfo:nil repeats:YES];
        }
    }else{
        NSLog(@"用车助手提醒发送系统错误");
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset=scrollView.contentOffset;
    [_pageController setCurrentPage:offset.x/300];
}

-(void)PageTurn:(UIPageControl*)sender{
    int page=sender.currentPage;
    [_scroll setContentOffset:CGPointMake(300*page, 0)];
}

-(void)PageChange:(NSTimer *)timer{
    int page=_pageController.currentPage;
    if (page==[_newsDataArray count]-1) {
        page=0;
    }else{
        page++;
    }
    [_pageController setCurrentPage:page];
    [_scroll setContentOffset:CGPointMake(300*page, 0)];
    
}


-(void)Scoll:(NSTimer*)timer{
    
    CGPoint newContentOffset=_dailyReminderTableView.contentOffset;
    if (newContentOffset.y==15*([_remindArray count]-1)) {
        newContentOffset.y-=(15*[_remindArray count]);
        [_dailyReminderTableView setContentOffset:newContentOffset];
        //        [NSThread sleepForTimeInterval:3];
    }
    newContentOffset.y+=15;
    [_dailyReminderTableView setContentOffset:newContentOffset];
    
}


-(void)handleOilPriceData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        NSArray* data=[dictionary objectForKey:@"data"];
        if ([data count]==0) {
            _dayOliPriceLabel.text=[NSString stringWithFormat:NSLocalizedStringFromTable(@"oilPricesFailedToUpdateKey",@"MyString", @"")];
            _dayOliPriceLabel.textColor=[UIColor whiteColor];
            _dayOliPriceLabel.textAlignment=UITextAlignmentLeft;
            [_dayOliPriceLabel setBackgroundColor:[UIColor clearColor]];
            
        }else{
            NSDictionary* dic=[data objectAtIndex:0];
            NSString* oilType=[dic objectForKey:@"oilType"];
            NSString* typeString=@"";
            if([oilType intValue]==0){
                typeString=@"90#";
            }else if([oilType intValue]==1){
                typeString=@"93#";
            }else if ([oilType intValue]==2){
                typeString = @"97#";
            }else if ([oilType intValue]==3){
                typeString = @"90#";
            }
            
            _dayOliPriceLabel.text=[NSString stringWithFormat:@"%@: %@元/升(%@)",NSLocalizedStringFromTable(@"oilPricesTodayKey",@"MyString", @""),[dic objectForKey:@"price"],typeString];
            _dayOliPriceLabel.textColor=[UIColor whiteColor];
            _dayOliPriceLabel.textAlignment=UITextAlignmentLeft;
            [_dayOliPriceLabel setBackgroundColor:[UIColor clearColor]];
        }

    }else{
        NSLog(@"油价发送系统错误");
    }
}

-(void)handleWeatherData:(NSArray*)dictionary{
        if ([dictionary isEqual:[NSNull null]]) {
            NSLog(@"出错了");
            [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:NSLocalizedStringFromTable(@"weatherUpdateFailedKey",@"MyString", @"")];
//            [_washLabel setHidden:YES];
//            [_limtLabel setHidden:YES];
//            [_todayImgView setHidden:YES];
//            [_todayTemperatureLabel setHidden:YES];
//            [_tomorrowImgView setHidden:YES];
//            [_tomorrowTemperatureLabel setHidden:YES];
//            [_afterImgView setHidden:YES];
//            [_afterTemperatureLabel setHidden:YES];
            
            
            _washLabel.text=[NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"carWashIndexKey",@"MyString", @""),@"1.0"];
            _washLabel.textColor=[UIColor whiteColor];
            [_washLabel setBackgroundColor:[UIColor clearColor]];
  
            _todayTemperatureLabel.text=[NSString stringWithFormat:@"%@",@"0~0℃"];
            _todayTemperatureLabel.textColor=[UIColor whiteColor];
            _todayTemperatureLabel.textAlignment=NSTextAlignmentCenter;
            _todayTemperatureLabel.font=[UIFont systemFontOfSize:10];
            [_todayTemperatureLabel setBackgroundColor:[UIColor clearColor]];
            _todayImgView.image=[UIImage imageNamed:[self WeatherImage:@"晴"]];
            
            
            _tomorrowTemperatureLabel.text=[NSString stringWithFormat:@"%@",@"0~0℃"];
            _tomorrowTemperatureLabel.textColor=[UIColor whiteColor];
            _tomorrowTemperatureLabel.textAlignment=NSTextAlignmentCenter;
            _tomorrowTemperatureLabel.font=[UIFont systemFontOfSize:10];
            [_tomorrowTemperatureLabel setBackgroundColor:[UIColor clearColor]];
            _tomorrowImgView.image=[UIImage imageNamed:[self WeatherImage:@"晴"]];
            
            _afterTemperatureLabel.text=[NSString stringWithFormat:@"%@",@"0~0℃"];
            _afterTemperatureLabel.textColor=[UIColor whiteColor];
            _afterTemperatureLabel.textAlignment=NSTextAlignmentCenter;
            _afterTemperatureLabel.font=[UIFont systemFontOfSize:10];
            [_afterTemperatureLabel setBackgroundColor:[UIColor clearColor]];
            _afterImgView.image=[UIImage imageNamed:[self WeatherImage:@"晴"]];
        }else{
            NSArray *theArray1 = [[dictionary objectAtIndex:0] objectForKey:@"weather_data"];
            NSArray *theArray2 = [[dictionary objectAtIndex:0] objectForKey:@"index"];
            NSString* wash;
            if(theArray2.count>0){
                wash=[[[theArray2 objectAtIndex:1] objectForKey:@"zs"] copy];
            }else{
                wash=@"适宜";
            }
//            NSString* wash=[[theArray2 objectAtIndex:1] objectForKey:@"zs"];
            _washLabel.text=[NSString stringWithFormat:@"%@: %@",NSLocalizedStringFromTable(@"carWashIndexKey",@"MyString", @""),wash];
            _washLabel.textColor=[UIColor whiteColor];
            [_washLabel setBackgroundColor:[UIColor clearColor]];
    
        
//            NSDictionary* future=[[dictionary objectAtIndex:0] objectForKey:@"future"];
            _transmitDictionary=[[NSArray alloc]initWithArray:theArray1];
    
            NSDictionary* today= [theArray1 objectAtIndex:0];
            NSString* todayTemperature=[today objectForKey:@"temperature"];
            NSString* todayWeather=[today objectForKey:@"weather"];
            //        NSLog(todayWeather);
            _todayTemperatureLabel.text=[NSString stringWithFormat:@"%@",todayTemperature];
            _todayTemperatureLabel.textColor=[UIColor whiteColor];
            _todayTemperatureLabel.textAlignment=NSTextAlignmentCenter;
            _todayTemperatureLabel.font=[UIFont systemFontOfSize:10];
            [_todayTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    
       
            _todayImgView.image=[UIImage imageNamed:[self WeatherImage:todayWeather]];
    
            //    NSTimeInterval oneDay=24*60*60;
            //        NSDate* tdate=[[NSDate alloc]initWithTimeIntervalSinceNow:oneDay];
            //        NSDateFormatter* forma=[[NSDateFormatter alloc]init];
            //        [forma setDateFormat:@"YYYYMMdd"];
            //        NSString* to=[forma stringFromDate:tdate];
        
            NSDictionary* tomorrow=[theArray1 objectAtIndex:1];
            NSString* tomorrowTemperature=[tomorrow objectForKey:@"temperature"];
            NSString* tomorrowWeather=[tomorrow objectForKey:@"weather"];
        //        NSLog(tomorrowWeather);
            _tomorrowTemperatureLabel.text=[NSString stringWithFormat:@"%@",tomorrowTemperature];
            _tomorrowTemperatureLabel.textColor=[UIColor whiteColor];
            _tomorrowTemperatureLabel.textAlignment=NSTextAlignmentCenter;
            _tomorrowTemperatureLabel.font=[UIFont systemFontOfSize:10];
            [_tomorrowTemperatureLabel setBackgroundColor:[UIColor clearColor]];
        
            _tomorrowImgView.image=[UIImage imageNamed:[self WeatherImage:tomorrowWeather]];
    

    
            NSDictionary* after=[theArray1 objectAtIndex:2];
            NSString* afterTemperature=[after objectForKey:@"temperature"];
            NSString* afterWeather=[after objectForKey:@"weather"];
            //        NSLog(afterWeather);
            _afterTemperatureLabel.text=[NSString stringWithFormat:@"%@",afterTemperature];
            _afterTemperatureLabel.text=[NSString stringWithFormat:@"%@",tomorrowTemperature];
            _afterTemperatureLabel.textColor=[UIColor whiteColor];
            _afterTemperatureLabel.textAlignment=NSTextAlignmentCenter;
            _afterTemperatureLabel.font=[UIFont systemFontOfSize:10];
            [_afterTemperatureLabel setBackgroundColor:[UIColor clearColor]];
    
            _afterImgView.image=[UIImage imageNamed:[self WeatherImage:afterWeather]];
        }
}
#pragma makr -TableView setUp
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_remindArray count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary* dic=[_remindArray objectAtIndex:indexPath.row];
    NSString* content=[dic objectForKey:@"content"];
    cell.textLabel.text=content;
    cell.textLabel.textColor=[UIColor whiteColor];
    [cell.textLabel setFont:[UIFont systemFontOfSize:10]];
    [cell setBackgroundColor:[UIColor clearColor]];
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 15;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSString*)WeatherImage:(NSString*)weatherStr{
    NSString* ImgName=@"晴.png";
    if ([weatherStr length]<2) {
        if ([weatherStr isEqualToString:@"晴"]) {
            ImgName=@"晴.png";
        }else if ([weatherStr isEqualToString:@"阴"]){
            ImgName=@"阴.png";
        }else if ([weatherStr isEqualToString:@"雾"]){
            ImgName=@"雾.png";
        }
    }else{
        weatherStr=[weatherStr substringWithRange:NSMakeRange(0, 2)];
        if ([weatherStr isEqualToString:@"扬沙"]) {
            ImgName=@"扬沙.png";
        }else if ([weatherStr isEqualToString:@"多云"]){
            ImgName=@"多云.png";
        }else if ([weatherStr isEqualToString:@"小雪"]){
            ImgName=@"小雪.png";
        }else if ([weatherStr isEqualToString:@"雨夹"]){
            ImgName=@"小雪.png";
        }else if ([weatherStr isEqualToString:@"阵雪"]){
            ImgName=@"阵雪.png";
        }else if ([weatherStr isEqualToString:@"中雪"]){
            ImgName=@"中雪.png";
        }else if ([weatherStr isEqualToString:@"大雪"]){
            ImgName=@"大雪.png";
        }else if ([weatherStr isEqualToString:@"小雨"]){
            ImgName=@"小雨.png";
        }else if ([weatherStr isEqualToString:@"阵雨"]){
            ImgName=@"阵雨.png";
        }else if ([weatherStr isEqualToString:@"中雨"]){
            ImgName=@"中雨.png";
        }else if ([weatherStr isEqualToString:@"大雨"]){
            ImgName=@"大雨.png";
        }else if ([weatherStr isEqualToString:@"雷阵"]){
            ImgName=@"雷阵雨.png";
        }else if ([weatherStr isEqualToString:@"沙尘"]){
            ImgName=@"沙尘暴.png";
            weatherStr=[weatherStr substringWithRange:NSMakeRange(0, 1)];
        }else if ([weatherStr isEqualToString:@"晴"]) {
            ImgName=@"晴.png";
        }else if ([weatherStr isEqualToString:@"阴"]){
            ImgName=@"阴.png";
        }else if ([weatherStr isEqualToString:@"雾"]){
            ImgName=@"雾.png";
        }
    }
    return ImgName;
}
@end
