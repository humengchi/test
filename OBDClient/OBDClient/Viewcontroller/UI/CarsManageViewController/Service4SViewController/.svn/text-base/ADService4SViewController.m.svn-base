//
//  ADService4SViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADService4SViewController.h"
#import "ADReset4SStoreViewController.h"

@interface ADService4SViewController ()<ADEditBind4sInfoDelegate>
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) NSDictionary *storeInfo;
@end

@implementation ADService4SViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VEHICLE_BIND4S_INFO_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(requestVehicle4sInfoSuccess:)
                           name:ADVehiclesModelrequest4sInfoSuccessNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(setVehicle4sStoreSuccess:)
                           name:ADVehiclesModelSet4sStoreSuccessNotification
                         object:nil];
        
        
    }
    return self;
}

- (void)dealloc
{
    [_vehiclesModel removeObserver:self forKeyPath:KVO_VEHICLE_BIND4S_INFO_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelrequest4sInfoSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelSet4sStoreSuccessNotification
                        object:nil];
    
    [_vehiclesModel cancel];
}

- (void)requestVehicle4sInfoSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}
- (void)setVehicle4sStoreSuccess:(NSNotification *)aNoti
{
    [_vehiclesModel requestBind4sStoreInfoWithArgument:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _dataItems = @[NSLocalizedStringFromTable(@"bind4s_name",@"MyString", @""),NSLocalizedStringFromTable(@"bind4s_tel",@"MyString", @""),NSLocalizedStringFromTable(@"bind4s_address",@"MyString", @""),NSLocalizedStringFromTable(@"bind4s_mark",@"MyString", @"")];
    self.title=NSLocalizedStringFromTable(@"The4SshopbindingKey",@"MyString", @"");
    
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

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
    UIButton *resetButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    resetButton.frame = CGRectMake(10, 262, self.view.bounds.size.width-20, 44);
    [resetButton setTitle:NSLocalizedStringFromTable(@"ReboundKey",@"MyString", @"") forState:UIControlStateNormal];
    [resetButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [resetButton addTarget:self action:@selector(resetTap:) forControlEvents:UIControlEventTouchUpInside];
    [resetButton setBackgroundImage:[UIImage imageNamed:@"_0001_Shape-8.png"] forState:UIControlStateNormal];
    if([[ADSingletonUtil sharedInstance].currentDeviceBase.accountType isEqualToString:@"0"]){
        [self.view addSubview:resetButton];
    }
    
    UIButton *unbindButton =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    unbindButton.frame = CGRectMake(10, 262, self.view.bounds.size.width-20, 44);
    [unbindButton setTitle:NSLocalizedStringFromTable(@"noboundKey",@"MyString", @"") forState:UIControlStateNormal];
    [unbindButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [unbindButton addTarget:self action:@selector(unbindTap:) forControlEvents:UIControlEventTouchUpInside];
    [unbindButton setBackgroundImage:[UIImage imageNamed:@"_0001_Shape-8.png"] forState:UIControlStateNormal];
    [self.view addSubview:unbindButton];
    unbindButton.hidden=YES;
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [resetButton setFrame:CGRectMake(10, 326, self.view.bounds.size.width-20, 44)];
        [unbindButton setFrame:CGRectMake(10, 326, self.view.bounds.size.width-20, 44)];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [resetButton setFrame:CGRectMake(10, self.view.bounds.size.height-100, self.view.bounds.size.width-20, 44)];
        [unbindButton setFrame:CGRectMake(10, self.view.bounds.size.height-100, self.view.bounds.size.width-20, 44)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [resetButton setFrame:CGRectMake(10, self.view.bounds.size.height-36, self.view.bounds.size.width-20, 44)];
        [unbindButton setFrame:CGRectMake(10, self.view.bounds.size.height-36, self.view.bounds.size.width-20, 44)];
	}

    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_vehiclesModel requestBind4sStoreInfoWithArgument:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)editContactViewController:(ADReset4SStoreViewController *)viewController didEditContact:(NSArray *)editContact{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")];
    [_vehiclesModel setVehicleBind4sStoreWithArguments:editContact];
}

- (IBAction)resetTap:(id)sender
{
    ADReset4SStoreViewController *resetView = [[ADReset4SStoreViewController alloc]initWithNibName:nil bundle:nil];
    resetView.delegate=self;
    [self.navigationController pushViewController:resetView animated:YES];
}

- (IBAction)unbindTap:(id)sender
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_BIND4S_INFO_PATH_NAME]) {
            _storeInfo = _vehiclesModel.vehicleBind4sInfo;
            if(_storeInfo==nil){
                [IVToastHUD showAsToastErrorWithStatus:@"您尚未绑定4s店"];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _dataItems[indexPath.row];
    if(indexPath.row == 0){
        cell.detailTextLabel.text=[_storeInfo objectForKey:@"name"]==[NSNull null]?@"":[_storeInfo objectForKey:@"name"];
    }
    else if (indexPath.row==1) {
        cell.detailTextLabel.text=[_storeInfo objectForKey:@"tel"]==[NSNull null]?@"":[_storeInfo objectForKey:@"tel"];
    }else if (indexPath.row==2){
        cell.detailTextLabel.text=[_storeInfo objectForKey:@"address"]==[NSNull null]?@"":[_storeInfo objectForKey:@"address"];
    }else if (indexPath.row==3){
        cell.detailTextLabel.text=[_storeInfo objectForKey:@"mark"]==[NSNull null]?@"":[_storeInfo objectForKey:@"mark"];
    }
    
    cell.backgroundColor=[UIColor whiteColor];
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
