//
//  ADVehicleBase.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleBase.h"

@implementation ADVehicleBase

- (id)initWithDictionary:(NSDictionary *)aDict{
    
    
    if(self=[super init]){
        
        NSString *storeID = [aDict objectForKey:@"storeID"];
        NSDate *buyDate = [aDict objectForKey:@"buyDate"];
        NSString *defenceFlag = [aDict objectForKey:@"defenceFlag"];
        NSString *ein = [aDict objectForKey:@"ein"];
        NSString *recordId = [aDict objectForKey:@"recordId"];
        NSDate *inspectionDate = [aDict objectForKey:@"inspectionDate"];
        NSDate *licenseDate = [aDict objectForKey:@"licenseDate"];
        NSString *licenseModel = [aDict objectForKey:@"licenseModel"];
        NSString *licenseNumber = [aDict objectForKey:@"licenseNumber"];
        NSString *licensePlace = [aDict objectForKey:@"licensePlace"];
        NSDate *manufactureDate = [aDict objectForKey:@"manufactureDate"];
        NSString *ownerName = [aDict objectForKey:@"ownerName"];
        NSString *salesCompany = [aDict objectForKey:@"salesCompany"];
        NSString *salesCompanyPhone = [aDict objectForKey:@"salesCompanyPhone"];
        NSString *salesContractNumber = [aDict objectForKey:@"salesContractNumber"];
        NSString *salesPerson = [aDict objectForKey:@"salesPerson"];
        NSString *salesPersonPhone = [aDict objectForKey:@"salesPersonPhone"];
        NSString *shareFlag = [aDict objectForKey:@"shareFlag"];
        NSString *vin = [aDict objectForKey:@"vin"];
        
        self.StoreID=[storeID isKindOfClass:[NSNull class]]?nil:storeID;
        self.buyDate=[buyDate isKindOfClass:[NSNull class]]?nil:buyDate;
        self.defenceFlag=[defenceFlag isKindOfClass:[NSNull class]]?nil:defenceFlag;
        self.ein=[ein isKindOfClass:[NSNull class]]?nil:ein;
        self.recordId=[recordId isKindOfClass:[NSNull class]]?nil:recordId;
        self.inspectionDate=[inspectionDate isKindOfClass:[NSNull class]]?nil:inspectionDate;
        self.licenseDate=[licenseDate isKindOfClass:[NSNull class]]?nil:licenseDate;
        self.licenseModel=[licenseModel isKindOfClass:[NSNull class]]?nil:licenseModel;
        self.licenseNumber=[licenseNumber isKindOfClass:[NSNull class]]?nil:licenseNumber;
        self.licensePlace=[licensePlace isKindOfClass:[NSNull class]]?nil:licensePlace;
        self.manufactureDate=[manufactureDate isKindOfClass:[NSNull class]]?nil:manufactureDate;
        self.ownerName=[ownerName isKindOfClass:[NSNull class]]?nil:ownerName;
        self.salesCompany=[salesCompany isKindOfClass:[NSNull class]]?nil:salesCompany;
        self.salesCompanyPhone=[salesCompanyPhone isKindOfClass:[NSNull class]]?nil:salesCompanyPhone;
        self.salesContractNumber=[salesContractNumber isKindOfClass:[NSNull class]]?nil:salesContractNumber;
        self.salesPerson=[salesPerson isKindOfClass:[NSNull class]]?nil:salesPerson;
        self.salesPersonPhone=[salesPersonPhone isKindOfClass:[NSNull class]]?nil:salesPersonPhone;
        self.shareFlag=[shareFlag isKindOfClass:[NSNull class]]?nil:shareFlag;
        self.vin=[vin isKindOfClass:[NSNull class]]?nil:vin;
        
    }
    return self;
}


@end
