//
//  ADCalendarModel.h
//  OBDClient
//
//  Created by hys on 25/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADModelBase.h"

extern NSString * const ADCalendarModelRequestSuccessNotification;
extern NSString * const ADCalendarModelRequestFailNotification;
extern NSString * const ADCalendarModelRequestTimeoutNotification;
extern NSString * const ADCalendarModelRequestDataErrorNotification;

@protocol ADCalendarWeatherDelegate;


@interface ADCalendarModel : ADModelBase
{
    NSArray* _arguments;
    id<ADCalendarWeatherDelegate>weatherDelegate;
}

@property(weak,nonatomic)id<ADCalendarWeatherDelegate>weatherDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;


@end

@protocol ADCalendarWeatherDelegate <NSObject>

-(void)handleWeatherData:(NSArray*)dictionary;


@end