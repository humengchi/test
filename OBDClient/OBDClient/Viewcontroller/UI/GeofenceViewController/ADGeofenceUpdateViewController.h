//
//  ADGeofenceUpdateViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-23.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>
#import "ADGeofenceBase.h"
#import "ADGeofenceModel.h"
#import "ADDeviceDetail.h"
#import "IVToastHUD.h"
#import "ADiPhoneLoginViewController.h"

#include "ADDefine.h"

#define circle

typedef enum
{
    GEOFENCE_TYPE_EDIT = 1,
    GEOFENCE_TYPE_NEW = 2
} ADGeofenceUpdateViewControllerType;

@protocol ADGeofenceUpdateDelegate <NSObject>

- (void)geofenceUpdateCompleted;

@end

@interface ADGeofenceUpdateViewController : UIViewController <BMKMapViewDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, UIAlertViewDelegate>
{
    IBOutlet BMKMapView *_mapView;
    BMKCircle *_circle;
    BMKPolygon *_rect;
    UIView *_circleImageView;
    UIView *_circleLineView;
    UIView *_rectView;
    ADGeofenceModel *_geofenceModel;
    ADGeofenceBase *_oldGenfenceBase;
    ADGeofenceBase *_newGenfenceBase;
    UILabel *_genfenceInfoLabel;
    ADGeofenceUpdateViewControllerType _type;
    NSString *_deviceID;
}

@property (nonatomic, weak) id <ADGeofenceUpdateDelegate> delegate;

@property (nonatomic, assign) BOOL isCircle;   //是否为圆形栅栏

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
         geofenceBase:(ADGeofenceBase *)aGeofenceBase;

- (void)updateDeviceID:(NSString *)aDeviceID;

@end
