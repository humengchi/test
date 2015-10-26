//
//  ADVehicleSharedViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-4.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleSharedViewController.h"

@interface ADVehicleSharedViewController ()

@end

@implementation ADVehicleSharedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(shareVehicleSuccess:)
                           name:ADVehiclesModelShareVehicleSuccessNotification
                         object:nil];
    }
    return self;
}

- (void)dealloc{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelShareVehicleSuccessNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)shareVehicleSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"LocationsharingKey",@"MyString", @"");
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
		[self setExtraCellLineHidden:tableView];
    }

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
    
    UISwitch *switchButton =[[UISwitch alloc]initWithFrame:CGRectMake(230, 10, 80, 30)];
    [cell addSubview:switchButton];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    switchButton.tag=0;
    [switchButton setOn:[ADSingletonUtil sharedInstance].currentDeviceBase.shareFlag];
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    cell.textLabel.text = NSLocalizedStringFromTable(@"publicvehiclesKey",@"MyString", @"");
    cell.detailTextLabel.text = NSLocalizedStringFromTable(@"publicvehiclesDetailKey",@"MyString", @"");
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.backgroundColor=[UIColor clearColor];
    
    // Configure the cell...
    return cell;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")];
    [_vehiclesModel shareVehicleWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,isButtonOn?@"1":@"0", nil]];
}

@end
