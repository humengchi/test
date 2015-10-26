//
//  ADGetNewsModel.m
//  OBDClient
//
//  Created by hys on 25/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGetNewsModel.h"

@implementation ADGetNewsModel
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startRequestGetNewsWithArguments:(NSArray *)aArguments{
    _arguments=aArguments;
    [super startCallWithService:API_GETNEWS_SERVICE method:API_GETNEWS_METHOD arguments:_arguments];
}

#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    [_getNewsDelegate handleGetNewsData:(NSDictionary*)object];
    
}


- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}


@end
