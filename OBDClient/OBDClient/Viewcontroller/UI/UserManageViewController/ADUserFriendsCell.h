//
//  ADUserFriendsCell.h
//  OBDClient
//
//  Created by hys on 3/7/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADUserFriendsCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *groupName;
@property (nonatomic, weak) IBOutlet UILabel *callNumber;
@property (nonatomic, strong) IBOutlet UIImageView *imageview;
@property (nonatomic, strong) IBOutlet UIImageView *newsNum;

@end
