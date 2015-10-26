//
//  ADGetMessageNotifactionSwitchModel.h
//  OBDClient
//
//  Created by hys on 11/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADApiManager.h"

@protocol ADGetMessageNotifactionSwitchDelegate;

@interface ADGetMessageNotifactionSwitchModel : ADModelBase
{
    NSArray* _arguments;
    id<ADGetMessageNotifactionSwitchDelegate>getMessageNotifactionSwitchDelegate;

}

@property(strong,nonatomic)id<ADGetMessageNotifactionSwitchDelegate>getMessageNotifactionSwitchDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;

@end

@protocol ADGetMessageNotifactionSwitchDelegate <NSObject>

-(void)handleGetMessageNotifactionSwitchStatus:(NSDictionary*)dictionary;

@end