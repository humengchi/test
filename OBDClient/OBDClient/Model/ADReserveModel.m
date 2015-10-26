//
//  ADReserveModel.m
//  OBDClient
//
//  Created by hys on 19/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADReserveModel.h"

@implementation ADReserveModel
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startRequestBlinding4SShopWithArguments:(NSArray *)aArguments{
    _requestType=RESERVEMODEL_GET4SSHOP;
    _arguments=aArguments;
    [super startCallWithService:API_GETCURRENT4SSTORE_SERVICE method:API_GETCURRENT4SSTORE_METHOD arguments:_arguments];
}

-(void)startRequestSubmitWithArguments:(NSArray *)aArguments{
    _requestType=RESERVEMODEL_RESERVATION;
    _arguments=aArguments;
    [super startCallWithService:API_RESERVATION_SERVICE method:API_RESERVATION_METHOD arguments:_arguments];
}

-(void)startRequestGetReservationWithArguments:(NSArray *)aArguments{
    _requestType=RESERVEMODEL_GETRESERVATION;
    _arguments=aArguments;
    [super startCallWithService:API_GETRESERVATION_SERVICE method:API_GETRESERVATION_METHOD arguments:_arguments];
}

#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    if (_requestType==RESERVEMODEL_GET4SSHOP) {
        [_reserveDelegate handleBlinding4SShop:(NSDictionary*)object];
    }else if (_requestType==RESERVEMODEL_RESERVATION){
        [_reserveDelegate handleSubmit:(NSDictionary*)object];
    }else if (_requestType==RESERVEMODEL_GETRESERVATION){
        [_reserveDelegate handleGetReservation:(NSDictionary*)object];
    }
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
