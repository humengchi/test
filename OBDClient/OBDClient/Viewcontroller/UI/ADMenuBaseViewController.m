//
//  ADMenuBaseViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-24.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"


@interface ADMenuBaseViewController ()

@end

@implementation ADMenuBaseViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //自定义的button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 27.5);
    [button setBackgroundImage:[UIImage imageNamed:@"nav_button_nor.png"] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"nav_button_act.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(menuButtonTap:) forControlEvents:UIControlEventTouchUpInside];

    //根据自定义的button生成UIBarButtonItem(导航栏左边的button)
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
//    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_button_nor.png"] landscapeImagePhone:nil style:UIBarButtonItemStylePlain target:self action:@selector(menuButtonTap:)];
    
//    menuItem.possibleTitles = [NSSet setWithObject:@"菜单"];

    //设置导航栏的leftBarButtonItem为自定义的UIBarButtonItem
    self.navigationItem.leftBarButtonItem = menuItem;
    
    

}

  
- (IBAction)menuButtonTap:(id)sender    
{
    [self.slidingController anchorTopViewTo:ECRight]; //设置侧栏从左往右推出
}

@end
