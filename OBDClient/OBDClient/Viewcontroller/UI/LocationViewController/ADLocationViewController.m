//
//  ADLocationViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADLocationViewController.h"
#import "ADMoreInfoViewController.h"
#import "NSDate+Helper.h"
#import "ADSharedModel.h"

#define TAG_ADDRESS_LABEL       30001
#define TAG_LIVE_TRACE_UIVIEW   30002
#define TAG_SPEED_LABEL         30003
#define TAG_COOLTEMP_LABEL      30004
#define TAG_RMP_LABEL           30005
#define TAG_OIL_LABEL           30006
#define TAG_BATTERY_LABEL       30007
#define TAG_SPEED_AND_VIEW      30008
#define TAG_ADDRESS_VIEW        30009

#define degreesToRadians(x) (M_PI*(x)/180.0)

@interface ADLocationViewController ()<UIActionSheetDelegate>
{
    BOOL trafficOn;
    BOOL showGeofence;
    UIButton *trafficButton;
    UIButton *phonePosButton;
    UIButton *carPosButton;
    UIButton *geofenceButton;
    UIButton *showSpeedButton;
    NSDate *updateTime;
    NSString *strUpdateTime;
    ADGeofenceModel *_geofenceModel;
    ADSharedModel *_sharedModel;
    CLLocationCoordinate2D realCoor;
    
    
    UIView *menuView; //菜单列表
}
@end

@implementation ADLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _devicesModel = [[ADDevicesModel alloc]init];
        [_devicesModel addObserver:self
                        forKeyPath:KVO_DEVICE_DETAIL_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        _geofenceModel = [[ADGeofenceModel alloc] init];
        [_geofenceModel addObserver:self
                         forKeyPath:KVO_GEOGENCE_ALL_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:NULL];
        _sharedModel = [[ADSharedModel alloc]init];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(requestDetailDeviceSuccess:)
                           name:ADDevicesModelRequestDeviceDetailSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestDetailDeviceFail:)
                           name:ADDevicesModelRequestDeviceDetailFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestDetailDeviceTimeout:)
                           name:ADDevicesModelRequestDeviceDetailTimeoutNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(requestGeogencesSuccess:)
                           name:ADGeofenceModelRequestSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestGeogencesFail:)
                           name:ADGeofenceModelRequestFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestGeogencesTiemout:)
                           name:ADGeofenceModelRequestTimeoutNotification
                         object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADDevicesModelLoginTimeOutNotification
                                                   object:nil];
    }
    return self;
}


- (void)dealloc
{
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_DEVICE_DETAIL_PATH_NAME];
    [_geofenceModel removeObserver:self
                        forKeyPath:KVO_GEOGENCE_ALL_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestDeviceDetailSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestDeviceDetailFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestDeviceDetailTimeoutNotification
                        object:nil];
    if (_mapView) {
        _mapView = nil;
    }
    [_devicesModel cancel];
    [_geofenceModel cancel];
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    [_mapView setShowsUserLocation:NO];
    [_mapView setZoomLevel:17];
    [self beginRequestAllGeofencesWithDeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID];
//    if(_devicesModel.deviceDetail!=nil){
//        [self updateMap];
//    }else{
//        [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(31.2105889593161, 121.492910330211)];
//        [_mapView setZoomLevel:12];
//    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    trafficOn=NO;
    [_mapView setMapType:BMKMapTypeStandard];
    _mapView.showsUserLocation = NO;//显示定位图层
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
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

- (IBAction)mainTap:(id)sender
{
    [self navigateToViewControllerByClassName:@"CarAssistantViewController"];
}

- (IBAction)summeryTap:(id)sender
{
    [self navigateToViewControllerByClassName:@"ADSummaryFinalViewController"];
}

- (IBAction)moreBtnTap:(id)sender
{
    menuView.hidden = menuView.hidden?NO:YES;
}

- (IBAction)geofenceTap:(id)sender
{
    menuView.hidden = YES;
    [_devicesModel cancel];
    UIViewController *viewController = [[ADiPhoneGeofenceViewController alloc] initWithNibName:nil bundle:nil deviceBase:[ADSingletonUtil sharedInstance].currentDeviceBase];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)moreTap:(id)sender
{
    menuView.hidden = YES;
    [_devicesModel cancel];
    ADMoreInfoViewController *moreView=[[ADMoreInfoViewController alloc]init];
    
    [self.navigationController pushViewController:moreView animated:YES];
}

- (IBAction)shareToWXTap:(id)sender
{
    menuView.hidden = YES;
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择微信分享方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享给微信好友" otherButtonTitles:@"分享到朋友圈", nil];
    actionSheet.delegate=self;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSString *url=[[NSString stringWithFormat:@"http://180.166.124.142:9983/obd_wx/location.php?markers=%f,%f&licenseNumber=%@&center=%f,%f&zoom=13&address=%@&updateTime=%@&speed=%f&high_temp=%@&engineRPM=%@&fuel_level_now=%f&batt_level=%f",realCoor.longitude,realCoor.latitude,[ADSingletonUtil sharedInstance].currentDeviceBase.licenseNumber,realCoor.longitude,realCoor.latitude,_devicesModel.deviceDetail.address_num,[updateTime toStringHasTime:YES],_devicesModel.deviceDetail.speed,_devicesModel.deviceDetail.high_temp,_devicesModel.deviceDetail.engineRPM,_devicesModel.deviceDetail.fuel_level_now,_devicesModel.deviceDetail.batt_level] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    NSLog(@"%@",url);
    
    switch (buttonIndex) {
        case 0:
            [_sharedModel changeScene:0];
            [_sharedModel sendLinkContentWithTitle:@"我的车辆位置" description:_locationAddressLabel.text image:@"icon.png" url:url];
            break;
        case 1:
            [_sharedModel changeScene:1];
            [_sharedModel sendLinkContentWithTitle:@"我的车辆位置" description:_locationAddressLabel.text image:@"icon.png" url:url];
            break;
        default:
            break;
    }
    
}

- (IBAction)showvehicleLocation:(id)sender{
//    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//    CLLocationCoordinate2D coor;
//    coor.latitude = self.devicesModel.deviceDetail.latitude;
//    coor.longitude = self.devicesModel.deviceDetail.longitude;
//    NSDictionary *tip = BMKBaiduCoorForWgs84(coor);
//    //纠偏
//    CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
//    annotation.coordinate = coordinate;
//    [_mapView setZoomLevel:16];
//    [_mapView setCenterCoordinate:coordinate animated:YES];
    
    if(_mapView.annotations.count>0){
        BMKPointAnnotation *annotation=_mapView.annotations[0];
        [_mapView setCenterCoordinate:annotation.coordinate animated:YES];
    }
    
}

- (IBAction)showGeofences:(id)sender{
//    UIView *speedAndView = (UIView *)[self.view viewWithTag:TAG_SPEED_AND_VIEW];
//    [self hidden:speedAndView enable:showGeofence];
    if (showGeofence) {
        [geofenceButton setBackgroundImage:[UIImage imageNamed:@"geofence_off.png"] forState:UIControlStateNormal];
        [_mapView removeOverlays:[_mapView.overlays copy]];
        //remove
    }else{
        [geofenceButton setBackgroundImage:[UIImage imageNamed:@"gefence_on.png"] forState:UIControlStateNormal];
        for(int i=0;i<_geofenceModel.geogences.count;i++){
            ADGeofenceBase *gefence=[_geofenceModel.geogences objectAtIndex:i];
            if (![gefence.cmdType isEqualToString:@"0"]) {
                [self addGeofenceToMap:gefence];
            }
        }
        //add
    }
    showGeofence=showGeofence?NO:YES;
    
}

-(void)showSpeedView:(id)sender{
    UIView *speedAndView = (UIView *)[self.view viewWithTag:TAG_SPEED_AND_VIEW];
    [self hidden:speedAndView enable:!speedAndView.hidden];
//    UIView *addressView = (UIView *)[self.view viewWithTag:TAG_ADDRESS_VIEW];
//    [self hidden:addressView enable:!addressView.hidden];
    if (speedAndView.hidden) {
        [showSpeedButton setBackgroundImage:[UIImage imageNamed:@"btn_day_press.png"] forState:UIControlStateNormal];
    }else{
        [showSpeedButton setBackgroundImage:[UIImage imageNamed:@"btn_day_normal.png"] forState:UIControlStateNormal];
    }
}

-(IBAction)showPhoneLocation:(id)sender{
    if(_mapView.showsUserLocation){
        _mapView.showsUserLocation = NO;
        [phonePosButton setBackgroundImage:[UIImage imageNamed:@"phone_position.png"] forState:UIControlStateNormal];
        
    }else{
        _mapView.showsUserLocation = YES;
        [phonePosButton setBackgroundImage:[UIImage imageNamed:@"phone_position_on.png"] forState:UIControlStateNormal];
    }
    
    //显示定位图层
}

//- (void)mapView:(BMKMapView *)mapView didUpdateUserLocation:(BMKUserLocation *)userLocation{
//    CLLocationCoordinate2D coor;
//    coor.latitude                   = _mapView.userLocation.coordinate.latitude;
//    coor.longitude                  = _mapView.userLocation.coordinate.longitude;
//    [_mapView setCenterCoordinate:coor animated:YES];
//}

- (IBAction)showTraffic:(id)sender{
    if(trafficOn){
        trafficOn=NO;
        [trafficButton setBackgroundImage:[UIImage imageNamed:@"traffic_off.png"] forState:UIControlStateNormal];
        [_mapView setMapType:BMKMapTypeStandard];
    }else{
        trafficOn=YES;
        [trafficButton setBackgroundImage:[UIImage imageNamed:@"traffic_on.png"] forState:UIControlStateNormal];
        [_mapView setMapType:BMKMapTypeStandard];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.title=NSLocalizedStringFromTable(@"locationKey",@"MyString", @"");
    trafficOn = NO;
    showGeofence = YES;
//    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"geofenceKey",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(geofenceTap:)];
//
//    UIBarButtonItem *barButton2=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"detailedKey",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(moreTap:)];
//    
//    UIBarButtonItem *barButtomWX=[[UIBarButtonItem alloc]initWithTitle:@"微信分享" style:UIBarButtonItemStyleBordered target:self action:@selector(shareToWXTap:)];
//    
//    UIBarButtonItem *superButtonItem = self.navigationItem.rightBarButtonItem;
//    
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:barButtomWX,barButton2, barButton,superButtonItem, nil]];
//    
//    if (IOS7_OR_LATER) {
//        barButton.tintColor=[UIColor lightGrayColor];
//        barButton2.tintColor=[UIColor lightGrayColor];
//        barButtomWX.tintColor=[UIColor lightGrayColor];
//        superButtonItem.tintColor=[UIColor lightGrayColor];
//    }
    UIBarButtonItem *mainButton=[[UIBarButtonItem alloc]initWithTitle:@"首页" style:UIBarButtonItemStyleBordered target:self action:@selector(mainTap:)];
    UIBarButtonItem *summeryButton=[[UIBarButtonItem alloc]initWithTitle:@"仪表盘" style:UIBarButtonItemStyleBordered target:self action:@selector(summeryTap:)];
    UIBarButtonItem *moreButton=[[UIBarButtonItem alloc]initWithTitle:@"更多" style:UIBarButtonItemStyleBordered target:self action:@selector(moreBtnTap:)];
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:moreButton,summeryButton, mainButton, nil]];
    if (IOS7_OR_LATER) {
        mainButton.tintColor=[UIColor lightGrayColor];
        summeryButton.tintColor=[UIColor lightGrayColor];
        moreButton.tintColor=[UIColor lightGrayColor];
    }

    
    CGRect frame = self.navigationController.navigationBar.frame;
    frame.origin.y += 44;
    frame.origin.x = WIDTH-70;
    frame.size.width = 70;
    frame.size.height = 90;
    menuView = [[UIView alloc] initWithFrame:frame];
    menuView.backgroundColor = [UIColor grayColor];
    
    UIButton *batBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    batBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    batBtn.layer.borderWidth = 0.3;
    batBtn.frame = CGRectMake(0, 0, 70, 30);
    [batBtn setTitle:NSLocalizedStringFromTable(@"geofenceKey",@"MyString", @"") forState:UIControlStateNormal];
    [batBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    batBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [batBtn addTarget:self action:@selector(geofenceTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *batBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    batBtn1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    batBtn1.layer.borderWidth = 0.3;
    batBtn1.frame = CGRectMake(0, 30, 70, 30);
    [batBtn1 setTitle:NSLocalizedStringFromTable(@"detailedKey",@"MyString", @"") forState:UIControlStateNormal];
    [batBtn1 setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    batBtn1.titleLabel.font = [UIFont systemFontOfSize:13];
    [batBtn1 addTarget:self action:@selector(moreTap:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *batBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    batBtn2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    batBtn2.layer.borderWidth = 0.3;
    batBtn2.frame = CGRectMake(0, 60, 70, 30);
    [batBtn2 setTitle:@"分享" forState:UIControlStateNormal];
    [batBtn2 setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    batBtn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [batBtn2 addTarget:self action:@selector(shareToWXTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [menuView addSubview:batBtn];
    [menuView addSubview:batBtn1];
    [menuView addSubview:batBtn2];
    menuView.hidden = YES;
    
    
    //map:
    if(!_mapView)
        _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-74)];
//    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    trafficButton = [[UIButton alloc]init];
    [trafficButton addTarget:self action:@selector(showTraffic:) forControlEvents:UIControlEventTouchUpInside];
    trafficButton.titleLabel.text = @"实时路况";
    trafficButton.frame = CGRectMake(WIDTH-40, 60+64, 33, 33);
    [trafficButton setBackgroundImage:[UIImage imageNamed:@"traffic_off.png"] forState:UIControlStateNormal];
    [self.view addSubview:trafficButton];
    
    phonePosButton = [[UIButton alloc]init];
    [phonePosButton addTarget:self action:@selector(showPhoneLocation:) forControlEvents:UIControlEventTouchUpInside];
    phonePosButton.titleLabel.text = @"手机位置";
    phonePosButton.frame = CGRectMake(WIDTH-37, 95+64, 28, 30);
    [phonePosButton setBackgroundImage:[UIImage imageNamed:@"phone_position.png"] forState:UIControlStateNormal];
    [self.view addSubview:phonePosButton];
    
    carPosButton = [[UIButton alloc]init];
    [carPosButton addTarget:self action:@selector(showvehicleLocation:) forControlEvents:UIControlEventTouchUpInside];
    carPosButton.titleLabel.text = @"车辆位置";
    carPosButton.frame = CGRectMake(WIDTH-37, 125+64, 28, 30);
    [carPosButton setBackgroundImage:[UIImage imageNamed:@"car_position.png"] forState:UIControlStateNormal];
    [self.view addSubview:carPosButton];
    
    geofenceButton = [[UIButton alloc]init];
    [geofenceButton addTarget:self action:@selector(showGeofences:) forControlEvents:UIControlEventTouchUpInside];
    geofenceButton.tag=10001;
    geofenceButton.frame = CGRectMake(WIDTH-37, 155+64, 28, 30);
    [geofenceButton setBackgroundImage:[UIImage imageNamed:@"gefence_on.png"] forState:UIControlStateNormal];
    [self.view addSubview:geofenceButton];
    
    showSpeedButton =[[UIButton alloc]init];
    [showSpeedButton addTarget:self action:@selector(showSpeedView:) forControlEvents:UIControlEventTouchUpInside];
    showSpeedButton.tag=10002;
    showSpeedButton.frame = CGRectMake(WIDTH-37, 185+64, 28, 30);
    [showSpeedButton setBackgroundImage:[UIImage imageNamed:@"btn_day_normal.png"] forState:UIControlStateNormal];
    [self.view addSubview:showSpeedButton];
    
    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-79, WIDTH, 80)];
    _locationAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, WIDTH-50, 80)];
    _locationAddressLabel.backgroundColor=[UIColor clearColor];
    _locationAddressLabel.textColor=[UIColor darkGrayColor];
    _locationAddressLabel.font=[UIFont boldSystemFontOfSize:14];
    _locationAddressLabel.numberOfLines=2;
    _locationAddressLabel.text=@"";
//    addressView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"map_location.png"]];
    addressView.tag=TAG_ADDRESS_VIEW;
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 80)];
    imageview.image = [UIImage imageNamed:@"map_location.png"];
    [addressView addSubview:imageview];
    [addressView addSubview:_locationAddressLabel];
    
    
    UIButton* startBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-40, 15, 40, 45)];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"start.png"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startNavigation) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setBackgroundColor:[UIColor clearColor]];
    [addressView addSubview:startBtn];
    
    [self.view addSubview:addressView];
    addressView.hidden=NO;

    
    
    UIView *speedAndView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 50)];
    speedAndView.tag = TAG_SPEED_AND_VIEW;
    UIImageView* bgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    bgImgView.image=[UIImage imageNamed:@"location_speed.png"];
    [speedAndView addSubview:bgImgView];

    _locationSpeedLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH/5.0, 50)];  //speed的label
    _locationSpeedLabel.backgroundColor=[UIColor clearColor];
    _locationSpeedLabel.textColor=[UIColor darkGrayColor];
    _locationSpeedLabel.font=[UIFont boldSystemFontOfSize:12];
    _locationSpeedLabel.textAlignment=UITextAlignmentCenter;
    _locationSpeedLabel.tag = TAG_SPEED_LABEL;
    _locationSpeedLabel.text=[NSString stringWithFormat:@"%@:0KM/H",NSLocalizedStringFromTable(@"speedKey",@"MyString", @"")];
    _locationSpeedLabel.numberOfLines=0;
    _locationSpeedLabel.lineBreakMode=UILineBreakModeWordWrap;
    [speedAndView addSubview:_locationSpeedLabel];
    
    
    _locationCoolTempLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/5.0*1, 0, WIDTH/5.0, 50)];  //speed的label
    _locationCoolTempLabel.backgroundColor=[UIColor clearColor];
    _locationCoolTempLabel.textColor=[UIColor darkGrayColor];
    _locationCoolTempLabel.font=[UIFont boldSystemFontOfSize:12];
    _locationCoolTempLabel.textAlignment=UITextAlignmentCenter;
    _locationCoolTempLabel.tag = TAG_COOLTEMP_LABEL;
    _locationCoolTempLabel.text=[NSString stringWithFormat:@"%@:\n0℃",NSLocalizedStringFromTable(@"coolKey",@"MyString", @"")];
    _locationCoolTempLabel.numberOfLines=0;
    _locationCoolTempLabel.lineBreakMode=UILineBreakModeWordWrap;
    [speedAndView addSubview:_locationCoolTempLabel];
    
    _locationRMPLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/5.0*2, 0, WIDTH/5.0, 50)];  //speed的label
    _locationRMPLabel.backgroundColor=[UIColor clearColor];
    _locationRMPLabel.textColor=[UIColor darkGrayColor];
    _locationRMPLabel.font=[UIFont boldSystemFontOfSize:12];
    _locationRMPLabel.textAlignment=UITextAlignmentCenter;
    _locationRMPLabel.tag = TAG_RMP_LABEL;
    _locationRMPLabel.text=[NSString stringWithFormat:@"%@:0r/min",NSLocalizedStringFromTable(@"enginePRM",@"MyString", @"")];
    _locationRMPLabel.numberOfLines=0;
    _locationRMPLabel.lineBreakMode=UILineBreakModeWordWrap;

    [speedAndView addSubview:_locationRMPLabel];

    _locationOilLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/5.0*3, 0, WIDTH/5.0, 50)]; //oil的label
    _locationOilLabel.backgroundColor=[UIColor clearColor];
    _locationOilLabel.textColor=[UIColor darkGrayColor];
    _locationOilLabel.font=[UIFont boldSystemFontOfSize:12];
    _locationOilLabel.textAlignment=UITextAlignmentCenter;
    _locationOilLabel.tag = TAG_OIL_LABEL;
    _locationOilLabel.text=[NSString stringWithFormat:@"%@:\n0%%",NSLocalizedStringFromTable(@"oilKey",@"MyString", @"")];
    _locationOilLabel.numberOfLines=0;
    _locationOilLabel.lineBreakMode=UILineBreakModeWordWrap;
    [speedAndView addSubview:_locationOilLabel];
    
    _locationBatteryLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/5.0*4, 0, WIDTH/5.0, 50)]; //oil的label
    _locationBatteryLabel.backgroundColor=[UIColor clearColor];
    _locationBatteryLabel.textColor=[UIColor darkGrayColor];
    _locationBatteryLabel.font=[UIFont boldSystemFontOfSize:12];
    _locationBatteryLabel.textAlignment=UITextAlignmentCenter;
    _locationBatteryLabel.tag = TAG_BATTERY_LABEL;
    _locationBatteryLabel.text=[NSString stringWithFormat:@"%@:\n0v",NSLocalizedStringFromTable(@"batteryKey",@"MyString", @"")];
    _locationBatteryLabel.numberOfLines=0;
    _locationBatteryLabel.lineBreakMode=UILineBreakModeWordWrap;

    [speedAndView addSubview:_locationBatteryLabel];
    
    
//    speedAndView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"map_location.png"]];

    [self.view addSubview:speedAndView];
    speedAndView.hidden=NO;
    
    /*
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [trafficButton setFrame:CGRectMake(260, 124, 33, 33)];
        [phonePosButton setFrame:CGRectMake(263, 159, 28, 30)];
        [carPosButton setFrame:CGRectMake(263, 189, 28, 30)];
        [geofenceButton setFrame:CGRectMake(263, 219, 28, 30)];
        [showSpeedButton setFrame:CGRectMake(263, 249, 28, 30)];
        [addressView setFrame:CGRectMake(0, 406, WIDTH, 74)];
        [speedAndView setFrame:CGRectMake(0, 64, WIDTH, 50)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [addressView setFrame:CGRectMake(0, 430, WIDTH, 74)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [trafficButton setFrame:CGRectMake(260, 124, 33, 33)];
        [phonePosButton setFrame:CGRectMake(263, 159, 28, 30)];
        [carPosButton setFrame:CGRectMake(263, 189, 28, 30)];
        [geofenceButton setFrame:CGRectMake(263, 219, 28, 30)];
        [showSpeedButton setFrame:CGRectMake(263, 249, 28, 30)];
        [addressView setFrame:CGRectMake(0, 494, WIDTH, 74)];
        [speedAndView setFrame:CGRectMake(0, 64, WIDTH, 50)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    */
    [self.view addSubview:menuView];
    
    [_devicesModel requestDetailDeviceInfoWithArguments:[NSArray arrayWithObjects:@"",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,nil] isContinue:YES];
}

- (void)beginRequestAllGeofencesWithDeviceID:(NSString *)aDeviceID
{
    [_geofenceModel requestGeofencesWithDeviceID:aDeviceID];
}

-(void)hidden:(UIView*)view enable:(BOOL)enable{
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionFade;
    animation.duration = 0.8;
    [view.layer addAnimation:animation forKey:nil];
    
    view.hidden = enable;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _devicesModel) {
        if ([keyPath isEqualToString:KVO_DEVICE_DETAIL_PATH_NAME]) {
            if(_devicesModel.deviceDetail==nil){
                [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
                _locationAddressLabel.text=NSLocalizedStringFromTable(@"noLocation",@"MyString", @"");
            }else{
                [self updateMap];
            }
            
            return;
        }
    }
    if (object == _geofenceModel) {
        if ([keyPath isEqualToString:KVO_GEOGENCE_ALL_PATH_NAME]) {
            if(_geofenceModel.geogences.count>0){
                if([_mapView.overlays count]!=0){
                    [_mapView removeOverlays:[_mapView.overlays copy]];
                }
                for(int i=0;i<_geofenceModel.geogences.count;i++){
                    ADGeofenceBase *gefence=[_geofenceModel.geogences objectAtIndex:i];
                    if (![gefence.cmdType isEqualToString:@"0"]) {
                        [self addGeofenceToMap:gefence];
                    }
                }
            }else{
                
            }
            NSLog(@"%d",_geofenceModel.geogences.count);
            
            return;
        }
    }

    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)addGeofenceToMap:(ADGeofenceBase*)aGeofence
{
//#ifdef circle
    if([aGeofence.pCount isEqual:@"0"]){
        CLLocationCoordinate2D coor = {aGeofence.lat1, aGeofence.lng1};
        BMKCircle* circle1 = [BMKCircle circleWithCenterCoordinate:coor radius:aGeofence.radius];
        circle1.title=@"geofence";
        [_mapView addOverlay:circle1];
    }
//#else
    else{
        CLLocationCoordinate2D coords[4] = {0};
        coords[0].latitude = aGeofence.lat1;
        coords[0].longitude = aGeofence.lng1;
        coords[1].latitude = aGeofence.lat2;
        coords[1].longitude = aGeofence.lng2;
        coords[2].latitude = aGeofence.lat3;
        coords[2].longitude = aGeofence.lng3;
        coords[3].latitude = aGeofence.lat4;
        coords[3].longitude = aGeofence.lng4;
        BMKPolygon* polygon = [BMKPolygon polygonWithCoordinates:coords count:4];
        [_mapView addOverlay:polygon];
        
    }

//#endif
}

- (void)requestDetailDeviceSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
//    [self beginRequestAllGeofencesWithDeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID];
}

- (void)requestDetailDeviceFail:(NSNotification *)aNoti
{
//    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    _locationAddressLabel.text=NSLocalizedStringFromTable(@"noLocation",@"MyString", @"");
}

- (void)requestDetailDeviceTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)updateMap
{
    if([_mapView.annotations count]!=0){
        [_mapView removeAnnotations:_mapView.annotations];
    }
    
//    UILabel *labelOfDate = (UILabel*)[self.view viewWithTag:TAG_LABEL_LAST_UPDATED_DATE];
    NSString *stringTime=_devicesModel.deviceDetail.gpsTime;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSString *stringDate = _devicesModel.deviceDetail.gpsDate;
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *update_time=[[NSString stringWithFormat:@"%@ %@",stringDate,stringTime] dateFromStringHasTime:YES];
    strUpdateTime=[update_time toStringHasTime:YES];
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    if([self.devicesModel.deviceDetail.ign isEqualToString:@"0"]){
        annotation.subtitle=@"ign_off";
    }else{
        annotation.subtitle=@"ign_on";
    }
    CLLocationCoordinate2D coor;
    coor.latitude = self.devicesModel.deviceDetail.latitude;
    coor.longitude = self.devicesModel.deviceDetail.longitude;
//<<<<<<< .mine
    if ([_devicesModel.deviceDetail.ign isEqualToString:@"1"] && [_devicesModel.deviceDetail.onLineStatus isEqualToString:@"1"]) {
        if (coor.latitude!=0&&coor.longitude!=0) {     //启动 在线 最新位置有效
            _locationAddressLabel.text = [NSString stringWithFormat:@"%@：%@\n%@：%@",NSLocalizedStringFromTable(@"currentPositionKey",@"MyString", @""),self.devicesModel.deviceDetail.address_num,NSLocalizedStringFromTable(@"latestUpdateTime",@"MyString", @""),strUpdateTime];
        }else if (coor.latitude==0&&coor.longitude==0){  //启动 在线 最新位置无效
            if (_devicesModel.deviceDetail.lastLocation==nil) {    //最近位置无效
                _locationAddressLabel.text = @"您的车辆尚无有效定位记录";
                coor.latitude=121.506296;
                coor.longitude=31.245704;
            }else{    //最近位置有效
                if([_devicesModel.deviceDetail.lastLocation objectForKey:@"latitude"]==[NSNull null]||[_devicesModel.deviceDetail.lastLocation objectForKey:@"longitude"]==[NSNull null]){
                    coor.latitude = [[self.devicesModel.deviceDetail.lastLocation objectForKey:@"latitude"] floatValue];
                    coor.longitude = [[self.devicesModel.deviceDetail.lastLocation objectForKey:@"longitude"] floatValue];
                    _locationAddressLabel.text = [NSString stringWithFormat:@"%@：%@\n%@：%@",NSLocalizedStringFromTable(@"lastPositionKey",@"MyString", @""),self.devicesModel.deviceDetail.address_num,NSLocalizedStringFromTable(@"latestUpdateTime",@"MyString", @""),strUpdateTime];
                }
            }
        }
    }else{
        if (coor.latitude!=0&&coor.longitude!=0) {
            _locationAddressLabel.text = [NSString stringWithFormat:@"%@：%@\n%@：%@",NSLocalizedStringFromTable(@"lastPositionKey",@"MyString", @""),self.devicesModel.deviceDetail.address_num,NSLocalizedStringFromTable(@"latestUpdateTime",@"MyString", @""),strUpdateTime];
        }else if (coor.latitude==0&&coor.longitude==0){
            NSLog(@"%@",[self.devicesModel.deviceDetail.lastLocation objectForKey:@"longitude"]);
//            if([[self.devicesModel.deviceDetail.lastLocation objectForKey:@"latitude"] isEqualToString:@"<null>"]||[[self.devicesModel.deviceDetail.lastLocation objectForKey:@"longitude"] isEqualToString:@"<null>"]){
            if([_devicesModel.deviceDetail.lastLocation objectForKey:@"latitude"]==[NSNull null]||[_devicesModel.deviceDetail.lastLocation objectForKey:@"longitude"]==[NSNull null]){
            }else{
                coor.latitude = [[self.devicesModel.deviceDetail.lastLocation objectForKey:@"latitude"] floatValue];
                coor.longitude = [[self.devicesModel.deviceDetail.lastLocation objectForKey:@"longitude"] floatValue];
            }
            _locationAddressLabel.text = [NSString stringWithFormat:@"%@：%@\n%@：%@",NSLocalizedStringFromTable(@"lastPositionKey",@"MyString", @""),self.devicesModel.deviceDetail.address_num,NSLocalizedStringFromTable(@"latestUpdateTime",@"MyString", @""),strUpdateTime];
        }
    }
    
    
            NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
            //纠偏
            CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
            annotation.coordinate = coordinate;
            [_mapView addAnnotation:annotation];
            
            if(!_mapView.showsUserLocation&&![updateTime isEqualToDate:update_time]){
                NSLog(@"lastlocation");
                [_mapView setCenterCoordinate:coordinate animated:YES];
//                [_mapView setZoomLevel:16];
            }
            realCoor=coordinate;
    updateTime=update_time;
    
    UILabel *labelOfSpeed = (UILabel *)[self.view viewWithTag:TAG_SPEED_LABEL];
    labelOfSpeed.text = [NSString stringWithFormat:@"%@:\n%dKM/H",NSLocalizedStringFromTable(@"speedKey",@"MyString", @""),(int)(self.devicesModel.deviceDetail.speed)];
    
    UILabel *labelOfCoolTemp = (UILabel *)[self.view viewWithTag:TAG_COOLTEMP_LABEL];
    labelOfCoolTemp.text = [NSString stringWithFormat:@"%@:\n%.1f℃",NSLocalizedStringFromTable(@"coolKey",@"MyString", @""),(float)([self.devicesModel.deviceDetail.high_temp floatValue])];
    
    UILabel *labelOfRMP = (UILabel *)[self.view viewWithTag:TAG_RMP_LABEL];
    labelOfRMP.text = [NSString stringWithFormat:@"%@:\n%.0fr/min",NSLocalizedStringFromTable(@"enginePRM",@"MyString", @""),(float)([self.devicesModel.deviceDetail.engineRPM floatValue])];

    UILabel *labelOfOil = (UILabel *)[self.view viewWithTag:TAG_OIL_LABEL];
    labelOfOil.text = [NSString stringWithFormat:@"%@:\n%d%%",NSLocalizedStringFromTable(@"oilKey",@"MyString", @""),(int)(self.devicesModel.deviceDetail.fuel_level_now)];
    
    UILabel *labelOfBattery = (UILabel *)[self.view viewWithTag:TAG_BATTERY_LABEL];
    labelOfBattery.text = [NSString stringWithFormat:@"%@:\n%.0fv",NSLocalizedStringFromTable(@"batteryKey",@"MyString", @""),(float)(self.devicesModel.deviceDetail.batt_level)];
}

#pragma mark -BMKDelegate
// Override
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]){
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 4.0;
        return circleView;
    }else if ([overlay isKindOfClass:[BMKPolygon class]]){
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.3];
        polygonView.lineWidth = 4.0;
        
        return polygonView;
    }
    return nil;
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView
             viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                   reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.enabled=NO;
        newAnnotationView.enabled3D=YES;
        newAnnotationView.animatesDrop = NO;//标注的动画效果.
//        if ([annotation.subtitle isEqualToString:@"ign_off"]) {
//            newAnnotationView.image = [UIImage imageNamed:@"grayCar.png"];
//        }else if ([annotation.subtitle isEqualToString:@"disconn"]){
//            newAnnotationView.image = [UIImage imageNamed:@"car_disconn.png"];
//        }
//        else{
//            newAnnotationView.image = [UIImage imageNamed:@"car.png"];
//        }
        
        if ([_devicesModel.deviceDetail.ign isEqualToString:@"1"] && [_devicesModel.deviceDetail.onLineStatus isEqualToString:@"1"]) {
            if (newAnnotationView.annotation.coordinate.latitude!=0 && newAnnotationView.annotation.coordinate.longitude!=0) {
                newAnnotationView.image=[UIImage imageNamed:@"car.png"];
            }else{
                newAnnotationView.image=[UIImage imageNamed:@"car_disconn.png"];
            }
        }else{
            newAnnotationView.image=[UIImage imageNamed:@"grayCar.png"];
        }

        CGFloat heading=[_devicesModel.deviceDetail.heading floatValue];
        heading+=90.0;

//        CABasicAnimation* animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//        animation.toValue=[NSNumber numberWithFloat:degreesToRadians(heading)];
//        animation.duration=1.0f;
//        animation.cumulative=YES;
//        animation.repeatCount=0;
//        animation.fillMode=kCAFillModeForwards;
//        animation.removedOnCompletion = NO;
//        [newAnnotationView.layer addAnimation:animation forKey:nil];       //同样可行
        newAnnotationView.image=[self rotateImageWithRadian:degreesToRadians(heading) cropMode:enSvCropExpand drawView:newAnnotationView];
        return newAnnotationView;
        NSLog(@"width:%f,height:%f",newAnnotationView.frame.size.width,newAnnotationView.frame.size.height);
    }
    return nil;
    
}


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    UIView *labelOfSpeed = (UIView *)[self.view viewWithTag:11];
    UIView *labelOfAddress = (UIView *)[self.view viewWithTag:12];
    [self hidden:labelOfAddress enable:NO];
    [self hidden:labelOfSpeed enable:NO];
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view{
//    UIView *labelOfSpeed = (UIView *)[self.view viewWithTag:11];
//    UIView *labelOfAddress = (UIView *)[self.view viewWithTag:12];
//    [self hidden:labelOfAddress enable:YES];
//    [self hidden:labelOfSpeed enable:YES];
}

- (void)startNavigation{
//    [_mapView setShowsUserLocation:YES];
//    NaviPara* para=[[NaviPara alloc]init];
//    para.naviType=NAVI_TYPE_WEB;
    BMKPlanNode* start=[[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coorStart;
//    coorStart.latitude=_mapView.userLocation.coordinate.latitude;
//    coorStart.longitude=_mapView.userLocation.coordinate.longitude;
//    coorStart.latitude=121.442912;
//    coorStart.longitude=31.194811;
    start.pt=coorStart;
//    para.startPoint=start;
    
    BMKPlanNode* end=[[BMKPlanNode alloc]init];
    CLLocationCoordinate2D coorEnd;
    
    coorEnd.latitude = self.devicesModel.deviceDetail.latitude;
    coorEnd.longitude = self.devicesModel.deviceDetail.longitude;
    
    if ([_devicesModel.deviceDetail.ign isEqualToString:@"1"] && [_devicesModel.deviceDetail.onLineStatus isEqualToString:@"1"]) {
        if (coorEnd.latitude==0&&coorEnd.longitude==0){  //启动 在线 最新位置无效
            if (_devicesModel.deviceDetail.lastLocation==nil) {    //最近位置无效
                coorEnd.latitude=121.506296;
                coorEnd.longitude=31.245704;
            }else{
                coorEnd.latitude = [[self.devicesModel.deviceDetail.lastLocation objectForKey:@"latitude"] floatValue];
                coorEnd.longitude = [[self.devicesModel.deviceDetail.lastLocation objectForKey:@"longitude"] floatValue];
            }
        }
    }
    
    NSDictionary *tip = BMKConvertBaiduCoorFrom(coorEnd, BMK_COORDTYPE_COMMON);
    //纠偏
    CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
    coorEnd = coordinate;
    
    end.pt=coorEnd;
//    para.endPoint=end;
//    para.appName=[NSString stringWithFormat:@"%@",@"testAppName"];
//    [BMKNavigation openBaiduMapNavigation:para];
    
}


- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

#pragma mark - notification handle
- (void)requestGeogencesSuccess:(NSNotification *)aNoti
{
    //    [_tableView setEditing:NO];
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)requestGeogencesFail:(NSNotification *)aNoti
{
    //    [_tableView setEditing:NO];
    //[IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)requestGeogencesTimeout:(NSNotification *)aNoti
{
    //    [_tableView setEditing:NO];
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (UIImage*)rotateImageWithRadian:(CGFloat)radian cropMode:(SvCropMode)cropMode drawView:(BMKAnnotationView*)ImgView
{
    CGSize imgSize = CGSizeMake(ImgView.frame.size.width, ImgView.frame.size.height);
    CGSize outputSize = imgSize;
    if (cropMode == enSvCropExpand) {
        CGRect rect = CGRectMake(0, 0, imgSize.width, imgSize.height);
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(radian));
        outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, radian);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    
    [ImgView.image drawInRect:CGRectMake(0, 0, imgSize.width, imgSize.height)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGRect imageRrect = CGRectMake(0, 0,ImgView.frame.size.width, ImgView.frame.size.height);
    UIGraphicsBeginImageContext(imageRrect.size);
//    [ImgView.image drawInRect:CGRectMake(1,1,ImgView.frame.size.width-2,ImgView.frame.size.height-2)];
    [ImgView.image drawInRect:CGRectMake(10,10,ImgView.frame.size.width-20,ImgView.frame.size.height-20)];

    ImgView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    
    return image;
}

@end
