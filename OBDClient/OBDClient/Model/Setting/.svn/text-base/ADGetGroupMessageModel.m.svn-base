//
//  ADGetGroupMessageModel.m
//  OBDClient
//
//  Created by hys on 15/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGetGroupMessageModel.h"

@implementation ADGetGroupMessageModel

- (id)init
{
    if (self = [super init]){
        
    }
    return self;
}


-(void)startCallWithArguments:(NSArray *)aArguments
{
    _arguments=aArguments;
    [super startCallWithService:API_GETGROUPMESSAGE_SERVICE method:API_GETGROUPMESSAGE_METHOD arguments:_arguments];
}

//网络请求的回调 即对收到的object进行处理
-(void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall receivedObject:(NSObject *)object{
    [_getGroupMessageDelegate  handleGroupMessageData:(NSDictionary*)object];
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
