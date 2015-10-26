//
//  ADDTCBase.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-17.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDTCBase.h"

@interface ADDTCBase ()

@property (nonatomic, strong) NSString *DTC_1;
@property (nonatomic, strong) NSString *DTC_2;
@property (nonatomic, strong) NSString *DTC_3;
@property (nonatomic, strong) NSString *DTC_4;
@property (nonatomic, strong) NSString *DTC_5;
@property (nonatomic, strong) NSString *DTC_6;
@property (nonatomic, strong) NSString *DTC_7;
@property (nonatomic, strong) NSString *DTC_8;
@property (nonatomic, strong) NSString *DTC_9;
@property (nonatomic, strong) NSString *DTC_10;
@property (nonatomic)         NSInteger Num_of_DTC;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSDate   *readDate;

@end

@implementation ADDTCBase

- (id)initWithDTC_1:(NSString *)aDTC_1
              DTC_2:(NSString *)aDTC_2
              DTC_3:(NSString *)aDTC_3
              DTC_4:(NSString *)aDTC_4
              DTC_5:(NSString *)aDTC_5
              DTC_6:(NSString *)aDTC_6
              DTC_7:(NSString *)aDTC_7
              DTC_8:(NSString *)aDTC_8
              DTC_9:(NSString *)aDTC_9
              DTC_10:(NSString *)aDTC_10
         Num_of_DTC:(NSString *)aNum_of_DTC
           deviceID:(NSString *)adeviceID
           readDate:(NSString *)areadDate
{
    if (self = [self init]) {
        self.DTC_1 = aDTC_1;
        self.DTC_2 = aDTC_2;
        self.DTC_3 = aDTC_3;
        self.DTC_4 = aDTC_4;
        self.DTC_5 = aDTC_5;
        self.DTC_6 = aDTC_6;
        self.DTC_7 = aDTC_7;
        self.DTC_8 = aDTC_8;
        self.DTC_9 = aDTC_9;
        self.DTC_10 = aDTC_10;
        self.Num_of_DTC = [aNum_of_DTC intValue];
        self.deviceID = adeviceID;
        self.readDate = (NSDate *)areadDate;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    NSString *DTC_1 = [aDict objectForKey:@"DTC_1"];
    NSString *DTC_2 = [aDict objectForKey:@"DTC_2"];
    NSString *DTC_3 = [aDict objectForKey:@"DTC_3"];
    NSString *DTC_4 = [aDict objectForKey:@"DTC_4"];
    NSString *DTC_5 = [aDict objectForKey:@"DTC_5"];
    NSString *DTC_6 = [aDict objectForKey:@"DTC_6"];
    NSString *DTC_7 = [aDict objectForKey:@"DTC_7"];
    NSString *DTC_8 = [aDict objectForKey:@"DTC_8"];
    NSString *DTC_9 = [aDict objectForKey:@"DTC_9"];
    NSString *DTC_10 = [aDict objectForKey:@"DTC_10"];
    NSString *Num_of_DTC = [aDict objectForKey:@"Num_of_DTC"];
    NSString *deviceID = [aDict objectForKey:@"deviceID"];
    NSString *readDate = [aDict objectForKey:@"readDate"];
    
    return [self initWithDTC_1:DTC_1
                         DTC_2:DTC_2
                         DTC_3:DTC_3
                         DTC_4:DTC_4
                         DTC_5:DTC_5
                         DTC_6:DTC_6
                         DTC_7:DTC_7
                         DTC_8:DTC_8
                         DTC_9:DTC_9
                        DTC_10:DTC_10
                    Num_of_DTC:Num_of_DTC
                      deviceID:deviceID
                      readDate:readDate];
}

@end
