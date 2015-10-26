//
//  ADUserBase.m
//  OBDClient
//
//  Created by Holyen Zou on 13-4-28.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserBase.h"
#import "NSString+Helper.h"

@interface ADUserBase ()

@property (nonatomic, strong) NSString *acctID;
@property (nonatomic, strong) NSString *admin;
@property (nonatomic, strong) NSString *dst;
@property (nonatomic, strong) NSString *fullname;
@property (nonatomic, strong) NSString *language;
@property (nonatomic, strong) NSString *mapSource;
@property (nonatomic, strong) NSString *passwd;
@property (nonatomic, strong) NSString *timezone;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *units;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *organID;
@property (nonatomic, strong) NSString *organName;
@property (nonatomic) NSString *smsNum;
@property (nonatomic) NSString *email;

@end

@implementation ADUserBase

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
               email:(NSString *)aEmail
{
    if (self = [super init]) {
        //_MDN = aMDN;
        _acctID = aAcctID;
        _admin = aAdmin;
        //_deviceID = aDeviceID;
        _dst = aDst;
        _fullname = aFullName;
        //_groupID = [aGroupID isKindOfClass:[NSNull class]] ? @"A" : aGroupID;
        //_groupName = aGroupName;
        _language = aLanguage;
        _mapSource = aMapSource;
        _passwd = aPasswd;
        _timezone = aTimezone;
        _uname = aUname;
        _units = aUnits;
        _userID = aUserID;
        _organID = aOrganID;
        _organName = aOrganName;
        _smsNum = aSmsNum;
        _email = aEmail;
    }
    
    return self;
}

- (id)initWithDictionary:(NSDictionary *)aDict
{
    NSString *acctID = [aDict objectForKey:@"acctID"];
    NSString *admin = [aDict objectForKey:@"admin"];
    NSString *dst = [aDict objectForKey:@"dst"];
    NSString *fullname = [aDict objectForKey:@"fullname"];
    NSString *language = [aDict objectForKey:@"language"];
    NSString *mapSource = [aDict objectForKey:@"mapSource"];
    NSString *passwd = [aDict objectForKey:@"passwd"];
    NSString *timezone = [aDict objectForKey:@"timezone"];
    NSString *uname = [aDict objectForKey:@"uname"];
    NSString *units = [aDict objectForKey:@"units"];
    NSString *userID = [aDict objectForKey:@"userID"];
    NSString *organID= [aDict objectForKey:@"organID"];
    NSString *organName = [aDict objectForKey:@"organName"];
    NSString *smsNum = [aDict objectForKey:@"smsNum"];
    NSString *email = [aDict objectForKey:@"email"];
  
    return [self initWithacctID:acctID
                       admin:admin
                         dst:dst
                    fullname:fullname
                    language:language
                   mapSource:mapSource                                   
                      passwd:passwd
                    timezone:timezone
                       uname:uname
                       units:units
                      userID:userID
                     organID:organID
                   organName:organName
                      smsNum:smsNum
                       email:email
            ];
}

@end
