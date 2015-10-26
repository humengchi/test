//
//  ADHistroyMapViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHistroyMapViewController.h"
#import <math.h>
#include <stdio.h>
#define degreesToRadians(x) (M_PI*(x)/180.0)

@interface ADHistroyMapViewController ()
{
    int row;
    int n;
    int m;
    NSMutableArray *theArray;
    NSMutableArray *speedArray;
}
@end

@implementation ADHistroyMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil data:(NSArray *)adata
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _historyModel=[[ADHistoryModel alloc]init];
        [_historyModel addObserver:self
                        forKeyPath:KVO_HISTORY_TRACK_POINTS_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
        
        [_historyModel addObserver:self
                        forKeyPath:KVO_HISTORY_TRACKS_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:NULL];

        _data=adata;
        theArray = [[NSMutableArray alloc] init];
        speedArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"TrajectorymapKey",@"MyString", @"");
    [self.navigationController setToolbarHidden:YES];
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 416)];
//    _mapView.delegate = self;
//    _mapView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
    [self.view addSubview:_mapView];
    
    UIBarButtonItem *pointsButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"DetailedtrajectoryKey",@"MyString", @"") style:UIBarButtonItemStylePlain target:self action:@selector(trackPointsTap:)];
    self.navigationItem.rightBarButtonItem=pointsButtonItem;
    if (IOS7_OR_LATER) {
        pointsButtonItem.tintColor=[UIColor lightGrayColor];
    }
    
    _listView = [[UIView alloc]initWithFrame:CGRectMake(0, 183, WIDTH, 233)];
    _listView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"track_list_bg.png"]];
    _listView.alpha=0.8;
    _listView.hidden=YES;
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 233) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView=nil;
    self.tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
//    _tableView.hidden=YES;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
//    _tableView.separatorColor=[UIColor brownColor];
    
    [_listView addSubview:_tableView];
    [self.view addSubview:_listView];
    
    _detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    _detailView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"map_location.png"]];
    [self.view addSubview:_detailView];
    
    _tripNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 50)];
    _tripNumLabel.text=[NSString stringWithFormat:@"行驶里程:\n%3.2f公里",[[_data objectAtIndex:4] floatValue]/1000];
//    _tripNumLabel.text=@"行驶里程:\n0.0公里";
    _tripNumLabel.backgroundColor=[UIColor clearColor];
    _tripNumLabel.textColor=[UIColor darkGrayColor];
    _tripNumLabel.font=[UIFont boldSystemFontOfSize:12];
    _tripNumLabel.textAlignment=UITextAlignmentCenter;
    _tripNumLabel.numberOfLines=0;
    _tripNumLabel.lineBreakMode=UILineBreakModeWordWrap;
    [_detailView addSubview:_tripNumLabel];
    
    
    NSDateFormatter* formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* startDate=[formatter dateFromString:[_data objectAtIndex:2]];
    NSDate* endDate=[formatter dateFromString:[_data objectAtIndex:3]];
    NSTimeInterval sec=[endDate timeIntervalSinceDate:startDate];
    double time=sec/3600;
    _averageSpeedLabel=[[UILabel alloc]initWithFrame:CGRectMake(80, 0, 80, 50)];
    _averageSpeedLabel.text=[NSString stringWithFormat:@"平均速度:\n%2.1fKM/H",[[_data objectAtIndex:4] floatValue]/(1000*time)];
//    _averageSpeedLabel.text=@"平均速度:\n0.0KM/H";
    _averageSpeedLabel.backgroundColor=[UIColor clearColor];
    _averageSpeedLabel.textColor=[UIColor darkGrayColor];
    _averageSpeedLabel.font=[UIFont boldSystemFontOfSize:12];
    _averageSpeedLabel.textAlignment=UITextAlignmentCenter;
    _averageSpeedLabel.numberOfLines=0;
    _averageSpeedLabel.lineBreakMode=UILineBreakModeWordWrap;
    [_detailView addSubview:_averageSpeedLabel];
    
    _averageFuelConsumptionLabel=[[UILabel alloc]initWithFrame:CGRectMake(160, 0, 80, 50)];
    _averageFuelConsumptionLabel.text=@"平均油耗:\n--升/百公里";
    _averageFuelConsumptionLabel.backgroundColor=[UIColor clearColor];
    _averageFuelConsumptionLabel.textColor=[UIColor darkGrayColor];
    _averageFuelConsumptionLabel.font=[UIFont boldSystemFontOfSize:12];
    _averageFuelConsumptionLabel.textAlignment=UITextAlignmentCenter;
    _averageFuelConsumptionLabel.numberOfLines=0;
    _averageFuelConsumptionLabel.lineBreakMode=UILineBreakModeWordWrap;
    [_detailView addSubview:_averageFuelConsumptionLabel];
    
    int hour = (int)sec/3600;
    int minute = (int)(sec-hour*3600)/60;
    _tripTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(240, 0, 80, 50)];
    _tripTimeLabel.text=[NSString stringWithFormat:@"行驶时间:\n%d小时%d分",hour,minute];
//    _tripTimeLabel.text=@"行驶时间:\n0小时0分";
    _tripTimeLabel.backgroundColor=[UIColor clearColor];
    _tripTimeLabel.textColor=[UIColor darkGrayColor];
    _tripTimeLabel.font=[UIFont boldSystemFontOfSize:12];
    _tripTimeLabel.textAlignment=UITextAlignmentCenter;
    _tripTimeLabel.numberOfLines=0;
    _tripTimeLabel.lineBreakMode=UILineBreakModeWordWrap;
    [_detailView addSubview:_tripTimeLabel];


    //轨迹回放按钮
    reviewLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    reviewLineBtn.frame = CGRectMake(260, 455, 38, 38);
    [reviewLineBtn setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
//    reviewLineBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:0.0/255.0 alpha:1];
//    [reviewLineBtn.layer setMasksToBounds:YES];
//    [reviewLineBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//    [reviewLineBtn.layer setBorderWidth:2.0];   //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.5});
//    [reviewLineBtn.layer setBorderColor:colorref];//边框颜色
    
    reviewLineBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [reviewLineBtn setTitle:@"轨迹回放" forState:UIControlStateNormal];
    [reviewLineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [reviewLineBtn addTarget:self action:@selector(reviewLine) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reviewLineBtn];
    n = 1;
    m = 0;
    
    //打开标记按钮
    renewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    renewBtn.frame = CGRectMake(260, 430, 58, 20);
    renewBtn.hidden = YES;
    
//    renewBtn.backgroundColor = [UIColor colorWithRed:171.0/255.0 green:130.0/255.0 blue:255.0/255.0 alpha:1];
//    [renewBtn.layer setMasksToBounds:YES];
//    [renewBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//    [renewBtn.layer setBorderWidth:2.0];   //边框宽度
//    CGColorSpaceRef colorSpace1 = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref1 = CGColorCreate(colorSpace1,(CGFloat[]){ 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.5});
//    [renewBtn.layer setBorderColor:colorref1];//边框颜色
    
    renewBtn.titleLabel.font = [UIFont systemFontOfSize:12.0f];
    [renewBtn setTitle:@"打开标记" forState:UIControlStateNormal];
    [renewBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [renewBtn addTarget:self action:@selector(renewLine) forControlEvents:UIControlEventTouchUpInside];
    renewBtn.hidden = YES;
    [self.view addSubview:renewBtn];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, 416)];
        [_listView setFrame:CGRectMake(0, 247+80, WIDTH, 233)];
        [_detailView setFrame:CGRectMake(0, 64, WIDTH, 50)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
        reviewLineBtn.frame = CGRectMake(277, 122, 38, 38);
        renewBtn.frame = CGRectMake(260, 155, 58, 20);
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 0, WIDTH, 504)];
        [_listView setFrame:CGRectMake(0, 271+80, WIDTH, 233)];
        [_detailView setFrame:CGRectMake(0, 0, WIDTH, 50)];
        
        reviewLineBtn.frame = CGRectMake(277, 122, 38, 38);
        renewBtn.frame = CGRectMake(260, 155, 58, 20);
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, 504)];
        [_listView setFrame:CGRectMake(0, 335+80, WIDTH, 233)];
        [_detailView setFrame:CGRectMake(0, 64, WIDTH, 50)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
        
        reviewLineBtn.frame = CGRectMake(277, 122, 38, 38);
        renewBtn.frame = CGRectMake(260, 155, 58, 20);
	}

    
    [_historyModel requestTrackPointsWithAcctID:_data[0] DeviceID:_data[1] startDate:_data[2] endDate:_data[3]];
    
    //添加手势，点击map区域关闭列表的操作
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenList:)];
//    gesture.numberOfTapsRequired = 1;
//    [_mapView addGestureRecognizer:gesture];
    
    
    
}

- (void)renewLine
{
    if(myTimer){
        [myTimer invalidate];
        myTimer = nil;
    }
//    [reviewLineBtn setTitle:@"轨迹回放" forState:UIControlStateNormal];
//    reviewLineBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:0.0/255.0 alpha:1];
//    [reviewLineBtn.layer setMasksToBounds:YES];
//    [reviewLineBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//    [reviewLineBtn.layer setBorderWidth:2.0];   //边框宽度
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.5});
//    [reviewLineBtn.layer setBorderColor:colorref];//边框颜色
    [reviewLineBtn setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
    
    _listView.hidden = YES;
    n = 1;
    renewBtn.hidden = YES;
    [_historyModel requestTrackPointsWithAcctID:_data[0] DeviceID:_data[1] startDate:_data[2] endDate:_data[3]];
}

- (void)reviewLine
{
    if(theArray.count == 0)
        return;
    if(n==1){
        renewBtn.hidden = YES;
        [_mapView removeAnnotations:[[NSArray arrayWithArray:_mapView.annotations] mutableCopy]];
        CLLocationCoordinate2D coor;
        coor.latitude = [[[theArray objectAtIndex:0] objectForKey:@"latitude"]doubleValue];
        coor.longitude = [[[theArray objectAtIndex:0] objectForKey:@"longitude"] doubleValue];
        BMKCoordinateRegion region = BMKCoordinateRegionMake(coor, BMKCoordinateSpanMake(0.0052, 0.0052));//越小地图显示越详细0.000115
        [_mapView setRegion:region animated:YES];//执行设定显示范围
    }

    if(n++%2!=0){
//        [reviewLineBtn setTitle:@"停止回放" forState:UIControlStateNormal];
//        reviewLineBtn.backgroundColor = [UIColor colorWithRed:105.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1];
//        [reviewLineBtn.layer setMasksToBounds:YES];
//        [reviewLineBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//        [reviewLineBtn.layer setBorderWidth:2.0];   //边框宽度
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.5});
//        [reviewLineBtn.layer setBorderColor:colorref];//边框颜色
        [reviewLineBtn setImage:[UIImage imageNamed:@"stopButton.png"] forState:UIControlStateNormal];
        _listView.hidden = NO;
        [self start];
    }else{
//        [reviewLineBtn setTitle:@"继续回放" forState:UIControlStateNormal];
//        reviewLineBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1];
//        [reviewLineBtn.layer setMasksToBounds:YES];
//        [reviewLineBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//        [reviewLineBtn.layer setBorderWidth:2.0];   //边框宽度
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.5});
//        [reviewLineBtn.layer setBorderColor:colorref];//边框颜色
        [reviewLineBtn setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        _listView.hidden = NO;
        [self stop];
    }
}

//根据角度旋转图片
- (UIImage*)rotateImageWithRadian:(CGFloat)radian cropMode:(NSInteger)cropMode drawView:(BMKAnnotationView*)ImgView
{
    CGSize imgSize = CGSizeMake(ImgView.frame.size.width, ImgView.frame.size.height);
    CGSize outputSize = imgSize;
    if (cropMode == 1) {
        CGRect rect = CGRectMake(0, 0, imgSize.width+15, imgSize.height+15); //外部视图的大小
        rect = CGRectApplyAffineTransform(rect, CGAffineTransformMakeRotation(radian));
        outputSize = CGSizeMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    }
    
    UIGraphicsBeginImageContext(outputSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context, outputSize.width / 2, outputSize.height / 2);
    CGContextRotateCTM(context, radian);
    CGContextTranslateCTM(context, -imgSize.width / 2, -imgSize.height / 2);
    if([[[theArray objectAtIndex:row+1]objectForKey:@"longitude"] floatValue]>[[[theArray objectAtIndex:row]objectForKey:@"longitude"] doubleValue]){
        [ImgView.image drawInRect:CGRectMake(0, 10, imgSize.width, imgSize.height)];
    }else{
        [ImgView.image drawInRect:CGRectMake(0, -10, imgSize.width, imgSize.height)]; //汽车图片在外部视图中的位置和大小
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    CGRect imageRrect = CGRectMake(0, 0,ImgView.frame.size.width, ImgView.frame.size.height);
//    UIGraphicsBeginImageContext(imageRrect.size);
//    //    [ImgView.image drawInRect:CGRectMake(1,1,ImgView.frame.size.width-2,ImgView.frame.size.height-2)];
//    [ImgView.image drawInRect:CGRectMake(10,10,ImgView.frame.size.width-20,ImgView.frame.size.height-20)];
//    
//    ImgView.image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    
    return image;
}

//通过经纬度获取旋转的角度
- (double)getOrian:(int)i
{
    double x1 = 1;
    double y1 = 0;
    double x2, y2;
    if(i<theArray.count-2){
    x2 = [[[theArray objectAtIndex:i+2]objectForKey:@"longitude"] floatValue]-[[[theArray objectAtIndex:i+1]objectForKey:@"longitude"] doubleValue];
    y2 = [[[theArray objectAtIndex:i+2]objectForKey:@"latitude"] floatValue]-[[[theArray objectAtIndex:i+1]objectForKey:@"latitude"] doubleValue];
    }else{
        x2 = [[[theArray objectAtIndex:i]objectForKey:@"longitude"] floatValue]-[[[theArray objectAtIndex:i-1]objectForKey:@"longitude"] doubleValue];
        y2 = [[[theArray objectAtIndex:i]objectForKey:@"latitude"] floatValue]-[[[theArray objectAtIndex:i-1]objectForKey:@"latitude"] doubleValue];
    }
    double n1 = x1*x2+y1*y2;
    double m1 = sqrt(x1*x1)*sqrt(x2*x2+y2*y2);
    double t = acos(n1/m1);
    if(i<theArray.count-2){
        if([[[theArray objectAtIndex:i+2]objectForKey:@"latitude"] floatValue]>[[[theArray objectAtIndex:1+i]objectForKey:@"latitude"] floatValue]){
        double r = 360-t*180/3.1415;
        return r;
        }
    }else{
        if([[[theArray objectAtIndex:i]objectForKey:@"latitude"] floatValue]>[[[theArray objectAtIndex:i-1]objectForKey:@"latitude"] floatValue]){
            double r = 360-t*180/3.1415;
            return r;
        }
    }
    return t*180/3.1415;
}

//轨迹回放函数
- (void)nextStep
{
    CLLocationCoordinate2D coor;
    if(m<theArray.count){
        if([[[speedArray objectAtIndex:m] objectForKey:@"speed"]integerValue] == 0){
            [_tableView setContentSize:CGSizeMake(WIDTH, theArray.count*80)];
            [_tableView setContentOffset:CGPointMake(0, m*80) animated:YES];
            m++;
            return;
        }
        [_mapView removeAnnotation:item];
        coor.latitude = [[[theArray objectAtIndex:m] objectForKey:@"latitude"]doubleValue];
        coor.longitude = [[[theArray objectAtIndex:m] objectForKey:@"longitude"] doubleValue];
        if(coor.latitude == 0&& coor.longitude == 0){
            [_tableView setContentOffset:CGPointMake(0, m*80) animated:YES];
            m++;
            return;
        }
        if(!item)
            item = [[BMKPointAnnotation alloc]init];
        item.coordinate = coor;//经纬度
        item.title = @"guijihuifang";
        [_mapView addAnnotation:item];
        if(m%2==0){
            [UIView beginAnimations:@"animation" context:nil];
            [UIView setAnimationDuration:0.5f];
            [_mapView setCenterCoordinate:coor];
            [UIView commitAnimations];
        }
        
        [_tableView setContentOffset:CGPointMake(0, m*80) animated:YES];
        row = m;
        m++;
    }else{
        [myTimer invalidate];
        myTimer = nil;
        m = 0;
        row = 0;
//        [reviewLineBtn setTitle:@"重新回放" forState:UIControlStateNormal];
//        reviewLineBtn.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:139.0/255.0 blue:0.0/255.0 alpha:1];
//        [reviewLineBtn.layer setMasksToBounds:YES];
//        [reviewLineBtn.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
//        [reviewLineBtn.layer setBorderWidth:2.0];   //边框宽度
//        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//        CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 240.0/255.0, 240.0/255.0, 240.0/255.0, 0.5});
//        [reviewLineBtn.layer setBorderColor:colorref];//边框颜色
        [reviewLineBtn setImage:[UIImage imageNamed:@"playButton.png"] forState:UIControlStateNormal];
        n++;
    }
}

- (void)stop
{
    NSLog(@"stop");
    [myTimer setFireDate:[NSDate distantFuture]];
}

- (void)start
{
    NSLog(@"start");
    if(!myTimer){
        myTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(nextStep) userInfo:nil repeats:YES];
    }
    [myTimer setFireDate:[NSDate distantPast]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    [myTimer invalidate];
    myTimer = nil;
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_historyModel removeObserver:self
                       forKeyPath:KVO_HISTORY_TRACK_POINTS_PATH_NAME];
    [_historyModel removeObserver:self
                       forKeyPath:KVO_HISTORY_TRACKS_PATH_NAME];
    
    [_historyModel cancel];
    if (_mapView) {
        _mapView = nil;
    }
    if(myTimer){
        myTimer = nil;
        n = 1;
    }
    _mapView = nil;
}

- (void)viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];
    _mapView.delegate = self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _historyModel) {
        if ([keyPath isEqualToString:KVO_HISTORY_TRACK_POINTS_PATH_NAME]) {
            [self  updateMapByDataSource:_historyModel.trackPoints];
            [_tableView reloadData];
            return;
        }else if ([keyPath isEqualToString:KVO_HISTORY_TRACKS_PATH_NAME]){
            [self updateDetailView];
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

-(IBAction)trackPointsTap:(id)sender{
    if(_listView.hidden){
        [self hidden:_listView enable:NO type:@"pop"];
    }else{
        [self hidden:_listView enable:YES type:@"push"];
    }
}

-(IBAction)hidenList:(id)sender{
    [self hidden:_listView enable:YES type:@"push"];
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _historyModel.trackPoints.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSDictionary *data=_historyModel.trackPoints[indexPath.row];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[[data objectForKey:@"address_num"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    if([[data objectForKey:@"latitude"] floatValue]==0&&[[data objectForKey:@"longitude"] floatValue]==0){
        cell.textLabel.text=NSLocalizedStringFromTable(@"noposition",@"MyString", @"");
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    NSString *codeAndTime = [NSString stringWithFormat:@"%@ %@ %@\n",[[ADSingletonUtil alloc] alertNameByCode:[data objectForKey:@"code"] ],[data objectForKey:@"serverDate"], [data objectForKey:@"serverTime"]];
    
    NSLog(@"%@",codeAndTime);
    int code=[[data objectForKey:@"code"] intValue];
    switch (code) {
//        case 3000:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",codeAndTime,@"设备拔出时间：",[data objectForKey:@"time_remove"]];
//            break;
//        case 3001:
//            break;
//        case 3003:
//            break;
//        case 3006:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@%@ %@%@%@ %@%@%@",codeAndTime,@"围栏id：",[data objectForKey:@"geoID"],@"速度：",[data objectForKey:@"speed"],@"KM/H",@"马达转速：",[data objectForKey:@"engineRPM"],@"转/秒",@"电池电压：",[data objectForKey:@"batt_level"],@"V"];
//            break;
        case 3008:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",codeAndTime,NSLocalizedStringFromTable(@"num_of_dtc",@"MyString", @""),[data objectForKey:@"num_of_dtc"]];
            break;
//        case 3009:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",codeAndTime,@"dtc报警个数：",[data objectForKey:@"num_of_dtc"]];
//            break;
        case 3010:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@",codeAndTime,NSLocalizedStringFromTable(@"speed",@"MyString", @""),[data objectForKey:@"speed"],NSLocalizedStringFromTable(@"engineRPM",@"MyString", @""),[data objectForKey:@"engineRPM"]];
            break;
//        case 3011:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@",codeAndTime,@"速度：",[data objectForKey:@"speed"],@"马达转速：",[data objectForKey:@"engineRPM"]];
//            break;
//        case 3012:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",codeAndTime,@"电池电压：",[data objectForKey:@"batt_level"]];
//            break;
//        case 3013:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",codeAndTime,@"非法移动时间：",[data objectForKey:@"unauth_time"]];
//            break;
        case 3014:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@",codeAndTime,NSLocalizedStringFromTable(@"driving_dist",@"MyString", @""),[data objectForKey:@"driving_dist"],NSLocalizedStringFromTable(@"fuel_level_now",@"MyString", @""),[data objectForKey:@"fuel_level_now"]];
            break;
        case 3015:
            cell.detailTextLabel.text=codeAndTime;
            break;
        case 3016:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@",codeAndTime,NSLocalizedStringFromTable(@"driving_dist",@"MyString", @""),[data objectForKey:@"driving_dist"],NSLocalizedStringFromTable(@"fuel_consumption",@"MyString", @""),[data objectForKey:@"fuel_consumption"]];
            break;
        case 3017:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",codeAndTime,NSLocalizedStringFromTable(@"high_temp",@"MyString", @""),[data objectForKey:@"high_temp"]];
            break;
//        case 3018:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@",codeAndTime,@"空转时长：",[data objectForKey:@"idle_time"],@"马达转速：",[data objectForKey:@"engineRPM"]];
//            break;
        case 3019:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@",codeAndTime,NSLocalizedStringFromTable(@"fuel_level_bef",@"MyString", @""),[data objectForKey:@"fuel_level_bef"],NSLocalizedStringFromTable(@"fuel_level_now",@"MyString", @""),[data objectForKey:@"fuel_level_now"]];
            break;
//        case 3020:
//            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@",codeAndTime,@"加（减）速方向：",[data objectForKey:@"speed_dir"]];
//            break;
        case 3024:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@ %@%@",codeAndTime,NSLocalizedStringFromTable(@"raw_data_include",@"MyString", @""),[data objectForKey:@"raw_data_include"],@"accel_x,y,z：",[data objectForKey:@"accel_x,y,z"],@"raw_x,y,z：",[data objectForKey:@"raw_x,y,z"]];
            break;
        case 3025:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@ %@%@ %@%@",codeAndTime,NSLocalizedStringFromTable(@"raw_data_include",@"MyString", @""),[data objectForKey:@"raw_data_include"],@"accel_x,y,z：",[data objectForKey:@"accel_x,y,z"],@"raw_x,y,z：",[data objectForKey:@"raw_x,y,z"],NSLocalizedStringFromTable(@"speed_corner",@"MyString", @""),[data objectForKey:@"speed_corner"]];
            break;
        case 3026:
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@%@ %@%@ %@%@",codeAndTime,NSLocalizedStringFromTable(@"raw_data_include",@"MyString", @""),[data objectForKey:@"raw_data_include"],@"accel_x,y,z：",[data objectForKey:@"accel_x,y,z"],@"raw_x,y,z：",[data objectForKey:@"raw_x,y,z"]];
            break;
        default:
            cell.detailTextLabel.text=codeAndTime;
            break;
    }

    
    cell.detailTextLabel.numberOfLines=0;
    
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    cell.textLabel.textColor=[UIColor orangeColor];
    cell.detailTextLabel.textColor=[UIColor orangeColor];
    
    NSString *imageName=@"track_center_tip.png";
    NSString *codeString=[data objectForKey:@"code"];
    if([codeString isEqualToString:@"3015"]||[codeString isEqualToString:@"3016"]||[codeString isEqualToString:@"3008"]||[codeString isEqualToString:@"3010"]||[codeString isEqualToString:@"3014"]||[codeString isEqualToString:@"3017"]||[codeString isEqualToString:@"3019"]||[codeString isEqualToString:@"3024"]||[codeString isEqualToString:@"3025"]||[codeString isEqualToString:@"3026"]){
        imageName = [NSString stringWithFormat:@"track_%@.png",codeString];
    }else if([codeString isEqualToString:@"3004"]||[codeString isEqualToString:@"3005"]){
        imageName = @"track_location.png";
        cell.detailTextLabel.textColor=[UIColor grayColor];
        cell.textLabel.textColor=[UIColor blackColor];
    }else{
        imageName=@"track_alert.png";
    }
    
    
    
    
    
    if(indexPath.row==0){
        cell.imageView.image=[UIImage imageNamed:@"track_3015.png"];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[[ADSingletonUtil alloc] alertNameByCode:@"3015"],[data objectForKey:@"serverDate"], [data objectForKey:@"serverTime"]];
//        cell.textLabel.textColor=[UIColor orangeColor];
//        cell.detailTextLabel.textColor=[UIColor orangeColor];
    }else if (indexPath.row==_historyModel.trackPoints.count-1){
        cell.imageView.image=[UIImage imageNamed:@"track_3016.png"];
//        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@",[[ADSingletonUtil alloc] alertNameByCode:@"3016"],[data objectForKey:@"serverDate"], [data objectForKey:@"serverTime"]];
//        cell.textLabel.textColor=[UIColor orangeColor];
//        cell.detailTextLabel.textColor=[UIColor orangeColor];
    }else{
        cell.imageView.image=[UIImage imageNamed:imageName];
    }
    cell.backgroundColor=[UIColor whiteColor];
    //    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%d",indexPath.row);
    [self updateMapByPoint:_historyModel.trackPoints[indexPath.row]];
    
}

-(void)hidden:(UIView*)view enable:(BOOL)enable type:(NSString *)type{
    CATransition *animation = [CATransition animation];
    if([type isEqualToString:@"push"]){
        animation.type =kCATransitionPush;
        animation.subtype = kCATransitionFromBottom;
    }else if([type isEqualToString:@"pop"]){
        animation.type =kCATransitionPush;
        animation.subtype = kCATransitionFromTop;
    }
    
    animation.duration = 0.3;
    [view.layer addAnimation:animation forKey:nil];
    
    view.hidden = enable;
}

-(void)updateMapByPoint:(NSDictionary*)aPoint{

    [self hidden:_listView enable:YES type:@"push"];
    if([[aPoint objectForKey:@"latitude"] floatValue]==0&&[[aPoint objectForKey:@"longitude"] floatValue]==0){
        return;
    }
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([[aPoint objectForKey:@"latitude"] floatValue],[[aPoint objectForKey:@"longitude"] floatValue]);
    //地图纠正
    NSDictionary *tip = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_COMMON);    CLLocationCoordinate2D coor = BMKCoorDictionaryDecode(tip);
    [_mapView setCenterCoordinate:coor animated:YES];
//    [_mapView setZoomLevel:14];
}

-(void)updateDetailView{
    
}
-(void)updateMapByDataSource:(NSArray*)aDataSource{
    if([_mapView.overlays count]!=0){
        [_mapView removeOverlays:_mapView.overlays];
    }
    NSMutableArray *annotationMArray = [[NSArray arrayWithArray:_mapView.annotations] mutableCopy];
    
    [_mapView removeAnnotations:annotationMArray];
    
    if([annotationMArray count]!=0){
        [_mapView removeAnnotations:annotationMArray];
    }
    
    NSUInteger count = [aDataSource count];
    speedArray = [aDataSource mutableCopy];
//    CLLocationCoordinate2D coors[count];
    
//    BMKMapPoint northEastPoint;
//    BMKMapPoint southWestPoint;
//    
//    BMKMapPoint *pointArr = malloc(sizeof(CLLocationCoordinate2D) * count);
    
    CLLocationCoordinate2D *locationCoodinateArr = malloc(sizeof(CLLocationCoordinate2D) * count);
    
    NSMutableArray *allCoordinateArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < [aDataSource count]; i ++) {
        NSDictionary *historyPoint = [aDataSource objectAtIndex:i];
        NSLog(@"%@",[historyPoint objectForKey:@"code"]);
        double latitude = [[historyPoint objectForKey:@"latitude"] doubleValue];
        double longitude = [[historyPoint objectForKey:@"longitude"] doubleValue];
//        [speedArray addObject:[historyPoint objectForKey:@"speed"]];
        NSString *address = [NSString stringWithFormat:@"%@ %@ %@",[historyPoint objectForKey:@"serverDate"], [historyPoint objectForKey:@"serverTime"],[[historyPoint objectForKey:@"address_num"] stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
        
        if(latitude==0&&longitude==0){
            for(int s=i; s<[aDataSource count]; s++){
                NSDictionary *historySearchPoint = [aDataSource objectAtIndex:s];
                if([[historySearchPoint objectForKey:@"latitude"] doubleValue]!=0&&[[historySearchPoint objectForKey:@"longitude"] doubleValue]!=0){
                    latitude = [[historySearchPoint objectForKey:@"latitude"] doubleValue];
                    longitude = [[historySearchPoint objectForKey:@"longitude"] doubleValue];
                    break;
                }
    
            }
            
            if(latitude==0&&longitude==0){
                for (int t=i; t>-1; t--) {
                    NSDictionary *historySearchPointBack = [aDataSource objectAtIndex:t];
                    if([[historySearchPointBack objectForKey:@"latitude"] doubleValue]!=0&&[[historySearchPointBack objectForKey:@"longitude"] doubleValue]!=0){
                        latitude = [[historySearchPointBack objectForKey:@"latitude"] doubleValue];
                        longitude = [[historySearchPointBack objectForKey:@"longitude"] doubleValue];
                        break;
                    }
                }
            }
            
            address = [NSString stringWithFormat:@"%@ %@ %@",[historyPoint objectForKey:@"serverDate"], [historyPoint objectForKey:@"serverTime"],NSLocalizedStringFromTable(@"noposition",@"MyString", @"")];
        }
        
        if(latitude==0&&longitude==0){
            
            [IVToastHUD showAsToastErrorWithStatus:@"无任何上报有效位置的轨迹点！"];
            return;
        }
        
        NSString *code = [historyPoint objectForKey:@"code"] ;
//        coors[i].latitude = latitude;
//        coors[i].longitude = longitude;
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longitude);
        //地图纠正
        NSDictionary *tip = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_COMMON);
        
        CLLocationCoordinate2D coordinate1 = BMKCoorDictionaryDecode(tip);
        
//        BMKMapPoint point = BMKMapPointForCoordinate(coordinate1);
        
        if([code isEqualToString:@"3015"]||[code isEqualToString:@"3016"]||[code isEqualToString:@"3008"]||[code isEqualToString:@"3010"]||[code isEqualToString:@"3014"]||[code isEqualToString:@"3017"]||[code isEqualToString:@"3019"]||[code isEqualToString:@"3024"]||[code isEqualToString:@"3025"]||[code isEqualToString:@"3026"]){
            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
            annotation.coordinate = coordinate1;
            annotation.title=code;
            annotation.subtitle=address;
//            NSLog(@"%f,%f",annotation.coordinate.latitude,annotation.coordinate.longitude);
            [_mapView addAnnotation:annotation];
        }
        
//        if(i==0||i==[aDataSource count]-1){
//            BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
//            annotation.coordinate = coordinate1;
//            if(i==0){
//                annotation.title = @"3015";
//            }else if(i==[aDataSource count]-1){
//                annotation.title = @"3016";
//            }
//            
//            [_mapView addAnnotation:annotation];
//            
//            
//        }
        
//        if (i == 0) {
//            northEastPoint = point;
//            southWestPoint = point;
//        } else {
//            if (point.x > northEastPoint.x)
//            {
//                northEastPoint.x = point.x;
//            }
//            if (point.y > northEastPoint.y)
//            {
//                northEastPoint.y = point.y;
//            }
//            if (point.x < southWestPoint.x)
//            {
//                southWestPoint.x = point.x;
//            }
//            if (point.y < southWestPoint.y)
//            {
//                southWestPoint.y = point.y;
//            }
//        }
//        pointArr[i] = point;
        locationCoodinateArr[i] = coordinate1;
        [theArray addObject:@{@"latitude": [NSString stringWithFormat:@"%f", coordinate1.latitude], @"longitude":[NSString stringWithFormat:@"%f", coordinate1.longitude]}];
        
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:coordinate1.latitude longitude:coordinate1.longitude];
        [allCoordinateArr addObject:currentLocation];
    }
    
    for (int i = 0; i < [aDataSource count]; i ++) {
        
        if(i==0||i==[aDataSource count]-1){
            NSDictionary *historyPoint = [aDataSource objectAtIndex:i];
            NSLog(@"%@",[historyPoint objectForKey:@"code"]);
            double latitude = [[historyPoint objectForKey:@"latitude"] doubleValue];
            double longitude = [[historyPoint objectForKey:@"longitude"] doubleValue];
            
            if(i==0){
                if(latitude==0&&longitude==0){
                    for(int s=i; s<[aDataSource count]; s++){
                        NSDictionary *historySearchPoint = [aDataSource objectAtIndex:s];
                        if([[historySearchPoint objectForKey:@"latitude"] doubleValue]!=0&&[[historySearchPoint objectForKey:@"longitude"] doubleValue]!=0){
                            latitude = [[historySearchPoint objectForKey:@"latitude"] doubleValue];
                            longitude = [[historySearchPoint objectForKey:@"longitude"] doubleValue];
                            
                            break;
                        }
                        
                    }
                }
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longitude);
                //地图纠正
                NSDictionary *tip = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_COMMON);
                
                CLLocationCoordinate2D coordinate1 = BMKCoorDictionaryDecode(tip);
                
                BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
                annotation.coordinate = coordinate1;
                annotation.title = @"3015";
                [_mapView addAnnotation:annotation];
            }else if(i==[aDataSource count]-1){
                if(latitude==0&&longitude==0){
                    for (int t=i; t>-1; t--) {
                        NSDictionary *historySearchPointBack = [aDataSource objectAtIndex:t];
                        if([[historySearchPointBack objectForKey:@"latitude"] doubleValue]!=0&&[[historySearchPointBack objectForKey:@"longitude"] doubleValue]!=0){
                            latitude = [[historySearchPointBack objectForKey:@"latitude"] doubleValue];
                            longitude = [[historySearchPointBack objectForKey:@"longitude"] doubleValue];
                            break;
                        }
                    }
                }
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude,longitude);
                //地图纠正
                NSDictionary *tip = BMKConvertBaiduCoorFrom(coordinate, BMK_COORDTYPE_COMMON);
                
                CLLocationCoordinate2D coordinate1 = BMKCoorDictionaryDecode(tip);
                
                BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
                annotation.coordinate = coordinate1;
                annotation.title = @"3016";
                [_mapView addAnnotation:annotation];
            }
            
        }
        
    }
    
    //    CLLocationCoordinate2D coorss[2] = {0};
    //    coorss[0].latitude = 31.319311;
    //    coorss[0].longitude = 121.592800;
    //    coorss[1].latitude = 31.509311;
    //    coorss[1].longitude = 121.582800;
    //    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coorss count:2];
    //    [_mapView setCenterCoordinate:coorss[0]];
    //
    //    [_mapView addOverlay:polyline];
    
    //    _routeLine = [BMKPolyline polylineWithPoints:locationCoodinateArr count:count];
    _routeLine = [BMKPolyline polylineWithCoordinates:locationCoodinateArr count:count];
    //    _routRect = BMKMapRectMake(southWestPoint.x, southWestPoint.y, northEastPoint.x - southWestPoint.x, northEastPoint.y - southWestPoint.y);
//    free(pointArr);
    [_mapView addOverlay:_routeLine];
    [self setRegion:allCoordinateArr];
    //    BMKPolygon *polygon = [BMKPolygon polygonWithCoordinates:coors count:count];
    //    [_mapView addOverlay:polygon];
    
    
    
    
    //    [_mapView setZoomLevel:18];
}

//设置地图当前显示的区域
- (void)setRegion:(NSArray * )arr
{
    if ([arr count]!=0) {
        // determine the extents of the trip points that were passed in, and zoom in to that area.
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
        
        for(int i = 0; i < [arr count]; i++)
        {
            CLLocation* currentLocation = [arr objectAtIndex:i];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        
        BMKCoordinateRegion region;
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  = maxLat - minLat;
        region.span.longitudeDelta = maxLon - minLon;
        [_mapView setRegion:region];
        
        CLLocation *location = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
        
        //        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
        //        CLLocationCoordinate2D coor = location.coordinate;
        //        annotation.coordinate = coor;
        //        annotation.title = @"";
        //        [_mapView addAnnotation:annotation];
        
        [_mapView setCenterCoordinate:location.coordinate];
    }else {
        //"无轨迹！";
    }
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = COLOR_RGB(28, 134, 238);
        polylineView.lineWidth = 4.0;
        return polylineView;
    }
    return nil;
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                   reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        NSString *imageName =@"track_alert.png";
        if([annotation.title isEqualToString: @"3015"]||[annotation.title isEqualToString: @"3016"]||[annotation.title isEqualToString:@"3008"]||[annotation.title isEqualToString:@"3010"]||[annotation.title isEqualToString:@"3014"]||[annotation.title isEqualToString:@"3017"]||[annotation.title isEqualToString:@"3019"]||[annotation.title isEqualToString:@"3024"]||[annotation.title isEqualToString:@"3025"]||[annotation.title isEqualToString:@"3026"]){
            imageName = [NSString stringWithFormat:@"annotation_%@.png",annotation.title];
        }else if([annotation.title isEqualToString:@"3004"]||[annotation.title isEqualToString:@"3005"]){
            imageName = @"map_view_vehicle_auth.png";
        }else if([annotation.title isEqualToString:@"guijihuifang"]){
            newAnnotationView.enabled=NO;
            newAnnotationView.enabled3D=YES;
            newAnnotationView.animatesDrop = NO;//标注的动画效果.
            
            newAnnotationView.image = [UIImage imageNamed:@"car_right.png"];
//            newAnnotationView.image = [self rotateImageWithRadian:degreesToRadians([self getOrian:(int)row]) cropMode:1 drawView:newAnnotationView];
            newAnnotationView.image = [self rotateImageWithRadian:degreesToRadians([[[speedArray objectAtIndex:row] objectForKey:@"heading"] floatValue]-90) cropMode:1 drawView:newAnnotationView];
            NSLog(@"\n%d\n",[[[speedArray objectAtIndex:row] objectForKey:@"heading"] integerValue]);
            return newAnnotationView;
        }else{
            imageName=@"annotation_alert.png";
        }
        newAnnotationView.image=[UIImage imageNamed:imageName];
        
        BMKPointAnnotation *newAnnotation=[[BMKPointAnnotation alloc]init];
        newAnnotation= annotation;
        newAnnotation.title=[NSString stringWithFormat:@"%@",[[ADSingletonUtil alloc] alertNameByCode:annotation.title]];
//        newAnnotation.subtitle=[newAnnotation.subtitle substringFromIndex:20];
        newAnnotationView.annotation=newAnnotation;
        
        if ([annotation.title isEqualToString:@"3004"]||[annotation.title isEqualToString:@"3005"]) {
            newAnnotationView.bounds=CGRectMake(0, 0, 7, 7);
        }else{
            newAnnotationView.bounds=CGRectMake(0, 0, 21, 35);
        }
        
        newAnnotationView.animatesDrop =  NO;
//        CGPoint offset = {-10,-14};
//        newAnnotationView.centerOffset = offset;
//        newAnnotationView.enabled=YES;
        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    CLLocationCoordinate2D coor;
    coor=view.annotation.coordinate;
    [mapView setCenterCoordinate:coor animated:YES];
    
//    for (NSInteger i=0; i<[_historyModel.trackPoints count]; i++) {
//        NSDictionary* dic=[_historyModel.trackPoints objectAtIndex:i];
//        CLLocationCoordinate2D coordinate=CLLocationCoordinate2DMake([[dic objectForKey:@"latitude"] doubleValue], [[dic objectForKey:@"longitude"] doubleValue]);
//        NSDictionary* tip=BMKBaiduCoorForWgs84(coordinate);
//        CLLocationCoordinate2D coor2D=BMKCoorDictionaryDecode(tip);
//        if (coor.latitude==coor2D.latitude && coor.longitude==coor2D.longitude) {
//            [self hidden:_listView enable:NO type:@"push"];
//            [_tableView setContentOffset:CGPointMake(0, 80*i)];
//            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
//            [_tableView selectRowAtIndexPath:index animated:YES scrollPosition:UITableViewScrollPositionNone];
//            break;
//        }
//    }
    
}

@end