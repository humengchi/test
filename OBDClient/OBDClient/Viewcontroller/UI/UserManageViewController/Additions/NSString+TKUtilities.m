//
//  NSString+TKUtilities.m
//  TKContactsMultiPicker
//
//  Created by Jongtae Ahn on 12. 8. 31..
//  Copyright (c) 2012년 TABKO Inc. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "NSString+TKUtilities.h"

@implementation NSString (TKUtilities)

- (BOOL)containsString:(NSString *)aString
{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}

- (NSString*)telephoneWithReformat
{
    NSString *str = [self mutableCopy];
    if ([str containsString:@"-"])
    {
        str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([str containsString:@" "])
    {
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    if ([str containsString:@"("])
    {
        str = [str stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([str containsString:@")"])
    {
        str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    return str;
}

@end
