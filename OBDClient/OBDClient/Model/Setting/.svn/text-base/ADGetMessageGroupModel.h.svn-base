//
//  ADGetMessageGroupModel.h
//  OBDClient
//
//  Created by hys on 10/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADApiManager.h"

@protocol ADGetMessageGroupDelegate;

@interface ADGetMessageGroupModel : ADModelBase
{
    NSArray* _arguments;
    id<ADGetMessageGroupDelegate>getMessageGroupDelegate;
}

@property(weak,nonatomic)id<ADGetMessageGroupDelegate>getMessageGroupDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;

@end

@protocol ADGetMessageGroupDelegate <NSObject>

-(void)handleMessageGroupData:(NSDictionary*)dictionary;

@end