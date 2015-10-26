//
//  ADModelBase.h
//  OBDClient
//
//  Created by Holyen Zou on 13-4-28.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMFRemotingCall.h"
#import "ADApiManager.h"
#import "ADSingletonUtil.h"

@interface ADModelBase : NSObject <AMFRemotingCallDelegate>
{
    NSString *_callService;
    NSString *_callMethod;
    NSArray *_callArguments;
}

@property (strong) AMFRemotingCall *remotingCall;

@property (nonatomic, strong, readonly) NSMutableDictionary *receivedData;

- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object;

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError;

- (void)startCallWithService:(NSString *)aService
                      method:(NSString *)aMethod
                   arguments:(NSArray *)aArguments;

- (void)cancel;

- (NSArray *)argumentConfig:(NSArray *)aOld;

@end
