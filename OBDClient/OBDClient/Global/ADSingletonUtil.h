//
//  ADSingletonUtil.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-17.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADUserBase.h"
#import "ADDeviceBase.h"
#import "ADVehicleBase.h"

@interface ADSingletonUtil : NSObject

@property (nonatomic, strong) NSString *server_url;

@property (nonatomic, strong) NSString *server_url_zend;

@property (nonatomic, strong) ADUserBase *globalUserBase;

@property (nonatomic, weak) NSArray *devices;

@property (nonatomic, weak) NSArray *authDevices;

@property (nonatomic, weak) NSArray *sharedDevices;

@property (nonatomic) ADVehicleBase *vehicleInfo;

@property (nonatomic) NSDictionary *vehicleBaseInfo;

@property (nonatomic, strong) ADDeviceBase *currentDeviceBase;

@property (nonatomic) int selectMenuIndex;

@property (nonatomic) NSDictionary *userInfo;

@property (nonatomic) BOOL firstLogin;

@property (nonatomic) NSString *push_userid;

@property (nonatomic) NSString *push_appid;

@property (nonatomic) NSString *push_channelid;

@property (nonatomic) BOOL autoMsgCenter;

@property (nonatomic) BOOL chattingIsLogin;

- (NSString *)alertNameByCode:(NSString *)aCode;

- (NSString *)errorStringByResultCode:(NSString *)aResultCode;

-(BOOL) isRulesString:(NSString *)string;

+ (ADSingletonUtil *)sharedInstance;


@end
