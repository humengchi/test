//
//  ADHistoryFinalViewController.m
//  OBDClient
//
//  Created by hys on 6/3/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADHistoryFinalViewController.h"
#import "ADRecentHistroyViewController.h"


@interface ADHistoryFinalViewController ()

@end

@implementation ADHistoryFinalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _historyModel=[[ADHistoryModel alloc]init];
        [_historyModel addObserver:self
                        forKeyPath:KVO_HISTORY_TRACK_POINTS_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
        [_historyModel addObserver:self
                        forKeyPath:KVO_HISTORY_TRACKS_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:NULL];

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title=@"历史轨迹";

    _viewOfUpdateInfo=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 65)];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 55, WIDTH, HEIGHT-55-36) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    
    _viewOfBottom=[[UIView alloc]initWithFrame:CGRectMake(0, 380, WIDTH, 36)];
    [_viewOfBottom setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_viewOfBottom];
    
    UIButton* leftBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 36, 36)];
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"left_arrow.png"] forState:UIControlStateNormal];
    leftBtn.tag=20001;
    [leftBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    [_viewOfBottom addSubview:leftBtn];
    
    UIButton* rightBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-36, 0, 36, 36)];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"right_arrow.png"] forState:UIControlStateNormal];
    rightBtn.tag=20002;
    [rightBtn addTarget:self action:@selector(selectDate:) forControlEvents:UIControlEventTouchUpInside];
    [_viewOfBottom addSubview:rightBtn];
    
//    _currentDate=[NSDate date];
    _formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"YYYY-MM-dd"];
    
    UIButton* timeButton=[[UIButton alloc]initWithFrame:CGRectMake(36, 0, WIDTH-72, 36)];
    [timeButton setBackgroundColor:[UIColor clearColor]];
    [timeButton addTarget:self action:@selector(showDateView) forControlEvents:UIControlEventTouchUpInside];
    [_viewOfBottom addSubview:timeButton];
    
    _timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(36, 0, WIDTH-72, 36)];
    _timeLabel.backgroundColor=[UIColor clearColor];
    _timeLabel.textColor=[UIColor lightGrayColor];
    _timeLabel.textAlignment=UITextAlignmentCenter;
    [_viewOfBottom addSubview:_timeLabel];
    
    
    _dateView=[[UIView alloc]initWithFrame:CGRectMake(0, 50, WIDTH, 270)];
    [_dateView setBackgroundColor:[UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0]];
    [_dateView setHidden:YES];
    [self.view addSubview:_dateView];
    
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    [_dateView addSubview:_datePicker];
    
    UIButton* okBtn=[[UIButton alloc]initWithFrame:CGRectMake(60, 225, 70, 40)];
    [okBtn setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_dateView addSubview:okBtn];

    UIButton* cancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(WIDTH-130, 225, 70, 40)];
    [cancleBtn setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_dateView addSubview:cancleBtn];

    
    
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_viewOfUpdateInfo setFrame:CGRectMake(0, 64, WIDTH, 65)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
        [_viewOfBottom setFrame:CGRectMake(0, HEIGHT-36, WIDTH, 36)];
        [_dateView setFrame:CGRectMake(0, 114, WIDTH, 270)];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_tableView.frame;
        frame.size.height+=88;
        [_tableView setFrame:frame];
        [_viewOfBottom setFrame:CGRectMake(0, HEIGHT-36, WIDTH, 36)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_viewOfUpdateInfo setFrame:CGRectMake(0, 64, WIDTH, 65)];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        frame.size.height+=88;
        [_tableView setFrame:frame];
        [_viewOfBottom setFrame:CGRectMake(0, HEIGHT-36, WIDTH, 36)];
        [_dateView setFrame:CGRectMake(0, 114, WIDTH, 270)];
	}
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"最近浏览"
                                                                    style:UIBarButtonItemStyleDone
                                                                   target:self
                                                                   action:@selector(recentNoteHistory)];
    [rightButton setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
//    NSTimeInterval oneday=24*60*60;
//    _currentDate=[NSDate dateWithYear:2014 month:7 day:11];
//    _currentDate = [NSDate date];
    NSString *dateString = [_formatter stringFromDate:[NSDate date]];
    _currentDate = [NSDate dateWithYear:[[[dateString componentsSeparatedByString:@"-"] firstObject] integerValue] month:[[[dateString componentsSeparatedByString:@"-"] objectAtIndex:1] integerValue] day:[[[dateString componentsSeparatedByString:@"-"] lastObject] integerValue]];
//    NSDate* nextDay=[NSDate dateWithTimeInterval:oneday sinceDate:_currentDate];
    _timeLabel.text=[_formatter stringFromDate:_currentDate];
    
    [self requestWithDate];
}

//最近查看的历史轨迹的记录
- (void)recentNoteHistory
{
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    _currentDate = [userDefaults objectForKey:@"recentNotesHistory"];
//    _timeLabel.text=[_formatter stringFromDate:_currentDate];
//    [self requestWithDate];
    ADRecentHistroyViewController *view = [[ADRecentHistroyViewController alloc] init];
    view.title = @"历史记录";
    view.delegate = self;
    [self.navigationController pushViewController:view animated:YES];
}

- (void)showDateView{
    [_dateView setHidden:NO];
    [_datePicker setDate:_currentDate];
}


- (void)sureBtn:(id)sender{
    [_dateView setHidden:YES];
    _currentDate=[_datePicker date];
    _timeLabel.text=[_formatter stringFromDate:_currentDate];
    [self requestWithDate];
}


- (void)cancleBtn:(id)sender{
    [_dateView setHidden:YES];
}
- (void)selectDate:(id)sender{
    UIButton* btn=(UIButton*)sender;
    NSCalendar* cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* components=[cal components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit) fromDate:_currentDate];
    _year=[components year];
    _month=[components month];
    _day=[components day];
    if (btn.tag==20001) {
        if (_day==1) {
            if (_month==1) {
                _year=_year-1;
                _month=12;
                _day=31;
            }else{
                _month-=1;
                if (_month==1||_month==3||_month==5||_month==7||_month==8||_month==10||_month==12) {
                    _day=31;
                }else if (_month==4||_month==6||_month==9||_month==11){
                    _day=30;
                }else if ((_year%4==0&&_year%400==0)&&_year%100!=0){
                    _day=29;
                }else{
                    _day=28;
                }
            }
        }else{
            _day-=1;
        }
    }else if (btn.tag==20002){
        if (_month==12) {
            if (_day==31) {
                _year=_year+1;
                _month=1;
                _day=1;
            }else{
                _day+=1;
            }
        }else if (_month==1||_month==3||_month==5||_month==7||_month==8||_month==10){
            if (_day==31) {
                _month+=1;
                _day=1;
            }else{
                _day+=1;
            }
        }else if (_month==4||_month==6||_month==9||_month==11){
            if (_day==30) {
                _month+=1;
                _day=1;
            }else{
                _day+=1;
            }
        }else if ((_year%4==0&&_year%400==0)&&_year%100!=0){
            if (_day==29) {
                _month+=1;
                _day=1;
            }else{
                _day+=1;
            }
        }else{
            if (_day==28) {
                _month+=1;
                _day=1;
            }else{
                _day+=1;
            }
        }
    }
    _currentDate=[NSDate dateWithYear:_year month:_month day:_day];
    _timeLabel.text=[_formatter stringFromDate:_currentDate];
    [self requestWithDate];

}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _historyModel) {
        if ([keyPath isEqualToString:KVO_HISTORY_TRACKS_PATH_NAME]) {
            if(_historyModel.historyTracks.count==0){
                [IVToastHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"NotrackrecordKey",@"MyString", @"")];
                [_viewOfUpdateInfo setHidden:YES];
                _dataSource=nil;
                [_tableView reloadData];
            }else{
                //                [(ADHistoryByDayViewController *)[_viewControllerArray objectAtIndex:_currentSelectedIndex] updateUIByDataSource:_historyModel.historyTracks];
                
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableArray *theArray = [[NSMutableArray alloc] init];
                if([userDefaults objectForKey:[NSString stringWithFormat:@"recentHistoryArray_%@",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]]){
                    theArray = [[userDefaults objectForKey:[NSString stringWithFormat:@"recentHistoryArray_%@",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]] mutableCopy];
                    if(theArray.count == 8){
                        [theArray removeObjectAtIndex:7];
                    }
                }
                int flag = 0;
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyyMMdd"];
                
                for(int i = 0; i < theArray.count; i++){
                    int theTime = [[dateFormatter stringFromDate:[theArray objectAtIndex:i]] integerValue];
                    int currentTime = [[dateFormatter stringFromDate:_currentDate] integerValue];
                    if([[dateFormatter stringFromDate:[theArray objectAtIndex:0]] integerValue]<currentTime){
                        [theArray insertObject:_currentDate atIndex:i];
                        flag = 1;
                        break;
                    }
                    if(theTime == currentTime){
                        flag = 1;
                        break;
                    }
                    if(theArray.count==1){
                        if(theTime>currentTime){
                            [theArray insertObject:_currentDate atIndex:i+1];
                            flag = 1;
                        }
                        break;
                    }
                    if(i == theArray.count-1) break;
                    int nextTime = [[dateFormatter stringFromDate:[theArray objectAtIndex:i+1]] integerValue];
                    if(currentTime<theTime && currentTime > nextTime){
                        [theArray insertObject:_currentDate atIndex:i+1];
                        flag = 1;
                        break;
                    }
                }
                if(flag == 0){
                    [theArray addObject:_currentDate];
                }
                [userDefaults setObject:theArray forKey:[NSString stringWithFormat:@"recentHistoryArray_%@",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
                [userDefaults synchronize];
                
                
                
                [_viewOfUpdateInfo setHidden:NO];
                [self updateUIByDataSource:_historyModel.historyTracks];
                
            }
            
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}



- (void)updateUIByDataSource:(NSArray *)aDataSource
{
    _dataSource = aDataSource;
    if ([_dataSource count]!=0) {
        _viewOfUpdateInfo.hidden=NO;
        float mileage=0;
        for(int i=0;i<_dataSource.count;i++){
            NSDictionary *historyPoint=[_dataSource objectAtIndex:i];
            if (![historyPoint objectForKey:@"trackDistance"]) {
                mileage+=0;
            }else{
                mileage+=[[historyPoint objectForKey:@"trackDistance"] floatValue];
            }
        }
        [_buttonMileage setTitle:[NSString stringWithFormat:@"%07.02f",mileage/1000] forState:UIControlStateNormal];
        
    }else{
        _viewOfUpdateInfo.hidden=YES;
    }
    [_tableView reloadData];
}


- (void)dealloc
{
    [_historyModel removeObserver:self forKeyPath:KVO_HISTORY_TRACK_POINTS_PATH_NAME];
    [_historyModel removeObserver:self forKeyPath:KVO_HISTORY_TRACKS_PATH_NAME];
    [_historyModel cancel];
}


#pragma mark - UITableViewDataSource

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.delegate clickCellViewController:self Argumets:[NSArray arrayWithObjects:@"obd_demo",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,[(NSDictionary*)_dataSource[indexPath.row] objectForKey:@"startTime"],[(NSDictionary*)_dataSource[indexPath.row] objectForKey:@"stopTime"], nil]];
    [self clickCellViewController:[NSArray arrayWithObjects:@"obd_demo",
                                   [ADSingletonUtil sharedInstance].currentDeviceBase.deviceID,
                                   [(NSDictionary*)_dataSource[indexPath.row] objectForKey:@"startTime"],
                                   [(NSDictionary*)_dataSource[indexPath.row] objectForKey:@"stopTime"],
                                   [(NSDictionary*)_dataSource[indexPath.row] objectForKey:@"trackDistance"], nil]];
}

- (void) clickCellViewController:(NSArray *)aArgumets{
    ADHistroyMapViewController *historyMapView=[[ADHistroyMapViewController alloc]initWithNibName:nil bundle:nil data:aArgumets];
    [self.navigationController pushViewController:historyMapView animated:YES];
    //    [self presentViewController:historyMapView animated:YES completion:nil];
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
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,105, cell.bounds.size.width, 1)];
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
//    return 96;
    return 105;
}

-(void)requestWithDate{
    NSTimeInterval oneday=24*60*60;
    NSDate* nextDay=[NSDate dateWithTimeInterval:oneday sinceDate:_currentDate];
    [_historyModel requestHistoryWithMode:HISTORYMODEL_TRACKS
                                 DeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID
                                startDate:_currentDate
                                  endDate:nextDay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark -ADRecentHistroyDelegate
- (void)fllush:(NSDate *)theDate
{
    _currentDate = theDate;
    _timeLabel.text=[_formatter stringFromDate:_currentDate];
    [self requestWithDate];
}

@end
