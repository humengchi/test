//
//  ADMaintainPlanViewController.m
//  OBDClient
//
//  Created by hys on 5/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMaintainPlanViewController.h"

@interface ADMaintainPlanViewController ()

@end

@implementation ADMaintainPlanViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _getMaintainListModel=[[ADGetMaintainListModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    if (IOS7_OR_LATER) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }

    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    [_getMaintainListModel startRequestMaintainItemsWithArguments:[NSArray arrayWithObjects:vin, nil]];

   
    
    _getMaintainListModel.getMaintainListDelegate=self;
}

#pragma mark -handle Request
-(void)handleMaintainList:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        _maintainListArray=[dictionary objectForKey:@"data"];
        _maintainListNum=[_maintainListArray count];
//        for (ASObject *asObject in _maintainListArray) {
//            NSDictionary *plan = [asObject properties];
//            NSString* IdList=[plan objectForKey:@"IdList"];
//            NSString* IntervalMileage=[plan objectForKey:@"IntervalMileage"];
//            NSLog(@"%@    %@",IdList,IntervalMileage);
//            
//        }
        if (_maintainItemsNum!=0) {
            _leftScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,80, self.view.bounds.size.height)];
            _leftScrollView.contentSize=CGSizeMake(80, 40*(1+_maintainItemsNum));
            _leftScrollView.showsHorizontalScrollIndicator=NO;
            _leftScrollView.showsVerticalScrollIndicator=NO;
            _leftScrollView.pagingEnabled=NO;
            _leftScrollView.scrollEnabled=YES;
            _leftScrollView.delegate=self;
            [_leftScrollView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:_leftScrollView];
            
            _leftTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80, self.view.bounds.size.height) style:UITableViewStylePlain];
            [_leftTableView setBackgroundColor:[UIColor clearColor]];
            [_leftTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            _leftTableView.dataSource=self;
            _leftTableView.delegate=self;
            [_leftScrollView addSubview:_leftTableView];
            
            _rightScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(80, 0, self.view.bounds.size.width-80, self.view.bounds.size.height)];
            _rightScrollView.contentSize=CGSizeMake(80*_maintainListNum, 40*(1+_maintainItemsNum));
            _rightScrollView.showsHorizontalScrollIndicator=NO;
            _rightScrollView.showsVerticalScrollIndicator=NO;
            _rightScrollView.pagingEnabled=NO;
            _rightScrollView.scrollEnabled=YES;
            _rightScrollView.delegate=self;
            [_rightScrollView setBackgroundColor:[UIColor clearColor]];
            [self.view addSubview:_rightScrollView];
            
            _rightTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 80*_maintainListNum, self.view.bounds.size.height) style:UITableViewStylePlain];
            [_rightTableView setBackgroundColor:[UIColor clearColor]];
            [_rightTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            _rightTableView.dataSource=self;
            _rightTableView.delegate=self;
            [_rightScrollView addSubview:_rightTableView];
            
            if (IOS7_OR_LATER) {
                CGRect frame=_leftScrollView.frame;
                frame.origin.y+=64;
                [_leftScrollView setFrame:frame];
                
                frame=_rightScrollView.frame;
                frame.origin.y+=64;
                [_rightScrollView setFrame:frame];
            }
            
            
        }
        
    }else{
        [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"getMaintainItemsFailKey",@"MyString", @"")];
    }
    
}


-(void)handleMaintainItems:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        _maintainItemsArray=[dictionary objectForKey:@"data"];
        _maintainItemsNum=[_maintainItemsArray count];
        NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
        [_getMaintainListModel startRequestMaintainListWithArguments:[NSArray arrayWithObjects:vin, nil]];
    }else{
        NSLog(@"保养计划发生系统错误");
    }
    
}



#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _maintainItemsNum+1;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleTableIdentifier = @"SimpleTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             SimpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier: SimpleTableIdentifier];
    }
    
    UIView* view;
        
    if ([tableView isEqual:_leftTableView]) {
        
//        if (indexPath.row==0) {
//            cell.textLabel.text=@"里程(公里)";
//        }else{
//            NSDictionary* dic=[_maintainItemsArray objectAtIndex:(indexPath.row-1)];
//            cell.textLabel.text=[dic objectForKey:@"Name"];
//        }
        
        view=[self ViewWithLeftContent:indexPath.row];
    }
        
    
    if ([tableView isEqual:_rightTableView]){
        
        view=[self ViewWithRightContent:indexPath.row];
        
        
    }

        
    
    
    while ([cell.contentView.subviews lastObject] != nil) {
        [(UIView*)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    
    [cell.contentView addSubview:view];

    return cell;
}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:_leftTableView]) {
        _rightTableView.contentOffset=_leftTableView.contentOffset;
    }else{
        _leftTableView.contentOffset=_rightTableView.contentOffset;
    }
}

-(UIView*)ViewWithLeftContent:(NSInteger)index{
    UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
    if (index==0) {
        UIImageView* labBgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        labBgImgView.image=[UIImage imageNamed:@"lattice.png"];
        [contentView addSubview:labBgImgView];
        UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        lab.text=NSLocalizedStringFromTable(@"MileagekmKey",@"MyString", @"");
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment=UITextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:12];
        [lab setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:lab];
    }else{
        UIImageView* labBgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        labBgImgView.image=[UIImage imageNamed:@"lattice.png"];
        [contentView addSubview:labBgImgView];
        NSDictionary* ItemsDic=[_maintainItemsArray objectAtIndex:(index-1)];
        UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 40)];
        lab.text=[ItemsDic objectForKey:@"Name"];
        lab.textColor=[UIColor whiteColor];
        lab.textAlignment=UITextAlignmentCenter;
        lab.font=[UIFont systemFontOfSize:12];
        [lab setBackgroundColor:[UIColor clearColor]];
        [contentView addSubview:lab];

    }
    UIImageView* lineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, 80, 2)];
    lineImgView.image=[UIImage imageNamed:@"xiline.png"];
    [contentView addSubview:lineImgView];
    
    return contentView;
}


-(UIView*)ViewWithRightContent:(NSInteger)index{
    UIView* contentView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, _rightTableView.frame.size.width, 40)];
    if (index==0) {
        for (int i=0; i<[_maintainListArray count]; i++) {
            
            NSDictionary* dic=[[_maintainListArray objectAtIndex:i] properties];
            NSString* IntervalMileage=[dic objectForKey:@"IntervalMileage"];

            UIImageView* labBgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(80*i, 0, 80, 40)];
            labBgImgView.image=[UIImage imageNamed:@"lattice.png"];
            
            UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(80*i, 0, 80, 40)];
            lab.text=[NSString stringWithFormat:@"%@",IntervalMileage];
            lab.textAlignment=UITextAlignmentCenter;
            lab.textColor=[UIColor whiteColor];
            [lab setBackgroundColor:[UIColor clearColor]];
            
            [contentView addSubview:labBgImgView];
            [contentView addSubview:lab];
        }
    }else{
        NSDictionary* itemsDic=[_maintainItemsArray objectAtIndex:(index-1)];
        NSString* ItemID=[itemsDic objectForKey:@"ItemID"];
        
        for (int i=0; i<[_maintainListArray count]; i++) {
            NSDictionary* dic=[[_maintainListArray objectAtIndex:i] properties];
            NSString* IdList=[dic objectForKey:@"IdList"];
            UIImageView* labBgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(80*i, 0, 80, 40)];
            labBgImgView.image=[UIImage imageNamed:@"lattice.png"];
            
            UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(80*i, 0, 80, 40)];
            lab.textAlignment=UITextAlignmentCenter;
            lab.text=@"";
            lab.textColor=[UIColor whiteColor];
            [lab setBackgroundColor:[UIColor clearColor]];
            NSArray* IdListArray=[IdList componentsSeparatedByString:@","];
            for (int j=0; j<[IdListArray count]; j++) {
                NSString* ID=[IdListArray objectAtIndex:j];
                if ([ID isEqualToString:ItemID]) {
                    lab.text=@"●";
                    break;
                }
            }
            
            [contentView addSubview:labBgImgView];
            [contentView addSubview:lab];
            
        }
    }
    UIImageView* lineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 40, _rightTableView.frame.size.width, 2)];
    lineImgView.image=[UIImage imageNamed:@"xiline.png"];
    [contentView addSubview:lineImgView];
    
    return contentView;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
