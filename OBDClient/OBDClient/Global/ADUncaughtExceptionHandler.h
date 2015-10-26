//
//  ADUncaughtExceptionHandler.h
//  OBDClient
//
//  Created by hys on 21/3/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADUncaughtExceptionHandler : NSObject{
    BOOL dismissed;
}

@end

void HandleException(NSException *exception);
void SignalHandler(int signal);
void InstallUncaughtExceptionHandler(void);