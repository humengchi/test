//
//  MessageCell.h
//  OBDClient
//
//  Created by hys on 1/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *typeImgView;
@property (weak, nonatomic) IBOutlet UILabel *typeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *unreadNumImgView;
@property (weak, nonatomic) IBOutlet UILabel *unreadNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *separatorLineImgView;

@end
