//
//  ADWebNewsViewController.m
//  OBDClient
//
//  Created by hys on 25/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADWebNewsViewController.h"

@interface ADWebNewsViewController ()

@end

@implementation ADWebNewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _getNewsModel=[[ADGetNewsModel alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(showWebNews:)
                                                     name:ADGetNewsIDNotification
                                                   object:nil];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (IOS7_OR_LATER){
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }
    self.view.backgroundColor = [UIColor blackColor];
	// Do any additional setup after loading the view.
        
}

-(void)showWebNews:(NSNotification *)aNoti{
    NSString* sID=[aNoti object];
    _ID=[sID intValue];
    [_getNewsModel startRequestGetNewsWithArguments:[NSArray arrayWithObjects:@"3", nil]];
    _getNewsModel.getNewsDelegate=self;

    
    
}
//    _currentSelectedCity=(NSString*)[aNoti object];
//    //    [_netWorkingManager oilRequest];
//    [_CalendarModel startCallWithArguments:[NSArray arrayWithObjects:_currentSelectedCity, nil]];

-(void)handleGetNewsData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqual:@"200"]) {
        _newsArray=[dictionary objectForKey:@"data"];
        if ([_newsArray count]!=0) {
            NSDictionary* dic=[_newsArray objectAtIndex:_ID];
            NSString* contentUrl=[dic objectForKey:@"contentUrl"];
            _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 436)];
//            [_webView setScalesPageToFit:YES];
            NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
            NSString *server_url = [defaults objectForKey:@"server_url"];
            NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",server_url,contentUrl]]];
            [_webView loadRequest:request];
            _webView.delegate=self;
            [self.view addSubview:_webView];
        }else{
            NSLog(@"图片新闻返回值为空");
        }
        
    }
    else{
        NSLog(@"图片新闻系统错误");
    }
        
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(100, 200, 120, 80)];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [view setTag:108];
    [self.view addSubview:view];
    
    _acIndicator=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 64, 120, 80)];
    [_acIndicator setCenter:view.center];
    [_acIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [_acIndicator startAnimating];
    [self.view addSubview:_acIndicator];
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_webView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        [view setFrame:CGRectMake(100, 264, 120, 80)];
        [_acIndicator setFrame:CGRectMake(0, 64, 120, 80)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_webView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_webView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
        [view setFrame:CGRectMake(100, 264, 120, 80)];
        [_acIndicator setFrame:CGRectMake(0, 64, 120, 80)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [_acIndicator stopAnimating];
    UIView *view=(UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
}

@end
