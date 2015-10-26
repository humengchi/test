//
//  PeripheralViewController.m
//  OBDClient
//
//  Created by hys on 17/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "PeripheralViewController.h"

@interface PeripheralViewController ()

@end

@implementation PeripheralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    if (_mapView) {
        _mapView = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate=self;
    _search.delegate=self;
//    _mapFlag=YES;
}

- (void)viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _search.delegate=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"peripheralKey",@"MyString", @"");
	// Do any additional setup after loading the view.
    _mapView=[[BMKMapView alloc]initWithFrame:CGRectMake(0, 0, WIDTH,367)];
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    if([ADSingletonUtil sharedInstance].currentDeviceBase.latitude==0&&[ADSingletonUtil sharedInstance].currentDeviceBase.longitude==0){
        if([ADSingletonUtil sharedInstance].currentDeviceBase.lastLocation==nil){
            [IVToastHUD showAsToastErrorWithStatus:@"您的车辆尚未定位"];
        }else{
            if([[ADSingletonUtil sharedInstance].currentDeviceBase.lastLocation objectForKey:@"latitude"] == [NSNull null]){
                
            }else{
                coor.latitude=[[[ADSingletonUtil sharedInstance].currentDeviceBase.lastLocation objectForKey:@"latitude"] floatValue];
                coor.longitude=[[[ADSingletonUtil sharedInstance].currentDeviceBase.lastLocation objectForKey:@"longitude"] floatValue];
                NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
                //纠偏
                CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
                annotation.coordinate = coordinate;
                annotation.title = @"车辆位置";
                [_mapView addAnnotation:annotation];
                [_mapView setCenterCoordinate:coordinate];
                [_mapView setZoomLevel:11];
            }
        }
    }else{
        coor.latitude = [ADSingletonUtil sharedInstance].currentDeviceBase.latitude;
        coor.longitude = [ADSingletonUtil sharedInstance].currentDeviceBase.longitude;
        NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
        //纠偏
        CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
        annotation.coordinate = coordinate;
        annotation.title = @"车辆位置";
        [_mapView addAnnotation:annotation];
        [_mapView setCenterCoordinate:coordinate];
        [_mapView setZoomLevel:11];
    }

    [self.view addSubview:_mapView];
    
//    UIView *addressView = [[UIView alloc]initWithFrame:CGRectMake(0, 318, WIDTH, 49)];
//    _resultTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 220, 49)];
//    _resultTextLabel.backgroundColor=[UIColor clearColor];
//    _resultTextLabel.textColor=[UIColor darkGrayColor];
//    _resultTextLabel.font=[UIFont boldSystemFontOfSize:14];
//    _resultTextLabel.text=@"";
//    addressView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"location_address.png"]];
//    addressView.tag=11;
//    [addressView addSubview:_resultTextLabel];
//    [self.view addSubview:addressView];
//    addressView.hidden=NO;
    
    _search=[[BMKPoiSearch alloc]init];
    
    UITabBar *tabbar = [[UITabBar alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    tabbar.delegate = self;
    
    UITabBarItem *itemA = [[UITabBarItem alloc]initWithTitle:NSLocalizedStringFromTable(@"4sStoreKey",@"MyString", @"") image:[UIImage imageNamed:@"_0004_4S.png"] tag:0];
    UITabBarItem *itemB = [[UITabBarItem alloc]initWithTitle:NSLocalizedStringFromTable(@"oilStationKey",@"MyString", @"") image:[UIImage imageNamed:@"_0000_gas.png"] tag:1];
    UITabBarItem *itemC = [[UITabBarItem alloc]initWithTitle:NSLocalizedStringFromTable(@"washKey",@"MyString", @"") image:[UIImage imageNamed:@"_0001_wash.png"] tag:2];
    UITabBarItem *itemD = [[UITabBarItem alloc]initWithTitle:NSLocalizedStringFromTable(@"parkKey",@"MyString", @"") image:[UIImage imageNamed:@"_0002_parking.png"] tag:3];
    UITabBarItem *itemE = [[UITabBarItem alloc]initWithTitle:NSLocalizedStringFromTable(@"bankKey",@"MyString", @"") image:[UIImage imageNamed:@"_0003_bank.png"] tag:4];
    [tabbar setItems:[NSArray arrayWithObjects:itemA,itemB,itemC,itemD,itemE,nil] animated:YES];
    [self.view addSubview:tabbar];
    
    
    _listView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 433)];
    _listView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]];
//    _listView.alpha=0.9;
    _listView.hidden=YES;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, self.view.bounds.size.width, HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView=nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_listView addSubview:_tableView];
    [self.view addSubview:_listView];
    
    [_mapView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64-49)];
    [tabbar setFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
    [_listView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
}

-(void)changeFlag{
    if(_mapFlag){
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedStringFromTable(@"ListView",@"MyString", @"")];
        [self hidden:_listView enable:YES type:@"push"];
        _mapFlag=NO;
    }else{
        [self.navigationItem.rightBarButtonItem setTitle:NSLocalizedStringFromTable(@"MapViewKey",@"MyString", @"")];
        [self hidden:_listView enable:NO type:@"pop"];
        _mapFlag=YES;
    }
}

-(IBAction)hidenList:(id)sender{
    [self changeFlag];
}

-(void)hidden:(UIView*)view enable:(BOOL)enable type:(NSString *)type{
    CATransition *animation = [CATransition animation];
    if([type isEqualToString:@"push"]){
        animation.type =kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
    }else if([type isEqualToString:@"pop"]){
        animation.type =kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
    }
    
    animation.duration = 0.3;
    [view.layer addAnimation:animation forKey:nil];
    
    view.hidden = enable;
}

#pragma mark - Table view data source
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *annotationMArray = [[NSArray arrayWithArray:_mapView.annotations] mutableCopy];
    BMKPointAnnotation*annotation=annotationMArray[indexPath.row];
    [[_mapView viewForAnnotation:annotation] setSelected:YES animated:NO];
    [_mapView setCenterCoordinate:annotation.coordinate animated:NO];
    [_mapView setZoomLevel:14];
    [self changeFlag];
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 81;
}

// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _result.poiInfoList.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
    BMKPoiInfo* poi = [_result.poiInfoList objectAtIndex:indexPath.row];
    cell.textLabel.text=poi.name;
    NSString *detailText;
    if(poi.phone!=nil){
        detailText=[NSString stringWithFormat:@"地址：%@\n电话：%@",poi.address,poi.phone];
    }else{
        detailText=[NSString stringWithFormat:@"地址：%@",poi.address];
    }
    cell.detailTextLabel.text=detailText;
    cell.detailTextLabel.numberOfLines=3;
    cell.textLabel.font=[UIFont systemFontOfSize:14];
//    cell.imageView.bounds=CGRectMake(0, 0, 40, 40);
    cell.imageView.image=_searchImage;
    cell.textLabel.textColor=[UIColor whiteColor];
    float sw=40/cell.imageView.image.size.width;
    float sh=40/cell.imageView.image.size.height;
    cell.imageView.transform=CGAffineTransformMakeScale(sw,sh);
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,80, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    cell.backgroundColor=[UIColor clearColor];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    //    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    // Configure the cell...
    return cell;
}

- (void)onGetPoiResult:(NSArray*)poiResultList searchType:(int)type errorCode:(int)error
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    NSMutableArray *allCoordinateArr = [[NSMutableArray alloc] init];
    
    if (error == BMKErrorOk) {
        [self changeFlag];
//        [self hidden:_listView enable:NO type:@"pop"];
        _result = [poiResultList objectAtIndex:0];
        
        for (int i = 0; i < _result.poiInfoList.count; i++) {
            BMKPoiInfo* poi = [_result.poiInfoList objectAtIndex:i];
            BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
            item.coordinate = poi.pt;
            item.title = poi.name;
//            item.subtitle = poi.address;
            [_mapView addAnnotation:item];
            
            CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:item.coordinate.latitude longitude:item.coordinate.longitude];
            [allCoordinateArr addObject:currentLocation];
        }
        [_tableView reloadData];
    }else{
        [IVToastHUD showAsToastSuccessWithStatus:NSLocalizedStringFromTable(@"nodataKey",@"MyString", @"")];
    }
    
    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
    CLLocationCoordinate2D coor;
    coor.latitude = [ADSingletonUtil sharedInstance].currentDeviceBase.latitude;
    coor.longitude = [ADSingletonUtil sharedInstance].currentDeviceBase.longitude;
    NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
    //纠偏
    CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
    annotation.coordinate = coordinate;
    annotation.title=@"车辆位置";
    [_mapView addAnnotation:annotation];
    
    CLLocation *currentLocationself = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [allCoordinateArr addObject:currentLocationself];
    [self setRegion:allCoordinateArr];
    
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    switch (item.tag) {
        case 0:
            _searchImage=[UIImage imageNamed:@"4S.png"];
            break;
        case 1:
            _searchImage=[UIImage imageNamed:@"gas-station.png"];
            break;
        case 2:
            _searchImage=[UIImage imageNamed:@"wash.png"];
            break;
        case 3:
            _searchImage=[UIImage imageNamed:@"park.png"];
            break;
        case 4:
            _searchImage=[UIImage imageNamed:@"bank.png"];
            break;
        default:
            _searchImage=[UIImage imageNamed:@"4S.png"];
            break;
    }

    NSMutableArray *annotationMArray = [[NSArray arrayWithArray:_mapView.annotations] mutableCopy];
    [_mapView removeAnnotations:annotationMArray];
    if([annotationMArray count]!=0){
        [_mapView removeAnnotations:annotationMArray];
    }
    [_mapView setZoomLevel:11];
    
    //隐藏菊花
//    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    CLLocationCoordinate2D coor;
    coor.latitude = [ADSingletonUtil sharedInstance].currentDeviceBase.latitude;
    coor.longitude = [ADSingletonUtil sharedInstance].currentDeviceBase.longitude;
    NSDictionary *tip = BMKConvertBaiduCoorFrom(coor, BMK_COORDTYPE_COMMON);
    //纠偏
    CLLocationCoordinate2D coordinate = BMKCoorDictionaryDecode(tip);
//    [_search poiSearchNearBy:item.title center:coordinate radius:20000 pageIndex:0];
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.location = coordinate;
    option.radius = 20000;
    [_search poiSearchNearBy:option];
//    [_search poiSearchInCity:@"上海" withKey:item.title pageIndex:0];
    UIBarButtonItem *ButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"MapViewKey",@"MyString", @"") style:UIBarButtonItemStylePlain target:self action:@selector(hidenList:)];
    self.navigationItem.rightBarButtonItem=ButtonItem;
    if (IOS7_OR_LATER) {
        ButtonItem.tintColor=[UIColor lightGrayColor];
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

#pragma mark -Button action


- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    CLLocationCoordinate2D coor;
    coor=view.annotation.coordinate;
    [_mapView setCenterCoordinate:coor animated:YES];
//    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.5,0.5));
//    BMKCoordinateRegion adjustedRegion = [mapView regionThatFits:viewRegion];
//    [mapView setRegion:adjustedRegion animated:YES];
}

- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        if([annotation.title isEqualToString:@"车辆位置"]){
            return newAnnotationView;
        }
        
        newAnnotationView.image = _searchImage;
        newAnnotationView.bounds=CGRectMake(0, 0, 40, 40);
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示
        return newAnnotationView;
    }
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
