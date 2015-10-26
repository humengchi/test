//
//  ADVehicleInsure.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ADVehicleInsure : NSObject

@property (nonatomic) NSString *claimClerk;
@property (nonatomic) NSString *claimClerkPhone;
@property (nonatomic) NSDate *createTime;
@property (nonatomic) NSString *customerServicePhone;
@property (nonatomic) NSString *detailInfo;
@property (nonatomic) NSDate *effectiveDate;
@property (nonatomic) NSDate *expirationDate;
@property (nonatomic) NSString *insuranceCompany;
@property (nonatomic) NSString *mark;
@property (nonatomic) NSString *policyNumber;
@property (nonatomic) NSString *recordId;
@property (nonatomic) NSString *vin;
@property (nonatomic) NSString *aitfNumber;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end
