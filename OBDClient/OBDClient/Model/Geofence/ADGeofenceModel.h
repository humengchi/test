//
//  ADGeofenceModel.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-21.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADGeofenceBase.h"

#define KVO_GEOGENCE_ALL_PATH_NAME              @"geogences"

typedef enum
{
    GEOGENCEMODEL_GET_ALL = 1,
    GEOGENCEMODEL_CREATE = 2,
    GEOGENCEMODEL_UPDATE = 3,
    GEOGENCEMODEL_REMOVE = 4
} ADGeogenceModelRequestType;

extern NSString * const ADGeofenceModelRequestSuccessNotification;
extern NSString * const ADGeofenceModelRequestFailNotification;
extern NSString * const ADGeofenceModelRequestTimeoutNotification;

extern NSString * const ADGeofenceModelUpdateSuccessNotification;
extern NSString * const ADGeofenceModelUpdateFailNotification;
extern NSString * const ADGeofenceModelUpdateTimeoutNotification;

extern NSString * const ADGeofenceModelCreateSuccessNotification;
extern NSString * const ADGeofenceModelCreateFailNotification;
extern NSString * const ADGeofenceModelCreateTimeoutNotification;

extern NSString * const ADGeofenceModelRemoveSuccessNotification;
extern NSString * const ADGeofenceModelRemoveFailNotification;
extern NSString * const ADGeofenceModelRemoveTimeoutNotification;
extern NSString * const ADGeofenceModelLoginTimeOutNotification;

@interface ADGeofenceModel : ADModelBase
{
    ADGeogenceModelRequestType _requestType;
    ADGeofenceBase *_currentUpdateGeofenceBase;
}

@property (nonatomic, strong) NSString *removeOfDeviceID;
@property (nonatomic, strong) NSString *removeOfGeoID;

@property (nonatomic, strong) NSArray *geogences;

- (void)requestGeofencesWithDeviceID:(NSString *)aDeviceID;

- (void)createGeofenceWithGeofenceBase:(ADGeofenceBase *)aGeofenceBase;

- (void)updateGeofenceWithNewGeofenceBase:(ADGeofenceBase *)aGeofenceBase
                          oldGeofenceBase:(ADGeofenceBase *)aOldGeofenceBase;

- (void)removeGeofenceWithDeviceID:(NSString *)aDeviceID geoID:(NSString *)aGeoID;

@end
