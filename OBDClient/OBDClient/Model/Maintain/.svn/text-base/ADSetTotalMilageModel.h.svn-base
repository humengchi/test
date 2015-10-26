//
//  ADSetTotalMilageModel.h
//  OBDClient
//
//  Created by hys on 7/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADSetTotalMilageDelegate;




@interface ADSetTotalMilageModel : ADModelBase{
    NSArray* _arguments;
    id<ADSetTotalMilageDelegate>setTotalMilageDelegate;
}

//delegate置为弱引用，否则影响内存释放
@property(weak,nonatomic)id<ADSetTotalMilageDelegate>setTotalMilageDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end

@protocol ADSetTotalMilageDelegate <NSObject>

-(void)handleSetTotalMilageData:(NSDictionary*)dictionary;

@end