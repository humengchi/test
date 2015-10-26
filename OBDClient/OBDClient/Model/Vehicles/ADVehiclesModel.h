//
//  ADVehiclesModel.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleBase.h"
#import "ADModelBase.h"
#import "ADVehicleInsure.h"
#import "ADVehicleSettingConfig.h"

extern NSString * const ADVehiclesModelRequestVehicleInfoSuccessNotification;
extern NSString * const ADVehiclesModelRequestVehicleInfoFailNotification;
extern NSString * const ADVehiclesModelRequestVehicleInfoTimeoutNotification;

extern NSString * const ADVehiclesModelSetVehicleInfoSuccessNotification;
extern NSString * const ADVehiclesModelSetVehicleInfoFailNotification;
extern NSString * const ADVehiclesModelSetVehicleInfoTimeoutNotification;

extern NSString * const ADVehiclesModelRequestVehicleInfoForInsureSuccessNotification;
extern NSString * const ADVehiclesModelRequestVehicleInfoForInsureFailNotification;
extern NSString * const ADVehiclesModelRequestVehicleInfoForInsureTimeoutNotification;

extern NSString * const ADVehiclesModelSetVehicleInfoForInsureSuccessNotification;

extern NSString * const ADVehiclesModelSetVehicleGateWaySuccessNotification;

extern NSString * const ADVehiclesModelSetVehicleModelTypeSuccessNotification;

extern NSString * const ADVehiclesModelSetVehicleSettingConfigSuccessNotification;

extern NSString * const ADVehiclesModelSetAuthUserSuccessNotification;

extern NSString * const ADVehiclesModelAddVehicleSuccessNotification;

extern NSString * const ADVehiclesModelAddVehicleExistNotification;

extern NSString * const ADVehiclesModelAddVehicleErrorNotification;

extern NSString * const ADVehiclesModelDeleteVehicleSuccessNotification;

extern NSString * const ADVehiclesModelBindDeviceSuccessNotification;

extern NSString * const ADVehiclesModelBindDeviceErrorNotification;

extern NSString * const ADVehiclesModelActiveDeviceSendSuccessNotification;

extern NSString * const ADVehiclesModelActiveDeviceSuccessNotification;

extern NSString * const ADVehiclesModelActiveDeviceFailNotification;

extern NSString * const ADVehiclesModelUnbindDeviceSuccessNotification;

extern NSString * const ADVehiclesModelrequestVehicleDetectionFailNotification;

extern NSString * const ADVehiclesModelShareVehicleSuccessNotification;

extern NSString * const ADVehiclesModelrequest4sInfoSuccessNotification;

extern NSString * const ADVehiclesModelSet4sStoreSuccessNotification;

extern NSString * const ADVehiclesModelSetDefenceSuccessNotification;

extern NSString * const ADVehiclesModelGetSettingConfigResultNotification;

extern NSString * const ADVehiclesModelGetGatewayConfigResultNotification;

extern NSString * const ADVehiclesModelSetSellsInfoSuccessNotification;

extern NSString * const ADVehiclesModelAuthVehicleFailNotification;

extern NSString * const ADVehiclesModelGetConditionTimeOutNotification;

extern NSString * const ADVehiclesModelUpdateBaseInfoSuccessNotification;

extern NSString * const ADVehiclesModelGetStatusDeatailNotification;

extern NSString * const ADVehiclesModelDeleteAuthUserSuccessNotification;

extern NSString * const ADVehiclesModelLoginTimeOutNotification;




#define KVO_VEHICLE_INFO_PATH_NAME       @"vehicleInfo"
#define KVO_VEHICLE_INSURE_INFO_PATH_NAME       @"vehicleInsureInfo"
#define KVO_VEHICLE_SETTING_CONFIG_PATH_NAME    @"vehicleSettingConfig"
#define KVO_VCEHICLE_DETECTION_PATH_NAME         @"vehicleConditionCheck"
#define KVO_VCEHICLE_DETECTION_INDEED_PATH_NAME         @"vehicleConditionCheckResult"
#define KVO_VEHICLE_INFO_MODELTYPE_PATH_NAME    @"vehicleInfoModelType"
#define KVO_VEHICLE_GATEWAY_CONFIG_PATH_NAME    @"vehicleGateWayConfig"
#define KVO_VEHICLE_MODELTYPE_LIST_PATH_NAME    @"vehicleModelTypeList"
#define KVO_VEHICLE_AUTHUSERS_LIST_PATH_NAME    @"vehicleAuthUsersList"
#define KVO_VEHICLE_BIND4S_INFO_PATH_NAME       @"vehicleBind4sInfo"
#define KVO_VEHICLE_CURRENT_4SSTORES_LIST_PATH_NAME  @"current4sStoresList"


typedef enum{
    VEHICLE_INFO_LICENSE = 0,
    VEHICLE_INFO_SELL = 1,
    SET_VEHICLE_INFO_LICENSE = 2,
    VEHICLE_INFO_INSURE = 3,
    AUTH_VEHICLE_TO_USERID = 4,
    VEHICLE_SETTING_CONFIG_GET = 5,
    VEHICLE_DETECTION = 6,
    VEHICLE_DETECTION_INDEED = 7,
    SET_VEHICLE_INFO_INSURE = 8,
    VEHICLE_INFO_MODELTYPE = 9,
    VEHICLE_INFO_GATEWAY_CONFIG = 10,
    SET_VEHICLE_GATEWAY_CONFIG = 11,
    VEHICLE_MODELTYPE_LIST_GET = 12,
    VEHICLE_MODELTYPE_SET = 13,
    VEHICLE_SETTING_CONFIG_SET = 14,
    VEHICLE_AUTH_USERS_GET = 15,
    VEHICLE_ADD = 16,
    VEHICLE_DELETE = 17,
    VEHICLE_BIND_DEVICE = 18,
    VEHICLE_AND_DEVICE_ACTIVE = 19,
    VEHICLE_GET_ACTIVE_STATUS = 20,
    VEHICLE_UNBIND_DEVICE = 21,
    VEHICLE_SHARE = 22,
    VEHICLE_BIND4S_INFO = 23,
    VEHICLE_CURRENT_4SSTORES = 24,
    VEHICLE_SET_4SSTORE = 25,
    VEHICLE_SET_DEFENCE = 26,
    VEHICLE_SET_SALESINFO = 27,
    VEHICLE_GET_CONDITION_TIME_OUT=28,
    VEHICLE_BASE_INFO_UPDATE = 29,
    VEHICLE_GET_STATUS_DEATAIL=30,
    VEHICLE_AUTH_USER_DELETE = 31,
    VEHICLE_GET_FRIENDLISTS = 32
    
    
} ADVehicleInfoRequestType;

@interface ADVehiclesModel : ADModelBase
{
    ADVehicleInfoRequestType _requestType;
    NSTimer *_timer;
    NSTimer *_activeTimer;
    NSArray *arg;
    NSArray *activeArg;
    int timeNum;
    int conditionTimeNum;
}

@property (nonatomic) ADVehicleBase *vehicleInfo;

@property (nonatomic) ADVehicleInsure *vehicleInsureInfo;

@property (nonatomic) ADVehicleSettingConfig *vehicleSettingConfig;

@property (nonatomic) NSDictionary *vehicleConditionCheck;

@property (nonatomic) NSDictionary *vehicleConditionCheckResult;

@property (nonatomic) NSDictionary *vehicleInfoModelType;

@property (nonatomic) NSDictionary *vehicleGateWayConfig;

@property (nonatomic) NSArray *vehicleModelTypeList;

@property (nonatomic) NSArray *vehicleAuthUsersList;

@property (nonatomic) NSDictionary *vehicleBind4sInfo;

@property (nonatomic) NSArray *current4sStoresList;



- (void)requestVehicleInfoWithArguments:(NSArray*)aArguments;

- (void)setVehicleInfoWithArguments:(NSArray*)aArguments;

- (void)requestVehicleInfoForInsureWithArguments:(NSArray*)aArguments;

- (void)setVehicleInfoForInsureWithArguments:(NSArray*)aArguments;

- (void)authorizeVehicleWithArguments:(NSArray*)aArguments;

- (void)requestAuthorizedUsersWithArguments:(NSArray*)aArguments;

- (void)requestVehicleSettingConfigWithArguments:(NSArray *)aArguments;

- (void)requestVehicleDetectionInfoWithArguments:(NSArray *)aArguments;

- (void)requestVehicleDetectionIndeedWithArguments:(NSArray *)aArguments continue:(BOOL)aContinue;

- (void)requestVehicleModelTypeWithArguments:(NSArray *)aArguments;

- (void)requestVehicleGeteWayConfigWithArguments:(NSArray *)aArguments;

- (void)setVehicleGateWayConfigWithArguments:(NSArray *)aArguments;

- (void)requestVehicleModelTypeListWithArguments:(NSArray *)aArguments;

- (void)setVehicleModelTypeWithArguments:(NSArray *)aArguments;

- (void)setVehicleSettingConfigWithArguments:(NSMutableArray *)aArguments;

- (void)addVehicleWithArguments:(NSArray *)aArguments;

- (void)deleteVehicleWithArguments:(NSArray *)aArguments;

- (void)bindDeviceWithArguments:(NSArray *)aArguments;

- (void)activeDeviceWithArguments:(NSArray *)aArguments;

- (void)getActiveStatusIndeedWithArguments:(NSArray *)aArguments continue:(BOOL)aContinue;

- (void)unBindDeviceWithArguments:(NSArray *)aArguments;

- (void)shareVehicleWithArguments:(NSArray *)aArguments;

- (void)requestBind4sStoreInfoWithArgument:(NSArray *)aArguments;

- (void)requestCurrent4SStoresListWithArguments:(NSArray *)aArguments;

- (void)setVehicleBind4sStoreWithArguments:(NSArray *)aArguments;

- (void)setVehicleDefenceWithArguments:(NSArray *)aArguments;

- (void)setVehicleSalesInfoWithArguments:(NSArray *)aArguments;

- (void)requestGetVehicleConditionCheckTimeOut:(NSArray *)aArguments;

- (void)updateBaseVehicleInfoWithArguments:(NSArray *)aArguments;

- (void)requestGetVehicleStatusDeatail:(NSArray *)aArguments;

- (void)deleteAuthUserWithArguments:(NSArray *)aArguments;

- (void)getFriendListsByUsername:(NSArray*)aArguments;

@end


