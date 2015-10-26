//
//  ADCarManagerItemViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADCarManagerItemViewController.h"

@interface ADCarManagerItemViewController ()

@end

@implementation ADCarManagerItemViewController

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
    self.title = @"用户手册";
    _helpWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 568)];
    _helpWebView.delegate = self;
    _helpWebView.scalesPageToFit = YES;
    _helpWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_helpWebView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *help_ios = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"help_ios"]stringByAppendingPathExtension:@"pdf"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if(![fileManager fileExistsAtPath:help_ios]){
            NSURL    *url = [NSURL URLWithString:@"http://180.166.124.142:9983/down/help_ios.pdf"];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            NSError *error = nil;
            NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                                   returningResponse:nil
                                                               error:&error];
            [data writeToFile:help_ios atomically:YES];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL fileURLWithPath:help_ios]];
            [_helpWebView loadRequest:request];
        });
    });
    
    if(IOS7_OR_LATER && DEVICE_IS_IPHONE5){
        CGRect frame = _helpWebView.frame;
        frame.origin.y = 64;
        frame.size.height = 568;
        _helpWebView.frame = frame;
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        views.backgroundColor = [UIColor grayColor];
        [self.view addSubview:views];
    }else if(IOS7_OR_LATER && !DEVICE_IS_IPHONE5){
        CGRect frame = _helpWebView.frame;
        frame.origin.y = 64;
        frame.size.height = 480;
        _helpWebView.frame = frame;
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        views.backgroundColor = [UIColor grayColor];
        [self.view addSubview:views];
    }else if(!IOS7_OR_LATER && !DEVICE_IS_IPHONE5){
        CGRect frame = _helpWebView.frame;
        frame.size.height = 480-64;
        _helpWebView.frame = frame;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
//    self.title=@"开发页面";
}

@end
