//
//  ADSetMessageNotifactionSwitchModel.h
//  OBDClient
//
//  Created by hys on 11/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADApiManager.h"

@protocol ADSetMessageNotifactionSwitchDelegate;

@interface ADSetMessageNotifactionSwitchModel : ADModelBase{
    NSArray* _arguments;
    id<ADSetMessageNotifactionSwitchDelegate>setMessageNotifactionSwitchDelegate;
}

@property(strong,nonatomic)id<ADSetMessageNotifactionSwitchDelegate>setMessageNotifactionSwitchDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;


@end

@protocol ADSetMessageNotifactionSwitchDelegate <NSObject>

-(void)handleSetMessageNotifactionSwitchStatus:(NSDictionary*)dictionary;

@end