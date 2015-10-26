//
//  ADActiveDeviceViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-7.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADActiveDeviceViewController.h"

@interface ADActiveDeviceViewController ()

@end

@implementation ADActiveDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(activeDeviceSendSuccess:)
                           name:ADVehiclesModelActiveDeviceSendSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(activeDeviceSuccess:)
                           name:ADVehiclesModelActiveDeviceSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(activeDeviceFail:)
                           name:ADVehiclesModelActiveDeviceFailNotification
                         object:nil];
        
    }
    return self;
}

- (void)dealloc{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelActiveDeviceSendSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelActiveDeviceSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelActiveDeviceFailNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)activeDeviceSendSuccess:(NSNotification *)aNoti{
    self.activeStatusTextField.text=NSLocalizedStringFromTable(@"ActivatingpleaselaterKey",@"MyString", @"");
    [_vehiclesModel getActiveStatusIndeedWithArguments:[NSArray arrayWithObject:self.willActiveVin] continue:YES];
    
}

- (void)activeDeviceSuccess:(NSNotification *)aNoti{
    self.activeStatusTextField.text=NSLocalizedStringFromTable(@"ActivatesuccessKey",@"MyString", @"");
    self.navigationItem.rightBarButtonItem.title=NSLocalizedStringFromTable(@"completeKey",@"MyString", @"");
    self.activeButton.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [IVToastHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"ActivatesuccessKey",@"MyString", @"")];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)activeDeviceFail:(NSNotification *)aNoti{
    self.activeStatusTextField.text=NSLocalizedStringFromTable(@"ActivatefailedKey",@"MyString", @"");
    self.navigationItem.rightBarButtonItem.title=NSLocalizedStringFromTable(@"completeKey",@"MyString", @"");
    self.activeButton.enabled = YES;
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"ActivatedevideKey",@"MyString", @"");
    self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"SkipKey",@"MyString", @"") style:UIBarButtonItemStyleDone target:self action:@selector(canceTap:)];
    self.navigationItem.rightBarButtonItem=barButton;
    _lab1.text=NSLocalizedStringFromTable(@"remindKey",@"MyString", @"");
    
    _lab2.text=NSLocalizedStringFromTable(@"currentStateKey",@"MyString", @"");
    
//    _lab3.text=NSLocalizedStringFromTable(@"waitStateKey",@"MyString", @"");
    
    [_activeButton setTitle:NSLocalizedStringFromTable(@"ActivationKey",@"MyString", @"") forState:UIControlStateNormal];

    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_lab1.frame;
        frame.origin.y+=64;
        [_lab1 setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y-=14;
        [_lab2 setFrame:frame];
        
        frame=_activeStatusTextField.frame;
        frame.origin.y-=14;
        [_activeStatusTextField setFrame:frame];
        
        frame=_activeButton.frame;
        frame.origin.y-=14;
        [_activeButton setFrame:frame];
        
        barButton.tintColor=[UIColor lightGrayColor];
        
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_activeButton.frame;
        frame.origin.y+=88;
        [_activeButton setFrame:frame];

    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_lab1.frame;
        frame.origin.y+=64;
        [_lab1 setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y-=34;
        [_lab2 setFrame:frame];
        
        frame=_activeStatusTextField.frame;
        frame.origin.y-=34;
        [_activeStatusTextField setFrame:frame];
        
        frame=_activeButton.frame;
        frame.origin.y-=34;
        [_activeButton setFrame:frame];
        
        barButton.tintColor=[UIColor lightGrayColor];
	}

    
}

- (IBAction)canceTap:(id)sender
{
    
//    [self.navigationController popToRootViewControllerAnimated:YES];
    if([_fromPage isEqualToString:@"bindInfo"]){
//        [IVToastHUD showAsToastSuccessWithStatus:@"车辆绑定成功，请重新选择车辆"];
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"promptKey",@"MyString", @"") message:@"车辆绑定成功，请重新选择车辆" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"") otherButtonTitles: nil];
        [alertView show];
    }
    [self navigateToViewControllerByClassName:@"ADiPhoneUserManageViewController"];
    
}

- (void)navigateToViewControllerByClassName:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
    ADNavigationController *navigationController = [ADNavigationController navigationControllerWithRootViewController:viewController];
    CGRect frame = self.slidingController.topViewController.view.frame;
    self.slidingController.topViewController = navigationController;
    self.slidingController.topViewController.view.frame = frame;
    [self.slidingController resetTopView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)activeTap:(id)sender {
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString * na = [df stringFromDate:currentDate];
    [_vehiclesModel activeDeviceWithArguments:[NSArray arrayWithObjects:self.willActiveVin,na,nil]];
    self.activeStatusTextField.text=NSLocalizedStringFromTable(@"SendActivationcommandKey",@"MyString", @"");
    self.activeButton.enabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}
- (void)viewDidUnload {
    [self setActiveStatusTextField:nil];
    [self setActiveButton:nil];
    [self setLab1:nil];
    [self setLab2:nil];
//    [self setLab3:nil];
    [self setActivityBtn:nil];
    [super viewDidUnload];
}
@end