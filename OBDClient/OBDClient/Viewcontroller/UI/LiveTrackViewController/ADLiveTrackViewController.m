//
//  ADLiveTrackViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-10.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADLiveTrackViewController.h"

@interface ADLiveTrackViewController ()

@end

@implementation ADLiveTrackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _devicesModel = [[ADDevicesModel alloc] init];
        [_devicesModel addObserver:self
                        forKeyPath:KVO_DEVICE_DETAIL_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestFail:)
                                                     name:ADDevicesModelRequestDeviceDetailFailNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestSuccess:)
                                                     name:ADDevicesModelRequestDeviceDetailSuccessNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestTimeout:)
                                                     name:ADDevicesModelRequestDeviceDetailTimeoutNotification
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADDevicesModelRequestDeviceDetailFailNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADDevicesModelRequestDeviceDetailSuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADDevicesModelRequestDeviceDetailTimeoutNotification
                                                  object:nil];
    [_devicesModel cancel];
}

- (void)requestDetailDeviceID:(NSString *)aDeviceID
{
    [IVToastHUD showAsToastWithStatus:@"正在加载..."];
    [_devicesModel requestDetailDeviceInfoWithArguments:[NSArray arrayWithObjects:@"", aDeviceID, nil]
                                             isContinue:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"时时追踪";
    
    UIView *viewOfGauge = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 170)];
    viewOfGauge.backgroundColor = [UIColor yellowColor];
    
    _sppedGaugeView = [[ADGaugeView alloc] initWithFrame:CGRectMake(20, 20, 120, 120)
                                                minValue:0
                                                maxValue:180
                                                minDegree:-140
                                                maxDegree:132
                                              totalMarks:10
                                             pointerSize:CGSizeMake(5, 55)
                                                 bgImage:[UIImage imageNamed:@"location_indicator.png"]
                                            pointerImage:[UIImage imageNamed:@"location_speed_pointer.png"]
                                           initValue:-140
                                          pointerYOffset:NSNotFound];
    [viewOfGauge addSubview:_sppedGaugeView];
    
    _oilGaugeView = [[ADGaugeView alloc] initWithFrame:CGRectMake(200, 20, 100, 100)
                                              minValue:0
                                              maxValue:180
                                              minDegree:0
                                              maxDegree:180
                                            totalMarks:10
                                           pointerSize:CGSizeMake(5, 40)
                                               bgImage:[UIImage imageNamed:@"location_oil_indicator.png"]
                                          pointerImage:[UIImage imageNamed:@"location_oil_pointer.png"]
                                         initValue:180
                                        pointerYOffset:NSNotFound];
    [viewOfGauge addSubview:_oilGaugeView];
    
    UILabel *labelOfDistance = [[UILabel alloc] initWithFrame:CGRectMake(20, 150, WIDTH, 20)];
    labelOfDistance.text = @"";
    labelOfDistance.backgroundColor = [UIColor clearColor];
    [viewOfGauge addSubview:labelOfDistance];
    [self.view addSubview:viewOfGauge];
    
    //map:
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 180, WIDTH, self.view.bounds.size.height - 180)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    //_mapView.region = 0.05;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _devicesModel) {
        if ([keyPath isEqualToString:KVO_DEVICE_DETAIL_PATH_NAME]) {
            [self updateMap];
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

- (void)updateMap
{
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = _devicesModel.deviceDetail.latitude;
    coor.longitude = _devicesModel.deviceDetail.longitude;
    annotation.coordinate = coor;
    annotation.title = @"";
    [_mapView addAnnotation:annotation];
    CLLocation *deviceLocation = [[CLLocation alloc] initWithLatitude:_devicesModel.deviceDetail.latitude
                                                            longitude:_devicesModel.deviceDetail.longitude];
    [_mapView setCenterCoordinate:deviceLocation.coordinate animated:YES];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView
             viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                    reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = NO;//标注的动画效果.
        return newAnnotationView;
    }
    return nil;

}

#pragma mark - Request handle

- (void)requestSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)requestFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"网络异常"];
}

- (void)requestTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:@"网络超时"];

}

@end
