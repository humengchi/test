//
//  WeatherViewController.m
//  V3ViewController
//
//  Created by hys on 11/9/13.
//  Copyright (c) 2013年 hys. All rights reserved.
//

#import "WeatherViewController.h"

NSString * const ADSendToUserLocationSettingCurrentSelectedCityNotification      = @"ADSendToUserLocationSettingCurrentSelectedCityNotification";

@interface WeatherViewController ()

@end

@implementation WeatherViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherData:) name:ADWeatherDataNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weatherCurrentCity:) name:ADSendToWeatherCurrentSelectedCityNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    self.title=NSLocalizedStringFromTable(@"weatherKey",@"MyString", @"");
   
    _changeCityView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    UIImageView* BgImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 5, WIDTH-10, 45)];
    BgImgView.image=[UIImage imageNamed:@"carassistantrect.png"];
    [_changeCityView addSubview:BgImgView];
    
        
    UIButton* changeCityButton=[[UIButton alloc]initWithFrame:CGRectMake((WIDTH-110)/2, 8, 110, 20)];
    [changeCityButton setBackgroundImage:[UIImage imageNamed:@"navbar_btn1_nor.png"] forState:UIControlStateNormal];
    [changeCityButton setTitle:NSLocalizedStringFromTable(@"clickSwitchCityKey",@"MyString", @"") forState:UIControlStateNormal];
    changeCityButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [changeCityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [changeCityButton addTarget:self action:@selector(changeCityButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_changeCityView addSubview:changeCityButton];
    [self.view addSubview:_changeCityView];
    
//    UIImageView* Bg=[[UIImageView alloc]initWithFrame:CGRectMake(3, 56, 314, 360)];
//    Bg.image=[UIImage imageNamed:@"bottomrect.png"];
//    [self.view addSubview:Bg];
    
    _weatherTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 56, WIDTH, HEIGHT-56) style:UITableViewStylePlain];
    _weatherTableView.delegate=self;
    _weatherTableView.dataSource=self;
    [_weatherTableView setBackgroundColor:[UIColor clearColor]];
    [_weatherTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _weatherTableView.showsHorizontalScrollIndicator=NO;
    _weatherTableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_weatherTableView];
    
    NSDate* date=[NSDate date];
    NSTimeInterval one=24*60*60;
    
    NSDateFormatter* dateformatter=[[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    
    NSCalendar* cal=[NSCalendar currentCalendar];

    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    
    NSDateComponents * conponent= [cal components:unitFlags fromDate:date];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];

    _oneDay=[NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    
    
    date=[NSDate dateWithTimeIntervalSinceNow:one];
    conponent= [cal components:unitFlags fromDate:date];
    year=[conponent year];
    month=[conponent month];
    day=[conponent day];
    _twoDay=[NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    
    date=[NSDate dateWithTimeIntervalSinceNow:one*2];
    conponent= [cal components:unitFlags fromDate:date];
    year=[conponent year];
    month=[conponent month];
    day=[conponent day];
    _threeDay=[NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    
    
    date=[NSDate dateWithTimeIntervalSinceNow:one*3];
    conponent= [cal components:unitFlags fromDate:date];
    year=[conponent year];
    month=[conponent month];
    day=[conponent day];
    _fourDay=[NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    
    date=[NSDate dateWithTimeIntervalSinceNow:one*4];
    conponent= [cal components:unitFlags fromDate:date];
    year=[conponent year];
    month=[conponent month];
    day=[conponent day];
    _fiveDay=[NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    
    date=[NSDate dateWithTimeIntervalSinceNow:one*5];
    conponent= [cal components:unitFlags fromDate:date];
    year=[conponent year];
    month=[conponent month];
    day=[conponent day];
    _sixDay=[NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    
    date=[NSDate dateWithTimeIntervalSinceNow:one*6];
    conponent= [cal components:unitFlags fromDate:date];
    year=[conponent year];
    month=[conponent month];
    day=[conponent day];
    _sevenDay=[NSString stringWithFormat:@"%d%02d%02d",year,month,day];
    
    

    
    
}
#pragma mark -Button action
-(void)weatherCurrentCity:(NSNotification *)aNoti{
    _cityLabel=[[UILabel alloc]initWithFrame:CGRectMake(55, 25, WIDTH-110, 25)];
    _currentSelectedCity=[aNoti object];
    _cityLabel.text=[NSString stringWithFormat:@"%@:%@",NSLocalizedStringFromTable(@"currentCityKey",@"MyString", @""),_currentSelectedCity];
    _cityLabel.textAlignment=UITextAlignmentCenter;
    _cityLabel.textColor=[UIColor whiteColor];
    [_cityLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_cityLabel];

    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_changeCityView setFrame:CGRectMake(0, 64, WIDTH, 50)];
        [_weatherTableView setFrame:CGRectMake(0, 120, WIDTH, HEIGHT-120)];
        [_cityLabel setFrame:CGRectMake(55, 89, WIDTH-110, 25)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
       
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_weatherTableView setFrame:CGRectMake(0, 56, WIDTH, 448)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_changeCityView setFrame:CGRectMake(0, 64, WIDTH, 50)];
        [_weatherTableView setFrame:CGRectMake(0, 120, WIDTH, HEIGHT-120)];
        [_cityLabel setFrame:CGRectMake(55, 89, WIDTH-110, 25)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
        
	}

}
-(void)weatherData:(NSNotification *)aNoti{
    NSArray* data=(NSArray*)[aNoti object];
    _weatherdataDictionary=[[NSArray alloc]initWithArray:data];
}

-(void)changeCityButton:(id)sender{
    ADUserLocationSettingViewController* userLocationSetting=[[ADUserLocationSettingViewController alloc]init];
    [self.navigationController pushViewController:userLocationSetting animated:NO];
    [[NSNotificationCenter defaultCenter]postNotificationName:ADSendToUserLocationSettingCurrentSelectedCityNotification object:_currentSelectedCity];
}

//-(void)showCityWeather:(NSNotification *)aNoti{
//    NSDictionary* show=(NSMutableDictionary*)[aNoti object];
//    
//}

#pragma mark -setup TableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_weatherdataDictionary.count <= 0) return 0;
    return 4;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"WeatherCell";
    WeatherCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray* cellArray=[[NSBundle mainBundle] loadNibNamed:@"WeatherCell" owner:self options:nil];
        cell=(WeatherCell*)[cellArray objectAtIndex:0];
        
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSRange monthRange=NSMakeRange(4, 2);
    NSRange dayRange=NSMakeRange(6, 2);
    
    if (indexPath.row==0) {
        NSString* month=[_oneDay substringWithRange:monthRange];
        NSString* day=[_oneDay substringWithRange:dayRange];
        cell.monthAndDayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        cell.monthAndDayLabel.textAlignment=UITextAlignmentCenter;

        _transitionDictionary=[_weatherdataDictionary objectAtIndex:0];
        
    }else if (indexPath.row==1) {
        NSString* month=[_twoDay substringWithRange:monthRange];
        NSString* day=[_twoDay substringWithRange:dayRange];
        cell.monthAndDayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        cell.monthAndDayLabel.textAlignment=UITextAlignmentCenter;
        
        _transitionDictionary=[_weatherdataDictionary objectAtIndex:1];
        
    }else if (indexPath.row==2) {
        NSString* month=[_threeDay substringWithRange:monthRange];
        NSString* day=[_threeDay substringWithRange:dayRange];
        cell.monthAndDayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        cell.monthAndDayLabel.textAlignment=UITextAlignmentCenter;
        
        _transitionDictionary=[_weatherdataDictionary objectAtIndex:2];
        
    }else if (indexPath.row==3) {
        NSString* month=[_fourDay substringWithRange:monthRange];
        NSString* day=[_fourDay substringWithRange:dayRange];
        cell.monthAndDayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        cell.monthAndDayLabel.textAlignment=UITextAlignmentCenter;
        
        _transitionDictionary=[_weatherdataDictionary objectAtIndex:3];
        
    }else if (indexPath.row==4) {
        NSString* month=[_fiveDay substringWithRange:monthRange];
        NSString* day=[_fiveDay substringWithRange:dayRange];
        cell.monthAndDayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        cell.monthAndDayLabel.textAlignment=UITextAlignmentCenter;
        
        _transitionDictionary=[_weatherdataDictionary objectAtIndex:3];
        
    }else if (indexPath.row==5) {
        NSString* month=[_sixDay substringWithRange:monthRange];
        NSString* day=[_sixDay substringWithRange:dayRange];
        cell.monthAndDayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        cell.monthAndDayLabel.textAlignment=UITextAlignmentCenter;
        
        _transitionDictionary=[_weatherdataDictionary objectAtIndex:3];
        
    }else if (indexPath.row==6){
        NSString* month=[_sevenDay substringWithRange:monthRange];
        NSString* day=[_sevenDay substringWithRange:dayRange];
        cell.monthAndDayLabel.text=[NSString stringWithFormat:@"%@月%@日",month,day];
        cell.monthAndDayLabel.textAlignment=UITextAlignmentCenter;
        
        _transitionDictionary=[_weatherdataDictionary objectAtIndex:3];

    }
    
    cell.monthAndDayLabel.textColor=[UIColor whiteColor];

    NSString* week=[[[_transitionDictionary objectForKey:@"date"] componentsSeparatedByString:@" "] objectAtIndex:0];
    cell.weekdayLabel.text=week;
    cell.weekdayLabel.textAlignment=UITextAlignmentCenter;
    cell.weekdayLabel.textColor=[UIColor whiteColor];
    
    NSString* temperature=[_transitionDictionary objectForKey:@"temperature"];
    cell.temperatureLabel.text=temperature;
//    cell.temperatureLabel.textAlignment=UITextAlignmentCenter;
    cell.temperatureLabel.font=[UIFont systemFontOfSize:14];
    cell.temperatureLabel.textColor=[UIColor whiteColor];
    
    NSString* wind=[_transitionDictionary objectForKey:@"wind"];
    cell.windLabel.text=wind;
//    cell.windLabel.textAlignment=UITextAlignmentCenter;
    cell.windLabel.font=[UIFont systemFontOfSize:12];
    cell.windLabel.textColor=[UIColor whiteColor];
    
    NSString* weatherString=[_transitionDictionary objectForKey:@"weather"];
    
    cell.weatherLabel.text=weatherString;
    
    cell.weatherImgView.image=[UIImage imageNamed:[self WeatherImage:weatherString]];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)WeatherImage:(NSString*)weatherStr{
    NSString* ImgName=@"晴.png";
    if ([weatherStr length]<2) {
        if ([weatherStr isEqualToString:@"晴"]) {
            ImgName=@"晴.png";
        }else if ([weatherStr isEqualToString:@"阴"]){
            ImgName=@"阴.png";
        }else if ([weatherStr isEqualToString:@"雾"]){
            ImgName=@"雾.png";
        }
    }else{
        weatherStr=[weatherStr substringWithRange:NSMakeRange(0, 2)];
        if ([weatherStr isEqualToString:@"扬沙"]) {
            ImgName=@"扬沙.png";
        }else if ([weatherStr isEqualToString:@"多云"]){
            ImgName=@"多云.png";
        }else if ([weatherStr isEqualToString:@"小雪"]){
            ImgName=@"小雪.png";
        }else if ([weatherStr isEqualToString:@"雨夹"]){
            ImgName=@"小雪.png";
        }else if ([weatherStr isEqualToString:@"阵雪"]){
            ImgName=@"阵雪.png";
        }else if ([weatherStr isEqualToString:@"中雪"]){
            ImgName=@"中雪.png";
        }else if ([weatherStr isEqualToString:@"大雪"]){
            ImgName=@"大雪.png";
        }else if ([weatherStr isEqualToString:@"小雨"]){
            ImgName=@"小雨.png";
        }else if ([weatherStr isEqualToString:@"阵雨"]){
            ImgName=@"阵雨.png";
        }else if ([weatherStr isEqualToString:@"中雨"]){
            ImgName=@"中雨.png";
        }else if ([weatherStr isEqualToString:@"大雨"]){
            ImgName=@"大雨.png";
        }else if ([weatherStr isEqualToString:@"雷阵"]){
            ImgName=@"雷阵雨.png";
        }else if ([weatherStr isEqualToString:@"沙尘"]){
            ImgName=@"沙尘暴.png";
            weatherStr=[weatherStr substringWithRange:NSMakeRange(0, 1)];
        }else if ([weatherStr isEqualToString:@"晴"]) {
            ImgName=@"晴.png";
        }else if ([weatherStr isEqualToString:@"阴"]){
            ImgName=@"阴.png";
        }else if ([weatherStr isEqualToString:@"雾"]){
            ImgName=@"雾.png";
        }
    }
    return ImgName;
}

@end
