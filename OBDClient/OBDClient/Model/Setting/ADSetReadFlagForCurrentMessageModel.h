//
//  ADSetReadFlagForCurrentMessageModel.h
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADApiManager.h"

@protocol ADSetReadFlagForCurrentMessageDelegate;


@interface ADSetReadFlagForCurrentMessageModel : ADModelBase
{
    NSArray* _arguments;
    id<ADSetReadFlagForCurrentMessageDelegate>setReadFlagForCurrentMessageDelegate;
    
}


@property(strong,nonatomic)id<ADSetReadFlagForCurrentMessageDelegate>setReadFlagForCurrentMessageDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end


@protocol ADSetReadFlagForCurrentMessageDelegate <NSObject>

-(void)handleSetReadFlagForCurrentMessageData:(NSDictionary*)dictionary;

@end

