//
//  ADVehicleGateWayConfigEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-11.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleGateWayConfigEditViewController.h"

@interface ADVehicleGateWayConfigEditViewController ()<UITextFieldDelegate>

@end

@implementation ADVehicleGateWayConfigEditViewController

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
    self.title=@"编辑";
    self.navigationItem.leftBarButtonItem=nil;
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(editTap:)];
    self.navigationItem.rightBarButtonItem = menuItem;
    if (IOS7_OR_LATER) {
        menuItem.tintColor=[UIColor lightGrayColor];
    }
    self.ftp_id_textField.delegate=self;
    self.ftp_ipaddr_textField.delegate = self;
    self.ftp_pass_textField.delegate = self;
    self.ftp_port_textField.delegate = self;
    self.sms_addr_textField.delegate = self;
    self.svr_port_textField.delegate = self;
    self.svr_url_textField.delegate = self;
    
    //注册键盘响应事件方法
    [self.ftp_id_textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.ftp_ipaddr_textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.ftp_pass_textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.ftp_port_textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.sms_addr_textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.svr_port_textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.svr_url_textField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillAppear:(BOOL)animated{
    self.ftp_id_textField.text=[_vehicleGateWayConfig objectForKey:@"ftp_id"];
    self.ftp_ipaddr_textField.text=[_vehicleGateWayConfig objectForKey:@"ftp_ipaddr"];
    self.ftp_pass_textField.text=[_vehicleGateWayConfig objectForKey:@"ftp_pass"];
    self.ftp_port_textField.text=[_vehicleGateWayConfig objectForKey:@"ftp_port"];
    self.sms_addr_textField.text=[_vehicleGateWayConfig objectForKey:@"sms_addr"];
    self.svr_port_textField.text=[_vehicleGateWayConfig objectForKey:@"svr_port"];
    self.svr_url_textField.text=[_vehicleGateWayConfig objectForKey:@"svr_url"];
}

- (IBAction)editTap:(id)sender{
    NSArray *dataArray=[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,self.svr_url_textField.text,self.svr_port_textField.text,self.ftp_ipaddr_textField.text,self.ftp_port_textField.text,self.ftp_id_textField.text,self.ftp_pass_textField.text,self.sms_addr_textField.text,nil];
    
    [self.delegate editContactViewController:self didEditContact:dataArray];
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    float Y = 0.0f;
    if (textField.tag>2) {
        Y=-80;
    }
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//点击键盘上的按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender == self.ftp_id_textField){
        [self.ftp_ipaddr_textField becomeFirstResponder];
    }else if (sender == self.ftp_ipaddr_textField) {
        [self.ftp_pass_textField becomeFirstResponder];
    }else if (sender == self.ftp_pass_textField){
        [self.ftp_port_textField becomeFirstResponder];
    }else if (sender == self.ftp_port_textField){
        [self.sms_addr_textField becomeFirstResponder];
    }else if (sender == self.sms_addr_textField){
        [self.svr_port_textField becomeFirstResponder];
    }else if (sender == self.svr_port_textField){
        [self.svr_url_textField becomeFirstResponder];
    }else if (sender == self.svr_url_textField){
        [self hidenKeyboard];
    }
    
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self resumeView];
    [self.view endEditing:YES];
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
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setFtp_id_textField:nil];
    [self setFtp_ipaddr_textField:nil];
    [self setFtp_pass_textField:nil];
    [self setFtp_port_textField:nil];
    [self setSms_addr_textField:nil];
    [self setSvr_url_textField:nil];
    [self setSvr_port_textField:nil];
    [super viewDidUnload];
}
@end
