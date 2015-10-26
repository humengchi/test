//
//  RegisterViewController.m
//  OBDClient
//
//  Created by hys on 25/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _UserRegisterModel=[[ADUserRegisterModel alloc]init];

    }
    return self;
}

- (void)dealloc{
    [_UserRegisterModel cancel];
}



- (void)viewDidLoad
{
#ifdef REGISTER_XMPP
    [self xmppLogin];
#endif
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    UIImageView* titleImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    titleImgView.image=[UIImage imageNamed:@"app_topbar_bg~iphone.png"];
    [titleView addSubview:titleImgView];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 7, WIDTH-120, 30)];
    titleLabel.text=NSLocalizedStringFromTable(@"registerNewUserKey",@"MyString", @"");
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleLabel.textColor=[UIColor whiteColor];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];

    UIButton* registerBackButton=[[UIButton alloc]initWithFrame:CGRectMake(8, 9, 50, 30)];
    [registerBackButton addTarget:self action:@selector(registerBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [registerBackButton setTitle:NSLocalizedStringFromTable(@"back",@"MyString", @"") forState:UIControlStateNormal];
    [registerBackButton setBackgroundImage:[UIImage imageNamed:@"nav_back_nor.png"] forState:UIControlStateNormal];
    [registerBackButton setBackgroundImage:[UIImage imageNamed:@"nav_back_act.png"] forState:UIControlStateHighlighted];
    [registerBackButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [registerBackButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 2, 0)];
    registerBackButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [registerBackButton setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:registerBackButton];
    [self.view addSubview:titleView];

    self.UserNameTextField.delegate=self;
    self.PassWordRepeatTextField.delegate=self;
    self.PassWordTextField.delegate=self;
    self.MailTextField.delegate=self;
    self.PhoneTextField.delegate = self;
    
    [self.UserNameTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.PassWordRepeatTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.PassWordTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.MailTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.PhoneTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];

    _UserNameTextField.placeholder=NSLocalizedStringFromTable(@"userNameKey",@"MyString", @"");
    
    _PassWordTextField.placeholder=NSLocalizedStringFromTable(@"passwordKey",@"MyString", @"");
    _PassWordRepeatTextField.placeholder=NSLocalizedStringFromTable(@"passwordRepeatKey",@"MyString", @"");
    
    _MailTextField.placeholder=NSLocalizedStringFromTable(@"mailKey",@"MyString", @"");
    
    [_submitBtn setTitle:NSLocalizedStringFromTable(@"submitRegisterKey",@"MyString", @"") forState:UIControlStateNormal];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [titleView setFrame:CGRectMake(0, 20, WIDTH, 44)];
        CGRect frame=_UserNameTextField.frame;
        frame.origin.y+=20;
        [_UserNameTextField setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=20;
        [_ImgViewOne setFrame:frame];
        
        frame=_ImgViewOneIcon.frame;
        frame.origin.y+=20;
        [_ImgViewOneIcon setFrame:frame];
        
        frame=_PassWordTextField.frame;
        frame.origin.y+=20;
        [_PassWordTextField setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=20;
        [_ImgViewTwo setFrame:frame];
        
        frame=_ImgViewTwoIcon.frame;
        frame.origin.y+=20;
        [_ImgViewTwoIcon setFrame:frame];
        
        frame=_PassWordRepeatTextField.frame;
        frame.origin.y+=20;
        [_PassWordRepeatTextField setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=20;
        [_ImgViewThree setFrame:frame];
        
        frame=_ImgViewThreeIcon.frame;
        frame.origin.y+=20;
        [_ImgViewThreeIcon setFrame:frame];
        
        frame=_MailTextField.frame;
        frame.origin.y+=20;
        [_MailTextField setFrame:frame];
        
        frame=_ImgViewFour.frame;
        frame.origin.y+=20;
        [_ImgViewFour setFrame:frame];
        
        frame=_ImgViewFourIcon.frame;
        frame.origin.y+=20;
        [_ImgViewFourIcon setFrame:frame];
        
        frame=_submitBtn.frame;
        frame.origin.y+=20;
        [_submitBtn setFrame:frame];
        
        frame=_ImgViewArrow.frame;
        frame.origin.y+=20;
        [_ImgViewArrow setFrame:frame];
        
        frame = _PhoneTextField.frame;
        frame.origin.y+=20;
        [_PhoneTextField setFrame:frame];
        
        frame = _ImgViewFive.frame;
        frame.origin.y+=20;
        [_ImgViewFive setFrame:frame];
        
        frame = _ImgViewFiveIcon.frame;
        frame.origin.y+=20;
        [_ImgViewFiveIcon setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_submitBtn.frame;
        frame.origin.y+=88;
        frame.size.height=5;
        [_submitBtn setFrame:frame];
        
        frame=_ImgViewArrow.frame;
        frame.origin.y+=88;
        [_ImgViewArrow setFrame:frame];
    }
    
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [titleView setFrame:CGRectMake(0, 20, WIDTH, 44)];
        CGRect frame=_UserNameTextField.frame;
        frame.origin.y+=20;
        [_UserNameTextField setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=20;
        [_ImgViewOne setFrame:frame];
        
        frame=_ImgViewOneIcon.frame;
        frame.origin.y+=20;
        [_ImgViewOneIcon setFrame:frame];
        
        frame=_PassWordTextField.frame;
        frame.origin.y+=20;
        [_PassWordTextField setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=20;
        [_ImgViewTwo setFrame:frame];
        
        frame=_ImgViewTwoIcon.frame;
        frame.origin.y+=20;
        [_ImgViewTwoIcon setFrame:frame];
        
        frame=_PassWordRepeatTextField.frame;
        frame.origin.y+=20;
        [_PassWordRepeatTextField setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=20;
        [_ImgViewThree setFrame:frame];
        
        frame=_ImgViewThreeIcon.frame;
        frame.origin.y+=20;
        [_ImgViewThreeIcon setFrame:frame];
        
        frame=_MailTextField.frame;
        frame.origin.y+=20;
        [_MailTextField setFrame:frame];
        
        frame=_ImgViewFour.frame;
        frame.origin.y+=20;
        [_ImgViewFour setFrame:frame];
        
        frame=_ImgViewFourIcon.frame;
        frame.origin.y+=20;
        [_ImgViewFourIcon setFrame:frame];
        
        frame=_submitBtn.frame;
        frame.origin.y+=108;
        frame.size.height=5;
        [_submitBtn setFrame:frame];
        
        frame=_ImgViewArrow.frame;
        frame.origin.y+=108;
        [_ImgViewArrow setFrame:frame];
        
        frame = _PhoneTextField.frame;
        frame.origin.y+=20;
        [_PhoneTextField setFrame:frame];
        
        frame = _ImgViewFive.frame;
        frame.origin.y+=20;
        [_ImgViewFive setFrame:frame];
        
        frame = _ImgViewFiveIcon.frame;
        frame.origin.y+=20;
        [_ImgViewFiveIcon setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}



}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    float Y = -70.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
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

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender == self.UserNameTextField){
        [self.PassWordTextField becomeFirstResponder];
    }else if (sender == self.PassWordTextField) {
        [self.PassWordRepeatTextField becomeFirstResponder];
    }else if (sender == self.PassWordRepeatTextField){
        [self.MailTextField becomeFirstResponder];
    }else if (sender == self.MailTextField){
        [self.PhoneTextField becomeFirstResponder];
//        [self resumeView];
    }else if (sender == self.PhoneTextField){
        [self.PhoneTextField resignFirstResponder];
        [self resumeView];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self resumeView];
}

- (IBAction)agreeProtocolButton:(id)sender
{
    ADProtocolViewController *proVC = [[ADProtocolViewController alloc] init];
    [self presentModalViewController:proVC animated:YES];
//    [self.navigationController pushViewController:proVC animated:YES];
}

#pragma mark - Button Action
- (void)registerBackButton:(id)sender{
    [(ADMainWindow *)self.view.window transitionToLoginViewController];
}

// 正则判断手机号码地址格式
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (IBAction)submitButton:(id)sender {
    NSString* userName=_UserNameTextField.text;
    NSString* pwd=_PassWordTextField.text;
    NSString* pwd1=_PassWordRepeatTextField.text;
    NSString* company=@"1";
    NSString* mail=_MailTextField.text;
    NSString* smsnum=_PhoneTextField.text;
    NSString* userPhoto=@"";
    if([userName isEqualToString: @""]||[pwd isEqualToString: @""]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"用户名和密码不能为空"];
    }else if ([userName length]<3||[userName length]>15){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"用户名长度必须大于3小于15"];
    }
    else if ([pwd length]<6||[pwd length]>20){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"密码长度必须大于6小于20"];
    }
    else if (![pwd isEqualToString:pwd1]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"请输入相同的密码"];
    }
    else if (![[ADSingletonUtil sharedInstance] isRulesString:pwd]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"密码不能包含非法字符"];
    }else if(![self isMobileNumber:smsnum]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"手机格式输入不正确"];
    }else{
        [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
        [_UserRegisterModel startRequestUserWithArguments:[NSArray arrayWithObjects:userName,pwd,mail,smsnum,company,userPhoto, nil]];
        _UserRegisterModel.registerDelegate=self;
        
#ifdef REGISTER_XMPP
        [self xmppRegister];
#endif
    }
    
    
}


#pragma mark - Request handle
-(void)handleUser:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"200"]) {
        PerfectInformationViewController* perfectViewController=[[PerfectInformationViewController alloc]initWithNibName:@"PerfectInformationViewController" bundle:nil];
        perfectViewController.userID=[dictionary objectForKey:@"data"];
        [(ADMainWindow*)self.view.window setRootViewController:perfectViewController animated:YES];

        [IVToastHUD showSuccessWithStatus:@"注册成功"];
    
    }else if ([resultCode isEqualToString:@"1001"]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"系统错误"];
    }else if ([resultCode isEqualToString:@"1002"]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"用户已经存在"];
    }
    
}

//- (void)requestSuccess:(NSNotification *)aNoti
//{
//    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:@""];

//    PerfectInformationViewController* perfectViewController=[[PerfectInformationViewController alloc]initWithNibName:@"PerfectInformationViewController" bundle:nil];
//    [(ADMainWindow*)self.view.window setRootViewController:perfectViewController animated:NO];
//    [(ADMainWindow *)self.view.window transitionToLoginViewController];
//}

//- (void)requestFail:(NSNotification *)aNoti
//{
//    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"注册失败"];
//}
//
//- (void)requestTimeout:(NSNotification *)aNoti
//{
//    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:@"网络超时"];
//}
//
//- (void)requestDataError:(NSNotification *)aNoti
//{
//    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"用户已存在"];
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUserNameTextField:nil];
    [self setPassWordTextField:nil];
    [self setPassWordRepeatTextField:nil];
    [self setMailTextField:nil];
    [self setSubmitBtn:nil];
    [super viewDidUnload];
}

#pragma mark -ADAppDelegate menthod
//取得当前程序的委托
-(ADAppDelegate *)appDelegate{
    return (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}

#pragma mark -registerXMPP
- (void)xmppRegister
{
    NSString *jid = [[NSString alloc] initWithFormat:@"%@@%@", _UserNameTextField.text, @"pc163.anydata.sh"];
    [[self xmppStream] setMyJID:[XMPPJID jidWithString:jid]];
    NSError *error=nil;
    if (![[self xmppStream] registerWithPassword:_PassWordTextField.text error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"创建帐号失败"
                                                            message:[error localizedDescription]
                                                           delegate:nil 
                                                  cancelButtonTitle:@"Ok" 
                                                  otherButtonTitles:nil];
        [alertView show];
    }
}

- (void)xmppLogin
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"anonymous" forKey:USERID];
    [defaults setObject:nil forKey:PASS];
    [defaults synchronize];
    
    [[self appDelegate] connect];
}

@end
