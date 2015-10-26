//
//  ADGreenDriveGraphicViewController.m
//  OBDClient
//
//  Created by hys on 8/8/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADGreenDriveGraphicViewController.h"

@interface ADGreenDriveGraphicViewController ()

@end

@implementation ADGreenDriveGraphicViewController

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    //图标数据获取
    NSDate* today=[NSDate date];
    _cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    _component=[_cal components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit) fromDate:today];
    [_component setDay:01];
    _currentShowDate=[_cal dateFromComponents:_component];
    _formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    _currentShowDateStr=[_formatter stringFromDate:_currentShowDate];
    NSString* deviceID= [ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    [_countCenterModel startRequestMonthDrivingBehavior:[NSArray arrayWithObjects:deviceID, _currentShowDateStr, nil]];
    _countCenterModel.countCenterDelegate=self;
    
    //Bottom View
    UIView* bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 370, WIDTH, 46)];
    [bottomView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_topbar_bg~iphone.png"]]];
    [self.view addSubview:bottomView];
    
    UIImageView* leftlineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(59, 0, 2, 46)];
    leftlineImgView.image=[UIImage imageNamed:@"shuline.png"];
    [bottomView addSubview:leftlineImgView];
    
    UIImageView* leftarrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 13, 20, 20)];
    leftarrowImgView.image=[UIImage imageNamed:@"leftarrow.png"];
    [bottomView addSubview:leftarrowImgView];
    
    UIButton* leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 46)];
    leftButton.tag=0;
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton addTarget:self action:@selector(selectCalendar1:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftButton];
    
    UIImageView* rightlineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(259, 0, 2, 46)];
    rightlineImgView.image=[UIImage imageNamed:@"shuline.png"];
    [bottomView addSubview:rightlineImgView];
    
    UIImageView* rightarrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 13, 20, 20)];
    rightarrowImgView.image=[UIImage imageNamed:@"rightarrow.png"];
    [bottomView addSubview:rightarrowImgView];
    
    UIButton* rightButton=[[UIButton alloc]initWithFrame:CGRectMake(260, 0, 60, 46)];
    rightButton.tag=1;
    [rightButton addTarget:self action:@selector(selectCalendar1:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:rightButton];
    
    _showCalendarLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 26)];
    [_showCalendarLabel setBackgroundColor:[UIColor clearColor]];
    _showCalendarLabel.textColor=[UIColor whiteColor];
    _showCalendarLabel.textAlignment=UITextAlignmentCenter;
    _showCalendarLabel.text=[NSString stringWithFormat:@"%d-%2d",[_component year],[_component month]];
    [bottomView addSubview:_showCalendarLabel];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        _lineChartView.frame = CGRectMake(8, 67, 288, 221);
        _btnsView.frame = CGRectMake(0, 391-40, WIDTH, 89);
        _graphicColorImage.frame = CGRectMake(0, 300, WIDTH, 40);
        [bottomView setFrame:CGRectMake(0, 440, WIDTH, 46)];
        ((UIView*)[self.view viewWithTag:300]).frame = CGRectMake(130, 280, 61, 21);
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        _lineChartView.frame = CGRectMake(8, 0, 288, 201);
        _btnsView.frame = CGRectMake(0, 330, WIDTH, 89);
        _graphicColorImage.frame = CGRectMake(0, 260, WIDTH, 40);
        [bottomView setFrame:CGRectMake(0, 464, WIDTH, 46)];
    }
    if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS6.0 3.5寸屏幕
        _lineChartView.frame = CGRectMake(8, 0, 288, 260);
        _btnsView.frame = CGRectMake(0, 290, WIDTH, 89);
        _graphicColorImage.frame = CGRectMake(0, 230, WIDTH, 40);
        [bottomView setFrame:CGRectMake(0, 380, WIDTH, 46)];
        ((UIView*)[self.view viewWithTag:300]).frame = CGRectMake(130, 210, 61, 21);
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        ((UIView*)[self.view viewWithTag:300]).frame = CGRectMake(130, 288, 61, 21);
        _lineChartView.frame = CGRectMake(8, 67, 288, 141);
        _btnsView.frame = CGRectMake(0, 479-40, WIDTH, 89);
        _graphicColorImage.frame = CGRectMake(0, 359, WIDTH, 40);
        [bottomView setFrame:CGRectMake(0, 528, WIDTH, 46)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 64)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    
    _currentSelectedBtn = (UIButton*)[self.view viewWithTag:200];
    _currentSelectedBtn.selected = YES;
    
    self.lineChartView.max = 10;
    self.lineChartView.min = 0;
    self.lineChartView.interval = 1;
    self.lineChartView.xAxisValues = @[@"",@"2", @"", @"4", @"", @"6", @"", @"8", @"", @"10", @"", @"12", @"", @"14", @"", @"16", @"", @"18", @"", @"20", @"", @"22", @"", @"24", @"", @"26", @"", @"28", @"", @"30", @"", @""];
    self.lineChartView.yAxisValues = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
    self.lineChartView.axisLeftLineWidth = 32;
    
    for(int i = 0; i < 8; i++){
        UIButton *button = (UIButton*)[self.view viewWithTag:200+i];
        button.selected = YES;
    }
    // Do any additional setup after loading the view from its nib.
}

#pragma mark -Button Action
-(void)selectCalendar1:(id)sender{
    UIButton* btn=(UIButton*)sender;
    int tag=btn.tag;
    if (tag==0) {
        if ([_component month]==1) {
            [_component setYear:[_component year]-1];
            [_component setMonth:12];
        }else{
            [_component setMonth:[_component month]-1];
        }
    }else if (tag==1){
        if ([_component month]==12) {
            [_component setYear:[_component year]+1];
            [_component setMonth:01];
        }else{
            
            [_component setMonth:[_component month]+1];
        }
    }
    _showCalendarLabel.text=[NSString stringWithFormat:@"%d-%02d",[_component year],[_component month]];
    _currentShowDate=[_cal dateFromComponents:_component];
    _currentShowDateStr=[_formatter stringFromDate:_currentShowDate];
    //    NSLog(@"%@",_currentShowDateStr);
    //    NSString* deviceID=[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    //    [_countCenterModel startRequestMonthCountMileage:[NSArray arrayWithObjects:deviceID,_currentShowDateStr, nil]];
    NSString* deviceID= [ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    [_countCenterModel startRequestMonthDrivingBehavior:[NSArray arrayWithObjects:deviceID, _currentShowDateStr, nil]];
    _currentSelectedBtn.selected = NO;
    _currentSelectedBtn = (UIButton*)[self.view viewWithTag:200];
    _currentSelectedBtn.selected = YES;
}

- (void)createGrap:(NSArray*)theArray AndColor:(UIColor*)color
{
//    if(self.lineChartView.plots.count){
//        [self.lineChartView.plots removeAllObjects];
//    }
    PNPlot *plot1 = [[PNPlot alloc] init];
    plot1.plottingValues = theArray;
    plot1.lineColor = color;
    plot1.lineWidth = 0.5;
    [self.lineChartView addPlot:plot1];
    [self.lineChartView setNeedsDisplay];
    if(theArray.count == 0){
//        [IVToastHUD showErrorWithStatus:@"无数据"];
    }
}

#pragma mark -Methods_button
 - (IBAction)changGrapButtonPressed:(id)sender
{
    if(self.lineChartView.plots.count){
        [self.lineChartView.plots removeAllObjects];
    }
    UIButton *btn = (UIButton*)sender;
    if(btn.selected){
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    
    NSMutableArray *yArray = [[NSMutableArray alloc] init];
    float range = 1;
    float temp = 0;
    for(int i = 0; i < 8; i++){
        UIButton *button = (UIButton*)[self.view viewWithTag:200+i];
        if(button.selected == NO){
            continue;
        }
        else{
            UIColor *color;
            NSString *key;
            switch (button.tag) {
                case 200:{
                    color = [UIColor redColor];
                    key = @"SPEED";
                }
                    break;
                case 201:{
                    color = [UIColor yellowColor];
                    key = @"HARD_CORNER";
                }
                    break;
                case 202:{
                    color = [UIColor colorWithRed:0 green:125.0f/255.0f blue:197.0f/255.0f alpha:1];
                    key = @"HARD_BREAK";
                }
                    break;
                case 203:{
                    color = [UIColor blackColor];
                    key = @"HARD_ACCEL";
                }
                    break;
                case 204:{
                    color = [UIColor greenColor];
                    key = @"HARD_DECEL";
                }
                    break;
                case 205:{
                    color = [UIColor colorWithRed:0 green:136.0f/255.0f blue:92.0f/255.0f alpha:1];
                    key = @"FATIGUE_DRIV";
                }
                    break;
                case 206:{
                    color = [UIColor colorWithRed:149.0f/255.0f green:21.0f/255.0f blue:114.0f/255.0f alpha:1];
                    key = @"RPM";
                }
                    break;
                case 207:{
                    color = [UIColor colorWithRed:204.0f/255.0f green:76.0f/255.0f blue:25.0f/255.0f alpha:1];
                    key = @"IDLING";
                }
                    break;
                    
                default:
                    break;
            }
            if([_resultDict objectForKey:key] != [NSNull null]){
                NSMutableArray *theArray = [[NSMutableArray alloc] init];
                theArray = [[[_resultDict objectForKey:key]componentsSeparatedByString:@";"] mutableCopy];
                
                for(NSString *num in theArray){
                    if(temp<[num floatValue]){
                        if([num floatValue] > 10 && [num floatValue] <= 20){
                            range = 2;
                            if(yArray.count!=0){
                                [yArray removeAllObjects];
                            }
                            yArray = [@[@"0", @"2", @"4", @"6",@"8", @"10", @"12",@"14", @"16", @"18",@"20"] mutableCopy];
                        }else if([num floatValue] > 20 && [num floatValue] <= 30){
                            range = 3;
                            if(yArray.count!=0){
                                [yArray removeAllObjects];
                            }
                            yArray = [@[@"0", @"3", @"6", @"9",@"12", @"15", @"18",@"21", @"24", @"27",@"30"]mutableCopy];
                        }else if([num floatValue] > 30 && [num floatValue] <= 40){
                            range = 4;
                            if(yArray.count!=0){
                                [yArray removeAllObjects];
                            }
                            yArray = [@[@"0", @"4", @"8", @"12",@"16", @"20", @"24",@"28", @"32", @"36",@"40"]mutableCopy];
                        }else if([num floatValue] > 40 && [num floatValue] <= 50){
                            range = 5;
                            if(yArray.count!=0){
                                [yArray removeAllObjects];
                            }
                            yArray = [@[@"0", @"5", @"10", @"15",@"20", @"25", @"30",@"35", @"40", @"45",@"50"]mutableCopy];
                        }else if([num floatValue] > 50){
                            range = 10;
                            if(yArray.count!=0){
                                [yArray removeAllObjects];
                            }
                            yArray = [@[@"0", @"10", @"20", @"30",@"40", @"50", @"60",@"70", @"80", @"90",@"100"]mutableCopy];
                        }else{
                            if(yArray.count!=0){
                                [yArray removeAllObjects];
                            }
                            yArray = [@[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"]mutableCopy];
                        }
                        temp = [num floatValue];
                    }
                }
                self.lineChartView.yAxisValues = yArray;
                self.lineChartView.range = range;
                [self.lineChartView setNeedsDisplay];
                PNPlot *plot1 = [[PNPlot alloc] init];
                plot1.plottingValues = theArray;
                plot1.lineColor = color;
                plot1.lineWidth = 0.5;
                [self.lineChartView addPlot:plot1];
            }else{
                UIButton *button = (UIButton*)[self.view viewWithTag:200+i];
                button.selected = NO;
            }
        }
    }
    [self.lineChartView setNeedsDisplay];
}

- (IBAction)changGrapButtonPressed1:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    _currentSelectedBtn.selected = NO;
    _currentSelectedBtn = (UIButton*)[self.view viewWithTag:btn.tag];
    _currentSelectedBtn.selected = YES;
    UIColor *color;
    NSString *key;
    switch (btn.tag) {
        case 200:{
            color = [UIColor greenColor];
            key = @"SPEED";
        }
            break;
        case 201:{
            color = [UIColor redColor];
            key = @"HARD_CORNER";
        }
            break;
        case 202:{
            color = [UIColor orangeColor];
            key = @"HARD_BREAK";
        }
            break;
        case 203:{
            color = [UIColor yellowColor];
            key = @"HARD_ACCEL";
        }
            break;
        case 204:{
            color = [UIColor blueColor];
            key = @"HARD_DECEL";
        }
            break;
        case 205:{
            color = [UIColor blueColor];
            key = @"FATIGUE_DRIV";
        }
            break;
        case 206:{
            color = [UIColor purpleColor];
            key = @"RPM";
        }
            break;
        case 207:{
            color = [UIColor grayColor];
            key = @"IDLING";
        }
            break;
            
        default:
            break;
    }
    if([_resultDict objectForKey:key] != [NSNull null]){
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        theArray = [[[_resultDict objectForKey:key]componentsSeparatedByString:@";"] mutableCopy];
        NSArray *yArray = [[NSArray alloc] init];
        float range = 1;
        float temp = 0;
        for(NSString *num in theArray){
            if(temp<[num floatValue]){
                if([num floatValue] > 10 && [num floatValue] <= 20){
                    range = 2;
                    yArray = @[@"0", @"2", @"4", @"6",@"8", @"10", @"12",@"14", @"16", @"18",@"20"];
                }else if([num floatValue] > 20 && [num floatValue] <= 30){
                    range = 3;
                    yArray = @[@"0", @"3", @"6", @"9",@"12", @"15", @"18",@"21", @"24", @"27",@"30"];
                }else if([num floatValue] > 30 && [num floatValue] <= 40){
                    range = 4;
                    yArray = @[@"0", @"4", @"8", @"12",@"16", @"20", @"24",@"28", @"32", @"36",@"40"];
                }else if([num floatValue] > 40 && [num floatValue] <= 50){
                    range = 5;
                    yArray = @[@"0", @"5", @"10", @"15",@"20", @"25", @"30",@"35", @"40", @"45",@"50"];
                }else if([num floatValue] > 50){
                    range = 10;
                    yArray = @[@"0", @"10", @"20", @"30",@"40", @"50", @"60",@"70", @"80", @"90",@"100"];
                }else{
                    yArray = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
                }
                temp = [num floatValue];
            }
        }
        self.lineChartView.yAxisValues = yArray;
        self.lineChartView.range = range;
        [self createGrap:theArray  AndColor:color];
    }else{
        self.lineChartView.yAxisValues = @[@"0", @"1", @"2", @"3",@"4", @"5", @"6",@"7", @"8", @"9",@"10"];
        self.lineChartView.range = 1;
        [self createGrap:nil  AndColor:color];
    }
}


#pragma mark -ADCountCenterDeleagte
- (void)handleMonthDrivingBehavior:(NSDictionary *)dictionary
{
    _resultDict = [[[dictionary objectForKey:@"data"] objectAtIndex:0]mutableCopy];
    for(int i = 0; i < 8; i++){
        UIButton *button = (UIButton*)[self.view viewWithTag:200+i];
        button.selected = YES;
    }
    [self changGrapButtonPressed:nil];
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
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
