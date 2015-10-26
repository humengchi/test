//
//  ADApiManager.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-3.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define API_DOMAIN_SERVER_DEFAULT                  @"http://114.80.200.25:80/"//25
//#define API_DOMAIN_DEFAULT                  @"http://114.80.200.25:80/zend_obd/"//25
//#define API_DOMAIN_SERVER_DEFAULT                  @"http://180.166.124.142:9983/"//163
//#define API_DOMAIN_DEFAULT                  @"http://180.166.124.142:9983/zend_obd/"//163
//#define API_DOMAIN_SERVER_DEFAULT                  @"http://180.166.124.142:9969/"//203
//#define API_DOMAIN_DEFAULT                  @"http://180.166.124.142:9969/zend_obd_dev/"//203

#define API_USER_SERVICE                    @"Login"
#define API_USER_METHOD                     @"tryLogin"
#define API_BIND_CHANNEL_METHOD             @"bindPushChannel"


#define API_USER_INFO_SERVICE               @"Users"
#define API_USER_INFO_METHOD                @"getUserInfo"
#define API_USER_INFO_UPDATE_METHOD         @"updateUserInfo"
#define API_USER_DRIVER_LICENSE_METHOD      @"getUserDriverLicenseByUserID"
#define API_USER_DRIVER_LICENSE_UPDATE_METHOD @"registerDriverLicense"

#define API_USER_REGISTER_SERVICE           @"Users"
#define API_USER_REGISTER_METHOD            @"register4chat"//@"register"

#define API_USERDRIVERLICENSE_REGISTER_SERVICE  @"Users"
#define API_USERDRIVERLICENSE_REGISTER_METHOD  @"registerDriverLicense"   

#define API_SYSTEM_SETTING_SERVICE          @"SystemSettings"
#define API_USER_NICKNAME_UPDATE            @"changeNickName"
#define API_USER_FEEDBACK_SUBMIT            @"feedback"
#define API_SEARCH_ORGAN_METHOD             @"searchOrgan"

#define API_CALENDAR_WEATHER_SERVICE        @"SystemSettings"
#define API_CALENDAR_WEATHER_METHOD         @"getWeather4baidu"//"getWeather"

#define API_REMIND_SERVICE                  @"SystemSettings"
#define API_REMIND_METHOD                   @"getDailyReminder"

#define API_DELETECURRENTMESSAGES_SERVICE   @"Users"
#define API_DELETECURRENTMESSAGES_METHOD    @"deleteCurrentMessages"

#define API_SETTOTALMILAGE_SERVICE          @"Maintain"
#define API_COUNTMILEAGE_METHOD             @"getMonthDist"
#define API_GETMONTHCONSUMPTION             @"getMonthConsumption"
#define API_GETMONTHDRIVINGHEHAVIOR         @"drivingBehavior"

#define API_SETTOTALMILAGE_METHOD           @"setTotalMilage"
#define API_UPDATEMELIAGE_METHOD            @"getDashboadStatistics"

#define API_LIMITLINE_SERVICE               @"SystemSettings"
#define API_LIMITLINE_METHOD                @"getLimitline"

#define API_GETNEWS_SERVICE                 @"SystemSettings"
#define API_GETNEWS_METHOD                  @"getNews"

#define API_OILPRICE_SERVICE                @"SystemSettings"
#define API_OILPRICE_METHOD                 @"getOilPrice"

#define API_GETMAINTAINLIST_SERVICE         @"Maintain"
#define API_GETMAINTAINLIST_METHOD          @"getMTList1"

#define API_GETCURRENT4SSTORE_SERVICE       @"Vehicle"
#define API_GETCURRENT4SSTORE_METHOD        @"get4sStore"

#define API_RESERVATION_SERVICE             @"Vehicle"
#define API_RESERVATION_METHOD              @"reservation"

#define API_GETRESERVATION_SERVICE          @"Vehicle"
#define API_GETRESERVATION_METHOD           @"getReservation"

#define API_MAINTAINITEMS_SERVICE           @"Maintain"
#define API_MAINTAINITEMS_METHOD            @"getToMaintainItems"

#define API_GETMESSAGEGROUP_SERVICE         @"Users"
#define API_GETMESSAGEGROUP_METHOD          @"getMessageGroup"

#define API_GETGROUPMESSAGE_SERVICE         @"Users"
#define API_GETGROUPMESSAGE_METHOD          @"getGroupMessage"

#define API_GETGREENDRIVESCORE_SERVICE         @"Vehicle"
#define API_GETGREENDRIVESCORE_METHOD          @"getGreenDriveScore"

#define API_SETMESSAGENOTIFACTIONSWITCH_SERVICE @"Users"
#define API_SETMESSAGENOTIFACTIONSWITCH_METHOD  @"setNotifactionSetting"

#define API_GETMESSAGENOTIFACTIONSWITCH_SERVICE @"Users"
#define API_GETMESSAGENOTIFACTIONSWITCH_METHOD  @"getNotifactionSetting"

#define API_SETREADFLAGFORALLMESSAGE_SERVICE    @"Users"
#define API_SETREADFLAGFORALLMESSAGE_METHOD     @"setReadFlag4All"

#define API_SETREADFLAGFORGROUPMESSAGE_SERVICE  @"Users"
#define API_SETREADFLAGFORGROUPMESSAGE_METHOD   @"setReadFlag4CurrentGroup"

#define API_SETREADFLAGFORCURRENTMESSAGE_SERVICE    @"Users"
#define API_SETREADFLAGFORCURRENTMESSAGE_METHOD     @"setReadFlag4CurrentMessages"

#define API_ALL_DEVICES_SERVICE             @"Login"
#define API_ALL_DEVICES_METHOD              @"getMyDeviceID"
#define API_SHARED_DEVICES_METHOD           @"getDeviceID4Share"

#define API_AUTH_DEVICES_SERVICE             @"Login"
#define API_AUTH_DEVICES_METHOD              @"getDeviceID4Authorize"

#define API_DETAIL_DEVICE_SERVICE           @"Locations"
#define API_DETAIL_DEVICE_METHOD            @"getLocations"
#define API_LATEST_INFO_METHOD              @"getLatestInfo"

#define API_DEVICE_DTCS_SERVICE             @"Locations"
#define API_DEVICE_DTCS_METHOD              @"getDTCs1"
#define API_DEVICE_DTCS_INFO_METHOD         @"getDtcInfo"


#define API_DEVICE_HISTORY_SERVICE          @"History"

#define API_DEVICE_HISTORY_METHOD           @"getTracksNew"
#define API_DEVICE_HISTORYS_METHOD           @"getHistory"
#define API_DEVICE_HISTORY_TRACKPOINTS_METHOD @"getTrackPoint"

#define API_GEOFENCE_SERVICE                @"Geofence"
#define API_GEOFENCE_ALL_METHOD             @"getGeofences"

#define API_GEOFENCE_CREATE_METHOD          @"createGeofence"

#define API_GEOFENCE_UPDATE_METHOD          @"updateGeofence"

#define API_GEOFENCE_REMOVE_METHOD          @"removeGeofence"

#define API_TRIP_LOG_SERVICE                @"SystemSettings"
#define API_TRIP_LOG_METHOD                 @"setTripLogConfig"

#define API_PID_DEVICE_SERVICE              @"Locations"
#define API_PID_DEVICE_METHOD               @"getVehicleInfo1"                      //   "getPidListDevice"

#define API_VEHICLE_INFO_SERVICE            @"Vehicle"
#define API_VEHICLE_ADD_METHOD              @"addBaseVehicleInfo"
#define API_VEHICLE_BASE_INFO_UPDATE_METHOD @"updateBaseVehicleInfo"
#define API_VEHICLE_DELE_METHOD             @"deleteVehicle"
#define API_VEHICLE_BIND_DEVICE_METHOD      @"bindDevice"
#define API_VEHICLE_AND_DEVICE_ACTIVE_METHOD     @"activateDevice"
#define API_VEHICLE_ACTIVE_STATUS_GET_METHOD    @"getDeviceActivateStatus"
#define API_VEHICLE_UNBIND_DEVICE_METHOD    @"unbindDevice"
#define API_VEHICLE_SHARE_METHOD            @"shareVehicle"
#define API_VEHICLE_BIND4S_INFO_GET_METHOD  @"get4sStore"
#define API_VEHICLE_BIND4S_SET_METHOD       @"bind4sStore"
#define API_VEHICLE_DENFECE_SET_METHOD      @"setDefenceSwitch"
#define API_VEHICLE_SELL_SET_METHOD         @"updateVehicleSellInfo"
#define API_VEHICLE_GET_CONDITION_TIME_OUT_METHDO  @"getTimeOutVehicleConditionData"
#define API_VEHICLE_GET_STATUS_DEATAIL_METHID      @"getVehicleStatusDeatail"
#define API_VEHICLE_AUTH_USER_DELETE_METHOD @"cancelAuthorizedUser"



#define API_VEHICLE_INFO_MODULETYPE_METHOD  @"queryBaseVehicleInfo"

#define API_VEHICLE_INFO_METHOD             @"getVehicleInfo"
#define API_SET_VEHICLE_INFO_METHOD         @"updateDrivingLicense"

#define API_VEHICLE_INFO_INSURE_METHOD      @"getInsurance"
#define API_SET_VEHICLE_INFO_INSURE_METHOD  @"updateInsurance"

#define API_AUTH_VEHICLE_TO_USERID_METHOD   @"authorizeVehicles"
#define API_VEHICLE_AUTH_USERS_GET_METHOD   @"getAuthorizedUsers"

#define API_VEHICLE_DETECTION_METHOD        @"vehicleConditionCheck"
#define API_VEHICLE_DETECTION_INDEED_METHOD @"getVehicleConditionCheckResult"
#define API_VEHICLE_DETECTION_TIMEOUT_METHOD @"getTimeOutVehicleConditionData"

#define API_VEHICLE_SETTING_SERVICE         @"DeviceSetting"
#define API_VEHICLE_SETTING_CONFIG_GET_METHOD  @"getVehicleSetting"
#define API_VEHICLE_SETTING_CONFIG_SET_METHOD  @"updateVehicleSetting"

#define API_VEHICLE_GATEWAY_SERVICE         @"SystemSettings"
#define API_VEHICLE_GETEWAY_CONFIG_GET_METHOD   @"getGateway_cfg"
#define API_SET_VEHICLE_GATEWAY_CONFIG_METHOD   @"setGatewayConfig"

#define API_VEHICLE_MODELTYPE_LIST_SERVICE  @"Maintain"
#define API_VEHICLE_MODELTYPE_LIST_GET_METHOD   @"getVehicleModelList"
#define API_VEHICLE_MODELTYPE_SET_METHOD    @"saveVehicleModel"

#define API_VEHICLE_MAINTAIN_SERVICE        @"Maintain"
#define API_VEHICLE_MAINTAIN_LIST_GET_METHOD @"getNextMaintainInfo"
#define API_VEHICLE_MAINTAIN_HISTORY_LIST_GET_METHOD @"getMTHistroyList"
#define API_VEHICLE_MAINTAIN_ITEMS_GET_METHOD   @"getToMaintainItems"
#define API_VEHICIE_MAINTAIN_ITEMS_SET_METHOD   @"saveMaintainInfoNew"

#define API_SYSTEMSETTINGS_SERVICE          @"SystemSettings"
#define API_VEHICLE_CURRENT_4SSTORES_GET_METHOD @"get4sStoreList"

#define API_GET_USERNAME              @"Users"
#define API_GET_GETFRIENDLISTS              @"checkMdns"

@interface ADApiManager : NSObject

+ (ADApiManager *)sharedManager;

@end
