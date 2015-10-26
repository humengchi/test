//
//  ADUserRegisterModel.h
//  OBDClient
//
//  Created by hys on 23/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADModelBase.h"

@protocol ADRegisterDelegate;

typedef enum
{
    REGISTERUSER = 1,
    REGISTERUSERDRIVERLICENSE=2
} ADUserRegisterModelRequestType;


@interface ADUserRegisterModel : ADModelBase
{
    ADUserRegisterModelRequestType _requestType;
    NSArray* _arguments;
    id<ADRegisterDelegate>registerDelegate;
}

@property(weak,nonatomic)id<ADRegisterDelegate>registerDelegate;
- (void)startRequestUserWithArguments:(NSArray *)aArguments;
- (void)startRequestUserDriverLicenseWithArguments:(NSArray *)aArguments;
@end


@protocol ADRegisterDelegate <NSObject>

-(void)handleUser:(NSDictionary*)dictionary;

-(void)handleUserDriverLicense:(NSDictionary *)dictionary;

@end

