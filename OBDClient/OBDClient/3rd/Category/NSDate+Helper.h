//
//  NSDate+Helper.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Helper)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (NSString *)toStringHasTime:(BOOL)aHastime;

+ (NSDate *)localDate;

@end
