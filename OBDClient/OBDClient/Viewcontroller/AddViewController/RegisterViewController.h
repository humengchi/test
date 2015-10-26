//
//  RegisterViewController.h
//  OBDClient
//
//  Created by hys on 25/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADUserRegisterModel.h"
#import "ADMainWindow.h"
#import "IVToastHUD.h"
#import "PerfectInformationViewController.h"
#import "ADAppDelegate.h"
#import "ADProtocolViewController.h"



@interface RegisterViewController : UIViewController<UITextFieldDelegate,ADRegisterDelegate, XMPPStreamDelegate>

@property(nonatomic,strong)ADUserRegisterModel* UserRegisterModel;

@property (weak, nonatomic) IBOutlet UITextField *UserNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWordTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassWordRepeatTextField;
@property (weak, nonatomic) IBOutlet UITextField *MailTextField;
@property (weak, nonatomic) IBOutlet UITextField *PhoneTextField;

- (IBAction)submitButton:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewThree;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewFour;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewFive;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewOneIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewTwoIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewThreeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewFourIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewFiveIcon;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewArrow;

- (IBAction)agreeProtocolButton:(id)sender;
@end
