//
//  ADChatTabBarViewController.m
//  OBDClient
//
//  Created by hmc on 16/1/15.
//  Copyright (c) 2015年 AnyData.com. All rights reserved.
//

#import "ADChatTabBarViewController.h"
#import "ADAppDelegate.h"

@interface ADChatTabBarViewController ()
{
    UIView *view;
    UILabel *badgeValue;
}

@end

@implementation ADChatTabBarViewController

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
    
    
    ADNearContactViewController *nearFriendsVC = [[ADNearContactViewController alloc] init];
    
    ADUserFriendsViewController *userFriendsVC = [[ADUserFriendsViewController alloc] init];
    
    LatestInformationViewController *latestVC = [[LatestInformationViewController alloc] init];
    
    UIView *tabbarView = [[UIView alloc] initWithFrame:self.tabBar.frame];
    tabbarView.backgroundColor = [UIColor whiteColor];
    
    _button_recent = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_recent.tag = 0;
    _button_recent.frame = CGRectMake(40, 2, 40, 45);
    [_button_recent addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_button_recent setTitle:@"最近" forState:UIControlStateNormal];
    _button_recent.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_button_recent setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_button_recent setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
//    [_button_recent setImage:[UIImage imageNamed:@"recent_unselected.png"] forState:UIControlStateNormal];
//    [_button_recent setImage:[UIImage imageNamed:@"recent_selected.png"] forState:UIControlStateSelected];
    
    _button_contace = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_contace.tag = 1;
    _button_contace.frame = CGRectMake(140, 2, 40, 45);
    [_button_contace addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_button_contace setTitle:@"联系人" forState:UIControlStateNormal];
    _button_contace.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_button_contace setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_button_contace setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
//    [_button_contace setImage:[UIImage imageNamed:@"aqua.png"] forState:UIControlStateNormal];
//    [_button_contace setImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateSelected];
    
    _button_news = [UIButton buttonWithType:UIButtonTypeCustom];
    _button_news.tag = 2;
    _button_news.frame = CGRectMake(240, 2, 40, 45);
    [_button_news addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [_button_news setTitle:@"资讯" forState:UIControlStateNormal];
    _button_news.titleLabel.font = [UIFont systemFontOfSize:14.0f];
    [_button_news setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_button_news setTitleColor:[UIColor orangeColor] forState:UIControlStateSelected];
//    [_button_news setImage:[UIImage imageNamed:@"aqua.png"] forState:UIControlStateNormal];
//    [_button_news setImage:[UIImage imageNamed:@"orange.png"] forState:UIControlStateSelected];
    
    [tabbarView addSubview:_button_recent];
    [tabbarView addSubview:_button_contace];
    [tabbarView addSubview:_button_news];
    
    _button_selected = _button_recent;
    _button_selected.selected = YES;
    
    
    self.viewControllers = @[nearFriendsVC, userFriendsVC, latestVC];
    self.title = self.selectedViewController.title;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDateUI_main) name:@"GETNEWINFO_ALLNUMBER" object:nil];
    
    view = [[UIView alloc] initWithFrame:CGRectMake(65, 2, 18, 18)];
    view.backgroundColor = [UIColor redColor];
    view.layer.cornerRadius = 9;
    badgeValue = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 18, 18)];
    badgeValue.textAlignment = NSTextAlignmentCenter;
    badgeValue.textColor = [UIColor whiteColor];
    badgeValue.font = [UIFont systemFontOfSize:12];
    badgeValue.text = @"1";
    [view addSubview:badgeValue];
    [tabbarView addSubview:view];
    view.hidden = YES;
    
    [self.view addSubview:tabbarView];
    for(UIView *viewss in self.view.subviews)
	{
		if([viewss isKindOfClass:[UITabBar class]])
		{
			viewss.hidden = YES;
			break;
		}
	}
    // Do any additional setup after loading the view from its nib.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self upDateUI_main];
    [self.selectedViewController viewWillAppear:YES];
//    [self buttonPressed:(id)_button_recent];
}

#pragma mark 
#pragma mark -Method
- (IBAction)buttonPressed:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    if(_button_selected.tag == btn.tag){
        return;
    }
    self.selectedIndex = btn.tag;
    _button_selected.selected = NO;
    _button_selected = btn;
    _button_selected.selected = YES;
    self.title = self.selectedViewController.title;
    if([self.title isEqualToString:@"联系人"]){
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addFriendInBook_Not)];
        barBtn.tintColor = [UIColor lightGrayColor];
        self.navigationItem.rightBarButtonItem = barBtn;
    }else if([self.title isEqualToString:@"资讯"]){
        self.navigationItem.rightBarButtonItem = nil;
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshWebNews_Not)];
        barBtn.tintColor = [UIColor lightGrayColor];
        self.navigationItem.rightBarButtonItem = barBtn;
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)upDateUI_main
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString* allNumberChats = [NSString stringWithFormat:@"%@_ALLNUMBERCHAT", [self xmppStream].myJID.user];
    if([userDefault objectForKey:allNumberChats]){
        if([[userDefault objectForKey:allNumberChats] integerValue] > 0){
            view.hidden = NO;
            badgeValue.text = [userDefault objectForKey:allNumberChats];
        }else if([[userDefault objectForKey:allNumberChats] integerValue] == 0){
            view.hidden = YES;
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark -NSNotification
- (void)addFriendInBook_Not
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ADDFRIENDBOOK_NOT" object:nil];
}

- (void)refreshWebNews_Not
{
    [((LatestInformationViewController*)self.selectedViewController).webView reload];
}

#pragma mark -ADAppDelegate
-(ADAppDelegate *)appDelegate{
    return (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

@end
