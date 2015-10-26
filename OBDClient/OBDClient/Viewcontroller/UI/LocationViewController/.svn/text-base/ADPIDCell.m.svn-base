//
//  ADPIDCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-6.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADPIDCell.h"

@implementation ADPIDCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           titleStr:(NSString *)aTitleStr
         contentStr:(NSString *)aContentStr
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.labelMargin = 0;
        self.textLabel.textAlignment = UITextAlignmentLeft;
        self.detailLabelMargin = 85;
        self.textLabel.textColor = [UIColor orangeColor];
        self.textLabel.font = [UIFont systemFontOfSize:13];
        
    }
    return self;
}

- (void)updateUIByTitleStr:(NSString *)aTitleStr
                contentStr:(NSString *)aContentStr
{
    self.textLabel.text = [aTitleStr isKindOfClass:[NSNull class]] ? @"" : aTitleStr;
    self.detailTextLabel.text = [aContentStr isKindOfClass:[NSNull class]] ? @"" : aContentStr;
}

@end
