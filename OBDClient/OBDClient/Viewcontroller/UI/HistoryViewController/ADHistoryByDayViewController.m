//
//  ADHistoryByDayViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHistoryByDayViewController.h"
#import "IVToastHUD.h"

#define TAG_BUTTON_MILEAGE                       65200

@interface ADHistoryByDayViewController ()
@property (nonatomic) UIButton *buttonMileage;
@property (nonatomic) UIView *viewOfUpdateInfo;
@end

@implementation ADHistoryByDayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _historyModel=[[ADHistoryModel alloc]init];
        [_historyModel addObserver:self
                        forKeyPath:KVO_HISTORY_TRACK_POINTS_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect rectOfUpdateInfo = CGRectMake(0, 0, WIDTH, 65);
    _viewOfUpdateInfo = [[UIView alloc] initWithFrame:rectOfUpdateInfo];
    
    
    UILabel *labelOfLastUpdatedTitle = [[UILabel alloc] initWithFrame:CGRectMake(47, 0, 70, 50)];
    labelOfLastUpdatedTitle.text = NSLocalizedStringFromTable(@"totalMileageKey",@"MyString", @"");//@"总里程";
    labelOfLastUpdatedTitle.font = [UIFont boldSystemFontOfSize:20];
    labelOfLastUpdatedTitle.textColor = DEFAULT_LABEL_COLOR;
    labelOfLastUpdatedTitle.backgroundColor = [UIColor clearColor];
    labelOfLastUpdatedTitle.textAlignment=UITextAlignmentCenter;
    labelOfLastUpdatedTitle.numberOfLines=0;
    [_viewOfUpdateInfo addSubview:labelOfLastUpdatedTitle];
    
    
    _buttonMileage = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonMileage.frame = CGRectMake(117, 0, 115, 50);
    [_buttonMileage setTitle:@"000000" forState:UIControlStateNormal];
    _buttonMileage.titleLabel.font=[UIFont systemFontOfSize:25];
    [_buttonMileage setBackgroundColor:[UIColor clearColor]];
    [_buttonMileage setBackgroundImage:[UIImage imageNamed:@"summary_odometer.png"] forState:UIControlStateNormal];
//    [_buttonMileage addTarget:self action:@selector(EditMileageButton:) forControlEvents:UIControlEventTouchUpInside];
    _buttonMileage.tag = TAG_BUTTON_MILEAGE;
    [_viewOfUpdateInfo addSubview:_buttonMileage];
    
    
    
    UILabel *labelOfMile = [[UILabel alloc] initWithFrame:CGRectMake(223, 0, 50, 50)];
    labelOfMile.text = NSLocalizedStringFromTable(@"kmKey",@"MyString", @"");//@"公里";
    labelOfMile.font = [UIFont boldSystemFontOfSize:20];
    labelOfMile.textColor = DEFAULT_LABEL_COLOR;
    labelOfMile.backgroundColor = [UIColor clearColor];
    labelOfMile.textAlignment=UITextAlignmentCenter;
    labelOfMile.numberOfLines=0;
    [_viewOfUpdateInfo addSubview:labelOfMile];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,50, WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [_viewOfUpdateInfo addSubview:lineView];

    _viewOfUpdateInfo.hidden=YES;
    [self.view addSubview:_viewOfUpdateInfo];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, WIDTH, 315) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_viewOfUpdateInfo setFrame:CGRectMake(0, 64, WIDTH, 65)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
        
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_tableView.frame;
        frame.size.height+=88;
        [_tableView setFrame:frame];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_viewOfUpdateInfo setFrame:CGRectMake(0, 64, WIDTH, 65)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        frame.size.height+=88;
        [_tableView setFrame:frame];
	}


}

- (void)dealloc
{
    [_historyModel removeObserver:self forKeyPath:KVO_HISTORY_TRACK_POINTS_PATH_NAME];
    [_historyModel cancel];
}

- (void)viewWillAppear:(BOOL)animated{

}

-(void)viewWillDisappear:(BOOL)animated
{

}


- (void)updateUIByDataSource:(NSArray *)aDataSource
{
    _dataSource = aDataSource;
    if ([_dataSource count]!=0) {
        _viewOfUpdateInfo.hidden=NO;
        float mileage=0;
        for(int i=0;i<_dataSource.count;i++){
            NSDictionary *historyPoint=[_dataSource objectAtIndex:i];
            if ([[historyPoint objectForKey:@"trackDistance"] isEqualToString:@"null"]) {
                mileage+=0;
            }else{
                mileage+=[[historyPoint objectForKey:@"trackDistance"] intValue]/1000;
            }
        }
    [_buttonMileage setTitle:[NSString stringWithFormat:@"%07.02f",mileage] forState:UIControlStateNormal];

    }else{
        _viewOfUpdateInfo.hidden=YES;
    }
    [_tableView reloadData];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _historyModel) {
        if ([keyPath isEqualToString:KVO_HISTORY_TRACK_POINTS_PATH_NAME]) {
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate clickCellViewController:self Argumets:[NSArray arrayWithObjects:@"obd_demo",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[(NSDictionary*)_dataSource[indexPath.row] objectForKey:@"startTime"],[(NSDictionary*)_dataSource[indexPath.row] objectForKey:@"stopTime"], nil]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierStr = @"ADHistoryByDayViewController.cell";
    ADHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
    NSDictionary *historyPoint = [_dataSource objectAtIndex:indexPath.row];
    if (!cell) {
        cell = [[ADHistoryCell alloc]initWithFrame:CGRectZero];
    }
    NSString *drual=@"";
    if(indexPath.row<_dataSource.count-1){
        NSDictionary *nextHistoryPoint=[_dataSource objectAtIndex:indexPath.row+1];
        NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"]; 
        NSDate *nextDate=[dateFormat dateFromString:[nextHistoryPoint objectForKey:@"startTime"]];
        NSDate *thisDate=[dateFormat dateFromString:[historyPoint objectForKey:@"stopTime"]];
        NSTimeInterval secondsInterval= [nextDate timeIntervalSinceDate:thisDate];
        int hour = (int)secondsInterval/3600;
        int minute = (int)(secondsInterval-hour*3600)/60;
//        int second = (int)secondsInterval-hour*3600-minute*60;
        drual=[NSString stringWithFormat:@"%d%@%d%@",hour,NSLocalizedStringFromTable(@"hour",@"MyString", @""),minute,NSLocalizedStringFromTable(@"minute",@"MyString", @"")];
    }
    
    
    [cell updateUIByHistoryPoint:historyPoint andDrual:drual];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,95, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
    cell.accessoryView=buttonRight;
    
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 96;
}

@end
