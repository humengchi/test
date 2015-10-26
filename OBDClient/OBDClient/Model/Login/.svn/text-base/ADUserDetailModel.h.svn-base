//
//  ADUserDetailModel.h
//  OBDClient
//
//  Created by Holyen Zou on 13-4-28.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADModelBase.h"
#import "ADUserBase.h"

#define KVO_LOGIN_USERDETAIL_PATH_NAME    @"userDetail"
#define KVO_USER_INFO_PATH_NAME           @"userInfo"
#define KVO_USER_DRIVER_LICENSE_PATH_NAME @"userDriverLicenseInfo"

typedef enum{
    USER_LOGIN = 1,
    USER_INFO = 2,
    USER_INFO_UPDATE = 3,
    USER_DRIVER_LICENSE = 4,
    USER_DRIVER_LICENSE_UPDATE = 5,
    USER_NICKNAME_UPDATE = 6,
    USER_FEEDBACK_SUBMIT = 7,
    USER_BIND_CHANNEL = 8
    
} ADUserModelRequestType;

extern NSString * const ADUserDetailModelRequestSuccessNotification;
extern NSString * const ADUserDetailModelRequestFailNotification;
extern NSString * const ADUserDetailModelRequestTimeoutNotification;
extern NSString * const ADUserDetailModelRequestDataErrorNotification;
extern NSString * const ADUserDetailModelRequestUserLoginFailNotification;

extern NSString * const ADUserInfoUpdateSuccessNotification;
extern NSString * const ADUserInfoRequestSuccessNotification;
extern NSString * const ADUserDriverLicenseRequestSuccessNotification;
extern NSString * const ADUserDriverLicenseUpdateSuccessNotification;
extern NSString * const ADUserUserNicknameUpdateSuccessNotification;
extern NSString * const ADUserUserFeedbackSubmitSuccessNotification;

extern NSString * const ADUserBindChannelSuccessNotification;


@interface ADUserDetailModel : ADModelBase
{
    NSArray *_arguments;
    ADUserModelRequestType _requestType;
}

@property (nonatomic, strong, readonly) ADUserBase *userDetail;
@property (nonatomic) NSDictionary *userInfo;
@property (nonatomic) NSDictionary *userDriverLicenseInfo;
@property (nonatomic) BOOL isLoginSucces;

- (void)startCallWithArguments:(NSArray *)aArguments;

-(void)requestUserInfoWithArguments:(NSArray *)aArguments;

-(void)updateUserInfoWithArguments:(NSArray *)aArguments;

- (void)requestUserDriveLicenseWithArguments:(NSArray *)aArguments;

- (void)updateUserDriverLicenseWithArguments:(NSArray *)aArguments;

- (void)updateUserNicknameWithArguments:(NSArray *)aArguments;

- (void)submitFeedBackWithArguments:(NSArray *)aArguments;

- (void)bindPushChannelWithArguments:(NSArray *)aArguments;

@end
