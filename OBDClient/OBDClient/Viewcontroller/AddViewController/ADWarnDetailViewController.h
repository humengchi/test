//
//  ADWarnDetailViewController.h
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADWarnListViewController.h"
#import "ADSetReadFlagForCurrentMessageModel.h"

extern NSString* const ADWarnDetailReadFlagNotification;

@interface ADWarnDetailViewController : UIViewController<ADSetReadFlagForCurrentMessageDelegate>


@property(strong,nonatomic)UILabel* warnTitleLabel;

@property(strong,nonatomic)UILabel* warnPiorityLabel;

@property(strong,nonatomic)UILabel* warnTimeLabel;

@property(strong,nonatomic)UILabel* warnContentLabel;

@property(strong,nonatomic)NSString* warnTitle;

@property(strong,nonatomic)NSString* warnPiority;

@property(strong,nonatomic)NSString* warnTime;

@property(strong,nonatomic)NSString* warnContent;

@property(strong,nonatomic)NSDictionary* warn;

@property(strong,nonatomic)ADSetReadFlagForCurrentMessageModel* setReadFlagForCurrentMessageModel;

@end
