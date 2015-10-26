	//
//  ADGeofenceUpdateViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-23.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGeofenceUpdateViewController.h"
#import "ADGeofenceDraw.h"
#import "ADGeoLineDraw.h"
#import "ADRectDraw.h"

@interface ADGeofenceUpdateViewController ()
{
    
}

@end

@implementation ADGeofenceUpdateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         geofenceBase:(ADGeofenceBase *)aGeofenceBase
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _geofenceModel = [[ADGeofenceModel alloc] init];
        _oldGenfenceBase = aGeofenceBase;
        if (_oldGenfenceBase) {
            _type = GEOFENCE_TYPE_EDIT;
            _newGenfenceBase = [ADGeofenceBase initWithCopy:aGeofenceBase];
        } else {
            _type = GEOFENCE_TYPE_NEW;
            _newGenfenceBase = [[ADGeofenceBase alloc] init];
            _newGenfenceBase.pCount = @"";
            [self changeNameButtonTap:nil];
        }
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(updateGeofenceSuccess:)
                           name:ADGeofenceModelUpdateSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(updateGeofenceFail:)
                           name:ADGeofenceModelUpdateFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(updateGeofenceTimeout:)
                           name:ADGeofenceModelUpdateTimeoutNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(generateGeofenceSuccess:)
                           name:ADGeofenceModelCreateSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(generateGeofenceFail:)
                           name:ADGeofenceModelCreateFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(generateGeofenceTimeout:)
                           name:ADGeofenceModelCreateTimeoutNotification
                         object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADGeofenceModelLoginTimeOutNotification
                                                   object:nil];

        
    }
    return self;
}

- (void)updateDeviceID:(NSString *)aDeviceID
{
    _deviceID = aDeviceID;
    _newGenfenceBase.deviceID = _deviceID;
}

- (void)generateGeofenceSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)generateGeofenceFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
}

- (void)generateGeofenceTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)updateGeofenceSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    _oldGenfenceBase = [ADGeofenceBase initWithCopy:_newGenfenceBase];
}

- (void)updateGeofenceFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
}

- (void)updateGeofenceTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)dealloc
{
    NSLog(@"dealloc");
    if(_mapView){
        _mapView=nil;
    }
    if(_circleImageView){
        _circleImageView=nil;
    }
    if (_circleLineView) {
        _circleLineView=nil;
    }
    if (_rectView) {
        _rectView=nil;
    }
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADGeofenceModelUpdateSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADGeofenceModelUpdateFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADGeofenceModelUpdateTimeoutNotification
                        object:nil];
    
    [notiCenter removeObserver:self
                          name:ADGeofenceModelCreateSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADGeofenceModelCreateFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADGeofenceModelCreateTimeoutNotification
                        object:nil];
    
    [_geofenceModel cancel];
}

- (void)generateGeofenceBase
{
    if(!_isCircle){
        _newGenfenceBase.pCount = @"5";
        _newGenfenceBase.isCircle = NO;
    }else{
        _newGenfenceBase.pCount = @"0";
        _newGenfenceBase.isCircle = YES;
        _newGenfenceBase.lat2 = 0;
        _newGenfenceBase.lng2 = 0;
        _newGenfenceBase.lat3 = 0;
        _newGenfenceBase.lng3 = 0;
        _newGenfenceBase.lat4 = 0;
        _newGenfenceBase.lng4 = 0;
        _newGenfenceBase.lat5 = 0;
        _newGenfenceBase.lat5 = 0;
        _newGenfenceBase.lat6 = 0;
        _newGenfenceBase.lng6 = 0;
        _newGenfenceBase.lat7 = 0;
        _newGenfenceBase.lng7 = 0;
        _newGenfenceBase.lat8 = 0;
        _newGenfenceBase.lng8 = 0;
        _newGenfenceBase.lat9 = 0;
        _newGenfenceBase.lng9 = 0;
        _newGenfenceBase.lat10 = 0;
        _newGenfenceBase.lng10 = 0;
    }
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"updataKey",@"MyString", @"")];
    [_geofenceModel createGeofenceWithGeofenceBase:_newGenfenceBase];
}

- (void)updateGeofenceBase
{
    if(!_isCircle){
        _newGenfenceBase.pCount = @"5";
        _newGenfenceBase.isCircle = NO;
    }else{
        _newGenfenceBase.pCount = @"0";
        _newGenfenceBase.isCircle = YES;
        _newGenfenceBase.lat2 = 0;
        _newGenfenceBase.lng2 = 0;
        _newGenfenceBase.lat3 = 0;
        _newGenfenceBase.lng3 = 0;
        _newGenfenceBase.lat4 = 0;
        _newGenfenceBase.lng4 = 0;
        _newGenfenceBase.lat5 = 0;
        _newGenfenceBase.lat5 = 0;
        _newGenfenceBase.lat6 = 0;
        _newGenfenceBase.lng6 = 0;
        _newGenfenceBase.lat7 = 0;
        _newGenfenceBase.lng7 = 0;
        _newGenfenceBase.lat8 = 0;
        _newGenfenceBase.lng8 = 0;
        _newGenfenceBase.lat9 = 0;
        _newGenfenceBase.lng9 = 0;
        _newGenfenceBase.lat10 = 0;
        _newGenfenceBase.lng10 = 0;
    }
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"updataKey",@"MyString", @"")];
    [_geofenceModel updateGeofenceWithNewGeofenceBase:_newGenfenceBase oldGeofenceBase:_oldGenfenceBase];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

-(void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)viewDidLoad
{
    NSLog(@"didload");
    [super viewDidLoad];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveButtonTap:) ];
    saveItem.possibleTitles = [NSSet setWithObject:@""];
    
    UIBarButtonItem *reNameItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"renameKey",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(changeNameButtonTap:)];
    reNameItem.possibleTitles = [NSSet setWithObject:@""];
    self.navigationItem.rightBarButtonItem = reNameItem;
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:saveItem,reNameItem, nil];
    
    if (IOS7_OR_LATER) {
        saveItem.tintColor=[UIColor lightGrayColor];
        reNameItem.tintColor=[UIColor lightGrayColor];
    }
    self.title = _oldGenfenceBase.geoName;
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-44)];
    [self.view addSubview:_mapView];
    
    _genfenceInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 40)];
    _genfenceInfoLabel.textColor = [UIColor blackColor];
    _genfenceInfoLabel.font=[UIFont systemFontOfSize:13];
    _genfenceInfoLabel.textAlignment = UITextAlignmentCenter;
    _genfenceInfoLabel.alpha=0.8;
    [_genfenceInfoLabel setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_genfenceInfoLabel];
//#ifdef circle
    //在分辨率不同的设备上显示有误差，若需支持多分辨率，updateMapZoom需做差异处理
    _circleImageView = [[ADGeofenceDraw alloc] initWithFrame:CGRectZero];
    _circleLineView = [[ADGeoLineDraw alloc] initWithFrame:CGRectZero];
//#else
    _rectView = [[ADRectDraw alloc] initWithFrame:CGRectZero];
//#endif
    if (_type == GEOFENCE_TYPE_EDIT) {
        if([_oldGenfenceBase.pCount integerValue] == 0){
            CLLocationCoordinate2D coor = {_oldGenfenceBase.lat1, _oldGenfenceBase.lng1};
            [_mapView setCenterCoordinate:coor animated:YES];
            _circle = [BMKCircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(_oldGenfenceBase.lat1, _oldGenfenceBase.lng1) radius:_oldGenfenceBase.radius];
            NSLog(@"_oldGenfenceBase.radius:%f",_oldGenfenceBase.radius);
            _isCircle = YES;
        }else{
            CLLocationCoordinate2D coor = {_oldGenfenceBase.lat5, _oldGenfenceBase.lng5};
            [_mapView setCenterCoordinate:coor animated:YES];
            CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D)*4);
            coords[0].latitude = _oldGenfenceBase.lat1;
            coords[0].longitude = _oldGenfenceBase.lng1;
            coords[1].latitude = _oldGenfenceBase.lat2;
            coords[1].longitude = _oldGenfenceBase.lng2;
            coords[2].latitude = _oldGenfenceBase.lat3;
            coords[2].longitude = _oldGenfenceBase.lng3;
            coords[3].latitude = _oldGenfenceBase.lat4;
            coords[3].longitude = _oldGenfenceBase.lng4;
            _rect = [BMKPolygon polygonWithCoordinates:coords count:4];
            
            _newGenfenceBase.width = [_mapView convertMapRect:_rect.boundingMapRect toRectToView:self.view].size.width;
            
            _isCircle = NO;
            
        }
        
        [self updateMapZoom];
    } else {
        CLLocationCoordinate2D coor;
        if ([ADSingletonUtil sharedInstance].currentDeviceBase.latitude==0&&[ADSingletonUtil sharedInstance].currentDeviceBase.longitude==0) {
            coor = CLLocationCoordinate2DMake(31.2105889593161, 121.492910330211);
        }else{
            coor = CLLocationCoordinate2DMake([ADSingletonUtil sharedInstance].currentDeviceBase.latitude, [ADSingletonUtil sharedInstance].currentDeviceBase.longitude);
        }
        NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
        //纠偏
        CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
        [_mapView setZoomLevel:16];
        [_mapView setCenterCoordinate:coordinate animated:YES];
        
//#ifdef circle
        _circleImageView.frame=CGRectMake((_mapView.frame.size.width - 250) / 2, (_mapView.frame.size.height - 250) / 2, 250, 250);
        _circleLineView.frame=CGRectMake((_mapView.frame.size.width - 250) / 2, (_mapView.frame.size.height - 250) / 2, 250, 250);
//#else
        _rectView.frame = CGRectMake((_mapView.frame.size.width - 250) / 2, (_mapView.frame.size.height - 250) / 2, 250, 250);
        
//#endif
        
        _isCircle = NO;
    }
    
    [self.view addSubview:_circleLineView];
    [self.view addSubview:_circleImageView];
    [self.view addSubview:_rectView];
    if(_isCircle){
        _circleImageView.hidden = NO;
        _circleLineView.hidden = NO;
        _rectView.hidden = YES;
    }else{
        _circleImageView.hidden = YES;
        _circleLineView.hidden = YES;
        _rectView.hidden = NO;
    }


//#ifdef circle
    [_circleImageView setUserInteractionEnabled:YES];
    UIPinchGestureRecognizer *pinGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(circleImagePin:)];
    [pinGesture setDelegate:self];
    [_circleImageView addGestureRecognizer:pinGesture];
//#else
    [_rectView setUserInteractionEnabled:YES];
    UIPinchGestureRecognizer *pinGesture1 = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(rectPin:)];
    [pinGesture1 setDelegate:self];
    [_rectView addGestureRecognizer:pinGesture1];
//#endif
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        [_genfenceInfoLabel setFrame:CGRectMake(0, 64, WIDTH, 40)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
//#ifdef circle
        CGRect frame=_circleImageView.frame;
        frame.origin.y+=50;
        [_circleImageView setFrame:frame];
        frame=_circleLineView.frame;
        frame.origin.y+=50;
        [_circleLineView setFrame:frame];
//#else
        CGRect frame1=_rectView.frame;
        frame1.origin.y+=50;
        [_rectView setFrame:frame1];
//#endif
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        [_genfenceInfoLabel setFrame:CGRectMake(0, 64, WIDTH, 40)];
//#ifdef circle
        CGRect frame=_circleImageView.frame;
        frame.origin.y+=50;
        [_circleImageView setFrame:frame];
        frame=_circleLineView.frame;
        frame.origin.y+=50;
        [_circleLineView setFrame:frame];
//#else
        CGRect frame1 =_rectView.frame;
        frame1.origin.y+=50;
        [_rectView setFrame:frame1];
//#endif
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    
    if (_type != GEOFENCE_TYPE_EDIT) {
//#ifdef circle
        CGRect rectOfImageView = _circleImageView.frame;
        _circle = [BMKCircle circleWithMapRect:[_mapView convertRect:rectOfImageView toMapRectFromView:self.view]];
        NSLog(@"newGenfenceBase.radius:%f",(double)_circle.radius);
//#else
        CGRect rectOfImageView1 = _rectView.frame;
        BMKMapRect rectFrame = [_mapView convertRect:rectOfImageView1 toMapRectFromView:self.view];
        float width = rectFrame.size.width;
        float height = rectFrame.size.height;
        float x = rectFrame.origin.x;
        float y = rectFrame.origin.y;
        
        BMKMapPoint *thePoints = malloc(sizeof(BMKMapPoint)*4);
        thePoints[0].x = x;
        thePoints[0].y = y;
        thePoints[1].x = x;
        thePoints[1].y = y + height;
        thePoints[2].x = x + width;
        thePoints[2].y = y + height;
        thePoints[3].x = x + width;
        thePoints[3].y = y;
        CLLocationCoordinate2D coords[4] = {0};
        for(int i = 0; i < 4; i++){
            coords[i] = BMKCoordinateForMapPoint(thePoints[i]);
        }
        _rect = [BMKPolygon polygonWithCoordinates:coords count:4];
        _newGenfenceBase.coords = coords;
        _newGenfenceBase.lng1 = coords[0].longitude;
        _newGenfenceBase.lat1 = coords[0].latitude;
        _newGenfenceBase.lng2 = coords[1].longitude;
        _newGenfenceBase.lat2 = coords[1].latitude;
        _newGenfenceBase.lng3 = coords[2].longitude;
        _newGenfenceBase.lat3 = coords[2].latitude;
        _newGenfenceBase.lng4 = coords[3].longitude;
        _newGenfenceBase.lat4 = coords[3].latitude;
        _newGenfenceBase.width = width;
        
        //获取中点的经纬度
        CLLocationCoordinate2D centerCoord = BMKCoordinateForMapPoint(BMKMapPointMake(x+width/2, y+width/2));
        _newGenfenceBase.lng5 = centerCoord.longitude;
        _newGenfenceBase.lat5 = centerCoord.latitude;
        
        NSLog(@"newGenfenceBase.width:%f",_newGenfenceBase.width);
//#endif
    }else{
        if([_oldGenfenceBase.pCount integerValue] == 0){
            _rectView.frame = _circleImageView.frame;
            CGRect rectOfImageView1 = _rectView.frame;
            BMKMapRect rectFrame = [_mapView convertRect:rectOfImageView1 toMapRectFromView:self.view];
            float width = rectFrame.size.width;
            float height = rectFrame.size.height;
            float x = rectFrame.origin.x;
            float y = rectFrame.origin.y;
            
            BMKMapPoint *thePoints = malloc(sizeof(BMKMapPoint)*4);
            thePoints[0].x = x;
            thePoints[0].y = y;
            thePoints[1].x = x;
            thePoints[1].y = y + height;
            thePoints[2].x = x + width;
            thePoints[2].y = y + height;
            thePoints[3].x = x + width;
            thePoints[3].y = y;
            CLLocationCoordinate2D coords[4] = {0};
            for(int i = 0; i < 4; i++){
                coords[i] = BMKCoordinateForMapPoint(thePoints[i]);
            }
            _rect = [BMKPolygon polygonWithCoordinates:coords count:4];
            _newGenfenceBase.coords = coords;
            _newGenfenceBase.lng1 = coords[0].longitude;
            _newGenfenceBase.lat1 = coords[0].latitude;
            _newGenfenceBase.lng2 = coords[1].longitude;
            _newGenfenceBase.lat2 = coords[1].latitude;
            _newGenfenceBase.lng3 = coords[2].longitude;
            _newGenfenceBase.lat3 = coords[2].latitude;
            _newGenfenceBase.lng4 = coords[3].longitude;
            _newGenfenceBase.lat4 = coords[3].latitude;
            _newGenfenceBase.width = width;
            
            //获取中点的经纬度
            CLLocationCoordinate2D centerCoord = BMKCoordinateForMapPoint(BMKMapPointMake(x+width/2, y+width/2));
            _newGenfenceBase.lng5 = centerCoord.longitude;
            _newGenfenceBase.lat5 = centerCoord.latitude;
            
            NSLog(@"newGenfenceBase.width:%f",_newGenfenceBase.width);
        }else{
            _circleImageView.frame = _rectView.frame;
            _circleLineView.frame = _rectView.frame;
            CGRect rectOfImageView = _circleImageView.frame;
            _circle = [BMKCircle circleWithMapRect:[_mapView convertRect:rectOfImageView toMapRectFromView:self.view]];
            NSLog(@"newGenfenceBase.radius:%f",(double)_circle.radius);
        }
    }
    [self flush];
    [self updateInfoUI];
    [self addVehicleToMap];
    
    
//    if (_type != GEOFENCE_TYPE_EDIT) {
        UIButton *circleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        circleButton.frame = CGRectMake(WIDTH-35, _mapView.frame.origin.y+45, 30, 30);
        [circleButton setTitle:@"圆形" forState:UIControlStateNormal];
        [circleButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [circleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        circleButton.titleLabel.font = [UIFont systemFontOfSize:12];
        circleButton.layer.cornerRadius = 5.0f;
        circleButton.layer.borderWidth = 0.8f;
        circleButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [circleButton setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.7f]];
        circleButton.tag = 2222;
        [circleButton addTarget:self action:@selector(changeGraphicByTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:circleButton];
        
        
        UIButton *rectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        rectButton.frame = CGRectMake(WIDTH-35, _mapView.frame.origin.y+80, 30, 30);
        [rectButton setTitle:@"矩形" forState:UIControlStateNormal];
        [rectButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [rectButton setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
        rectButton.titleLabel.font = [UIFont systemFontOfSize:12];
        rectButton.layer.cornerRadius = 5.0f;
        rectButton.layer.borderWidth = 0.8f;
        rectButton.layer.borderColor = [[UIColor grayColor] CGColor];
        [rectButton setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.7f]];
        rectButton.tag = 2223;
        [rectButton addTarget:self action:@selector(changeGraphicByTag:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rectButton];
        
        
        if(_isCircle){
            circleButton.selected = YES;
        }else{
            rectButton.selected = YES;
        }
//    }
}

- (IBAction)changeGraphicByTag:(id)sender
{
    if(_type == GEOFENCE_TYPE_EDIT&&[_oldGenfenceBase.applyField isEqualToString:@"1"]&&[_oldGenfenceBase.cmdType isEqualToString:@"0"]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"beingDeleted",@"MyString", @"")];
        return;
    }
    UIButton *btn = (UIButton*)sender;
    if(btn.tag == 2222){
        [(UIButton*)[self.view viewWithTag:2222] setSelected:YES];
        [(UIButton*)[self.view viewWithTag:2223] setSelected:NO];
        _isCircle = YES;
    
    }else{
        [(UIButton*)[self.view viewWithTag:2222] setSelected:NO];
        [(UIButton*)[self.view viewWithTag:2223] setSelected:YES];
        _isCircle = NO;
    }
    if(_isCircle){
        _circleImageView.hidden = NO;
        _circleLineView.hidden = NO;
        _rectView.hidden = YES;
    }else{
        _circleImageView.hidden = YES;
        _circleLineView.hidden = YES;
        _rectView.hidden = NO;
    }
    
    
    //及时更新数据
    [self flush];
    
    [self updateInfoUI];
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
//    NSLog(@"%@",touches.description);
//}

- (void)addVehicleToMap{
    NSLog(@"addvehicletomap");
    ADDeviceBase *deviceBase=[ADSingletonUtil sharedInstance].currentDeviceBase;
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = deviceBase.latitude;
    coor.longitude = deviceBase.longitude;
    if(coor.latitude==0&&coor.longitude==0){
        if(deviceBase.lastLocation==nil){
           
        }else{
            NSLog(@"%@",[deviceBase.lastLocation objectForKey:@"latitude"]);
            if([deviceBase.lastLocation objectForKey:@"latitude"]==[NSNull null]||[deviceBase.lastLocation objectForKey:@"longitude"]==[NSNull null]){
                //
            }else{
                coor.latitude = [[deviceBase.lastLocation objectForKey:@"latitude"] floatValue];
                coor.longitude = [[deviceBase.lastLocation objectForKey:@"longitude"] floatValue];
            }
            NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
            //纠偏
            CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
            annotation.coordinate = coordinate;
            [_mapView addAnnotation:annotation];
        }
    }else{
        NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
        //纠偏
        CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
        annotation.coordinate = coordinate;
        [_mapView addAnnotation:annotation];
    }
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView
             viewForAnnotation:(id<BMKAnnotation>)annotation
{
    NSLog(@"geoannotation");
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                   reuseIdentifier:@"geo"];
        newAnnotationView.pinColor = BMKPinAnnotationColorGreen;
        newAnnotationView.enabled=NO;
        newAnnotationView.enabled3D=YES;
        newAnnotationView.animatesDrop = NO;//标注的动画效果.
//        newAnnotationView.image = [UIImage imageNamed:@"car.png"];
        return newAnnotationView;
    }
    return nil;
    
}

- (void)changeNameButtonTap:(id)sender
{
    if(_type == GEOFENCE_TYPE_EDIT&&[_oldGenfenceBase.applyField isEqualToString:@"1"]&&[_oldGenfenceBase.cmdType isEqualToString:@"0"]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"beingDeleted",@"MyString", @"")];
        return;
    }
    
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@""
                                                       message:NSLocalizedStringFromTable(@"enterTheNewNameKey",@"MyString", @"")
                                                      delegate:self
                                             cancelButtonTitle:NSLocalizedStringFromTable(@"cancelKey",@"MyString", @"")
                                             otherButtonTitles:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @""), nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView textFieldAtIndex:0].text = _newGenfenceBase.geoName;
    [alertView textFieldAtIndex:0].delegate = self;
    [alertView show];
}

- (void)updateMapZoom
{
//#ifdef circle
    if(_isCircle){
    double radius = _oldGenfenceBase.radius;
    double imageView_radius;
    
    if (radius <= 500 && radius >= 300) {
        [_mapView setZoomLevel:17];
        imageView_radius = radius / 2;
    }else if(radius <= 1000 && radius > 500)
    {
        [_mapView setZoomLevel:16];
        imageView_radius = radius / 4;
    }else if(radius <= 2000 && radius > 1000)
    {
        [_mapView setZoomLevel:15];
        imageView_radius = radius / 8;
    }else
    {
        [_mapView setZoomLevel:14];
        imageView_radius = radius / 16;
    }
    _circleImageView.frame = CGRectMake((_mapView.frame.size.width - imageView_radius)/2, (_mapView.frame.size.height - imageView_radius)/2, imageView_radius, imageView_radius);
    _circleLineView.frame = CGRectMake((_mapView.frame.size.width - imageView_radius)/2, (_mapView.frame.size.height - imageView_radius)/2, imageView_radius, imageView_radius);
    }
//#else
    else{
    double width = _newGenfenceBase.width;
    double rectView_width = _newGenfenceBase.width;
    if (width <= 500 && width >= 300) {
        [_mapView setZoomLevel:17];
        rectView_width = width / 2;
    }else if(width <= 1000 && width > 500)
    {
        [_mapView setZoomLevel:16];
        rectView_width = width / 4;
    }else if(width <= 2000 && width > 1000)
    {
        [_mapView setZoomLevel:15];
        rectView_width = width / 8;
    }else if(width > 2000){
        [_mapView setZoomLevel:14];
        rectView_width = width / 16;
    }else{
//        [_mapView setZoomLevel:14];
        rectView_width = width;
    }
    _rectView.frame = CGRectMake((_mapView.frame.size.width - rectView_width)/2, (_mapView.frame.size.height - rectView_width)/2, rectView_width, rectView_width);
    }
//#endif
}


- (void)saveButtonTap:(id)sender
{
    if(_isCircle){
        if(_type == GEOFENCE_TYPE_EDIT&&[_oldGenfenceBase.applyField isEqualToString:@"1"]&&[_oldGenfenceBase.cmdType isEqualToString:@"0"]){
            
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"beingDeleted",@"MyString", @"")];
            return;
        }
        
        if (_newGenfenceBase.radius > 2250) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"failedToSetGeofenceKey",@"MyString", @"")
                                                          message:NSLocalizedStringFromTable(@"geofenceNotMoreThan2250metersKey",@"MyString", @"")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"")
                                                otherButtonTitles:nil];
            [alert show];
            return;
            
        } else if(_newGenfenceBase.radius < 300) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"failedToSetGeofenceKey",@"MyString", @"")
                                                          message:NSLocalizedStringFromTable(@"geofenceNotLessThan300metersKey",@"MyString", @"")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"")
                                                otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if ([_newGenfenceBase.geoName isEqualToString:@""]) {
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"pleaseEnterTheNameOfTheGeofenceKey",@"MyString", @"")];
            return;
        }
        
        if (_type == GEOFENCE_TYPE_EDIT) {
            [self updateGeofenceBase];
        } else if (_type == GEOFENCE_TYPE_NEW) {
            [self generateGeofenceBase];
        }

    }else{
        if(_type == GEOFENCE_TYPE_EDIT&&[_oldGenfenceBase.applyField isEqualToString:@"1"]&&[_oldGenfenceBase.cmdType isEqualToString:@"0"]){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"beingDeleted",@"MyString", @"")];
            return;
        }
        
        if (_newGenfenceBase.width > 4500) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"failedToSetGeofenceKey",@"MyString", @"")
                                                          message:NSLocalizedStringFromTable(@"geofenceNotMoreThan4500metersKey",@"MyString", @"")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"")
                                                otherButtonTitles:nil];
            [alert show];
            return;
            
        } else if(_newGenfenceBase.width < 300) {
            UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"failedToSetGeofenceKey",@"MyString", @"")
                                                          message:NSLocalizedStringFromTable(@"geofenceNotLessThan300metersKey",@"MyString", @"")
                                                         delegate:self
                                                cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"")
                                                otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if ([_newGenfenceBase.geoName isEqualToString:@""]) {
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"pleaseEnterTheNameOfTheGeofenceKey",@"MyString", @"")];
            return;
        }
        
        if (_type == GEOFENCE_TYPE_EDIT) {
            [self updateGeofenceBase];
        } else if (_type == GEOFENCE_TYPE_NEW) {
            [self generateGeofenceBase];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rectPin:(UIPinchGestureRecognizer *)aRecogn
{
    if (aRecogn.state == UIGestureRecognizerStateEnded) {
        
        if (_rectView.frame.size.width > WIDTH) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.50];
            _rectView.frame = CGRectMake(0, ((_mapView.frame.size.height - WIDTH) / 2)+_mapView.frame.origin.y, WIDTH, WIDTH);
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            aRecogn.view.transform = CGAffineTransformScale(aRecogn.view.transform, aRecogn.scale, aRecogn.scale);
            [UIView commitAnimations];
        }
        NSLog(@"width:%f--height:%f",_rectView.frame.size.width,_rectView.frame.size.height);
    }
    else
    {
        aRecogn.view.transform = CGAffineTransformScale(aRecogn.view.transform, aRecogn.scale, aRecogn.scale);
    }
    aRecogn.scale = 1;
    CGRect rectOfImageView = _rectView.frame;
    BMKMapRect rectFrame = [_mapView convertRect:rectOfImageView toMapRectFromView:self.view];
    float width = rectFrame.size.width;
    float height = rectFrame.size.height;
    float x = rectFrame.origin.x;
    float y = rectFrame.origin.y;
    
    BMKMapPoint *thePoints = malloc(sizeof(BMKMapPoint)*4);
    thePoints[0].x = x;
    thePoints[0].y = y;
    thePoints[1].x = x;
    thePoints[1].y = y + height;
    thePoints[2].x = x + width;
    thePoints[2].y = y + height;
    thePoints[3].x = x + width;
    thePoints[3].y = y;
    CLLocationCoordinate2D coords[4] = {0};
    for(int i = 0; i < 4; i++){
        coords[i] = BMKCoordinateForMapPoint(thePoints[i]);
    }
    _rect = [BMKPolygon polygonWithCoordinates:coords count:4];
    _newGenfenceBase.coords = coords;
    _newGenfenceBase.lng1 = coords[0].longitude;
    _newGenfenceBase.lat1 = coords[0].latitude;
    _newGenfenceBase.lng2 = coords[1].longitude;
    _newGenfenceBase.lat2 = coords[1].latitude;
    _newGenfenceBase.lng3 = coords[2].longitude;
    _newGenfenceBase.lat3 = coords[2].latitude;
    _newGenfenceBase.lng4 = coords[3].longitude;
    _newGenfenceBase.lat4 = coords[3].latitude;
    _newGenfenceBase.width = width;
    
    //获取中点的经纬度
    CLLocationCoordinate2D centerCoord = BMKCoordinateForMapPoint(BMKMapPointMake(x+width/2, y+width/2));
    _newGenfenceBase.lng5 = centerCoord.longitude;
    _newGenfenceBase.lat5 = centerCoord.latitude;
    
    [self flush];
    [self updateInfoUI];
}

//- (void)saveButtonTap1:(id)sender
//{
//    if(_type == GEOFENCE_TYPE_EDIT&&[_oldGenfenceBase.cmdType isEqualToString:@"0"]){
//        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"beingDeleted",@"MyString", @"")];
//        return;
//    }
//    
//    if (_newGenfenceBase.radius > 2250) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"failedToSetGeofenceKey",@"MyString", @"")
//                                                      message:NSLocalizedStringFromTable(@"geofenceNotMoreThan2250metersKey",@"MyString", @"")
//                                                     delegate:self
//                                            cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"")
//                                            otherButtonTitles:nil];
//        [alert show];
//        return;
//        
//    } else if(_newGenfenceBase.radius < 300) {
//        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"failedToSetGeofenceKey",@"MyString", @"")
//                                                      message:NSLocalizedStringFromTable(@"geofenceNotLessThan300metersKey",@"MyString", @"")
//                                                     delegate:self
//                                            cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"")
//                                            otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    
//    if ([_newGenfenceBase.geoName isEqualToString:@""]) {
//        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"pleaseEnterTheNameOfTheGeofenceKey",@"MyString", @"")];
//        return;
//    }
//    
//    if (_type == GEOFENCE_TYPE_EDIT) {
//        [self updateGeofenceBase];
//    } else if (_type == GEOFENCE_TYPE_NEW) {
//        [self generateGeofenceBase];
//    }
//}


- (void)circleImagePin:(UIPinchGestureRecognizer *)aRecogn
{
    if (aRecogn.state == UIGestureRecognizerStateEnded) {
        NSLog(@"width:%f--height:%f",_circleImageView.frame.size.width,_circleImageView.frame.size.height);
        if (_circleImageView.frame.size.width > WIDTH) {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.50];
            _circleImageView.frame = CGRectMake(0, ((_mapView.frame.size.height - WIDTH) / 2)+_mapView.frame.origin.y, WIDTH, WIDTH);
            _circleLineView.frame=_circleImageView.frame;
            [UIView commitAnimations];
        } else {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.1];
            aRecogn.view.transform = CGAffineTransformScale(aRecogn.view.transform, aRecogn.scale, aRecogn.scale);
            [UIView commitAnimations];
        }
    }
    else
    {
        aRecogn.view.transform = CGAffineTransformScale(aRecogn.view.transform, aRecogn.scale, aRecogn.scale);
    }
    aRecogn.scale = 1;
    _circleLineView.frame=_circleImageView.frame;
    [_circleLineView setNeedsDisplay];
    _circle = [BMKCircle circleWithMapRect:[_mapView convertRect:_circleImageView.frame toMapRectFromView:self.view]];
    
    [self flush];
    [self updateInfoUI];
}


- (void)updateInfoUI
{
//#ifdef circle
    if(_isCircle){
    NSString *showGenfenceRadius = [[NSString alloc] initWithFormat:@"%@，%@%d%@",NSLocalizedStringFromTable(@"toSetTheMinimumRadiusOf300MetersKey",@"MyString", @""), NSLocalizedStringFromTable(@"currentKey",@"MyString", @""),(int)_circle.radius,NSLocalizedStringFromTable(@"metersKey",@"MyString", @"")];
    _genfenceInfoLabel.text = showGenfenceRadius;
    
    NSLog(@"111%@",showGenfenceRadius);

    _newGenfenceBase.radius = _circle.radius;
    _newGenfenceBase.lat1 = _circle.coordinate.latitude;
    _newGenfenceBase.lng1 = _circle.coordinate.longitude;
    }
//#else
    else{
    NSString *showGenfenceRadius = [[NSString alloc] initWithFormat:@"可设置最小边长300米，当前%d米", (int)_newGenfenceBase.width];
    _genfenceInfoLabel.text = showGenfenceRadius;
    NSLog(@"222%@",showGenfenceRadius);
    }
//#endif
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.alertViewStyle == UIAlertViewStylePlainTextInput && buttonIndex == 1) {
        if (_type == GEOFENCE_TYPE_EDIT) {
            [self updateGeofenceBase];
        }
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _newGenfenceBase.geoName = textField.text;
    self.title = _newGenfenceBase.geoName;
}

- (void)flush
{
    if(_isCircle){
        CGRect rectOfImageView = _circleImageView.frame;
        
        _circle = [BMKCircle circleWithMapRect:[_mapView convertRect:rectOfImageView toMapRectFromView:self.view]];
        NSLog(@"%f",(double)_circle.radius);
    }else{
        CGRect rectOfImageView = _rectView.frame;
        BMKMapRect rectFrame = [_mapView convertRect:rectOfImageView toMapRectFromView:self.view];
        float width = rectFrame.size.width;
        float height = rectFrame.size.height;
        float x = rectFrame.origin.x;
        float y = rectFrame.origin.y;
        
        BMKMapPoint *thePoints = malloc(sizeof(BMKMapPoint)*4);
        thePoints[0].x = x;
        thePoints[0].y = y;
        thePoints[1].x = x;
        thePoints[1].y = y + height;
        thePoints[2].x = x + width;
        thePoints[2].y = y + height;
        thePoints[3].x = x + width;
        thePoints[3].y = y;
        CLLocationCoordinate2D coords[4] = {0};
        for(int i = 0; i < 4; i++){
            coords[i] = BMKCoordinateForMapPoint(thePoints[i]);
        }
        _rect = [BMKPolygon polygonWithCoordinates:coords count:4];
        _newGenfenceBase.coords = coords;
        _newGenfenceBase.lng1 = coords[0].longitude;
        _newGenfenceBase.lat1 = coords[0].latitude;
        _newGenfenceBase.lng2 = coords[1].longitude;
        _newGenfenceBase.lat2 = coords[1].latitude;
        _newGenfenceBase.lng3 = coords[2].longitude;
        _newGenfenceBase.lat3 = coords[2].latitude;
        _newGenfenceBase.lng4 = coords[3].longitude;
        _newGenfenceBase.lat4 = coords[3].latitude;
        _newGenfenceBase.width = width;
        
        CLLocationCoordinate2D centerCoord = BMKCoordinateForMapPoint(BMKMapPointMake(x+width/2, y+width/2));
        _newGenfenceBase.lng5 = centerCoord.longitude;
        _newGenfenceBase.lat5 = centerCoord.latitude;
        
        NSLog(@"%lf--%lf", centerCoord.latitude, centerCoord.longitude);
    }

}

#pragma mark - map

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    [self flush];
    
    [self updateInfoUI];
}

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

#pragma mark - gesture
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    if (touch.view == _circleImageView) {
        return YES;
    }else if(touch.view  == _rectView){
        return  YES;
    }
    return NO;
}

- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

@end
