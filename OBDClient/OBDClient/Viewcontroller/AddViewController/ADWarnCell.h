//
//  ADWarnCell.h
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADWarnCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *warnTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *warnTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *separatorLineImgView;
@property (weak, nonatomic) IBOutlet UIImageView *redFlagImgView;

@end
