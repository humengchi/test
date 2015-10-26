//
//  ADDTCDetailCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-31.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDTCDetailCell.h"
#import "NSDate+Helper.h"

@implementation ADDTCDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
            dtcCode:(NSString *)aDTCCode
         dtcContent:(NSString *)aDTCContent
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        self.detailTextLabel.font = [UIFont systemFontOfSize:13];
        self.textLabel.numberOfLines=0;
        self.detailTextLabel.numberOfLines=0;
        self.labelMargin = 5;
        self.detailLabelMargin = 5;
        [self updateUIBydtcCode:aDTCCode dtcContent:aDTCContent];
    }
    
    return self;
}

- (void)updateUIBydtcCode:(NSString *)aDTCCode dtcContent:(NSString *)aDTCContent
{
    _dtcCodeStr = aDTCCode;
    _dtcContent = aDTCContent;//aDTCContent;
    
    NSString *mainTitle;
    NSString *subTitle;

    mainTitle = [NSString stringWithFormat:@"故障代码: %@",_dtcCodeStr];
    subTitle = [NSString stringWithFormat:@"故障描述: %@",_dtcContent];

    self.textLabel.text = mainTitle;
    self.detailTextLabel.text = subTitle;
}

@end
