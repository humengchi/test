//
//  ADWarnListViewController.m
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADWarnListViewController.h"

NSString* const ADWarnDetailNotification=@"ADWarnDetailNotification";

NSString* const ADWarnListReadFlagNotification=@"ADWarnListReadFlagNotification";

@interface ADWarnListViewController ()

@end

@implementation ADWarnListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _getGroupMessageModel=[[ADGetGroupMessageModel alloc]init];
        
        _deleteCurrentMessagesModel=[[ADDeleteCurrentMessagesModel alloc]init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(startCall:) name:ADNotificationTypeNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWarnDetailReadFlag:) name:ADWarnDetailReadFlagNotification object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
       
    

    _editItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(tableViewEdit:)];
    
    _editItem =[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"editKey",@"MyString", @"") style:UIBarButtonItemStylePlain target:self action:@selector(tableViewEdit:)];
    
    UIBarButtonItem* setReadFlagForGroupMessageButtonItem=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"haveReadKey",@"MyString", @"") style:UIBarButtonItemStylePlain target:self action:@selector(setReadFlagForGroupMessage:)];

    self.navigationItem.rightBarButtonItems=[NSArray arrayWithObjects:setReadFlagForGroupMessageButtonItem,_editItem, nil];
    if (IOS7_OR_LATER) {
        setReadFlagForGroupMessageButtonItem.tintColor=[UIColor lightGrayColor];
        _editItem.tintColor=[UIColor lightGrayColor];
    }

    self.title=NSLocalizedStringFromTable(@"listOfMessagesKey",@"MyString", @"");;
    
    _warnListTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 416) style:UITableViewStyleGrouped];
    
    if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {
        _warnListTableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    }

    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
       
        _warnListTableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        CGRect frame=_warnListTableView.frame;
        frame.origin.y+=64;
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height-64);
        [_warnListTableView setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        _warnListTableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        _warnListTableView=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
        CGRect frame=_warnListTableView.frame;
        frame.origin.y+=64;
        [_warnListTableView setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    
    [_warnListTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _warnListTableView.delegate=self;
    _warnListTableView.dataSource=self;
    _warnListTableView.backgroundView=nil;
    [_warnListTableView setBackgroundColor:[UIColor clearColor]];
    _warnListTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    [self.view  addSubview:_warnListTableView];

    
//    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
//    [_getGroupMessageModel startCallWithArguments:[NSArray arrayWithObjects:uID,@"3", nil]];
//    _getGroupMessageModel.getGroupMessageDelegate=self;
    
    _deleteCurrentMessagesModel.deleteCurrentMessagesDelegate=self;
    
}


#pragma makr -Button Action

- (void)tableViewEdit:(id)sender
{
    if ([_editItem.title isEqualToString:NSLocalizedStringFromTable(@"completeKey",@"MyString", @"")]) {
        [_editItem setTitle:NSLocalizedStringFromTable(@"editKey",@"MyString", @"")];
    }else{
        [_editItem setTitle:NSLocalizedStringFromTable(@"completeKey",@"MyString", @"")];
    }
    [_warnListTableView setEditing:!_warnListTableView.isEditing animated:YES];
}

-(void)setReadFlagForGroupMessage:(id)sender{
    _setReadFlagForGroupMessageModel=[[ADSetReadFlagForGroupMessageModel alloc]init];
    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_setReadFlagForGroupMessageModel startCallWithArguments:[NSArray arrayWithObjects:uID,_currentNotificationType, nil]];
    _setReadFlagForGroupMessageModel.setReadFlagForGroupMessageDelegate=self;
}


- (void)startCall:(NSNotification *)aNoti
{
    _currentNotificationType=(NSString*)[aNoti object];
    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_getGroupMessageModel startCallWithArguments:[NSArray arrayWithObjects:uID,_currentNotificationType, nil]];
    _getGroupMessageModel.getGroupMessageDelegate=self;

}

#pragma mark -handle request return
-(void)handleSetReadFlagForGroupMessageData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"200"]) {
        NSString* resultMsg=[dictionary objectForKey:@"resultMsg"];
        NSLog(@"%@",resultMsg);
        [[NSNotificationCenter defaultCenter] postNotificationName:ADWarnListReadFlagNotification object:nil];
        NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
        [_getGroupMessageModel startCallWithArguments:[NSArray arrayWithObjects:uID,_currentNotificationType, nil]];
    }else{
        NSLog(@"标记当组消息已读失败");
    }

}

-(void)handleGroupMessageData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        _currentDataArray=[dictionary objectForKey:@"data"];
        [_warnListTableView reloadData];
    }else{
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"getMaintainItemsFailKey",@"MyString", @"")];
    }
}


-(void)handleDeleteCurrentMessagesData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        [_currentDataArray removeObjectAtIndex:_deleteRow];
        [_warnListTableView reloadData];
        NSLog(@"Delete CurrentMessage Success");
    }else{
        NSLog(@"Delete CurrentMessage Failed");
    }
}

-(void)handleWarnDetailReadFlag:(NSNotification* )aNoti{
    NSString* uID=[ADSingletonUtil sharedInstance].globalUserBase.userID;
    [_getGroupMessageModel startCallWithArguments:[NSArray arrayWithObjects:uID,_currentNotificationType, nil]];
}

#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_currentDataArray count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"WarnCell";
    ADWarnCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"ADWarnCell" owner:self options:nil];
        cell=(ADWarnCell*)[xib objectAtIndex:0];
        
    }
    if (indexPath.row<[_currentDataArray count]) {
        NSDictionary* data=[_currentDataArray objectAtIndex:indexPath.row];
        NSString* title=[data objectForKey:@"title"];
        NSString* time=[data objectForKey:@"createTime"];
        cell.warnTitleLabel.text=[NSString stringWithFormat:@"%d.%@",indexPath.row+1,title];
        cell.warnTitleLabel.textColor=[UIColor blackColor];
        cell.warnTimeLabel.text=time;
        cell.warnTimeLabel.textColor=[UIColor blackColor];
        
        NSString* readFlag=[data objectForKey:@"readFlag"];
        if ([readFlag isEqualToString:@"1"]) {
            [cell.redFlagImgView setHidden:YES];
        }else{
            [cell.redFlagImgView setHidden:NO];
        }
//        cell.backgroundColor=[UIColor whiteColor];
        
    }
    
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 46;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ADWarnDetailViewController* warnDetailViewController=[[ADWarnDetailViewController alloc]init];
    [self.navigationController pushViewController:warnDetailViewController animated:NO];
    NSDictionary* data=[_currentDataArray objectAtIndex:indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADWarnDetailNotification object:data];
    
    
}


//TableView左边的删除按钮
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSString* messageID=[[_currentDataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        [_deleteCurrentMessagesModel startCallWithArguments:[NSArray arrayWithObjects:messageID, nil]];
        _deleteRow=indexPath.row;
    }
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
