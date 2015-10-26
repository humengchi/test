//
//  ADMessageSettingViewController.m
//  OBDClient
//
//  Created by hys on 10/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMessageSettingViewController.h"

@interface ADMessageSettingViewController ()
{
    int first;
}

@end

@implementation ADMessageSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _getMessageNotifactionSwitchModel=[[ADGetMessageNotifactionSwitchModel alloc]init];
        _setMessageNotifactionSwitchModel=[[ADSetMessageNotifactionSwitchModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    first = 1;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    self.title=@"消息设置";
//    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
	// Do any additional setup after loading the view.
    
    _statusTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 436) style:UITableViewStylePlain];
    [_statusTableView setBackgroundColor:[UIColor clearColor]];
    _statusTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _statusTableView.delegate=self;
    _statusTableView.dataSource=self;
    [self.view addSubview:_statusTableView];

    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_statusTableView setFrame:CGRectMake(0, 64, WIDTH, 436)];
        [self setExtraCellLineHidden:_statusTableView];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_statusTableView setFrame:CGRectMake(0, 0, WIDTH, 504)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_statusTableView setFrame:CGRectMake(0, 64, WIDTH, 504)];
        [self setExtraCellLineHidden:_statusTableView];

	}

    _statusArray=[NSMutableArray arrayWithCapacity:20];
    
    NSString* userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_getMessageNotifactionSwitchModel startCallWithArguments:[NSArray arrayWithObjects:userID, nil]];
    _getMessageNotifactionSwitchModel.getMessageNotifactionSwitchDelegate=self;
    
    
    _setMessageNotifactionSwitchModel.setMessageNotifactionSwitchDelegate=self;

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

#pragma mark -Button Action


#pragma mark -Handle request return
-(void)handleGetMessageNotifactionSwitchStatus:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"200"]) {
        _dataArray=[dictionary objectForKey:@"data"];
        [_statusTableView reloadData];
//        [IVToastHUD showAsToastSuccessWithStatus:@"设置成功"];
        if(first == 0)
//            [IVToastHUD showSuccessWithStatus:@"设置成功"];
            [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
        first = 0;
    }else{
        NSLog(@"获取消息状态失败");
    }
}


#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  [_dataArray count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"NotificationStatusCell";
    NotificationStatusCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"NotificationStatusCell" owner:self options:nil];
        cell=(NotificationStatusCell*)[xib objectAtIndex:0];
    }
    cell.nameLabel.text=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"notifactionName"];
    
    NSString* status=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"status"];
//    [_statusArray addObject:status];
    
  
    if ([status isEqualToString:@"1"]) {
        [cell.switchBtn setOn:YES];
    }else{
        [cell.switchBtn setOn:NO];
    }
    NSString* type=[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"notifactionType"];
    cell.switchBtn.tag=[type integerValue];
    [cell.switchBtn addTarget:self action:@selector(SwitchButton:) forControlEvents:UIControlEventValueChanged];
//    [_statusArray addObject:type];
//    [_statusArray addObject:status];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)SwitchButton:(id)sender{
    
    NSString* userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    UISwitch* switchButton=(UISwitch*)sender;
    //获取被修改的状态
    BOOL isButtonOn=[switchButton isOn];
    NSString* status;
    if (isButtonOn) {
        status=@"1";
    }else{
        status=@"0";
    }
    int tag=switchButton.tag;
    //被修改状态的类型
    NSString* type=[NSString stringWithFormat:@"%d",tag];
    
    for (NSDictionary* dic in _dataArray) {
        NSString* notifactionType=[dic objectForKey:@"notifactionType"];
        NSString* notifactionstatus=[dic objectForKey:@"status"];
//        [_statusArray addObject:notifactionType];
        if ([notifactionType isEqualToString:type]) {
            [_statusArray addObject:[NSString stringWithFormat:@"%@,%@",notifactionType,status]];
        }else{
            [_statusArray addObject:[NSString stringWithFormat:@"%@,%@",notifactionType,notifactionstatus]];
        }
    }
    [IVToastHUD showAsToastWithStatus:@"正在设置...."];
    [_setMessageNotifactionSwitchModel startCallWithArguments:[NSArray arrayWithObjects:userID,_statusArray, nil]];
    
}

-(void)handleSetMessageNotifactionSwitchStatus:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"200"]) {
        //        NSString* resultMsg=[dictionary objectForKey:@"resultMsg"];
        NSLog(@"消息开关请求发送成功");
        NSString* userID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
        [_getMessageNotifactionSwitchModel startCallWithArguments:[NSArray arrayWithObjects:userID, nil]];
        
    } else{
        NSLog(@"消息开关请求发送失败");
    }
    [_statusArray removeAllObjects];
}

@end
