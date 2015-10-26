//
//  ADChattingLoginViewController.m
//  OBDClient
//
//  Created by hys on 13/8/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADChattingLoginViewController.h"
#import "IVToastHUD.h"
#import "ADSingletonUtil.h"

@interface ADChattingLoginViewController ()

@end

@implementation ADChattingLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    currentLogin = 0;
    self.title = @"车友登录";
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 212;
        [self.view addSubview:view];
	}
    
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 212;
        [self.view addSubview:view];
	}

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([userDefaults objectForKey:@"ChattingUsername"]){
        _username_TextField.text = [userDefaults objectForKey:@"ChattingUsername"];
        _password_TextField.text = [userDefaults objectForKey:@"ChattingPassword"];
        if([[userDefaults objectForKey:@"ChattingRemberPassword"] integerValue] == 1){
            [_remberPasswdBtn setBackgroundColor:[UIColor redColor]];
        }else{
            [_remberPasswdBtn setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeLgoinIsSuccess:) name:@"NoticeChattingLoginIsSuccess" object:nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NoticeChattingLoginIsSuccess"
                                                  object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NoticeChattingLoginIsSuccess"
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -NSNotificationLoginSuccess
//监听是否登录成功
- (void)noticeLgoinIsSuccess:(NSNotification*)notification
{
    NSString *string = [notification object];
    if([string isEqualToString:@"success"]){
        if(currentLogin == 1){
            [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:@""];
            ADUserFriendsViewController *userFriendVC = [[ADUserFriendsViewController alloc] init];
        [self.navigationController pushViewController:userFriendVC animated:YES];
        }
        [ADSingletonUtil sharedInstance].chattingIsLogin = YES;
    }else{
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"用户名或密码错误"];
        [ADSingletonUtil sharedInstance].chattingIsLogin = NO;
    }
}

#pragma mark -Methods
- (IBAction)loginButtonPressed:(id)sender
{
    [IVToastHUD showAsToastWithStatus:@"正在加载..."];
    if(_username_TextField.text.length == 0 || _password_TextField.text.length == 0){
        [IVToastHUD showAsToastErrorWithStatus:@"用户名和密码不能为空"];
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:_username_TextField.text forKey:@"ChattingUsername"];
    [userDefaults setObject:_password_TextField.text forKey:@"ChattingPassword"];
    [userDefaults setObject:@"192.168.0.163" forKey:@"server"];
    [userDefaults synchronize];
    
    currentLogin = 1;
    //用户委托连接登录
    ADAppDelegate *del = [self appDelegate];
    del.chatDelegate = self;
    [del connect];
}

- (IBAction)forgetPasswdButtonPressed:(id)sender
{
    
        
}

- (IBAction)remberPasswdButtonPressed:(id)sender
{
    if(_username_TextField.text.length == 0 || _password_TextField.text.length == 0){
        return;
    }
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if([[userDefaults objectForKey:@"ChattingRemberPassword"] length] == 0){
        [_remberPasswdBtn setBackgroundColor:[UIColor redColor]];
        [userDefaults setObject:@"1" forKey:@"ChattingRemberPassword"];
        [userDefaults synchronize];
        return;
    }
    if([[userDefaults objectForKey:@"ChattingRemberPassword"] integerValue] == 0){
        [_remberPasswdBtn setBackgroundColor:[UIColor redColor]];
        [userDefaults setObject:@"1" forKey:@"ChattingRemberPassword"];
    }else{
        [_remberPasswdBtn setBackgroundColor:[UIColor whiteColor]];
        [userDefaults setObject:@"0" forKey:@"ChattingRemberPassword"];
    }
    [userDefaults synchronize];
}

#pragma mark -UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, -30, WIDTH, self.view.frame.size.height);
    [[self.view viewWithTag:212] setFrame:CGRectMake(0, 70, WIDTH, 20)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[self.view viewWithTag:212] setFrame:CGRectMake(0, 0, WIDTH, 20)];
    self.view.frame = CGRectMake(0, 0, WIDTH, self.view.frame.size.height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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

@end
