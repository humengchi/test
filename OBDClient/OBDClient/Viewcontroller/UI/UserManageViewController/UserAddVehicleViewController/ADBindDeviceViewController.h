//
//  ADBindDeviceViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-7.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADVehiclesModel.h"

@interface ADBindDeviceViewController : ADBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *esnLabel;
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UITextField *esnTextField;
@property (weak, nonatomic) IBOutlet UITextField *keyTextField;
@property (nonatomic) ADVehiclesModel *vehiclesModel;
@property (nonatomic) NSString * beSavedVin;
@property (nonatomic) NSString * fromPage;
- (IBAction)submitTap:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *ensureBtn;

@end
