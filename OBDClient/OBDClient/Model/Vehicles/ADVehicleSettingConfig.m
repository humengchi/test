//
//  ADVehicleSettingConfig.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-29.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleSettingConfig.h"

@implementation ADVehicleSettingConfig

- (id)initWithDictionary:(NSDictionary *)aDict{
    
    if(self=[super init]){
        NSString *accel = [aDict objectForKey:@"accel"];
        NSString *accele_break_apply = [aDict objectForKey:@"accele_break_apply"];
        NSString *angle = [aDict objectForKey:@"angle"];
        NSString *battery = [aDict objectForKey:@"battery"];
        NSString *battery_apply = [aDict objectForKey:@"battery_apply"];
        NSString *coolant_temp = [aDict objectForKey:@"coolant_temp"];
        NSString *cornering_apply = [aDict objectForKey:@"cornering_apply"];
        NSString *coolant_temp_apply = [aDict objectForKey:@"coolant_temp_apply"];
        NSString *deviceID = [aDict objectForKey:@"deviceID"];
        NSString *dle_apply = [aDict objectForKey:@"dle_apply"];
        NSString *fast_heartbeat_cnt = [aDict objectForKey:@"fast_heartbeat_cnt"];
        NSString *fast_heartbeat_cnt_apply = [aDict objectForKey:@"fast_heartbeat_cnt_apply"];
        NSString *fuel_level = [aDict objectForKey:@"fuel_level"];
        NSString *fuel_level_apply = [aDict objectForKey:@"fuel_level_apply"];
        NSString *fuel_level_change = [aDict objectForKey:@"fuel_level_change"];
        NSString *fuel_level_change_apply = [aDict objectForKey:@"fuel_level_change_apply"];
        NSString *fuel_limit = [aDict objectForKey:@"fuel_limit"];
        NSString *fuel_trim_apply = [aDict objectForKey:@"fuel_trim_apply"];
        NSString *heartbeat_interval = [aDict objectForKey:@"heartbeat_interval"];
        
        NSString *heartbeat_interval_apply = [aDict objectForKey:@"heartbeat_interval_apply"];
        
        NSString *heartbeat_type = [aDict objectForKey:@"heartbeat_type"];
        NSString *heartbeat_type_apply = [aDict objectForKey:@"heartbeat_type_apply"];
        NSString *hg_hyst = [aDict objectForKey:@"hg_hyst"];
        NSString *highG = [aDict objectForKey:@"highG"];
        NSString *idle = [aDict objectForKey:@"idle"];
        NSString *orient = [aDict objectForKey:@"orient"];
        NSString *raw_data_apply = [aDict objectForKey:@"raw_data_apply"];
        NSString *raw_data_include = [aDict objectForKey:@"raw_data_include"];
        NSString *rpm = [aDict objectForKey:@"rpm"];
        NSString *rpm_apply = [aDict objectForKey:@"rpm_apply"];
        NSString *rpm_duration = [aDict objectForKey:@"rpm_duration"];
        NSString *rpm_duration_apply = [aDict objectForKey:@"rpm_duration_apply"];
        NSString *slop_duration = [aDict objectForKey:@"slop_duration"];
        NSString *slop_thresh = [aDict objectForKey:@"slop_thresh"];
        NSString *speed_duration = [aDict objectForKey:@"speed_duration"];
        
        NSString *speed_duration_apply = [aDict objectForKey:@"speed_duration_apply"];
        NSString *speed = [aDict objectForKey:@"speed"];
        NSString *speed_apply = [aDict objectForKey:@"speed_apply"];
        NSString *turn = [aDict objectForKey:@"turn"];
        NSString *unauth_delay = [aDict objectForKey:@"unauth_delay"];
        NSString *unauth_duration = [aDict objectForKey:@"unauth_duration"];
        NSString *unauth_thresh = [aDict objectForKey:@"unauth_thresh"];
        NSString *vehicle_break = [aDict objectForKey:@"vehicle_break"];

        
        self.accel=accel;
        self.accele_break_apply=accele_break_apply;
        self.angle=angle;
        self.battery=battery;
        self.battery_apply=battery_apply;
        self.coolant_temp=coolant_temp;
        self.cornering_apply=cornering_apply;
        self.coolant_temp_apply=coolant_temp_apply;
        self.deviceID=deviceID;
        self.dle_apply=dle_apply;
        self.fast_heartbeat_cnt=fast_heartbeat_cnt;
        self.fast_heartbeat_cnt_apply=fast_heartbeat_cnt_apply;
        self.fuel_level=fuel_level;
        self.fuel_level_apply=fuel_level_apply;
        self.fuel_level_change=fuel_level_change;
        self.fuel_level_change_apply=fuel_level_change_apply;
        self.fuel_limit=fuel_limit;
        self.fuel_trim_apply=fuel_trim_apply;
        self.heartbeat_interval=heartbeat_interval;
        self.heartbeat_interval_apply=heartbeat_interval_apply;

        self.heartbeat_type = heartbeat_type;
        
        self.heartbeat_type_apply = heartbeat_type_apply;
        self.hg_hyst = hg_hyst;
        self.highG = highG;
        self.idle = idle;
        self.orient = orient;
        self.raw_data_apply = raw_data_apply;
        self.raw_data_include = raw_data_include;
        self.rpm = rpm;
        self.rpm_apply = rpm_apply;
        self.rpm_duration = rpm_duration;
        self.rpm_duration_apply = rpm_duration_apply;
        self.speed = speed;
        self.speed_apply = speed_apply;
        self.speed_duration = speed_duration;
        
        self.slop_duration = slop_duration;
        self.slop_thresh = slop_thresh;
        
        self.speed_duration_apply = speed_duration_apply;
        self.turn = turn;
        self.unauth_delay = unauth_delay;
        self.unauth_duration = unauth_duration;
        self.unauth_thresh = unauth_thresh;
        self.vehicle_break = vehicle_break;
        
//        NSArray * returnArray = [NSArray arrayWithObjects:accel,accele_break_apply,angle,
//         battery,battery_apply,coolant_temp,coolant_temp_apply,cornering_apply,deviceID,dle_apply,fast_heartbeat_cnt,fast_heartbeat_cnt_apply,fuel_level,fuel_level_apply,fuel_level_change_apply,fuel_limit,fuel_trim_apply,heartbeat_interval,heartbeat_interval_apply,heartbeat_type,heartbeat_type_apply,hg_hyst,highG,idle,orient,raw_data_apply,raw_data_include,rpm,rpm_apply,rpm_duration,rpm_duration_apply,slop_duration,slop_thresh,speed,speed_apply,speed_duration,speed_duration_apply,turn,unauth_duration,unauth_thresh,nil];
        
//        self.returnArray = returnArray;
        
    }
    return self;
    
}

@end
