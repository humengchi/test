//
//  ADUserLocationSettingViewController.h
//  OBDClient
//
//  Created by hys on 23/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherViewController.h"
#import "ADSingletonUtil.h"
#import "IVToastHUD.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI/BMapKit.h>
#import "ADSearchOrganModel.h"
#import "SearchOrganCell.h"

extern NSString* const ADSendToCarAssistantCurrentSelectedCityNotification;

@interface ADUserLocationSettingViewController : UIViewController<BMKMapViewDelegate,CLLocationManagerDelegate,ADSerachOrganDelegate,UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)NSString* currentSelectedCity;

@property(strong,nonatomic)UISearchBar* search;

@property(nonatomic)double currentCitylatitude;

@property(nonatomic)double currentCitylongitude;

@property(strong,nonatomic)BMKMapView* mapView;

@property(strong,nonatomic)CLLocationManager* locationManager;

@property(strong,nonatomic)ADSearchOrganModel* searchOrganModel;

@property(strong,nonatomic)NSArray* searchArray;

@property(strong,nonatomic)UITableView* searchTableView;

@end
