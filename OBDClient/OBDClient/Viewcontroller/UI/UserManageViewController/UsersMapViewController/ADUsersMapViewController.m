//
//  ADUsersMapViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-22.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUsersMapViewController.h"

@interface ADUsersMapViewController ()
{
    BOOL trafficOn;
}
@end

@implementation ADUsersMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"MapViewKey",@"MyString", @"");
    //map:
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 416)];
    //    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem=nil;
    [_mapView viewWillAppear];
    _mapView.delegate = self;
//    [_mapView setCenterCoordinate:CLLocationCoordinate2DMake(31.2105889593161, 121.492910330211)];
//    [_mapView setZoomLevel:12];
    
    if (_modelFlag==2) {
        [self updateMapUI];
    }else if (_modelFlag==1){
         NSArray *authDevices=[ADSingletonUtil sharedInstance].authDevices;
        ADDeviceBase *authdeviceinfo=[authDevices objectAtIndex:_authIndex];
        
        if(authdeviceinfo.location!=nil&&authdeviceinfo.latitude!=0&&authdeviceinfo.longitude!=0){
            CLLocationCoordinate2D authCoor={authdeviceinfo.latitude,authdeviceinfo.longitude};
            BMKPointAnnotation *point=[[BMKPointAnnotation alloc]init];
            point.coordinate=authCoor;
            
            point.title=[NSString stringWithFormat:@"%@%@%@%@",authdeviceinfo.address_state,authdeviceinfo.address_city,authdeviceinfo.address_street,authdeviceinfo.address_num];
            point.subtitle=authdeviceinfo.licenseNumber;
            [_mapView addAnnotation:point];
            
            [_mapView setZoomLevel:14];
            [_mapView setCenterCoordinate:authCoor animated:YES];
        }else{
            [IVToastHUD showAsToastErrorWithStatus:@"你选择的车辆未进行定位或者未取得位置"];
        }
        

        
    }else{
        NSMutableArray *allCoordinateArr = [[NSMutableArray alloc] init];
        NSArray *devices=[ADSingletonUtil sharedInstance].devices;
        for(NSInteger i=0;i<devices.count;i++){
            ADDeviceBase *deviceinfo=[devices objectAtIndex:i];
            if(deviceinfo.location!=nil&&deviceinfo.latitude!=0&&deviceinfo.longitude!=0){
                CLLocationCoordinate2D devCoor={deviceinfo.latitude,deviceinfo.longitude};
                BMKPointAnnotation *point=[[BMKPointAnnotation alloc]init];
                point.coordinate=devCoor;
                
                point.title=[NSString stringWithFormat:@"%@",deviceinfo.address_num];
                point.subtitle=deviceinfo.licenseNumber;
                [_mapView addAnnotation:point];
                
                CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:deviceinfo.latitude longitude:deviceinfo.longitude];
                [allCoordinateArr addObject:currentLocation];
            }
            
        }
        NSArray *authDevices=[ADSingletonUtil sharedInstance].authDevices;
        for(NSInteger i=0;i<authDevices.count;i++){
            ADDeviceBase *authdeviceinfo=[authDevices objectAtIndex:i];
            
            if(authdeviceinfo.location!=nil&&authdeviceinfo.latitude!=0&&authdeviceinfo.longitude!=0){
                CLLocationCoordinate2D authcoor={authdeviceinfo.latitude,authdeviceinfo.longitude};
                BMKPointAnnotation *authpoint=[[BMKPointAnnotation alloc]init];
                authpoint.coordinate=authcoor;
                authpoint.title=[NSString stringWithFormat:@"（%@）%@%@",NSLocalizedStringFromTable(@"LicensedvehiclesKey",@"MyString", @""),authdeviceinfo.address_num,NSLocalizedStringFromTable(@"nearKey",@"MyString", @"")];
                authpoint.subtitle=authdeviceinfo.licenseNumber;
                [_mapView addAnnotation:authpoint];
                
                CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:authdeviceinfo.latitude longitude:authdeviceinfo.longitude];
                [allCoordinateArr addObject:currentLocation];
            }
            
        }
        if(allCoordinateArr.count==0){
            [IVToastHUD showAsToastErrorWithStatus:@"无已上报有效位置的车辆"];
        }else{
            [self setRegion:allCoordinateArr];
        }
        
    }

}

//设置地图当前显示的区域
- (void)setRegion:(NSArray * )arr
{
    if ([arr count]!=0) {
        // determine the extents of the trip points that were passed in, and zoom in to that area.
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
        
        for(int i = 0; i < [arr count]; i++)
        {
            CLLocation* currentLocation = [arr objectAtIndex:i];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        
        BMKCoordinateRegion region;
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  = maxLat - minLat;
        region.span.longitudeDelta = maxLon - minLon;
        [_mapView setRegion:region];
    
    }else {
        //"no data！";
    }
}


- (IBAction)showTraffic:(id)sender{
    if(trafficOn){
        trafficOn=NO;
        [_mapView setMapType:BMKMapTypeStandard];
        self.navigationItem.rightBarButtonItem.title=@"开启实时路况";
    }else{
        trafficOn=YES;
        [_mapView setMapType:BMKMapTypeStandard];
        self.navigationItem.rightBarButtonItem.title=@"关闭实时路况";
    }
}

- (void)updateMapUI{
    NSMutableArray *allCoordinateArr = [[NSMutableArray alloc] init];
    NSArray *sharedDevices=[ADSingletonUtil sharedInstance].sharedDevices;
    for(NSInteger i=0;i<sharedDevices.count;i++){
        ADDeviceBase *sharedDeviceinfo=[sharedDevices objectAtIndex:i];
        if(sharedDeviceinfo.location!=nil&&sharedDeviceinfo.latitude!=0&&sharedDeviceinfo.longitude!=0){
            CLLocationCoordinate2D sharedCoor={sharedDeviceinfo.latitude,sharedDeviceinfo.longitude};
            BMKPointAnnotation *sharedPoint=[[BMKPointAnnotation alloc]init];
            sharedPoint.coordinate=sharedCoor;
            
            sharedPoint.title=[NSString stringWithFormat:@"（%@）%@%@",NSLocalizedStringFromTable(@"ShareofvehicleKey",@"MyString", @""),sharedDeviceinfo.address_num,NSLocalizedStringFromTable(@"nearKey",@"MyString", @"")];
            sharedPoint.subtitle=sharedDeviceinfo.licenseNumber;
            
            NSLog(@"%f",sharedDeviceinfo.latitude);
            [_mapView addAnnotation:sharedPoint];
            
            CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:sharedDeviceinfo.latitude longitude:sharedDeviceinfo.longitude];
            [allCoordinateArr addObject:currentLocation];
        }
    }
    if(allCoordinateArr.count==0){
        [IVToastHUD showAsToastErrorWithStatus:@"无已上报有效位置的公开车辆"];
    }else{
        [self setRegion:allCoordinateArr];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
//    [mapView setZoomLevel:14];
    CLLocationCoordinate2D coor;
    coor=view.annotation.coordinate;
    [mapView setCenterCoordinate:coor animated:YES];
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView
             viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        //        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.animatesDrop = NO;//标注的动画效果.
        newAnnotationView.image = [UIImage imageNamed:@"car.png"];
        
        return newAnnotationView;
    }
    return nil;
    
}

-(UIImage *)grayImage:(UIImage *)sourceImage
{
    int bitmapInfo = kCGImageAlphaNone;
    int width = sourceImage.size.width;
    int height = sourceImage.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();
    CGContextRef context = CGBitmapContextCreate (nil,
                                                  width,
                                                  height,
                                                  8,      // bits per component
                                                  0,
                                                  colorSpace,
                                                  bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    if (context == NULL) {
        return nil;
    }
    CGContextDrawImage(context,
                       CGRectMake(0, 0, width, height), sourceImage.CGImage);
    UIImage *grayImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
    CGContextRelease(context);
    return grayImage;
}

- (void)dealloc {
    [_devicesModel cancel];
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_SHARED_DEVICES_PATH_NAME];
    
    if (_mapView) {
        _mapView = nil;
    }
}

@end