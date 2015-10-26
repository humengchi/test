//
//  ADCalendarModel.m
//  OBDClient
//
//  Created by hys on 25/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADCalendarModel.h"

NSString * const ADCalendarModelRequestSuccessNotification      = @"ADCalendarModelRequestSuccessNotification";
NSString * const ADCalendarModelRequestFailNotification         = @"ADCalendarModelRequestFailNotification";
NSString * const ADCalendarModelRequestTimeoutNotification      = @"ADCalendarModelRequestTimeoutNotification";
NSString * const ADCalendarModelRequestDataErrorNotification    = @"ADCalendarModelRequestDataErrorNotification";


@implementation ADCalendarModel

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

- (void)startCallWithArguments:(NSArray *)aArguments       //用户登录请求
{
    _arguments = aArguments;
    [super startCallWithService:API_CALENDAR_WEATHER_SERVICE
                         method:API_CALENDAR_WEATHER_METHOD
                      arguments:_arguments];
}


#pragma mark - implement super class methods
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
       
        [_weatherDelegate handleWeatherData:(NSArray*)object];
        [[NSNotificationCenter defaultCenter] postNotificationName:ADCalendarModelRequestSuccessNotification object:self];
        
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    [[NSNotificationCenter defaultCenter] postNotificationName:ADCalendarModelRequestFailNotification
                                                        object:self];
    
    
}

@end
