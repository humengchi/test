//
//  ADUserInfoSettingViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserInfoSettingViewController.h"
#import "ADUserInfoEditViewController.h"
#import "ADUserNicknameEditViewController.h"
#import "ADMainWindow.h"

@interface ADUserInfoSettingViewController ()<ADEditUserInfoDelegate,ADEditUserNicknameDelegate>
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) ADUserBase *userInfo;
@end

@implementation ADUserInfoSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _userModel = [[ADUserDetailModel alloc]init];
        [_userModel addObserver:self forKeyPath:KVO_USER_INFO_PATH_NAME options:NSKeyValueObservingOptionNew context:nil];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(userInfoRequestSuccess:)
                           name:ADUserInfoRequestSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(userInfoUpdateSuccess:)
                           name:ADUserInfoUpdateSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(userNicknameUpdateSuccess:)
                           name:ADUserUserNicknameUpdateSuccessNotification
                         object:nil];
        
    }
    return self;
}

- (void)dealloc{
    [_userModel removeObserver:self forKeyPath:KVO_USER_INFO_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self name:ADUserInfoRequestSuccessNotification object:nil];
    [notiCenter removeObserver:self name:ADUserInfoUpdateSuccessNotification object:nil];
    [notiCenter removeObserver:self name:ADUserUserNicknameUpdateSuccessNotification object:nil];
    [_userModel cancel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _userModel) {
        if ([keyPath isEqualToString:KVO_USER_INFO_PATH_NAME]) {
            if(_userModel.userInfo==nil){
                [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
            }else{
                [_tableView reloadData];
            }
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

-(void)userInfoRequestSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}

-(void)userInfoUpdateSuccess:(NSNotification *)aNoti{
    [IVToastHUD showAsToastSuccessWithStatus:NSLocalizedStringFromTable(@"newpswsuccess",@"MyString", @"")];
    [(ADMainWindow *)self.view.window transitionToLoginViewController];
}
-(void)userNicknameUpdateSuccess:(NSNotification *)aNoti{
    [_userModel requestUserInfoWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].globalUserBase.userID]];
}



- (void)viewWillAppear:(BOOL)animated{
    self.title=NSLocalizedStringFromTable(@"userInfoSettingKey",@"MyString", @"");
    UIBarButtonItem *pswChangeButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"updateNickname",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(editTap:)];
    
//    UIBarButtonItem *editButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"resetPsw",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(resetPswTap:)];
    
    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:pswChangeButton, nil];
    if (IOS7_OR_LATER) {
        pswChangeButton.tintColor=[UIColor lightGrayColor];
    }
}

- (void) editContactViewController:(ADUserInfoEditViewController *) editController didEditContact:(NSArray * ) contact{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_userModel updateUserInfoWithArguments:contact];
}

- (void)resetPswTap:(id)sender{
    ADUserInfoEditViewController *editView=[[ADUserInfoEditViewController alloc]init];
    editView.userInfo=_userModel.userInfo;
    editView.delegate=self;
    [self.navigationController pushViewController:editView animated:NO];
}

- (void)editTap:(id)sender{
    ADUserNicknameEditViewController *editView=[[ADUserNicknameEditViewController alloc]init];
    editView.delegate=self;
    [self.navigationController pushViewController:editView animated:YES];
}

- (void) editNicknameViewController:(ADUserNicknameEditViewController *) editController didEditContact:(NSArray * ) contact{
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_userModel updateUserNicknameWithArguments:contact];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    UIButton * cgPswButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cgPswButton setFrame:CGRectMake(10, 350, 300, 40)];
    [cgPswButton setBackgroundImage:[UIImage imageNamed:@"_0001_Shape-8.png"] forState:UIControlStateNormal];
    [cgPswButton setTitle:NSLocalizedStringFromTable(@"resetPsw",@"MyString", @"") forState:UIControlStateNormal];
    cgPswButton.titleLabel.font=[UIFont boldSystemFontOfSize:14];
    [cgPswButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [cgPswButton addTarget:self action:@selector(resetPswTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cgPswButton];
    
    if (IOS7_OR_LATER) {
        [cgPswButton setFrame:CGRectMake(10, 414, 300, 40)];
    }
    
    _dataItems=[NSArray arrayWithObjects:
                NSLocalizedStringFromTable(@"userNameKey",@"MyString", @""),
                NSLocalizedStringFromTable(@"userFullnameKey",@"MyString", @""),
//                NSLocalizedStringFromTable(@"smsNumKey",@"MyString", @""),
//                NSLocalizedStringFromTable(@"emailKey",@"MyString", @""),
                NSLocalizedStringFromTable(@"registerDateKey",@"MyString", @""), nil];
    
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_userModel requestUserInfoWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].globalUserBase.userID]];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    cell.backgroundColor=[UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    
    
    if(indexPath.row==0){
        cell.detailTextLabel.text=[_userModel.userInfo objectForKey:@"uname"];
    }
    else if (indexPath.row==1){
        cell.detailTextLabel.text=[_userModel.userInfo objectForKey:@"fullname"];
    }
//    else if (indexPath.row==2){
//        cell.detailTextLabel.text=[_userModel.userInfo objectForKey:@"smsNum"];
//    }
//    else if (indexPath.row==3){
//        cell.detailTextLabel.text=[_userModel.userInfo objectForKey:@"email"];
//    }
    else if(indexPath.row==2){
        cell.detailTextLabel.text=[_userModel.userInfo objectForKey:@"registerDate"];
    }
    // Configure the cell...
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
