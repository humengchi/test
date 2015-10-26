//
//  ADUserManageViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-25.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserManageViewController.h"
#import "ADMainWindow.h"
#import "ADApiManager.h"
#import "ADBindDeviceViewController.h"
#import "ADActiveDeviceViewController.h"
#import "ADChattingLoginViewController.h"
#import "ADSingletonUtil.h"


@interface ADUserManageViewController ()
{
    BOOL table_cell_device;
    BOOL table_cell_auth;
    BOOL table_cell_other;
}
@property (nonatomic) UILabel *labelOfHeader;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADUserManageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _devicesModel = [[ADDevicesModel alloc] init];
        _vehiclesModes = [[ADVehiclesModel alloc]init];
        [_devicesModel addObserver:self
                        forKeyPath:KVO_ALL_DEVICES_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        [_devicesModel addObserver:self
                        forKeyPath:KVO_AUTH_DEVICES_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        [_devicesModel addObserver:self
                        forKeyPath:KVO_SHARED_DEVICES_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        
        
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(requestAllDevicesSuccess:)
                           name:ADDevicesModelRequestAllDevicesSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestAllDevicesFail:)
                           name:ADDevicesModelRequestAllDevicesFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestAllDevicesTimeout:)
                           name:ADDevicesModelRequestAllDevicesTimeoutNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(requestAuthDevicesSuccess:)
                           name:ADDevicesModelRequestAuthorizeDevicesSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestAuthDevicesFail:)
                           name:ADDevicesModelRequestAuthorizeDevicesFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestAuthDevicesTimeout:)
                           name:ADDevicesModelRequestAuthorizeDevicesTimeoutNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(requestSharedDevicesSuccess:)
                           name:ADDevicesModelRequestSharedDevicesSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestSharedDevicesFail:)
                           name:ADDevicesModelRequestSharedDevicesFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(requestSharedDevicesTimeout:)
                           name:ADDevicesModelRequestSharedDevicesTimeoutNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(deleteVehicleSuccess:)
                           name:ADVehiclesModelDeleteVehicleSuccessNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(deleteVehicleFail:)
                           name:@"ADVehiclesModelDeleteVehicleFailNotification"
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(unbindDeviceSuccess:)
                           name:ADVehiclesModelUnbindDeviceSuccessNotification
                         object:nil];
        
        [notiCenter addObserver:self
                       selector:@selector(updateNickNameRequestSuccess:)
                           name:ADUserInfoRequestSuccessNotification
                         object:nil];

    }
    

    return self;
}

- (void)dealloc
{
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_ALL_DEVICES_PATH_NAME];
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_AUTH_DEVICES_PATH_NAME];
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_SHARED_DEVICES_PATH_NAME];
    
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestAllDevicesSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestAllDevicesFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestAllDevicesTimeoutNotification
                        object:nil];

    [notiCenter removeObserver:self
                       name:ADDevicesModelRequestAuthorizeDevicesSuccessNotification
                     object:nil];
    [notiCenter removeObserver:self
                       name:ADDevicesModelRequestAuthorizeDevicesFailNotification
                     object:nil];
    [notiCenter removeObserver:self
                       name:ADDevicesModelRequestAuthorizeDevicesTimeoutNotification
                     object:nil];
    
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestSharedDevicesSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestSharedDevicesFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADDevicesModelRequestSharedDevicesTimeoutNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelDeleteVehicleSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:@"ADVehiclesModelDeleteVehicleFailNotification"
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelUnbindDeviceSuccessNotification
                        object:nil];
    
    [_devicesModel cancel];
    [_vehiclesModes cancel];
}

- (void)tableViewEdit1:(id)sender
{
    
    [_tableView setEditing:!_tableView.isEditing animated:YES];
    if(_tableView.isEditing){
        self.navigationItem.rightBarButtonItem.title=NSLocalizedStringFromTable(@"completeKey",@"MyString", @"");
    }else{
        self.navigationItem.rightBarButtonItem.title=NSLocalizedStringFromTable(@"editKey",@"MyString", @"");
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
#ifdef HMC
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"chattingConnect" object:nil userInfo:nil];
#endif
    self.navigationItem.title=NSLocalizedStringFromTable(@"usercenterKey",@"MyString", @"");
    
    self.navigationItem.leftBarButtonItem=nil;

    UIBarButtonItem *editButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"editKey",@"MyString", @"") style:UIBarButtonItemStyleDone target:self action:@selector(tableViewEdit1:)];
    
    
    self.navigationItem.rightBarButtonItem=editButtonItem;
    if (IOS7_OR_LATER) {
        editButtonItem.tintColor=[UIColor lightGrayColor];
    }
    
    CGRect rect = CGRectMake(0, 0, WIDTH, 60);
    UIView *viewOfHeader = [[UIView alloc] initWithFrame:rect];
    viewOfHeader.backgroundColor=[UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 4, 50, 50);
    [button setBackgroundImage:[UIImage imageNamed:@"user_photo_default.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(userManagerTap:) forControlEvents:UIControlEventTouchUpInside];
    [viewOfHeader addSubview:button];
    
    NSLog(@"%@",[ADSingletonUtil sharedInstance].globalUserBase.fullname);
    
    CGRect rectLabel = CGRectMake(60, 4, 180, 50);
    _labelOfHeader=[[UILabel alloc]initWithFrame:rectLabel];
    NSString *textWelcome=[NSString stringWithFormat:@"%@ \n%@",[ADSingletonUtil sharedInstance].globalUserBase.fullname,NSLocalizedStringFromTable(@"WelcometouseKey",@"MyString", @"")];
    _labelOfHeader.numberOfLines = 0;
    _labelOfHeader.text=textWelcome;
    UIFont *font=[_labelOfHeader.font fontWithSize:14];
    _labelOfHeader.font=font;
    _labelOfHeader.textColor=[UIColor grayColor];
    _labelOfHeader.textAlignment=NSTextAlignmentLeft;
    _labelOfHeader.backgroundColor=[UIColor clearColor];
    [viewOfHeader addSubview:_labelOfHeader];
    
    UIButton *buttonExit = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonExit.frame = CGRectMake(WIDTH-60, 20, 50, 25);
    [buttonExit setBackgroundImage:[UIImage imageNamed:@"exit_button.png"] forState:UIControlStateNormal];
    [buttonExit setTitle:NSLocalizedStringFromTable(@"logoffKey",@"MyString", @"") forState:UIControlStateNormal];
    buttonExit.titleLabel.font=[UIFont systemFontOfSize:12];
    [buttonExit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonExit addTarget:self action:@selector(exitButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    [viewOfHeader addSubview:buttonExit];
    
    CGRect rectLine = CGRectMake(0, 58, WIDTH, 1);
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:rectLine];
    lineLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [viewOfHeader addSubview:lineLabel];
    
    

    CGRect rectTable= CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y+60, self.view.bounds.size.width, self.view.bounds.size.height-104);
    
    
    _tableView=[[UITableView alloc]initWithFrame:rectTable style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];

    
    UIToolbar *toolbar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height-88, WIDTH, 44)];
    [toolbar setBackgroundImage:[UIImage imageNamed:@"app_topbar_bg.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    UIButton *buttonMap = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonMap.imageView.image= [UIImage imageNamed:@"tab_0005_map.png"];
    buttonMap.frame = CGRectMake(0, 0, WIDTH/3.0, 44);
    [buttonMap setTitle:NSLocalizedStringFromTable(@"MapViewKey",@"MyString", @"") forState:UIControlStateNormal];
    buttonMap.titleLabel.font=[UIFont systemFontOfSize:14];
    [buttonMap setBackgroundColor:[UIColor clearColor]];
    [buttonMap setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [buttonMap addTarget:self action:@selector(mapViewTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:buttonMap];

    UIButton *buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonAdd.frame = CGRectMake(0, 0, WIDTH/3.0, 44);
    [buttonAdd setTitle:NSLocalizedStringFromTable(@"AddvehicleKey",@"MyString", @"") forState:UIControlStateNormal];
    buttonAdd.titleLabel.font=[UIFont systemFontOfSize:14];
    [buttonAdd setBackgroundColor:[UIColor clearColor]];
    [buttonAdd setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [buttonAdd addTarget:self action:@selector(addVehicleTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:buttonAdd];


    
    UIButton *buttonReload = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonReload.frame = CGRectMake(0, 0, WIDTH/3.0, 44);
    [buttonReload setTitle:NSLocalizedStringFromTable(@"initKey",@"MyString", @"") forState:UIControlStateNormal];
    buttonReload.titleLabel.font=[UIFont systemFontOfSize:14];
    [buttonReload setBackgroundColor:[UIColor clearColor]];
    [buttonReload setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [buttonReload addTarget:self action:@selector(reloadTap:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithCustomView:buttonReload];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [toolbar setItems:[NSArray arrayWithObjects:flexSpace,item1,flexSpace,item2,flexSpace,item3,flexSpace,nil] animated:YES];
    
    [self.view addSubview:toolbar];
    
    [self.view addSubview:viewOfHeader];
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [viewOfHeader setFrame:CGRectMake(0, 64, WIDTH, 60)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        frame.size.height-=64;
        [_tableView setFrame:frame];
        [toolbar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-43, WIDTH, 44)];
        editButtonItem.tintColor=[UIColor lightGrayColor];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_tableView.frame;
        frame.size.height=[UIScreen mainScreen].bounds.size.height-215;
        [_tableView setFrame:frame];
        [toolbar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-107, WIDTH, 44)];
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [viewOfHeader setFrame:CGRectMake(0, 64, WIDTH, 60)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        frame.size.height-=64;
        [_tableView setFrame:frame];
        [toolbar setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-43, WIDTH, 44)];
        editButtonItem.tintColor=[UIColor lightGrayColor];

	}
    _tableView.frame = CGRectMake(0, 128, WIDTH, HEIGHT-64*3);
    NSString *userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_devicesModel requestAllDevicesWithArguments:[NSArray arrayWithObjects:userID,nil]];

#ifdef HMC
    //判断车友聊天是否登录成功
//    if(![ADSingletonUtil sharedInstance].chattingIsLogin){
//        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:@"提示" message:@"车友聊天登录失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//        [alertview show];
//    }
#endif
    
//    UIButton *buttonMap1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonMap1.frame = CGRectMake(70, 60, 106, 44);
//    [buttonMap1 setTitle:@"导航" forState:UIControlStateNormal];
//    buttonMap1.titleLabel.font=[UIFont systemFontOfSize:17];
//    [buttonMap1 setBackgroundColor:[UIColor redColor]];
//    [buttonMap1 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
//    [buttonMap1 addTarget:self action:@selector(nativeNavi:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:buttonMap1];
    
}

////调启百度地图客户端导航
//- (IBAction)nativeNavi:(id)sender
//{
//    //初始化调启导航时的参数管理类
//    NaviPara* para = [[NaviPara alloc]init];
//    //指定导航类型
//    para.naviType = NAVI_TYPE_NATIVE;
//    
//    //初始化终点节点
//    BMKPlanNode* end = [[BMKPlanNode alloc]init] ;
//    //指定终点经纬度
//    CLLocationCoordinate2D coor2;
//    coor2.latitude = [@"31.207829f" floatValue];
//    coor2.longitude = [@"121.594041" floatValue];
//    end.pt = coor2;
//    //指定终点名称
//    end.name = @"游世移动通信";
//    //指定终点
//    para.endPoint = end;
//    
//    //指定返回自定义scheme，具体定义方法请参考常见问题
//    para.appScheme = @"baidumapsdk://mapsdk.baidu.com";
//    //调启百度地图客户端导航
//    [BMKNavigation openBaiduMapNavigation:para];
//
//}

- (IBAction)userManagerTap:(id)sender{
    [self tableViewSelectedHandleInSubClasses:@"ADUserInfoSettingViewController"];
}

- (IBAction)mapViewTap:(id)sender {
    ADUsersMapViewController *viewController = [[ADUsersMapViewController alloc] init];
    viewController.modelFlag=0;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)addVehicleTap:(id)sender {
//    UIViewController *viewController = [[NSClassFromString(@"ADUserAddVehicleViewController") alloc] initWithNibName:nil bundle:nil];
//    [self.navigationController pushViewController:viewController animated:YES];
    [self tableViewSelectedHandleInSubClasses:@"ADUserAddVehicleViewController"];
    
}

- (IBAction)reloadTap:(id)sender {
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    NSString *userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [self.devicesModel requestAllDevicesWithArguments:[NSArray arrayWithObjects:userID, nil]];
}

- (IBAction)bindTap:(id)sender{
    _selectDevice=[_devicesModel.devices objectAtIndex:[(UIButton*)sender tag]-1000];
    NSLog(@"%@",_selectDevice.licenseNumber);
    if(_selectDevice.bindedFlag){
        UIActionSheet *bindActionSheet=[[UIActionSheet alloc]
                                        initWithTitle:[NSString stringWithFormat:@"%@（%@）",_selectDevice.licenseNumber,[_selectDevice.modelName substringFromIndex:2]]
                                        delegate:self
                                        cancelButtonTitle:NSLocalizedStringFromTable(@"cancelKey",@"MyString", @"")
                                        destructiveButtonTitle:NSLocalizedStringFromTable(@"noboundKey",@"MyString", @"")
                                        otherButtonTitles:NSLocalizedStringFromTable(@"ReboundKey",@"MyString", @""),NSLocalizedStringFromTable(@"ActivationKey",@"MyString", @""),nil];
        bindActionSheet.tag=99;
        bindActionSheet.delegate=self;
        bindActionSheet.actionSheetStyle=UIBarStyleBlackOpaque;
        [bindActionSheet showInView:self.view];
    }else{
        UIActionSheet *bindActionSheet=[[UIActionSheet alloc]
                                        initWithTitle:[NSString stringWithFormat:@"%@（%@）",_selectDevice.licenseNumber,[_selectDevice.modelName substringFromIndex:2]]
                                        delegate:self
                                        cancelButtonTitle:NSLocalizedStringFromTable(@"cancelKey",@"MyString", @"")
                                        destructiveButtonTitle:NSLocalizedStringFromTable(@"BindingequipmentKey",@"MyString", @"")
                                        otherButtonTitles:nil];
        bindActionSheet.tag=100;
        bindActionSheet.delegate=self;
        bindActionSheet.actionSheetStyle=UIBarStyleBlackOpaque;
        [bindActionSheet showInView:self.view];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag==200){
        if(buttonIndex==1){
            [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"submitingKey",@"MyString", @"")];
            [_vehiclesModes unBindDeviceWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].globalUserBase.userID,_selectDevice.d_vin,_selectDevice.d_esn,_selectDevice.registerKey, nil]];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(actionSheet.tag==99){
        UIAlertView *unboundAlertView = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"promptKey",@"MyString", @"") message:[NSString stringWithFormat:@"%@%@（%@）",NSLocalizedStringFromTable(@"determinebinding",@"MyString", @""),_selectDevice.licenseNumber,[_selectDevice.modelName substringFromIndex:2]] delegate:self cancelButtonTitle:NSLocalizedStringFromTable(@"cancelKey",@"MyString", @"") otherButtonTitles:NSLocalizedStringFromTable(@"ensureKey",@"MyString", @""), nil];
        unboundAlertView.tag=200;
        unboundAlertView.delegate=self;
        switch (buttonIndex) {
            case 0:
                [unboundAlertView show];
                break;
            case 1:
                [self bindDevice:_selectDevice.d_vin];
                break;
            case 2:
                [self activeDevice:_selectDevice.d_vin];
                break;
            default:
                break;
        }
    }else if (actionSheet.tag==100){
        switch (buttonIndex) {
            case 0:
                [self bindDevice:_selectDevice.d_vin];
                break;
            default:
                break;
        }

    }
}

-(void)bindDevice:(NSString *)vin{
    [self setRefresh];
    ADBindDeviceViewController *bindView = [[ADBindDeviceViewController alloc]initWithNibName:nil bundle:nil];
    bindView.beSavedVin=vin;
    [self.navigationController pushViewController:bindView animated:YES];
}

-(void)activeDevice:(NSString *)vin{
    [self setRefresh];
    ADActiveDeviceViewController *activeView = [[ADActiveDeviceViewController alloc]initWithNibName:nil bundle:nil];
    activeView.willActiveVin=vin;
    [self.navigationController pushViewController:activeView animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == _devicesModel) {
        if ([keyPath isEqualToString:KVO_ALL_DEVICES_PATH_NAME]) {
            [ADSingletonUtil sharedInstance].devices = _devicesModel.devices;
            
            [_tableView reloadData];
            //默认选中第一个
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
            if(_devicesModel.devices.count>0){
                _currentDeviceBase = ((ADDeviceBase *)[[ADSingletonUtil sharedInstance].devices objectAtIndex:0]);
                [ADSingletonUtil sharedInstance].currentDeviceBase = _currentDeviceBase;
                if ([ADSingletonUtil sharedInstance].autoMsgCenter) {
//                    [self navigateToViewControllerByClassName:@"CarAssistantViewController"];
                    MessageViewController* msgViewController=[[MessageViewController alloc]init];
//                    [self navigateToViewControllerByClassName:@"MessageViewController"];
                    [self.navigationController pushViewController:msgViewController animated:YES];
                    [ADSingletonUtil sharedInstance].selectMenuIndex=0;
                    [ADSingletonUtil sharedInstance].autoMsgCenter=NO;
                }
                
//                _isAutoNavigation=NO;
            }
            return;
        } else if ([keyPath isEqualToString:KVO_AUTH_DEVICES_PATH_NAME]){
            [_tableView reloadData];
            return;
        }
        else if ([keyPath isEqualToString:KVO_SHARED_DEVICES_PATH_NAME]) {
            [ADSingletonUtil sharedInstance].sharedDevices = _devicesModel.sharedDevices;
            if (_devicesModel.sharedDevices.count>0) {
                ADUsersMapViewController *viewController = [[ADUsersMapViewController alloc] init];
                viewController.modelFlag=2;
                [self.navigationController pushViewController:viewController animated:YES];
            }else{
                [IVToastHUD showAsToastSuccessWithStatus:NSLocalizedStringFromTable(@"nototalvehicle",@"MyString", @"")];
            }
            
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)navigateToViewControllerByClassName:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
    ADNavigationController *navigationController = [ADNavigationController navigationControllerWithRootViewController:viewController];
    CGRect frame = self.slidingController.topViewController.view.frame;
    self.slidingController.topViewController = navigationController;
    self.slidingController.topViewController.view.frame = frame;
    [self.slidingController resetTopView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (IBAction)exitButtonTap:(id)sender{
    [ADSingletonUtil sharedInstance].userInfo=nil;
    [ADSingletonUtil sharedInstance].chattingIsLogin = NO;
    [(ADMainWindow *)self.view.window transitionToLoginViewController];
#ifdef HMC
    [[self appDelegate].xmppStream disconnectAfterSending];
#endif
}

- (void)hiddenTap:(id)sender{
     UIView *view=((UIGestureRecognizer *)sender).view;
    if (view.tag==300384) {
        table_cell_device=(table_cell_device?NO:YES);
    }else if (view.tag==300385){
        table_cell_auth=(table_cell_auth?NO:YES);
    }else if (view.tag==300386){
        table_cell_other=(table_cell_other?NO:YES);
    }
    [_tableView reloadData];
}

- (void)getShareDeviceList{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_devicesModel requestSharedDevicesWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].globalUserBase.userID]];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    headerView.alpha=0.75;
    headerView.tag=300384+section;
    UITapGestureRecognizer *tapGes =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenTap:)];
    tapGes.numberOfTapsRequired = 1;
    [headerView addGestureRecognizer:tapGes];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 5, 20, 9.5);

//    [button setBackgroundImage:[UIImage imageNamed:@"vehicle_list_header.png"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(hiddenTap:) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor=[UIColor clearColor];
//    button.tag=300384+section;
    button.enabled=NO;
    [headerView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-20, 20)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [headerView addSubview:label];
    
    UIImage *openImage=[UIImage imageNamed:@"vehicle_list_header.png"];
    UIImage *closeImage=[UIImage imageNamed:@"title_icon.png"];
    if(section == 0){
        if (table_cell_device) {
            [button setBackgroundImage:closeImage forState:UIControlStateNormal];
            [button setBackgroundImage:closeImage forState: UIControlStateDisabled];
        }else{
            [button setBackgroundImage:openImage forState:UIControlStateNormal];
            [button setBackgroundImage:openImage forState: UIControlStateDisabled];
        }
        label.text =NSLocalizedStringFromTable(@"MyvehicleKey",@"MyString", @"");
    }else if (section==1){
        if (table_cell_auth) {
            [button setBackgroundImage:closeImage forState:UIControlStateNormal];
            [button setBackgroundImage:closeImage forState: UIControlStateDisabled];
        }else{
            [button setBackgroundImage:openImage forState:UIControlStateNormal];
            [button setBackgroundImage:openImage forState: UIControlStateDisabled];
        }
        label.text = NSLocalizedStringFromTable(@"MyauthorizethevehicleKey",@"MyString", @"");
    }else if (section==2){
        if (table_cell_other) {
            [button setBackgroundImage:closeImage forState:UIControlStateNormal];
            [button setBackgroundImage:closeImage forState: UIControlStateDisabled];
        }else{
            [button setBackgroundImage:openImage forState:UIControlStateNormal];
            [button setBackgroundImage:openImage forState: UIControlStateDisabled];
        }
        label.text = NSLocalizedStringFromTable(@"othergroupKey",@"MyString", @"");
    }

    return headerView;
}

- (void)setRefresh{
//    [self setRefresh];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    if (indexPath.section==0) {
        if(_devicesModel.devices.count!=0){
            ADDeviceBase *currentDeviceBase = [_devicesModel.devices objectAtIndex:indexPath.row];
            [ADSingletonUtil sharedInstance].currentDeviceBase = currentDeviceBase;
            if(!currentDeviceBase.bindedFlag){
                [self setRefresh];
                [IVToastHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"needBindAlertKey",@"MyString", @"")];
                ADBindDeviceViewController *bindView = [[ADBindDeviceViewController alloc]init];
                bindView.beSavedVin = currentDeviceBase.d_vin;
                bindView.fromPage = @"userManager";
                [self.navigationController pushViewController:bindView animated:YES];
            }else{
                [self navigateToViewControllerByClassName:@"CarAssistantViewController"];
                [ADSingletonUtil sharedInstance].selectMenuIndex=0;
            }
            
        }
        
    }else if (indexPath.section==1){
        if(_devicesModel.authDevices.count!= 0){
            ADUsersMapViewController *viewController = [[ADUsersMapViewController alloc] init];
            viewController.modelFlag=1;
            viewController.authIndex=indexPath.row;
            [self.navigationController pushViewController:viewController animated:YES];
        }
    }else if (indexPath.section==2&&indexPath.row==1){
//        [self tableViewSelectedHandleInSubClasses:@"ADUserFriendsViewController"];
#ifdef HMC
        //禁掉车友功能
        if([ADSingletonUtil sharedInstance].chattingIsLogin){
            [self tableViewSelectedHandleInSubClasses:@"ADUserFriendsViewController"];
        }else{
            [self tableViewSelectedHandleInSubClasses:@"ADChattingLoginViewController"];
        }
#endif
    }else if(indexPath.section==2&&indexPath.row==0){
        [self getShareDeviceList];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

#pragma mark - UITableViewDataDelegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headTitle=@"";
    if (section==0) {
        headTitle=NSLocalizedStringFromTable(@"MyvehicleKey",@"MyString", @"");
        
    }else if (section==1){
        headTitle=NSLocalizedStringFromTable(@"MyauthorizethevehicleKey",@"MyString", @"");
    }else if (section==2){
        headTitle=NSLocalizedStringFromTable(@"othergroupKey",@"MyString", @"");
    }
    
    return headTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if ([_devicesModel.devices count]==0) {
            return 1;
        }
        return [_devicesModel.devices count];
    }else if(section==1){
        if([_devicesModel.authDevices count]==0){
            return 1;
        }
        return [_devicesModel.authDevices count];
    }else if (section==2){
//        return 2;
        return 1;
    }
    else{
        return 0;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section<2) {
        if(indexPath.section==0){
            return table_cell_device?0:51;
        }else if (indexPath.section==1){
            return table_cell_auth?0:51;
        }
        return 51;
    }else{
        
        return table_cell_other?0:42;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
    cell.imageView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.detailTextLabel.textColor=[UIColor lightGrayColor];
    
    if (indexPath.section==0) {
        if([_devicesModel.devices count]==0){
            cell.textLabel.text = NSLocalizedStringFromTable(@"NovehiclemanagementKey",@"MyString", @"");
        }else{
            ADDeviceBase *currentDeviceBase = [_devicesModel.devices objectAtIndex:indexPath.row];
            UIButton *buttonBind = [UIButton buttonWithType:UIButtonTypeCustom];
            buttonBind.frame = CGRectMake(WIDTH-60, 12, 50, 25);
            buttonBind.titleLabel.font=[UIFont systemFontOfSize:12];
//            buttonBind.enabled=NO;
            [buttonBind addTarget:self action:@selector(bindTap:) forControlEvents:UIControlEventTouchUpInside];
            buttonBind.tag=indexPath.row+1000;
            [cell.contentView addSubview:buttonBind];
            if(currentDeviceBase.bindedFlag){
                cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）",currentDeviceBase.licenseNumber,[currentDeviceBase.modelName substringFromIndex:2]];
                
                [buttonBind setBackgroundImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
                if(currentDeviceBase.activatedFlag){
                    [buttonBind setTitle:NSLocalizedStringFromTable(@"actived",@"MyString", @"") forState:UIControlStateNormal];
                }else{
                    [buttonBind setTitle:NSLocalizedStringFromTable(@"unActived",@"MyString", @"") forState:UIControlStateNormal];
                }
                if (currentDeviceBase.location!=nil) {
                    if(currentDeviceBase.latitude==0&&currentDeviceBase.longitude==0){
                        if(currentDeviceBase.lastLocation!=nil){
                            cell.detailTextLabel.text=[currentDeviceBase.lastLocation objectForKey:@"address_num"]==[NSNull null]?NSLocalizedStringFromTable(@"noLocation",@"MyString", @""):[currentDeviceBase.lastLocation objectForKey:@"address_num"];
                        }else{
                            cell.detailTextLabel.text=NSLocalizedStringFromTable(@"noLocation",@"MyString", @"");
                        }
                        
                    }else{
                       cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",currentDeviceBase.address_num]; 
                    }
                }else{
                    cell.detailTextLabel.text=NSLocalizedStringFromTable(@"noLocation",@"MyString", @"");
                }
                
                
            }else{
                cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）",currentDeviceBase.licenseNumber,[currentDeviceBase.modelName substringFromIndex:2]];
                [buttonBind setBackgroundImage:[UIImage imageNamed:@"undone.png"] forState:UIControlStateNormal];
                [buttonBind setTitle:NSLocalizedStringFromTable(@"UnboundKey",@"MyString", @"") forState:UIControlStateNormal];
//                cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",currentDeviceBase.address_num];
            }
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        NSString *server_url = [defaults objectForKey:@"server_url"];
//            NSString *urlAsString = [NSString stringWithFormat:@"%@picture/%@.jpg",server_url,currentDeviceBase.BrandID];
//            NSURL *url = [NSURL URLWithString:urlAsString];
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
//            cell.imageView.image=[UIImage imageWithData:imageData];
        }
        cell.hidden=table_cell_device;
    }else if (indexPath.section==1){
        if(_devicesModel.authDevices.count==0){
            cell.textLabel.text = NSLocalizedStringFromTable(@"UnlicensedvehiclesKey",@"MyString", @"");
        }else{
            ADDeviceBase *authDevice = [_devicesModel.authDevices objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@（%@）",authDevice.licenseNumber,[authDevice.modelName substringFromIndex:2]];
            
            if (authDevice.location!=nil) {
                if(authDevice.latitude==0&&authDevice.longitude==0){
                    if(authDevice.lastLocation!=nil){
                        cell.detailTextLabel.text=[authDevice.lastLocation objectForKey:@"address_num"]==[NSNull null]?NSLocalizedStringFromTable(@"noLocation",@"MyString", @""):[authDevice.lastLocation objectForKey:@"address_num"];
                    }else{
                        cell.detailTextLabel.text=NSLocalizedStringFromTable(@"noLocation",@"MyString", @"");
                    }
                }else{
                    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@",authDevice.address_num];
                }
            }else{
                cell.detailTextLabel.text=NSLocalizedStringFromTable(@"noLocation",@"MyString", @"");
            }
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        NSString *server_url = [defaults objectForKey:@"server_url"];
//            NSString *urlAsString = [NSString stringWithFormat:@"%@picture/%@.jpg",server_url,authDevice.BrandID];
//            NSURL *url = [NSURL URLWithString:urlAsString];
//            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//            NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
//            cell.imageView.image=[UIImage imageWithData:imageData];
        }
        cell.hidden=table_cell_auth;
    }else if (indexPath.section==2){
        
        if (indexPath.row==1) {
            if(![ADSingletonUtil sharedInstance].chattingIsLogin){
#ifdef HMC
                cell.textLabel.text = [NSString stringWithFormat:@"%@（未登录）", NSLocalizedStringFromTable(@"RidersKey",@"MyString", @"")];
#else
                cell.textLabel.text = [NSString stringWithFormat:@"%@（未开通）", NSLocalizedStringFromTable(@"RidersKey",@"MyString", @"")];
#endif

            }else{
                cell.textLabel.text=NSLocalizedStringFromTable(@"RidersKey",@"MyString", @"");
            }
            
            cell.imageView.image=[UIImage imageNamed:@"vehicle_list_friends.png"];
        }
//        else if (indexPath.row==1){
//            cell.textLabel.text=@"我管理的车辆";
//        }
        else if (indexPath.row==0){
            cell.textLabel.text=NSLocalizedStringFromTable(@"publicvehiclesKey",@"MyString", @"");
            cell.imageView.image=[UIImage imageNamed:@"vehicle_list_shared.png"];
        }
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
    cell.accessoryView=buttonRight;
    cell.hidden=table_cell_other;
    }
   
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,indexPath.section<2?50:40, WIDTH, 2)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"xiline.png"]];
    [cell addSubview:lineView];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton* b = (UIButton*)[cell viewWithTag:1000+indexPath.row];
    [UIView beginAnimations:@"" context:nil];
    [UIView animateWithDuration:0.5 animations:^{
        b.frame = CGRectMake(b.frame.origin.x-50, b.frame.origin.y, b.frame.size.width, b.frame.size.height);
        
    }];
    [UIView commitAnimations];
}

- (void)tableView:(UITableView *)tableView didEndEditingRowAtIndexPath:(NSIndexPath*)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    UIButton* b = (UIButton*)[cell viewWithTag:1000+indexPath.row];
    [UIView beginAnimations:@"" context:nil];
    [UIView animateWithDuration:0.5 animations:^{
        b.frame = CGRectMake(b.frame.origin.x+50, b.frame.origin.y, b.frame.size.width, b.frame.size.height);
        
    }];
    [UIView commitAnimations];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section==0){
        if(_devicesModel.devices.count==0){
            return NO;
        }
        return YES;
    }else{
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADDeviceBase *currentDeviceBase = [_devicesModel.devices objectAtIndex:indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"deleteKey",@"MyString", @"")];
        [_vehiclesModes deleteVehicleWithArguments:[NSArray arrayWithObject:currentDeviceBase.d_vin]];
    }
}

- (void)tableViewSelectedHandleInSubClasses:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)updateNickNameRequestSuccess:(NSNotification *)aNoti{
    NSString* fullname=[[ADSingletonUtil sharedInstance].userInfo objectForKey:@"fullname"];
    NSString *textWelcome=[NSString stringWithFormat:@"%@ \n%@",fullname,NSLocalizedStringFromTable(@"WelcometouseKey",@"MyString", @"")];
    _labelOfHeader.text=textWelcome;

}
- (void)deleteVehicleSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [self reloadTap:nil];
}

- (void)deleteVehicleFail:(NSNotification *)aNoti{
    NSDictionary *theDict = (NSDictionary*)aNoti.object;
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [IVToastHUD showAsToastErrorWithStatus:[theDict objectForKey:@"resultMsg"]];
//    [self reloadTap:nil];
}


- (void)requestAllDevicesSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_devicesModel requestAuthorizeDevicesWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].globalUserBase.userID, nil]];
}

- (void)requestAllDevicesFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
}

- (void)requestAllDevicesTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)requestAuthDevicesSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)requestAuthDevicesFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"networkAnomalyKey",@"MyString", @"")];
}

- (void)requestAuthDevicesTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)requestSharedDevicesSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

- (void)requestSharedDevicesFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"networkAnomalyKey",@"MyString", @"")];
}

- (void)requestSharedDevicesTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:NSLocalizedStringFromTable(@"networkTimeoutKey",@"MyString", @"")];
}

- (void)unbindDeviceSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [self reloadTap:nil];
}


/*
#pragma mark - ADCarsShowViewDelegate

- (void)ADCarsShowView:(ADCarsShowView *)carsShowView
       selectedChanged:(NSUInteger)aIndex isManual:(BOOL)aIsManual
{
    _isAutoNavigation = aIsManual;
    [NSObject cancelPreviousPerformRequestsWithTarget:nil];    //取消延迟执行函数
    ADDeviceBase *currentDeviceBase = [_devicesModel.devices objectAtIndex:aIndex];
//    _currentDeviceBase = [_devicesModel.devices objectAtIndex:aIndex];
    NSAssert(currentDeviceBase, @"selected device is not exist.");
    [ADSingletonUtil sharedInstance].currentDeviceBase = currentDeviceBase;
    [self requestDetailDeviceInfo:currentDeviceBase isContinue:NO];
}
*/

#pragma mark -ADAppDelegate
//取得当前程序的委托
-(ADAppDelegate *)appDelegate{
    
    return (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

//取得当前的XMPPStream
-(XMPPStream *)xmppStream{
    return [[self appDelegate] xmppStream];
}
@end
