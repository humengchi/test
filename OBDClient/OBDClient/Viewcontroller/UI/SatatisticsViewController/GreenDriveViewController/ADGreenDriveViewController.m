//
//  ADGreenDriveViewController.m
//  OBDClient
//
//  Created by hys on 13/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGreenDriveViewController.h"
#import "ADGreenDriveGraphicViewController.h"

@interface ADGreenDriveViewController ()

@end

@implementation ADGreenDriveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _countCenterModel=[[ADCountCenterModel alloc]init];
        _countCenterModel.countCenterDelegate=self;
        _resultDict = [[NSMutableDictionary alloc] init];
        
    }
    return self;
}

- (IBAction)gotoGraphicVC:(id)sender
{
    ADGreenDriveGraphicViewController *graphicVC = [[ADGreenDriveGraphicViewController alloc] init];
    [self.navigationController pushViewController:graphicVC animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIButton *graphic = [UIButton buttonWithType:UIButtonTypeCustom];
//    graphic.frame = CGRectMake(100, 350, 100, 30);
//    [graphic setTitle:@"详情" forState:UIControlStateNormal];
////    [graphic setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [graphic addTarget:self action:@selector(gotoGraphicVC:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:graphic];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"详情" style:UIBarButtonItemStylePlain target:self action:@selector(gotoGraphicVC:)];
    rightBtn.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.title = @"驾驶行为分析";
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    _scoreImgView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 0, 120, 85)];
    _scoreImgView.image=[UIImage imageNamed:@"star3.png"];
    [self.view addSubview:_scoreImgView];
    UILabel* lab1=[[UILabel alloc]initWithFrame:CGRectMake(0, 120, WIDTH, 20)];
    lab1.text=@"针对您最近的驾驶行为分析，您的驾驶行为：";//NSLocalizedStringFromTable(@"currentDriveHabitScoreKey",@"MyString", @"");
    [lab1 setBackgroundColor:[UIColor clearColor]];
    lab1.textAlignment = UITextAlignmentCenter;
    lab1.textColor=[UIColor whiteColor];
    [lab1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0f]];
    [self.view addSubview:lab1];
    
    
    _scoreLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, lab1.frame.origin.y+30, WIDTH, 50)];
    _scoreLabel.text=@"优秀";
    _scoreLabel.textAlignment = UITextAlignmentCenter;
    [_scoreLabel setBackgroundColor:[UIColor clearColor]];
    _scoreLabel.textColor=[UIColor colorWithRed:76.0/255.0 green:199.0/255.0 blue:122.0/255.0 alpha:1.0];
    _scoreLabel.font=[UIFont systemFontOfSize:30.0f];
    [self.view addSubview:_scoreLabel];
    
//    UILabel* lab2=[[UILabel alloc]initWithFrame:CGRectMake(267, 120, 20, 20)];
//    [lab2 setBackgroundColor:[UIColor clearColor]];
//    lab2.text=NSLocalizedStringFromTable(@"markKey",@"MyString", @"");
//    lab2.textColor=[UIColor whiteColor];
//    [lab2 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
//    [self.view addSubview:lab2];
    
//    UILabel* lab3=[[UILabel alloc]initWithFrame:CGRectMake(10, 170, 105, 20)];
//    [lab3 setBackgroundColor:[UIColor clearColor]];
//    lab3.text=NSLocalizedStringFromTable(@"thanTheAverageKey",@"MyString", @"");
//    lab3.textColor=[UIColor whiteColor];
//    [lab3 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
//    [self.view addSubview:lab3];
//
//    UILabel* lab4=[[UILabel alloc]initWithFrame:CGRectMake(115, 165, 30, 25)];
//    [lab4 setBackgroundColor:[UIColor clearColor]];
//    lab4.text=@"68";
//    lab4.textColor=[UIColor colorWithRed:79.0/255.0 green:147.0/255.0 blue:228.0/255.0 alpha:1.0];
//    lab4.font=[UIFont systemFontOfSize:24.0f];
//    [self.view addSubview:lab4];
//
//    UILabel* lab5=[[UILabel alloc]initWithFrame:CGRectMake(145, 170, 40, 20)];
//    [lab5 setBackgroundColor:[UIColor clearColor]];
//    lab5.text=NSLocalizedStringFromTable(@"markHighKey",@"MyString", @"");
//    lab5.textColor=[UIColor whiteColor];
//    [lab5 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
//    [self.view addSubview:lab5];
    
    UILabel* lab6=[[UILabel alloc]initWithFrame:CGRectMake(0, 200, WIDTH, 20)];
    [lab6 setBackgroundColor:[UIColor clearColor]];
    lab6.tag = 3322;
    lab6.text=NSLocalizedStringFromTable(@"makePersistentEffortsNotProud",@"MyString", @"");
    lab6.textColor=[UIColor whiteColor];
    [lab6 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17.0f]];
    lab6.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:lab6];
    
    UILabel* lab7=[[UILabel alloc]initWithFrame:CGRectMake(0, 230, 240, 20)];
    [lab7 setBackgroundColor:[UIColor clearColor]];
    lab7.text=@"<<点击右上角按钮查看详情";
    lab7.textColor=[UIColor whiteColor];
    [lab7 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0f]];
    lab7.textAlignment = UITextAlignmentRight;
    [self.view addSubview:lab7];
    
    
    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    [_countCenterModel startRequestGreenDriveScroe:[NSArray arrayWithObject:vin]];
    
    
//    //图标数据获取
//    NSDate* today=[NSDate date];
//    _cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    _component=[_cal components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit) fromDate:today];
//    [_component setDay:01];
//    _currentShowDate=[_cal dateFromComponents:_component];
//    _formatter=[[NSDateFormatter alloc]init];
//    [_formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    _currentShowDateStr=[_formatter stringFromDate:_currentShowDate];
//    NSString* deviceID= [ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
////    [_countCenterModel startRequestMonthDrivingBehavior:[NSArray arrayWithObjects:deviceID, _currentShowDateStr, nil]];
////    _countCenterModel.countCenterDelegate=self;
//    
//    //Bottom View
//    UIView* bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 370, WIDTH, 46)];
//    [bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_topbar_bg~iphone.png"]]];
//    [self.view addSubview:bottomView];
//    
//    UIImageView* leftlineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(59, 0, 2, 46)];
//    leftlineImgView.image=[UIImage imageNamed:@"shuline.png"];
//    [bottomView addSubview:leftlineImgView];
//    
//    UIImageView* leftarrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 13, 20, 20)];
//    leftarrowImgView.image=[UIImage imageNamed:@"leftarrow.png"];
//    [bottomView addSubview:leftarrowImgView];
//    
//    UIButton* leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 46)];
//    leftButton.tag=0;
//    [leftButton setBackgroundColor:[UIColor clearColor]];
//    [leftButton addTarget:self action:@selector(selectCalendar:) forControlEvents:UIControlEventTouchUpInside];
//    [bottomView addSubview:leftButton];
//    
//    UIImageView* rightlineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(259, 0, 2, 46)];
//    rightlineImgView.image=[UIImage imageNamed:@"shuline.png"];
//    [bottomView addSubview:rightlineImgView];
//    
//    UIImageView* rightarrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 13, 20, 20)];
//    rightarrowImgView.image=[UIImage imageNamed:@"rightarrow.png"];
//    [bottomView addSubview:rightarrowImgView];
//    
//    UIButton* rightButton=[[UIButton alloc]initWithFrame:CGRectMake(260, 0, 60, 46)];
//    rightButton.tag=1;
//    [rightButton addTarget:self action:@selector(selectCalendar:) forControlEvents:UIControlEventTouchUpInside];
//    [rightButton setBackgroundColor:[UIColor clearColor]];
//    [bottomView addSubview:rightButton];
//    
//    _showCalendarLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 26)];
//    [_showCalendarLabel setBackgroundColor:[UIColor clearColor]];
//    _showCalendarLabel.textColor=[UIColor whiteColor];
//    _showCalendarLabel.textAlignment=UITextAlignmentCenter;
//    _showCalendarLabel.text=[NSString stringWithFormat:@"%d-%2d",[_component year],[_component month]];
//    [bottomView addSubview:_showCalendarLabel];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_scoreImgView setFrame:CGRectMake(100, 64, 120, 85)];
        [lab1 setFrame:CGRectMake(0, 184, WIDTH, 20)];
        [_scoreLabel setFrame:CGRectMake(0, 210, WIDTH, 50)];
//        [lab2 setFrame:CGRectMake(267+10, 184, 20, 20)];
//        [lab3 setFrame:CGRectMake(10+40, 234, 105, 20)];
//        [lab4 setFrame:CGRectMake(115+40, 229, 30, 25)];
//        [lab5 setFrame:CGRectMake(145+40, 234, 40, 20)];
        [lab6 setFrame:CGRectMake(0, 264, WIDTH, 20)];
        [lab7 setFrame:CGRectMake(0, 310, 260, 20)];
        
        
//        _lineChartView.frame = CGRectMake(8, 67, 288, 221);
//        _btnsView.frame = CGRectMake(0, 391-40, WIDTH, 89);
//        [bottomView setFrame:CGRectMake(0, 440, WIDTH, 46)];
//        ((UIView*)[self.view viewWithTag:300]).frame = CGRectMake(130, 280, 61, 21);
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

        
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
//        _lineChartView.frame = CGRectMake(8, 67, 288, 201);
//        _btnsView.frame = CGRectMake(0, 440-40, WIDTH, 89);
//        [bottomView setFrame:CGRectMake(0, 464, WIDTH, 46)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_scoreImgView setFrame:CGRectMake(100, 64, 120, 85)];
        [lab1 setFrame:CGRectMake(0, 184, WIDTH, 40)];
        [_scoreLabel setFrame:CGRectMake(0, 210, WIDTH, 50)];
//        [lab2 setFrame:CGRectMake(267+10, 184, 20, 20)];
//        [lab3 setFrame:CGRectMake(10+40, 234, 105, 20)];
//        [lab4 setFrame:CGRectMake(115+40, 229, 30, 25)];
//        [lab5 setFrame:CGRectMake(145+40, 234, 40, 20)];
        [lab6 setFrame:CGRectMake(0, 264, WIDTH, 20)];
        [lab7 setFrame:CGRectMake(0, 310, 260, 20)];
        
//        ((UIView*)[self.view viewWithTag:300]).frame = CGRectMake(130, 288, 61, 21);
//        _lineChartView.frame = CGRectMake(8, 67, 288, 141);
//        _btnsView.frame = CGRectMake(0, 479-40, WIDTH, 89);
//        [bottomView setFrame:CGRectMake(0, 528, WIDTH, 46)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}

//    _currentSelectedBtn = (UIButton*)[self.view viewWithTag:200];
//    _currentSelectedBtn.selected = YES;
    
    
//    NSDate* today=[NSDate date];
//    NSCalendar *cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
//    NSDateComponents *component=[cal components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit) fromDate:today];
//    [component setDay:01];
//    NSDate *currentShowDate=[cal dateFromComponents:component];
//    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
//    [formatter setDateFormat:@"YYYY-MM-dd"];
//    NSString *currentShowDateStr=[formatter stringFromDate:currentShowDate];
//    @"6C500CBD";//
//    NSString* deviceID= [ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
//    [_countCenterModel startRequestMonthDrivingBehavior:[NSArray arrayWithObjects:deviceID, currentShowDateStr, nil]];
//    _countCenterModel.countCenterDelegate=self;
    
    
//    self.lineChartView.max = 10;
//    self.lineChartView.min = 0;
//    self.lineChartView.interval = 1;
//    self.lineChartView.xAxisValues = @[@"",@"2", @"", @"4", @"", @"6", @"", @"8", @"", @"10", @"", @"12", @"", @"14", @"", @"16", @"", @"18", @"", @"20", @"", @"22", @"", @"24", @"", @"26", @"", @"28", @"", @"30", @"", @""];
//    self.lineChartView.yAxisValues = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
//    self.lineChartView.axisLeftLineWidth = 32;
}

//#pragma mark -Button Action
//-(void)selectCalendar:(id)sender{
//    UIButton* btn=(UIButton*)sender;
//    int tag=btn.tag;
//    if (tag==0) {
//        if ([_component month]==1) {
//            [_component setYear:[_component year]-1];
//            [_component setMonth:12];
//        }else{
//            [_component setMonth:[_component month]-1];
//        }
//    }else if (tag==1){
//        if ([_component month]==12) {
//            [_component setYear:[_component year]+1];
//            [_component setMonth:01];
//        }else{
//            
//            [_component setMonth:[_component month]+1];
//        }
//    }
//    _showCalendarLabel.text=[NSString stringWithFormat:@"%d-%02d",[_component year],[_component month]];
//    _currentShowDate=[_cal dateFromComponents:_component];
//    _currentShowDateStr=[_formatter stringFromDate:_currentShowDate];
//    //    NSLog(@"%@",_currentShowDateStr);
////    NSString* deviceID=[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
////    [_countCenterModel startRequestMonthCountMileage:[NSArray arrayWithObjects:deviceID,_currentShowDateStr, nil]];
//    NSString* deviceID= [ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
//    [_countCenterModel startRequestMonthDrivingBehavior:[NSArray arrayWithObjects:deviceID, _currentShowDateStr, nil]];
//    _currentSelectedBtn.selected = NO;
//    _currentSelectedBtn = (UIButton*)[self.view viewWithTag:200];
//    _currentSelectedBtn.selected = YES;
//}
//
//- (void)createGrap:(NSArray*)theArray AndColor:(UIColor*)color
//{
//    if(self.lineChartView.plots.count){
//        [self.lineChartView.plots removeAllObjects];
//    }
//    PNPlot *plot1 = [[PNPlot alloc] init];
//    plot1.plottingValues = theArray;
//    plot1.lineColor = color;
//    plot1.lineWidth = 0.5;
//    [self.lineChartView addPlot:plot1];
//    [self.lineChartView setNeedsDisplay];
//}
//
//#pragma mark -Methods_button
//- (IBAction)changGrapButtonPressed:(id)sender
//{
//    UIButton *btn = (UIButton*)sender;
//    _currentSelectedBtn.selected = NO;
//    _currentSelectedBtn = (UIButton*)[self.view viewWithTag:btn.tag];
//    _currentSelectedBtn.selected = YES;
//    UIColor *color;
//    NSString *key;
//    switch (btn.tag) {
//        case 200:{
//            color = [UIColor greenColor];
//            key = @"SPEED";
//        }
//            break;
//        case 201:{
//            color = [UIColor redColor];
//            key = @"HARD_CORNER";
//        }
//            break;
//        case 202:{
//            color = [UIColor orangeColor];
//            key = @"HARD_BREAK";
//        }
//            break;
//        case 203:{
//            color = [UIColor yellowColor];
//            key = @"HARD_ACCEL";
//        }
//            break;
//        case 204:{
//            color = [UIColor blueColor];
//            key = @"HARD_DECEL";
//        }
//            break;
//        case 205:{
//            color = [UIColor blueColor];
//            key = @"FATIGUE_DRIV";
//        }
//            break;
//        case 206:{
//            color = [UIColor purpleColor];
//            key = @"RPM";
//        }
//            break;
//        case 207:{
//            color = [UIColor grayColor];
//            key = @"IDLING";
//        }
//            break;
//            
//        default:
//            break;
//    }
//    if([_resultDict objectForKey:key] != [NSNull null]){
//        NSMutableArray *theArray = [[NSMutableArray alloc] init];
//        theArray = [[[_resultDict objectForKey:key]componentsSeparatedByString:@";"] mutableCopy];
//        NSArray *yArray = [[NSArray alloc] init];
//        float range = 1;
//        float temp = 0;
//        for(NSString *num in theArray){
//            if(temp<[num floatValue]){
//                if([num floatValue] > 10 && [num floatValue] <= 20){
//                    range = 2;
//                    yArray = @[@"0", @"2", @"4", @"6",@"8", @"10", @"12",@"14", @"16", @"18",@"20"];
//                }else if([num floatValue] > 20 && [num floatValue] <= 30){
//                    range = 3;
//                    yArray = @[@"0", @"3", @"6", @"9",@"12", @"15", @"18",@"21", @"24", @"27",@"30"];
//                }else if([num floatValue] > 30 && [num floatValue] <= 40){
//                    range = 4;
//                    yArray = @[@"0", @"4", @"8", @"12",@"16", @"20", @"24",@"28", @"32", @"36",@"40"];
//                }else if([num floatValue] > 40 && [num floatValue] <= 50){
//                    range = 5;
//                    yArray = @[@"0", @"5", @"10", @"15",@"20", @"25", @"30",@"35", @"40", @"45",@"50"];
//                }else if([num floatValue] > 50){
//                    range = 10;
//                    yArray = @[@"0", @"10", @"20", @"30",@"40", @"50", @"60",@"70", @"80", @"90",@"100"];
//                }else{
//                    yArray = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
//                }
//                temp = [num floatValue];
//            }
//        }
//        self.lineChartView.yAxisValues = yArray;
//        self.lineChartView.range = range;
//        [self createGrap:theArray  AndColor:color];
//    }else{
//        self.lineChartView.yAxisValues = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
//        self.lineChartView.range = 1;
//        [self createGrap:nil  AndColor:color];
//    }
//}



#pragma mark -ADCountCenterDeleagte
-(void)handleGreenDriveScroe:(NSDictionary *)dictionary{
    NSString* data=[dictionary objectForKey:@"data"];
    int score=[data intValue];
//    _scoreLabel.text=data;
    NSString *string= @"";
    UIColor *color;
    if (score==0) {
        _scoreImgView.image=[UIImage imageNamed:@"star0.png"];
        string = @"有待改进";
        color = [UIColor grayColor];
    }else if (score<=20){
        _scoreImgView.image=[UIImage imageNamed:@"star1.png"];
        string = @"有待改进";
        color = [UIColor grayColor];
    }else if (score<=40){
        _scoreImgView.image=[UIImage imageNamed:@"star2.png"];
        string = @"有待改进";
        color = [UIColor grayColor];
    }else if (score<=60){
        _scoreImgView.image=[UIImage imageNamed:@"star3.png"];
        string = @"有待改进";
        color = [UIColor grayColor];
        ((UILabel*)[self.view viewWithTag:3322]).text = @"请再接再厉，不要灰心";
    }else if (score<=80){
        _scoreImgView.image=[UIImage imageNamed:@"star4.png"];
        string = @"普通";
        color = [UIColor blueColor];
    }else if (score<=100){
        _scoreImgView.image=[UIImage imageNamed:@"star5.png"];
        string = @"优秀";
        color = [UIColor colorWithRed:76.0/255.0 green:199.0/255.0 blue:122.0/255.0 alpha:1.0];
    }
    _scoreLabel.textColor = color;
    _scoreLabel.text = string;
}

//- (void)handleMonthDrivingBehavior:(NSDictionary *)dictionary
//{
//    _resultDict = [[[dictionary objectForKey:@"data"] objectAtIndex:0]mutableCopy];
//    if([_resultDict objectForKey:@"SPEED"] == [NSNull null]){
//        self.lineChartView.yAxisValues = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
//        self.lineChartView.range = 1;
//        [self createGrap:nil  AndColor:[UIColor greenColor]];
//        return;
//    }
//    NSMutableArray *theArray = [[NSMutableArray alloc] init];
//    theArray = [[[_resultDict objectForKey:@"SPEED"]componentsSeparatedByString:@";"] mutableCopy];
//    
//    NSArray *yArray = [[NSArray alloc] init];
//    float range = 1;
//    float temp = 0;
//    for(NSString *num in theArray){
//        if(temp<[num floatValue]){
//            if([num floatValue] > 10 && [num floatValue] <= 20){
//                range = 2;
//                yArray = @[@"0", @"2", @"4", @"6",@"8", @"10", @"12",@"14", @"16", @"18",@"20"];
//            }else if([num floatValue] > 20 && [num floatValue] <= 30){
//                range = 3;
//                yArray = @[@"0", @"3", @"6", @"9",@"12", @"15", @"18",@"21", @"24", @"27",@"30"];
//            }else if([num floatValue] > 30 && [num floatValue] <= 40){
//                range = 4;
//                yArray = @[@"0", @"4", @"8", @"12",@"16", @"20", @"24",@"28", @"32", @"36",@"40"];
//            }else if([num floatValue] > 40 && [num floatValue] <= 50){
//                range = 5;
//                yArray = @[@"0", @"5", @"10", @"15",@"20", @"25", @"30",@"35", @"40", @"45",@"50"];
//            }else if([num floatValue] > 50){
//                range = 10;
//                yArray = @[@"0", @"10", @"20", @"30",@"40", @"50", @"60",@"70", @"80", @"90",@"100"];
//            }else{
//                yArray = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
//            }
//            temp = [num floatValue];
//        }
//    }
//    if(yArray.count == 0){
//        self.lineChartView.yAxisValues = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
//        self.lineChartView.range = 1;
//    }else{
//        self.lineChartView.yAxisValues = yArray;
//        self.lineChartView.range = range;
//    }
//    [self createGrap:theArray  AndColor:[UIColor greenColor]];
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
