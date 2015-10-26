//
//  WeatherCell.h
//  V3ViewController
//
//  Created by hys on 11/9/13.
//  Copyright (c) 2013年 hys. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeatherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *monthAndDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImgView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@end
