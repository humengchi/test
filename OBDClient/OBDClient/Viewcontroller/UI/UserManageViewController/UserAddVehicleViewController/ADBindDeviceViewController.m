//
//  ADBindDeviceViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-7.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBindDeviceViewController.h"
#import "ADActiveDeviceViewController.h"
#import "ADiPhoneUserManageViewController.h"
#import "ADBindInfoViewController.h"

@interface ADBindDeviceViewController ()

@end

@implementation ADBindDeviceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(bindDeviceSuccess:)
                           name:ADVehiclesModelBindDeviceSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(bindDeviceError:)
                           name:ADVehiclesModelBindDeviceErrorNotification
                         object:nil];
    }
    return self;
}

-(void)dealloc{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelBindDeviceSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelBindDeviceErrorNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)bindDeviceError:(NSNotification *)aNoti{
    NSString * code = [[aNoti userInfo] objectForKey:@"resultCode"];
    if([code isEqualToString:@"1001"]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"SystemerrorKey",@"MyString", @"")];
    }else if([code isEqualToString:@"1011"]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"ThisdevicedoesnotexistKey",@"MyString", @"")];
    }else if ([code isEqualToString:@"1017"]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"ThisdevicehasbeenothervehiclesboundKey",@"MyString", @"")];
    }
}

- (void)bindDeviceSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
//    if([_fromPage isEqualToString:@"bindInfo"]){
//        
//        ADBindInfoViewController *bindInfoViewControllor=[self.navigationController.viewControllers objectAtIndex:1];
//        bindInfoViewControllor.beSavedESN = self.esnTextField.text;
//        [self.navigationController popToViewController:bindInfoViewControllor animated:YES];
//    }
//    else if ([_fromPage isEqualToString:@"userManager"]){
//        ADiPhoneUserManageViewController *userView = [self.navigationController.viewControllers objectAtIndex:0];
//        userView.isRefresh = YES;
//        [self.navigationController popToViewController:userView animated:YES];
//    }
//    else{
        ADActiveDeviceViewController *activeView = [[ADActiveDeviceViewController alloc]initWithNibName:nil bundle:nil];
        activeView.willActiveVin = self.beSavedVin;
        activeView.fromPage=_fromPage;
        [self.navigationController pushViewController:activeView animated:YES];
//    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"BindingequipmentKey",@"MyString", @"");
    if(![_fromPage isEqualToString:@"bindInfo"]){
        self.navigationItem.hidesBackButton=YES;
        UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"SkipKey",@"MyString", @"") style:UIBarButtonItemStyleDone target:self action:@selector(canceTap:)];
        self.navigationItem.rightBarButtonItem=barButton;
        if (IOS7_OR_LATER) {
            barButton.tintColor=[UIColor lightGrayColor];
        }
    }
    
    [_ensureBtn setTitle:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @"") forState:UIControlStateNormal];
    
    if (IOS7_OR_LATER) {
        CGRect frame=_esnLabel.frame;
        frame.origin.y+=64;
        [_esnLabel setFrame:frame];
        
        frame=_esnTextField.frame;
        frame.origin.y+=64;
        [_esnTextField setFrame:frame];
        
        frame=_keyLabel.frame;
        frame.origin.y+=64;
        [_keyLabel setFrame:frame];
        
        frame=_keyTextField.frame;
        frame.origin.y+=64;
        [_keyTextField setFrame:frame];
        
        frame=_ensureBtn.frame;
        frame.origin.y+=64;
        [_ensureBtn setFrame:frame];
        
        

    }
}

- (void)tableViewSelectedHandleInSubClasses:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
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

- (IBAction)canceTap:(id)sender
{
    if([_fromPage isEqualToString:@"userManager"]){
        [self navigateToViewControllerByClassName:@"CarAssistantViewController"];
        [ADSingletonUtil sharedInstance].selectMenuIndex=0;
    }else{
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setEsnTextField:nil];
    [self setKeyTextField:nil];
    [self setEnsureBtn:nil];
    [super viewDidUnload];
}
- (IBAction)submitTap:(id)sender {
    if([self.esnTextField.text isEqualToString:@""]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"PleaseinputdeviceESN",@"MyString", @"")];
    }else if ([self.keyTextField.text isEqualToString:@""]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"PleaseinputdeviceKey",@"MyString", @"")];
    }else{
        [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")];
        [_vehiclesModel bindDeviceWithArguments:[NSArray arrayWithObjects:self.beSavedVin,self.esnTextField.text,self.keyTextField.text,0, nil]];
    }
    
}
@end
