//
//  ADModifyPhoneRentViewController.h
//  OBDClient
//
//  Created by hmc on 13/10/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADModifyPhoneRentViewController : UIViewController

@property (nonatomic, strong) IBOutlet UITextField *phoneTextField;
@property (nonatomic, strong) IBOutlet UIButton *modifyBtn;

- (IBAction)submitButtonPressed:(id)sender;

@end
