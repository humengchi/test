//
//  ADMenuViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUtil.h"
#import "ADSlidingViewController.h"
#import "ADNavigationController.h"
#import "ADUserDetailModel.h"

@interface ADMenuViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSDictionary *menuDataSource;

@property (nonatomic) UIButton *button;

@property (nonatomic) UILabel *label;

- (CGFloat)cellHeight;

- (void)tableViewSelectedHandleInSubClasses:(NSString *)className;

@end
