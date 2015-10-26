//
//  ADDevicesModel.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-3.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDevicesModel.h"
#import "ADSingletonUtil.h"

#define DEVICE_DETAIL_REQUEST_TIME  20

NSString * const ADDevicesModelRequestAllDevicesSuccessNotification   = @"ADDevicesModelRequestAllDevicesSuccessNotification";
NSString * const ADDevicesModelRequestAllDevicesFailNotification      = @"ADDevicesModelRequestAllDevicesFailNotification";
NSString * const ADDevicesModelRequestAllDevicesTimeoutNotification   = @"ADDevicesModelRequestAllDevicesTimeoutNotification";

NSString * const ADDevicesModelRequestDeviceDetailSuccessNotification   = @"ADDevicesModelRequestDeviceDetailSuccessNotification";
NSString * const ADDevicesModelRequestDeviceDetailFailNotification      = @"ADDevicesModelRequestDeviceDetailFailNotification";
NSString * const ADDevicesModelRequestDeviceDetailTimeoutNotification   = @"ADDevicesModelRequestDeviceDetailTimeoutNotification";

NSString * const ADDevicesModelRequestAuthorizeDevicesSuccessNotification   = @"ADDevicesModelRequestAuthorizeDevicesSuccessNotification";
NSString * const ADDevicesModelRequestAuthorizeDevicesFailNotification      = @"ADDevicesModelRequestAuthorizeDevicesFailNotification";
NSString * const ADDevicesModelRequestAuthorizeDevicesTimeoutNotification   = @"ADDevicesModelRequestAuthorizeDevicesTimeoutNotification";

NSString * const ADDevicesModelRequestSharedDevicesSuccessNotification   = @"ADDevicesModelRequestSharedDevicesSuccessNotification";
NSString * const ADDevicesModelRequestSharedDevicesFailNotification      = @"ADDevicesModelRequestSharedDevicesFailNotification";
NSString * const ADDevicesModelRequestSharedDevicesTimeoutNotification   = @"ADDevicesModelRequestSharedDevicesTimeoutNotification";

NSString * const ADDevicesModelRequestLatestInfoSuccessNotification   = @"ADDevicesModelRequestLatestInfoSuccessNotification";
NSString * const ADDevicesModelLoginTimeOutNotification  = @"ADDevicesModelLoginTimeOutNotification";

@interface ADDevicesModel ()

@property (nonatomic, strong) NSArray *devices;
@property (nonatomic, strong) ADDeviceDetail *deviceDetail;
@property (nonatomic, strong) NSArray *authDevices;
@property (nonatomic, strong) NSArray *sharedDevices;
@property (nonatomic) NSDictionary *latestInfo;

@end

@implementation ADDevicesModel

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)cancel
{
    if (_timer) {
        [_timer invalidate];
    }
    [super cancel];
}

- (void)requestAuthorizeDevicesWithArguments:(NSArray *)aArguments
{
//    NSLog(@"requestAuthorizeDevices");
    _requestType = DEVICESMODEL_AUTH_DEVICES;
    [super startCallWithService:API_AUTH_DEVICES_SERVICE method:API_AUTH_DEVICES_METHOD arguments:aArguments];
}

- (void)requestAllDevicesWithArguments:(NSArray *)aArguments
{
    _requestType = DEVICESMODEL_ALL_DEVICES;
    [super startCallWithService:API_ALL_DEVICES_SERVICE
                         method:API_ALL_DEVICES_METHOD
                      arguments:aArguments];
}

- (void)requestSharedDevicesWithArguments:(NSArray *)aArguments
{
    _requestType = DEVICESMODEL_SHARED_DEVICES;
    [super startCallWithService:API_ALL_DEVICES_SERVICE method:API_SHARED_DEVICES_METHOD arguments:aArguments];
}

- (void)requestDetailDeviceInfoWithArguments:(NSArray *)aArguments
                                    isContinue:(BOOL)aContinue
{
    _requestType = DEVICESMODEL_DETAIL_DEVICE;
    _argumentsArrayForDetail = [self argumentConfig:aArguments];
    if (aContinue) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:DEVICE_DETAIL_REQUEST_TIME
                                                  target:self
                                                selector:@selector(requestDetailDeviceIndeed)
                                                userInfo:nil
                                                 repeats:YES];
        [_timer fire];
    }else{
        [self requestDetailDeviceIndeed];
    }
    
}

- (void)requestDetailDeviceIndeed
{
    
    NSAssert(_argumentsArrayForDetail, @"_argumentsArrayForDetail is not exsit.");
    if (!_argumentsArrayForDetail) return;
    [super startCallWithService:API_DETAIL_DEVICE_SERVICE
                         method:API_DETAIL_DEVICE_METHOD
                      arguments:_argumentsArrayForDetail];
}

- (void)requestLatestInfoWithArguments:(NSArray *)aArguments{
    _requestType = DEVICESMODEL_LATEST_INFO;
    [super startCallWithService:API_DETAIL_DEVICE_SERVICE method:API_LATEST_INFO_METHOD arguments:aArguments];
}

- (void)requestFinishedHandleWithData:(NSArray*)aDataArray
{
    if (_requestType == DEVICESMODEL_ALL_DEVICES) {
        NSMutableArray *devicesTemp = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (ASObject *asObject in aDataArray) {
            NSDictionary *data = [asObject properties];
            ADDeviceBase *device = [[ADDeviceBase alloc] initWithDictionary:data];
            [devicesTemp addObject:device];
        }
        [ADSingletonUtil sharedInstance].devices = devicesTemp;
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestAllDevicesSuccessNotification
                                                            object:self];
        self.devices = [ADSingletonUtil sharedInstance].devices;

    } else if (_requestType == DEVICESMODEL_DETAIL_DEVICE) {
        if(aDataArray.count==0){
            self.deviceDetail=nil;
        }else{
            ASObject *asObject = [aDataArray objectAtIndex:0];
            NSDictionary *data = [asObject properties];
            [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestDeviceDetailSuccessNotification
                                                                object:self];
            self.deviceDetail = [[ADDeviceDetail alloc] initWithDictionary:data];
        }
        
    }else if (_requestType == DEVICESMODEL_AUTH_DEVICES){
        NSMutableArray *authDevicesTemp = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (ASObject *asObject in aDataArray) {
            NSDictionary *data = [asObject properties];
            ADDeviceBase *device = [[ADDeviceBase alloc] initWithDictionary:data];
            [authDevicesTemp addObject:device];
        }
        [ADSingletonUtil sharedInstance].authDevices=authDevicesTemp;
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestAuthorizeDevicesSuccessNotification
                                                            object:self];
        self.authDevices = [ADSingletonUtil sharedInstance].authDevices;
    }else if (_requestType == DEVICESMODEL_SHARED_DEVICES){
        NSMutableArray *sharedDevicesTemp = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (ASObject *asObject in aDataArray) {
            NSDictionary *data = [asObject properties];
            ADDeviceBase *device = [[ADDeviceBase alloc] initWithDictionary:data];
            [sharedDevicesTemp addObject:device];
        }
        [ADSingletonUtil sharedInstance].sharedDevices=sharedDevicesTemp;
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestSharedDevicesSuccessNotification
                                                            object:self];
        self.sharedDevices=sharedDevicesTemp;
    }else if (_requestType == DEVICESMODEL_LATEST_INFO){
            NSDictionary *data = [aDataArray objectAtIndex:0];
            [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestLatestInfoSuccessNotification
                                                                object:self userInfo:data];
    }
    else {
        NSAssert(0, @"requestType is not handle");
    }
}


#pragma mark - implement super class methods
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    NSLog(@"Devicemodel:%@",object);
    NSString *resultCode = [(NSDictionary *)object objectForKey:@"resultCode"];
    
    if ([resultCode isKindOfClass:[NSNull class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestAllDevicesFailNotification
                                                            object:self];

        NSAssert(0,@"the data return, is null~. ADDevicesModel");
        return;
    }
    
    if ([resultCode isEqualToString:@"200"]) {
        NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
        [self requestFinishedHandleWithData:dataArray];
    }
    else
    {
        if (_requestType == DEVICESMODEL_ALL_DEVICES) {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestAllDevicesFailNotification
                                                                object:self userInfo:(NSDictionary *)object];
        } else if (_requestType == DEVICESMODEL_DETAIL_DEVICE) {
            if ([resultCode isEqualToString:@"202"]||[resultCode isEqualToString:@"203"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelLoginTimeOutNotification object:nil];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestDeviceDetailFailNotification
                                                                object:self userInfo:(NSDictionary *)object];
        }else if (_requestType == DEVICESMODEL_AUTH_DEVICES){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestAuthorizeDevicesFailNotification
                                                                object:self userInfo:(NSDictionary *)object];
        }else if (_requestType == DEVICESMODEL_SHARED_DEVICES){
            //allDevicesFail now
            [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestSharedDevicesFailNotification
                                                                object:self userInfo:(NSDictionary *)object];
        }else if (_requestType == DEVICESMODEL_LATEST_INFO){
            
        }
        else {
            NSAssert(0, @"not handle request type");
        }
        
        
    }
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall error:(NSError *)aError
{
    if (_requestType == DEVICESMODEL_ALL_DEVICES) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestAllDevicesFailNotification
                                                            object:self];
    } else if (_requestType == DEVICESMODEL_DETAIL_DEVICE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestDeviceDetailFailNotification
                                                            object:self];
    }else if (_requestType == DEVICESMODEL_AUTH_DEVICES){
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestAuthorizeDevicesFailNotification
                                                            object:self];
    
    }else if (_requestType == DEVICESMODEL_SHARED_DEVICES){
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDevicesModelRequestSharedDevicesFailNotification
                                                            object:self];
    }
    else {
        NSAssert(0, @"not handle request type");
    }
}

@end
