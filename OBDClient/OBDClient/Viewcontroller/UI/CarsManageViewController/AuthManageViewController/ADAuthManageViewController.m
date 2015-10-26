//
//  ADAuthManageViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADAuthManageViewController.h"
#import "ADAuthUserListViewController.h"


@interface ADAuthManageViewController ()<ADEditAuthInfoDelegate>
@property (nonatomic) UIBarButtonItem *editItem;
@end

@implementation ADAuthManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel=[[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VEHICLE_AUTHUSERS_LIST_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(setAuthUserSuccess:)
                           name:ADVehiclesModelSetAuthUserSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(setAuthUserFail:)
                           name:ADVehiclesModelAuthVehicleFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(deleteAuthUserSuccess:)
                           name:ADVehiclesModelDeleteAuthUserSuccessNotification
                         object:nil];
        
    }
    return self;
}

- (void)dealloc{
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VEHICLE_AUTHUSERS_LIST_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelSetAuthUserSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelAuthVehicleFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelDeleteAuthUserSuccessNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"AuthorizationmanagementKey",@"MyString", @"");
    
    UIBarButtonItem *addButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTap:)];
    addButtonItem.tintColor = [UIColor lightGrayColor];
    _editItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"editKey",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(editTap:)];
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:addButtonItem,_editItem, nil];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView=nil;
    _tableView.delegate=self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    if (IOS7_OR_LATER) {
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
		[self setExtraCellLineHidden:_tableView];
        _editItem.tintColor=[UIColor lightGrayColor];
    }

    [_vehiclesModel requestAuthorizedUsersWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
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

- (IBAction)addTap:(id)sender {
    ADAuthUserListViewController * addView = [[ADAuthUserListViewController alloc]init];
    addView.delegate=self;
    [self.navigationController pushViewController:addView animated:YES];
}

-(void)editTap:(id)sender {
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    if(_tableView.isEditing){
        _editItem.title=NSLocalizedStringFromTable(@"completeKey",@"MyString", @"");
    }else{
        _editItem.title=NSLocalizedStringFromTable(@"editKey",@"MyString", @"");
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"deleteKey",@"MyString", @"")];
        [_vehiclesModel deleteAuthUserWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,[(NSDictionary *)_itemDatas[indexPath.row] objectForKey:@"userID"], nil]];
    }
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    headerView.alpha=0.75;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 5, 20, 9.5);
    [button setBackgroundImage:[UIImage imageNamed:@"vehicle_list_header.png"] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    [headerView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-20, 20)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [headerView addSubview:label];
    
    if(section == 0){
        label.text = NSLocalizedStringFromTable(@"ThevehiclehasbeendelegatedtothefollowingusersKey",@"MyString", @"");
    }
    
    if( _itemDatas.count==0){
        label.text = NSLocalizedStringFromTable(@"ThevehiclehavenoauthmanagerKey",@"MyString", @"");
    }
    
    return headerView;
}

// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _itemDatas.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //    if (cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    //    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,40, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    cell.textLabel.text = [(NSDictionary *)_itemDatas[indexPath.row] objectForKey:@"uname"];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.indentationLevel=1;
    
    cell.backgroundColor=[UIColor clearColor];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_AUTHUSERS_LIST_PATH_NAME]) {
            _itemDatas=_vehiclesModel.vehicleAuthUsersList;            
            [_tableView reloadData];
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void) editContactViewController:(ADAuthUserListViewController *) authUserEditViewController didEditContact:(NSArray * ) contact{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    
    [_vehiclesModel authorizeVehicleWithArguments:contact];
}

- (void)setAuthUserSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [_vehiclesModel requestAuthorizedUsersWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
}

- (void)deleteAuthUserSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [_vehiclesModel requestAuthorizedUsersWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
}


- (void)setAuthUserFail:(NSNotification *)aNoti{
    NSString *code=[aNoti.userInfo objectForKey:@"resultCode"];
    ADSingletonUtil *util=[[ADSingletonUtil alloc]init];
    [IVToastHUD showAsToastErrorWithStatus:[util errorStringByResultCode:code]];
}


- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
