//
//  ADSummaryModel.m
//  OBDClient
//
//  Created by hys on 7/3/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADSummaryModel.h"

@implementation ADSummaryModel
- (id)init
{
    if (self = [super init])
    {
    }
    return self;
}

-(void)setTotalMeliage:(NSArray *)aArguments{
    _requestType=SUMMARY_SETMELIAGE;
    _arguments=aArguments;
    [super startCallWithService:API_SETTOTALMILAGE_SERVICE
                         method:API_SETTOTALMILAGE_METHOD
                      arguments:_arguments];
    
}

-(void)updateMeliage:(NSArray *)aArguments{
    _requestType=SUMMARY_UPDATEMELIAGE;
    _arguments=aArguments;
    [super startCallWithService:API_DEVICE_DTCS_SERVICE
                         method:API_UPDATEMELIAGE_METHOD
                      arguments:_arguments];
}

#pragma mark - implement super class methods/Users/hys/Desktop/_v3/OBDClient/AddViewController/MessageViewController.m
//网络请求的回调 即对收到的object进行处理
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //通知自身请求成功
    if (_requestType==SUMMARY_SETMELIAGE) {
        [_summaryDelegate handleSetTotalMilageData:(NSDictionary*)object];
    }else if (_requestType==SUMMARY_UPDATEMELIAGE){
        [_summaryDelegate handleUpdateMeliageDate:(NSDictionary*)object];
    }
    
    
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //fail.
    
}

@end
