//
//  ADMoreInfoCell.h
//  OBDClient
//
//  Created by hys on 2/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADMoreInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *keyLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *referenceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *oneImgView;
@property (weak, nonatomic) IBOutlet UIImageView *twoImgView;
@property (weak, nonatomic) IBOutlet UIImageView *bottomImgView;


@end
