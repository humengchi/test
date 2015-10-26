//
//  LatestInformationViewController.m
//  V3ViewController
//
//  Created by hys on 12/9/13.
//  Copyright (c) 2013年 hys. All rights reserved.
//

#import "LatestInformationViewController.h"

@interface LatestInformationViewController ()

@end

@implementation LatestInformationViewController
@synthesize webView;

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
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title=NSLocalizedStringFromTable(@"informationKey",@"MyString", @"");
	// Do any additional setup after loading the view.
   //    UITableView* informationTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 60, WIDTH, WIDTH) style:UITableViewStylePlain];
//    informationTableView.delegate=self;
//    informationTableView.dataSource=self;
//    [self.view addSubview:informationTableView];
    webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 416)];
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://info.3g.qq.com/g/s?sid=AeGDXEsFiNcNq2X8JZWTpQ0Y&icfa=auto_h&aid=template&tid=F3G_09xinche"]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
//        [webView setFrame:CGRectMake(0, 0, WIDTH, 416)];
//        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
//        [view setBackgroundColor:[UIColor grayColor]];
//        [self.view addSubview:view];
        [webView setFrame:CGRectMake(0, 62, WIDTH, 480-62)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [webView setFrame:CGRectMake(0, 0, WIDTH, 504)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [webView setFrame:CGRectMake(0, 62, WIDTH, 568-62)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    [webView setFrame:CGRectMake(0, 62, WIDTH, HEIGHT-62)];

}
#pragma mark -Button action

//#pragma mark -setup TableView
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    return 1;
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return 8;
//}
//
//-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *cellIdentifier=@"MenuCell";
//    MenuCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
//    if(cell==nil)
//    {
//        NSArray *xib=[[NSBundle mainBundle] loadNibNamed:@"MenuCell" owner:self options:nil];
//        cell=(MenuCell*)[xib objectAtIndex:0];
//        
//    }
//    switch (indexPath.row) {
//        case 0:
//            cell.menuLabel.text=@"首页";
//            break;
//        case 1:
//            cell.menuLabel.text=@"首页";
//            break;
//        case 2:
//            cell.menuLabel.text=@"首页";
//            break;
//            
//        case 3:
//            cell.menuLabel.text=@"首页";
//            break;
//            
//        case 4:
//            cell.menuLabel.text=@"首页";
//            break;
//            
//        case 5:
//            cell.menuLabel.text=@"首页";
//            break;
//            
//        case 6:
//            cell.menuLabel.text=@"首页";
//            break;
//            
//        default:
//            break;
//    }
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
