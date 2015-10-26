//
//  ADVehicleGateWayConfigEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-11.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
@class ADVehicleGateWayConfigEditViewController;
@protocol ADEditVehicleGateWayDelegate <NSObject>

- (void) editContactViewController:(ADVehicleGateWayConfigEditViewController *) vehicleGateWayConfigEditViewController didEditContact:(NSArray * ) contact;

@end

@interface ADVehicleGateWayConfigEditViewController : ADMenuBaseViewController
@property (weak, nonatomic) id<ADEditVehicleGateWayDelegate> delegate;
@property (nonatomic) NSDictionary *vehicleGateWayConfig;
@property (weak, nonatomic) IBOutlet UITextField *ftp_id_textField;
@property (weak, nonatomic) IBOutlet UITextField *ftp_ipaddr_textField;
@property (weak, nonatomic) IBOutlet UITextField *ftp_pass_textField;
@property (weak, nonatomic) IBOutlet UITextField *ftp_port_textField;
@property (weak, nonatomic) IBOutlet UITextField *sms_addr_textField;
@property (weak, nonatomic) IBOutlet UITextField *svr_url_textField;
@property (weak, nonatomic) IBOutlet UITextField *svr_port_textField;
@end
