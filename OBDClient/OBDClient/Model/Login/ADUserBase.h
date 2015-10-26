//
//  ADUserBase.h
//  OBDClient
//
//  Created by Holyen Zou on 13-4-28.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASObject.h"

@interface ADUserBase : NSObject

@property (nonatomic, strong, readonly) NSString *acctID;
@property (nonatomic, strong, readonly) NSString *admin;
@property (nonatomic, strong, readonly) NSString *dst;
@property (nonatomic, strong, readonly) NSString *fullname;
@property (nonatomic, strong, readonly) NSString *language;
@property (nonatomic, strong, readonly) NSString *mapSource;
@property (nonatomic, strong, readonly) NSString *passwd;
@property (nonatomic, strong, readonly) NSString *timezone;
@property (nonatomic, strong, readonly) NSString *uname;
@property (nonatomic, strong, readonly) NSString *units;
@property (nonatomic, strong, readonly) NSString *userID;
@property (nonatomic, strong, readonly) NSString *organID;
@property (nonatomic, strong, readonly) NSString *organName;
@property (nonatomic,readonly) NSString *smsNum;
@property (nonatomic,readonly) NSString *email;

@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *token_secret;

- (id)initWithacctID:(NSString *)aAcctID
               admin:(NSString *)aAdmin
                 dst:(NSString *)aDst
            fullname:(NSString *)aFullName
            language:(NSString *)aLanguage
           mapSource:(NSString *)aMapSource
              passwd:(NSString *)aPasswd
            timezone:(NSString *)aTimezone
               uname:(NSString *)aUname
               units:(NSString *)aUnits
              userID:(NSString *)aUserID
             organID:(NSString *)aOrganID
           organName:(NSString *)aOrganName
              smsNum:(NSString *)aSmsNum
               email:(NSString *)aEmail;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end
