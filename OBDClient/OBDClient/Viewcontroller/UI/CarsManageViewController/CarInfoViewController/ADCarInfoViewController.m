//
//  ADCarInfoViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADCarInfoViewController.h"
#import "ADVehicleModelTypeChangeViewController.h"
#import "ADVehicleBaseInfoEditViewController.h"

@interface ADCarInfoViewController ()<ADEditVehicleBaseInfoDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataItems;
@end

@implementation ADCarInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VEHICLE_INFO_MODELTYPE_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(setVehicleModelTypeSuccess:)
                           name:ADVehiclesModelSetVehicleModelTypeSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(updateVehicleBaseInfoSuccess:)
                           name:ADVehiclesModelUpdateBaseInfoSuccessNotification
                         object:nil];
    }
    return self;
}



- (void)dealloc{
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VEHICLE_INFO_MODELTYPE_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelSetVehicleModelTypeSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelUpdateBaseInfoSuccessNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIBarButtonItem *changeTypeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"ChangethetypeofvehicleKey",@"MyString", @"") style:UIBarButtonItemStylePlain target:self action:@selector(changeTypeTap:)];
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTap:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:editItem, nil];
    _beSavedModelNumID=@"";
    
    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
        [self setExtraCellLineHidden:_tableView];
        editItem.tintColor=[UIColor lightGrayColor];
    }
    
    
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _dataItems=@[NSLocalizedStringFromTable(@"vehicleNickname",@"MyString", @""),
                 NSLocalizedStringFromTable(@"framenumberKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"DrivinglicensenumberKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"totalMileageKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"BrandKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"TypeofvehicleKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"StylesKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"handfromafileKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"typeoffuelKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"mailboxsizeKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"gasdisplacement",@"MyString", @"")
                 ];
    [self.view addSubview:_tableView];
    
    [_vehiclesModel requestVehicleModelTypeWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
}

-(void)viewDidAppear:(BOOL)animated{
    if(![_beSavedModelNumID isEqual:@""]){
        [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
        [_vehiclesModel setVehicleModelTypeWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,_beSavedModelNumID, nil]];
    }
    
}

- (void) editContactViewController:(ADVehicleBaseInfoEditViewController *) editViewController didEditContact:(NSArray * ) contact{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_vehiclesModel updateBaseVehicleInfoWithArguments:contact];
}

- (void)updateVehicleBaseInfoSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [_vehiclesModel requestVehicleModelTypeWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
}

- (void)setVehicleModelTypeSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [_vehiclesModel requestVehicleModelTypeWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
}

- (IBAction)changeTypeTap:(id)sender{
    _beSavedModelNumID=@"";
    ADVehicleModelTypeChangeViewController *viewController=[[ADVehicleModelTypeChangeViewController alloc]initWithNibName:nil bundle:nil];
    viewController.typeFlag=0;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)editTap:(id)sender{
    ADVehicleBaseInfoEditViewController *editView = [[ADVehicleBaseInfoEditViewController alloc]init];
    editView.baseInfo=_vehiclesModel.vehicleInfoModelType;
    editView.delegate=self;
    [self.navigationController pushViewController:editView animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_INFO_MODELTYPE_PATH_NAME]) {
            if(_vehiclesModel.vehicleInfoModelType==nil){
                [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
            }else{
                [_tableView reloadData];
            }
            
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _dataItems[indexPath.row];
    if (indexPath.row==0) {
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"nickName"];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row==1){
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"v_vin"];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row==2){
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"licenseNumber"];
//        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row==3){
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@",[_vehiclesModel.vehicleInfoModelType objectForKey:@"TotalMilage"],NSLocalizedStringFromTable(@"kmKey",@"MyString", @"")];
    }else if (indexPath.row==4){
        cell.detailTextLabel.text=[[_vehiclesModel.vehicleInfoModelType objectForKey:@"Brand"] substringFromIndex:2];
    }else if (indexPath.row==5){
        cell.detailTextLabel.text=[[_vehiclesModel.vehicleInfoModelType objectForKey:@"ModelName"] substringFromIndex:2];
    }else if (indexPath.row==6){
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"Type"];
    }else if (indexPath.row==7){
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"manuAutomatic"];
    }else if (indexPath.row==8){
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"oilType"]==nil?@"":[self getOilType:[_vehiclesModel.vehicleInfoModelType objectForKey:@"oilType"]];
    }else if (indexPath.row==9){
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"tanksize"];
    }else if (indexPath.row==10){
        cell.detailTextLabel.text=[_vehiclesModel.vehicleInfoModelType objectForKey:@"Swept"];
    }
    else{
        cell.detailTextLabel.text=@"";
    }
    cell.backgroundColor=[UIColor whiteColor];
    
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

- (NSString*)getOilType:(NSNumber *)type{
//    NSLog(@"%@",type);
    NSString *typeString ;
    if([type intValue]==0){
        typeString=@"90#";
    }else if([type intValue]==1){
        typeString=@"93#";
    }else if ([type intValue]==2){
        typeString = @"97#";
    }else if ([type intValue]==3){
        typeString = @"90#";
    }
    return typeString;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    self.title=NSLocalizedStringFromTable(@"BasicInformationKey",@"MyString", @"");
    self.navigationItem.leftBarButtonItem=nil;
}
- (void)viewDidUnload {
    [super viewDidUnload];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
