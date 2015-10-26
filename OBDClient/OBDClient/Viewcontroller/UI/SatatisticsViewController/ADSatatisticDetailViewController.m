//
//  ADSatatisticDetailViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSatatisticDetailViewController.h"

@interface ADSatatisticDetailViewController ()

@end

@implementation ADSatatisticDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _countCenterModel=[[ADCountCenterModel alloc]init];
        _meliageArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    NSString* deviceID=[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    NSDate* today=[NSDate date];
    _cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    _component=[_cal components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit) fromDate:today];
//    NSInteger year=[conponent year];
//    NSInteger month=[conponent month];
//    [_component setMonth:11];
    [_component setDay:01];
    _currentShowDate=[_cal dateFromComponents:_component];
    _formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    _currentShowDateStr=[_formatter stringFromDate:_currentShowDate];
//    NSLog(@"%@",_currentShowDateStr);
    [_countCenterModel startRequestMonthCountMileage:[NSArray arrayWithObjects:deviceID,_currentShowDateStr, nil]];
    _countCenterModel.countCenterDelegate=self;
    
    CPTGraphHostingView* hostView=[[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
    [hostView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    [self.view addSubview:hostView];
    
    _barChart=[[CPTXYGraph alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 270)];
    [hostView setHostedGraph:_barChart];
    
    _barChart.plotAreaFrame.paddingLeft=35.0;
    _barChart.plotAreaFrame.paddingTop=15.0;
    _barChart.plotAreaFrame.paddingRight=0.0f;
    _barChart.plotAreaFrame.paddingBottom=30.0;
    
    _plotSpace=(CPTXYPlotSpace*)_barChart.defaultPlotSpace;
    
    _plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(31.0f)];
    _plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(100.0f)];
    CPTXYAxisSet* axisSet=(CPTXYAxisSet*)_barChart.axisSet;
    CPTXYAxis* x=axisSet.xAxis;

    CPTMutableLineStyle* xlineStyle=[x.axisLineStyle mutableCopy];
    xlineStyle.lineColor=[CPTColor whiteColor];
    x.axisLineStyle=xlineStyle;
    
    CPTMutableTextStyle* xtextStyle=[x.labelTextStyle mutableCopy];
    [xtextStyle setColor:[CPTColor whiteColor]];
    [xtextStyle setFontSize:8.0f];
    x.labelTextStyle=xtextStyle;
        
    x.majorTickLineStyle=xlineStyle;
    x.majorTickLength=10;
    x.majorIntervalLength=CPTDecimalFromString(@"1");
    
    x.minorTickLineStyle=nil;
    x.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");
    
    _barChart.title=NSLocalizedStringFromTable(@"dayMeliageCountChartKey",@"MyString", @"");
    
    x.title=NSLocalizedStringFromTable(@"dateDayKey",@"MyString", @"");
    x.titleLocation=CPTDecimalFromFloat(13.5f);
    x.titleOffset=17.0f;
    
    x.labelingPolicy=CPTAxisLabelingPolicyNone;
    x.axisConstraints=[CPTConstraints constraintWithLowerOffset:0.0];// 加上这两句才能显示label
    NSMutableArray* labelArray=[NSMutableArray arrayWithCapacity:15];
    NSArray* conArray=[NSArray arrayWithObjects:@"2",@"4",@"6",@"8",@"10",@"12",@"14",@"16",@"18",@"20",@"22",@"24",@"26",@"28",@"30", nil];
    int labelLocation=0;
    for (NSString* label in conArray) {
        
        CPTAxisLabel* newLabel=[[CPTAxisLabel alloc]initWithText:label textStyle:xtextStyle];
        labelLocation++;
        newLabel.tickLocation=[[NSNumber numberWithInt:(labelLocation*2)] decimalValue];
        newLabel.offset=x.labelOffset+x.majorTickLength-10;
        [labelArray addObject:newLabel];
    }
    x.axisLabels=[NSSet setWithArray:labelArray];
    
    CPTXYAxis* y=axisSet.yAxis;
    CPTMutableLineStyle* ylineStyle=[y.axisLineStyle mutableCopy];
    ylineStyle.lineColor=[CPTColor whiteColor];
    y.axisLineStyle=ylineStyle;
    
    CPTMutableTextStyle* ytextStyle=[y.labelTextStyle mutableCopy];
    [ytextStyle setColor:[CPTColor whiteColor]];
    [ytextStyle setFontSize:12.0f];
    y.labelTextStyle=xtextStyle;
    y.titleTextStyle=ytextStyle;
    x.titleTextStyle=ytextStyle;

    _barChart.titleTextStyle=ytextStyle;
    
    y.majorTickLength=5;
    y.majorTickLineStyle=ylineStyle;
    y.majorIntervalLength=CPTDecimalFromString(@"5");
    y.minorTickLineStyle=nil;
    y.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");
    y.title=NSLocalizedStringFromTable(@"dayMeliageKmKey",@"MyString", @"");
    y.titleLocation=CPTDecimalFromFloat(4.0f);
    y.titleOffset=20.0f;   //x轴偏移
    
    NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
    labelFormatter.numberStyle = NSNumberFormatterNoStyle;
    x.labelFormatter = labelFormatter;
    y.labelFormatter = labelFormatter;
    
    
    _barPlot=[CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:218.0/255.0 green:95.0/255.0 blue:16.0/255.0 alpha:1.0] horizontalBars:NO];
    _barPlot.baseValue=CPTDecimalFromString(@"0.02");
    _barPlot.barWidth=CPTDecimalFromString(@"0.5");
    _barPlot.barOffset=CPTDecimalFromString(@"-0.1");
    _barPlot.identifier=@"BarPlot";
    _barPlot.dataSource=self;
    _barPlot.delegate=self;
    
    [_barChart addPlot:_barPlot toPlotSpace:_plotSpace];
    
    
    //Middle View
    UIView* middleView=[[UIView alloc]initWithFrame:CGRectMake(0, WIDTH, WIDTH, 50)];
    [middleView setBackgroundColor:[UIColor blackColor]];
    [self.view addSubview:middleView];
    
    UILabel* label1=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 55, 17.5)];
    [label1 setBackgroundColor:[UIColor clearColor]];
    label1.text=NSLocalizedStringFromTable(@"monthMeliageKey",@"MyString", @"");
    label1.textColor=[UIColor lightGrayColor];
    label1.font=[UIFont systemFontOfSize:12.0f];
    [middleView addSubview:label1];
    _monthMeliageCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 5, 80, 17.5)];
    _monthMeliageCountLabel.textColor=[UIColor colorWithRed:61.0/255.0 green:96.0/255.0 blue:168.0/255.0 alpha:1.0];
    [_monthMeliageCountLabel setBackgroundColor:[UIColor clearColor]];
    [middleView addSubview:_monthMeliageCountLabel];
    
    UILabel* label2=[[UILabel alloc]initWithFrame:CGRectMake(5, 27.5, 70, 17.5)];
    [label2 setBackgroundColor:[UIColor clearColor]];
    label2.text=NSLocalizedStringFromTable(@"dayAverageMeliageKey",@"MyString", @"");;
    label2.textColor=[UIColor lightGrayColor];
    label2.font=[UIFont systemFontOfSize:12.0f];
    [middleView addSubview:label2];
    _dayAverageMeliageLabel=[[UILabel alloc]initWithFrame:CGRectMake(73, 27.5, 80, 17.5)];
    _dayAverageMeliageLabel.textColor=[UIColor colorWithRed:61.0/255.0 green:96.0/255.0 blue:168.0/255.0 alpha:1.0];
    [_dayAverageMeliageLabel setBackgroundColor:[UIColor clearColor]];
    [middleView addSubview:_dayAverageMeliageLabel];
    
    
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
    [leftButton addTarget:self action:@selector(selectCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:leftButton];
    
    UIImageView* rightlineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(259, 0, 2, 46)];
    rightlineImgView.image=[UIImage imageNamed:@"shuline.png"];
    [bottomView addSubview:rightlineImgView];
    
    UIImageView* rightarrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 13, 20, 20)];
    rightarrowImgView.image=[UIImage imageNamed:@"rightarrow.png"];
    [bottomView addSubview:rightarrowImgView];
    
    UIButton* rightButton=[[UIButton alloc]initWithFrame:CGRectMake(260, 0, 60, 46)];
    rightButton.tag=1;
    [rightButton addTarget:self action:@selector(selectCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:rightButton];
    
    _showCalendarLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 10, 200, 26)];
    [_showCalendarLabel setBackgroundColor:[UIColor clearColor]];
    _showCalendarLabel.textColor=[UIColor whiteColor];
    _showCalendarLabel.textAlignment=UITextAlignmentCenter;
    _showCalendarLabel.text=[NSString stringWithFormat:@"%d-%2d",[_component year],[_component month]];
    [bottomView addSubview:_showCalendarLabel];
    
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [hostView setFrame:CGRectMake(0, 64, WIDTH, WIDTH)];
        [middleView setFrame:CGRectMake(0, 384, WIDTH, 56)];
        [bottomView setFrame:CGRectMake(0, 440, WIDTH, 46)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [hostView setFrame:CGRectMake(0, 20, WIDTH, WIDTH)];
        [middleView setFrame:CGRectMake(0, 408, WIDTH, 56)];
        [bottomView setFrame:CGRectMake(0, 464, WIDTH, 46)];
        [middleView setBackgroundColor:[UIColor clearColor]];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [hostView setFrame:CGRectMake(0, 84, WIDTH, WIDTH)];
        [middleView setFrame:CGRectMake(0, 442, WIDTH, 56)];
        [bottomView setFrame:CGRectMake(0, 528, WIDTH, 46)];
        [middleView setBackgroundColor:[UIColor clearColor]];
        [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    self.view.backgroundColor = [UIColor blackColor];
}

#pragma mark -Button Action
-(void)selectCalendar:(id)sender{
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
    NSString* deviceID=[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    [_countCenterModel startRequestMonthCountMileage:[NSArray arrayWithObjects:deviceID,_currentShowDateStr, nil]];

}
#pragma mark -Plot Data Source Methods
// 返回数据源的纪录数
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    return [_meliageArray count];
}

// 返回数据源的数据
-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    NSDecimalNumber* num=nil;
//    NSDictionary* meliageDic=[_meliageArray objectAtIndex:index];
//    NSString* serverDate=[meliageDic objectForKey:@"serverDate"];
//    NSArray* datearray=[serverDate componentsSeparatedByString:@"-"];
//    NSString* idx=[datearray objectAtIndex:2];
//    float x=[idx integerValue];
//    float distance=[[meliageDic objectForKey:@"distance"] integerValue]/1000+1;
    float x = index+1;
    float distance = [[_meliageArray objectAtIndex:index]floatValue]/1000;
    if(distance == 0) return 0;
    
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        if (fieldEnum==CPTBarPlotFieldBarLocation) {
            num=(NSDecimalNumber*)[NSDecimalNumber numberWithUnsignedInteger:x];
        }
        if (fieldEnum==CPTBarPlotFieldBarTip){
            if (_meliageArray==nil||[_meliageArray count]==0) {
                num=(NSDecimalNumber*)[NSDecimalNumber numberWithFloat:0.5];
            }else{
                num=(NSDecimalNumber*)[NSDecimalNumber numberWithFloat:distance];
            }
        }
    }
    return num;
}

-(CPTFill*)barFillForBarPlot:(CPTBarPlot *)barPlot recordIndex:(NSUInteger)index{
    return nil;
}

// 在柱子上面显示对应的值
//-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
//    CPTMutableTextStyle* textLineStyle=[CPTMutableTextStyle textStyle];
//    textLineStyle.fontSize=14;
//    textLineStyle.color=[CPTColor blackColor];
//    CPTTextLayer* label=[[CPTTextLayer alloc]initWithText:[NSString stringWithFormat:@"%d",index] style:textLineStyle];
//    return label;
//}

#pragma mark-handleRequest
-(void)handleMonthCountMileage:(NSDictionary *)dictionary{
//    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
//    if ([resultCode isEqualToString:@"200"]) {
    if([[dictionary objectForKey:@"resultCode"] integerValue] == 201){
        [IVToastHUD showAsToastErrorWithStatus:@"无数据"];
        if(_meliageArray.count){
            [_meliageArray removeAllObjects];
            _meliageArray = nil;
            [_barPlot reloadData];
        }
        _monthMeliageCountLabel.text=[NSString stringWithFormat:@"%1.1fkm",0.0];
        _dayAverageMeliageLabel.text=[NSString stringWithFormat:@"%1.1fkm",0.0];
        return;
    }
    _meliageArray=[[[dictionary objectForKey:@"data"] componentsSeparatedByString:@";"]mutableCopy];
    [_barPlot reloadData];
    if ([_meliageArray count]==0) {
        _monthMeliageCountLabel.text=[NSString stringWithFormat:@"%1.1fkm",0.0];
        _dayAverageMeliageLabel.text=[NSString stringWithFormat:@"%1.1fkm",0.0];

    }else{
    float sum=0;
    for (NSString* dic in _meliageArray) {
//        int distance=[[dic objectForKey:@"distance"]intValue];
        float distance = [dic floatValue];
        sum+=distance;
    }
    _monthMeliageCountLabel.text=[NSString stringWithFormat:@"%1.1fkm",sum/1000];
    _dayAverageMeliageLabel.text=[NSString stringWithFormat:@"%1.1fkm",sum/(1000*[_meliageArray count])];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.title=self.satatisticTitle;
}

@end
