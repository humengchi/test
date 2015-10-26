//
//  ADTrafficViewController.m
//  OBDClient
//
//  Created by hmc on 13/11/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADTrafficViewController.h"

#define TRAFFIC_URL @"http://180.166.124.142:9983/down/Traffic.pdf"

@interface ADTrafficViewController ()

@end

@implementation ADTrafficViewController

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
    self.title = @"交通标志";
    _myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 568)];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *help_ios = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"traffic"]stringByAppendingPathExtension:@"pdf"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:help_ios]){
            NSURL    *url = [NSURL URLWithString:TRAFFIC_URL];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSError *error = nil;
            NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:nil
                                                               error:&error];
            [data writeToFile:help_ios atomically:YES];
        }
        [self performSelectorOnMainThread:@selector(showWebView:) withObject:help_ios waitUntilDone:YES];
    });
    
    _myWebView.scalesPageToFit = YES;
    _myWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_myWebView];
    if(IOS7_OR_LATER && DEVICE_IS_IPHONE5){
        CGRect frame = _myWebView.frame;
        frame.origin.y = 64;
        frame.size.height = 568;
        _myWebView.frame = frame;
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        views.backgroundColor = [UIColor grayColor];
        [self.view addSubview:views];
    }else if(IOS7_OR_LATER && !DEVICE_IS_IPHONE5){
        CGRect frame = _myWebView.frame;
        frame.origin.y = 64;
        frame.size.height = 480;
        _myWebView.frame = frame;
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        views.backgroundColor = [UIColor grayColor];
        [self.view addSubview:views];
    }else if(!IOS7_OR_LATER && !DEVICE_IS_IPHONE5){
        CGRect frame = _myWebView.frame;
        frame.size.height = 480-64;
        _myWebView.frame = frame;
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showWebView:(NSString*)help_ios
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:help_ios]];
    
    [_myWebView loadRequest:request];
}

@end
