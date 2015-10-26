//
//  ADLimitLineModel.h
//  OBDClient
//
//  Created by hys on 4/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADLimitLineDelegate;

@interface ADLimitLineModel : ADModelBase{
    NSArray* _arguments;
    id<ADLimitLineDelegate>limitLineDelegate;
}
//delegate置为弱引用，否则影响内存释放
@property(weak,nonatomic)id<ADLimitLineDelegate>limitLineDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end


@protocol ADLimitLineDelegate <NSObject>

-(void)handleLimitLineData:(NSDictionary*)dictionary;

@end