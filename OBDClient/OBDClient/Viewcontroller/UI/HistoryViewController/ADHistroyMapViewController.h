//
//  ADHistroyMapViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ADHistoryModel.h"

@interface ADHistroyMapViewController : ADBaseViewController<BMKMapViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BMKPolyline *_routeLine;
    BMKMapRect _routRect;
    BMKPointAnnotation *item;
    NSTimer *myTimer;
    UIButton *reviewLineBtn;
    UIButton *renewBtn;
}
@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic) ADHistoryModel *historyModel;
@property (nonatomic) NSArray *data;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UIView *listView;
@property (nonatomic) UIView *detailView;
@property (nonatomic) UILabel *tripNumLabel;
@property (nonatomic) UILabel *averageSpeedLabel;
@property (nonatomic) UILabel *averageFuelConsumptionLabel;
@property (nonatomic) UILabel *tripTimeLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)adata;

@end
