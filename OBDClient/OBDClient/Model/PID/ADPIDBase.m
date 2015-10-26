//
//  ADPIDBase.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-6.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADPIDBase.h"

@implementation ADPIDBase

- (id)initWithDeviceID:(NSString *)aDeviceID
               pidCode:(NSString *)aPidCode
              pidCode1:(NSString *)aPidCode1
              pidCode2:(NSString *)aPidCode2
              pidCode3:(NSString *)aPidCode3
              pidCode4:(NSString *)aPidCode4
              pidCode5:(NSString *)aPidCode5
              pidCode6:(NSString *)aPidCode6
              pidCode7:(NSString *)aPidCode7
              pidCode8:(NSString *)aPidCode8
              pidCode9:(NSString *)aPidCode9
             pidCode10:(NSString *)aPidCode10
             pidCode11:(NSString *)aPidCode11
             pidCode12:(NSString *)aPidCode12
             pidCode13:(NSString *)aPidCode13
             pidCode14:(NSString *)aPidCode14
             pidCode15:(NSString *)aPidCode15
             pidCode16:(NSString *)aPidCode16
             pidCode17:(NSString *)aPidCode17
             pidCode18:(NSString *)aPidCode18
             pidCode19:(NSString *)aPidCode19
             pidCode20:(NSString *)aPidCode20
            pidContent:(NSString *)aPidContent
 pidDataByteConversion:(NSString *)aPidDataByteConversion
pidDataByteConversion2:(NSString *)aPidDataByteConversion2
     pidDataByteOrigin:(NSString *)aPidDataByteOrigin
               pidUnit:(NSString *)aPidUnit
           pidValueMax:(NSString *)aPidValueMax
           pidValueMin:(NSString *)aPidValueMin
               useFlag:(NSString *)aUseFlag
{
    if (self = [super init]) {
        self.deviceID = aDeviceID;
        self.pidCode = aPidCode;
        self.pidCode1 = aPidCode1;
        self.pidCode2 = aPidCode2;
        self.pidCode3 = aPidCode3;
        self.pidCode4 = aPidCode4;
        self.pidCode5 = aPidCode5;
        self.pidCode6 = aPidCode6;
        self.pidCode7 = aPidCode7;
        self.pidCode8 = aPidCode8;
        self.pidCode9 = aPidCode9;
        self.pidCode10 = aPidCode10;
        self.pidCode11 = aPidCode11;
        self.pidCode12 = aPidCode12;
        self.pidCode13 = aPidCode13;
        self.pidCode14 = aPidCode14;
        self.pidCode15 = aPidCode15;
        self.pidCode16 = aPidCode16;
        self.pidCode17 = aPidCode17;
        self.pidCode18 = aPidCode18;
        self.pidCode19 = aPidCode19;
        self.pidCode20 = aPidCode20;
        self.pidContent = aPidContent;
        self.pidDataByteConversion = aPidDataByteConversion;
        self.pidDataByteConversion2 = aPidDataByteConversion2;
        self.pidDataByteOrigin = aPidDataByteOrigin;
        self.pidUnit = aPidUnit;
        self.pidValueMax = aPidValueMax;
        self.pidValueMin = aPidValueMin;
        self.useFlag = aUseFlag;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    NSString *deviceID = [aDict objectForKey:@"deviceID"];
    NSString *pidCode = [aDict objectForKey:@"pidCode"];
    NSString *pidCode1 = [aDict objectForKey:@"pidCode1"];
    NSString *pidCode2 = [aDict objectForKey:@"pidCode2"];
    NSString *pidCode3 = [aDict objectForKey:@"pidCode3"];
    NSString *pidCode4 = [aDict objectForKey:@"pidCode4"];
    NSString *pidCode5 = [aDict objectForKey:@"pidCode5"];
    NSString *pidCode6 = [aDict objectForKey:@"pidCode6"];
    NSString *pidCode7 = [aDict objectForKey:@"pidCode7"];
    NSString *pidCode8 = [aDict objectForKey:@"pidCode8"];
    NSString *pidCode9 = [aDict objectForKey:@"pidCode9"];
    NSString *pidCode10 = [aDict objectForKey:@"pidCode10"];
    NSString *pidCode11 = [aDict objectForKey:@"pidCode11"];
    NSString *pidCode12 = [aDict objectForKey:@"pidCode12"];
    NSString *pidCode13 = [aDict objectForKey:@"pidCode13"];
    NSString *pidCode14 = [aDict objectForKey:@"pidCode14"];
    NSString *pidCode15 = [aDict objectForKey:@"pidCode15"];
    NSString *pidCode16 = [aDict objectForKey:@"pidCode16"];
    NSString *pidCode17 = [aDict objectForKey:@"pidCode17"];
    NSString *pidCode18 = [aDict objectForKey:@"pidCode18"];
    NSString *pidCode19 = [aDict objectForKey:@"pidCode19"];
    NSString *pidCode20 = [aDict objectForKey:@"pidCode20"];
    NSString *pidContent = [aDict objectForKey:@"pidContent"];
    NSString *pidDataByteConversion = [aDict objectForKey:@"pidDataByteConversion"];
    NSString *pidDataByteConversion2 = [aDict objectForKey:@"pidDataByteConversion2"];
    NSString *pidDataByteOrigin = [aDict objectForKey:@"pidDataByteOrigin"];
    NSString *pidUnit = [aDict objectForKey:@"pidUnit"];
    NSString *pidValueMax = [aDict objectForKey:@"pidValueMax"];
    NSString *pidValueMin = [aDict objectForKey:@"pidValueMin"];
    NSString *useFlag = [aDict objectForKey:@"useFlag"];
    
    return [self initWithDeviceID:deviceID
                          pidCode:pidCode
                         pidCode1:pidCode1
                         pidCode2:pidCode2
                         pidCode3:pidCode3
                         pidCode4:pidCode4
                         pidCode5:pidCode5
                         pidCode6:pidCode6
                         pidCode7:pidCode7
                         pidCode8:pidCode8
                         pidCode9:pidCode9
                        pidCode10:pidCode10
                        pidCode11:pidCode11
                        pidCode12:pidCode12
                        pidCode13:pidCode13
                        pidCode14:pidCode14
                        pidCode15:pidCode15
                        pidCode16:pidCode16
                        pidCode17:pidCode17
                        pidCode18:pidCode18
                        pidCode19:pidCode19
                        pidCode20:pidCode20
                       pidContent:pidContent
            pidDataByteConversion:pidDataByteConversion
           pidDataByteConversion2:pidDataByteConversion2
                pidDataByteOrigin:pidDataByteOrigin
                          pidUnit:pidUnit
                      pidValueMax:pidValueMax
                      pidValueMin:pidValueMin
                          useFlag:useFlag];
}

@end
