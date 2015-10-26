//
//  ADVehicleSettingConfigViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-29.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleSettingConfigViewController.h"
#import "ADVehicleSettingConfigEditViewController.h"

@interface ADVehicleSettingConfigViewController ()<ADEditVehicleSettingConfigDelegate>
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) NSArray *data;
@property (nonatomic) NSArray *accelAndBreakData;
@property (nonatomic) NSArray *corneringData;
@property (nonatomic) NSArray *statusData;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADVehicleSettingConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel=[[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VEHICLE_SETTING_CONFIG_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(setVehicleSettingConfigSuccess:)
                           name:ADVehiclesModelSetVehicleSettingConfigSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(getVehicleSettingConfigResult:)
                           name:ADVehiclesModelGetSettingConfigResultNotification
                         object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADVehiclesModelLoginTimeOutNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc{
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VEHICLE_SETTING_CONFIG_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelSetVehicleSettingConfigSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelGetSettingConfigResultNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)setVehicleSettingConfigSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [_vehiclesModel requestVehicleSettingConfigWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil]];
}

- (void)getVehicleSettingConfigResult:(NSNotification *)aNoti{
    NSString *code=[aNoti.userInfo objectForKey:@"resultCode"];
    if ([code isEqualToString:@"200"]){
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
        self.dataItems=[NSArray arrayWithObjects:@"heartbeat_interval",@"heartbeat_type",@"idle",@"raw_data_include",@"speed",@"speed_duration",@"battery",@"fuel_level",@"fuel_level_change",@"rpm",@"rpm_duration",@"fast_heartbeat_cnt",@"coolant_temp",@"vehicle_break",@"accel",@"turn",@"slop_duration",@"slop_thresh",@"unauth_duration",@"unauth_thresh",@"highG",@"orient",@"hg_hyst",@"angle",nil];
        [_tableView reloadData];
    }else{
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"nodataKey",@"MyString", @"")];
        self.navigationItem.rightBarButtonItem=nil;
        _tableView.hidden=YES;
        self.dataItems=nil;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"RemotesetupKey",@"MyString", @"");;
    
//    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTap:)];
    UIBarButtonItem *menuItem =[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTap:)];
    menuItem.tintColor = [UIColor lightGrayColor];

    self.navigationItem.rightBarButtonItem = menuItem;
    
    
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

    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")];
    [_vehiclesModel requestVehicleSettingConfigWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil]];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)editTap:(id)sender{
    ADVehicleSettingConfigEditViewController *editView=[[ADVehicleSettingConfigEditViewController alloc]initWithNibName:nil bundle:nil];
    editView.delegate=self;
    editView.settingConfigItems=[NSArray arrayWithObjects:
                                 @"heartbeat_interval",
//                                 @"heartbeat_type",
                                 @"idle",
//                                 @"accel",
//                                 @"break",
//                                 @"turn",
//                                 @"slop_duration",
//                                 @"slop_thresh",
//                                 @"unauth_duration",
//                                 @"unauth_thresh",
//                                 @"highG",
//                                 @"orient",
//                                 @"hg_hyst",
//                                 @"angle",
//                                 @"unauth_delay",
//                                 @"raw_data_include",
                                 @"speed",
//                                 @"speed_duration",
//                                 @"battery",
//                                 @"fuel_level",
//                                 @"fuel_level_change",
                                 @"rpm",
//                                 @"rpm_duration",
//                                 @"fast_heartbeat_cnt",
//                                 @"coolant_temp",
//                                 @"fuel_limit",
                                 nil];
    ADVehicleSettingConfig *vehicleSettingConfig=_vehiclesModel.vehicleSettingConfig;
    editView.settingConfigItemsDefaultValues=[NSMutableArray arrayWithObjects:
                                              vehicleSettingConfig.heartbeat_interval,
                                              vehicleSettingConfig.heartbeat_type,
                                              vehicleSettingConfig.idle,
                                              vehicleSettingConfig.accel,
                                              @"",//break
                                              vehicleSettingConfig.turn,
                                              vehicleSettingConfig.slop_duration,
                                              vehicleSettingConfig.slop_thresh,
                                              vehicleSettingConfig.unauth_duration,
                                              vehicleSettingConfig.unauth_thresh,
                                              vehicleSettingConfig.highG,
                                              vehicleSettingConfig.orient,
                                              vehicleSettingConfig.hg_hyst,
                                              vehicleSettingConfig.angle,
                                              @"",//unauth_delay
                                              vehicleSettingConfig.raw_data_include,
                                              vehicleSettingConfig.speed,
                                              vehicleSettingConfig.speed_duration,
                                              vehicleSettingConfig.battery,
                                              vehicleSettingConfig.fuel_level,
                                              @"",//fuel_level_change
                                              vehicleSettingConfig.rpm,
                                              vehicleSettingConfig.rpm_duration,
                                              vehicleSettingConfig.fast_heartbeat_cnt,
                                              vehicleSettingConfig.coolant_temp,
                                              vehicleSettingConfig.fuel_limit,
                                              nil];
    [self.navigationController pushViewController:editView animated:YES];
}

#pragma mark - Table view data source
// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return @"常规";
    }else if (section==1){
        return @"急加速/急减速";
    }else if (section==2){
        return @"急转弯";
    }else{
        return @"其他";
    }
}

//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
//    return _dataItems.count;
    if(section==0){
        return _data.count;
    }else if (section==1){
        return _accelAndBreakData.count;
    }else if (section==2){
        return _corneringData.count;
    }else{
        return 0;
    }
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
    static NSString *cellIdentifier=@"ADVehicleRemoteSetupCell";
    ADVehicleRemoteSetupCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"ADVehicleRemoteSetupCell" owner:self options:nil];
        cell=(ADVehicleRemoteSetupCell*)[xib objectAtIndex:0];
        
    }

    if(indexPath.section==0){
//        cell.textLabel.text = _dataItems[indexPath.row];
        cell.textLabel.text =NSLocalizedStringFromTable(_dataItems[indexPath.row],@"MyString", @"");
        cell.statusLabel.text=_statusData[indexPath.row];
        if(_data[indexPath.row]!=[NSNull null]){
            cell.valueLabel.text=_data[indexPath.row];
        }else{
            cell.valueLabel.text=@"";
        }
        
    }else if (indexPath.section==1){
//        cell.textLabel.text = _dataItems[indexPath.row+12];
        cell.textLabel.text =NSLocalizedStringFromTable(_dataItems[indexPath.row+13],@"MyString", @"");
        cell.statusLabel.text=_statusData[indexPath.row+13];

        if(_accelAndBreakData[indexPath.row]!=[NSNull null]){
            cell.valueLabel.text=_accelAndBreakData[indexPath.row];
        }else{
            cell.valueLabel.text=@"";
        }
    }else if (indexPath.section==2){
//        cell.textLabel.text = _dataItems[indexPath.row+14];
        cell.textLabel.text =NSLocalizedStringFromTable(_dataItems[indexPath.row+16],@"MyString", @"");
        cell.statusLabel.text=_statusData[indexPath.row+16];

        if(_corneringData[indexPath.row]!=[NSNull null]){
            cell.valueLabel.text=_corneringData[indexPath.row];
        }else{
            cell.valueLabel.text=@"";
        }
    }
    
//    cell.textLabel.text = _dataItems[indexPath.row];
//    
//    if(_data[indexPath.row]!=[NSNull null]){
//         
//        cell.detailTextLabel.text=_data[indexPath.row];
//    }else{
//        cell.detailTextLabel.text=@"";
//    }
    
    cell.backgroundColor=[UIColor whiteColor];
//    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_SETTING_CONFIG_PATH_NAME]) {
            ADVehicleSettingConfig *vehicleSettingConfig=_vehiclesModel.vehicleSettingConfig;
            _statusData=[NSArray arrayWithObjects:
                         vehicleSettingConfig.heartbeat_interval_apply,
                         vehicleSettingConfig.heartbeat_type_apply,
                         vehicleSettingConfig.accele_break_apply,
                         vehicleSettingConfig.raw_data_apply,
                         vehicleSettingConfig.speed_apply,
                         vehicleSettingConfig.speed_duration_apply,
                         vehicleSettingConfig.battery_apply,
                         vehicleSettingConfig.fuel_level_apply,
                         vehicleSettingConfig.fuel_level_change_apply,
                         vehicleSettingConfig.rpm_apply,
                         vehicleSettingConfig.rpm_duration_apply,
                         vehicleSettingConfig.fast_heartbeat_cnt_apply,
                         vehicleSettingConfig.coolant_temp_apply,
                         vehicleSettingConfig.accele_break_apply,
                         vehicleSettingConfig.accele_break_apply,
                         vehicleSettingConfig.accele_break_apply,
                         vehicleSettingConfig.cornering_apply,
                         vehicleSettingConfig.cornering_apply,
                         vehicleSettingConfig.cornering_apply,
                         vehicleSettingConfig.cornering_apply,
                         vehicleSettingConfig.cornering_apply,
                         vehicleSettingConfig.cornering_apply,
                         vehicleSettingConfig.cornering_apply,
                         vehicleSettingConfig.cornering_apply, nil];
            
            _data=[NSArray arrayWithObjects:vehicleSettingConfig.heartbeat_interval,
                   vehicleSettingConfig.heartbeat_type,
                   vehicleSettingConfig.idle,
                   vehicleSettingConfig.raw_data_include,
                   vehicleSettingConfig.speed,
                   vehicleSettingConfig.speed_duration,
                   vehicleSettingConfig.battery,
                   vehicleSettingConfig.fuel_level,
                   vehicleSettingConfig.fuel_level_change,
                   vehicleSettingConfig.rpm,
                   vehicleSettingConfig.rpm_duration,
                   vehicleSettingConfig.fast_heartbeat_cnt,
                   vehicleSettingConfig.coolant_temp,
                   nil];
            _accelAndBreakData=[NSArray arrayWithObjects:
                                vehicleSettingConfig.vehicle_break,
                                vehicleSettingConfig.accel,
                                vehicleSettingConfig.turn,//break
                                nil];
            _corneringData = [NSArray arrayWithObjects:vehicleSettingConfig.slop_duration,
                              vehicleSettingConfig.slop_thresh,
                              vehicleSettingConfig.unauth_duration,
                              vehicleSettingConfig.unauth_thresh,
                              vehicleSettingConfig.highG,
                              vehicleSettingConfig.orient,
                              vehicleSettingConfig.hg_hyst,
                              vehicleSettingConfig.angle,//undelay
                              nil];

//            _data=[NSArray arrayWithObjects:vehicleSettingConfig.accel,vehicleSettingConfig.accele_break_apply,vehicleSettingConfig.angle,vehicleSettingConfig.battery,
//             vehicleSettingConfig.battery_apply,vehicleSettingConfig.coolant_temp,vehicleSettingConfig.coolant_temp_apply,vehicleSettingConfig.cornering_apply,vehicleSettingConfig.dle_apply,vehicleSettingConfig.fast_heartbeat_cnt,vehicleSettingConfig.fast_heartbeat_cnt_apply,vehicleSettingConfig.fuel_level,vehicleSettingConfig.fuel_level_apply,vehicleSettingConfig.fuel_level_change_apply,vehicleSettingConfig.fuel_limit,vehicleSettingConfig.fuel_trim_apply,vehicleSettingConfig.heartbeat_interval,vehicleSettingConfig.heartbeat_interval_apply,vehicleSettingConfig.heartbeat_type,vehicleSettingConfig.heartbeat_type_apply,vehicleSettingConfig.hg_hyst,vehicleSettingConfig.highG,vehicleSettingConfig.idle,vehicleSettingConfig.orient,vehicleSettingConfig.raw_data_apply,vehicleSettingConfig.raw_data_include,vehicleSettingConfig.rpm,vehicleSettingConfig.rpm_apply,vehicleSettingConfig.rpm_duration,vehicleSettingConfig.rpm_duration_apply,vehicleSettingConfig.slop_duration,vehicleSettingConfig.slop_thresh,vehicleSettingConfig.speed,vehicleSettingConfig.speed_apply,vehicleSettingConfig.speed_duration,vehicleSettingConfig.speed_duration_apply,vehicleSettingConfig.turn,vehicleSettingConfig.unauth_duration,vehicleSettingConfig.unauth_thresh,
//                   nil];
            [_tableView reloadData];
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) editContactViewController:(ADVehicleSettingConfigEditViewController *) vehicleSettingConfigEditViewController didEditContact:(NSArray * ) contact{
    NSLog(@"%@",contact);
    NSMutableArray *returnArray = [NSMutableArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID, nil];
    [returnArray addObjectsFromArray:contact];
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")]; 
    [_vehiclesModel setVehicleSettingConfigWithArguments:returnArray];
    
    
}
- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}


@end
