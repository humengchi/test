//
//  ADSingletonUtil.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-17.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSingletonUtil.h"

@implementation ADSingletonUtil

/* 映射表 暂时使用方法实现.**/
- (NSString *)alertNameByCode:(NSString *)aCode    //通过code插入文字提醒
{
    NSString *name;
    if ([aCode isEqualToString:@"3000"]) {
        name = NSLocalizedStringFromTable(@"code3000",@"MyString", @"");//@"开机";
    } else if ([aCode isEqualToString:@"3001"]) {
        name = NSLocalizedStringFromTable(@"code3001",@"MyString", @"");//@"关机";
    } else if ([aCode isEqualToString:@"3002"]) {
        name = NSLocalizedStringFromTable(@"code3002",@"MyString", @"");//@"当前状态信息";
    } else if ([aCode isEqualToString:@"3003"]) {
        name = NSLocalizedStringFromTable(@"code3003",@"MyString", @"");//@"车辆信息更新报警";
    } else if ([aCode isEqualToString:@"3004"]) {
        name = NSLocalizedStringFromTable(@"code3004",@"MyString", @"");//@"位置报告(短)";
    } else if ([aCode isEqualToString:@"3005"]) {
        name = NSLocalizedStringFromTable(@"code3005",@"MyString", @"");//@"位置报告(长)";
    } else if ([aCode isEqualToString:@"3006"]) {
        name = NSLocalizedStringFromTable(@"code3006",@"MyString", @"");//@"围栏报警";
    } else if ([aCode isEqualToString:@"3007"]) {
        name = NSLocalizedStringFromTable(@"code3007",@"MyString", @"");
    } else if ([aCode isEqualToString:@"3008"]) {
        name = NSLocalizedStringFromTable(@"code3008",@"MyString", @"");//@"引擎故障灯报警";
    } else if ([aCode isEqualToString:@"3009"]) {
        name = NSLocalizedStringFromTable(@"code3009",@"MyString", @"");//@"车辆故障码报警";
    } else if ([aCode isEqualToString:@"3010"]) {
        name = NSLocalizedStringFromTable(@"code3010",@"MyString", @"");//@"超速报告";
    } else if ([aCode isEqualToString:@"3011"]) {
        name = NSLocalizedStringFromTable(@"code3011",@"MyString", @"");//@"超转速报警";
    } else if ([aCode isEqualToString:@"3012"]) {
        name = NSLocalizedStringFromTable(@"code3012",@"MyString", @"");//@"电池低压报警";
    } else if ([aCode isEqualToString:@"3013"]) {
        name = NSLocalizedStringFromTable(@"code3013",@"MyString", @"");//@"非法移动报警";
    } else if ([aCode isEqualToString:@"3014"]) {
        name = NSLocalizedStringFromTable(@"code3014",@"MyString", @"");//@"油量低报警";
    } else if ([aCode isEqualToString:@"3015"]) {
        name = NSLocalizedStringFromTable(@"code3015",@"MyString", @"");//@"引擎发动";
    } else if ([aCode isEqualToString:@"3016"]) {
        name = NSLocalizedStringFromTable(@"code3016",@"MyString", @"");//@"引擎熄火";
    } else if ([aCode isEqualToString:@"3017"]) {
        name = NSLocalizedStringFromTable(@"code3017",@"MyString", @"");//@"冷却液高温报警";
    } else if ([aCode isEqualToString:@"3018"]) {
        name = NSLocalizedStringFromTable(@"code3018",@"MyString", @"");//@"空转报警";
    } else if ([aCode isEqualToString:@"3019"]) {
        name = NSLocalizedStringFromTable(@"code3019",@"MyString", @"");//@"油量变动过快报警";
    } else if ([aCode isEqualToString:@"3020"]) {
        name = NSLocalizedStringFromTable(@"code3020",@"MyString", @"");//@"起步停车报警";
    } else if ([aCode isEqualToString:@"3021"]) {
        name = NSLocalizedStringFromTable(@"code3021",@"MyString", @"");
    } else if ([aCode isEqualToString:@"3022"]) {
        name = NSLocalizedStringFromTable(@"code3022",@"MyString", @"");
    } else if ([aCode isEqualToString:@"3023"]) {
        name = NSLocalizedStringFromTable(@"code3023",@"MyString", @"");
    } else if ([aCode isEqualToString:@"3024"]) {
        name = NSLocalizedStringFromTable(@"code3024",@"MyString", @"");//@"急启动事件";
    } else if ([aCode isEqualToString:@"3025"]) {
        name = NSLocalizedStringFromTable(@"code3025",@"MyString", @"");//@"急转弯事件";
    } else if ([aCode isEqualToString:@"3026"]) {
        name = NSLocalizedStringFromTable(@"code3026",@"MyString", @"");//@"急刹车事件";
    } else if ([aCode isEqualToString:@"3027"]) {
        name = NSLocalizedStringFromTable(@"code3027",@"MyString", @"");
    } else{
        name = NSLocalizedStringFromTable(@"codeOther",@"MyString", @"");
    }

//    if ([aCode isEqualToString:@"3000"]) {
//        name = NSLocalizedString(@"alert-code-name-power-on", nil);//@"开机";
//    } else if ([aCode isEqualToString:@"3001"]) {
//        name = NSLocalizedString(@"alert-code-name-power-off", nil);//@"关机";
//    } else if ([aCode isEqualToString:@"3002"]) {
//        name = NSLocalizedString(@"alert-code-name-current-status-info", nil);//@"当前状态信息";
//    } else if ([aCode isEqualToString:@"3003"]) {
//        name = NSLocalizedString(@"alert-code-name-car-info-updated-alert", nil);//@"车辆信息更新报警";
//    } else if ([aCode isEqualToString:@"3004"]) {
//        name = NSLocalizedString(@"alert-code-name-location-report(short)", nil);//@"位置报告(短)";
//    } else if ([aCode isEqualToString:@"3005"]) {
//        name = NSLocalizedString(@"alert-code-name-location-report(long)", nil);//@"位置报告(长)";
//    } else if ([aCode isEqualToString:@"3006"]) {
//        name = NSLocalizedString(@"alert-code-name-geofence-alert", nil);//@"围栏报警";
//    } else if ([aCode isEqualToString:@"3007"]) {
//        name = @"";
//    } else if ([aCode isEqualToString:@"3008"]) {
//        name = NSLocalizedString(@"alert-code-name-engine-trouble-light-alert", nil);//@"引擎故障灯报警";
//    } else if ([aCode isEqualToString:@"3009"]) {
//        name = NSLocalizedString(@"alert-code-name-car-trouble-code-alert", nil);//@"车辆故障码报警";
//    } else if ([aCode isEqualToString:@"3010"]) {
//        name = NSLocalizedString(@"alert-code-name-high-speed-alert", nil);//@"超速报告";
//    } else if ([aCode isEqualToString:@"3011"]) {
//        name = NSLocalizedString(@"alert-code-name-high-rotate-speed-alert", nil);//@"超转速报警";
//    } else if ([aCode isEqualToString:@"3012"]) {
//        name = NSLocalizedString(@"alert-code-name-low-battery-alert", nil);//@"电池低压报警";
//    } else if ([aCode isEqualToString:@"3013"]) {
//        name = NSLocalizedString(@"alert-code-name-invalid-moving-alert", nil);//@"非法移动报警";
//    } else if ([aCode isEqualToString:@"3014"]) {
//        name = NSLocalizedString(@"alert-code-name-low-fuel-alert", nil);//@"油量低报警";
//    } else if ([aCode isEqualToString:@"3015"]) {
//        name = NSLocalizedString(@"alert-code-name-engine-power-on", nil);//@"引擎发动";
//    } else if ([aCode isEqualToString:@"3016"]) {
//        name = NSLocalizedString(@"alert-code-name-engine-power-off", nil);//@"引擎熄火";
//    } else if ([aCode isEqualToString:@"3017"]) {
//        name = NSLocalizedString(@"alert-code-name-cooling-liquid-high-temperature-alert", nil);//@"冷却液高温报警";
//    } else if ([aCode isEqualToString:@"3018"]) {
//        name = NSLocalizedString(@"alert-code-name-idle-alert", nil);//@"空转报警";
//    } else if ([aCode isEqualToString:@"3019"]) {
//        name = NSLocalizedString(@"alert-code-name-fuel-change-too-fast-alert", nil);//@"油量变动过快报警";
//    } else if ([aCode isEqualToString:@"3020"]) {
//        name = NSLocalizedString(@"alert-code-name-stop-start-alert", nil);//@"起步停车报警";
//    } else if ([aCode isEqualToString:@"3021"]) {
//        name = @"";
//    } else if ([aCode isEqualToString:@"3022"]) {
//        name = @"";
//    } else if ([aCode isEqualToString:@"3023"]) {
//        name = @"";
//    } else if ([aCode isEqualToString:@"3024"]) {
//        name = NSLocalizedString(@"alert-code-name-urgency-start-event", nil);//@"急启动事件";
//    } else if ([aCode isEqualToString:@"3025"]) {
//        name = NSLocalizedString(@"alert-code-name-urgency-swerve-event", nil);//@"急转弯事件";
//    } else if ([aCode isEqualToString:@"3026"]) {
//        name = NSLocalizedString(@"alert-code-name-urgency-brake-event", nil);//@"急刹车事件";
//    } else if ([aCode isEqualToString:@"3027"]) {
//        name = @"";
//    }
    return name;
}

+ (ADSingletonUtil *)sharedInstance       
{
    static ADSingletonUtil *_sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (NSString *)errorStringByResultCode:(NSString *)aResultCode{
    NSString *errString;
    if([aResultCode isEqualToString:@"201"]){
        errString=NSLocalizedStringFromTable(@"code201",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"202"]){
        errString=NSLocalizedStringFromTable(@"code202",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"203"]){
        errString=NSLocalizedStringFromTable(@"code203",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"204"]){
        errString=NSLocalizedStringFromTable(@"code204",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"205"]){
        errString=NSLocalizedStringFromTable(@"code205",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"206"]){
        errString=NSLocalizedStringFromTable(@"code206",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"301"]){
        errString=NSLocalizedStringFromTable(@"code301",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1001"]){
        errString=NSLocalizedStringFromTable(@"code1001",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1002"]){
        errString=NSLocalizedStringFromTable(@"code1002",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1003"]){
        errString=NSLocalizedStringFromTable(@"code1003",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1004"]){
        errString=NSLocalizedStringFromTable(@"code1004",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1005"]){
        errString=NSLocalizedStringFromTable(@"code1005",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1006"]){
        errString=NSLocalizedStringFromTable(@"code1006",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1007"]){
        errString=NSLocalizedStringFromTable(@"code1007",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1008"]){
        errString=NSLocalizedStringFromTable(@"code1008",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1009"]){
        errString=NSLocalizedStringFromTable(@"code1009",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1010"]){
        errString=NSLocalizedStringFromTable(@"code1010",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1011"]){
        errString=NSLocalizedStringFromTable(@"code1011",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1012"]){
        errString=NSLocalizedStringFromTable(@"code1012",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1013"]){
        errString=NSLocalizedStringFromTable(@"code1013",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1014"]){
        errString=NSLocalizedStringFromTable(@"code1014",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1015"]){
        errString=NSLocalizedStringFromTable(@"code1015",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1016"]){
        errString=NSLocalizedStringFromTable(@"code1016",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1017"]){
        errString=NSLocalizedStringFromTable(@"code1017",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1018"]){
        errString=NSLocalizedStringFromTable(@"code1018",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1019"]){
        errString=NSLocalizedStringFromTable(@"code1019",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1020"]){
        errString=NSLocalizedStringFromTable(@"code1020",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1021"]){
        errString=NSLocalizedStringFromTable(@"code1021",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1022"]){
        errString=NSLocalizedStringFromTable(@"code1022",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1023"]){
        errString=NSLocalizedStringFromTable(@"code1023",@"MyString", @"");
    }else if ([aResultCode isEqualToString:@"1024"]){
        errString=NSLocalizedStringFromTable(@"code1024",@"MyString", @"");
    }
    else{
        errString=NSLocalizedStringFromTable(@"codeUnclear",@"MyString", @"");
    }
    
    return  errString;
}

-(BOOL) isRulesString:(NSString *)string{
    
    NSString* retString =string;
    
    for(int i=0;i<[retString length];i++)
    {
        unichar character = [retString characterAtIndex:i];
        
        if ((character <= '9'&& character >= '0')
            ||( character <= 'Z' && character >= 'A')
            ||( character <= 'z' && character >= 'a')
            ||(character >= 19968 &&character <= (19968+20902)))
        {
        }else {
            return NO;
        }
    }
    
    return YES;
    
}

@end
