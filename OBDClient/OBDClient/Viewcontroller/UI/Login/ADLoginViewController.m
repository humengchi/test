//
//  ADLoginViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADLoginViewController.h"
#import "ADUserBase.h"
#import "ADMainWindow.h"
#import "IVToastHUD.h"
#import "RegisterViewController.h"
#import "ADUserNameCell.h"
//#import "JSONKit.h"

#ifdef DEBUG
#define LOGIN_USER_NAME     @"todd"
#define LOGIN_USER_PWD      @"demo"
#else
#define LOGIN_USER_NAME     @""
#define LOGIN_USER_PWD      @""
#endif

@interface ADLoginViewController ()<UIAlertViewDelegate, NSURLConnectionDelegate, NSURLConnectionDataDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) NSArray *dataItems;

@end

@implementation ADLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userDetailModel = [[ADUserDetailModel alloc] init];
        [_userDetailModel addObserver:self
                           forKeyPath:KVO_LOGIN_USERDETAIL_PATH_NAME
                              options:NSKeyValueObservingOptionNew
                              context:NULL];
        
                
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(calculator)
//                                                     name:UITextFieldTextDidChangeNotification
//                                                   object:nil];
        
        _devicesModel = [[ADDevicesModel alloc] init];
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

        //对不同的通知进行响应的处理
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestDataError:)
                                                     name:ADUserDetailModelRequestDataErrorNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestFail:)
                                                     name:ADUserDetailModelRequestFailNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestSuccess:)
                                                     name:ADUserDetailModelRequestSuccessNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestTimeout:)
                                                     name:ADUserDetailModelRequestTimeoutNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestLoginFail:)
                                                     name:ADUserDetailModelRequestUserLoginFailNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bindChannelSuccess:)
                                                     name:ADUserBindChannelSuccessNotification
                                                   object:nil];
#ifdef HMC
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(noticeLgoinIsSuccess:)
                                                     name:@"NoticeChattingLoginIsSuccess"
                                                   object:nil];
#endif
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
//    [_devicesModel removeObserver:self
//                       forKeyPath:KVO_ALL_DEVICES_PATH_NAME];
//    [_devicesModel removeObserver:self
//                       forKeyPath:KVO_AUTH_DEVICES_PATH_NAME];
//    [_devicesModel removeObserver:self
//                       forKeyPath:KVO_SHARED_DEVICES_PATH_NAME];
}

- (void)dealloc
{
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_ALL_DEVICES_PATH_NAME];
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_AUTH_DEVICES_PATH_NAME];
    [_devicesModel removeObserver:self
                       forKeyPath:KVO_SHARED_DEVICES_PATH_NAME];
    
    
    [_userDetailModel removeObserver:self
                          forKeyPath:KVO_LOGIN_USERDETAIL_PATH_NAME];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADUserDetailModelRequestDataErrorNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADUserDetailModelRequestFailNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADUserDetailModelRequestSuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADUserDetailModelRequestTimeoutNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADUserDetailModelRequestUserLoginFailNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADUserBindChannelSuccessNotification
                                                  object:nil];
#ifdef HMC
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"NoticeChattingLoginIsSuccess"
                                                  object:nil];
#endif
    
    [_userDetailModel cancel];
}


//监听是否登录成功
- (void)noticeLgoinIsSuccess:(NSNotification*)notification
{
#ifdef HMC
    NSString *string = [notification object];
    if([string isEqualToString:@"success"]){
        [ADSingletonUtil sharedInstance].chattingIsLogin = YES;
    }else{
        [ADSingletonUtil sharedInstance].chattingIsLogin = NO;
    }
#endif
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _userDetailModel) {
        if ([keyPath isEqualToString:KVO_LOGIN_USERDETAIL_PATH_NAME]) {
            //success.
            return;
        }
    }
    if (object == _devicesModel) {
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:@""];
        if ([keyPath isEqualToString:KVO_ALL_DEVICES_PATH_NAME]) {
            [ADSingletonUtil sharedInstance].devices = _devicesModel.devices;
            if(_devicesModel.devices.count>0){
                [ADSingletonUtil sharedInstance].currentDeviceBase = ((ADDeviceBase *)[[ADSingletonUtil sharedInstance].devices objectAtIndex:0]);
                [(ADMainWindow *)self.view.window transitionToCarAssistantViewController];
//                if ([ADSingletonUtil sharedInstance].autoMsgCenter) {
//                    MessageViewController* msgViewController=[[MessageViewController alloc]init];
//                    [self.navigationController pushViewController:msgViewController animated:YES];
//                    [ADSingletonUtil sharedInstance].selectMenuIndex=0;
//                    [ADSingletonUtil sharedInstance].autoMsgCenter=NO;
//                }
            }else{
                [(ADMainWindow *)self.view.window transitionToMainViewController];
            }
            return;
        } else if ([keyPath isEqualToString:KVO_AUTH_DEVICES_PATH_NAME]){
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef HMC
    //监听车友聊天是否成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noticeLgoinIsSuccess:) name:@"NoticeChattingLoginIsSuccess" object:nil];
#endif
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg.png"]];
    
    _userLabel.text=NSLocalizedStringFromTable(@"loginLabelKey",@"MyString", @"");
    [_loginBtn setTitle:NSLocalizedStringFromTable(@"loginKey",@"MyString", @"") forState:UIControlStateNormal];
    
    [_visitorLoginBtn setTitle:NSLocalizedStringFromTable(@"visitorKey",@"MyString", @"") forState:UIControlStateNormal];
    
    [_registerBtn setTitle:NSLocalizedStringFromTable(@"registerKey",@"MyString", @"") forState:UIControlStateNormal];
    
//    _loginBtn.enabled = NO;
//    _visitorLoginBtn.enabled = NO;
//    _registerBtn.enabled = NO;
    _loginBtn.enabled = YES;
    _visitorLoginBtn.enabled = YES;
    _registerBtn.enabled = YES;
    _userNameTextField.placeholder=NSLocalizedStringFromTable(@"userNameKey",@"MyString", @"");
    _passwordTextField.placeholder=NSLocalizedStringFromTable(@"passwordKey",@"MyString", @"");
    
    [_userIconImgView setBackgroundColor:[UIColor clearColor]];

    [_userNameTextField setBackgroundColor:[UIColor clearColor]];
    
    _userNameTextField.delegate=self;
    _passwordTextField.delegate=self;
    
    [_userNameTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [_passwordTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor blackColor];
    _tableView.hidden=YES;
    [self.view addSubview:_tableView];
    
    _matchArray=[[NSMutableArray alloc]initWithCapacity:10];
    _userNameTableView=[[UITableView alloc]initWithFrame:CGRectMake(39, 315, WIDTH-78, 35) style:UITableViewStylePlain];
    _userNameTableView.delegate=self;
    _userNameTableView.dataSource=self;
//    [_userNameTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"_0010_password.png"]]];
    [_userNameTableView setBackgroundColor:[UIColor whiteColor]];
    _userNameTableView.hidden=YES;
    [self.view addSubview:_userNameTableView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_loginBtn.frame;
        frame.origin.y+=20;
        [_loginBtn setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=20;
        [_ImgViewOne setFrame:frame];
        
        frame=_registerBtn.frame;
        frame.origin.y+=20;
        [_registerBtn setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=20;
        [_ImgViewTwo setFrame:frame];
        
        frame=_visitorLoginBtn.frame;
        frame.origin.y+=20;
        [_visitorLoginBtn setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=20;
        [_ImgViewThree setFrame:frame];
        
        frame=_ImgViewFour.frame;
        frame.origin.y+=20;
        [_ImgViewFour setFrame:frame];
        
        frame=_userLabel.frame;
        frame.origin.y+=20;
        [_userLabel setFrame:frame];
        
        frame=_ImgViewFive.frame;
        frame.origin.y+=20;
        [_ImgViewFive setFrame:frame];
        
        frame=_userIconImgView.frame;
        frame.origin.y+=20;
        [_userIconImgView setFrame:frame];
        
        frame=_userNameTextField.frame;
        frame.origin.y+=20;
        [_userNameTextField setFrame:frame];
        
        frame=_ImgViewSix.frame;
        frame.origin.y+=20;
        [_ImgViewSix setFrame:frame];
        
        frame=_ImgViewSeven.frame;
        frame.origin.y+=20;
        [_ImgViewSeven setFrame:frame];
        
        frame=_passwordTextField.frame;
        frame.origin.y+=20;
        [_passwordTextField setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_loginBtn.frame;
        frame.origin.y+=70;
        frame.size.height=22;
        [self.loginBtn setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=70;
        [_ImgViewOne setFrame:frame];
        
        frame=_visitorLoginBtn.frame;
        frame.origin.y+=77;
        frame.size.height=16;
        [_visitorLoginBtn setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=77;
        [_ImgViewThree setFrame:frame];
        
        frame=_registerBtn.frame;
        frame.origin.y+=83;
        frame.size.height=4;
        [_registerBtn setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=83;
        [_ImgViewTwo setFrame:frame];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_loginBtn.frame;
        frame.origin.y+=90;
        frame.size.height=22;
        [self.loginBtn setFrame:frame];
        
        frame=_ImgViewOne.frame;
        frame.origin.y+=90;
        [_ImgViewOne setFrame:frame];
        
        frame=_registerBtn.frame;
        frame.origin.y+=103;
        frame.size.height=4;
        [_registerBtn setFrame:frame];
        
        frame=_ImgViewTwo.frame;
        frame.origin.y+=103;
        [_ImgViewTwo setFrame:frame];
        
        frame=_visitorLoginBtn.frame;
        frame.origin.y+=97;
        frame.size.height=16;
        [_visitorLoginBtn setFrame:frame];
        
        frame=_ImgViewThree.frame;
        frame.origin.y+=93;
        [_ImgViewThree setFrame:frame];
        
        frame=_ImgViewFour.frame;
        frame.origin.y+=20;
        [_ImgViewFour setFrame:frame];
        
        frame=_userLabel.frame;
        frame.origin.y+=20;
        [_userLabel setFrame:frame];
        
        frame=_ImgViewFive.frame;
        frame.origin.y+=20;
        [_ImgViewFive setFrame:frame];
        
        frame=_userIconImgView.frame;
        frame.origin.y+=20;
        [_userIconImgView setFrame:frame];
        
        frame=_userNameTextField.frame;
        frame.origin.y+=20;
        [_userNameTextField setFrame:frame];
        
        frame=_ImgViewSix.frame;
        frame.origin.y+=20;
        [_ImgViewSix setFrame:frame];
        
        frame=_ImgViewSeven.frame;
        frame.origin.y+=20;
        [_ImgViewSeven setFrame:frame];
        
        frame=_passwordTextField.frame;
        frame.origin.y+=20;
        [_passwordTextField setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}

    
    if([ADSingletonUtil sharedInstance].firstLogin){
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString* userName = [defaults objectForKey:@"userName"];
        NSString* pwd = [defaults objectForKey:@"pwd"];
//        NSArray *userNameArray = [defaults objectForKey:@"userNameArray"];
//        NSArray *pwdArray = [defaults objectForKey:@"pwdArray"];
       //        NSLog(@"%@__%@",userName,pwd);
        if((userName != nil) && (pwd!=nil)){
            _userNameTextField.text=userName;
            _passwordTextField.text=pwd;
            if([ADSingletonUtil sharedInstance].autoMsgCenter){
                [self.userDetailModel startCallWithArguments:[NSArray arrayWithObjects:userName, pwd, nil]];
            }
            
        }
    }
    [ADSingletonUtil sharedInstance].firstLogin=NO;
    
    
    //检测版本更新
    
//    NSString *URL = @"http://itunes.apple.com/lookup?id=789620165";
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//    [request setURL:[NSURL URLWithString:URL]];
//    [request setHTTPMethod:@"POST"];
//    NSHTTPURLResponse *urlResponse = nil;
//    NSError *error = nil;
//    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    
//    NSDictionary *dic = [recervedData objectFromJSONData];
//    NSString *newVersion = [[[dic objectForKey:@"results"] objectAtIndex:0] objectForKey:@"version"];
//    self.trackViewUrl = [[[dic objectForKey:@"results"] objectAtIndex:0] objectForKey:@"trackViewUrl"];
//    //检测当前的版本号是否为最新的
//    NSString* thisVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString*)kCFBundleVersionKey];
//    
//    if(thisVersion != nil && newVersion != nil){
//        if(![thisVersion isEqualToString:newVersion]){
//            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isIgnore"] isEqualToString:@"yes"]){
//                return;
//            }
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"更新提示" message:[NSString stringWithFormat:@"有新版本（v%@），是否更新！", newVersion] delegate:self cancelButtonTitle:@"不再提示" otherButtonTitles:@"立即更新", @"下次再说",  nil];
//            alertView.tag = 222;
//            [alertView show];
//        }else{
//            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"isIgnore"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
//    }
}

- (void)viewWillAppear:(BOOL)animated{
    _dataItems=@[@"25服务器",@"163服务器",@"163开发服务器",@"203服务器",@"203开发服务器",@"25开发服务器", @"大众服务器", @"重庆服务器"];
    
}

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
    if ([tableView isEqual:_tableView]) {
        return _dataItems.count;
    }else{
        return [_matchArray count];
    }
    
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_tableView]) {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *server_name = [defaults objectForKey:@"server_name"];
        //    NSLog(@"%@",server_name);
        if ([server_name isEqualToString:_dataItems[indexPath.row]]) {
            cell.accessoryType=UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text=_dataItems[indexPath.row];
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
        cell.backgroundColor=[UIColor whiteColor];
        return cell;
    }
    if ([tableView isEqual:_userNameTableView]){
        static NSString *cellIdentifier=@"ADUserNameCell";
        ADUserNameCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell==nil)
        {
            NSArray* cellArray=[[NSBundle mainBundle] loadNibNamed:@"ADUserNameCell" owner:self options:nil];
            cell=(ADUserNameCell*)[cellArray objectAtIndex:0];
            
        }
        cell.userNameLabel.text=[[_matchArray objectAtIndex:indexPath.row]objectForKey:@"userName"];
        return  cell;
    }
    return nil;
    // Configure the cell...
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_tableView]) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        if(indexPath.row==0){
            [defaults setObject:@"http://114.80.200.25:80/" forKey:@"server_url"];
            [defaults setObject:@"http://114.80.200.25:80/zend_obd/" forKey:@"server_url_zend"];
        }else if (indexPath.row==1){
            [defaults setObject:@"http://180.166.124.142:9983/" forKey:@"server_url"];
            [defaults setObject:@"http://180.166.124.142:9983/zend_obd/" forKey:@"server_url_zend"];
        }else if (indexPath.row==2){
            [defaults setObject:@"http://180.166.124.142:9983/" forKey:@"server_url"];
            [defaults setObject:@"http://180.166.124.142:9983/zend_obd_dev/" forKey:@"server_url_zend"];
        }
        else if (indexPath.row==3){
            [defaults setObject:@"http://180.166.124.142:9969/" forKey:@"server_url"];
            [defaults setObject:@"http://180.166.124.142:9969/zend_obd/" forKey:@"server_url_zend"];
        }
        else if (indexPath.row==4){
            [defaults setObject:@"http://180.166.124.142:9969/" forKey:@"server_url"];
            [defaults setObject:@"http://180.166.124.142:9969/zend_obd_dev/" forKey:@"server_url_zend"];
        }else if (indexPath.row==5){
            [defaults setObject:@"http://114.80.200.25:80/" forKey:@"server_url"];
            [defaults setObject:@"http://114.80.200.25:80/zend_obd_dev/" forKey:@"server_url_zend"];
        }else if (indexPath.row==6){
            [defaults setObject:@"http://222.66.84.166:80/" forKey:@"server_url"];
            [defaults setObject:@"http://222.66.84.166:80/zend_obd/" forKey:@"server_url_zend"];
        }else if (indexPath.row==7){
            [defaults setObject:@"http://113.207.27.147:81/" forKey:@"server_url"];
            [defaults setObject:@"http://113.207.27.147:81/zend_obd/" forKey:@"server_url_zend"];
        }
        [defaults setObject:_dataItems[indexPath.row] forKey:@"server_name"];
        [defaults synchronize];
        [_tableView setHidden:YES];
        
        NSString *vcStr = @"ADiPhoneLoginViewController";
        UIViewController *loginVC = [[NSClassFromString(vcStr) alloc] initWithNibName:nil bundle:nil]; //创建登录的试图控制器类
        [(ADMainWindow *)self.view.window setRootViewController:loginVC animated:NO];  //设置窗口的root视图控制器为登录试图控制器
    }
    if ([tableView isEqual:_userNameTableView]) {
        NSDictionary* dic=[_matchArray objectAtIndex:indexPath.row];
        _userNameTextField.text=[dic objectForKey:@"userName"];
        _passwordTextField.text=[dic objectForKey:@"pwd"];
        _userNameTableView.hidden=YES;
    }
}



//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:_passwordTextField]) {
        _userNameTableView.hidden=YES;
    }
//    if ([textField isEqual:_userNameTextField]) {
//        if (_userNameTextField.text.length!=0) {
//            _userNameTableView.hidden=NO;
//        }
//    }
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    float Y = -90.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 20.0f;
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        Y=0.0f;
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        Y=0.0f;
	}

    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender == self.userNameTextField){
        [self.passwordTextField becomeFirstResponder];
    }else if (sender == self.passwordTextField) {
        [self.view endEditing:YES];
        [self resumeView];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self resumeView];
}

- (IBAction)loginTap:(id)sender
{
    [self.view endEditing:YES];
    [self resumeView];
    
    NSString *userName = self.userNameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    if([userName isEqualToString:@"*#06#"]){
        _tableView.hidden=NO;
        return;
    }
    
    if ([userName isEqualToString:@""]||[pwd isEqualToString:@""]) {
        [IVToastHUD showErrorWithStatus:@"请输入用户名和密码"];
    }else{
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSString *userName = self.userNameTextField.text;
        NSString *pwd = self.passwordTextField.text;
//        
//        NSArray *userNameArray = [defaults objectForKey:@"userName"];
//        NSArray *pwdArray = [defaults objectForKey:@"pwd"];
//        NSMutableArray* userNameMutableArray=[[NSMutableArray alloc]initWithArray:userNameArray];
//        NSMutableArray* pwdMutableArray=[[NSMutableArray alloc]initWithArray:pwdArray];
//
//        [userNameMutableArray addObject:userName];
//        [pwdMutableArray addObject:pwd];
//        [defaults setObject:userNameMutableArray forKey:@"userName"];
//        [defaults setObject:pwdMutableArray forKey:@"pwd"];
//        [defaults synchronize];
        
        [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];  //在连接服务器的时候在中间显示正在加载中
        [self.userDetailModel startCallWithArguments:[NSArray arrayWithObjects:userName, pwd, nil]];  //向服务器发送请求
#ifdef HMC
        //=======================================车友登录=========================================
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"chattingConnect" object:nil];
#ifdef LOGIN_XMPP
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:_userNameTextField.text forKey:USERID];
        [defaults setObject:_passwordTextField.text forKey:PASS];
        [defaults synchronize];
#endif
        [[NSNotificationCenter defaultCenter] postNotificationName:@"chattingConnect" object:nil];
#endif
        

    }
}

- (IBAction)registerButton:(id)sender {
    RegisterViewController* registerViewController=[[RegisterViewController alloc]initWithNibName:@"RegisterViewController" bundle:nil];
//    [self.navigationController pushViewController:registerViewController animated:NO];
    [self presentViewController:registerViewController animated:YES completion:nil];
//    [(ADMainWindow*)self.view.window setRootViewController:registerViewController];
}

- (IBAction)visitorTap:(id)sender{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];  //在连接服务器的时候在中间显示正在加载中
    NSString *userName = @"todd";
    NSString *pwd = @"demo";
    self.userNameTextField.text=userName;
    self.passwordTextField.text=pwd;
    [self.userDetailModel startCallWithArguments:[NSArray arrayWithObjects:userName, pwd, nil]];  //向服务器发送请求
    
#ifdef HMC
    //=======================================车友登录=========================================
    
#ifdef LOGIN_XMPP
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:userName forKey:USERID];
    [defaults setObject:pwd forKey:PASS];
    [defaults synchronize];
#endif
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chattingConnect" object:nil];
#endif
    

}

- (IBAction)userNameMatch:(id)sender {
    NSString* matchStr=_userNameTextField.text;
    NSInteger length=[matchStr length];
    
    if (length>0) {
        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
        NSArray *userNameArray = [defaults objectForKey:@"userNameArray"];
        NSArray *pwdArray = [defaults objectForKey:@"pwdArray"];
        
        [_matchArray removeAllObjects];
        
        if ([userNameArray count]>0) {
            for (int i=0; i<[userNameArray count]; i++) {
                if (length<=[[userNameArray objectAtIndex:i] length]) {
                    _str=[[userNameArray objectAtIndex:i] substringToIndex:length];
//                    NSLog(@"%@",_str);
                    
                    if ([_str isEqualToString:matchStr]) {
                        NSDictionary* dic=[[NSDictionary alloc]initWithObjectsAndKeys:[userNameArray objectAtIndex:i],@"userName",[pwdArray objectAtIndex:i],@"pwd", nil];
                        [_matchArray addObject:dic];
                        
                    }
                }
            }
            
            [_userNameTableView reloadData];
        }
        
        if ([_matchArray count]==0) {
            _userNameTableView.hidden=YES;
        }else{
            _userNameTableView.hidden=NO;
            CGRect frame=_userNameTableView.frame;
            if ([_matchArray count]>3) {
                frame.size.height=105;
            }else{
                frame.size.height=35*[_matchArray count];
            }
            
            [_userNameTableView setFrame:frame];
        }

    }
    
    
}




#pragma mark - Request handle

- (void)requestSuccess:(NSNotification *)aNoti
{
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *userName = self.userNameTextField.text;
    NSString *pwd = self.passwordTextField.text;
    
    [defaults setObject:userName forKey:@"userName"];
    [defaults setObject:pwd forKey:@"pwd"];
    
    NSArray *userNameArray = [defaults objectForKey:@"userNameArray"];
    NSArray *pwdArray = [defaults objectForKey:@"pwdArray"];
    
    int flag=0;
    for (NSString* uname in userNameArray) {
        if ([uname isEqualToString:userName]) {
            flag=1;
        }
    }
    if (flag==0) {
        NSMutableArray* userNameMutableArray=[[NSMutableArray alloc]initWithArray:userNameArray];
        NSMutableArray* pwdMutableArray=[[NSMutableArray alloc]initWithArray:pwdArray];
        
        [userNameMutableArray addObject:userName];
        [pwdMutableArray addObject:pwd];
        [defaults setObject:userNameMutableArray forKey:@"userNameArray"];
        [defaults setObject:pwdMutableArray forKey:@"pwdArray"];
        [defaults synchronize];
    }

//    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:@""];
    
    NSString *channelid=[ADSingletonUtil sharedInstance].push_channelid;
    NSString *userid=[ADSingletonUtil sharedInstance].push_userid;
    NSString *userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    
    [_userDetailModel bindPushChannelWithArguments:[NSArray arrayWithObjects:userID,channelid,userid,@"1", nil]];
    //建立用户id和百度云推送id的关联
    NSLog(@"%@ %@ %@",userID,channelid,userid);
//    [(ADMainWindow *)self.view.window transitionToMainViewController];
}

- (void)bindChannelSuccess:(NSNotification *)aNoti{
//    [(ADMainWindow *)self.view.window transitionToMainViewController];
    NSString *userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
//    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_devicesModel requestAllDevicesWithArguments:[NSArray arrayWithObjects:userID,nil]];
}

- (void)requestFail:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
}

- (void)requestTimeout:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_TIMEOUT message:@"网络超时"];
}

- (void)requestDataError:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"网络异常"];
}

- (void)requestLoginFail:(NSNotification *)aNoti
{
     [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
}

- (void)viewDidUnload {
    [self setUserIconImgView:nil];
    [self setLoginBtn:nil];
    [self setRegisterBtn:nil];
    [super viewDidUnload];
}


@end
