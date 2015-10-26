//
//  ADMaintainModel.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-16.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

extern NSString * const ADMaintainModelSetItemsSuccessNotification;
extern NSString * const ADMaintainModelRequestNextMaintainItemsFailNotification;

typedef enum{
    VEHICLE_MAINTAIN_LIST = 0,
    VEHICLE_MAINTAIN_HISTORY_LIST = 1,
    VEHICLE_MAINTAIN_ITEMS = 2,
    VEHICLE_MAINTAIN_ITEMS_SET = 3
    
} ADMaintainModelRequestType;

#define KVO_MAINTAIN_LIST_PATH_NAME       @"vehicleMaintainList"
#define KVO_MAINTAIN_HISTORY_PATH_NAME    @"vehicleMaintainHistoryList"
#define KVO_MAINTAIN_ITEMS_PATH_NAME      @"vehicleMaintainItems"

@interface ADMaintainModel : ADModelBase
{
    ADMaintainModelRequestType _requestType;
}

@property (nonatomic) NSArray *vehicleMaintainList;
@property (nonatomic) NSArray *vehicleMaintainHistoryList;
@property (nonatomic) NSArray *vehicleMaintainItems;

- (void)requestVehicleMaintainListWithArguments:(NSArray *)aArguments;

- (void)requestVehicleMaintainHistoryListWithArguments:(NSArray *)aArguments;

- (void)requestVehicleMaintainItemsWithArguments:(NSArray *)aArguments;

- (void)saveVehicleMaintainItemsWithArguments:(NSArray *)aArguments;

@end
