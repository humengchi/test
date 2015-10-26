//
//  ADReserveModel.h
//  OBDClient
//
//  Created by hys on 19/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADReserveDelegate;

typedef enum
{
    RESERVEMODEL_GET4SSHOP = 1,
    RESERVEMODEL_RESERVATION = 2,
    RESERVEMODEL_GETRESERVATION =3
    
} ADReserveModelRequestType;

@interface ADReserveModel : ADModelBase{
    ADReserveModelRequestType* _requestType;
    NSArray* _arguments;
    id<ADReserveDelegate>reserveDelegate;
}

@property(weak,nonatomic)id<ADReserveDelegate>reserveDelegate;

-(void)startRequestBlinding4SShopWithArguments:(NSArray *)aArguments;

-(void)startRequestSubmitWithArguments:(NSArray *)aArguments;

-(void)startRequestGetReservationWithArguments:(NSArray *)aArguments;

@end

@protocol ADReserveDelegate <NSObject>

-(void)handleBlinding4SShop:(NSDictionary*)dictionary;

-(void)handleSubmit:(NSDictionary*)dictionary;

-(void)handleGetReservation:(NSDictionary*)dictionary;

@end