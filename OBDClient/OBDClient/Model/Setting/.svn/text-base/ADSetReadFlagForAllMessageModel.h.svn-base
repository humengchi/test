//
//  ADSetReadFlagForAllMessageModel.h
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADApiManager.h"

@protocol ADSetReadFlagForAllMessageDelegate;

@interface ADSetReadFlagForAllMessageModel : ADModelBase
{
    NSArray* _arguments;
    id<ADSetReadFlagForAllMessageDelegate>setReadFlagForAllMessageDelegate;
}

@property(strong,nonatomic)id<ADSetReadFlagForAllMessageDelegate>setReadFlagForAllMessageDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end

@protocol ADSetReadFlagForAllMessageDelegate <NSObject>

-(void)handleSetReadFlagForAllMessageData:(NSDictionary*)dictionary;

@end
