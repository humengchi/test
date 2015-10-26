//
//  ADDeviceDetail.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDeviceDetail.h"

@interface ADDeviceDetail ()

@property (nonatomic, strong) NSString *MDN;
@property (nonatomic, strong) NSString *accel_x;
@property (nonatomic, strong) NSString *accel_y;
@property (nonatomic, strong) NSString *accel_z;
@property (nonatomic, strong) NSDate   *activationDate;


@property (nonatomic, strong) NSString *address_city;
@property (nonatomic, strong) NSString *address_country;
@property (nonatomic, strong) NSString *address_num;
@property (nonatomic, strong) NSString *address_state;
@property (nonatomic, strong) NSString *address_street;
@property (nonatomic, strong) NSString *address_zip;
@property (nonatomic, strong) NSString *altitude;
@property (nonatomic)         float     batt_level;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) NSString *d_vin;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *driving_dist;
@property (nonatomic)         BOOL      enabled;
@property (nonatomic, strong) NSString *engineRPM;
@property (nonatomic, strong) NSString *fixType;
@property (nonatomic)         float     fuel_level_bef;
@property (nonatomic)         float     fuel_level_now;
@property (nonatomic, strong) NSString *geoID;
@property (nonatomic, strong) NSString *gpsDate;
@property (nonatomic, strong) NSString *gpsTime;
@property (nonatomic, strong) NSString *high_temp;
@property (nonatomic, strong) NSString *heading;
@property (nonatomic, strong) NSString *idle_time;
@property (nonatomic, strong) NSString *imsi;
@property (nonatomic)         float     latitude;
@property (nonatomic)         float     longitude;
@property (nonatomic, strong) NSString *max_rpm;
@property (nonatomic, strong) NSString *max_speed;
@property (nonatomic, strong) NSString *num_of_dtc;
@property (nonatomic, strong) NSString *onLineStatus;
@property (nonatomic, strong) NSString *ratePlan;


@property (nonatomic, strong) NSString *raw_data_include;
@property (nonatomic, strong) NSString *raw_x;
@property (nonatomic, strong) NSString *raw_y;
@property (nonatomic, strong) NSString *raw_z;
@property (nonatomic)         float     speed;
@property (nonatomic, strong) NSString *speed_corner;
@property (nonatomic, strong) NSString *speed_dir;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSDate   *time_remove;
@property (nonatomic, strong) NSDate   *unauth_time;
@property (nonatomic, strong) NSString *totalMileage;
@property (nonatomic, strong) NSString *ign;

@property (nonatomic, strong) NSDictionary *lastLocation;

@end

@implementation ADDeviceDetail

- (id)initWithMDN:(NSString *)aMDN
          accel_x:(NSString *)aAccel_x
          accel_y:(NSString *)aAccel_y
          accel_z:(NSString *)aAccel_z
   activationDate:(NSString *)aActivationDate
     address_city:(NSString *)aAddress_city
  address_country:(NSString *)aAddress_country
      address_num:(NSString *)aAddress_num
    address_state:(NSString *)aAddress_state
   address_street:(NSString *)aAddress_street
      address_zip:(NSString *)aAddress_zip
         altitude:(NSString *)aAltitude
       batt_level:(NSString *)aBatt_level
             code:(NSString *)aCode
            d_vin:(NSString *)aD_vin
         deviceID:(NSString *)aDeviceID
     driving_dist:(NSString *)aDriving_dist
          enabled:(NSString *)aEnabled
        engineRPM:(NSString *)aEngineRPM
          fixType:(NSString *)aFixType
   fuel_level_bef:(NSString *)aFuel_level_bef
   fuel_level_now:(NSString *)aFuel_level_now
            geoID:(NSString *)aGeoID
          gpsDate:(NSString *)aGpsDate
          gpsTime:(NSString *)aGpsTime
        high_temp:(NSString *)aHigh_temp
          heading:(NSString *)aHeading
        idle_time:(NSString *)aIdle_time
             imsi:(NSString *)aImsi
         latitude:(NSString *)aLatitude
        longitude:(NSString *)aLongitude
          max_rpm:(NSString *)aMax_rpm
        max_speed:(NSString *)aMax_speed
       num_of_dtc:(NSString *)aNum_of_dtc
     onLineStatus:(NSString *)aonLineStatus
         ratePlan:(NSString *)aRatePlan
 raw_data_include:(NSString *)aRaw_data_include
            raw_x:(NSString *)aRaw_x
            raw_y:(NSString *)aRaw_y
            raw_z:(NSString *)aRaw_z
            speed:(NSString *)aSpeed
     speed_corner:(NSString *)aSpeed_corner
        speed_dir:(NSString *)aSpeed_dir
           status:(NSString *)aStatus
      time_remove:(NSString *)aTime_remove
      unauth_time:(NSString *)aUnauth_time
     totalMileage:(NSString *)aTotalMileage
              ign:(NSString *)aIgn
     lastLocation:(NSDictionary *)aLastLocation
{
    if (self = [super init]) {

        self.MDN = aMDN;
        self.accel_x = aAccel_x;
        self.accel_y = aAccel_y;
        self.accel_z = aAccel_z;
        self.activationDate = [aActivationDate dateFromStringHasTime:NO];
        self.address_city = aAddress_city;
        self.address_country = aAddress_country;
        NSLog(@"%@====%@",aLatitude,aLongitude);
        if (aLatitude==nil&&aLongitude==nil) {
            self.address_num=NSLocalizedStringFromTable(@"noLocation",@"MyString", @"");
        }
        
        else if ([aLatitude floatValue]==0&&[aLongitude floatValue]==0) {
            self.address_num=NSLocalizedStringFromTable(@"noposition",@"MyString", @"");
        }else{
            self.address_num=aAddress_num;
        }
        
//        self.address_num = ([aLatitude floatValue]==0&&[aLongitude floatValue]==0)? NSLocalizedStringFromTable(@"noLocation",@"MyString", @""):aAddress_num;
        self.address_state = aAddress_state;
        self.address_street = aAddress_street;
        self.address_zip = aAddress_zip;
        self.altitude = aAltitude;
        self.batt_level = [aBatt_level floatValue];
        self.code = aCode;
        self.d_vin = aD_vin;
        self.deviceID = aDeviceID;
        self.driving_dist = aDriving_dist;
        self.enabled = [aEnabled isEqualToString:@"1"] ? YES : NO;
        self.engineRPM = aEngineRPM;
        self.fixType = aFixType;
        self.fuel_level_bef = [aFuel_level_bef floatValue];
        self.fuel_level_now = [aFuel_level_now floatValue];
        self.geoID = aGeoID;
        self.gpsDate = aGpsDate;
        self.gpsTime = aGpsTime;
        self.high_temp = aHigh_temp;
        self.heading = aHeading;
        self.idle_time = aIdle_time;
        self.imsi = aImsi;
        self.latitude = [aLatitude floatValue];
        self.longitude = [aLongitude floatValue];
        self.max_rpm = aMax_rpm;
        self.max_speed = aMax_speed;
        self.num_of_dtc = aNum_of_dtc;
        self.onLineStatus = aonLineStatus;
        self.ratePlan = aRatePlan;
        self.raw_data_include = aRaw_data_include;
        self.raw_x = aRaw_x;
        self.raw_y = aRaw_y;
        self.raw_z = aRaw_z;
        self.speed = [aSpeed floatValue];
        self.speed_corner = aSpeed_corner;
        self.speed_dir = aSpeed_dir;
        self.status = aStatus;
        self.time_remove = [aTime_remove dateFromStringHasTime:YES];
        self.unauth_time = [aUnauth_time dateFromStringHasTime:YES];
        self.totalMileage = aTotalMileage;
        self.ign = aIgn;
        self.lastLocation=aLastLocation;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    NSString *MDN = [aDict objectForKey:@"MDN"];
    NSString *accel_x = [aDict objectForKey:@"accel_x"];
    NSString *accel_y = [aDict objectForKey:@"accel_y"];
    NSString *accel_z = [aDict objectForKey:@"accel_z"];
    NSString *activationDate = [aDict objectForKey:@"activationDate"];
    NSString *address_city = [aDict objectForKey:@"address_city"];
    NSString *address_country = [aDict objectForKey:@"address_country"];
    NSString *address_num = [aDict objectForKey:@"address_num"];
    NSString *address_state = [aDict objectForKey:@"address_state"];
    NSString *address_street = [aDict objectForKey:@"address_street"];
    NSString *address_zip = [aDict objectForKey:@"address_zip"];
    NSString *altitude = [aDict objectForKey:@"altitude"];
    NSString *batt_level = [aDict objectForKey:@"batt_level"];
    NSString *code = [aDict objectForKey:@"code"];
    NSString *d_vin = [aDict objectForKey:@"d_vin"];
    NSString *deviceID = [aDict objectForKey:@"deviceID"];
    NSString *driving_dist = [aDict objectForKey:@"driving_dist"];
    NSString *enabled = [aDict objectForKey:@"enabled"];
    NSString *engineRPM = [aDict objectForKey:@"engineRPM"];
    NSString *fixType = [aDict objectForKey:@"fixType"];
    NSString *fuel_level_bef = [aDict objectForKey:@"fuel_level_bef"];
    NSString *fuel_level_now = [aDict objectForKey:@"fuel_level_now"];
    NSString *geoID = [aDict objectForKey:@"geoID"];
    NSString *gpsDate = [aDict objectForKey:@"gpsDate"];
    NSString *gpsTime = [aDict objectForKey:@"gpsTime"];
    NSString *high_temp = [aDict objectForKey:@"high_temp"];
    NSString *heading = [aDict objectForKey:@"heading"];
    NSString *idle_time = [aDict objectForKey:@"idle_time"];
    NSString *imsi = [aDict objectForKey:@"imsi"];
    NSString *latitude = [aDict objectForKey:@"latitude"];
    NSString *longitude = [aDict objectForKey:@"longitude"];
    NSString *max_rpm = [aDict objectForKey:@"max_rpm"];
    NSString *max_speed = [aDict objectForKey:@"max_speed"];
    NSString *num_of_dtc = [aDict objectForKey:@"num_of_dtc"];
    NSString *onLineStatus = [aDict objectForKey:@"onLineStatus"];
    NSString *ratePlan = [aDict objectForKey:@"ratePlan"];
    NSString *raw_data_include = [aDict objectForKey:@"raw_data_include"];
    NSString *raw_x = [aDict objectForKey:@"raw_x"];
    NSString *raw_y = [aDict objectForKey:@"raw_y"];
    NSString *raw_z = [aDict objectForKey:@"raw_z"];
    NSString *speed = [aDict objectForKey:@"speed"];
    NSString *speed_corner = [aDict objectForKey:@"speed_corner"];
    NSString *speed_dir = [aDict objectForKey:@"speed_dir"];
    NSString *status = [aDict objectForKey:@"status"];
    NSString *time_remove = [aDict objectForKey:@"time_remove"];
    NSString *unauth_time = [aDict objectForKey:@"unauth_time"];
    NSString *totalMileage = [aDict objectForKey:@"totalMileage"];
    NSString *ign = [[aDict objectForKey:@"ign"] isKindOfClass:[NSNumber class]]?[[aDict objectForKey:@"ign"] stringValue ]:[aDict objectForKey:@"ign"];
    NSDictionary *lastLocation;
    if([self isNull:[aDict objectForKey:@"lastlocation"]]){
        lastLocation=[[aDict objectForKey:@"lastlocation"] properties];
//        NSLog(@"lastLocationlastLocation%@",lastLocation);
    }
    return [self initWithMDN:MDN
                     accel_x:accel_x
                     accel_y:accel_y
                     accel_z:accel_z
              activationDate:activationDate
                address_city:address_city
             address_country:address_country
                 address_num:address_num
               address_state:address_state
              address_street:address_street
                 address_zip:address_zip
                    altitude:altitude
                  batt_level:batt_level
                        code:code
                       d_vin:d_vin
                    deviceID:deviceID
                driving_dist:driving_dist
                     enabled:enabled
                   engineRPM:engineRPM
                     fixType:fixType
              fuel_level_bef:fuel_level_bef
              fuel_level_now:fuel_level_now
                       geoID:geoID
                     gpsDate:gpsDate
                     gpsTime:gpsTime
                   high_temp:high_temp
                     heading:heading
                   idle_time:idle_time
                        imsi:imsi
                    latitude:latitude
                   longitude:longitude
                     max_rpm:max_rpm
                   max_speed:max_speed
                  num_of_dtc:num_of_dtc
                onLineStatus:onLineStatus
                    ratePlan:ratePlan
            raw_data_include:raw_data_include
                       raw_x:raw_x
                       raw_y:raw_y
                       raw_z:raw_z
                       speed:speed
                speed_corner:speed_corner
                   speed_dir:speed_dir
                      status:status
                 time_remove:time_remove
                 unauth_time:unauth_time
                totalMileage:totalMileage
                         ign:ign
                lastLocation:lastLocation
            ];
}

-(BOOL)isNull:(id)object
{
    // 判断是否为空
    if ([object isEqual:[NSNull null]] || object==[NSNull null]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if ([object isKindOfClass:[NSString class]])
    {
        return NO;
    }
    else if (object==nil || object == NULL){
        return NO;
    }
    
    return YES;
}


@end
