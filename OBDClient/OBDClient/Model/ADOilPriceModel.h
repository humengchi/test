//
//  ADOilPriceModel.h
//  OBDClient
//
//  Created by hys on 31/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADOilPriceDelegate;

@interface ADOilPriceModel : ADModelBase{
    NSArray* _arguments;
    id<ADOilPriceDelegate>oilPriceDelegate;
}

@property(weak,nonatomic)id<ADOilPriceDelegate>oilPriceDelegate;

- (void)startCallWithArguments:(NSArray *)aArguments;
@end


@protocol ADOilPriceDelegate <NSObject>

-(void)handleOilPriceData:(NSDictionary*)dictionary;

@end

