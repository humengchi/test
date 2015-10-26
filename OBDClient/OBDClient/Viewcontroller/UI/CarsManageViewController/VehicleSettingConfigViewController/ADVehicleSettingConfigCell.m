//
//  ADVehicleSettingConfigCell.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleSettingConfigCell.h"

@implementation ADVehicleSettingConfigCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _valueTextField=[[UITextField alloc]initWithFrame:CGRectMake(200, 10, 100, 24)];
        _valueTextField.borderStyle=UITextBorderStyleNone;
        _valueTextField.textAlignment=NSTextAlignmentRight;
        [self addSubview:_valueTextField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
