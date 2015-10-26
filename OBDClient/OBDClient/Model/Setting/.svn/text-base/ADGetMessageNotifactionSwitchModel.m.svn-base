//
//  ADGetMessageNotifactionSwitchModel.m
//  OBDClient
//
//  Created by hys on 11/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGetMessageNotifactionSwitchModel.h"

@implementation ADGetMessageNotifactionSwitchModel

- (id)init
{
    if (self = [super init]){
        
    }
    return self;
}


-(void)startCallWithArguments:(NSArray *)aArguments
{
    _arguments=aArguments;
    [super startCallWithService:API_GETMESSAGENOTIFACTIONSWITCH_SERVICE method:API_GETMESSAGENOTIFACTIONSWITCH_METHOD arguments:_arguments];
}

//网络请求的回调 即对收到的object进行处理
-(void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall receivedObject:(NSObject *)object{
    [_getMessageNotifactionSwitchDelegate handleGetMessageNotifactionSwitchStatus:(NSDictionary*)object];
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}


@end
