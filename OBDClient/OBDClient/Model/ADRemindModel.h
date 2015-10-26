//
//  ADRemindModel.h
//  OBDClient
//
//  Created by hys on 27/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"


@protocol ADRemindDelegate;

@interface ADRemindModel : ADModelBase{
    NSArray* _arguments;
    id<ADRemindDelegate>remindDelegate;
}
//delegate置为弱引用，否则影响内存释放
@property(weak,nonatomic)id<ADRemindDelegate>remindDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end

@protocol ADRemindDelegate <NSObject>

-(void)handleRemindData:(NSDictionary*)dictionary;

@end