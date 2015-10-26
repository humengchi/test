//
//  ADVehicleLicenseInfoViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleLicenseInfoViewController.h"
#import "ADVehicleLicenseEditViewController.h"

@interface ADVehicleLicenseInfoViewController ()<ADEditVehicleInfoDelegate>
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) UITableView *tableView;
@end
@implementation ADVehicleLicenseInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel=[[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                        forKeyPath:KVO_VEHICLE_INFO_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(requestVehicleInfoSuccess:)
                           name:ADVehiclesModelRequestVehicleInfoSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestVehicleInfoFail:)
                           name:ADVehiclesModelRequestVehicleInfoFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestVehicleInfoTimeout:)
                           name:ADVehiclesModelRequestVehicleInfoTimeoutNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(setVehicleInfoSuccess:)
                           name:ADVehiclesModelSetVehicleInfoSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(setVehicleInfoFail:)
                           name:ADVehiclesModelSetVehicleInfoFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(setVehicleInfoTimeout:)
                           name:ADVehiclesModelSetVehicleInfoTimeoutNotification
                         object:nil];
    }
    return self;
}

-(void)dealloc{
    [_vehiclesModel removeObserver:self
                       forKeyPath:KVO_VEHICLE_INFO_PATH_NAME];

    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelRequestVehicleInfoSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelRequestVehicleInfoFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelRequestVehicleInfoTimeoutNotification
                        object:nil];
    
    [notiCenter removeObserver:self
                       name:ADVehiclesModelSetVehicleInfoSuccessNotification
                     object:nil];
    [notiCenter removeObserver:self
                       name:ADVehiclesModelSetVehicleInfoFailNotification
                     object:nil];
    [notiCenter removeObserver:self
                       name:ADVehiclesModelSetVehicleInfoTimeoutNotification
                     object:nil];
    
    [_vehiclesModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataItems=@[NSLocalizedStringFromTable(@"DrivinglicensenumberKey",@"MyString", @""),NSLocalizedStringFromTable(@"carownernameKey",@"MyString", @""),NSLocalizedStringFromTable(@"enginenumberKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"latestannualinspectiontimeKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"RegistrationTypeofvehicleKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"RegistrationlocationKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"RegistrationdateKey",@"MyString", @"")];
    self.title=NSLocalizedStringFromTable(@"DrivinglicenseinformationKey",@"MyString", @"");
    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
		[self setExtraCellLineHidden:_tableView];
    }

    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];

    UIBarButtonItem *menuItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTap:)];
    menuItem.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    ADDeviceBase *device=[ADSingletonUtil sharedInstance].currentDeviceBase;
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    
    [_vehiclesModel requestVehicleInfoWithArguments:[NSArray arrayWithObject:device.d_vin]];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_INFO_PATH_NAME]) {
            [ADSingletonUtil sharedInstance].vehicleInfo = _vehiclesModel.vehicleInfo;
            
            [_tableView reloadData];
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (IBAction)editTap:(id)sender{
    ADVehicleLicenseEditViewController *editView=[[ADVehicleLicenseEditViewController alloc]initWithNibName:nil bundle:nil];
    editView.delegate=self;
    [self.navigationController pushViewController:editView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _dataItems.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _dataItems[indexPath.row];
    if(indexPath.row == 0){
        cell.detailTextLabel.text=_vehiclesModel.vehicleInfo.licenseNumber;
    }
    else if (indexPath.row==1) {
        cell.detailTextLabel.text=_vehiclesModel.vehicleInfo.ownerName;
    }else if (indexPath.row==2){
        cell.detailTextLabel.text=_vehiclesModel.vehicleInfo.ein;
    }else if (indexPath.row==3){
        cell.detailTextLabel.text=(NSString *)_vehiclesModel.vehicleInfo.inspectionDate;
    }else if (indexPath.row==4){
        cell.detailTextLabel.text=_vehiclesModel.vehicleInfo.licenseModel;
    }else if (indexPath.row==5){
        cell.detailTextLabel.text=_vehiclesModel.vehicleInfo.licensePlace;
    }else if (indexPath.row==6){
        cell.detailTextLabel.text=(NSString *)_vehiclesModel.vehicleInfo.licenseDate;
    }
    
    cell.backgroundColor=[UIColor whiteColor];
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

- (void)requestVehicleInfoSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)requestVehicleInfoFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"networkAnomalyKey",@"MyString", @"")];
}

- (void)requestVehicleInfoTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)setVehicleInfoSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    ADDeviceBase *device=[ADSingletonUtil sharedInstance].currentDeviceBase;
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];    
    [_vehiclesModel requestVehicleInfoWithArguments:[NSArray arrayWithObject:device.d_vin]];
}

- (void)setVehicleInfoFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"networkAnomalyKey",@"MyString", @"")];
}

- (void)setVehicleInfoTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}


- (void) editContactViewController:(ADVehicleLicenseEditViewController *) vehicleLicenseEditViewController didEditContact:(NSArray * ) contact{
    NSLog(@"%@",[contact objectAtIndex:0]);
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"ArepresentedKey",@"MyString", @"")];  
    [_vehiclesModel setVehicleInfoWithArguments:contact];
}


@end
