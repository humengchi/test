//
//  ADGeogenceBase.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-21.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface ADGeofenceBase : NSObject

@property (nonatomic) NSString* applyField;
@property (nonatomic, strong) NSString *cmdType;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *geoID;
@property (nonatomic, strong) NSString *geoIndex;
@property (nonatomic, strong) NSString *geoName;
@property (nonatomic) double lat1;
@property (nonatomic) double lat10;
@property (nonatomic) double lat2;
@property (nonatomic) double lat3;
@property (nonatomic) double lat4;
@property (nonatomic) double lat5;
@property (nonatomic) double lat6;
@property (nonatomic) double lat7;
@property (nonatomic) double lat8;
@property (nonatomic) double lat9;
@property (nonatomic) double latitude;
@property (nonatomic) double lng1;
@property (nonatomic) double lng10;
@property (nonatomic) double lng2;
@property (nonatomic) double lng3;
@property (nonatomic) double lng4;
@property (nonatomic) double lng5;
@property (nonatomic) double lng6;
@property (nonatomic) double lng7;
@property (nonatomic) double lng8;
@property (nonatomic) double lng9;
@property (nonatomic) double longitude;
@property (nonatomic, strong) NSString *pCount;
@property (nonatomic) double radius;
@property (nonatomic, strong) NSString *units;

@property (nonatomic, assign) CLLocationCoordinate2D *coords;
@property (nonatomic) double  width; //矩形的宽度

@property (nonatomic, assign) BOOL isCircle;

- (id)initWithDictionary:(NSDictionary *)aDict;

+ (id)initWithCopy:(ADGeofenceBase *)aGeofenceBase;

@end
