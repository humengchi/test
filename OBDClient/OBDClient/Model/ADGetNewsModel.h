//
//  ADGetNewsModel.h
//  OBDClient
//
//  Created by hys on 25/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADGetNewsDelegate;

@interface ADGetNewsModel : ADModelBase{
    NSArray* _arguments;
    id<ADGetNewsDelegate>getNewsDelegate;
}

@property(weak,nonatomic)id<ADGetNewsDelegate>getNewsDelegate;

-(void)startRequestGetNewsWithArguments:(NSArray*)aArguments;

@end

@protocol ADGetNewsDelegate <NSObject>

-(void)handleGetNewsData:(NSDictionary*)dictionary;

@end
