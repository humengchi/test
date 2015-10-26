//
//  ADDeleteCurrentMessagesModel.m
//  OBDClient
//
//  Created by hys on 1/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDeleteCurrentMessagesModel.h"

@implementation ADDeleteCurrentMessagesModel

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startCallWithArguments:(NSArray *)aArguments{
    _arguments=aArguments;
    [super startCallWithService:API_DELETECURRENTMESSAGES_SERVICE
                         method:API_DELETECURRENTMESSAGES_METHOD
                      arguments:_arguments];
}

#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    
    [_deleteCurrentMessagesDelegate handleDeleteCurrentMessagesData:(NSDictionary*)object];
    
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
