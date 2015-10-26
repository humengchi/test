//
//  ADPIDModel.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-6.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADPIDModel.h"
#import "NSString+Helper.h"
#import "NSMutableArray+Helper.h"

#define ADPIDMODEL_PID_REQUEST_TIME     10

NSString * const ADPIDModelRequestCurrentPIDSuccessNotification = @"ADPIDModelRequestCurrentPIDSuccessNotification";
NSString * const ADPIDModelRequestCurrentPIDFailNotification    = @"ADPIDModelRequestCurrentPIDFailNotification";
NSString * const ADPIDModelRequestCurrentPIDTimeoutNotification = @"ADPIDModelRequestCurrentPIDTimeoutNotification";

NSString * const ADPIDModelRequestAllPIDsSuccessNotification = @"ADPIDModelRequestAllPIDsSuccessNotification";
NSString * const ADPIDModelRequestAllPIDsFailNotification = @"ADPIDModelRequestAllPIDsFailNotification";
NSString * const ADPIDModelRequestAllPIDsTimeoutNotification = @"ADPIDModelRequestAllPIDsTimeoutNotification";
NSString * const ADPIDModelLoginTimeOutNotification = @"ADPIDModelLoginTimeOutNotification";

@implementation ADPIDModel

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

- (void)requestPIDWithDeviceID:(NSString *)aDeviceID
                    isContinue:(BOOL)aIsContinue
{
    _requestType = PIDMODEL_GET_CURRENT_PID;
    _argumentsArrayForCurrentPID = [self argumentConfig:[NSArray arrayWithObject:aDeviceID]];
    if (aIsContinue) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:ADPIDMODEL_PID_REQUEST_TIME
                                                  target:self
                                                selector:@selector(requestPIDIndeed)
                                                userInfo:nil
                                                 repeats:YES];
        [_timer fire];
    }
    [self requestPIDIndeed];
   }

- (void)requestPIDIndeed
{
    NSAssert(_argumentsArrayForCurrentPID, @"_argumentsArrayForCurrentPID is not exsit.");
    if (!_argumentsArrayForCurrentPID) return;
    [super startCallWithService:API_PID_DEVICE_SERVICE
                         method:API_PID_DEVICE_METHOD
                      arguments:_argumentsArrayForCurrentPID];
    
}

- (void)requestFinishedHandleWithData:(NSArray*)aDataArray
{
    if (_requestType == PIDMODEL_GET_CURRENT_PID) {
        NSMutableArray *pidsTemp = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for(ASObject *asObject in aDataArray){
            NSDictionary *data = [asObject properties];
            [pidsTemp addObject:data];
        }
        self.pids=pidsTemp;
    } else if (_requestType == PIDMODEL_GET_ALL_PIDS) {
        
    }
}

- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    NSLog(@"PIDMODEL_GET_CURRENT_PID%@",object);
        NSString *resultCode = [(NSDictionary *)object objectForKey:@"resultCode"];
    
    if ([resultCode isKindOfClass:[NSNull class]]) {
        [self postFailNoti:nil];
        NSAssert(0,@"the data return, is null~. ADGeofenceModel");
        return;
    }
    
    if ([resultCode isEqualToString:@"200"]) {
        
        NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
        [self requestFinishedHandleWithData:dataArray];
        [self postSuccessNoti];
    }
    else
    {
        if (_requestType==PIDMODEL_GET_CURRENT_PID) {
            if ([resultCode isEqualToString:@"202"]||[resultCode isEqualToString:@"203"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ADPIDModelLoginTimeOutNotification object:nil];
            }
        }
        [self postFailNoti:(NSDictionary *)object];
    }
}

- (void)postSuccessNoti
{
    switch (_requestType) {
        case PIDMODEL_GET_CURRENT_PID:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADPIDModelRequestCurrentPIDSuccessNotification object:self];
        }
            break;
            case PIDMODEL_GET_ALL_PIDS:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADPIDModelRequestAllPIDsSuccessNotification object:self];
        }
        default:
            break;
    }
    
}

- (void)postFailNoti:(NSDictionary *)dictionary
{
    switch (_requestType) {
        case PIDMODEL_GET_CURRENT_PID:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADPIDModelRequestCurrentPIDFailNotification object:self userInfo:dictionary];
        }
            break;
        case PIDMODEL_GET_ALL_PIDS:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADPIDModelRequestAllPIDsFailNotification object:self userInfo:dictionary];
        }
        default:
            break;
    }
}

- (void)postTimeoutNoti
{
    switch (_requestType) {
        case PIDMODEL_GET_CURRENT_PID:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADPIDModelRequestCurrentPIDTimeoutNotification object:self];
        }
            break;
        case PIDMODEL_GET_ALL_PIDS:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:ADPIDModelRequestAllPIDsTimeoutNotification object:self];
        }
        default:
            break;
    }
}

@end
