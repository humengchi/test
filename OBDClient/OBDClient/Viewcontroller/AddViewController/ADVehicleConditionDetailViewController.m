//
//  ADVehicleConditionDetailViewController.m
//  OBDClient
//
//  Created by hys on 25/2/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADVehicleConditionDetailViewController.h"
#import "ADiPhoneHealthyViewController.h"

NSString * const ADDetailVehicleConditionToCarNotification =@"ADDetailVehicleConditionToCarNotification";

@interface ADVehicleConditionDetailViewController ()

@end

@implementation ADVehicleConditionDetailViewController

- (void)dealloc
{
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VCEHICLE_DETECTION_PATH_NAME
                           context:nil];
    [_vehiclesModel removeObserver:self
                        forKeyPath:KVO_VCEHICLE_DETECTION_INDEED_PATH_NAME
                           context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADVehiclesModelrequestVehicleDetectionFailNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADVehiclesModelGetConditionTimeOutNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADDetailVehicleConditionResultNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isCarAssistantView" object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _vehiclesModel=[[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VCEHICLE_DETECTION_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VCEHICLE_DETECTION_INDEED_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestVehicleDetectionFail:)
                                                     name:ADVehiclesModelrequestVehicleDetectionFailNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleGetVehicleConditionTimeOut:)
                                                     name:ADVehiclesModelGetConditionTimeOutNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleDetailResult1:)
                                                     name:ADDetailVehicleConditionResultNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    
    _ballImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 90, 90)];
//    _ballImgView.image=[UIImage imageNamed:@"blueball.png"];
    int i=[[[[_detailVehicleConditionResultArray objectAtIndex:6] properties] objectForKey:@"result"] intValue];
    if (i > 60) {
        _ballImgView.image=[UIImage imageNamed:@"blueball.png"];
    }else{
        _ballImgView.image=[UIImage imageNamed:@"redball.png"];
        
    }
    [self.view addSubview:_ballImgView];
    
    UILabel* lab1=[[UILabel alloc]initWithFrame:CGRectMake(115, 5, 150, 25)];
    lab1.text=@"您的爱车体检评分为";
    [lab1 setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    lab1.textColor=[UIColor whiteColor];
    lab1.textAlignment=NSTextAlignmentCenter;
    [lab1 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lab1];
    
    _pointLabel=[[UILabel alloc]initWithFrame:CGRectMake(265, 3, 36, 30)];
    _pointLabel.text=[[[_detailVehicleConditionResultArray objectAtIndex:6] properties] objectForKey:@"result"];
    [_pointLabel setFont:[UIFont systemFontOfSize:20.0]];
    _pointLabel.textColor=[UIColor colorWithRed:229.0/255.0 green:105.0/255.0 blue:0 alpha:1.0];
    _pointLabel.textAlignment=NSTextAlignmentCenter;
    [_pointLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_pointLabel];

    UILabel* lab2=[[UILabel alloc]initWithFrame:CGRectMake(115, 35, 150, 21)];
    lab2.text=@"定期体检，安全驾驶无隐患";
    lab2.font=[UIFont systemFontOfSize:12.0];
    lab2.backgroundColor=[UIColor clearColor];
    lab2.textColor=[UIColor whiteColor];
    lab2.textAlignment=NSTextAlignmentCenter;
    [self.view addSubview:lab2];
    
    _returnButton=[[UIButton alloc]initWithFrame:CGRectMake(115, 65, 60, 28)];
    [_returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_returnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_returnButton setTitle:@"返回" forState:UIControlStateNormal];
    [_returnButton setTitle:@"返回" forState:UIControlStateHighlighted];
    [_returnButton setBackgroundImage:[UIImage imageNamed:@"return.png"] forState:UIControlStateNormal];
    [_returnButton setBackgroundImage:[UIImage imageNamed:@"click.png"] forState:UIControlStateHighlighted];
    [_returnButton addTarget:self action:@selector(returnAction) forControlEvents:UIControlEventTouchUpInside];
    _returnButton.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [self.view addSubview:_returnButton];
    
    _restartButton=[[UIButton alloc]initWithFrame:CGRectMake(228, 65, 60, 28)];
    [_restartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_restartButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [_restartButton setTitle:@"重新体检" forState:UIControlStateNormal];
    [_restartButton setTitle:@"重新体检" forState:UIControlStateHighlighted];
    [_restartButton setBackgroundImage:[UIImage imageNamed:@"restartcheck.png"] forState:UIControlStateNormal];
//    [_restartButton setBackgroundImage:[UIImage imageNamed:@"click.png"] forState:UIControlStateHighlighted];
    [_restartButton addTarget:self action:@selector(restartCheckBtnAction) forControlEvents:UIControlEventTouchUpInside];
    _restartButton.titleLabel.font=[UIFont systemFontOfSize:13.0f];
    [self.view addSubview:_restartButton];
    
    
    UIImageView* line1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 105, WIDTH, 2)];
    line1.image=[UIImage imageNamed:@"xiline.png"];
    [self.view addSubview:line1];
    
    
    UIImageView* line2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 290, WIDTH, 2)];
    line2.image=[UIImage imageNamed:@"xiline.png"];
    [self.view addSubview:line2];
    
    UILabel* lab3=[[UILabel alloc]initWithFrame:CGRectMake(2, 295, 90, 25)];
    lab3.text=@"用车建议";
    lab3.textColor=[UIColor lightGrayColor];
    lab3.font=[UIFont systemFontOfSize:18.0];
    lab3.textAlignment=NSTextAlignmentLeft;
    lab3.backgroundColor=[UIColor clearColor];
    [self.view addSubview:lab3];
    
//    UIImageView* gthImgView=[[UIImageView alloc]initWithFrame:CGRectMake(5, 328, 20, 20)];
//    gthImgView.image=[UIImage imageNamed:@"bluegantanhao.png"];
//    [self.view addSubview:gthImgView];
    
//    _suggestTextView=[[UITextView alloc]initWithFrame:CGRectMake(30, 325, 285, 80)];
//    _suggestTextView.text=@"";
//    _suggestTextView.textColor=[UIColor whiteColor];
//    _suggestTextView.backgroundColor=[UIColor clearColor];
//    _suggestTextView.font=[UIFont systemFontOfSize:15.0f];
//    [self.view addSubview:_suggestTextView];
    
//    _suggestionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 390, 320, 80)];
//    _suggestionTableView.delegate = self;
//    _suggestionTableView.dataSource = self;
//    _suggestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    _suggestionTableView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_suggestionTableView];
    
    _arcImgView=[[UIImageView alloc]initWithFrame:CGRectMake(11, 11, 89, 89)];
    _arcImgView.image=[UIImage imageNamed:@"leida.png"];
    [self.view addSubview:_arcImgView];
    
    _ballPointLabel=[[UILabel alloc]initWithFrame:CGRectMake(17, 29, 90, 50)];
    _ballPointLabel.text=[[[_detailVehicleConditionResultArray objectAtIndex:6] properties] objectForKey:@"result"];
    _ballPointLabel.textAlignment = NSTextAlignmentCenter;
    _ballPointLabel.textColor=[UIColor whiteColor];
    _ballPointLabel.backgroundColor=[UIColor clearColor];
    [_ballPointLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
    [self.view addSubview:_ballPointLabel];
    
    
    
    _animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    _animation.toValue=[NSNumber numberWithFloat:degreesToRadians(12000)];
    _animation.duration=70.0f;
    _animation.cumulative=YES;
    _animation.repeatCount=0;
    
    [_arcImgView setHidden:YES];
    
    _myTimer1=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollTableView:) userInfo:nil repeats:YES];
    [_myTimer1 setFireDate:[NSDate distantFuture]];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_ballImgView setFrame:CGRectMake(10, 74, 90, 90)];
        [lab1 setFrame:CGRectMake(115, 69, 150, 25)];
        [_pointLabel setFrame:CGRectMake(265, 67, 36, 30)];
        [lab2 setFrame:CGRectMake(115, 99, 150, 21)];
        [_returnButton setFrame:CGRectMake(115, 129, 60, 28)];
        [_restartButton setFrame:CGRectMake(228, 129, 60, 28)];
        [line1 setFrame:CGRectMake(0, 169, WIDTH, 2)];
        [line2 setFrame:CGRectMake(0, 354, WIDTH, 2)];
        [lab3 setFrame:CGRectMake(2, 359, 90, 25)];
//        [gthImgView setFrame:CGRectMake(5, 392, 20, 20)];
//        [_suggestTextView setFrame:CGRectMake(30, 389, 285, 80)];
        [_arcImgView setFrame:CGRectMake(11, 75, 89, 89)];
        [_ballPointLabel setFrame:CGRectMake(17, 93, 70, 50)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_ballImgView setFrame:CGRectMake(10, 74, 90, 90)];
        [lab1 setFrame:CGRectMake(115, 69, 150, 25)];
        [_pointLabel setFrame:CGRectMake(265, 67, 36, 30)];
        [lab2 setFrame:CGRectMake(115, 99, 150, 21)];
        [_returnButton setFrame:CGRectMake(115, 129, 60, 28)];
        [_restartButton setFrame:CGRectMake(228, 129, 60, 28)];
        [line1 setFrame:CGRectMake(0, 169, WIDTH, 2)];
        [line2 setFrame:CGRectMake(0, 354, WIDTH, 2)];
        [lab3 setFrame:CGRectMake(2, 359, 90, 25)];
//        [gthImgView setFrame:CGRectMake(5, 392, 20, 20)];
//        [_suggestTextView setFrame:CGRectMake(30, 389, 285, 80)];
        [_arcImgView setFrame:CGRectMake(11, 75, 89, 89)];
        [_ballPointLabel setFrame:CGRectMake(17, 93, 70, 50)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
}

- (void)viewDidDisappear:(BOOL)animated
{
    [_myTimer1 invalidate];
    _myTimer1 = nil;
}

//Key-Value Observing (简写为KVO)：当指定的对象的属性被修改了，允许对象接受到通知的机制。每次指定的被观察对象的属性被修改的时候，KVO都会自动的去通知相应的观察者。
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VCEHICLE_DETECTION_PATH_NAME]) {
            NSDictionary *dic=_vehiclesModel.vehicleConditionCheck;
            NSString *timestamp = [dic objectForKey:@"now"];
            [_vehiclesModel requestVehicleDetectionIndeedWithArguments:[NSArray arrayWithObjects:
                                                                        timestamp,[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin, nil] continue:YES];
            
            return;
        }else if ([keyPath isEqualToString:KVO_VCEHICLE_DETECTION_INDEED_PATH_NAME]){
            _detailVehicleConditionResultArray=(NSArray*)_vehiclesModel.vehicleConditionCheckResult;
            
            if(_suggestionResultArray == nil){
                _suggestionResultArray = [[NSMutableArray alloc] init];
            }
            [_suggestionResultArray removeAllObjects];
            for (int i = 0; i < _detailVehicleConditionResultArray.count; i++) {
                if([[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"result"] isEqualToString:@"NG"]){
                    [_suggestionResultArray addObject:[_detailVehicleConditionResultArray objectAtIndex:i]];
                }
            }
            [self startShow];
            
            //            [_arcImgView setHidden:NO];
            //            [_arcImgView.layer addAnimation:_animation forKey:nil];
        }
        
    }
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark -handle Notification
-(void)handleDetailResult1:(NSNotification*)aNoti{
    _detailVehicleConditionResultArray=[aNoti object];
    _totalPoints=[[[_detailVehicleConditionResultArray objectAtIndex:([_detailVehicleConditionResultArray count]-1)] properties] objectForKey:@"result"];
    if ([_totalPoints isEqualToString:@""]) {
        _pointLabel.text=@"0";
        _ballPointLabel.text=@"0";
    }else{
        _pointLabel.text=_totalPoints;
        _ballPointLabel.text=_totalPoints;
    }
    if ([_totalPoints intValue]>60) {
        _ballImgView.image=[UIImage imageNamed:@"blueball.png"];
    }else{
        _ballImgView.image=[UIImage imageNamed:@"redball.png"];
        
    }

    if(_suggestionResultArray == nil){
        _suggestionResultArray = [[NSMutableArray alloc] init];
    }
//    [_suggestionResultArray removeAllObjects];
    for (int i = 0; i < _detailVehicleConditionResultArray.count; i++) {
        if([[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"result"] isEqualToString:@"NG"]){
            [_suggestionResultArray addObject:[_detailVehicleConditionResultArray objectAtIndex:i]];
        }
    }
    
    
    _detailVehicleConditionTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 108, WIDTH, 180) style:UITableViewStylePlain];
    [_detailVehicleConditionTableView setBackgroundColor:[UIColor clearColor]];
    _detailVehicleConditionTableView.delegate=self;
    _detailVehicleConditionTableView.dataSource=self;
    _detailVehicleConditionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_detailVehicleConditionTableView];
    
    _suggestionTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 390, WIDTH, 180)];
    _suggestionTableView.delegate = self;
    _suggestionTableView.dataSource = self;
    _suggestionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _suggestionTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_suggestionTableView];
    
    if (IOS7_OR_LATER) {
        [_detailVehicleConditionTableView setFrame:CGRectMake(0, 172, WIDTH, 180)];
        [self setExtraCellLineHidden:_detailVehicleConditionTableView];
    }else{
        CGRect frame = _suggestionTableView.frame;
        frame.origin.y -=65;
        _suggestionTableView.frame = frame;
    }
    //    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scrollTableView:) userInfo:nil repeats:YES];
    //    [_arcImgView setHidden:NO];
    //    [_arcImgView.layer addAnimation:_animation forKey:nil];
}


-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)requestVehicleDetectionFail:(NSNotification *)aNoti{
    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    [_vehiclesModel requestGetVehicleConditionCheckTimeOut:[NSArray arrayWithObjects:vin, nil]];
}

-(void)handleGetVehicleConditionTimeOut:(NSNotification *)aNoti{
    NSDictionary* dic=(NSDictionary*)[aNoti object];
    _detailVehicleConditionResultArray=[dic objectForKey:@"data"];
    if(_suggestionResultArray == nil){
        _suggestionResultArray = [[NSMutableArray alloc] init];
    }
    [_suggestionResultArray removeAllObjects];
    for (int i = 0; i < _detailVehicleConditionResultArray.count; i++) {
        if([[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"result"] isEqualToString:@"NG"]){
            [_suggestionResultArray addObject:[_detailVehicleConditionResultArray objectAtIndex:i]];
        }
    }
    [self startShow];
    
}

- (void)scrollTableView:(NSTimer *)timer{
    CGPoint newContentOffset=_detailVehicleConditionTableView.contentOffset;
    newContentOffset.y+=50;
    [_detailVehicleConditionTableView setContentOffset:newContentOffset];
    if (newContentOffset.y==50*([_detailVehicleConditionResultArray count]-3)) {
        [_myTimer1 setFireDate:[NSDate distantFuture]];
        //        [_detailVehicleConditionTableView setContentOffset:newContentOffset];
        [_arcImgView.layer removeAllAnimations];
        [_arcImgView setHidden:YES];
        _restartButton.userInteractionEnabled=YES;
        
        _totalPoints=[[[_detailVehicleConditionResultArray objectAtIndex:([_detailVehicleConditionResultArray count]-1)] properties] objectForKey:@"result"];
        if ([_totalPoints isEqualToString:@""]) {
            _pointLabel.text=@"0";
            _ballPointLabel.text=@"0";
        }else{
            _pointLabel.text=_totalPoints;
            _ballPointLabel.text=_totalPoints;
        }
        if ([_totalPoints intValue]>60) {
            _ballImgView.image=[UIImage imageNamed:@"blueball.png"];
        }else{
            _ballImgView.image=[UIImage imageNamed:@"redball.png"];
            
        }
        
        if(_suggestionResultArray == nil){
            _suggestionResultArray = [[NSMutableArray alloc] init];
        }
        [_suggestionResultArray removeAllObjects];
        for (int i = 0; i < _detailVehicleConditionResultArray.count; i++) {
            if([[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"result"] isEqualToString:@"NG"]){
                [_suggestionResultArray addObject:[_detailVehicleConditionResultArray objectAtIndex:i]];
            }
        }
    }
}

#pragma mark -TableView setUp
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == _detailVehicleConditionTableView){
        return [_detailVehicleConditionResultArray count];
    }else{
        
        if(_suggestionResultArray.count == 0){
            return 1;
        }
        if(_suggestionResultArray.count == 1){
            if([[[_suggestionResultArray objectAtIndex:0] objectForKey:@"factorName"] isEqualToString:@"dictNil"]){
                [_suggestionResultArray removeAllObjects];
                return 0;
            }
        }
        return [_suggestionResultArray count];
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == _detailVehicleConditionTableView){
        static NSString *cellIdentifier=@"ADDetailVehicleConditionCell";
        ADDetailVehicleConditionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if(cell==nil)
        {
            NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"ADDetailVehicleConditionCell" owner:self options:nil];
            cell=(ADDetailVehicleConditionCell*)[xib objectAtIndex:0];
        
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
        NSString* factorName=[[[_detailVehicleConditionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"factorName"];
    
        if (indexPath.row==([_detailVehicleConditionResultArray count]-1)) {
            _totalPoints=[[[_detailVehicleConditionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"value"];
            NSInteger i=[_totalPoints integerValue];
            if (i>60) {
                cell.iconImgView.image=[UIImage imageNamed:@"greengou.png"];
            }else{
                cell.iconImgView.image=[UIImage imageNamed:@"redgantanhao.png"];
            }
//        cell.detailLabel.text=[NSString stringWithFormat:@" %@ %@",factorName,_totalPoints];
            NSString *factor = @"";
            if([factorName isEqualToString:@"DTC_1"]){
                factor = @"DTC 动力系统";
            }else if([factorName isEqualToString:@"DTC_2"]){
                factor = @"DTC 底盘系统";
            }else if([factorName isEqualToString:@"DTC_3"]){
                factor = @"DTC 车身系统";
            }else if([factorName isEqualToString:@"DTC_4"]){
                factor = @"DTC 信号系统";
            }else if([factorName isEqualToString:@"batt level"]){
                factor = @"电池电压";
            }else if([factorName isEqualToString:@"Maintenance"]){
                factor = @"维修保养";
            }else{
                factor = @"体检指标";
            }
            cell.detailLabel.text=[NSString stringWithFormat:@" %@ %@",factor,_totalPoints];
        
        }else{
            NSString* result=[[[_detailVehicleConditionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"result"];
            if ([result isEqualToString:@"OK"]){
                cell.iconImgView.image=[UIImage imageNamed:@"greengou.png"];
            }else{
                cell.iconImgView.image=[UIImage imageNamed:@"redgantanhao.png"];
            }
//        cell.detailLabel.text=[NSString stringWithFormat:@" %@ %@",factorName,result];
            NSString *factor = @"";
            if([factorName isEqualToString:@"DTC_1"]){
                factor = @"DTC 动力系统";
            }else if([factorName isEqualToString:@"DTC_2"]){
                factor = @"DTC 底盘系统";
            }else if([factorName isEqualToString:@"DTC_3"]){
                factor = @"DTC 车身系统";
            }else if([factorName isEqualToString:@"DTC_4"]){
                factor = @"DTC 信号系统";
            }else if([factorName isEqualToString:@"batt level"]){
                factor = @"电池电压";
            }else if([factorName isEqualToString:@"Maintenance"]){
                factor = @"维修保养";
            }else{
                factor = @"体检指标";
            }
            if([result isEqualToString:@"NG"]){
                result = @"不正常";
            }else if([result isEqualToString:@"TIMEOUT"]){
                result = @"超时";
            }
            cell.detailLabel.text=[NSString stringWithFormat:@" %@ %@",factor,result];
        }
        [cell setBackgroundColor:[UIColor clearColor]];
        return  cell;
    }else{
        static NSString *indentifier = @"UITableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *goodlabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, WIDTH, 40)];
        if(_suggestionResultArray.count == 0){
            goodlabel.backgroundColor = [UIColor clearColor];
            goodlabel.textColor = [UIColor whiteColor];
            goodlabel.font = [UIFont systemFontOfSize:13.0f];
            goodlabel.text = @"您的爱车很健康，请持续关注您的爱车体检。";
            goodlabel.numberOfLines = 3;
            goodlabel.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
            [cell addSubview:goodlabel];
            cell.backgroundColor = [UIColor clearColor];
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
            return cell;
        }else{
            [goodlabel removeFromSuperview];
        }
        NSString* factorName=[[[_suggestionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"factorName"];
        NSString *factor = @"";
        NSString *value = [[[_suggestionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"value"];
        
        if([factorName isEqualToString:@"DTC_1"]){
            factor = @"DTC 动力系统";
        }else if([factorName isEqualToString:@"DTC_2"]){
            factor = @"DTC 底盘系统";
        }else if([factorName isEqualToString:@"DTC_3"]){
            factor = @"DTC 车身系统";
        }else if([factorName isEqualToString:@"DTC_4"]){
            factor = @"DTC 信号系统";
        }
        if(value.length == 0 || [value isEqualToString:@"0"]){
            cell.textLabel.text = [NSString stringWithFormat:@"%@故障，请尽快到4S维修。", factor];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)故障，请尽快到4S维修。", factor,value];
        }
        if([factorName isEqualToString:@"batt level"]){
            factor = @"电池电压";
            cell.textLabel.text = [NSString stringWithFormat:@"近3天电瓶电压出现%@次异常", value];
        }else if([factorName isEqualToString:@"Maintenance"]){
            factor = @"维修保养";
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 100)];
            label.backgroundColor = [UIColor clearColor];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:13.0f];
            label.text = @"您的爱车距离上次保养已超过5000公里，建议及时做常规保养，以免机油失效造成对发动机损害，若您已经保养，请点击添加保养记录";
            label.numberOfLines = 3;
            label.lineBreakMode = UILineBreakModeWordWrap|UILineBreakModeTailTruncation;
            [cell addSubview:label];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.0f];
        return cell;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == _detailVehicleConditionTableView){
        return 50;
    }else{
        if(_suggestionResultArray.count == 0){
            return 40;
        }
        if([[[[_suggestionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"factorName"] isEqualToString:@"Maintenance"]){
            return 60;
        }
        return 30;
    }
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == _suggestionTableView){
        if(_suggestionResultArray.count != 0){
            if([[[[_suggestionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"factorName"] isEqualToString:@"Maintenance"]){
                [ADSingletonUtil sharedInstance].selectMenuIndex=5;
                [self navigateToViewControllerByClassName:@"ADiPhoneHealthyViewController"];
            }
        }
    }
}

- (void)navigateToViewControllerByClassName:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] initWithNibName:nil bundle:nil];
    ADNavigationController *navigationController = [ADNavigationController navigationControllerWithRootViewController:viewController];
    CGRect frame = self.slidingController.topViewController.view.frame;
    self.slidingController.topViewController = navigationController;
    self.slidingController.topViewController.view.frame = frame;
    [self.slidingController resetTopView];
    
}

-(void)returnAction{
    [_myTimer1 invalidate];
    _myTimer1 = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)restartCheckBtnAction{
    _restartButton.userInteractionEnabled=NO;
    _detailVehicleConditionResultArray=nil;
    [_detailVehicleConditionTableView reloadData];
    
    [_suggestionResultArray removeAllObjects];
    NSDictionary *dict = @{@"factorName": @"dictNil"};
    [_suggestionResultArray addObject:dict];
    [_suggestionTableView reloadData];
//    _suggestTextView.text=@"";
    _pointLabel.text=@"";
    _ballPointLabel.text=@"";
    CGPoint newContentOffset=_detailVehicleConditionTableView.contentOffset;
    //    if (newContentOffset.y==50*([_detailVehicleConditionResultArray count]-3)) {
    newContentOffset.y=0;
    [_detailVehicleConditionTableView setContentOffset:newContentOffset];
    //    }
    [_arcImgView setHidden:NO];
    [_arcImgView.layer addAnimation:_animation forKey:nil];
    [_vehiclesModel requestVehicleDetectionInfoWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];
}

-(void)startShow{
    
    [_suggestionTableView reloadData];
    [_detailVehicleConditionTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDetailVehicleConditionToCarNotification object:nil];
    [_myTimer1 setFireDate:[NSDate distantPast]];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
