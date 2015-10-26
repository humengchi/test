//
//  NotificationStatusCell.h
//  OBDClient
//
//  Created by hys on 23/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationStatusCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchBtn;

@end
