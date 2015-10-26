//
//  ADCountCenterModel.h
//  OBDClient
//
//  Created by hys on 11/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADCountCenterDeleagte;
typedef enum{
    COUNTMILEAGE_TYPE=1,
    COUNTGREENDRIVESCROE_TYPE=2,
    COUNTMONTHCONSUMPTION=3,
    COUNTBEHAVIOR_TYPE = 4
} ADCountCenterRequestType;

@interface ADCountCenterModel : ADModelBase{
    ADCountCenterRequestType _requestType;
    NSArray* _arguments;
    id<ADCountCenterDeleagte>countCenterDelegate;
}

@property(weak,nonatomic)id<ADCountCenterDeleagte>countCenterDelegate;

-(void)startRequestMonthCountMileage:(NSArray*)aArguments;

-(void)startRequestGreenDriveScroe:(NSArray*)aArguments;

-(void)startRequestMonthConsumption:(NSArray*)aArguments;

-(void)startRequestMonthDrivingBehavior:(NSArray *)aArguments;

@end

@protocol ADCountCenterDeleagte <NSObject>

-(void)handleMonthCountMileage:(NSDictionary*)dictionary;

-(void)handleGreenDriveScroe:(NSDictionary*)dictionary;

-(void)handleMonthConsumption:(NSDictionary*)dictionary;

-(void)handleMonthDrivingBehavior:(NSDictionary*)dictionary;

@end
