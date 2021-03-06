//
//  ADVehicleSafeSettingViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleSafeSettingViewController.h"

@interface ADVehicleSafeSettingViewController ()
{
    UISwitch *switchButton_selected;
}

@end

@implementation ADVehicleSafeSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(setDefenceSuccess:)
                           name:ADVehiclesModelSetDefenceSuccessNotification
                         object:nil];
        
    }
    return self;
}

-(void)dealloc{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelSetDefenceSuccessNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"SafeSettingInfoKey",@"MyString", @"");
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate=self;
    tableView.dataSource=self;
    tableView.backgroundView=nil;
    tableView.backgroundColor=[UIColor clearColor];
    tableView.separatorColor = [UIColor clearColor];
    tableView.scrollEnabled = NO;
    [self.view addSubview:tableView];
    if (IOS7_OR_LATER) {
        CGRect frame=tableView.frame;
        frame.origin.y+=64;
        [tableView setFrame:frame];
    }
}

- (void)setDefenceSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [ADSingletonUtil sharedInstance].currentDeviceBase.defenceFlag = [switchButton_selected isOn];
}

#pragma mark - Table view data source
// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}
//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,50, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    
    if(indexPath.section==0){
        UISwitch *switchButton =[[UISwitch alloc]initWithFrame:CGRectMake(230, 10, 80, 30)];
        [cell addSubview:switchButton];
        [switchButton addTarget:self action:@selector(switchDefenseAction:) forControlEvents:UIControlEventValueChanged];
        switchButton.tag=indexPath.section;
        [switchButton setOn:[ADSingletonUtil sharedInstance].currentDeviceBase.defenceFlag animated:YES];
        cell.textLabel.text = NSLocalizedStringFromTable(@"DefenceInfoKey",@"MyString", @"");
    }else if (indexPath.section==1){
        UISwitch *switchButton =[[UISwitch alloc]initWithFrame:CGRectMake(230, 10, 80, 30)];
        [cell addSubview:switchButton];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        switchButton.tag=indexPath.section;
        switchButton.enabled=NO;
        [switchButton setOn:NO];
        cell.textLabel.text = NSLocalizedStringFromTable(@"MoveAlertKey",@"MyString", @"");
    }else if (indexPath.section==2){
        UISwitch *switchButton =[[UISwitch alloc]initWithFrame:CGRectMake(230, 10, 80, 30)];
        [cell addSubview:switchButton];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        switchButton.tag=indexPath.section;
        switchButton.enabled=NO;
        [switchButton setOn:NO];
        cell.textLabel.text = NSLocalizedStringFromTable(@"AutoSOSKey",@"MyString", @"");
    }
    
    
    
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    // Configure the cell...
    return cell;
}

-(void)switchDefenseAction:(id)sender{
    switchButton_selected = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton_selected isOn];
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")];
    [_vehiclesModel setVehicleDefenceWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,isButtonOn?@"1":@"0", nil]];
}

-(void)switchAction:(id)sender
{
//    UISwitch *switchButton = (UISwitch*)sender;
//    BOOL isButtonOn = [switchButton isOn];
//    [IVToastHUD showAsToastWithStatus:@"正在设置..."];
//    [_vehiclesModel shareVehicleWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,isButtonOn?@"1":@"0", nil]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
