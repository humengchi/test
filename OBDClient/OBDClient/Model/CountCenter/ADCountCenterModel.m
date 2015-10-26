//
//  ADCountCenterModel.m
//  OBDClient
//
//  Created by hys on 11/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADCountCenterModel.h"

@implementation ADCountCenterModel
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)startRequestMonthDrivingBehavior:(NSArray *)aArguments{
    _requestType=COUNTBEHAVIOR_TYPE;
    _arguments=aArguments;
    [super startCallWithService:API_SETTOTALMILAGE_SERVICE method:API_GETMONTHDRIVINGHEHAVIOR arguments:_arguments];
}

-(void)startRequestMonthCountMileage:(NSArray *)aArguments{
    _requestType=COUNTMILEAGE_TYPE;
    _arguments=aArguments;
    [super startCallWithService:API_SETTOTALMILAGE_SERVICE method:API_COUNTMILEAGE_METHOD arguments:_arguments];
}

-(void)startRequestMonthConsumption:(NSArray*)aArguments{
    _requestType = COUNTMONTHCONSUMPTION;
    _arguments=aArguments;
    [super startCallWithService:API_SETTOTALMILAGE_SERVICE method:API_GETMONTHCONSUMPTION arguments:_arguments];
}

-(void)startRequestGreenDriveScroe:(NSArray *)aArguments{
    _requestType=COUNTGREENDRIVESCROE_TYPE;
    _arguments=aArguments;
    [super startCallWithService:API_GETGREENDRIVESCORE_SERVICE method:API_GETGREENDRIVESCORE_METHOD arguments:_arguments];
}
#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    if (_requestType==COUNTMILEAGE_TYPE) {
        [_countCenterDelegate handleMonthCountMileage:(NSDictionary*)object];
    }else if (_requestType==COUNTGREENDRIVESCROE_TYPE){
        [_countCenterDelegate handleGreenDriveScroe:(NSDictionary*)object];
    }else if(_requestType == COUNTMONTHCONSUMPTION){
        [_countCenterDelegate handleMonthConsumption:(NSDictionary*)object];
    }else if(_requestType == COUNTBEHAVIOR_TYPE){
        [_countCenterDelegate handleMonthDrivingBehavior:(NSDictionary*)object];
    }
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end