//
//  ADVehicleSellInfoEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"

@class ADVehicleSellInfoEditViewController;
@protocol ADEditVehicleSellInfoDelegate <NSObject>

- (void) editContactViewController:(ADVehicleSellInfoEditViewController *) editViewController didEditContact:(NSArray * ) contact;

@end

@interface ADVehicleSellInfoEditViewController : ADBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic) ADVehicleBase *oldVehicleInfo;
@property (weak,nonatomic) id<ADEditVehicleSellInfoDelegate> delegate;
@end
