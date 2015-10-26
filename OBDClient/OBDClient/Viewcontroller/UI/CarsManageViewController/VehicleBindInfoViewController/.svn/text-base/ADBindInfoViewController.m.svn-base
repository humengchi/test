//
//  ADBindInfoViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-8.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBindInfoViewController.h"
#import "ADBindDeviceViewController.h"

@interface ADBindInfoViewController ()

@end

@implementation ADBindInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(unbindDeviceSuccess:)
                           name:ADVehiclesModelUnbindDeviceSuccessNotification
                         object:nil];
    }
    return self;
}

- (void)dealloc{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelUnbindDeviceSuccessNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"BindinginformationKey",@"MyString", @"");
    
    _lab1.text=NSLocalizedStringFromTable(@"currentblindKey",@"MyString", @"");
    
    _bindDeviceTextField.text=NSLocalizedStringFromTable(@"noequipmentKey",@"MyString", @"");
    
    
    [_unboundBtn setTitle:NSLocalizedStringFromTable(@"noboundKey",@"MyString", @"") forState:UIControlStateNormal];
    
    [_reboundBtn setTitle:NSLocalizedStringFromTable(@"ReboundKey",@"MyString", @"") forState:UIControlStateNormal];
    
    [_activateBtn setTitle:NSLocalizedStringFromTable(@"ActivationKey",@"MyString", @"") forState:UIControlStateNormal];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_lab1.frame;
        frame.origin.y+=64;
        [_lab1 setFrame:frame];
        
        frame=_bindDeviceTextField.frame;
        frame.origin.y+=64;
        [_bindDeviceTextField setFrame:frame];
        
        frame=_unboundBtn.frame;
        frame.origin.y+=64;
        [_unboundBtn setFrame:frame];
        
        frame=_reboundBtn.frame;
        frame.origin.y+=64;
        [_reboundBtn setFrame:frame];
        
        frame=_activateBtn.frame;
        frame.origin.y+=64;
        [_activateBtn setFrame:frame];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_unboundBtn.frame;
        frame.origin.y+=88;
        [_unboundBtn setFrame:frame];
        
        frame=_reboundBtn.frame;
        frame.origin.y+=88;
        [_reboundBtn setFrame:frame];
        
        frame=_activateBtn.frame;
        frame.origin.y+=88;
        [_activateBtn setFrame:frame];


    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_lab1.frame;
        frame.origin.y+=64;
        [_lab1 setFrame:frame];
        
        frame=_bindDeviceTextField.frame;
        frame.origin.y+=64;
        [_bindDeviceTextField setFrame:frame];
        
        frame=_unboundBtn.frame;
        frame.origin.y+=152;
        [_unboundBtn setFrame:frame];
        
        frame=_reboundBtn.frame;
        frame.origin.y+=152;
        [_reboundBtn setFrame:frame];
        
        frame=_activateBtn.frame;
        frame.origin.y+=152;
        [_activateBtn setFrame:frame];
	}

    
}

- (void)viewWillAppear:(BOOL)animated{
    if(_beSavedESN!=nil){
        self.bindDeviceTextField.text=_beSavedESN;
    }else if(![[ADSingletonUtil sharedInstance].currentDeviceBase.d_esn isEqualToString:@""]){
        self.bindDeviceTextField.text = [ADSingletonUtil sharedInstance].currentDeviceBase.d_esn;
    }else{
        _unboundBtn.hidden=YES;
        [_reboundBtn setTitle:NSLocalizedStringFromTable(@"绑定设备",@"MyString", @"") forState:UIControlStateNormal];
    }
}

- (void)unbindDeviceSuccess:(NSNotification *)aNoti{
//    self.bindDeviceTextField.text = NSLocalizedStringFromTable(@"NobindingequipmentKey",@"MyString", @"");
//    
//    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"SolutiontosuccessKey",@"MyString", @"")];
//    [IVToastHUD showAsToastSuccessWithStatus:@"车辆解绑成功，请重新选择车辆"];
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:NSLocalizedStringFromTable(@"promptKey",@"MyString", @"") message:@"车辆解绑成功，请重新选择车辆" delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"") otherButtonTitles: nil];
    [alertView show];
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

- (void)viewDidUnload {
    [self setBindDeviceTextField:nil];
    [self setLab1:nil];
    [self setUnboundBtn:nil];
    [self setReboundBtn:nil];
    [super viewDidUnload];
}
- (IBAction)unBindTap:(id)sender {
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")];
    [_vehiclesModel unBindDeviceWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].globalUserBase.userID,[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,[ADSingletonUtil sharedInstance].currentDeviceBase.d_esn,[ADSingletonUtil sharedInstance].currentDeviceBase.registerKey, nil]];
}

- (IBAction)reBindTap:(id)sender {
    ADBindDeviceViewController *bindView = [[ADBindDeviceViewController alloc]init];
    bindView.beSavedVin = [ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    bindView.fromPage = @"bindInfo";
    [self.navigationController pushViewController:bindView animated:YES];
}

- (IBAction)activateTap:(id)sender {
    ADActiveDeviceViewController *activeView = [[ADActiveDeviceViewController alloc]initWithNibName:nil bundle:nil];
    activeView.willActiveVin = [ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
//    activeView.fromPage=_fromPage;
    [self.navigationController pushViewController:activeView animated:YES];

}
@end
