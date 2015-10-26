//
//  ADRemindModel.m
//  OBDClient
//
//  Created by hys on 27/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADRemindModel.h"


@implementation ADRemindModel

- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startCallWithArguments:(NSArray *)aArguments{
    _arguments=aArguments;
    [super startCallWithService:API_REMIND_SERVICE
                        method:API_REMIND_METHOD
                      arguments:_arguments];
}

#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    
    [_remindDelegate handleRemindData:(NSDictionary*)object];
   

}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
