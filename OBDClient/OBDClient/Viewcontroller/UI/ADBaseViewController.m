//
//  ADBaseViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-6-19.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
@interface ADBaseViewController ()

@end

@implementation ADBaseViewController    //设置了图层的背景颜色

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg.png"]];
    self.navigationController.view.layer.shadowOpacity = 0.9f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [COLOR_RGB(0, 0, 0) CGColor];
    if (IOS7_OR_LATER) {
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }

}

@end
