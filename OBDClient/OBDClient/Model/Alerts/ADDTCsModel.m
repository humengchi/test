//
//  ADDTCsModel.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-17.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDTCsModel.h"
#import "IVToastHUD.h"

NSString * const ADDTCsModelRequestSuccessNotification = @"ADDTCsModelRequestSuccessNotification";
NSString * const ADDTCsModelRequestFailNotification = @"ADDTCsModelRequestFailNotification";
NSString * const ADDTCsModelRequestTimeoutNotification = @"ADDTCsModelRequestTimeoutNotification";
NSString * const ADDTCsModelLoginTimeOutNotification =@"ADDTCsModelLoginTimeOutNotification";

@implementation ADDTCsModel

- (void)requestDTCsWithArguments:(NSArray *)aArguments
{
    _requestType=DTCSMODEL_ALL_DTCS;
    [super startCallWithService:API_DEVICE_DTCS_SERVICE
                         method:API_DEVICE_DTCS_METHOD
                      arguments:[self argumentConfig:aArguments]];
}

- (void)requestDTCInfoWithArguments:(NSArray *)aAguments
{
//    NSLog(@"%@",aAguments);
    _requestType=DTCSMODEL_DTC_INFOS;
    [super startCallWithService:API_DEVICE_DTCS_SERVICE method:API_DEVICE_DTCS_INFO_METHOD arguments:aAguments];
}

#pragma mark - implement super class methods

- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall receivedObject:(NSObject *)object
{
    NSLog(@"%@",object);
    NSString *resultCode = [(NSDictionary *)object objectForKey:@"resultCode"];
    
    if ([resultCode isKindOfClass:[NSNull class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADDTCsModelRequestFailNotification
                                                            object:self];
        
        NSAssert(0,@"the data return, is null~. ADDTCsModel");
        return;
    }
    
    if ([resultCode isEqualToString:@"200"]) {
        NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
        if(_requestType==DTCSMODEL_ALL_DTCS){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADDTCsModelRequestSuccessNotification
                                                                object:self];
            
            NSMutableArray *dtcsTemp = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
            for (ASObject *asObject in dataArray) {
                NSDictionary *data = [asObject properties];
                ADDTCBase *dtcBase = [[ADDTCBase alloc] initWithDictionary:data];
                [dtcsTemp addObject:dtcBase];
            }
            self.dtcs = dtcsTemp;
        }else if (_requestType==DTCSMODEL_DTC_INFOS){
            NSMutableArray *dtcsInfoTemp = [[NSMutableArray alloc] initWithCapacity:[dataArray count]];
            for (ASObject *asObject in dataArray) {
                NSDictionary *data = [asObject properties];
                [dtcsInfoTemp addObject:data];
            }
            self.dtcsInfo=dtcsInfoTemp;
            
        }
        
    }else{
        //暂时在model里做错误显示
        [IVToastHUD showAsToastErrorWithStatus:[[ADSingletonUtil sharedInstance] errorStringByResultCode:resultCode]];
        if (_requestType==DTCSMODEL_ALL_DTCS) {
            if ([resultCode isEqualToString:@"202"]||[resultCode isEqualToString:@"203"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ADDTCsModelLoginTimeOutNotification object:nil];
            }
        }
    }

}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall error:(NSError *)aError
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDTCsModelRequestFailNotification
                                                        object:self];
}

@end
