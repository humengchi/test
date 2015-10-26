//
//  SpeedDialViewController.m
//  OBDClient
//
//  Created by hys on 30/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "SpeedDialViewController.h"
#import "ADInsureInfoViewController.h"
#import "ADService4SViewController.h"
#import "ADModifyPhoneRentViewController.h"

@interface SpeedDialViewController ()
{
    int modifyPhone;
}
@property (nonatomic) NSString *bind4sPhone;
@property (nonatomic) NSString *insurePhone;
@end

@implementation SpeedDialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VEHICLE_BIND4S_INFO_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(requestVehicle4sInfoSuccess1:)
                           name:ADVehiclesModelrequest4sInfoSuccessNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(requestVehicleInfoForInsureSuccess1:)
                           name:ADVehiclesModelRequestVehicleInfoForInsureSuccessNotification
                         object:nil];
    }
    return self;
}

- (void)requestVehicle4sInfoSuccess1:(NSNotification *)aNoti
{
    
}

- (void)requestVehicleInfoForInsureSuccess1:(NSNotification *)aNoti
{

}

- (void)dealloc
{
//    [_vehiclesModel removeObserver:self forKeyPath:KVO_VEHICLE_BIND4S_INFO_PATH_NAME];
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VEHICLE_INSURE_INFO_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelrequest4sInfoSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelRequestVehicleInfoForInsureSuccessNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)editTableView
{
    if([self.navigationItem.rightBarButtonItem.title isEqual:@"编辑"]){
        self.navigationItem.rightBarButtonItem.title =  @"完成";
        modifyPhone = 1;
    }else{
        self.navigationItem.rightBarButtonItem.title =  @"编辑";
        modifyPhone = 0;
    }
    [_speedDialTableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    modifyPhone = 0;
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editTableView)];
    rightItem.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.title=NSLocalizedStringFromTable(@"speedDialKey",@"MyString", @"");
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    _speedDialTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 436) style:UITableViewStylePlain];
    [_speedDialTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    _speedDialTableView.delegate=self;
    _speedDialTableView.dataSource=self;
    _speedDialTableView.scrollEnabled=NO;
    _speedDialTableView.separatorStyle=UITableViewCellSeparatorStyleSingleLineEtched;
    [self.view addSubview:_speedDialTableView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_speedDialTableView setFrame:CGRectMake(0, 0, WIDTH, 524)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_speedDialTableView setFrame:CGRectMake(0, 0, WIDTH, 524)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
//    [_vehiclesModel requestBind4sStoreInfoWithArgument:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [_vehiclesModel addObserver:self
                     forKeyPath:KVO_VEHICLE_BIND4S_INFO_PATH_NAME
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [_vehiclesModel requestBind4sStoreInfoWithArgument:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
//    [_speedDialTableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_BIND4S_INFO_PATH_NAME]) {
            if(_vehiclesModel.vehicleBind4sInfo){
                _bind4sPhone = _vehiclesModel.vehicleBind4sInfo[@"tel"];
            }
            [_vehiclesModel removeObserver:self forKeyPath:KVO_VEHICLE_BIND4S_INFO_PATH_NAME];
            [_vehiclesModel addObserver:self
                             forKeyPath:KVO_VEHICLE_INSURE_INFO_PATH_NAME
                                options:NSKeyValueObservingOptionNew
                                context:nil];
            [_vehiclesModel requestVehicleInfoForInsureWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
            return;
        }
        if ([keyPath isEqualToString:KVO_VEHICLE_INSURE_INFO_PATH_NAME]){
            if(_vehiclesModel.vehicleInsureInfo){
                _insurePhone = _vehiclesModel.vehicleInsureInfo.customerServicePhone;
            }
            [_speedDialTableView reloadData];
            return;
        }
        
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"SpeedDialCell";
    SpeedDialCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"SpeedDialCell" owner:self options:nil];
        cell=(SpeedDialCell*)[xib objectAtIndex:0];
        
    }
    if(modifyPhone == 0){
        cell.modifyTelButton.hidden = YES;
        cell.callButton.enabled = YES;
    }else{
        cell.modifyTelButton.hidden = NO;
        cell.callButton.enabled = NO;
    }
    cell.delegate = self;
    if (indexPath.row<6) {
        [cell.seperatorLineImgView setHidden:NO];
        
        if (indexPath.row==0) {
            cell.speedDialName.text=NSLocalizedStringFromTable(@"rescueKey",@"MyString", @"");
            cell.tel = _insurePhone;
            if(_insurePhone.length){
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(tel:%@)", _insurePhone];
            }else{
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(未设置快捷号码)"];
            }
            [cell.callButton setTag:10];
            [cell.modifyTelButton setTag:20];
        }else if (indexPath.row==1){
            cell.speedDialName.text=NSLocalizedStringFromTable(@"reserveKey",@"MyString", @"");
            cell.tel = _bind4sPhone;
            if(_bind4sPhone != [NSNull null] && _bind4sPhone.length){
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(tel:%@)", _bind4sPhone];
            }else{
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(未设置快捷号码)"];
            }
            [cell.callButton setTag:11];
            [cell.modifyTelButton setTag:21];
        }else if (indexPath.row==2){
            cell.speedDialName.text=NSLocalizedStringFromTable(@"atRiskKey",@"MyString", @"");
            cell.tel = _insurePhone;
            if(_insurePhone.length){
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(tel:%@)", _insurePhone];
            }else{
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(未设置快捷号码)"];
            }
            [cell.callButton setTag:12];
            [cell.modifyTelButton setTag:22];
        }else if (indexPath.row==3){
            cell.speedDialName.text=NSLocalizedStringFromTable(@"carRentalKey",@"MyString", @"");
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            cell.tel = [defaults objectForKey:@"rentPhone"];
            if(cell.tel.length){
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(tel:%@)", cell.tel];
            }else{
                cell.speedPhoneNumber.text = [NSString stringWithFormat:@"(未设置快捷号码)"];
            }
            [cell.callButton setTag:13];
            [cell.modifyTelButton setTag:23];
        }else if (indexPath.row==4){
            cell.speedDialName.text=@"110";
            cell.tel = @"110";
            [cell.modifyTelButton setHidden:YES];
            [cell.callButton setTag:14];
            [cell.speedPhoneNumber setHidden:YES];
        }else if (indexPath.row==5){
            cell.speedDialName.text=@"120";
            cell.tel = @"120";
            [cell.modifyTelButton setHidden:YES];
            [cell.callButton setTag:15];
            [cell.speedPhoneNumber setHidden:YES];
        }
    }else{
        [cell.speedDialName setHidden:YES];
        [cell.speedPhoneNumber setHidden:YES];
        [cell.callButton setHidden:YES];
        [cell.modifyTelButton setHidden:YES];
        [cell.seperatorLineImgView setHidden:YES];
    }

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.speedDialName.font=[UIFont systemFontOfSize:12];
    cell.speedPhoneNumber.font=[UIFont systemFontOfSize:12];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -SpeedDialCellDelegate
- (void)setupPhone:(NSInteger)tag
{
    if([self.navigationItem.rightBarButtonItem.title isEqual:@"完成"]){
        [self editTableView];
    }
    
    if(tag == 1){
        ADInsureInfoViewController *insureVC = [[ADInsureInfoViewController alloc] init];
        [self.navigationController pushViewController:insureVC animated:YES];
    }else if(tag == 2){
        ADService4SViewController *serverVC = [[ADService4SViewController alloc] init];
        [self.navigationController pushViewController:serverVC animated:YES];
    }else{
        ADModifyPhoneRentViewController *modifyTelVC = [[ADModifyPhoneRentViewController alloc] init];
        [self.navigationController pushViewController:modifyTelVC animated:YES];
    }
    NSLog(@"%d", tag);
}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 20;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0;
//}

//-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section{
//    if (section==0) {
//        UIView* view1=[[UIView alloc]init];
//        view1.backgroundColor=[UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.5];
//        UILabel* lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
//        lab1.text=@"我的车辆";
//        lab1.textColor=[UIColor blackColor];
//        lab1.backgroundColor=[UIColor clearColor];
//        [view1 addSubview:lab1];
//
//        return view1;
//    }
//    if (section==1){
//        UIView* view2=[[UIView alloc]init];
//        view2.backgroundColor=[UIColor colorWithRed:0.10 green:0.68 blue:0.94 alpha:0.5];
//
//        UILabel* lab2=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
//        lab2.text=@"我的授权车辆";
//        lab2.textColor=[UIColor blackColor];
//        lab2.backgroundColor=[UIColor clearColor];
//        [view2 addSubview:lab2];
//        return view2;
//
//    }
//    return nil;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
