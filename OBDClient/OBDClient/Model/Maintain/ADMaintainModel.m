//
//  ADMaintainModel.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-16.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "IVToastHUD.h"
#import "ADMaintainModel.h"

NSString * const ADMaintainModelSetItemsSuccessNotification   = @"ADMaintainModelSetItemsSuccessNotification";

NSString * const ADMaintainModelRequestNextMaintainItemsFailNotification   = @"ADMaintainModelRequestNextMaintainItemsFailNotification";


@implementation ADMaintainModel

- (void)dealloc
{

}

- (void)cancel
{
    [super cancel];
}

- (void)requestVehicleMaintainListWithArguments:(NSArray *)aArguments{
    _requestType = VEHICLE_MAINTAIN_LIST;
    [super startCallWithService:API_VEHICLE_MAINTAIN_SERVICE method:API_VEHICLE_MAINTAIN_LIST_GET_METHOD arguments:aArguments];
}

- (void)requestVehicleMaintainHistoryListWithArguments:(NSArray *)aArguments{
    _requestType = VEHICLE_MAINTAIN_HISTORY_LIST;
    [super startCallWithService:API_VEHICLE_MAINTAIN_SERVICE method:API_VEHICLE_MAINTAIN_HISTORY_LIST_GET_METHOD arguments:aArguments];
}

- (void)requestVehicleMaintainItemsWithArguments:(NSArray *)aArguments{
    _requestType = VEHICLE_MAINTAIN_ITEMS;
    [super startCallWithService:API_VEHICLE_MAINTAIN_SERVICE method:API_VEHICLE_MAINTAIN_ITEMS_GET_METHOD arguments:aArguments];
    
}

- (void)saveVehicleMaintainItemsWithArguments:(NSArray *)aArguments{
    _requestType = VEHICLE_MAINTAIN_ITEMS_SET;
    [super startCallWithService:API_VEHICLE_MAINTAIN_SERVICE method:API_VEHICIE_MAINTAIN_ITEMS_SET_METHOD arguments:aArguments];
}

- (void)requestFinishedHandleWithData:(NSArray*)aDataArray
{
    
    if(_requestType==VEHICLE_MAINTAIN_LIST){
        NSMutableArray *itemsTemp = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (NSDictionary *data in aDataArray) {
            [itemsTemp addObject:data];
        }
        self.vehicleMaintainList=itemsTemp;
    }else if (_requestType==VEHICLE_MAINTAIN_HISTORY_LIST){
        NSMutableArray *itemsTemp = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (NSDictionary *data in aDataArray) {
            [itemsTemp addObject:data];
        }
        self.vehicleMaintainHistoryList=itemsTemp;
    }else if(_requestType==VEHICLE_MAINTAIN_ITEMS){
        NSMutableArray *itemsTemp = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (NSDictionary *data in aDataArray) {
            NSMutableDictionary *dataCopy=[data mutableCopy];
            [dataCopy setObject:@"NO" forKey:@"selected"];
            [itemsTemp addObject:dataCopy];
        }
        self.vehicleMaintainItems=itemsTemp;
    }
}

-(BOOL)isNull:(id)object
{
    // 判断是否为空串
    if ([object isEqual:[NSNull null]] || object==[NSNull null]) {
        return NO;
    }
    else if ([object isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    else if ([object isKindOfClass:[NSArray class]])
    {
        return NO;
    }
    else if (object==nil || object == NULL){
        return NO;
    }
    
    return YES;
}

#pragma mark - implement super class methods
- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{   
    NSLog(@"requestFinishedHandleWithData%@",object);
    NSString *resultCode = [(NSDictionary *)object objectForKey:@"resultCode"];
    
    if ([resultCode isKindOfClass:[NSNull class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Nil
                                                            object:self];
        
        NSAssert(0,@"the data return, is null~. ADMaintainModel");
        return;
    }
    
    if ([resultCode isEqualToString:@"200"]) {
        if(_requestType==VEHICLE_MAINTAIN_ITEMS_SET){
            [[NSNotificationCenter defaultCenter] postNotificationName:ADMaintainModelSetItemsSuccessNotification
                                                                object:self];
        }else{
            NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
            [self requestFinishedHandleWithData:dataArray];
        }
    }else{
        //暂时在model里做错误显示
        [IVToastHUD showAsToastErrorWithStatus:[[ADSingletonUtil sharedInstance] errorStringByResultCode:resultCode]];
        
        if(_requestType==VEHICLE_MAINTAIN_LIST){
//            if([resultCode isEqualToString:@"1022"]){
//                [[NSNotificationCenter defaultCenter] postNotificationName:ADMaintainModelRequestNextMaintainItemsFailNotification
//                                                                    object:self];
//            }
            
        }else if (_requestType == VEHICLE_MAINTAIN_HISTORY_LIST){
            
        }else if (_requestType == VEHICLE_MAINTAIN_ITEMS){
            
        }else if (_requestType == VEHICLE_MAINTAIN_ITEMS_SET){
            
        }
    }
    
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall error:(NSError *)aError
{
    if(_requestType==VEHICLE_MAINTAIN_LIST){
        
    }else if (_requestType == VEHICLE_MAINTAIN_HISTORY_LIST){
        
    }else if (_requestType == VEHICLE_MAINTAIN_ITEMS){
        
    }else if (_requestType == VEHICLE_MAINTAIN_ITEMS_SET){
        
    }
    
}



@end
