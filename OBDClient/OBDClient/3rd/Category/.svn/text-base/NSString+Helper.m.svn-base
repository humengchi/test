//
//  NSString+Helper.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-6.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "NSString+Helper.h"

@implementation NSString (Helper)

- (NSDate *)dateFromStringHasTime:(BOOL)aHasTime
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (aHasTime) {
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSDate *destDate = [dateFormatter dateFromString:self];
    return destDate;
}

@end
