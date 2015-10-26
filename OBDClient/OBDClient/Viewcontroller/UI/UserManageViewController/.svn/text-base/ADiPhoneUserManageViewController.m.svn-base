//
//  ADiPhoneUserManageViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-25.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADiPhoneUserManageViewController.h"
@interface ADiPhoneUserManageViewController ()
@property (nonatomic) UILabel *labelOfHeader;
@end

@implementation ADiPhoneUserManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    if(_isRefresh){
        [self reloadTap:nil];
    }
    if([ADSingletonUtil sharedInstance].userInfo!=nil){
//        super.labelOfHeader.text=[NSString stringWithFormat:@"%@ \n%@",[[ADSingletonUtil sharedInstance].userInfo objectForKey:@"fullname"],NSLocalizedStringFromTable(@"WelcometouseKey",@"MyString", @"")];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_toolBar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    

//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 5, 42, 32);
//    [button setBackgroundColor:[UIColor clearColor]];
//    
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)setRefresh{
    _isRefresh = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)mapViewTap:(id)sender {
//    ADUsersMapViewController *usersMapView=[[ADUsersMapViewController alloc]init];
//    [self.navigationController pushViewController:usersMapView animated:YES];
    ADUsersMapViewController *viewController = [[ADUsersMapViewController alloc] init];
    viewController.modelFlag=0;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)addVehicleTap:(id)sender {
    _isRefresh = YES;
    UIViewController *viewController = [[NSClassFromString(@"ADUserAddVehicleViewController") alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)reloadTap:(id)sender {
    _isRefresh = NO;
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    NSString *userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [self.devicesModel requestAllDevicesWithArguments:[NSArray arrayWithObjects:userID, nil]];
}
- (void)viewDidUnload {
    [self setToolBar:nil];
    [self setMapViewItem:nil];
    [self setAddViewItem:nil];
    [self setReloadViewItem:nil];
    [super viewDidUnload];
}
@end
