//
//  WeatherViewController.h
//  V3ViewController
//
//  Created by hys on 11/9/13.
//  Copyright (c) 2013年 hys. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherCell.h"
#import "CarAssistantViewController.h"
#import "ADUserLocationSettingViewController.h"

extern NSString* const ADSendToUserLocationSettingCurrentSelectedCityNotification;

@interface WeatherViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UIView* titleView;

@property(strong,nonatomic)UIView* changeCityView;

@property(strong,nonatomic)UITableView* weatherTableView;

@property(strong,nonatomic)UILabel* cityLabel;

@property(strong,nonatomic)NSArray* weatherdataDictionary;// NSDictionary* weatherdataDictionary;

@property(strong,nonatomic)NSString* oneDay;

@property(strong,nonatomic)NSString* twoDay;

@property(strong,nonatomic)NSString* threeDay;

@property(strong,nonatomic)NSString* fourDay;

@property(strong,nonatomic)NSString* fiveDay;

@property(strong,nonatomic)NSString* sixDay;

@property(strong,nonatomic)NSString* sevenDay;

@property(strong,nonatomic)NSDictionary* transitionDictionary;

@property(strong,nonatomic)NSString* currentSelectedCity;

//-(UIImage*)decideWeather:(NSString*)weatherString;

@end
