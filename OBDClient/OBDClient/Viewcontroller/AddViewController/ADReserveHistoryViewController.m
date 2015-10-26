//
//  ADReserveHistoryViewController.m
//  OBDClient
//
//  Created by hys on 19/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADReserveHistoryViewController.h"

@interface ADReserveHistoryViewController ()

@end

@implementation ADReserveHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _reserveModel=[[ADReserveModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
     _reserveModel.reserveDelegate=self;
    [_reserveModel startRequestGetReservationWithArguments:[NSArray arrayWithObjects:vin,@"4", nil]];
    
    
    _reserveHistoryTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, WIDTH, 372) style:UITableViewStylePlain];
    [_reserveHistoryTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_reserveHistoryTableView];
    [_reserveHistoryTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _reserveHistoryTableView.delegate=self;
    _reserveHistoryTableView.dataSource=self;
   
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_BtnOne.frame;
        frame.origin.y+=64;
        [_BtnOne setFrame:frame];
        
        frame=_BtnTwo.frame;
        frame.origin.y+=64;
        [_BtnTwo setFrame:frame];
        
        frame=_BtnThree.frame;
        frame.origin.y+=64;
        [_BtnThree setFrame:frame];
        
        frame=_BtnFour.frame;
        frame.origin.y+=64;
        [_BtnFour setFrame:frame];
        
        frame=_BtnFive.frame;
        frame.origin.y+=64;
        [_BtnFive setFrame:frame];
        
        frame=_LineOne.frame;
        frame.origin.y+=64;
        [_LineOne setFrame:frame];
        
        frame=_LineTwo.frame;
        frame.origin.y+=64;
        [_LineTwo setFrame:frame];
        
        frame=_LineThree.frame;
        frame.origin.y+=64;
        [_LineThree setFrame:frame];

        frame=_LineFour.frame;
        frame.origin.y+=64;
        [_LineFour setFrame:frame];

        frame=_LineFive.frame;
        frame.origin.y+=64;
        [_LineFive setFrame:frame];


        frame=_reserveHistoryTableView.frame;
        frame.origin.y+=64;
        [_reserveHistoryTableView setFrame:frame];

        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];


	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_reserveHistoryTableView setFrame:CGRectMake(0, 44, WIDTH, 460)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_BtnOne.frame;
        frame.origin.y+=64;
        [_BtnOne setFrame:frame];
        
        frame=_BtnTwo.frame;
        frame.origin.y+=64;
        [_BtnTwo setFrame:frame];
        
        frame=_BtnThree.frame;
        frame.origin.y+=64;
        [_BtnThree setFrame:frame];
        
        frame=_BtnFour.frame;
        frame.origin.y+=64;
        [_BtnFour setFrame:frame];
        
        frame=_BtnFive.frame;
        frame.origin.y+=64;
        [_BtnFive setFrame:frame];
        
        frame=_LineOne.frame;
        frame.origin.y+=64;
        [_LineOne setFrame:frame];
        
        frame=_LineTwo.frame;
        frame.origin.y+=64;
        [_LineTwo setFrame:frame];
        
        frame=_LineThree.frame;
        frame.origin.y+=64;
        [_LineThree setFrame:frame];
        
        frame=_LineFour.frame;
        frame.origin.y+=64;
        [_LineFour setFrame:frame];
        
        frame=_LineFive.frame;
        frame.origin.y+=64;
        [_LineFive setFrame:frame];
        
        
        frame=_reserveHistoryTableView.frame;
        frame.origin.y+=64;
        frame.size.height+=88;
        [_reserveHistoryTableView setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}

    
}

#pragma mark -handle Request
-(void)handleGetReservation:(NSDictionary *)dictionary{
    if ([dictionary count]==0) {
        _dataArray=nil;
    }else{
        NSString* resultCode=[dictionary objectForKey:@"resultCode"];
        if ([resultCode isEqual:@"200"]) {
            _dataArray=[dictionary objectForKey:@"data"];
        }else{
            _dataArray=nil;
        }
    }
    
    [_reserveHistoryTableView reloadData];
    
}

#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"ADReserveHistoryCell";
    ADReserveHistoryCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"ADReserveHistoryCell" owner:self options:nil];
        cell=(ADReserveHistoryCell*)[xib objectAtIndex:0];
        
    }
    NSDictionary* dic=[_dataArray objectAtIndex:indexPath.row];
    cell.shopNameLabel.text=[NSString stringWithFormat:@"预约4s店:%@", [dic objectForKey:@"name"]];
    int type=[[dic objectForKey:@"type"] intValue];
    switch (type) {
        case 0:
            cell.projectLabel.text=@"预约项目:维修";
            break;
        case 1:
            cell.projectLabel.text=@"预约项目:保养";
            break;
        case 2:
            cell.projectLabel.text=@"预约项目:保险";
            break;
        case 3:
            cell.projectLabel.text=@"预约项目:年审";
            break;
        default:
            break;
    }
    cell.timeLabel.text=[NSString stringWithFormat:@"预约时间:%@",[dic objectForKey:@"reservationTime"]];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
    
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


//TableView左边的删除按钮
//- (void)tableView:(UITableView *)tableView
//commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
//forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSString* messageID=[[_currentDataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
//        [_deleteCurrentMessagesModel startCallWithArguments:[NSArray arrayWithObjects:messageID, nil]];
//        [_currentDataArray removeObjectAtIndex:indexPath.row];
//        [_warnListTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }
//}

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

- (IBAction)historyButtonAction:(id)sender {
    UIButton* btn=(UIButton*)sender;
    int tag=btn.tag;
    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    switch (tag) {
        case 4:
             [_reserveModel startRequestGetReservationWithArguments:[NSArray arrayWithObjects:vin,@"4", nil]];
            break;
        case 0:
            [_reserveModel startRequestGetReservationWithArguments:[NSArray arrayWithObjects:vin,@"0", nil]];
            break;
        case 1:
            [_reserveModel startRequestGetReservationWithArguments:[NSArray arrayWithObjects:vin,@"1", nil]];
            break;
        case 2:
            [_reserveModel startRequestGetReservationWithArguments:[NSArray arrayWithObjects:vin,@"2", nil]];
            break;
        case 3:
            [_reserveModel startRequestGetReservationWithArguments:[NSArray arrayWithObjects:vin,@"3", nil]];
            break;
        default:
            break;
    }
    
}
@end
