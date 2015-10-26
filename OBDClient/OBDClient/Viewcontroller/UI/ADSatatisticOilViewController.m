//
//  ADSatatisticOilViewController.m
//  OBDClient
//
//  Created by hys on 7/7/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADSatatisticOilViewController.h"
#import "NSDate+Helper.h"
#import "IVToastHUD.h"

@interface ADSatatisticOilViewController ()
{
    int i;
}

@end

@implementation ADSatatisticOilViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _countCenterModel=[[ADCountCenterModel alloc]init];
        _resultArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    NSDate* today=[NSDate date];
    NSCalendar *cal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *component=[cal components:(NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit) fromDate:today];
    [component setDay:01];
    NSDate *currentShowDate=[cal dateFromComponents:component];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *currentShowDateStr=[formatter stringFromDate:currentShowDate];
    
    NSString* deviceID=[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    [_countCenterModel startRequestMonthConsumption:[NSArray arrayWithObjects:deviceID, currentShowDateStr, nil]];
    _countCenterModel.countCenterDelegate=self;
    
    CPTGraphHostingView* hostView=[[CPTGraphHostingView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
    [hostView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    hostView.alpha = 0.8;
    [self.view addSubview:hostView];
    
    _barChart=[[CPTXYGraph alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 270)];
    [hostView setHostedGraph:_barChart];
    
    _barChart.plotAreaFrame.paddingLeft=35.0;
    _barChart.plotAreaFrame.paddingTop=15.0;
    _barChart.plotAreaFrame.paddingRight=0.0f;
    _barChart.plotAreaFrame.paddingBottom=30.0;
    
    _plotSpace=(CPTXYPlotSpace*)_barChart.defaultPlotSpace;
    
    _plotSpace.xRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(31.0f)];
    _plotSpace.yRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromCGFloat(0.0f) length:CPTDecimalFromCGFloat(20.0f)];
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
    
    _barChart.title=@"日耗油统计柱状图";
    
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
    y.majorIntervalLength=CPTDecimalFromString(@"2");
    y.minorTickLineStyle=nil;
    y.orthogonalCoordinateDecimal=CPTDecimalFromString(@"0");
    y.title=@"日耗油量(升)";
    y.titleLocation=CPTDecimalFromFloat(4.0f);
    y.titleOffset=20.0f;   //x轴偏移
    
    NSNumberFormatter *labelFormatter = [[NSNumberFormatter alloc] init];
    labelFormatter.numberStyle = NSNumberFormatterNoStyle;
    x.labelFormatter = labelFormatter;
    y.labelFormatter = labelFormatter;
    
    
    _barPlot=[CPTBarPlot tubularBarPlotWithColor:[CPTColor colorWithComponentRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0] horizontalBars:NO];
    _barPlot.baseValue=CPTDecimalFromString(@"0.02");
    _barPlot.barWidth=CPTDecimalFromString(@"0.5");
    _barPlot.barOffset=CPTDecimalFromString(@"-0.1");
    _barPlot.identifier=@"BarPlot";
    _barPlot.dataSource=self;
    _barPlot.delegate=self;
    
    [_barChart addPlot:_barPlot toPlotSpace:_plotSpace];
    
    i = 1;
    
    UIView *bottomView= [[UIView alloc] initWithFrame:CGRectMake(0, 380, WIDTH, 188)];
    bottomView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:bottomView];
    
    UILabel *allOilLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 13, 100, 20)];
    allOilLabel.font = [UIFont systemFontOfSize:14.0f];
    allOilLabel.textColor = [UIColor whiteColor];
    allOilLabel.text = @"月总耗油量:";
    allOilLabel.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:allOilLabel];
    
    UILabel *averageOilLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 46, 100, 20)];
    averageOilLabel.font = [UIFont systemFontOfSize:14.0f];
    averageOilLabel.textColor = [UIColor whiteColor];
    averageOilLabel.text = @"日平均耗油量:";
    averageOilLabel.backgroundColor = [UIColor clearColor];
    [bottomView addSubview:averageOilLabel];
    
    _monthMeliageCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 13, 120, 20)];
    _monthMeliageCountLabel.textColor=[UIColor colorWithRed:0/255.0 green:96.0/255.0 blue:0/255.0 alpha:1.0];
    [_monthMeliageCountLabel setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:_monthMeliageCountLabel];
    
    _dayAverageMeliageLabel=[[UILabel alloc]initWithFrame:CGRectMake(100, 46, 100, 20)];
    _dayAverageMeliageLabel.textColor=[UIColor colorWithRed:0/255.0 green:96.0/255.0 blue:0/255.0 alpha:1.0];
    [_dayAverageMeliageLabel setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:_dayAverageMeliageLabel];
    
    //buttonView 视图
    UIView* buttonView=[[UIView alloc]initWithFrame:CGRectMake(0, 390, WIDTH, 46)];
    [buttonView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_topbar_bg~iphone.png"]]];
    [bottomView addSubview:buttonView];
    
    UIImageView* leftlineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(59, 0, 2, 46)];
    leftlineImgView.image=[UIImage imageNamed:@"shuline.png"];
    [buttonView addSubview:leftlineImgView];
    
    UIImageView* leftarrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 8, 20, 20)];
    leftarrowImgView.image=[UIImage imageNamed:@"leftarrow.png"];
    [buttonView addSubview:leftarrowImgView];
    
    UIButton* leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 46)];
    leftButton.tag=0;
    [leftButton setBackgroundColor:[UIColor clearColor]];
    [leftButton addTarget:self action:@selector(selectCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:leftButton];
    
    UIImageView* rightlineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(259, 0, 2, 46)];
    rightlineImgView.image=[UIImage imageNamed:@"shuline.png"];
    [buttonView addSubview:rightlineImgView];
    
    UIImageView* rightarrowImgView=[[UIImageView alloc]initWithFrame:CGRectMake(280, 8, 20, 20)];
    rightarrowImgView.image=[UIImage imageNamed:@"rightarrow.png"];
    [buttonView addSubview:rightarrowImgView];
    
    UIButton* rightButton=[[UIButton alloc]initWithFrame:CGRectMake(260, 0, 60, 46)];
    rightButton.tag=1;
    [rightButton addTarget:self action:@selector(selectCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundColor:[UIColor clearColor]];
    [buttonView addSubview:rightButton];
    
    
    [formatter setDateFormat:@"YYYY-MM"];
    _showTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 2, 220, 34)];
    _showTimeLabel.textAlignment = UITextAlignmentCenter;
    _showTimeLabel.text = [formatter stringFromDate:currentShowDate];
    _showTimeLabel.textColor = [UIColor whiteColor];
    _showTimeLabel.font = [UIFont systemFontOfSize:20.0f];
    _showTimeLabel.backgroundColor = [UIColor clearColor];
    [buttonView addSubview:_showTimeLabel];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [hostView setFrame:CGRectMake(0, 60, WIDTH, 300)];
        bottomView.frame = CGRectMake(0, 360, WIDTH, 120);
        buttonView.frame = CGRectMake(0, 84, WIDTH, 46);
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS6.0 3.5寸屏幕
        [hostView setFrame:CGRectMake(0, 0, WIDTH, 280)];
        bottomView.frame = CGRectMake(0, 290, WIDTH, 80);
        buttonView.frame = CGRectMake(0, 84, WIDTH, 46);
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [hostView setFrame:CGRectMake(0, 0, WIDTH, WIDTH)];
        bottomView.frame = CGRectMake(0, 330, WIDTH, 188);
        buttonView.frame = CGRectMake(0, 132, WIDTH, 46);
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [hostView setFrame:CGRectMake(0, 60, WIDTH, WIDTH)];
        bottomView.frame = CGRectMake(0, 380, WIDTH, 188);
        buttonView.frame = CGRectMake(0, 152, WIDTH, 46);
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}

    // Do any additional setup after loading the view from its nib.
}

#pragma mark -Plot Data Source Methods
// 返回数据源的纪录数
-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot{
    
    return _resultArray.count;
}

// 返回数据源的数据
-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    NSDecimalNumber* num=nil;
//    NSDictionary* meliageDic=[_resultArray objectAtIndex:index];
//    NSString* serverDate=[meliageDic objectForKey:@"serverDate"];
//    NSArray* datearray=[serverDate componentsSeparatedByString:@"-"];
//    NSString* idx=[datearray objectAtIndex:2];
//    float x=[idx integerValue];
//    float distance=[[meliageDic objectForKey:@"fuel_consumption"] floatValue]*1000;
    
    float x = index+1;
    float distance = [[_resultArray objectAtIndex:index]floatValue];
    if(distance == 0) return 0;
    
    if ([plot isKindOfClass:[CPTBarPlot class]]) {
        if (fieldEnum==CPTBarPlotFieldBarLocation) {
            num=(NSDecimalNumber*)[NSDecimalNumber numberWithUnsignedInteger:x];
        }
        if (fieldEnum==CPTBarPlotFieldBarTip){
            if (_resultArray==nil||[_resultArray count]==0) {
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

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index{
//    CPTMutableTextStyle *textLineStyle=[CPTMutableTextStyle textStyle];
//    textLineStyle.fontSize=14;
//    textLineStyle.color=[CPTColor blackColor];
//    CPTTextLayer *label = nil;
//    if([_resultArray objectAtIndex:index] != 0)
//    {
//        label=[[CPTTextLayer alloc] initWithText:[NSString stringWithFormat:@"%@人",[_resultArray objectAtIndex:index]] style:textLineStyle];
//    }
//    return label;
    return nil;
}

#pragma mark -Button Action
-(void)selectCalendar:(UIButton*)sender
{
    NSArray* datearray=[_showTimeLabel.text componentsSeparatedByString:@"-"];
    NSInteger yy = [[datearray objectAtIndex:0] integerValue];
    NSInteger dd = [[datearray objectAtIndex:1] integerValue];
    if(sender.tag == 0){
        if(dd == 1){
            yy-=1;
            dd=12;
        }else{
            dd-=1;
        }
    }else{
        if(dd == 12){
            yy += 1;
            dd = 1;
        }else{
            dd +=1;
        }
    }
    NSDate *startDate = [NSDate dateWithYear:yy month:dd day:1];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString* deviceID=[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID;
    [_countCenterModel startRequestMonthConsumption:[NSArray arrayWithObjects:deviceID, [formatter stringFromDate:startDate], nil]];
    _countCenterModel.countCenterDelegate=self;
    [formatter setDateFormat:@"yyyy-MM"];
    _showTimeLabel.text = [formatter stringFromDate:startDate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark-handleRequest
- (void)handleMonthConsumption:(NSDictionary *)dictionary
{
    if([[dictionary objectForKey:@"resultCode"] integerValue] == 201){
        [IVToastHUD showAsToastErrorWithStatus:@"无数据"];
        if(_resultArray.count){
            [_resultArray removeAllObjects];
            _resultArray = nil;
            [_barPlot reloadData];
        }
        _monthMeliageCountLabel.text=[NSString stringWithFormat:@"%1.1fL",0.0];
        _dayAverageMeliageLabel.text=[NSString stringWithFormat:@"%1.1fL",0.0];
        return;
    }
    _resultArray = [[[dictionary objectForKey:@"data"] componentsSeparatedByString:@";"]mutableCopy];
    [_barPlot reloadData];
    if ([_resultArray count]==0) {
        _monthMeliageCountLabel.text=[NSString stringWithFormat:@"%1.1fL",0.0];
        _dayAverageMeliageLabel.text=[NSString stringWithFormat:@"%1.1fL",0.0];
        
    }else{
        float sum=0;
        for (NSString* dic in _resultArray) {
//            float distance=[[dic objectForKey:@"fuel_consumption"]floatValue];
            float distance = [dic floatValue];
            sum+=distance;
        }
        _monthMeliageCountLabel.text=[NSString stringWithFormat:@"%1.3fL",sum];
        _dayAverageMeliageLabel.text=[NSString stringWithFormat:@"%1.3fL",sum/[_resultArray count]];
    }
}

@end
