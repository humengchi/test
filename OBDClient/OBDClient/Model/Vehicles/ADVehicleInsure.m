//
//  ADVehicleInsure.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleInsure.h"

@implementation ADVehicleInsure

- (id)initWithDictionary:(NSDictionary *)aDict{
    
    
    if(self=[super init]){
        
        
        NSString *claimClerk = [aDict objectForKey:@"claimClerk"];
        NSString *claimClerkPhone = [aDict objectForKey:@"claimClerkPhone"];
        NSDate *createTime = [aDict objectForKey:@"createTime"];
        NSString *customerServicePhone = [aDict objectForKey:@"customerServicePhone"];
        NSString *detailInfo = [aDict objectForKey:@"detailInfo"];
        NSDate *effectiveDate = [aDict objectForKey:@"effectiveDate"];
        NSDate *expirationDate = [aDict objectForKey:@"expirationDate"];
        NSString *insuranceCompany = [aDict objectForKey:@"insuranceCompany"];
        NSString *mark = [aDict objectForKey:@"mark"];
        NSString *policyNumber = [aDict objectForKey:@"policyNumber"];
        NSString *recordId = [aDict objectForKey:@"recordId"];
        NSString *vin = [aDict objectForKey:@"vin"];
        NSString *aitfNumber = [aDict objectForKey:@"aitfNumber"];
        
        self.claimClerk=[claimClerk isKindOfClass:[NSNull class]]?nil:claimClerk;
        self.claimClerkPhone=[claimClerkPhone isKindOfClass:[NSNull class]]?nil:claimClerkPhone;
        self.createTime=[createTime isKindOfClass:[NSNull class]]?nil:createTime;
        self.customerServicePhone=[customerServicePhone isKindOfClass:[NSNull class]]?nil:customerServicePhone;
        self.detailInfo=[detailInfo isKindOfClass:[NSNull class]]?nil:detailInfo;
        self.effectiveDate=[effectiveDate isKindOfClass:[NSNull class]]?nil:effectiveDate;
        self.expirationDate=[expirationDate isKindOfClass:[NSNull class]]?nil:expirationDate;
        self.insuranceCompany=[insuranceCompany isKindOfClass:[NSNull class]]?nil:insuranceCompany;
        self.mark=[mark isKindOfClass:[NSNull class]]?nil:mark;
        self.policyNumber=[policyNumber isKindOfClass:[NSNull class]]?nil:policyNumber;
        self.recordId=[recordId isKindOfClass:[NSNull class]]?nil:recordId;
        self.vin=[vin isKindOfClass:[NSNull class]]?nil:vin;
        self.aitfNumber=[aitfNumber isKindOfClass:[NSNull class]]?nil:aitfNumber;
    }
    return self;
}


@end
