//
//  ADTripLogModel.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-31.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@interface ADTripLogModel : ADModelBase

- (void)requestTripLogWithDeviceID:(NSString *)aDeviceID;

@end
