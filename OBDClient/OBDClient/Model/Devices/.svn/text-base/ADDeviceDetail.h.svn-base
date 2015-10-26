//
//  ADDeviceDetail.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+Helper.h"

@interface ADDeviceDetail : NSObject

@property (nonatomic, strong, readonly) NSString *MDN;
@property (nonatomic, strong, readonly) NSString *accel_x;
@property (nonatomic, strong, readonly) NSString *accel_y;
@property (nonatomic, strong, readonly) NSString *accel_z;
@property (nonatomic, strong, readonly) NSDate   *activationDate;


@property (nonatomic, strong, readonly) NSString *address_city;
@property (nonatomic, strong, readonly) NSString *address_country;
@property (nonatomic, strong, readonly) NSString *address_num;
@property (nonatomic, strong, readonly) NSString *address_state;
@property (nonatomic, strong, readonly) NSString *address_street;
@property (nonatomic, strong, readonly) NSString *address_zip;
@property (nonatomic, strong, readonly) NSString *altitude;
@property (nonatomic, readonly)         float     batt_level;
@property (nonatomic, strong, readonly) NSString *code;
@property (nonatomic, strong, readonly) NSString *d_vin;
@property (nonatomic, strong, readonly) NSString *deviceID;
@property (nonatomic, strong, readonly) NSString *driving_dist;
@property (nonatomic, readonly)         BOOL      enabled;
@property (nonatomic, strong, readonly) NSString *engineRPM;
@property (nonatomic, strong, readonly) NSString *fixType;
@property (nonatomic, readonly)         float     fuel_level_bef;
@property (nonatomic, readonly)         float     fuel_level_now;
@property (nonatomic, strong, readonly) NSString *geoID;
@property (nonatomic, strong, readonly) NSString  *gpsDate;
@property (nonatomic, strong, readonly) NSString *gpsTime;
@property (nonatomic, strong, readonly) NSString *high_temp;
@property (nonatomic, strong, readonly) NSString *heading;
@property (nonatomic, strong, readonly) NSString *idle_time;
@property (nonatomic, strong, readonly) NSString *imsi;
@property (nonatomic, readonly)         float     latitude;
@property (nonatomic, readonly)         float     longitude;
@property (nonatomic, strong, readonly) NSString *max_rpm;
@property (nonatomic, strong, readonly) NSString *max_speed;
@property (nonatomic, strong, readonly) NSString *num_of_dtc;
@property (nonatomic, strong, readonly) NSString *onLineStatus;
@property (nonatomic, strong, readonly) NSString *ratePlan;


@property (nonatomic, strong, readonly) NSString *raw_data_include;
@property (nonatomic, strong, readonly) NSString *raw_x;
@property (nonatomic, strong, readonly) NSString *raw_y;
@property (nonatomic, strong, readonly) NSString *raw_z;
@property (nonatomic, readonly)         float     speed;
@property (nonatomic, strong, readonly) NSString *speed_corner;
@property (nonatomic, strong, readonly) NSString *speed_dir;
@property (nonatomic, strong, readonly) NSString *status;
@property (nonatomic, strong, readonly) NSDate   *time_remove;
@property (nonatomic, strong, readonly) NSDate   *unauth_time;
@property (nonatomic, strong, readonly) NSString *totalMileage;
@property (nonatomic, strong, readonly) NSString *ign;

@property (nonatomic, strong, readonly) NSDictionary *lastLocation;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end
