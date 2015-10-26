//
//  ADHistoryPoint.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-20.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADHistoryPoint : NSObject

@property (nonatomic, strong) NSString *VIN;
@property (nonatomic, strong) NSString *accel_x;
@property (nonatomic, strong) NSString *accel_y;
@property (nonatomic, strong) NSString *accel_z;
@property (nonatomic, strong) NSString *address_city;
@property (nonatomic, strong) NSString *address_country;
@property (nonatomic, strong) NSString *address_num;
@property (nonatomic, strong) NSString *address_state;
@property (nonatomic, strong) NSString *address_street;
@property (nonatomic, strong) NSString *address_zip;
@property (nonatomic, strong) NSString *batt_level;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *driving_dist;
@property (nonatomic, strong) NSString *engineRPM;
@property (nonatomic, strong) NSString *fixType;
@property (nonatomic, strong) NSString *fuel_level_bef;
@property (nonatomic, strong) NSString *fuel_level_now;
@property (nonatomic, strong) NSString *geoAlertGeoID;
@property (nonatomic, strong) NSString *geoAlertType;
@property (nonatomic, strong) NSString *geoID;
@property (nonatomic, strong) NSString *gpsDate;
@property (nonatomic, strong) NSString *gpsStamp;
@property (nonatomic, strong) NSString *gpsTime;
@property (nonatomic, strong) NSString *high_temp;
@property (nonatomic, strong) NSString *idle_time;
@property (nonatomic)           double latitude;
@property (nonatomic)           double longitude;
@property (nonatomic, strong) NSString *max_rpm;
@property (nonatomic, strong) NSString *max_speed;
@property (nonatomic, strong) NSString *num_of_dtc;
@property (nonatomic, strong) NSString *raw_data_include;
@property (nonatomic, strong) NSString *raw_x;
@property (nonatomic, strong) NSString *raw_y;
@property (nonatomic, strong) NSString *raw_z;
@property (nonatomic, strong) NSString *serverDate;
@property (nonatomic, strong) NSString *serverTime;
@property (nonatomic, strong) NSString *speed;
@property (nonatomic, strong) NSString *speed_corner;
@property (nonatomic, strong) NSString *speed_dir;
@property (nonatomic, strong) NSString *storeDataType;
@property (nonatomic, strong) NSString *time_remove;
@property (nonatomic, strong) NSString *unauth_time;


- (id)initWithDictionary:(NSDictionary *)aDict;

@end
