//
//  ADDTCsModel.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-17.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADDTCBase.h"

typedef enum{
    DTCSMODEL_ALL_DTCS = 0,
    DTCSMODEL_DTC_INFOS = 1
    
} ADDtcsModelRequestType;

#define KVO_DTCS_PATH_NAME              @"dtcs"
#define KVO_DTCS_INFO_PATH_NAME         @"dtcsInfo"

extern NSString * const ADDTCsModelRequestSuccessNotification;
extern NSString * const ADDTCsModelRequestFailNotification;
extern NSString * const ADDTCsModelRequestTimeoutNotification;
extern NSString * const ADDTCsModelLoginTimeOutNotification;

@interface ADDTCsModel : ADModelBase
{
    ADDtcsModelRequestType _requestType;
}

@property (nonatomic, strong) NSArray *dtcs;

@property (nonatomic) NSArray *dtcsInfo;

- (void)requestDTCsWithArguments:(NSArray *)aArguments;

- (void)requestDTCInfoWithArguments:(NSArray *)aAguments;

@end
