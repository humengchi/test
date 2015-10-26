//
//  ADModelBase.m
//  OBDClient
//
//  Created by Holyen Zou on 13-4-28.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "IVToastHUD.h"

/* BUG FIX!!! If call method requestDetailDeviceInfo: immediately , will occur throw exception.cause the remotingCall fault. fix later.
 **/
#define CALL_METHOD_DELAY(selector,args)  [self performSelector:selector withObject:args afterDelay:0.1]

@implementation ADModelBase

- (id)init
{
    if (self = [super init])
    {
        _remotingCall = [[AMFRemotingCall alloc] init];
        _remotingCall.delegate = self;
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *server_url_zend = [defaults objectForKey:@"server_url_zend"];
        _remotingCall.URL = [NSURL URLWithString:server_url_zend];
//        NSLog(@"%@",_remotingCall.URL);
    }
    return self;
}

- (void)startCallWithService:(NSString *)aService
                      method:(NSString *)aMethod
                   arguments:(NSArray *)aArguments
{
    _callService = aService;
    _callMethod = aMethod;
    _callArguments = aArguments;
#warning 取消cancel
//    [_remotingCall cancel];
    _remotingCall.service = _callService;
    _remotingCall.method = _callMethod;
    _remotingCall.arguments = _callArguments;
    CALL_METHOD_DELAY(@selector(delayStartRemotingCall), nil);
}

- (void)delayStartRemotingCall
{
    [_remotingCall start];
}

- (void)cancel
{
    #warning 取消cancel
//    [_remotingCall cancel];
}

- (void)dealloc
{
    [_remotingCall setDelegate:nil];
}

- (NSArray *)argumentConfig:(NSArray *)aOld
{
    ADUserBase *userBase = [ADSingletonUtil sharedInstance].globalUserBase;
    NSMutableArray *returnArray = [NSMutableArray arrayWithObjects:userBase.token, userBase.token_secret, userBase.userID, nil];
    [returnArray addObjectsFromArray:aOld];
    return returnArray;
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    //implement in subclass.
}

- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
    //implement in subclass.
}

#pragma mark - AMFRemotingCallDelegate
- (void)remotingCallDidFinishLoading:(AMFRemotingCall *)remotingCall
                      receivedObject:(NSObject *)object
{
    [self remotingDidFinishHandleWithCall:remotingCall
                           receivedObject:object];
}

- (void)remotingCall:(AMFRemotingCall *)remotingCall
    didFailWithError:(NSError *)error
{
    ADLogE(@"remotingCall fail,url:%@,error:%@", remotingCall.URL, [error description]);
    [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"codeNoNet",@"MyString", @"")];
//    [self remotingDidFailHandleWithCall:remotingCall
//                                  error:error];
}

@end
