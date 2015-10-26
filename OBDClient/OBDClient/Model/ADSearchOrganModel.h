//
//  ADSearchOrganModel.h
//  OBDClient
//
//  Created by hys on 19/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADSerachOrganDelegate;
typedef enum{
    SEARCHORGAN_TYPE=0
    
}ADSearchOrganRequestType;

@interface ADSearchOrganModel : ADModelBase{
    ADSearchOrganRequestType* _requestType;
    NSArray* _arguments;
    id<ADSerachOrganDelegate>searchOrganDelegate;
}

@property(weak,nonatomic)id<ADSerachOrganDelegate>searchOrganDelegate;

-(void)startRequestSearchOrganWithArguments:(NSArray *)aArguments;

@end

@protocol ADSerachOrganDelegate <NSObject>

-(void)handleSearchOrganList:(NSDictionary*)dictionary;

@end
