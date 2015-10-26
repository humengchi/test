//
//  ADGeogenceBase.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-21.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGeofenceBase.h"

#define DOUBLE_TO_STRING(d)    [[NSNumber numberWithDouble:d] stringValue]

@implementation ADGeofenceBase

- (id)initWithApplyField:(NSString *)aApplyField
     cmdType:(NSString *)aCmdType
            deviceID:(NSString *)aDeviceID
               geoID:(NSString *)aGeoID
            geoIndex:(NSString *)aGeoIndex
             geoName:(NSString *)aGeoName
                lat1:(NSString *)aLat1
               lat10:(NSString *)aLat10
                lat2:(NSString *)aLat2
                lat3:(NSString *)aLat3
                lat4:(NSString *)aLat4
                lat5:(NSString *)aLat5
                lat6:(NSString *)aLat6
                lat7:(NSString *)aLat7
                lat8:(NSString *)aLat8
                lat9:(NSString *)aLat9
            latitude:(NSString *)aLatitude
                lng1:(NSString *)aLng1
               lng10:(NSString *)aLng10
                lng2:(NSString *)aLng2
                lng3:(NSString *)aLng3
                lng4:(NSString *)aLng4
                lng5:(NSString *)aLng5
                lng6:(NSString *)aLng6
                lng7:(NSString *)aLng7
                lng8:(NSString *)aLng8
                lng9:(NSString *)aLng9
           longitude:(NSString *)aLongitude
              pCount:(NSString *)aPCount
              radius:(NSString *)aRadius
               units:(NSString *)aUnits
{
    if (self = [super init]) {
        self.applyField = aApplyField;
        self.cmdType = aCmdType;
        self.deviceID = aDeviceID;
        self.geoID = aGeoID;
        self.geoIndex = aGeoIndex;
        self.geoName = aGeoName;
        self.lat1 = [aLat1 doubleValue];
        self.lat10 = [aLat10 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat10 doubleValue];
        self.lat2 = [aLat2 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat2 doubleValue];
        self.lat3 = [aLat3 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat3 doubleValue];
        self.lat4 = [aLat4 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat4 doubleValue];
        self.lat5 = [aLat5 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat5 doubleValue];
        self.lat6 = [aLat6 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat6 doubleValue];
        
        self.lat7 = [aLat7 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat7 doubleValue];
        self.lat8 = [aLat8 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat8 doubleValue];
        self.lat9 = [aLat9 isKindOfClass:[NSNull class]] ? NSNotFound : [aLat9 doubleValue];
        self.latitude = [aLatitude isKindOfClass:[NSNull class]] ? NSNotFound : [aLatitude doubleValue];
        self.lng1 = [aLng1 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng1 doubleValue];
        self.lng10 = [aLng10 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng10 doubleValue];
        self.lng2 = [aLng2 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng2 doubleValue];
        self.lng3 = [aLng3 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng3 doubleValue];
        self.lng4 = [aLng4 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng4 doubleValue];
        self.lng5 = [aLng5 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng5 doubleValue];
        self.lng6 = [aLng6 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng6 doubleValue];
        self.lng7 = [aLng7 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng7 doubleValue];
        self.lng8 = [aLng8 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng8 doubleValue];
        self.lng9 = [aLng9 isKindOfClass:[NSNull class]] ? NSNotFound : [aLng9 doubleValue];
        self.longitude = [aLongitude isKindOfClass:[NSNull class]] ? NSNotFound : [aLongitude doubleValue];
        self.pCount = aPCount;
        self.radius = [aRadius isKindOfClass:[NSNull class]] ? NSNotFound : [aRadius floatValue];
        self.units = aUnits;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    NSString *applyField = [aDict objectForKey:@"applyField"];
    NSString *cmdType = [aDict objectForKey:@"cmdType"];
    NSString *deviceID = [aDict objectForKey:@"deviceID"];
    NSString *geoID = [aDict objectForKey:@"geoID"];
    NSString *geoIndex = [aDict objectForKey:@"geoIndex"];
    NSString *geoName = [aDict objectForKey:@"geoName"];
    NSString *lat1 = [aDict objectForKey:@"lat1"];
    NSString *lat10 = [aDict objectForKey:@"lat10"];
    NSString *lat2 = [aDict objectForKey:@"lat2"];
    NSString *lat3 = [aDict objectForKey:@"lat3"];
    NSString *lat4 = [aDict objectForKey:@"lat4"];
    NSString *lat5 = [aDict objectForKey:@"lat5"];
    NSString *lat6 = [aDict objectForKey:@"lat6"];
    NSString *lat7 = [aDict objectForKey:@"lat7"];
    NSString *lat8 = [aDict objectForKey:@"lat8"];
    NSString *lat9 = [aDict objectForKey:@"lat9"];
    NSString *latitude = [aDict objectForKey:@"latitude"];
    NSString *lng1 = [aDict objectForKey:@"lng1"];
    NSString *lng10 = [aDict objectForKey:@"lng10"];
    NSString *lng2 = [aDict objectForKey:@"lng2"];
    NSString *lng3 = [aDict objectForKey:@"lng3"];
    NSString *lng4 = [aDict objectForKey:@"lng4"];
    NSString *lng5 = [aDict objectForKey:@"lng5"];
    NSString *lng6 = [aDict objectForKey:@"lng6"];
    NSString *lng7 = [aDict objectForKey:@"lng7"];
    NSString *lng8 = [aDict objectForKey:@"lng8"];
    NSString *lng9 = [aDict objectForKey:@"lng9"];
    NSString *longitude = [aDict objectForKey:@"longitude"];
    NSString *pCount = [aDict objectForKey:@"pCount"];
    NSString *radius = [aDict objectForKey:@"radius"];
    NSString *units = [aDict objectForKey:@"units"];
    
    return [self initWithApplyField:applyField
                            cmdType:cmdType
                       deviceID:deviceID
                          geoID:geoID
                       geoIndex:geoIndex
                        geoName:geoName
                           lat1:lat1
                          lat10:lat10
                           lat2:lat2
                           lat3:lat3
                           lat4:lat4
                           lat5:lat5
                           lat6:lat6
                           lat7:lat7
                           lat8:lat8
                           lat9:lat9
                       latitude:latitude
                           lng1:lng1
                          lng10:lng10
                           lng2:lng2
                           lng3:lng3
                           lng4:lng4
                           lng5:lng5
                           lng6:lng6
                           lng7:lng7
                           lng8:lng8
                           lng9:lng9
                      longitude:longitude
                         pCount:pCount
                         radius:radius
                          units:units];
}

+ (id)initWithCopy:(ADGeofenceBase *)aGeofenceBase
{
    ADGeofenceBase *geofenceBase = [[ADGeofenceBase alloc] initWithApplyField:aGeofenceBase.applyField
                                                                      cmdType:aGeofenceBase.cmdType
                                                                 deviceID:aGeofenceBase.deviceID
                                                                    geoID:aGeofenceBase.geoID
                                                                 geoIndex:aGeofenceBase.geoIndex
                                                                  geoName:aGeofenceBase.geoName
                                                                     lat1:DOUBLE_TO_STRING(aGeofenceBase.lat1)
                                                                    lat10:DOUBLE_TO_STRING(aGeofenceBase.lat10)
                                                                     lat2:DOUBLE_TO_STRING(aGeofenceBase.lat2)
                                                                     lat3:DOUBLE_TO_STRING(aGeofenceBase.lat3)
                                                                     lat4:DOUBLE_TO_STRING(aGeofenceBase.lat4)
                                                                     lat5:DOUBLE_TO_STRING(aGeofenceBase.lat5)
                                                                     lat6:DOUBLE_TO_STRING(aGeofenceBase.lat6)
                                                                     lat7:DOUBLE_TO_STRING(aGeofenceBase.lat7)
                                                                     lat8:DOUBLE_TO_STRING(aGeofenceBase.lat8)
                                                                     lat9:DOUBLE_TO_STRING(aGeofenceBase.lat9)
                                                                 latitude:DOUBLE_TO_STRING(aGeofenceBase.latitude)
                                                                     lng1:DOUBLE_TO_STRING(aGeofenceBase.lng1)
                                                                    lng10:DOUBLE_TO_STRING(aGeofenceBase.lng10)
                                                                     lng2:DOUBLE_TO_STRING(aGeofenceBase.lng2)
                                                                     lng3:DOUBLE_TO_STRING(aGeofenceBase.lng3)
                                                                     lng4:DOUBLE_TO_STRING(aGeofenceBase.lng4)
                                                                     lng5:DOUBLE_TO_STRING(aGeofenceBase.lng5)
                                                                     lng6:DOUBLE_TO_STRING(aGeofenceBase.lng6)
                                                                     lng7:DOUBLE_TO_STRING(aGeofenceBase.lng7)
                                                                     lng8:DOUBLE_TO_STRING(aGeofenceBase.lng8)
                                                                     lng9:DOUBLE_TO_STRING(aGeofenceBase.lng9)
                                                                longitude:DOUBLE_TO_STRING(aGeofenceBase.longitude)
                                                                   pCount:aGeofenceBase.pCount
                                                                   radius:DOUBLE_TO_STRING(aGeofenceBase.radius)
                                                                    units:aGeofenceBase.units];
    return geofenceBase;
}

@end
