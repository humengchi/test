//
//  ADGetMaintainListModel.m
//  OBDClient
//
//  Created by hys on 5/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGetMaintainListModel.h"

@implementation ADGetMaintainListModel
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startRequestMaintainListWithArguments:(NSArray *)aArguments{
    _requestType=MAINTAINLIST_TYPE;
    _arguments=aArguments;
    [super startCallWithService:API_GETMAINTAINLIST_SERVICE
                         method:API_GETMAINTAINLIST_METHOD
                      arguments:_arguments];
}

-(void)startRequestMaintainItemsWithArguments:(NSArray *)aArguments{
     _requestType=MAINTAINITEMS_TYPE;
    _arguments=aArguments;
    [super startCallWithService:API_MAINTAINITEMS_SERVICE
                         method:API_MAINTAINITEMS_METHOD
                      arguments:_arguments];
    
}

#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    if (_requestType==MAINTAINLIST_TYPE) {
        [_getMaintainListDelegate handleMaintainList:(NSDictionary*)object];
    }else if (_requestType==MAINTAINITEMS_TYPE){
        [_getMaintainListDelegate handleMaintainItems:(NSDictionary*)object];
    }

    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
