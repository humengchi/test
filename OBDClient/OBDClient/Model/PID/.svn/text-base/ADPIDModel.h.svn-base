//
//  ADPIDModel.h
//  OBDClient
//
//  Created by Holyen Zou on 13-6-6.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADPIDBase.h"

#define KVO_CURRENT_PID_PATH_NAME       @"pids"

typedef enum {
    PIDMODEL_GET_CURRENT_PID = 1,
    PIDMODEL_GET_ALL_PIDS    =2
} ADPIDModelRequestType;

extern NSString * const ADPIDModelRequestCurrentPIDSuccessNotification;
extern NSString * const ADPIDModelRequestCurrentPIDFailNotification;
extern NSString * const ADPIDModelRequestCurrentPIDTimeoutNotification;

extern NSString * const ADPIDModelRequestAllPIDsSuccessNotification;
extern NSString * const ADPIDModelRequestAllPIDsFailNotification;
extern NSString * const ADPIDModelRequestAllPIDsTimeoutNotification;

extern NSString * const ADPIDModelLoginTimeOutNotification;

@interface ADPIDModel : ADModelBase
{
    ADPIDModelRequestType _requestType;
    NSArray *_argumentsArrayForCurrentPID;
    NSTimer *_timer;
    
}

@property (nonatomic, strong) ADPIDBase *currentPID;
@property (nonatomic, strong) NSArray *pids;

- (void)requestPIDWithDeviceID:(NSString *)aDeviceID isContinue:(BOOL)aIsContinue;

@end
