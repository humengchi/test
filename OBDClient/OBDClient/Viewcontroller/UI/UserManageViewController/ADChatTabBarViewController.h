//
//  ADChatTabBarViewController.h
//  OBDClient
//
//  Created by hmc on 16/1/15.
//  Copyright (c) 2015年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LatestInformationViewController.h"
#import "ADUserFriendsViewController.h"
#import "ADNearContactViewController.h"

@interface ADChatTabBarViewController : UITabBarController

@property (nonatomic, strong) IBOutlet UIButton *button_recent;
@property (nonatomic, strong) IBOutlet UIButton *button_contace;
@property (nonatomic, strong) IBOutlet UIButton *button_news;
@property (nonatomic, strong) UIButton *button_selected;

- (IBAction)buttonPressed:(id)sender;

@end
