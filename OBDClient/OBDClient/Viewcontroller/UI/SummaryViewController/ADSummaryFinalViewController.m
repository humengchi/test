//
//  ADSummaryFinalViewController.m
//  OBDClient
//
//  Created by hys on 7/1/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADSummaryFinalViewController.h"

@interface ADSummaryFinalViewController ()
{
    int clickRefreshBtn;
}

@end

@implementation ADSummaryFinalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _devicesModel=[[ADDevicesModel alloc]init];
        
        _historyModel=[[ADHistoryModel alloc]init];
        
        _dtcsModel=[[ADDTCsModel alloc]init];
        
        _summaryModel=[[ADSummaryModel alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                       selector:@selector(requestLatestInfoSuccess1:)
                           name:ADDevicesModelRequestLatestInfoSuccessNotification
                         object:nil];

        [_devicesModel addObserver:self
                        forKeyPath:KVO_DEVICE_DETAIL_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        
        [_historyModel addObserver:self
                        forKeyPath:KVO_ALERT_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        
        [_dtcsModel addObserver:self
                     forKeyPath:KVO_DTCS_PATH_NAME
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADDevicesModelLoginTimeOutNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADDTCsModelLoginTimeOutNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADHistoryModelLoginTimeOutNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADVehiclesModelLoginTimeOutNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(refresh1)
                                                     name:@"ADAlertViewDidDisappear"
                                                   object:nil];
        _theResultDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(void)dealloc{
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_DEVICE_DETAIL_PATH_NAME];
    [_dtcsModel removeObserver:self
                    forKeyPath:KVO_DTCS_PATH_NAME];
    
    [_historyModel removeObserver:self forKeyPath:KVO_ALERT_PATH_NAME];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                          name:ADDevicesModelRequestLatestInfoSuccessNotification
                        object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"ADAlertViewDidDisappear"
                                                  object:nil];
    [_devicesModel cancel];
    [_historyModel cancel];
    [_dtcsModel cancel];
    [_summaryModel cancel];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [myTimer invalidate];
    myTimer = nil;
//    newsNum = alertNum = dtcNum = locNum = 0;
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)refresh
{
    clickRefreshBtn = 1;
    [_vehiclesModel requestVehicleSettingConfigWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil]];
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
//    [self requestLatestInfoWithResultTime:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]]];
    [_summaryModel updateMeliage:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[NSString stringWithFormat:@"%d",_selectBtn.tag], nil]];
    _summaryModel.summaryDelegate=self;
    [IVToastHUD showAsToastWithStatus:@""];
}

- (void)refresh1
{
    clickRefreshBtn = newsNum = alertNum = dtcNum = locNum = 0;
    [_vehiclesModel requestVehicleSettingConfigWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [self requestLatestInfoWithResultTime:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]]];
    [_summaryModel updateMeliage:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[NSString stringWithFormat:@"%d",_selectBtn.tag], nil]];
    _summaryModel.summaryDelegate=self;
    [IVToastHUD showAsToastWithStatus:@""];
}

//监听三个接口事件是否全部完成
- (void)actionIsFinish
{
    if(newsNum == (alertNum+dtcNum+locNum) && newsNum != 0){
        newsNum = alertNum = dtcNum = locNum = 0;
        [_devicesModel requestLatestInfoWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].globalUserBase.acctID,[ADSingletonUtil sharedInstance].globalUserBase.userID,[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[_theResultDict objectForKey:@"resultTime"], nil]];
        [myTimer invalidate];
        myTimer = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    clickRefreshBtn = newsNum = alertNum = dtcNum = locNum = 0;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]]);
    [self requestLatestInfoWithResultTime:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]]];
    
    [_summaryModel updateMeliage:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[NSString stringWithFormat:@"%d",_selectBtn.tag], nil]];
    _summaryModel.summaryDelegate=self;
    
    [_vehiclesModel requestVehicleSettingConfigWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil]];
    
    
    
    
    UIBarButtonItem *locationButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"locationKey",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(locationTap:)];
    
    UIBarButtonItem *mainButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"homeKey",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(mainTap:)];
   
//    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc]initWithTitle:@"刷新" style:UIBarButtonItemStyleBordered target:self action:@selector(refresh)];
    UIBarButtonItem *refreshButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
    self.navigationItem.rightBarButtonItems = @[refreshButton, locationButton, mainButton];
//    self.navigationItem.rightBarButtonItem=locationButton;
    if (IOS7_OR_LATER) {
        locationButton.tintColor=[UIColor lightGrayColor];
        refreshButton.tintColor=[UIColor lightGrayColor];
        mainButton.tintColor = [UIColor lightGrayColor];
    }
    
    _summaryView=[[ADGaugeView alloc]initWithFrame:CGRectMake(0, 5, WIDTH, 236.5) minValue:0 maxValue:200 minDegree:-90 maxDegree:90 totalMarks:20 pointerSize:CGSizeMake(10, 70) bgImage:[UIImage imageNamed:@"hys_summary.png"] pointerImage:[UIImage imageNamed:@"zhizhen.png"] initValue:0 pointerYOffset:105];
    [self.view addSubview:_summaryView];
    
    _buttonMileage=[UIButton buttonWithType:UIButtonTypeCustom];
    [_buttonMileage setAlpha:0.5];
    [_buttonMileage setFrame:CGRectMake(120, 195, 92, 31)];
    [_buttonMileage setBackgroundColor:[UIColor grayColor]];
    _buttonMileage.titleLabel.font=[UIFont systemFontOfSize:26];
    _buttonMileage.titleLabel.textAlignment=UITextAlignmentCenter;
    [_buttonMileage addTarget:self action:@selector(showMeliage:) forControlEvents:UIControlEventTouchUpInside];
    [_buttonMileage setTitle:@"000000" forState:UIControlStateNormal];
    [self.view addSubview:_buttonMileage];
    
    _labelOfDate=[[UILabel alloc]initWithFrame:CGRectMake(118, 35, 80, 10)];
    [_labelOfDate setBackgroundColor:[UIColor clearColor]];
    [_labelOfDate setFont:[UIFont systemFontOfSize:8]];
    _labelOfDate.textColor=[UIColor colorWithRed:221.0/255.0 green:80.0/255.0 blue:4.0/255.0 alpha:1.0];
    _labelOfDate.textAlignment=UITextAlignmentCenter;
    _labelOfDate.text=@"";
    [self.view addSubview:_labelOfDate];
    
    
    _obdImgView=[[UIImageView alloc]initWithFrame:CGRectMake(78, 50, 25, 25)];
    _obdImgView.image=[UIImage imageNamed:@"alerts_off.png"];
    [self.view addSubview:_obdImgView];
    
    UILabel* obdlabel=[[UILabel alloc]initWithFrame:CGRectMake(103, 50, 60, 25)];
    obdlabel.text=@"OBD告警";
    [obdlabel setBackgroundColor:[UIColor clearColor]];
    obdlabel.textColor=[UIColor colorWithRed:201.0/255.0 green:200.0/255.0 blue:196.0/255.0 alpha:1.0];
    [obdlabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:obdlabel];
    
    UIButton* obdBtn=[[UIButton alloc]initWithFrame:CGRectMake(78, 50, 85, 25)];
    obdBtn.tag=1001;
    [obdBtn setBackgroundColor:[UIColor clearColor]];
    [obdBtn addTarget:self action:@selector(alertsAndDTC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:obdBtn];
    
    
    _dtcImgView=[[UIImageView alloc]initWithFrame:CGRectMake(175, 50, 25, 25)];
    _dtcImgView.image=[UIImage imageNamed:@"dtc_off.png"];
    [self.view addSubview:_dtcImgView];
    
    UILabel* dtclabel=[[UILabel alloc]initWithFrame:CGRectMake(200, 50, 40, 25)];
    dtclabel.text=@"保养";//@"DTC";
    [dtclabel setBackgroundColor:[UIColor clearColor]];
    dtclabel.textColor=[UIColor colorWithRed:201.0/255.0 green:200.0/255.0 blue:196.0/255.0 alpha:1.0];
    [dtclabel setFont:[UIFont systemFontOfSize:14.0]];
    [self.view addSubview:dtclabel];
    
    UIButton* dtcBtn=[[UIButton alloc]initWithFrame:CGRectMake(175, 50, 65, 25)];
    dtcBtn.tag=1002;
    [dtcBtn setBackgroundColor:[UIColor clearColor]];
    [dtcBtn addTarget:self action:@selector(alertsAndDTC:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dtcBtn];
    
    
    UIEdgeInsets insets=UIEdgeInsetsMake(1.5, 1.5, 1.5, 1.5);
    
    _oilImgView=[[UIImageView alloc]initWithFrame:CGRectMake(47.1, 68, 6.5, 0)];
    _oilImgView.image=[UIImage  imageNamed:@"greenrect.png"];
    [_oilImgView.image resizableImageWithCapInsets:insets];
    [self.view addSubview:_oilImgView];
    
    _temperatureImgView=[[UIImageView alloc]initWithFrame:CGRectMake(258.1, 68, 6.5, 0)];
    _temperatureImgView.image=[UIImage  imageNamed:@"greenrect.png"];
    [_temperatureImgView.image resizableImageWithCapInsets:insets];
    [self.view addSubview:_temperatureImgView];

    
    UIEdgeInsets ballinsets=UIEdgeInsetsMake(15, 15, 15, 15);
    
    _engineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(40, 240, 60, 60)];
    _engineImgView.image=[UIImage imageNamed:@"engineoff.png"];
    [_engineImgView.image resizableImageWithCapInsets:ballinsets];
    [self.view addSubview:_engineImgView];
    
    UILabel* engineLabel=[[UILabel alloc]initWithFrame:CGRectMake(40, 300, 60, 20)];
    engineLabel.text=@"引擎状态";
    engineLabel.textColor=[UIColor whiteColor];
    [engineLabel setBackgroundColor:[UIColor clearColor]];
    [engineLabel setFont:[UIFont systemFontOfSize:10.0]];
    engineLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:engineLabel];
    
    _blueColor=[UIColor colorWithRed:133.0/255.0 green:193.0/255.0 blue:231.0/255.0 alpha:1.0];
    _redColor=[UIColor colorWithRed:252.0/255.0 green:169.0/255.0 blue:158.0/255.0 alpha:1.0];
    
    _RMPImgView=[[UIImageView alloc]initWithFrame:CGRectMake(130, 240, 60, 60)];
    _RMPImgView.image=[UIImage imageNamed:@"blue.png"];
    [_RMPImgView.image resizableImageWithCapInsets:ballinsets];
    [self.view addSubview:_RMPImgView];
    
    UILabel* RMPLabel=[[UILabel alloc]initWithFrame:CGRectMake(130, 300, 60, 20)];
    RMPLabel.text=@"发动机转速\n(x1000rimin)";
    RMPLabel.textColor=[UIColor whiteColor];
    [RMPLabel setBackgroundColor:[UIColor clearColor]];
    RMPLabel.numberOfLines=0;
    RMPLabel.lineBreakMode=UILineBreakModeWordWrap;
    [RMPLabel setFont:[UIFont systemFontOfSize:10.0]];
    RMPLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:RMPLabel];

    
    _RMPLabel=[[UILabel alloc]initWithFrame:CGRectMake(135, 243, 50, 50)];
    _RMPLabel.text=@"0.0";
    _RMPLabel.textColor=_blueColor;
    [_RMPLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_RMPLabel setBackgroundColor:[UIColor clearColor]];
    _RMPLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:_RMPLabel];
    
    _batteryImgView=[[UIImageView alloc]initWithFrame:CGRectMake(220, 240, 60, 60)];
    _batteryImgView.image=[UIImage imageNamed:@"blue.png"];
    [_batteryImgView.image resizableImageWithCapInsets:ballinsets];
    [self.view addSubview:_batteryImgView];
    
    UILabel* batteryLabel=[[UILabel alloc]initWithFrame:CGRectMake(220, 300, 60, 20)];
    batteryLabel.text=@"电瓶电压(V)";
    batteryLabel.textColor=[UIColor whiteColor];
    [batteryLabel setBackgroundColor:[UIColor clearColor]];
    [batteryLabel setFont:[UIFont systemFontOfSize:10.0]];
    batteryLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:batteryLabel];

    
    _batteryLabel=[[UILabel alloc]initWithFrame:CGRectMake(223, 243, 50, 50)];
    _batteryLabel.text=@"0.0";
    _batteryLabel.textColor=_blueColor;
    [_batteryLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_batteryLabel setBackgroundColor:[UIColor clearColor]];
    _batteryLabel.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:_batteryLabel];

    UIView* viewOfBottom=[[UIView alloc]initWithFrame:CGRectMake(0, WIDTH, WIDTH, 96)];
    [viewOfBottom setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:viewOfBottom];
    
    UIImageView* line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 2)];
    line1.image=[UIImage imageNamed:@"xiline.png"];
    
    [viewOfBottom addSubview:line1];
    
    UIImageView* line2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 93, WIDTH, 2)];
    line2.image=[UIImage imageNamed:@"xiline.png"];
    [viewOfBottom addSubview:line2];
    
    
    
    _currentLabel=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-50)/2, 20, 50, 50)];
    _currentLabel.text=@"最近\n行程";
    _currentLabel.numberOfLines=0;
    _currentLabel.textAlignment=UITextAlignmentCenter;
    _currentLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    _currentLabel.backgroundColor=[UIColor clearColor];
    _currentLabel.textColor=[UIColor purpleColor];
    _currentLabel.lineBreakMode=UILineBreakModeWordWrap;
    [viewOfBottom addSubview:_currentLabel];
    
    _selectBtn=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-50)/2, 25, 50, 50)];
    _selectBtn.backgroundColor=[UIColor clearColor];
    _selectBtn.tag=0;
    [_selectBtn addTarget:self action:@selector(selectShowType:) forControlEvents:UIControlEventTouchUpInside];
    [viewOfBottom addSubview:_selectBtn];
    
    UIImageView* line3=[[UIImageView alloc]initWithFrame:CGRectMake(0, 46, (WIDTH-50)/2, 2)];
    line3.image=[UIImage imageNamed:@"xiline.png"];
    [viewOfBottom addSubview:line3];
    
    UIImageView* line4=[[UIImageView alloc]initWithFrame:CGRectMake((WIDTH-50)/2+50, 46, (WIDTH-50)/2, 2)];
    line4.image=[UIImage imageNamed:@"xiline.png"];
    [viewOfBottom addSubview:line4];
    
    _lab1=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 30, 20)];
    _lab1.text=@"续航";
    _lab1.textColor=[UIColor whiteColor];
    _lab1.backgroundColor=[UIColor clearColor];
    _lab1.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab1.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab1];
    
    _lab2=[[UILabel alloc]initWithFrame:CGRectMake(50, 15, 75, 20)];
    _lab2.text=@"0 次";
    _lab2.textColor=[UIColor whiteColor];
    _lab2.backgroundColor=[UIColor clearColor];
    _lab2.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab2.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab2];
    
    _lab3=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-50)/2+50+15, 15, 40, 20)];
    _lab3.text=@"驾驶";
    _lab3.textColor=[UIColor whiteColor];
    _lab3.backgroundColor=[UIColor clearColor];
    _lab3.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab3.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab3];
    
    _lab4=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-50)/2+50+65, 15, 75, 20)];
    _lab4.text=@"0 公里";
    _lab4.textColor=[UIColor whiteColor];
    _lab4.backgroundColor=[UIColor clearColor];
    _lab4.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab4.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab4];
    
    _lab5=[[UILabel alloc]initWithFrame:CGRectMake(10, 62, 30, 20)];
    _lab5.text=@"油耗";
    _lab5.textColor=[UIColor whiteColor];
    _lab5.backgroundColor=[UIColor clearColor];
    _lab5.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab5.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab5];
    
    _lab6=[[UILabel alloc]initWithFrame:CGRectMake(50, 62, 75, 20)];
    _lab6.text=@"0 升百公里";
    _lab6.textColor=[UIColor whiteColor];
    _lab6.backgroundColor=[UIColor clearColor];
    _lab6.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab6.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab6];
    
    _lab7=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-50)/2+50+15, 62, 40, 20)];
    _lab7.text=@"均速";
    _lab7.textColor=[UIColor whiteColor];
    _lab7.backgroundColor=[UIColor clearColor];
    _lab7.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab7.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab7];
    
    _lab8=[[UILabel alloc]initWithFrame:CGRectMake((WIDTH-50)/2+50+65, 62, 75, 20)];
    _lab8.text=@"0 公里/小时";
    _lab8.textColor=[UIColor whiteColor];
    _lab8.backgroundColor=[UIColor clearColor];
    _lab8.font=[UIFont fontWithName:@"Helvetica-Bold" size:12.0];
    _lab8.textAlignment=UITextAlignmentLeft;
    [viewOfBottom addSubview:_lab8];

    _editMileageView=[[UIView alloc]initWithFrame:CGRectMake(60, 50, 200, 100)];
    [_editMileageView setAlpha:0.9];
    [_editMileageView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_back.png"]]];
    [_editMileageView setHidden:YES];
    [self.view addSubview:_editMileageView];
    
    _mileageTextField=[[UITextField alloc]initWithFrame:CGRectMake(25, 15, 150, 30)];
    [_mileageTextField setBorderStyle:UITextBorderStyleRoundedRect];
    _mileageTextField.placeholder=NSLocalizedStringFromTable(@"enterKey",@"MyString", @"");
    _mileageTextField.textAlignment = UITextAlignmentCenter;
    _mileageTextField.secureTextEntry=NO;
    _mileageTextField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
    [_mileageTextField setFont:[UIFont systemFontOfSize:18]];
    [_editMileageView addSubview:_mileageTextField];
    _mileageTextField.delegate = self;
    
    UIButton* sureButton=[[UIButton alloc]initWithFrame:CGRectMake(25, 60, 60, 30)];
    [sureButton setTitle:NSLocalizedStringFromTable(@"submitKey",@"MyString", @"") forState:UIControlStateNormal];
    [sureButton setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sureButton setBackgroundImage:[UIImage imageNamed:@"restartcheck.png"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(SureButton:) forControlEvents:UIControlEventTouchUpInside];
    [_editMileageView addSubview:sureButton];
    
    UIButton* cancelButton=[[UIButton alloc]initWithFrame:CGRectMake(115, 60, 60, 30)];
    [cancelButton setTitle:NSLocalizedStringFromTable(@"cancelKey",@"MyString", @"") forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"click.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButton:) forControlEvents:UIControlEventTouchUpInside];
    [_editMileageView addSubview:cancelButton];

    _oilNum=15.0;
    _tempNum=105.0;
    _RMPNum=4000.0;
    _batteryNum=11.5;
    _bol=NO;
    
//    [_vehiclesModel requestVehicleSettingConfigWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil]];
    [_summaryView setFrame:CGRectMake(0, 69, WIDTH, 236.5)];
    [_labelOfDate setFrame:CGRectMake((WIDTH-80)/2, 99, 80, 10)];
    
    [_obdImgView setFrame:CGRectMake(78, 114, 25, 25)];
    [obdlabel setFrame:CGRectMake(103, 114, 60, 25)];
    [obdBtn setFrame:CGRectMake(78, 114, 85, 25)];
    [_dtcImgView setFrame:CGRectMake(WIDTH/2+15, 114, 25, 25)];
    [dtclabel setFrame:CGRectMake(WIDTH/2+40, 114, 40, 25)];
    [dtcBtn setFrame:CGRectMake(WIDTH/2+15, 114, 65, 25)];
    if (WIDTH==320) {
        [_oilImgView setFrame:CGRectMake(47.1, 132, 6.5, 0)];
        [_temperatureImgView setFrame:CGRectMake(258.1, 132, 6.5, 0)];
        [_buttonMileage setFrame:CGRectMake((WIDTH-92)/2.0, 259, 92, 31)];
    }else{
        [_oilImgView setFrame:CGRectMake(55.4, 132, 7.5, 0)];
        [_temperatureImgView setFrame:CGRectMake(WIDTH-72.4, 132, 7.5, 0)];
        [_buttonMileage setFrame:CGRectMake((WIDTH-92)/2.0, 259, 104, 31)];
    }
    
    [_engineImgView setFrame:CGRectMake((WIDTH-240)/2, 304, 60, 60)];
    [engineLabel setFrame:CGRectMake((WIDTH-240)/2, 364, 60, 20)];
    
    [_RMPImgView setFrame:CGRectMake((WIDTH-240)/2+90, 304, 60, 60)];
    [RMPLabel setFrame:CGRectMake((WIDTH-240)/2+90, 364, 60, 20)];
    [_RMPLabel setFrame:CGRectMake((WIDTH-240)/2+95, 307, 50, 50)];
    
    [_batteryImgView setFrame:CGRectMake((WIDTH-240)/2+180, 304, 60, 60)];
    [batteryLabel setFrame:CGRectMake((WIDTH-240)/2+180, 364, 60, 20)];
    [_batteryLabel setFrame:CGRectMake((WIDTH-240)/2+183, 307, 50, 50)];
    
    [viewOfBottom setFrame:CGRectMake(0, 384, WIDTH, 96)];
    [_editMileageView setFrame:CGRectMake((WIDTH-200)/2, 114, 200, 100)];
    /*
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_summaryView setFrame:CGRectMake(0, 69, WIDTH, 236.5)];
        [_buttonMileage setFrame:CGRectMake((WIDTH-92)/2.0, 259, 92, 31)];
        [_labelOfDate setFrame:CGRectMake(118, 99, 80, 10)];
        
        [_obdImgView setFrame:CGRectMake(78, 114, 25, 25)];
        [obdlabel setFrame:CGRectMake(103, 114, 60, 25)];
        [obdBtn setFrame:CGRectMake(78, 114, 85, 25)];
        [_dtcImgView setFrame:CGRectMake(175, 114, 25, 25)];
        [dtclabel setFrame:CGRectMake(200, 114, 40, 25)];
        [dtcBtn setFrame:CGRectMake(175, 114, 65, 25)];
        [_oilImgView setFrame:CGRectMake(47.1, 132, 6.5, 0)];
        [_temperatureImgView setFrame:CGRectMake(258.1, 132, 6.5, 0)];
        [_engineImgView setFrame:CGRectMake(40, 304, 60, 60)];
        [engineLabel setFrame:CGRectMake(40, 364, 60, 20)];
        [_RMPImgView setFrame:CGRectMake(130, 304, 60, 60)];
        [RMPLabel setFrame:CGRectMake(130, 364, 60, 20)];
        [_RMPLabel setFrame:CGRectMake(135, 307, 50, 50)];
        [_batteryImgView setFrame:CGRectMake(220, 304, 60, 60)];
        [batteryLabel setFrame:CGRectMake(220, 364, 60, 20)];
        [_batteryLabel setFrame:CGRectMake(223, 307, 50, 50)];
        [viewOfBottom setFrame:CGRectMake(0, 384, WIDTH, 96)];
        [_editMileageView setFrame:CGRectMake(60, 114, 200, 100)];
        
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
//        [_summaryView setFrame:CGRectMake(0, 20, WIDTH, 236.5)];
//        [_buttonMileage setFrame:CGRectMake(120, 210, 92, 31)];
//        [_labelOfDate setFrame:CGRectMake(118, 50, 80, 10)];
//        [_obdImgView setFrame:CGRectMake(78, 71, 25, 25)];
//        [obdlabel setFrame:CGRectMake(103, 71, 60, 25)];
//        [obdBtn setFrame:CGRectMake(78, 71, 85, 25)];
//        [_dtcImgView setFrame:CGRectMake(175, 71, 25, 25)];
//        [dtclabel setFrame:CGRectMake(200, 71, 40, 25)];
//        [dtcBtn setFrame:CGRectMake(175, 71, 65, 25)];
//        [_oilImgView setFrame:CGRectMake(47.1, 95, 6.5, 0)];
//        [_temperatureImgView setFrame:CGRectMake(258.1, 95, 6.5, 0)];

//        [_engineImgView setFrame:CGRectMake(10, 370, 90, 90)];
//        [engineLabel setFrame:CGRectMake(20, 460, 70, 30)];
//        [_RMPImgView setFrame:CGRectMake(115, 370, 90, 90)];
//        [RMPLabel setFrame:CGRectMake(125, 460, 70, 30)];
//        [_RMPLabel setFrame:CGRectMake(133, 387, 50, 50)];
//        [_batteryImgView setFrame:CGRectMake(219, 370, 90, 90)];
//        [batteryLabel setFrame:CGRectMake(219, 460, 90, 30)];
//        [_batteryLabel setFrame:CGRectMake(237, 387, 50, 50)];

    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_summaryView setFrame:CGRectMake(0, 69, WIDTH, 236.5)];
        [_buttonMileage setFrame:CGRectMake(120, 259, 92, 31)];
        [_labelOfDate setFrame:CGRectMake(118, 99, 80, 10)];
        
        [_obdImgView setFrame:CGRectMake(78, 114, 25, 25)];
        [obdlabel setFrame:CGRectMake(103, 114, 60, 25)];
        [obdBtn setFrame:CGRectMake(78, 114, 85, 25)];
        [_dtcImgView setFrame:CGRectMake(175, 114, 25, 25)];
        [dtclabel setFrame:CGRectMake(200, 114, 40, 25)];
        [dtcBtn setFrame:CGRectMake(175, 114, 65, 25)];
        [_oilImgView setFrame:CGRectMake(47.1, 132, 6.5, 0)];
        [_temperatureImgView setFrame:CGRectMake(258.1, 132, 6.5, 0)];
        [_engineImgView setFrame:CGRectMake(40, 304, 60, 60)];
        [engineLabel setFrame:CGRectMake(40, 364, 60, 20)];
        [_RMPImgView setFrame:CGRectMake(130, 304, 60, 60)];
        [RMPLabel setFrame:CGRectMake(130, 364, 60, 20)];
        [_RMPLabel setFrame:CGRectMake(135, 307, 50, 50)];
        [_batteryImgView setFrame:CGRectMake(220, 304, 60, 60)];
        [batteryLabel setFrame:CGRectMake(220, 364, 60, 20)];
        [_batteryLabel setFrame:CGRectMake(223, 307, 50, 50)];
        [viewOfBottom setFrame:CGRectMake(0, 384, WIDTH, 96)];
        [_editMileageView setFrame:CGRectMake(60, 114, 200, 100)];
	}
    */
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
//    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]]);
//    [self requestLatestInfoWithResultTime:[dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:0]]];
//    
//    [_summaryModel updateMeliage:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[NSString stringWithFormat:@"%d",_selectBtn.tag], nil]];
//    _summaryModel.summaryDelegate=self;
}

-(void)showMeliage:(id)sender{
    [_editMileageView setHidden:NO];
}

-(void)cancelButton:(id)sender{
    [_editMileageView setHidden:YES];
    _mileageTextField.placeholder=NSLocalizedStringFromTable(@"enterKey",@"MyString", @"");
    [_mileageTextField resignFirstResponder];
}

-(void)SureButton:(id)sender{
    [_editMileageView setHidden:YES];
    _mileageTextField.placeholder=NSLocalizedStringFromTable(@"enterKey",@"MyString", @"");
    [_mileageTextField resignFirstResponder];
    NSDate* now=[NSDate date];
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSString* nowStr=[formatter stringFromDate:now];
    [_summaryModel setTotalMeliage:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,_mileageTextField.text,nowStr, nil]];
    [IVToastHUD showAsToastWithStatus:@""];
}

- (void)selectShowType:(id)sender{
    switch (_selectBtn.tag) {
        case 0:
            _currentLabel.text=@"本日\n行程";
            _selectBtn.tag++;
            break;
        case 1:
            _currentLabel.text=@"本周\n行程";
            _selectBtn.tag++;
            break;
        case 2:
            _currentLabel.text=@"本月\n行程";
            _selectBtn.tag++;
            break;
        case 3:
            _currentLabel.text=_bol?@"当前\n行程":@"最近\n行程";
            _selectBtn.tag=0;
            break;
        default:
            break;
    }
    if (_selectBtn.tag==0) {
        _lab1.text=@"续航";
        _lab3.text=@"驾驶";
    }else{
        _lab1.text=@"行程";
        _lab3.text=@"总里程";
    }
    [_summaryModel updateMeliage:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[NSString stringWithFormat:@"%d",_selectBtn.tag], nil]];
    [IVToastHUD showAsToastWithStatus:@""];
}

- (void)locationTap:(id)sender{
    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
        return;
    }
    [ADSingletonUtil sharedInstance].selectMenuIndex=1;
    [self navigateToViewControllerByClassName:@"ADLocationViewController"];
}

- (void)mainTap:(id)sender{
//    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
//        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
//        return;
//    }
    [ADSingletonUtil sharedInstance].selectMenuIndex=0;
    [self navigateToViewControllerByClassName:@"CarAssistantViewController"];
}

- (void)alertsAndDTC:(id)sender{
    UIButton* btn=(UIButton*)sender;
    int tag=btn.tag;
    NSString* className;
    switch (tag) {
        case 1001:{
            className=@"ADAlertViewController";
            _obdImgView.image=[UIImage imageNamed:@"alerts_off.png"];
            NSDate *date = [NSDate date];
            NSDateFormatter* dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"MMddHHmmss"];
            [[NSUserDefaults standardUserDefaults] setObject:[dateformatter stringFromDate:date] forKey:@"OBDDate"];
        }
            break;
        case 1002:{
            className=@"ADDTCsViewController";
            _dtcImgView.image=[UIImage imageNamed:@"dtc_off.png"];
            NSDate *date = [NSDate date];
            NSDateFormatter* dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"MMddHHmmss"];
            [[NSUserDefaults standardUserDefaults] setObject:[dateformatter stringFromDate:date] forKey:@"DTCDate"];
        }
            break;
        default:
            break;
    }
    UIViewController* viewController=[[NSClassFromString(className) alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)updateDetailUI{
    [_buttonMileage setTitle:[NSString stringWithFormat:@"%06d",[_devicesModel.deviceDetail.totalMileage intValue]] forState:UIControlStateNormal];
//    NSString *stringTime=_devicesModel.deviceDetail.gpsTime;
//    NSString *stringDate = _devicesModel.deviceDetail.gpsDate;
//    _labelOfDate.text=[NSString stringWithFormat:@"%@ %@",stringDate,stringTime];
    
    NSString *stringTime=_devicesModel.deviceDetail.gpsTime;
    NSString *stringDate = _devicesModel.deviceDetail.gpsDate;
    NSDate *date=[[NSString stringWithFormat:@"%@ %@",stringDate,stringTime] dateFromStringHasTime:YES];
    NSString * strFormatDate=[date toStringHasTime:YES];
    _labelOfDate.text=[NSString stringWithFormat:@"%@",strFormatDate];
    
    
    [_summaryView runToValue:_devicesModel.deviceDetail.speed animated:YES hasEffect:YES];
    float oilV=_devicesModel.deviceDetail.fuel_level_now;
    NSLog(@"%f",oilV);
    float temp=[_devicesModel.deviceDetail.high_temp floatValue];
    if (oilV<_oilNum) {
        _oilImgView.image=[UIImage imageNamed:@"redrect.png"];
    }else{
        _oilImgView.image=[UIImage imageNamed:@"greenrect.png"];
    }
    
    if (temp<_tempNum) {
        _temperatureImgView.image=[UIImage imageNamed:@"greenrect.png"];
    }else{
        _temperatureImgView.image=[UIImage imageNamed:@"redrect.png"];
    }

    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_oilImgView.frame;
        if (oilV>100) {
            frame.origin.y=205;
            frame.size.height=0;
        }else{
            frame.origin.y=132+(100-oilV)/100*73;
            frame.size.height=73-(100-oilV)/100*73;
        }
        [_oilImgView setFrame:frame];
        
        frame=_temperatureImgView.frame;
        if (temp<50) {
            frame.origin.y=205;
            frame.size.height=0;
        }else if (temp<120){
            frame.origin.y=132+(120-temp)/70*73;
            frame.size.height=73-(120-temp)/70*73;
        }else{
            frame.origin.y=205;
            frame.size.height=0;
        }
        [_temperatureImgView setFrame:frame];
	}
    
    if (!IOS7_OR_LATER) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_oilImgView.frame;
        if (oilV>100) {
            frame.origin.y=141;
            frame.size.height=0;
        }else{
            frame.origin.y=68+(100-oilV)/100*73;
            frame.size.height=73-(100-oilV)/100*73;
        }
        [_oilImgView setFrame:frame];
        
        frame=_temperatureImgView.frame;
        if (temp<50) {
            frame.origin.y=141;
            frame.size.height=0;
        }else if (temp<120){
            frame.origin.y=68+(120-temp)/70*73;
            frame.size.height=73-(120-temp)/70*73;
        }else{
            frame.origin.y=141;
            frame.size.height=0;
        }
        [_temperatureImgView setFrame:frame];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_oilImgView.frame;
        if (oilV>100) {
            frame.origin.y=205;
            frame.size.height=0;
        }else{
            frame.origin.y=132+(100-oilV)/100*73;
            frame.size.height=73-(100-oilV)/100*73;
        }
        [_oilImgView setFrame:frame];
        
        frame=_temperatureImgView.frame;
        if (temp<50) {
            frame.origin.y=205;
            frame.size.height=0;
        }else if (temp<120){
            frame.origin.y=132+(120-temp)/70*73;
            frame.size.height=73-(120-temp)/70*73;
        }else{
            frame.origin.y=205;
            frame.size.height=0;
        }
        [_temperatureImgView setFrame:frame];
	}
    
    
    if ([_devicesModel.deviceDetail.ign isEqualToString:@"0"]) {
        _engineImgView.image=[UIImage imageNamed:@"engineoff.png"];
    }else{
        _engineImgView.image=[UIImage imageNamed:@"engineon.png"];
    }
    
    _RMPLabel.text=[NSString stringWithFormat:@"%2.1f",[_devicesModel.deviceDetail.engineRPM floatValue]/1000];
    if ([_devicesModel.deviceDetail.engineRPM floatValue]<_RMPNum) {
        _RMPImgView.image=[UIImage imageNamed:@"blue.png"];
        _RMPLabel.textColor=_blueColor;
    }else{
        _RMPImgView.image=[UIImage imageNamed:@"red.png"];
        _RMPLabel.textColor=_redColor;
    }
    
    _batteryLabel.text=[NSString stringWithFormat:@"%.1f",_devicesModel.deviceDetail.batt_level];
    if (_devicesModel.deviceDetail.batt_level>_batteryNum) {
        _batteryImgView.image=[UIImage imageNamed:@"blue.png"];
        _batteryLabel.textColor=_blueColor;
    }else{
        _batteryImgView.image=[UIImage imageNamed:@"red.png"];
        _batteryLabel.textColor=_redColor;
    }

    if ([_devicesModel.deviceDetail.ign isEqualToString:@"1"] && [_devicesModel.deviceDetail.onLineStatus isEqualToString:@"1"]) {
        
        _bol=YES;
    }
    
    if (_bol) {
        _currentLabel.text=@"当前\n行程";
    }else{
        _currentLabel.text=@"最近\n行程";
    }
}

- (void)requestLatestInfoSuccess1:(NSNotification *)aNoti{
    
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    NSDictionary *latestInfo=aNoti.userInfo;
    if ([[latestInfo objectForKey:@"alertNum"] intValue]>0) {
        newsNum += 1;
    }
    if ([[latestInfo objectForKey:@"dtcNum"] intValue]>0) {
        newsNum += 1;
    }
    if ([[latestInfo objectForKey:@"locNum"] intValue]>0) {
        newsNum += 1;
    }
    if([[latestInfo objectForKey:@"dtcNum"] intValue]>0 || [[latestInfo objectForKey:@"locNum"] intValue]>0 || [[latestInfo objectForKey:@"alertNum"] intValue]>0){
        _theResultDict = [latestInfo mutableCopy];
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(actionIsFinish) userInfo:nil repeats:YES];
        [myTimer fire];
    }
//    _labelOfDate.text=[latestInfo objectForKey:@"resultTime"];
    if ([[latestInfo objectForKey:@"alertNum"] intValue]>0) {
        [_historyModel requestAlertsWithDeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID
                                       startDate:[NSDate dateWithTimeIntervalSince1970:0]
                                         endDate:[NSDate localDate]
                                            type:@"1"
                                             row:@"3"
                                            page:@"1"];
    }
    
    if ([[latestInfo objectForKey:@"dtcNum"] intValue]>0) {
        [_dtcsModel requestDTCsWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, @"0", nil]];
    }
    
    if ([[latestInfo objectForKey:@"locNum"] intValue]>0) {
        [_devicesModel requestDetailDeviceInfoWithArguments:[NSArray arrayWithObjects:@"",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil] isContinue:NO];
    }
//    if(clickRefreshBtn != 0){
//        clickRefreshBtn -= 1;
//        return;
//    }
    
    if([[latestInfo objectForKey:@"dtcNum"] intValue]>0 || [[latestInfo objectForKey:@"locNum"] intValue]>0 || [[latestInfo objectForKey:@"alertNum"] intValue]>0){

    }else{
        [self performSelector:@selector(requestLatestInfoWithResultTime:) withObject:[latestInfo objectForKey:@"resultTime"] afterDelay:5];
    }
}


- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _devicesModel) {
        if ([keyPath isEqualToString:KVO_DEVICE_DETAIL_PATH_NAME]) {
            locNum = 1;
            if(_devicesModel.deviceDetail==nil){
                [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
            }else{
                [self updateDetailUI];
            }
            return;
        }
    }else if (object == _vehiclesModel){
        if ([keyPath isEqualToString:KVO_VEHICLE_SETTING_CONFIG_PATH_NAME]) {
            if (_vehiclesModel.vehicleSettingConfig!=nil) {
                if ([_vehiclesModel.vehicleSettingConfig.fuel_level isEqualToString:@""]||_vehiclesModel.vehicleSettingConfig.fuel_level==nil||[_vehiclesModel.vehicleSettingConfig.fuel_level floatValue]==0.0) {
                    _oilNum=15;
                }else{
                    _oilNum=[_vehiclesModel.vehicleSettingConfig.fuel_level floatValue];
                }
                
                if ([_vehiclesModel.vehicleSettingConfig.coolant_temp isEqualToString:@""]||_vehiclesModel.vehicleSettingConfig.coolant_temp==nil||[_vehiclesModel.vehicleSettingConfig.coolant_temp floatValue]==0.0) {
                    _tempNum=105;
                }else{
                    _tempNum=[_vehiclesModel.vehicleSettingConfig.coolant_temp floatValue];
                }

                if ([_vehiclesModel.vehicleSettingConfig.rpm isEqualToString:@""]||_vehiclesModel.vehicleSettingConfig.rpm==nil||[_vehiclesModel.vehicleSettingConfig.rpm floatValue]==0.0) {
                    _RMPNum=4000;
                }else{
                    _RMPNum=[_vehiclesModel.vehicleSettingConfig.rpm floatValue];
                }

                if ([_vehiclesModel.vehicleSettingConfig.battery isEqualToString:@""]||_vehiclesModel.vehicleSettingConfig.battery==nil||[_vehiclesModel.vehicleSettingConfig.battery floatValue]==0.0) {
                    _batteryNum=11.5;
                }else{
                    _batteryNum=[_vehiclesModel.vehicleSettingConfig.battery floatValue];
                }

//                [self updateDetailUI];
            }
        }
    }else if (object==_historyModel){
        if ([keyPath isEqualToString:KVO_ALERT_PATH_NAME]) {
            alertNum = 1;
            NSDictionary* dic=[_historyModel.alerts objectAtIndex:0];
            NSString* serveDate=[dic objectForKey:@"serverDate"];
            NSString* serveTime=[dic objectForKey:@"serverTime"];
            NSDateFormatter* dateformatter=[[NSDateFormatter alloc]init];
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSDate* lastDate=[dateformatter dateFromString:[NSString stringWithFormat:@"%@ %@",serveDate,serveTime]];
            [dateformatter setDateFormat:@"MMddHHmmss"];
//            NSTimeInterval timeInterval=[lastDate timeIntervalSinceNow];
//            timeInterval=-timeInterval;
            NSString *date;
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"OBDDate"]) {
                date = [[NSUserDefaults standardUserDefaults] objectForKey:@"OBDDate"];
            }else{
                date = [dateformatter stringFromDate:lastDate];
            }
            if([date intValue] > [[dateformatter stringFromDate:lastDate] intValue]){
                _obdImgView.image=[UIImage imageNamed:@"alerts_off.png"];
            }else{
                _obdImgView.image=[UIImage imageNamed:@"summary_alert_icon.png"];
            }
//            if (timeInterval<180.0) {
//                _obdImgView.image=[UIImage imageNamed:@"summary_alert_icon.png"];
//            }else{
//                _obdImgView.image=[UIImage imageNamed:@"alerts_off.png"];
//            }
        }
    }else if (object==_dtcsModel){
        if ([keyPath isEqualToString:KVO_DTCS_PATH_NAME]) {
            dtcNum = 1;
            if ([_dtcsModel.dtcs count]>0) {
                [_dtcsModel.dtcs objectAtIndex:0];
                ADDTCBase *dtcBase = [_dtcsModel.dtcs objectAtIndex:0];
                NSDateFormatter* dateformatter=[[NSDateFormatter alloc]init];
                [dateformatter setDateFormat:@"MMddHHmmss"];
                NSString *date;
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"DTCDate"]) {
                    date = [[NSUserDefaults standardUserDefaults] objectForKey:@"DTCDate"];
                }else{
                    date = [dateformatter stringFromDate:dtcBase.readDate];
                }
                
                if([date intValue] > [[dateformatter stringFromDate:dtcBase.readDate] intValue]){
                    _dtcImgView.image=[UIImage imageNamed:@"dtc_off.png"];
                }else{
                    _dtcImgView.image=[UIImage imageNamed:@"summary_dtc_icon.png"];
                }
            }else{
                _dtcImgView.image=[UIImage imageNamed:@"dtc_off.png"];
            }
        }
    }

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

- (void)requestLatestInfoWithResultTime:(NSString *)time{
    
    [_devicesModel requestLatestInfoWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].globalUserBase.acctID,[ADSingletonUtil sharedInstance].globalUserBase.userID,[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,time, nil]];
}
- (void)handleSetTotalMilageData:(NSDictionary *)dictionary{
    if ([[dictionary objectForKey:@"resultCode"] isEqualToString:@"200"]) {
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:@"设置成功"];
        [_buttonMileage setTitle:[NSString stringWithFormat:@"%06d",[_mileageTextField.text intValue]] forState:UIControlStateNormal];
    }else{
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"未设置成功"];
    }
}
- (void)handleUpdateMeliageDate:(NSDictionary *)dictionary{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:@""];
    NSArray* data=[dictionary objectForKey:@"data"];
    NSDictionary* dic=[data objectAtIndex:0];
    if (_selectBtn.tag==0) {
        _lab2.text=[NSString stringWithFormat:@"%@ 公里",[dic objectForKey:@"cruising_distance"]];
        _lab4.text=[NSString stringWithFormat:@"%@ 公里",[dic objectForKey:@"odometer"]];
        _lab6.text=[NSString stringWithFormat:@"%@ 升/百公里",[dic objectForKey:@"average_fuel_consumption"]];
        _lab8.text=[NSString stringWithFormat:@"%@ 公里/小时",[dic objectForKey:@"average_speed"]];
    }else{
        _lab2.text=[NSString stringWithFormat:@"%@ 次",[dic objectForKey:@"tripNum"]];
        _lab4.text=[NSString stringWithFormat:@"%@ 公里",[dic objectForKey:@"odometer"]];
        _lab6.text=[NSString stringWithFormat:@"%@ 升/百公里",[dic objectForKey:@"average_fuel_consumption"]];
        _lab8.text=[NSString stringWithFormat:@"%@ 公里/小时",[dic objectForKey:@"average_speed"]];
    }
    
}
- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
