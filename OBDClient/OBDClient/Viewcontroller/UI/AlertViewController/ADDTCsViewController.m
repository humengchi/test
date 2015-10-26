//
//  ADDTCsViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-24.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDTCsViewController.h"
#import "ADDTCDetailViewController.h"
#import "ADReserveViewController.h"

@interface ADDTCsViewController ()

@end

@implementation ADDTCsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dtcsModel = [[ADDTCsModel alloc] init];
        
        [_dtcsModel addObserver:self
                     forKeyPath:KVO_DTCS_PATH_NAME
                        options:NSKeyValueObservingOptionNew
                        context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestDTCsSuccess:)
                                                     name:ADDTCsModelRequestSuccessNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestDTCsFail:)
                                                     name:ADDTCsModelRequestFailNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestDTCsTimeout:)
                                                     name:ADDTCsModelRequestTimeoutNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADDTCsModelLoginTimeOutNotification
                                                   object:nil];

    }
    return self;
}

- (void)dealloc
{
    [_dtcsModel removeObserver:self
                    forKeyPath:KVO_DTCS_PATH_NAME];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDTCsModelRequestSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDTCsModelRequestFailNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ADDTCsModelRequestTimeoutNotification object:nil];

    
    [_dtcsModel cancel];
}

- (void)requestDTCsSuccess:(id)sender
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)requestDTCsFail:(id)sender
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"networkAnomalyKey",@"MyString", @"")];
}

- (void)requestDTCsTimeout:(id)sender
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADAlertViewDidDisappear" object:nil];
}

- (void)appointmentTap:(id)sender
{
    ADReserveViewController* reserve=[[ADReserveViewController alloc]initWithNibName:@"ADReserveViewController" bundle:nil];;
    [self.navigationController pushViewController:reserve animated:NO];
}

- (void)maintenance:(id)sender
{
    [ADSingletonUtil sharedInstance].selectMenuIndex=5;
    [self navigateToViewControllerByClassName:@"ADHealthyViewController"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=@"保养";//NSLocalizedStringFromTable(@"DTCListKey",@"MyString", @"");
    self.navigationItem.leftBarButtonItem=nil;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIBarButtonItem *appointmentButton=[[UIBarButtonItem alloc]initWithTitle:@"预约" style:UIBarButtonItemStyleBordered target:self action:@selector(appointmentTap:)];
    
    UIBarButtonItem *maintenanceButton=[[UIBarButtonItem alloc]initWithTitle:@"保养提醒" style:UIBarButtonItemStyleBordered target:self action:@selector(maintenance:)];
    
    //    self.navigationItem.rightBarButtonItem=locationButton;
    if (IOS7_OR_LATER) {
        appointmentButton.tintColor=[UIColor lightGrayColor];
        maintenanceButton.tintColor = [UIColor lightGrayColor];
    }
    
    self.navigationItem.rightBarButtonItems = @[maintenanceButton, appointmentButton];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
        
	}

    [self requestDTCsWithDeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID];
    
}

- (void)requestDTCsWithDeviceID:(NSString *)aDeviceID
{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_dtcsModel requestDTCsWithArguments:[NSArray arrayWithObjects:aDeviceID, @"1", nil]];
}

- (void)updateDetailUI
{
    [self requestDTCsWithDeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _dtcsModel) {
        if ([keyPath isEqualToString:KVO_DTCS_PATH_NAME]) {
            if(_dtcsModel.dtcs.count==0){
                [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
            }else{
                [_tableView reloadData];
            }
            return;
        }
    }
    return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

//- (void)labelsTextWithDTCBase:(ADDTCBase *)aDTCBase
//{
//    ((UILabel *)[self.view viewWithTag:TAG_LABEL_TYPE]).text = [NSString stringWithFormat:@"dtc:%@", ];
//    ((UILabel *)[self.view viewWithTag:TAG_LABEL_DATE]).text = [NSString stringWithFormat:@"时间:%@", aHistoryPoint.serverDate];
//    ((UILabel *)[self.view viewWithTag:TAG_LABEL_PLACE]).text = [NSString stringWithFormat:@"数量:%@", aHistoryPoint.address_street];
//}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADDTCBase *dtcBase = [_dtcsModel.dtcs objectAtIndex:indexPath.row];
    if (dtcBase.Num_of_DTC!=0&&dtcBase.Num_of_DTC!=255) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:[[ADDTCDetailViewController alloc] initWithNibName:nil bundle:nil dtcBase:[_dtcsModel.dtcs objectAtIndex:indexPath.row]] animated:YES];
    }
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.5f];
    
}

- (void)deselect
{
    [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - UITableViewDataDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dtcsModel.dtcs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idStr = @"ADDTCsViewController.cell";
    ADDTCCell *cell = [_tableView dequeueReusableCellWithIdentifier:idStr];
    ADDTCBase *dtcBase = [_dtcsModel.dtcs objectAtIndex:indexPath.row];
//    if (!cell) {
        cell = [[ADDTCCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:idStr dtcBase:dtcBase];
//    }
    [cell updateUIByDTCBase:dtcBase];
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,50, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    if (dtcBase.Num_of_DTC!=0&&dtcBase.Num_of_DTC!=255) {
        UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
        [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
        cell.accessoryView=buttonRight;
    }
    
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    return cell;
}

- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

@end
