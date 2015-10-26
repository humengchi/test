//
//  ADUserRegisterModel.m
//  OBDClient
//
//  Created by hys on 23/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserRegisterModel.h"


@implementation ADUserRegisterModel
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startRequestUserWithArguments:(NSArray *)aArguments{
    _requestType=REGISTERUSER;
    _arguments=aArguments;
    [super startCallWithService:API_USER_REGISTER_SERVICE method:API_USER_REGISTER_METHOD arguments:_arguments];
}

-(void)startRequestUserDriverLicenseWithArguments:(NSArray *)aArguments{
    _requestType=REGISTERUSERDRIVERLICENSE;
    _arguments=aArguments;
    [super startCallWithService:API_USERDRIVERLICENSE_REGISTER_SERVICE method:API_USERDRIVERLICENSE_REGISTER_METHOD arguments:_arguments];
}
#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    NSLog(@"%@",object);
    //通知自身请求成功
    if (_requestType==REGISTERUSER) {
        [_registerDelegate handleUser:(NSDictionary*)object];
    }else if (_requestType==REGISTERUSERDRIVERLICENSE){
        [_registerDelegate handleUserDriverLicense:(NSDictionary*)object];
    }    
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
