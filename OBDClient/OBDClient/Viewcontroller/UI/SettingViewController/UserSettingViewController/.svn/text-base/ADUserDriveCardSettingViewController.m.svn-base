//
//  ADUserDriveCardSettingViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserDriveCardSettingViewController.h"
#import "ADUserDriverLicenseEditViewController.h"

@interface ADUserDriveCardSettingViewController ()<ADEditUserDriverLicenseInfoDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) ADUserDetailModel *userModel;
@property (nonatomic) NSArray *itemsData;
@end

@implementation ADUserDriveCardSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userModel = [[ADUserDetailModel alloc]init];
        [_userModel addObserver:self forKeyPath:KVO_USER_DRIVER_LICENSE_PATH_NAME options:NSKeyValueObservingOptionNew context:nil];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(userDriverLicenseRequestSuccess:)
                           name:ADUserDriverLicenseRequestSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(userDriverLicenseUpdateSuccess:)
                           name:ADUserDriverLicenseUpdateSuccessNotification
                         object:nil];
        
        
    }
    return self;
}

- (void)dealloc{
    [_userModel removeObserver:self forKeyPath:KVO_USER_DRIVER_LICENSE_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self name:ADUserDriverLicenseRequestSuccessNotification object:nil];
    [notiCenter removeObserver:self name:ADUserDriverLicenseUpdateSuccessNotification object:nil];
    [_userModel cancel];
}

-(void)userDriverLicenseRequestSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

-(void)userDriverLicenseUpdateSuccess:(NSNotification *)aNoti{
    [_userModel requestUserDriveLicenseWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].globalUserBase.userID]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"driveLisenceKey",@"MyString", @"");
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editTap:)];
    self.navigationItem.rightBarButtonItem=barButton;
    _itemsData=[NSArray arrayWithObjects:
                NSLocalizedStringFromTable(@"docNo",@"MyString", @""),NSLocalizedStringFromTable(@"userName",@"MyString", @""),NSLocalizedStringFromTable(@"initialDate",@"MyString", @""),NSLocalizedStringFromTable(@"licenseNo",@"MyString", @""),NSLocalizedStringFromTable(@"licensePlace",@"MyString", @""),NSLocalizedStringFromTable(@"permissionDriverType",@"MyString", @""),NSLocalizedStringFromTable(@"points",@"MyString", @""),NSLocalizedStringFromTable(@"status",@"MyString", @""),NSLocalizedStringFromTable(@"validDate",@"MyString", @""),
                    NSLocalizedStringFromTable(@"certificationDate",@"MyString", @""),nil];
    
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

    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_userModel requestUserDriveLicenseWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].globalUserBase.userID]];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


- (void)editTap:(id)sender{
    ADUserDriverLicenseEditViewController *editView=[[ADUserDriverLicenseEditViewController alloc]init];
    editView.DriverLicenseInfo=_userModel.userDriverLicenseInfo;
    editView.delegate=self;
    [self.navigationController pushViewController:editView animated:NO];
}

- (void) editContactViewController:(ADUserDriverLicenseEditViewController *) editController didEditContact:(NSArray * ) contact{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_userModel updateUserDriverLicenseWithArguments:contact];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _userModel) {
        if ([keyPath isEqualToString:KVO_USER_DRIVER_LICENSE_PATH_NAME]) {
            if(_userModel.userDriverLicenseInfo==nil){
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
    return _itemsData.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text =_itemsData[indexPath.row];
    if (indexPath.row==0) {
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"docNo"];
    }else if (indexPath.row==1){
         cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"userName"];
    }else if (indexPath.row==2){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"initialDate"];
    }else if (indexPath.row==3){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"licenseNo"];
    }else if (indexPath.row==4){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"licensePlace"];
    }else if (indexPath.row==5){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"permissionDriverType"];
    }else if (indexPath.row==6){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"points"];
    }else if (indexPath.row==7){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"status"];
    }else if (indexPath.row==8){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"validDate"];
    }else if (indexPath.row==9){
        cell.detailTextLabel.text=[_userModel.userDriverLicenseInfo objectForKey:@"certificationDate"];
    }

    cell.backgroundColor=[UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    // Configure the cell...
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
