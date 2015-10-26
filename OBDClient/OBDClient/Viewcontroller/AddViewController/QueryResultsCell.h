//
//  QueryResultsCell.h
//  OBDClient
//
//  Created by hys on 26/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryResultsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *addressImgView;
@property (weak, nonatomic) IBOutlet UILabel *addressNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
