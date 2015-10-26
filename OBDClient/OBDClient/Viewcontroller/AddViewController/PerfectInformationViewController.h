//
//  PerfectInformationViewController.h
//  OBDClient
//
//  Created by hys on 26/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADMainWindow.h"
#import "ADUserRegisterModel.h"

@interface PerfectInformationViewController : UIViewController<UITextFieldDelegate,ADRegisterDelegate>

@property (weak, nonatomic) IBOutlet UIButton *skipBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UITextField *UserIDTextField;   //必填
@property (weak, nonatomic) IBOutlet UITextField *licenseNoTextField;  //必填
@property (weak, nonatomic) IBOutlet UITextField *docNoTextField;   //必填
@property (weak, nonatomic) IBOutlet UITextField *licensePlaceTextField;
@property (weak, nonatomic) IBOutlet UITextField *permissionDriveTypeTextField;
@property (weak, nonatomic) IBOutlet UITextField *pointsTextField;
@property (weak, nonatomic) IBOutlet UITextField *initialDateTextField;  //必填
@property (weak, nonatomic) IBOutlet UITextField *validDateTextField;  //必填
@property (weak, nonatomic) IBOutlet UITextField *certificationDateTextField;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewOne;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewTwo;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewThree;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewFour;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewFive;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewSix;
@property (weak, nonatomic) IBOutlet UILabel *lab7;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewSeven;
@property (weak, nonatomic) IBOutlet UILabel *lab8;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewEight;
@property (weak, nonatomic) IBOutlet UILabel *lab9;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewNine;

@property(strong,nonatomic)ADUserRegisterModel* registerModel;
@property(nonatomic) NSString *userID;

- (IBAction)dateButtonAction:(id)sender;
- (IBAction)skipButton:(id)sender;
- (IBAction)nextStepButton:(id)sender;


@end
