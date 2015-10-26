//
//  ADHistoryPoint.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-20.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHistoryPoint.h"

@implementation ADHistoryPoint

- (id)initWithVIN:(NSString *)aVIN
          accel_x:(NSString *)aAccel_x
          accel_y:(NSString *)aAccel_y
          accel_z:(NSString *)aAccel_z
     address_city:(NSString *)aAddress_city
  address_country:(NSString *)aAddress_country
      address_num:(NSString *)aAddress_num
    address_state:(NSString *)aAddress_state
   address_street:(NSString *)aAddress_street
      address_zip:(NSString *)aAddress_zip
       batt_level:(NSString *)aBatt_level
             code:(NSString *)aCode
         deviceID:(NSString *)aDeviceID
     driving_dist:(NSString *)aDriving_dist
        engineRPM:(NSString *)aEngineRPM
          fixType:(NSString *)aFixType
   fuel_level_bef:(NSString *)aFuel_level_bef
   fuel_level_now:(NSString *)aFuel_level_now
    geoAlertGeoID:(NSString *)aGeoAlertGeoID
     geoAlertType:(NSString *)aGeoAlertType
            geoID:(NSString *)aGeoID
          gpsDate:(NSString *)aGpsDate
         gpsStamp:(NSString *)aGpsStamp
          gpsTime:(NSString *)aGpsTime
        high_temp:(NSString *)aHigh_temp
        idle_time:(NSString *)aIdle_time
         latitude:(NSString *)aLatitude
        longitude:(NSString *)aLongitude
          max_rpm:(NSString *)aMax_rpm
        max_speed:(NSString *)aMax_speed
       num_of_dtc:(NSString *)aNum_of_dtc
 raw_data_include:(NSString *)aRaw_data_include
            raw_x:(NSString *)aRaw_x
            raw_y:(NSString *)aRaw_y
            raw_z:(NSString *)aRaw_z
       serverDate:(NSString *)aServerDate
       serverTime:(NSString *)aServerTime
            speed:(NSString *)aSpeed
     speed_corner:(NSString *)aSpeed_corner
        speed_dir:(NSString *)aSpeed_dir
    storeDataType:(NSString *)aStoreDataType
      time_remove:(NSString *)aTime_remove
      unauth_time:(NSString *)aUnauth_time
{
    if (self = [super init]) {
        self.VIN = aVIN;
        self.accel_x = aAccel_x;
        self.accel_y = aAccel_y;
        self.accel_z = aAccel_z;
        self.address_city = aAddress_city;
        self.address_country = aAddress_country;
        self.address_num = aAddress_num;
        self.address_state = aAddress_state;
        self.address_street = aAddress_street;
        self.address_zip = aAddress_zip;
        self.batt_level = aBatt_level;
        self.code = aCode;
        self.deviceID = aDeviceID;
        self.driving_dist = aDriving_dist;
        self.engineRPM = aEngineRPM;
        self.fixType = aFixType;
        self.fuel_level_bef = aFuel_level_bef;
        self.fuel_level_now = aFuel_level_now;
        self.geoAlertGeoID = aGeoAlertGeoID;
        self.geoAlertType = aGeoAlertType;
        self.geoID = aGeoID;
        self.gpsDate = aGpsDate;
        self.gpsStamp = aGpsStamp;
        self.gpsTime = aGpsTime;
        self.high_temp = aHigh_temp;
        self.idle_time = aIdle_time;
        self.latitude = [aLatitude doubleValue] == 0 ? 31.209093 : [aLatitude doubleValue];
        self.longitude = [aLongitude doubleValue] == 0 ? 121.58213 : [aLongitude doubleValue];
        self.max_rpm = aMax_rpm;
        self.max_speed = aMax_speed;
        self.num_of_dtc = aNum_of_dtc;
        self.raw_data_include = aRaw_data_include;
        self.raw_x = aRaw_x;
        self.raw_y = aRaw_y;
        self.raw_z = aRaw_z;
        self.serverDate = aServerDate;
        self.serverTime = aServerTime;
        self.speed = aSpeed;
        self.speed_corner = aSpeed_corner;
        self.speed_dir = aSpeed_dir;
        self.storeDataType = aStoreDataType;
        self.time_remove = aTime_remove;
        self.unauth_time = aUnauth_time;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    
    NSString *VIN = [aDict objectForKey:@"VIN"];
    NSString *accel_x = [aDict objectForKey:@"accel_x"];
    NSString *accel_y = [aDict objectForKey:@"accel_y"];
    NSString *accel_z = [aDict objectForKey:@"accel_z"];
    NSString *address_city = [aDict objectForKey:@"address_city"];
    NSString *address_country = [aDict objectForKey:@"address_country"];
    NSString *address_num = [aDict objectForKey:@"address_num"];
    NSString *address_state = [aDict objectForKey:@"address_state"];
    NSString *address_street = [aDict objectForKey:@"address_street"];
    NSString *address_zip = [aDict objectForKey:@"address_zip"];
    NSString *batt_level = [aDict objectForKey:@"batt_level"];
    NSString *code = [aDict objectForKey:@"code"];
    NSString *deviceID = [aDict objectForKey:@"deviceID"];
    NSString *driving_dist = [aDict objectForKey:@"driving_dist"];
    NSString *engineRPM = [aDict objectForKey:@"engineRPM"];
    NSString *fixType = [aDict objectForKey:@"fixType"];
    NSString *fuel_level_bef = [aDict objectForKey:@"fuel_level_bef"];
    NSString *fuel_level_now = [aDict objectForKey:@"fuel_level_now"];
    NSString *geoAlertGeoID = [aDict objectForKey:@"geoAlertGeoID"];
    NSString *geoAlertType = [aDict objectForKey:@"geoAlertType"];
    NSString *geoID = [aDict objectForKey:@"geoID"];
    NSString *gpsDate = [aDict objectForKey:@"gpsDate"];
    NSString *gpsStamp = [aDict objectForKey:@"gpsStamp"];
    NSString *gpsTime = [aDict objectForKey:@"gpsTime"];
    NSString *high_temp = [aDict objectForKey:@"high_temp"];
    NSString *idle_time = [aDict objectForKey:@"idle_time"];
    NSString *latitude = [aDict objectForKey:@"latitude"];
    NSString *longitude = [aDict objectForKey:@"longitude"];
    NSString *max_rpm = [aDict objectForKey:@"max_rpm"];
    NSString *max_speed = [aDict objectForKey:@"max_speed"];
    NSString *num_of_dtc = [aDict objectForKey:@"num_of_dtc"];
    NSString *raw_data_include = [aDict objectForKey:@"raw_data_include"];
    NSString *raw_x = [aDict objectForKey:@"raw_x"];
    NSString *raw_y = [aDict objectForKey:@"raw_y"];
    NSString *raw_z = [aDict objectForKey:@"raw_z"];
    NSString *serverDate = [aDict objectForKey:@"serverDate"];
    NSString *serverTime = [aDict objectForKey:@"serverTime"];
    NSString *speed = [aDict objectForKey:@"speed"];
    NSString *speed_corner = [aDict objectForKey:@"speed_corner"];
    NSString *speed_dir = [aDict objectForKey:@"speed_dir"];
    NSString *storeDataType = [aDict objectForKey:@"storeDataType"];
    NSString *time_remove = [aDict objectForKey:@"time_remove"];
    NSString *unauth_time = [aDict objectForKey:@"unauth_time"];
    
    return [self initWithVIN:VIN
                     accel_x:accel_x
                     accel_y:accel_y
                     accel_z:accel_z
                address_city:address_city
             address_country:address_country
                 address_num:address_num
               address_state:address_state
              address_street:address_street
                 address_zip:address_zip
                  batt_level:batt_level
                        code:code
                    deviceID:deviceID
                driving_dist:driving_dist
                   engineRPM:engineRPM
                     fixType:fixType
              fuel_level_bef:fuel_level_bef
              fuel_level_now:fuel_level_now
               geoAlertGeoID:geoAlertGeoID
                geoAlertType:geoAlertType
                       geoID:geoID
                     gpsDate:gpsDate
                    gpsStamp:gpsStamp
                     gpsTime:gpsTime
                   high_temp:high_temp
                   idle_time:idle_time
                    latitude:latitude
                   longitude:longitude
                     max_rpm:max_rpm
                   max_speed:max_speed
                  num_of_dtc:num_of_dtc
            raw_data_include:raw_data_include
                       raw_x:raw_x
                       raw_y:raw_y
                       raw_z:raw_z
                  serverDate:serverDate
                  serverTime:serverTime
                       speed:speed
                speed_corner:speed_corner
                   speed_dir:speed_dir
               storeDataType:storeDataType
                 time_remove:time_remove
                 unauth_time:unauth_time];
}

@end
