//
//  ADSearchOrganModel.m
//  OBDClient
//
//  Created by hys on 19/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSearchOrganModel.h"

@implementation ADSearchOrganModel
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startRequestSearchOrganWithArguments:(NSArray *)aArguments{
    _requestType=SEARCHORGAN_TYPE;
    _arguments=aArguments;
    [super startCallWithService:API_SYSTEM_SETTING_SERVICE
                         method:API_SEARCH_ORGAN_METHOD
                      arguments:_arguments];
}

#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    if (_requestType==SEARCHORGAN_TYPE) {
        [_searchOrganDelegate handleSearchOrganList:(NSDictionary*)object];
    }
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
