//
//  ADProtocolViewController.m
//  OBDClient
//
//  Created by hys on 24/9/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADProtocolViewController.h"

@interface ADProtocolViewController ()

@end

@implementation ADProtocolViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"车随行用户服务协议";
    self.navigationController.navigationBarHidden=NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    UIView* titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    UIImageView* titleImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    titleImgView.image=[UIImage imageNamed:@"app_topbar_bg~iphone.png"];
    [titleView addSubview:titleImgView];
    
    UILabel* titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(60, 7, WIDTH-120, 30)];
    titleLabel.text=@"车随行用户服务协议";
    titleLabel.textAlignment=NSTextAlignmentCenter;
    titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:20];
    titleLabel.textColor=[UIColor whiteColor];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:titleLabel];
    
    UIButton* registerBackButton=[[UIButton alloc]initWithFrame:CGRectMake(8, 9, 50, 30)];
    [registerBackButton addTarget:self action:@selector(registerBackButton:) forControlEvents:UIControlEventTouchUpInside];
    [registerBackButton setTitle:NSLocalizedStringFromTable(@"back",@"MyString", @"") forState:UIControlStateNormal];
    [registerBackButton setBackgroundImage:[UIImage imageNamed:@"nav_back_nor.png"] forState:UIControlStateNormal];
    [registerBackButton setBackgroundImage:[UIImage imageNamed:@"nav_back_act.png"] forState:UIControlStateHighlighted];
    [registerBackButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    [registerBackButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 6, 2, 0)];
    registerBackButton.titleLabel.font=[UIFont systemFontOfSize:12];
    [registerBackButton setBackgroundColor:[UIColor clearColor]];
    [titleView addSubview:registerBackButton];
    [self.view addSubview:titleView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [titleView setFrame:CGRectMake(0, 20, WIDTH, 44)];
        CGRect frame=_protocolTV.frame;
        frame.origin.y+=64;
        [_protocolTV setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }else if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [titleView setFrame:CGRectMake(0, 20, WIDTH, 44)];
        CGRect frame=_protocolTV.frame;
        frame.origin.y+=64;
        [_protocolTV setFrame:frame];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }else if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
//        [titleView setFrame:CGRectMake(0, 20, 320, 44)];
//        CGRect frame=_protocolTV.frame;
//        frame.origin.y+=20;
//        [_protocolTV setFrame:frame];
        CGRect frame=_protocolTV.frame;
        frame.origin.y+=44;
        [_protocolTV setFrame:frame];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action
- (void)registerBackButton:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

@end
