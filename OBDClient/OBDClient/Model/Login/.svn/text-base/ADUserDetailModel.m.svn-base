//
//  ADUserDetailModel.m
//  OBDClient
//
//  Created by Holyen Zou on 13-4-28.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserDetailModel.h"
#import "IVToastHUD.h"

NSString * const ADUserDetailModelRequestSuccessNotification        = @"ADUserDetailModelRequestSuccessNotification";
NSString * const ADUserDetailModelRequestFailNotification           = @"ADUserDetailModelRequestFailNotification";
NSString * const ADUserDetailModelRequestTimeoutNotification        = @"ADUserDetailModelRequestTimeoutNotification";
NSString * const ADUserDetailModelRequestDataErrorNotification      = @"ADUserDetailModelRequestDataErrorNotification";
NSString * const ADUserDetailModelRequestUserLoginFailNotification  = @"ADUserDetailModelRequestUserLoginFailNotification";

NSString * const ADUserInfoRequestSuccessNotification  = @"ADUserInfoRequestSuccessNotification";
NSString * const ADUserInfoUpdateSuccessNotification  = @"ADUserInfoUpdateSuccessNotification";
NSString * const ADUserDriverLicenseRequestSuccessNotification  = @"ADUserDriverLicenseRequestSuccessNotification";
NSString * const ADUserDriverLicenseUpdateSuccessNotification  = @"ADUserDriverLicenseUpdateSuccessNotification";
NSString * const ADUserUserNicknameUpdateSuccessNotification  = @"ADUserUserNicknameUpdateSuccessNotification";
NSString * const ADUserUserFeedbackSubmitSuccessNotification  = @"ADUserUserFeedbackSubmitSuccessNotification";

NSString * const ADUserBindChannelSuccessNotification = @"ADUserBindChannelSuccessNotification";



@interface ADUserDetailModel ()

@property (nonatomic, strong) ADUserBase *userDetail;

@end

@implementation ADUserDetailModel

- (id)init
{
    if (self = [super init])
    {
//        _userDetail = [ADSingletonUtil sharedInstance].globalUserBase;
    }
    return self;
}

- (void)cancel
{
    [super cancel];
}

- (void)startCallWithArguments:(NSArray *)aArguments       //用户登录请求
{
    _requestType = USER_LOGIN;
    _arguments = aArguments;
    [super startCallWithService:API_USER_SERVICE
                         method:API_USER_METHOD
                      arguments:_arguments];
}

-(void)requestUserInfoWithArguments:(NSArray *)aArguments{
    _requestType = USER_INFO;
    [super startCallWithService:API_USER_INFO_SERVICE method:API_USER_INFO_METHOD arguments:aArguments];
}

-(void)updateUserInfoWithArguments:(NSArray *)aArguments{
    _requestType = USER_INFO_UPDATE;
    _arguments=aArguments;
    [super startCallWithService:API_USER_INFO_SERVICE method:API_USER_INFO_UPDATE_METHOD arguments:aArguments];
}

- (void)requestUserDriveLicenseWithArguments:(NSArray *)aArguments{
    _requestType = USER_DRIVER_LICENSE;
    [super startCallWithService:API_USER_INFO_SERVICE method:API_USER_DRIVER_LICENSE_METHOD arguments:aArguments];
}

- (void)updateUserDriverLicenseWithArguments:(NSArray *)aArguments{
    _requestType = USER_DRIVER_LICENSE_UPDATE;
    [super startCallWithService:API_USER_INFO_SERVICE method:API_USER_DRIVER_LICENSE_UPDATE_METHOD arguments:aArguments];
}

- (void)updateUserNicknameWithArguments:(NSArray *)aArguments{
    _requestType = USER_NICKNAME_UPDATE;
    [super startCallWithService:API_SYSTEM_SETTING_SERVICE method:API_USER_NICKNAME_UPDATE arguments:aArguments];
}

- (void)submitFeedBackWithArguments:(NSArray *)aArguments{
    _requestType = USER_FEEDBACK_SUBMIT;
    [super startCallWithService:API_SYSTEM_SETTING_SERVICE method:API_USER_FEEDBACK_SUBMIT arguments:aArguments];
}

- (void)bindPushChannelWithArguments:(NSArray *)aArguments{
    NSLog(@"%@",aArguments);
    _requestType = USER_BIND_CHANNEL;
    [super startCallWithService:API_USER_SERVICE method:API_BIND_CHANNEL_METHOD arguments:aArguments];
}

#pragma mark - implement super class methods
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall    
                         receivedObject:(NSObject *)object
{
//    NSLog(@"%@",object);
    NSString *resultCode = [(NSDictionary *)object objectForKey:@"resultCode"];
    if ([resultCode isKindOfClass:[NSNull class]]) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:ADUserDetailModelRequestFailNotification object:self];
        NSLog(@"the data return, is null~. ADUserDetailModel");
        return;
    }
    if ([resultCode isEqualToString:@"200"])
    {
        if(_requestType == USER_LOGIN){
            NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
            NSDictionary *data = [(ASObject *)[dataArray objectAtIndex:0] properties];
            
            ADUserBase *temUserDetail = [[ADUserBase alloc] initWithDictionary:data];
            temUserDetail.token = [(NSDictionary *)object objectForKey:@"token"];
            temUserDetail.token_secret = [(NSDictionary *)object objectForKey:@"token_secret"];
            
            [ADSingletonUtil sharedInstance].globalUserBase = temUserDetail;
            
            //通知自身请求成功
            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserDetailModelRequestSuccessNotification object:self];
        }else if (_requestType==USER_INFO){
            NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
            if(dataArray.count==0){
                self.userInfo = nil;
            }else{
                NSDictionary *data = [dataArray objectAtIndex:0];
                self.userInfo = data;
            }
            [ADSingletonUtil sharedInstance].userInfo=self.userInfo;

            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserInfoRequestSuccessNotification object:self];
        }else if (_requestType==USER_INFO_UPDATE){
            NSString* pwd=[_arguments objectAtIndex:1];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            [defaults setObject:pwd forKey:@"pwd"];
            NSString* userName=[defaults objectForKey:@"userName"];
            NSMutableArray *userNameArray = [defaults objectForKey:@"userNameArray"];
            NSMutableArray *pwdArray = [[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"pwdArray"]];
            
            for (int i=0; i<[userNameArray count]; i++) {
                NSString* userNameMatch=[userNameArray objectAtIndex:i];
                if ([userName isEqualToString:userNameMatch]) {
                    [pwdArray replaceObjectAtIndex:i withObject:pwd];
                    [defaults setObject:pwdArray forKey:@"pwdArray"];
                    break;
                }
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserInfoUpdateSuccessNotification object:self];
        }else if (_requestType == USER_DRIVER_LICENSE){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserDriverLicenseRequestSuccessNotification object:self];
            NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
            if(dataArray.count==0){
                self.userDriverLicenseInfo = nil;
            }else{
                NSDictionary *data = [dataArray objectAtIndex:0];
                self.userDriverLicenseInfo = data;
            }
        }else if (_requestType == USER_DRIVER_LICENSE_UPDATE){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserDriverLicenseUpdateSuccessNotification object:self];
        }else if (_requestType == USER_NICKNAME_UPDATE){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserUserNicknameUpdateSuccessNotification object:self];
        }else if (_requestType == USER_FEEDBACK_SUBMIT){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserUserFeedbackSubmitSuccessNotification object:self];
        }else if (_requestType == USER_BIND_CHANNEL){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserBindChannelSuccessNotification object:self];
            
        }
        
    }
    else{
        //暂时在model里做错误显示
        [IVToastHUD showAsToastErrorWithStatus:[[ADSingletonUtil sharedInstance] errorStringByResultCode:resultCode]];
        
        if(_requestType==USER_LOGIN){
//            [[NSNotificationCenter defaultCenter] postNotificationName:ADUserDetailModelRequestFailNotification
//                                                                object:self userInfo:(NSDictionary *)object];
        }else if (_requestType==USER_INFO){
            
        }else if (_requestType==USER_INFO_UPDATE){
            
        }else if (_requestType == USER_DRIVER_LICENSE){
            
        }else if (_requestType == USER_DRIVER_LICENSE_UPDATE){
            
        }else if (_requestType == USER_BIND_CHANNEL){
            
        }
        
    }
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    [[NSNotificationCenter defaultCenter] postNotificationName:ADUserDetailModelRequestFailNotification
                                                        object:self];
    
}

@end
