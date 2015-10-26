//
//  ADDeleteCurrentMessagesModel.h
//  OBDClient
//
//  Created by hys on 1/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADDeleteCurrentMessagesDelegate;


@interface ADDeleteCurrentMessagesModel : ADModelBase{
    NSArray* _arguments;
    id<ADDeleteCurrentMessagesDelegate>deleteCurrentMessagesDelegate;

}

//delegate置为弱引用，否则影响内存释放
@property(weak,nonatomic)id<ADDeleteCurrentMessagesDelegate>deleteCurrentMessagesDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end

@protocol ADDeleteCurrentMessagesDelegate <NSObject>

-(void)handleDeleteCurrentMessagesData:(NSDictionary*)dictionary;

@end