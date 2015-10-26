//
//  ADDTCCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-24.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDTCCell.h"
#import "NSDate+Helper.h"

@implementation ADDTCCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dtcBase:(ADDTCBase *)aDTCBase
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.labelMargin = 5;
        self.detailLabelMargin = 5;
        self.textLabel.textColor=[UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:14];
//        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        [self updateUIByDTCBase:aDTCBase];
    }
    
    return self;
}

- (void)updateUIByDTCBase:(ADDTCBase *)aDTCBase
{
    _dtcBase = aDTCBase;
    NSString *mainTitle;
    NSString *subTitle;
    if (!_dtcBase) {
        mainTitle = @"";
        subTitle = @"";
    } else {
        if(aDTCBase.Num_of_DTC==0||aDTCBase.Num_of_DTC==255){
            mainTitle = NSLocalizedStringFromTable(@"noAlarmKey",@"MyString", @"");
        }
        else if(aDTCBase.Num_of_DTC==1){
            mainTitle = [NSString stringWithFormat:@"%@",[aDTCBase.DTC_1 substringToIndex:5]];
        }else if (aDTCBase.Num_of_DTC==2){
            mainTitle = [NSString stringWithFormat:@"%@,%@",[aDTCBase.DTC_1 substringToIndex:5],[aDTCBase.DTC_2 substringToIndex:5]];
            
        }else if (aDTCBase.Num_of_DTC==3){
            mainTitle = [NSString stringWithFormat:@"%@,%@,%@",[aDTCBase.DTC_1 substringToIndex:5],[aDTCBase.DTC_2 substringToIndex:5],[aDTCBase.DTC_3 substringToIndex:5]];
            
        }else if (aDTCBase.Num_of_DTC==4){
            mainTitle = [NSString stringWithFormat:@"%@,%@,%@,%@",[aDTCBase.DTC_1 substringToIndex:5],[aDTCBase.DTC_2 substringToIndex:5],[aDTCBase.DTC_3 substringToIndex:5],[aDTCBase.DTC_4 substringToIndex:5]];
        }else{
            mainTitle = [NSString stringWithFormat:@"%@,%@,%@,%@...",[aDTCBase.DTC_1 substringToIndex:5],[aDTCBase.DTC_2 substringToIndex:5],[aDTCBase.DTC_3 substringToIndex:5],[aDTCBase.DTC_4 substringToIndex:5]];
        }
        
//        mainTitle = [NSString stringWithFormat:@"DTC码：%@,%@,%@",[aDTCBase.DTC_1 substringToIndex:5],[aDTCBase.DTC_2 substringToIndex:5],[aDTCBase.DTC_3 substringToIndex:5]];
        subTitle = [NSString stringWithFormat:@"%@",aDTCBase.readDate];
    }
    self.textLabel.text = mainTitle;
    self.detailTextLabel.text = subTitle;
    
}

@end
