//
//  ADVehicleBase.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADVehicleBase : NSObject

@property (nonatomic) NSString *StoreID;
@property (nonatomic) NSDate *buyDate;
@property (nonatomic) NSString *defenceFlag;
@property (nonatomic) NSString *ein;
@property (nonatomic) NSString *recordId;
@property (nonatomic) NSDate *inspectionDate;
@property (nonatomic) NSDate *licenseDate;
@property (nonatomic) NSString *licenseModel;
@property (nonatomic) NSString *licenseNumber;
@property (nonatomic) NSString *licensePlace;
@property (nonatomic) NSDate *manufactureDate;
@property (nonatomic) NSString *ownerName;
@property (nonatomic) NSString *salesCompany;
@property (nonatomic) NSString *salesCompanyPhone;
@property (nonatomic) NSString *salesContractNumber;
@property (nonatomic) NSString *salesPerson;
@property (nonatomic) NSString *salesPersonPhone;
@property (nonatomic) NSString *shareFlag;
@property (nonatomic) NSString *vin;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end
