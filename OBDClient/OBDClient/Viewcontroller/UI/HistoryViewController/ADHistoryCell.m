//
//  ADHistoryCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHistoryCell.h"
#import "NSDate+Helper.h"
#import "UIUtil.h"

@implementation ADHistoryCell


- (id)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame])
    {
        _startTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 5, self.bounds.size.width-45, 20)];
        
        _stopTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 50, self.bounds.size.width-45, 20)];
        
        _startPointLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 25, 175, 20)];
        
        _stopPointLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 70, 175, 20)];
        
        _meterLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-115, 40, 100, 20)];
        _meterLabel.textAlignment=NSTextAlignmentCenter;
        
        _stopIntervalLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.bounds.size.width-115, 60, 100, 20)];
        _stopIntervalLabel.textAlignment=NSTextAlignmentCenter;
        
        _leaveFuelLabel = [[UILabel alloc]initWithFrame:CGRectMake(105, 93, 50, 10)];
        _leaveFuelLabel.textAlignment=NSTextAlignmentLeft;
        _leaveFuelLabel.textColor = [UIColor orangeColor];
        _leaveFuelLabel.font = [UIFont systemFontOfSize:9.0f];
//        _leaveFuelLabel.text = @"20%";
        [self addSubview:_leaveFuelLabel];
        
        _usedFuelLabel = [[UILabel alloc]initWithFrame:CGRectMake(225, 93, 50, 10)];
        _usedFuelLabel.textAlignment=NSTextAlignmentLeft;
        _usedFuelLabel.textColor = [UIColor orangeColor];
        _usedFuelLabel.font = [UIFont systemFontOfSize:9.0f];
//        _usedFuelLabel.text = @"1.90L";
        [self addSubview:_usedFuelLabel];
        
        UILabel *leaveLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 93, 50, 10)];
        leaveLabel.textAlignment=NSTextAlignmentRight;
        leaveLabel.textColor = [UIColor orangeColor];
        leaveLabel.font = [UIFont systemFontOfSize:9.0f];
        leaveLabel.text = @"剩余油量：";
        [self addSubview:leaveLabel];
        
        UILabel *usedLabel = [[UILabel alloc]initWithFrame:CGRectMake(175, 93, 50, 10)];
        usedLabel.textAlignment=NSTextAlignmentRight;
        usedLabel.textColor = [UIColor orangeColor];
        usedLabel.font = [UIFont systemFontOfSize:9.0f];
        usedLabel.text = @"油耗：";
        [self addSubview:usedLabel];
        
        UIButton *buttonStart = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonStart.frame = CGRectMake(5, 12, 25, 29);
        [buttonStart setBackgroundImage:[UIImage imageNamed:@"track_start.png"] forState:UIControlStateNormal];
        [self addSubview:buttonStart];
        
        UIButton *buttonStop = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonStop.frame = CGRectMake(5, 59, 25, 29);
        [buttonStop setBackgroundImage:[UIImage imageNamed:@"track_finish.png"] forState:UIControlStateNormal];
        [self addSubview:buttonStop];
        
        UIButton *buttonMileage = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonMileage.frame = CGRectMake(self.bounds.size.width-77, 13, 24, 27);
        [buttonMileage setBackgroundImage:[UIImage imageNamed:@"track_total.png"] forState:UIControlStateNormal];
        [self addSubview:buttonMileage];
        
        UIFont *font=[UIFont systemFontOfSize:12];
        _startTimeLabel.font=font;
        _stopTimeLabel.font=font;
        _startPointLabel.font=font;
        _stopPointLabel.font=font;
        _meterLabel.font =font;
        _stopIntervalLabel.font=font;
        
        _startTimeLabel.textColor=DEFAULT_LABEL_COLOR;
        _stopTimeLabel.textColor=DEFAULT_LABEL_COLOR;
        _startPointLabel.textColor=DEFAULT_LABEL_COLOR;
        _stopPointLabel.textColor=DEFAULT_LABEL_COLOR;
        _meterLabel.textColor=[UIColor orangeColor];
        _stopIntervalLabel.textColor=[UIColor orangeColor];
        
        _startTimeLabel.backgroundColor=[UIColor clearColor];
        _stopTimeLabel.backgroundColor=[UIColor clearColor];
        _startPointLabel.backgroundColor=[UIColor clearColor];
        _stopPointLabel.backgroundColor=[UIColor clearColor];
        _meterLabel.backgroundColor=[UIColor clearColor];
        _stopIntervalLabel.backgroundColor=[UIColor clearColor];
        
        [self addSubview:_startPointLabel];
        [self addSubview:_stopPointLabel];
        [self addSubview:_startTimeLabel];
        [self addSubview:_stopTimeLabel];
        [self addSubview:_meterLabel];
        [self addSubview:_stopIntervalLabel];
    }
    return self;
}

-(void)dealloc{
    _startPointLabel=nil;
    _stopPointLabel=nil;
    _startTimeLabel=nil;    
    _startTimeLabel=nil;
    _meterLabel=nil;
    _stopIntervalLabel=nil;
}

- (void)updateUIByHistoryPoint:(NSDictionary *)aHistoryPoint andDrual:(NSString *)drual
{
    _historyPoint = aHistoryPoint;
    _startTimeLabel.text = [NSString stringWithFormat:@"%@",[_historyPoint objectForKey:@"startTime"]];
    _stopTimeLabel.text = [NSString stringWithFormat:@"%@",[_historyPoint objectForKey:@"stopTime"]];
    if([[_historyPoint objectForKey:@"startLat"] intValue]==0||[[_historyPoint objectForKey:@"startLon"] intValue]==0){
        _startPointLabel.text =NSLocalizedStringFromTable(@"noposition",@"MyString", @"");
    }else{
        _startPointLabel.text = [NSString stringWithFormat:@"%@%@",[[_historyPoint objectForKey:@"startAddress"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]],NSLocalizedStringFromTable(@"nearKey",@"MyString", @"")]; 
    }
    
    if([[_historyPoint objectForKey:@"stopLat"] intValue]==0||[[_historyPoint objectForKey:@"stopLon"] intValue]==0){
        _stopPointLabel.text =NSLocalizedStringFromTable(@"noposition",@"MyString", @"");
    }else{
        _stopPointLabel.text = [NSString stringWithFormat:@"%@%@",[[_historyPoint objectForKey:@"stopAddress"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]],NSLocalizedStringFromTable(@"nearKey",@"MyString", @"")];
    }
    if([[_historyPoint objectForKey:@"trackDistance"] integerValue]==0){
        _meterLabel.text =NSLocalizedStringFromTable(@"historyNoMileage",@"MyString", @"");
    }else{
        _meterLabel.text = [NSString stringWithFormat:@"%@%.2f%@",NSLocalizedStringFromTable(@"drive",@"MyString", @""),(float)[[_historyPoint objectForKey:@"trackDistance"] integerValue]/1000,NSLocalizedStringFromTable(@"kmKey",@"MyString", @"")];
    }
    if(![drual isEqualToString:@""]){
        _stopIntervalLabel.text=[NSString stringWithFormat:@"%@%@",NSLocalizedStringFromTable(@"stay",@"MyString", @""),drual];
    }else{
        _stopIntervalLabel.text=NSLocalizedStringFromTable(@"noStay",@"MyString", @"");
    }
    
    if([[_historyPoint objectForKey:@"fuel_consumption"] floatValue]==0){
        _usedFuelLabel.text = @"0.0L";
    }else{
        _usedFuelLabel.text = [NSString stringWithFormat:@"%@L", [_historyPoint objectForKey:@"fuel_consumption"]];
    }
    
    if([[_historyPoint objectForKey:@"fuel_leve_now"] floatValue]==0){
        _leaveFuelLabel.text = @"0.0L";
    }else{
        _leaveFuelLabel.text = [NSString stringWithFormat:@"%@L", [_historyPoint objectForKey:@"fuel_leve_now"]];
    }
}

@end
