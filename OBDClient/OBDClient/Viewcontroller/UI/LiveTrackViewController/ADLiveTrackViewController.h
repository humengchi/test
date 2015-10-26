//
//  ADLiveTrackViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-10.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADGaugeView.h"
#import <BaiduMapAPI/BMapKit.h>
#import "ADDeviceDetail.h"
#import "ADDevicesModel.h"
#import "IVToastHUD.h"
#import "ADiPhoneLoginViewController.h"

@interface ADLiveTrackViewController : UIViewController <BMKMapViewDelegate>
{
    ADGaugeView *_sppedGaugeView;
    ADGaugeView *_oilGaugeView;
    IBOutlet BMKMapView *_mapView;
    ADDevicesModel *_devicesModel;
}

@end
