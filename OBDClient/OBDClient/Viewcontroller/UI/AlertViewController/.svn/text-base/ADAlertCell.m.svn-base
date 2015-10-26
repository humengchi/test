//
//  ADAlertCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-23.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADAlertCell.h"
#import "ADSingletonUtil.h"

@implementation ADAlertCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
       historyPoint:(NSDictionary *)aHistoryPoint
{
    if([reuseIdentifier isEqualToString:@"ADAlertViewController.cell"]){
        if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
            self.labelMargin = 35;
            self.detailLabelMargin = 35;
            self.imageMargin = 10;
            self.imageSize=CGSizeMake(20, 20);
            self.backgroundColor = [UIColor clearColor];
            self.textLabel.textColor = [UIColor whiteColor];
            self.textLabel.font = [UIFont boldSystemFontOfSize:13];
            [self updateUIByHistoryPoint:aHistoryPoint];
        }
    }else{
        if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
            self.labelMargin = 25;
            self.detailLabelMargin = 25;
            self.imageMargin = 0;
            self.imageSize=CGSizeMake(20, 20);
            self.backgroundColor = [UIColor clearColor];
            self.textLabel.textColor = [UIColor whiteColor];
            self.textLabel.font = [UIFont boldSystemFontOfSize:13];
            [self updateUIByHistoryPoint:aHistoryPoint];
        }
    }
    
    return self;
}

- (void)updateUIByHistoryPoint:(NSDictionary *)aHistoryPoint
{
//    _historyPoint = aHistoryPoint;
    NSString *mainTitle;
    NSString *subTitle;
    if (!aHistoryPoint) {
        mainTitle = @"";
        subTitle = @"";
    } else {
        mainTitle = [[ADSingletonUtil sharedInstance] alertNameByCode:[aHistoryPoint objectForKey:@"code"]];
        subTitle = [NSString stringWithFormat:@"%@ %@",[aHistoryPoint objectForKey:@"serverDate"], [aHistoryPoint objectForKey:@"serverTime"]];
    }
    self.textLabel.text = mainTitle;
    self.detailTextLabel.text = subTitle;
    self.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"code_%@.png",[aHistoryPoint objectForKey:@"code"]]];
    if(self.imageView.image==nil){
        self.imageView.image=[UIImage imageNamed:@"code_other.png"];
    }
}

@end
