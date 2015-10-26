//
//  ADUserGuideViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserGuideViewController.h"
#import "ADMainWindow.h"


@interface ADUserGuideViewController ()

@end

@implementation ADUserGuideViewController

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
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    [self initGuide];   //加载新用户指导页面
}

- (void)initGuide
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [_scrollView setContentSize:CGSizeMake(WIDTH*3, 0)];
    [_scrollView setPagingEnabled:YES];  //视图整页显示
    [_scrollView setBounces:NO]; //避免弹跳效果,避免把根视图露出来
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 460)];
    [imageview setImage:[UIImage imageNamed:@"guide_1.jpg"]];
    [_scrollView addSubview:imageview];
    
    UIImageView *imageview1 = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, 460)];
    [imageview1 setImage:[UIImage imageNamed:@"guide_2.jpg"]];
    [_scrollView addSubview:imageview1];
    
    UIImageView *imageview2 = [[UIImageView alloc] initWithFrame:CGRectMake(640, 0, WIDTH, 460)];
    [imageview2 setImage:[UIImage imageNamed:@"guide_3.jpg"]];
    imageview2.userInteractionEnabled = YES;
    [_scrollView addSubview:imageview2];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];//在imageview3上加载一个透明的button
    [button setTitle:nil forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"action_app.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(98, 371, 124, 35)];
    [button addTarget:self action:@selector(firstpressed) forControlEvents:UIControlEventTouchUpInside];
    [imageview2 addSubview:button];
    _scrollView.delegate=self;
    [self.view addSubview:_scrollView];
    
    _pageController=[[UIPageControl alloc]initWithFrame:CGRectMake(60, 420, 200, 20)];
    _pageController.numberOfPages=3;
    _pageController.currentPage=0;
    [_pageController addTarget:self action:@selector(PageTurn:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_pageController];
    
    
    [imageview setFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [imageview1 setFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    [imageview2 setFrame:CGRectMake(WIDTH*2, 0, WIDTH, HEIGHT)];
    [_pageController setFrame:CGRectMake(60, HEIGHT-60, WIDTH-120, 20)];
    [button setFrame:CGRectMake(100, HEIGHT-100, WIDTH-200, 35)];
   
    
    if (!DEVICE_IS_IPHONE5) {
        imageview.image=[UIImage imageNamed:@"guide_1-3.5.jpg"];
        imageview1.image=[UIImage imageNamed:@"guide_2-3.5.jpg"];
        imageview2.image=[UIImage imageNamed:@"guide_3-3.5.jpg"];
    }

}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGPoint offset=scrollView.contentOffset;
    [_pageController setCurrentPage:offset.x/WIDTH];
}

-(void)PageTurn:(UIPageControl*)sender{
    int page=sender.currentPage;
    [_scrollView setContentOffset:CGPointMake(WIDTH*page, 0)];
}

- (void)firstpressed
 {
     [(ADMainWindow*)self.view.window transitionToLoginViewController];
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
