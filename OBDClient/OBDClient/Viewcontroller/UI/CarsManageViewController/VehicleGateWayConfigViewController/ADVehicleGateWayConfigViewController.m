//
//  ADVehicleGateWayConfigViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-11.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleGateWayConfigViewController.h"
#import "ADVehiclesModel.h"
#import "ADVehicleGateWayConfigEditViewController.h"

@interface ADVehicleGateWayConfigViewController ()<ADEditVehicleGateWayDelegate>
@property (nonatomic) ADVehiclesModel *vehiclesModel;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataItems;
@end

@implementation ADVehicleGateWayConfigViewController 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                    forKeyPath:KVO_VEHICLE_GATEWAY_CONFIG_PATH_NAME
                       options:NSKeyValueObservingOptionNew
                       context:nil];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(setVehicleGateWayConfigSuccess:)
                           name:ADVehiclesModelSetVehicleGateWaySuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(getVehicleGateWayConfigResult:)
                           name:ADVehiclesModelGetGatewayConfigResultNotification
                         object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADVehiclesModelLoginTimeOutNotification
                                                   object:nil];

    }
    return self;
}

-(void)dealloc{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelSetVehicleGateWaySuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelGetGatewayConfigResultNotification
                        object:nil];
    [_vehiclesModel removeObserver:self forKeyPath:KVO_VEHICLE_GATEWAY_CONFIG_PATH_NAME];
    [_vehiclesModel cancel];
}

- (void)viewWillAppear:(BOOL)animated{
    self.title=NSLocalizedStringFromTable(@"GatewayconfigurationKey",@"MyString", @"");
    self.navigationItem.leftBarButtonItem=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataItems = @[@"ftp_id",@"ftp_ipaddr",@"ftp_pass",@"ftp_port",@"sms_addr",@"svr_port",@"svr_url"];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
//    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTap:)];
    
    UIBarButtonItem *menuItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTap:)];
    self.navigationItem.rightBarButtonItem = menuItem;
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_vehiclesModel requestVehicleGeteWayConfigWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
}

- (IBAction)editTap:(id)sender{
    ADVehicleGateWayConfigEditViewController *editView=[[ADVehicleGateWayConfigEditViewController alloc]initWithNibName:nil bundle:nil];
    editView.delegate=self;
    editView.vehicleGateWayConfig=_vehiclesModel.vehicleGateWayConfig;
    [self.navigationController pushViewController:editView animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setVehicleGateWayConfigSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [_vehiclesModel requestVehicleGeteWayConfigWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
}

- (void)getVehicleGateWayConfigResult:(NSNotification *)aNoti{
    NSString *code=[aNoti.userInfo objectForKey:@"resultCode"];
    if ([code isEqualToString:@"200"]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    }else{
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"nodataKey",@"MyString", @"")];
    }
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
    NSDictionary *vehicleGateWayConfig=_vehiclesModel.vehicleGateWayConfig;
    cell.textLabel.text = _dataItems[indexPath.row];
    cell.detailTextLabel.text = [vehicleGateWayConfig objectForKey:_dataItems[indexPath.row]];
    NSString *applyString=[NSString stringWithFormat:@"%@_apply",_dataItems[indexPath.row]];
    if ([[vehicleGateWayConfig objectForKey:applyString] isEqualToString:@"1"]) {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    cell.backgroundColor=[UIColor whiteColor];
    
    
    
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_GATEWAY_CONFIG_PATH_NAME]) {
            [_tableView reloadData];
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) editContactViewController:(ADVehicleGateWayConfigEditViewController *) vehicleGateWayConfigEditViewController didEditContact:(NSArray * ) contact{
    [IVToastHUD showAsToastWithStatus:@"正在加载..."];
    [_vehiclesModel setVehicleGateWayConfigWithArguments:contact];
}

- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

@end
