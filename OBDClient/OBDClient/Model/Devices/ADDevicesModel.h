//
//  ADDevicesModel.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-3.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADDeviceBase.h"
#import "ADDeviceDetail.h"
#import "ADDTCBase.h"

#define KVO_ALL_DEVICES_PATH_NAME       @"devices"
#define KVO_DEVICE_DETAIL_PATH_NAME     @"deviceDetail"
#define KVO_AUTH_DEVICES_PATH_NAME      @"authDevices"
#define KVO_SHARED_DEVICES_PATH_NAME    @"sharedDevices"

typedef enum{
    DEVICESMODEL_ALL_DEVICES = 0,
    DEVICESMODEL_DETAIL_DEVICE = 1,
    DEVICESMODEL_AUTH_DEVICES = 2,
    DEVICESMODEL_SHARED_DEVICES = 3,
    DEVICESMODEL_LATEST_INFO = 4
    
} ADDevicesModelRequestType;

extern NSString * const ADDevicesModelRequestAllDevicesSuccessNotification;
extern NSString * const ADDevicesModelRequestAllDevicesFailNotification;
extern NSString * const ADDevicesModelRequestAllDevicesTimeoutNotification;

extern NSString * const ADDevicesModelRequestDeviceDetailSuccessNotification;
extern NSString * const ADDevicesModelRequestDeviceDetailFailNotification;
extern NSString * const ADDevicesModelRequestDeviceDetailTimeoutNotification;

extern NSString * const ADDevicesModelRequestAuthorizeDevicesSuccessNotification;
extern NSString * const ADDevicesModelRequestAuthorizeDevicesFailNotification;
extern NSString * const ADDevicesModelRequestAuthorizeDevicesTimeoutNotification;

extern NSString * const ADDevicesModelRequestSharedDevicesSuccessNotification;
extern NSString * const ADDevicesModelRequestSharedDevicesFailNotification;
extern NSString * const ADDevicesModelRequestSharedDevicesTimeoutNotification;

extern NSString * const ADDevicesModelRequestLatestInfoSuccessNotification;
extern NSString * const ADDevicesModelLoginTimeOutNotification;

@interface ADDevicesModel : ADModelBase
{
    ADDevicesModelRequestType _requestType;
    NSTimer *_timer;
    NSArray *_argumentsArrayForDetail;
}

@property (nonatomic, strong, readonly) NSArray *devices;//value contains ADDeviceBase*

@property (nonatomic, strong, readonly) ADDeviceDetail *deviceDetail;//current selected device detail
@property (nonatomic,readonly) NSDictionary *latestInfo;

@property (nonatomic,strong,readonly) NSArray *authDevices;

@property (nonatomic,strong,readonly) NSArray *sharedDevices;

- (void)requestAllDevicesWithArguments:(NSArray *)aArguments;

- (void)requestDetailDeviceInfoWithArguments:(NSArray *)aArguments isContinue:(BOOL)aContinue;

- (void)requestAuthorizeDevicesWithArguments:(NSArray*)aArguments;

- (void)requestSharedDevicesWithArguments:(NSArray *)aArguments;

- (void)requestLatestInfoWithArguments:(NSArray *)aArguments;

@end
