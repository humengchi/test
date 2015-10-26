//
//  ADTripLogModel.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-31.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADTripLogModel.h"

@implementation ADTripLogModel

- (void)requestTripLogWithDeviceID:(NSString *)aDeviceID
{
    [super startCallWithService:API_TRIP_LOG_SERVICE
                         method:API_TRIP_LOG_METHOD
                      arguments:[ super argumentConfig:[NSArray arrayWithObject:aDeviceID]]];
}

- (void)remotingCallDidFinishLoading:(AMFRemotingCall *)remotingCall receivedObject:(NSObject *)object
{
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall error:(NSError *)aError
{
    
}

@end
