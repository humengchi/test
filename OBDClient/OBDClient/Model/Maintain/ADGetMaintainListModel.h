//
//  ADGetMaintainListModel.h
//  OBDClient
//
//  Created by hys on 5/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
@protocol ADGetMaintainListDelegate;

typedef enum{
    MAINTAINLIST_TYPE=1,
    MAINTAINITEMS_TYPE=2
    
} ADMaintainRequestType;

@interface ADGetMaintainListModel : ADModelBase{
    ADMaintainRequestType* _requestType;
    NSArray* _arguments;
    id<ADGetMaintainListDelegate>getMaintainListDelegate;

}

//@property(nonatomic)ADMaintainRequestType* requestType;

@property(weak,nonatomic)id<ADGetMaintainListDelegate>getMaintainListDelegate;

- (void)startRequestMaintainListWithArguments:(NSArray *)aArguments;

- (void)startRequestMaintainItemsWithArguments:(NSArray *)aArguments;

@end

@protocol ADGetMaintainListDelegate <NSObject>

-(void)handleMaintainList:(NSDictionary*)dictionary;

-(void)handleMaintainItems:(NSDictionary *)dictionary;

@end