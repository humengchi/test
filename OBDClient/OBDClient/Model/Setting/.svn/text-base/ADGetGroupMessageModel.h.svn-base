//
//  ADGetGroupMessageModel.h
//  OBDClient
//
//  Created by hys on 15/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADApiManager.h"

@protocol ADGetGroupMessageDelegate;

@interface ADGetGroupMessageModel : ADModelBase
{
    NSArray* _arguments;
    id<ADGetGroupMessageDelegate>getGroupMessageDelegate;
}

@property(strong,nonatomic)id<ADGetGroupMessageDelegate>getGroupMessageDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end

@protocol ADGetGroupMessageDelegate <NSObject>

-(void)handleGroupMessageData:(NSDictionary*)dictionary;

@end