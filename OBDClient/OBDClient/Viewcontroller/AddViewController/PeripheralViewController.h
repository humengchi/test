//
//  PeripheralViewController.h
//  OBDClient
//
//  Created by hys on 17/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "QueryResultsViewController.h"
#import "ADMenuBaseViewController.h"
#import "ADSingletonUtil.h"

@interface PeripheralViewController : ADMenuBaseViewController<BMKMapViewDelegate,BMKPoiSearchDelegate,UITabBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property(nonatomic)BMKPoiResult* result;
@property(strong,nonatomic)BMKMapView* mapView;

@property(strong,nonatomic)BMKPointAnnotation* point1;

@property(nonatomic)BMKPoiSearch *search;
@property(nonatomic) BOOL mapFlag;
@property(nonatomic)UIView *listView;
@property(nonatomic)UITableView *tableView;

@property(nonatomic)UIImage *searchImage;
@property(nonatomic)UIView *addressView;
@property(nonatomic)UILabel *resultTextLabel;
@property(nonatomic)UILabel *resultDetailTextLabel;

@end
