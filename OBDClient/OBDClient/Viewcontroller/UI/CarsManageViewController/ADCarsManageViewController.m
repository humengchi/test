//
//  ADCarsManageViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADCarsManageViewController.h"
#import "ADCarManagerItemViewController.h"
#import "ADCarInfoViewController.h"
#import "ADInsureInfoViewController.h"
#import "ADService4SViewController.h"
#import "ADAuthManageViewController.h"

@interface ADCarsManageViewController ()
@property (nonatomic) NSArray *itemData;
@property (nonatomic) UITableView * tableView;
@end

@implementation ADCarsManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    if (IOS7_OR_LATER) {
        CGRect frame=self.tableView.frame;
        frame.origin.y+=64;
        frame.size.height-=64;
        [self.tableView setFrame:frame];
    }
	// Do any additional setup after loading the view.
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _itemData.count;
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
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,40, WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    cell.textLabel.text = _itemData[indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:16];
//    cell.backgroundColor=[UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
    cell.accessoryView=buttonRight;
    // Configure the cell...
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

- (void) viewWillAppear:(BOOL)animated{
    self.title=NSLocalizedStringFromTable(@"CarsManageKey",@"MyString", @"");
    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
        _itemData=@[NSLocalizedStringFromTable(@"BasicInformationKey",@"MyString", @""),
                    NSLocalizedStringFromTable(@"DrivinglicenseinformationKey",@"MyString", @""),
                    NSLocalizedStringFromTable(@"SalesinformationKey",@"MyString", @""),
                    NSLocalizedStringFromTable(@"InsuranceinformationKey",@"MyString", @""),
                    [NSString stringWithFormat:@"%@（%@）",NSLocalizedStringFromTable(@"SafeSettingInfoKey",@"MyString", @""),@"受限"],
                    NSLocalizedStringFromTable(@"The4SshopbindingKey",@"MyString", @""),
                    [NSString stringWithFormat:@"%@（%@）",NSLocalizedStringFromTable(@"AuthorizationmanagementKey",@"MyString", @""),@"受限"],
                    [NSString stringWithFormat:@"%@（%@）",NSLocalizedStringFromTable(@"LocationsharingKey",@"MyString", @""),@"受限"],
                    [NSString stringWithFormat:@"%@（%@）",NSLocalizedStringFromTable(@"OBDParametersKey",@"MyString", @""),@"受限"],
                    [NSString stringWithFormat:@"%@（%@）",NSLocalizedStringFromTable(@"RemotesetupKey",@"MyString", @""),@"受限"],
                    [NSString stringWithFormat:@"%@（%@）",NSLocalizedStringFromTable(@"RemotecommandKey",@"MyString", @""),@"受限"],
                    NSLocalizedStringFromTable(@"BindinginformationKey",@"MyString", @"")];
    }else{
        _itemData=@[NSLocalizedStringFromTable(@"BasicInformationKey",@"MyString", @""),NSLocalizedStringFromTable(@"DrivinglicenseinformationKey",@"MyString", @""),NSLocalizedStringFromTable(@"SalesinformationKey",@"MyString", @""),NSLocalizedStringFromTable(@"InsuranceinformationKey",@"MyString", @""),
                    NSLocalizedStringFromTable(@"SafeSettingInfoKey",@"MyString", @""),
                    NSLocalizedStringFromTable(@"The4SshopbindingKey",@"MyString", @""),NSLocalizedStringFromTable(@"AuthorizationmanagementKey",@"MyString", @""),NSLocalizedStringFromTable(@"LocationsharingKey",@"MyString", @""),NSLocalizedStringFromTable(@"OBDParametersKey",@"MyString", @""),NSLocalizedStringFromTable(@"RemotesetupKey",@"MyString", @""),NSLocalizedStringFromTable(@"RemotecommandKey",@"MyString", @""),
//                    NSLocalizedStringFromTable(@"GatewayconfigurationKey",@"MyString", @""),
                    NSLocalizedStringFromTable(@"BindinginformationKey",@"MyString", @"")];
    }
    [_tableView reloadData];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BOOL bindFlag=[ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag;
    NSString *className=@"";
    if(indexPath.row==0){
        className=@"ADCarInfoViewController";
    }
    else if (indexPath.row==1){
        className=@"ADVehicleLicenseInfoViewController";
    }else if (indexPath.row==2){
        className=@"ADVehicleSellInfoViewController";
    }
    else if (indexPath.row==3){
        className=@"ADInsureInfoViewController";
    }else if (indexPath.row==4){
        className = @"ADVehicleSafeSettingViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
    }
    else if (indexPath.row==5){
        className=@"ADService4SViewController";
    }else if(indexPath.row==6){
        className=@"ADAuthManageViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
    }else if(indexPath.row==7){
        className=@"ADVehicleSharedViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
    }
    else if(indexPath.row==8){
        className=@"ADVehiclePidInfoViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
    }
    else if(indexPath.row==9){
        className=@"ADVehicleSettingConfigViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
    }else if (indexPath.row==10){
        className=@"ADVehicleCommandViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
    }
//    else if(indexPath.row==11){
//        className=@"ADVehicleGateWayConfigViewController";
//        if(!bindFlag){
//            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
//            return;
//        }
//    }
    else if (indexPath.row==11){
        className = @"ADBindInfoViewController";
    }
    else{
        className=@"ADCarManagerItemViewController";
    }
//    ADCarManagerItemViewController *carManagerView = [[ADCarManagerItemViewController alloc] init];
//    [self.navigationController pushViewController:carManagerView animated:YES];
    [self tableViewSelectedHandleInSubClasses:className];
}

- (void)tableViewSelectedHandleInSubClasses:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
