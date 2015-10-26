//
//  ADSetReadFlagForGroupMessageModel.m
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSetReadFlagForGroupMessageModel.h"

@implementation ADSetReadFlagForGroupMessageModel

- (id)init
{
    if (self = [super init]){
        
    }
    return self;
}

-(void)startCallWithArguments:(NSArray *)aArguments
{
    _arguments=aArguments;
    [super startCallWithService:API_SETREADFLAGFORGROUPMESSAGE_SERVICE method:API_SETREADFLAGFORGROUPMESSAGE_METHOD arguments:_arguments];
}

//网络请求的回调 即对收到的object进行处理
-(void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall receivedObject:(NSObject *)object{
    [_setReadFlagForGroupMessageDelegate  handleSetReadFlagForGroupMessageData:(NSDictionary*)object];
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}


@end
