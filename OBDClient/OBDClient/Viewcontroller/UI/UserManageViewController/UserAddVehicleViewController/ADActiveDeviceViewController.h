//
//  ADActiveDeviceViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-7.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADVehiclesModel.h"

@interface ADActiveDeviceViewController : ADBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *activeStatusTextField;
@property (weak, nonatomic) IBOutlet UIButton *activeButton;
@property (nonatomic) NSString *willActiveVin;
@property (nonatomic) ADVehiclesModel *vehiclesModel;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
//@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIButton *activityBtn;
@property (nonatomic) NSString *fromPage;

- (IBAction)activeTap:(id)sender;
@end
