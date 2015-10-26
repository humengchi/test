//
//  ADSetReadFlagForGroupMessageModel.h
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADApiManager.h"

@protocol ADSetReadFlagForGroupMessageDelegate;

@interface ADSetReadFlagForGroupMessageModel : ADModelBase
{
    NSArray* _arguments;
    id<ADSetReadFlagForGroupMessageDelegate>setReadFlagForGroupMessageDelegate;

}

@property(strong,nonatomic)id<ADSetReadFlagForGroupMessageDelegate>setReadFlagForGroupMessageDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end

@protocol ADSetReadFlagForGroupMessageDelegate <NSObject>

-(void)handleSetReadFlagForGroupMessageData:(NSDictionary*)dictionary;

@end

