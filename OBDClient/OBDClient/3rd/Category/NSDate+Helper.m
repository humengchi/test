//
//  NSDate+Helper.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    //ADLogV(@"y:%d m:%d d:%d",year, month, day);
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    NSDate *date = [calendar dateFromComponents:components];
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    //ADLogV(@"return localdate:%@ date:%@",localDate, date);
    return localDate;
}

- (NSString *)toStringHasTime:(BOOL)aHastime
{
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:self];
    NSDate *localDate = [self dateByAddingTimeInterval:interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    if (aHastime)
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    else
        [formatter setDateFormat:@"yyyy-MM-dd"];
//    NSLog(@"%@",[formatter stringFromDate:localDate]);
    return [formatter stringFromDate:localDate];
}

+ (NSDate *)localDate
{
    NSDate *date = [NSDate date];
    NSInteger interval = [[NSTimeZone systemTimeZone] secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:interval];
    return localDate;
}

@end
