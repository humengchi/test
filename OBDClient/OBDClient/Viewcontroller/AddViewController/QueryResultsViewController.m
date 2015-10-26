//
//  QueryResultsViewController.m
//  OBDClient
//
//  Created by hys on 26/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "QueryResultsViewController.h"

@interface QueryResultsViewController ()

@end

@implementation QueryResultsViewController

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
    // Do any additional setup after loading the view from its nib.
    _queryResultsTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 436) style:UITableViewStylePlain];
    _queryResultsTableView.delegate=self;
    _queryResultsTableView.dataSource=self;
    [_queryResultsTableView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    [self.view addSubview:_queryResultsTableView];
    self.title=NSLocalizedStringFromTable(@"queryResultsKey",@"MyString", @"");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"QueryResultsCell";
    QueryResultsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"QueryResultsCell" owner:self options:nil];
        cell=(QueryResultsCell*)[xib objectAtIndex:0];
        
    }
    switch (indexPath.row) {
        case 0:
            cell.addressImgView.image=[UIImage imageNamed:@"4S.png"];
            break;
        case 1:
            cell.addressImgView.image=[UIImage imageNamed:@"gas-station.png"];
            break;
        case 2:
            cell.addressImgView.image=[UIImage imageNamed:@"wash.png"];
            break;
        case 3:
            cell.addressImgView.image=[UIImage imageNamed:@"park.png"];
            break;
        case 4:
            cell.addressImgView.image=[UIImage imageNamed:@"bank.png"];
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleGray;  
    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    PeripheralViewController* warnDetailViewController=[[PeripheralViewController alloc]initWithNibName:@"PeripheralViewController" bundle:nil];
//    [self.navigationController pushViewController:warnDetailViewController animated:NO];
    
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

@end
