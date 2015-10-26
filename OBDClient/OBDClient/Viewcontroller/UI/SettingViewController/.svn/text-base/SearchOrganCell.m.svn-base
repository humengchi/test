//
//  SearchOrganCell.m
//  OBDClient
//
//  Created by hys on 20/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "SearchOrganCell.h"

NSString* const ADSendToUserLocationSettingNotification = @"ADSendToUserLocationSettingNotification";

@implementation SearchOrganCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)TurnPageAction:(id)sender {
    UIButton* btn=(UIButton*)sender;
    int tag=btn.tag;
    switch (tag) {
        case 0:
            [[NSNotificationCenter defaultCenter]postNotificationName:ADSendToUserLocationSettingNotification object:_labOne.text];
            break;
        case 1:
            [[NSNotificationCenter defaultCenter]postNotificationName:ADSendToUserLocationSettingNotification object:_labTwo.text];
            break;
        case 2:
            [[NSNotificationCenter defaultCenter]postNotificationName:ADSendToUserLocationSettingNotification object:_labThree.text];
            break;
        case 3:
            [[NSNotificationCenter defaultCenter]postNotificationName:ADSendToUserLocationSettingNotification object:_labFour.text];
            break;
        default:
            break;
    }
}
@end
