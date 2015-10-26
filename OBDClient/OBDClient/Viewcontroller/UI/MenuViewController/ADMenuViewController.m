//
//  ADMenuViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuViewController.h"
#import "ADMenuCell.h"
#import "ADMainWindow.h"
#import "ADLoginViewController.h"
#define MENU_COMMON_CELL_ID                 @"com.anydata.obd.menu.cell"
#define MENU_ITEM_DATA_SOURCE_NAME          @"menuItemsOf1Section"
#define MENU_ITEM_NAME_INDEX              NSLocalizedStringFromTable(@"homeKey",@"MyString", @"")
#define MENU_ITEM_NAME_SUMMARY              NSLocalizedStringFromTable(@"summaryKey",@"MyString", @"")
#define MENU_ITEM_NAME_ALERT               NSLocalizedStringFromTable(@"alarmKey",@"MyString", @"")
#define MENU_ITEM_NAME_DTC                  @"DTC"
#define MENU_ITEM_NAME_HISTORY              NSLocalizedStringFromTable(@"historyKey",@"MyString", @"")
#define MENU_ITEM_NAME_LOCATION            NSLocalizedStringFromTable(@"locationKey",@"MyString", @"")
#define MENU_ITEM_NAME_HEALTHY              NSLocalizedStringFromTable(@"MaintenancereminderKey",@"MyString", @"")
#define MENU_ITEM_NAME_CARSMANAGE           NSLocalizedStringFromTable(@"CarsManageKey",@"MyString", @"")
#define MENU_ITEM_NAME_SETTING              NSLocalizedStringFromTable(@"settingKey",@"MyString", @"")
#define MENU_ITEM_NAME_HELP                 NSLocalizedStringFromTable(@"helpKey",@"MyString", @"")
#define MENU_ITEM_NAME_LOGOUT               NSLocalizedStringFromTable(@"logoffKey",@"MyString", @"")
#define MENU_ITEM_NAME_PERIPHERAL           NSLocalizedStringFromTable(@"peripheralKey",@"MyString", @"")
#define MENU_ITEM_SATATISTICS               NSLocalizedStringFromTable(@"StatisticsCenterKey",@"MyString", @"")
#define MENU_ITEM_TOOLS                     NSLocalizedStringFromTable(@"toolBoxKey",@"MyString", @"")


@implementation ADMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
    {
                
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    NSString *brandID=[ADSingletonUtil sharedInstance].currentDeviceBase.BrandID;
    if(![brandID isEqual:@""]){
//        NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
//        NSString *server_url = [defaults objectForKey:@"server_url"];
//        NSString *urlAsString = [NSString stringWithFormat:@"%@picture/%@.jpg",server_url,brandID];
//        NSURL *url = [NSURL URLWithString:urlAsString];
//        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
//        NSData *imageData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
//        [_button setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
//        _label.text=[ADSingletonUtil sharedInstance].currentDeviceBase.nickname;
        _label.text=[NSString stringWithFormat:@"%@\n%@（%@）",[ADSingletonUtil sharedInstance].globalUserBase.fullname,[ADSingletonUtil sharedInstance].currentDeviceBase.licenseNumber,[[ADSingletonUtil sharedInstance].currentDeviceBase.modelName substringFromIndex:2]];
        _label.numberOfLines=2;
    }
    
    if(![ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag){
        _menuDataSource = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSArray alloc] initWithObjects:MENU_ITEM_NAME_INDEX,[NSString stringWithFormat:@"%@（%@）",MENU_ITEM_NAME_LOCATION,@"受限"],[NSString stringWithFormat:@"%@（%@）",MENU_ITEM_NAME_HISTORY,@"受限"],[NSString stringWithFormat:@"%@（%@）",MENU_ITEM_NAME_PERIPHERAL,@"受限"],[NSString stringWithFormat:@"%@（%@）",MENU_ITEM_NAME_SUMMARY,@"受限"],[NSString stringWithFormat:@"%@（%@）",MENU_ITEM_NAME_HEALTHY,@"受限"],MENU_ITEM_NAME_CARSMANAGE,[NSString stringWithFormat:@"%@（%@）",MENU_ITEM_SATATISTICS,@"受限"],MENU_ITEM_TOOLS,MENU_ITEM_NAME_SETTING,nil], MENU_ITEM_DATA_SOURCE_NAME, nil];
    }else{
        _menuDataSource = [[NSDictionary alloc] initWithObjectsAndKeys:[[NSArray alloc] initWithObjects:MENU_ITEM_NAME_INDEX,MENU_ITEM_NAME_LOCATION,MENU_ITEM_NAME_HISTORY,MENU_ITEM_NAME_PERIPHERAL,MENU_ITEM_NAME_SUMMARY,MENU_ITEM_NAME_HEALTHY,MENU_ITEM_NAME_CARSMANAGE,MENU_ITEM_SATATISTICS,MENU_ITEM_TOOLS,MENU_ITEM_NAME_SETTING,nil], MENU_ITEM_DATA_SOURCE_NAME, nil];
    }
    [_tableView reloadData];
    [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:[ADSingletonUtil sharedInstance].selectMenuIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rect = CGRectMake(0, 0, WIDTH, 44);
    UIView *viewOfHeader = [[UIView alloc] initWithFrame:rect];
//    UIImage *barBkgImg = [UIImage imageNamed:@"app_topbar_bg.png"];
//    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:barBkgImg];
//    bgImageView.frame = rect;
//    [viewOfHeader addSubview:bgImageView];

//    UILabel *labelOfHeader=[[UILabel alloc]initWithFrame:rect];
//    labelOfHeader.text=[ADSingletonUtil sharedInstance].globalUserBase.uname;
//    labelOfHeader.textColor=[UIColor whiteColor];
//    labelOfHeader.textAlignment=NSTextAlignmentCenter;
//    labelOfHeader.backgroundColor=[UIColor clearColor];
//    [viewOfHeader addSubview:labelOfHeader];
    
//    _button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_button addTarget:self action:@selector(userManageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
//    _button.frame = CGRectMake(10, 5, 34, 34);
//    [_button setBackgroundImage:[UIImage imageNamed:@"menu_userPhoto.png"] forState:UIControlStateNormal];
//    [viewOfHeader addSubview:_button];
    
    
    _label = [[UILabel alloc]initWithFrame:CGRectMake(50, 5, 180, 34)];
    UIColor *labelColor = [UIColor lightGrayColor];
    _label.textColor = labelColor;
    _label.font=[UIFont boldSystemFontOfSize:12];
    _label.backgroundColor=[UIColor clearColor];
    [viewOfHeader addSubview:_label];
    
    UIButton *buttonUserCenter = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonUserCenter addTarget:self action:@selector(userManageButtonTap:) forControlEvents:UIControlEventTouchUpInside];
    buttonUserCenter.frame = CGRectMake(13, 9, 26, 26);
    [buttonUserCenter setBackgroundImage:[UIImage imageNamed:@"menu_userCenter_gray.png"] forState:UIControlStateNormal];
    [buttonUserCenter setBackgroundImage:[UIImage imageNamed:@"menu_userCenter_blue.png"] forState:UIControlStateHighlighted];
    [viewOfHeader addSubview:buttonUserCenter];
    
    [self.view addSubview:viewOfHeader];
    
    rect = self.view.bounds;
//    rect = CGRectMake(10, 44, self.view.bounds.size.width-20, self.view.bounds.size.height);
    rect.origin.y = 44;
    _tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;  //控件的宽度随着父视图的宽度按比例改变
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.scrollsToTop = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;   //设置tableview的分隔线为透明的
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_back.png"]];
    
    [ADSingletonUtil sharedInstance].selectMenuIndex=0;
    
    [self.view addSubview:_tableView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [viewOfHeader setFrame:CGRectMake(0, 20, WIDTH, 44)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=20;
        [_tableView setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [viewOfHeader setFrame:CGRectMake(0, 20, WIDTH, 44)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=20;
        [_tableView setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}

}

//将ADiPhoneUserManageViewController设置为导航栏的视图
- (void)userManageButtonTap:(id)sender
{
    [self tableViewSelectedHandleInSubClasses:@"ADiPhoneUserManageViewController"];
    
}

- (CGFloat)cellHeight
{
    return 40.0;
}

- (void)tableViewSelectedHandleInSubClasses:(NSString *)className
{
    //implement in subclasses.
}

//对tableView中的cell点击事件的处理函数
- (void)tableViewSelectedHandle:(NSIndexPath *)indexPath
{
    if([ADSingletonUtil sharedInstance].selectMenuIndex==indexPath.row){
        [self.slidingController resetFrontView];
        return;
    }
    [ADSingletonUtil sharedInstance].selectMenuIndex=indexPath.row;
    BOOL bindFlag=[ADSingletonUtil sharedInstance].currentDeviceBase.bindedFlag;
    NSString *menuName = [[_menuDataSource objectForKey:MENU_ITEM_DATA_SOURCE_NAME] objectAtIndex:indexPath.row];
    NSString *className = nil;
    if ([MENU_ITEM_NAME_SUMMARY isEqualToString:menuName]) {
        className = @"ADiPhoneSummaryViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
        
    } else if ([MENU_ITEM_NAME_ALERT isEqualToString:menuName]) {
        className = @"ADiPhoneAlertViewController";
        
    } else if ([MENU_ITEM_NAME_DTC isEqualToString:menuName]) {
        className = @"ADiPhoneDTCsViewController";
        
    } else if ([MENU_ITEM_NAME_HISTORY isEqualToString:menuName]) {
        className = @"ADiPhoneHistoryViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
        
    } else if ([MENU_ITEM_NAME_LOCATION isEqualToString:menuName]) {
        className = @"ADiPhoneLocationViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
        
    }else if ([MENU_ITEM_NAME_PERIPHERAL isEqualToString:menuName]) {
        className = @"PeripheralViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
        
    }else if ([MENU_ITEM_NAME_CARSMANAGE isEqualToString:menuName]) {
        className = @"ADiPhoneCarsManageViewController";
        
    } else if ([MENU_ITEM_NAME_HEALTHY isEqualToString:menuName]) {
        className = @"ADiPhoneHealthyViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
        
    } else if ([MENU_ITEM_NAME_SETTING isEqualToString:menuName]) {
        className = @"ADiPhoneSettingViewController";
        
    } else if ([MENU_ITEM_NAME_HELP isEqualToString:menuName]) {
        className = @"ADiPhoneHelpViewController";
        return;

    } else if ([MENU_ITEM_SATATISTICS isEqualToString:menuName]) {
        className = @"ADSatatisticsViewController";
        if(!bindFlag){
            [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
            return;
        }
    } else if ([MENU_ITEM_TOOLS isEqualToString:menuName]) {
        className = @"ADToolsViewController";
    }else if ([MENU_ITEM_NAME_INDEX isEqualToString:menuName]){
        className = @"CarAssistantViewController";
    }
    
    
    
//    else if ([MENU_ITEM_NAME_LOGOUT isEqualToString:menuName]) {
//        className = @"ADiPhoneLoginViewController";
//        [(ADMainWindow *)self.view.window transitionToLoginViewController];
//        return;
//    }
    else{
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"unbindInfo",@"MyString", @"")];
        return;
    }
    [self tableViewSelectedHandleInSubClasses:className];
}



#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self tableViewSelectedHandle:indexPath];
}


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellHeight];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[_menuDataSource objectForKey:MENU_ITEM_DATA_SOURCE_NAME] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ADMenuCell *menuCell = [_tableView dequeueReusableCellWithIdentifier:MENU_COMMON_CELL_ID];
    if (!menuCell) {
        menuCell = [[ADMenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:MENU_COMMON_CELL_ID];
    }
    
    menuCell.textLabel.text = [[_menuDataSource objectForKey:MENU_ITEM_DATA_SOURCE_NAME] objectAtIndex:indexPath.row];
    menuCell.imageView.image = [self cellImageByIndexPath:indexPath];
    return menuCell;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIImage *)cellImageByIndexPath:(NSIndexPath *)aIndexPath
{
    int row = aIndexPath.row;
    NSString *imagePath = nil;
    if (row == 0) {
        imagePath = @"menu_index.png";
    } else if (row == 1) {
        imagePath = @"menu_location.png";
    }
    else if (row == 2) {
        imagePath = @"menu_history.png";
    }
    else if (row == 3) {
        imagePath = @"menu_area.png";
    }
    else if (row == 4) {
        imagePath = @"menu_summary.png";
    } else if (row == 5) {
        imagePath = @"menu_maintain.png";
    } else if (row == 6) {
        imagePath = @"menu_manager.png";
    } else if (row == 7) {
        imagePath = @"menu_satatistics.png";
    } else if (row == 8) {
        imagePath = @"menu_tools.png";
    } else if (row == 9) {
        imagePath = @"menu_setting.png";
    }
//    else if (row == 8) {
//        imagePath = @"app_menu_logout.png";
//    }
    return [UIImage imageNamed:imagePath];
}



@end