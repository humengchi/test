//
//  NSMutableArray+Helper.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-20.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "NSMutableArray+Helper.h"

@implementation NSMutableArray (Helper)

- (NSArray *)reverse
{
    if ([self count] == 0)
        return nil;
    NSUInteger i = 0;
    NSUInteger j = [self count] - 1;
    while (i < j) {
        [self exchangeObjectAtIndex:i
                  withObjectAtIndex:j];
        
        i++;
        j--;
    }
    return self;
}

@end
