//
//  ADLogger.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-6.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADLogger.h"

#import "DDASLLogger.h"
#import "DDTTYLogger.h"

@implementation ADLogger
+ (void)init
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
#ifdef DEBUG
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
#endif
}

@end
