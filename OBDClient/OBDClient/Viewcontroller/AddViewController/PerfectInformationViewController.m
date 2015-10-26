//
//  PerfectInformationViewController.m
//  OBDClient
//
//  Created by hys on 26/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "PerfectInformationViewController.h"

@interface PerfectInformationViewController ()

@end

@implementation PerfectInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _registerModel=[[ADUserRegisterModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"PerfectInformation",@"MyString", @"");
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    UIImageView* titleImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    titleImgView.image=[UIImage imageNamed:@"app_topbar_bg~iphone.png"];
    [titleView addSubview:titleImgView];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 7, 200, 30)];
    titleLabel.text=NSLocalizedStringFromTable(@"PerfectInformation",@"MyString", @"");
    titleLabel.textAlignment=UITextAlignmentCenter;
    titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleLabel.textColor=[UIColor whiteColor];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];
    
    UIButton *cancelButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 8, 44, 30)];
    [cancelButton setTitle:NSLocalizedStringFromTable(@"SkipKey",@"MyString", @"") forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn1_nor.png"] forState:UIControlStateNormal];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn1-act.png"] forState:UIControlStateHighlighted];
    [cancelButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
    [cancelButton addTarget:self action:@selector(skipButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font=[UIFont systemFontOfSize:12];
    cancelButton.titleLabel.textAlignment=UITextAlignmentCenter;
    [titleView addSubview:cancelButton];
    
    UIButton *saveButton = [[UIButton alloc]initWithFrame:CGRectMake(270, 8, 44, 30)];
    [saveButton setTitle:NSLocalizedStringFromTable(@"saveKey",@"MyString", @"") forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn1_nor.png"] forState:UIControlStateNormal];
    [saveButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn1-act.png"] forState:UIControlStateHighlighted];
    [saveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 2, 0)];
    [saveButton addTarget:self action:@selector(nextStepButton:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.titleLabel.font=[UIFont systemFontOfSize:12];
    saveButton.titleLabel.textAlignment=UITextAlignmentCenter;
    [titleView addSubview:saveButton];
    

    [self.view addSubview:titleView];
    
    [_skipBtn setTitle:NSLocalizedStringFromTable(@"skipKey",@"MyString", @"") forState:UIControlStateNormal];
    [_nextBtn setTitle:NSLocalizedStringFromTable(@"nextKey",@"MyString", @"") forState:UIControlStateNormal];
    
    
    _UserIDTextField.delegate=self;
    _licenseNoTextField.delegate=self;
    _docNoTextField.delegate=self;
    _licensePlaceTextField.delegate=self;
    _permissionDriveTypeTextField.delegate=self;
    _pointsTextField.delegate=self;
    _initialDateTextField.delegate=self;
    _validDateTextField.delegate=self;
    _certificationDateTextField.delegate=self;
    
    [_UserIDTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_licenseNoTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_docNoTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_licensePlaceTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_permissionDriveTypeTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_pointsTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_initialDateTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_validDateTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_certificationDateTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _UserIDTextField.returnKeyType=UIReturnKeyNext;
    _licenseNoTextField.returnKeyType=UIReturnKeyNext;
    _docNoTextField.returnKeyType=UIReturnKeyNext;
    _licensePlaceTextField.returnKeyType=UIReturnKeyNext;
    _permissionDriveTypeTextField.returnKeyType=UIReturnKeyNext;
    _pointsTextField.returnKeyType=UIReturnKeyNext;
    _initialDateTextField.returnKeyType=UIReturnKeyNext;
    _validDateTextField.returnKeyType=UIReturnKeyNext;
    _certificationDateTextField.returnKeyType=UIReturnKeyDone;
    
    

//    _datePicker=[[FlatDatePicker alloc]initWithParentView:self.view];
//    _datePicker.datePickerMode=FlatDatePickerModeDate;
//    _datePicker.delegate=self;
//    
//    [_datePicker dismiss];
    if (IOS7_OR_LATER ) {            //IOS7.0 3.5寸屏幕
        [titleView setFrame:CGRectMake(0, 20, WIDTH, 44)];
        CGRect frame=_lab1.frame;
        frame.origin.y+=20;
        [_lab1 setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=20;
        [_ImgViewOne setFrame:frame];
        
        frame=_UserIDTextField.frame;
        frame.origin.y+=20;
        [_UserIDTextField setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y+=20;
        [_lab2 setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=20;
        [_ImgViewTwo setFrame:frame];
        
        frame=_licenseNoTextField.frame;
        frame.origin.y+=20;
        [_licenseNoTextField setFrame:frame];
        
        frame=_lab3.frame;
        frame.origin.y+=20;
        [_lab3 setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=20;
        [_ImgViewThree setFrame:frame];
        
        frame=_docNoTextField.frame;
        frame.origin.y+=20;
        [_docNoTextField setFrame:frame];
        
        frame=_lab4.frame;
        frame.origin.y+=20;
        [_lab4 setFrame:frame];
        
        frame=_ImgViewFour.frame;
        frame.origin.y+=20;
        [_ImgViewFour setFrame:frame];
        
        frame=_licensePlaceTextField.frame;
        frame.origin.y+=20;
        [_licensePlaceTextField setFrame:frame];
        
        frame=_lab5.frame;
        frame.origin.y+=20;
        [_lab5 setFrame:frame];
        
        frame=_ImgViewFive.frame;
        frame.origin.y+=20;
        [_ImgViewFive setFrame:frame];
        
        frame=_permissionDriveTypeTextField.frame;
        frame.origin.y+=20;
        [_permissionDriveTypeTextField setFrame:frame];
        
        frame=_lab6.frame;
        frame.origin.y+=20;
        [_lab6 setFrame:frame];
        
        frame=_ImgViewSix.frame;
        frame.origin.y+=20;
        [_ImgViewSix setFrame:frame];
        
        frame=_pointsTextField.frame;
        frame.origin.y+=20;
        [_pointsTextField setFrame:frame];
        
        frame=_lab7.frame;
        frame.origin.y+=20;
        [_lab7 setFrame:frame];
        
        frame=_ImgViewSeven.frame;
        frame.origin.y+=20;
        [_ImgViewSeven setFrame:frame];
        
        frame=_initialDateTextField.frame;
        frame.origin.y+=20;
        [_initialDateTextField setFrame:frame];
        
        frame=_lab8.frame;
        frame.origin.y+=20;
        [_lab8 setFrame:frame];
        
        frame=_ImgViewEight.frame;
        frame.origin.y+=20;
        [_ImgViewEight setFrame:frame];
        
        frame=_validDateTextField.frame;
        frame.origin.y+=20;
        [_validDateTextField setFrame:frame];
        
        frame=_lab9.frame;
        frame.origin.y+=20;
        [_lab9 setFrame:frame];
        
        frame=_ImgViewNine.frame;
        frame.origin.y+=20;
        [_ImgViewNine setFrame:frame];
        
        frame=_certificationDateTextField.frame;
        frame.origin.y+=20;
        [_certificationDateTextField setFrame:frame];

        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        
	}

}

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender.tag==9){
        [sender resignFirstResponder];
        [self resumeView];
    }else{
        [(UITextField *)[self.view viewWithTag:sender.tag+1] becomeFirstResponder];
    }
}

#pragma mark -Keyboard
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移Y个单位，按实际情况设置
    float Y = 20.0f;
    float H = 0.0f;
    if (textField.tag>4) {
        Y=-textField.tag*30;
        H=textField.tag*30;
    }
    CGRect rect=CGRectMake(0.0f,Y,width,height+H);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 20.0f;
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        Y=0.0f;
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        Y=0.0f;
	}

    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self resumeView];
}


#pragma mark - Button Action
- (void)perfectInformationBackButton:(id)sender{
    [(ADMainWindow *)self.view.window transitionToLoginViewController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)skipButton:(id)sender {
    [(ADMainWindow*)self.view.window transitionToLoginViewController];
}

- (IBAction)nextStepButton:(id)sender {
    NSString* useID=_userID;
    NSString* licenseNo=_licenseNoTextField.text;
    NSString* docNo=_docNoTextField.text;
    NSString* userName=_UserIDTextField.text;
    NSString* licensePlace=_licensePlaceTextField.text;
    NSString* permissionDriveType=_permissionDriveTypeTextField.text;
    NSString* points=_pointsTextField.text;
    NSString* initialDate=_initialDateTextField.text;
    NSString* validDate=_validDateTextField.text;
    NSString* certificationDate=_certificationDateTextField.text;
    if ([useID isEqualToString:@""]||[licenseNo isEqualToString:@""]||[docNo isEqualToString:@""]||[initialDate isEqualToString:@""]||[validDate isEqualToString:@""]) {
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"Mustfillin",@"MyString", @"")];
    }else{
    [_registerModel startRequestUserDriverLicenseWithArguments:[NSArray arrayWithObjects:useID,licenseNo,docNo,userName,licensePlace,permissionDriveType,points,initialDate,validDate,certificationDate, nil]];
    _registerModel.registerDelegate=self;
    }
    
}

- (void)viewDidUnload {
    [self setSkipBtn:nil];
    [self setNextBtn:nil];
    [self setUserIDTextField:nil];
    [self setLicenseNoTextField:nil];
    [self setDocNoTextField:nil];
    [self setLicensePlaceTextField:nil];
    [self setPermissionDriveTypeTextField:nil];
    [self setPointsTextField:nil];
    [self setInitialDateTextField:nil];
    [self setValidDateTextField:nil];
    [self setCertificationDateTextField:nil];
    [super viewDidUnload];
}
- (IBAction)dateButtonAction:(id)sender {
//    [_datePicker setHidden:NO];
}


-(void)handleUserDriverLicense:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        UIAlertView* alert=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"promptKey",@"MyString", @"") message:NSLocalizedStringFromTable(@"SuccessfulRegistration",@"MyString", @"") delegate:nil cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"") otherButtonTitles:nil];
        [alert show];
        [(ADMainWindow*)self.view.window transitionToLoginViewController];
    }else{
        NSLog(@"注册消息完善失败");
    }
}
@end
