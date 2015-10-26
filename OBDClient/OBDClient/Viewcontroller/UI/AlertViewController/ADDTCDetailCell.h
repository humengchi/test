//
//  ADDTCDetailCell.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-31.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseCell.h"

@interface ADDTCDetailCell : ADBaseCell
{
    NSString *_dtcCodeStr;
    NSString *_dtcContent;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier dtcCode:(NSString *)aDTCCode dtcContent:(NSString *)aDTCContent;

- (void)updateUIBydtcCode:(NSString *)aDTCCode dtcContent:(NSString *)aDTCContent;

@end
