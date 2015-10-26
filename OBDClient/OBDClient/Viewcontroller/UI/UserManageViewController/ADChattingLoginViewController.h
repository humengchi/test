//
//  ADChattingLoginViewController.h
//  OBDClient
//
//  Created by hys on 13/8/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADUserFriendsViewController.h"
#import "ADAppDelegate.h"

@interface ADChattingLoginViewController : UIViewController<UITextFieldDelegate>
{
    NSInteger currentLogin;
}

@property (nonatomic, strong) IBOutlet UITextField  *username_TextField;
@property (nonatomic, strong) IBOutlet UITextField  *password_TextField;
@property (nonatomic, strong) IBOutlet UIButton     *remberPasswdBtn;


- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)forgetPasswdButtonPressed:(id)sender;
- (IBAction)remberPasswdButtonPressed:(id)sender;

@end
