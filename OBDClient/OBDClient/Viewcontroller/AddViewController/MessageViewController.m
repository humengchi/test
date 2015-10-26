//
//  MessageViewController.m
//  OBDClient
//
//  Created by hys on 17/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "MessageViewController.h"
#import "ADMessageSettingViewController.h"
NSString * const ADNotificationTypeNotification      = @"ADNotificationTypeNotification";

@interface MessageViewController ()

@end

@implementation MessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _getMessageGroupModel=[[ADGetMessageGroupModel alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUpdateUnreadNotification:) name:ADWarnListReadFlagNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWarnDetailReadFlag:) name:ADWarnDetailReadFlagNotification object:nil];
    }
    return self;
}

- (void)settingTap:(id)sender{
    ADMessageSettingViewController *messageSetView=[[ADMessageSettingViewController alloc]init];
    [self.navigationController pushViewController:messageSetView animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.title=NSLocalizedStringFromTable(@"messageCenterKey",@"MyString", @"");;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    
    UIBarButtonItem *settingButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"消息设置",@"MyString", @"") style:UIBarButtonItemStyleBordered target:self action:@selector(settingTap:)];
    self.navigationItem.rightBarButtonItem=settingButton;

    if (IOS7_OR_LATER) {
        settingButton.tintColor=[UIColor lightGrayColor];
    }


    _messageCenterTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];

    _messageCenterTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _messageCenterTableView.delegate=self;
    _messageCenterTableView.dataSource=self;
    [_messageCenterTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _messageCenterTableView.showsHorizontalScrollIndicator=NO;
    _messageCenterTableView.backgroundView=nil;
    [_messageCenterTableView setBackgroundColor:[UIColor clearColor]];
//    [_messageCenterTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];     //menu_back.png
    [self.view addSubview:_messageCenterTableView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
//        CGRect frame=_messageCenterTableView.frame;
//        frame.origin.y+=64;
//        [_messageCenterTableView setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
//        CGRect frame=_messageCenterTableView.frame;
//        frame.origin.y+=64;
//        [_messageCenterTableView setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}


    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_getMessageGroupModel startCallWithArguments:[NSArray arrayWithObjects:uID, nil]];
    _getMessageGroupModel.getMessageGroupDelegate=self;
    
   
    
    
   
    
}

#pragma mark -Button action
//-(void)setReadFlagForAllMessage:(id)sender{
//    _setReadFlagForAllMessageModel=[[ADSetReadFlagForAllMessageModel alloc]init];
//    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
//    [_setReadFlagForAllMessageModel startCallWithArguments:[NSArray arrayWithObjects:uID, nil]];
//    _setReadFlagForAllMessageModel.setReadFlagForAllMessageDelegate=self;
//    
//}


#pragma mark -handle request return
//-(void)handleSetReadFlagForAllMessageData:(NSDictionary *)dictionary{
//    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
//    if ([resultCode isEqualToString:@"200"]) {
//        NSLog(@"Success");
//    }
//}


-(void)handleMessageGroupData:(NSDictionary *)dictionary
{
    _messageGroupDataArray=[dictionary objectForKey:@"data"];
    [_messageCenterTableView reloadData];
           
}

- (void)handleUpdateUnreadNotification:(NSNotification *)aNoti{
    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_getMessageGroupModel startCallWithArguments:[NSArray arrayWithObjects:uID, nil]];
}

- (void)handleWarnDetailReadFlag:(NSNotification *)aNoti{
    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_getMessageGroupModel startCallWithArguments:[NSArray arrayWithObjects:uID, nil]];
}

#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messageGroupDataArray count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"MessageCell";
    MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
        cell=(MessageCell*)[xib objectAtIndex:0];
        
    }
    if (indexPath.row<[_messageGroupDataArray count]) {
        
        
    NSDictionary* data=[_messageGroupDataArray objectAtIndex:indexPath.row];
    
    NSString* type=[data objectForKey:@"notifactionType"];
    NSString* name=[data objectForKey:@"notifactionName"];
    NSString* totalNum=[data objectForKey:@"totalNum"];
    cell.totalNumLabel.text=[NSString stringWithFormat:@"(共%@条)",totalNum];
    NSString* toReadNum=[data objectForKey:@"toReadNum"];
    
    if ([toReadNum isEqualToString:@"0"]) {
        [cell.unreadNumImgView setHidden:YES];
        [cell.unreadNumLabel setHidden:YES];
    }else{
        cell.unreadNumImgView.image=[UIImage imageNamed:@"num_greenimage.png"];
        cell.unreadNumLabel.text=toReadNum;
    }
    
    
    if ([type isEqualToString:@"1"]) {
        cell.typeImgView.image=[UIImage imageNamed:@"增殖告警.png"];
    }else if ([type isEqualToString:@"2"]){
        cell.typeImgView.image=[UIImage imageNamed:@"保养维修提醒.png"];
    }else if ([type isEqualToString:@"3"]){
        cell.typeImgView.image=[UIImage imageNamed:@"保险到期提醒.png"];
    }else if ([type isEqualToString:@"4"]){
        cell.typeImgView.image=[UIImage imageNamed:@"业务提醒.png"];
    }else if ([type isEqualToString:@"5"]){
        cell.typeImgView.image=[UIImage imageNamed:@"系统广播.png"];
    }else if ([type isEqualToString:@"6"]){
        cell.typeImgView.image=[UIImage imageNamed:@"OBDios.png"];
    }else if ([type isEqualToString:@"7"]){
        cell.typeImgView.image=[UIImage imageNamed:@"DTCios.png"];
    }
    
    cell.typeNameLabel.text=name;
        
 
    }
        
//    }else{
//        [cell.unreadNumImgView setHidden:YES];
//        [cell.unreadNumLabel setHidden:YES];
//        [cell.typeImgView setHidden:YES];
//        [cell.typeNameLabel setHidden:YES];
//        [cell.separatorLineImgView setHidden:YES];
//    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    UIImageView *buttonRight = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH-15, 19, 6, 6.5)];
    buttonRight.image=[UIImage imageNamed:@"vehicle_list_right.png"];
//    [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
//    cell.accessoryView=buttonRight;
    [cell.contentView addSubview:buttonRight];
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
    ADWarnListViewController* warn=[[ADWarnListViewController alloc]init];
    [self.navigationController pushViewController:warn animated:NO];
    NSDictionary* data=[_messageGroupDataArray objectAtIndex:indexPath.row];
    NSString* type=[data objectForKey:@"notifactionType"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADNotificationTypeNotification object:type];    
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
