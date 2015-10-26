//
//  ADRecentHistroyViewController.m
//  OBDClient
//
//  Created by hys on 7/7/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADRecentHistroyViewController.h"
#import "ADSingletonUtil.h"
#include "ADDefine.h"

@interface ADRecentHistroyViewController ()

@end

@implementation ADRecentHistroyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.theArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
//    [NSString stringWithFormat:@"recentHistoryArray_%@",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]
    self.theArray = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"recentHistoryArray_%@",[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
//    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, WIDTH, self.view.bounds.size.height) style:UITableViewStylePlain];
    self.myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.backgroundColor = [UIColor blackColor];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: self.myTableView];
    self.myTableView.frame = CGRectMake(0, 64, WIDTH, HEIGHT-64);
    
    if (IOS7_OR_LATER) {
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        grayView.backgroundColor = [UIColor grayColor];
        [self.view addSubview:grayView];
//        CGRect frame=self.myTableView.frame;
//        frame.origin.y+=64;
//        frame.size.height-=64;
//        [self.myTableView setFrame:frame];
    }
    
//    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
//        self.myTableView.frame = CGRectMake(0, 20, WIDTH, self.view.bounds.size.height);
//	}
//    if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS6.0 3.5寸屏幕
//        self.myTableView.frame = CGRectMake(0, 44, WIDTH, self.view.bounds.size.height);
//	}
//    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
//        self.myTableView.frame = CGRectMake(0, 44, WIDTH, self.view.bounds.size.height);
//    }
//    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
//        self.myTableView.frame = CGRectMake(0, 20, WIDTH, self.view.bounds.size.height);
//	}

//    self.theArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"recentHistoryArray"];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.theArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentify = @"UITableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentify];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentify];
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    cell.textLabel.text = [formatter stringFromDate:[self.theArray objectAtIndex:indexPath.row]];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,39, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate fllush:[self.theArray objectAtIndex:indexPath.row]];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
