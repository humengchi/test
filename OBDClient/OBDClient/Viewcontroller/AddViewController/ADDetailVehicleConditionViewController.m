//
//  ADDetailVehicleConditionViewController.m
//  OBDClient
//
//  Created by hys on 27/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDetailVehicleConditionViewController.h"

//NSString * const ADDetailVehicleConditionToCarNotification =@"ADDetailVehicleConditionToCarNotification";

@interface ADDetailVehicleConditionViewController ()

@end

@implementation ADDetailVehicleConditionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _vehiclesModel=[[ADVehiclesModel alloc]init];
        
//        [self addObserver:self
//               forKeyPath:@"detailVehicleConditionResultArray"
//                  options:NSKeyValueObservingOptionNew
//                  context:nil];

        
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
                                                 selector:@selector(handleDetailResult:)
                                                     name:ADDetailVehicleConditionResultNotification object:nil];

        


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    
//    UIImageView* onelineImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 120, WIDTH, 2)];
//    onelineImgView.image=[UIImage imageNamed:@"xiline.png"];
//    [self.view addSubview:onelineImgView];
    
    UILabel* lab=[[UILabel alloc]initWithFrame:CGRectMake(5, 130, 120, 20)];
    lab.textColor=[UIColor lightGrayColor];
    lab.text=NSLocalizedStringFromTable(@"checkResultKey",@"MyString", @"");
    lab.font=[UIFont systemFontOfSize:18];
    [lab setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:lab];
    
    _animation=[CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    _animation.toValue=[NSNumber numberWithFloat:degreesToRadians(12000)];
    _animation.duration=70.0f;
    _animation.cumulative=YES;
    _animation.repeatCount=0;
    
    [_arcImgView setHidden:YES];
    
    _myTimer=[NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(scrollTableView:) userInfo:nil repeats:YES];
    [_myTimer setFireDate:[NSDate distantFuture]];
//
//    [_vehiclesModel requestVehicleDetectionInfoWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin]];   //返回一个heartbeat_interval timestamp of now
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
            _detailVehicleConditionResultArray=_vehiclesModel.vehicleConditionCheckResult;
            [self startShow];
           
//            [_arcImgView setHidden:NO];
//            [_arcImgView.layer addAnimation:_animation forKey:nil];
        }
        
    }
//    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


#pragma mark -handle Notification
-(void)handleDetailResult:(NSNotification*)aNoti{
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

    for (int i=0; i<[_detailVehicleConditionResultArray count]; i++) {
        NSString* factorName=[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"factorName"];
        NSString* result=[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"result"];
        if (i==[_detailVehicleConditionResultArray count]-1) {
            _suggestTextView.text=[_suggestTextView.text stringByAppendingString:[NSString stringWithFormat:@" %@ is %@ .",factorName,result]];
        }else{
            _suggestTextView.text=[_suggestTextView.text stringByAppendingString:[NSString stringWithFormat:@" %@ is %@ , ",factorName,result]];
        }
    }

    
    _detailVehicleConditionTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 157, WIDTH, 150) style:UITableViewStylePlain];
    [_detailVehicleConditionTableView setBackgroundColor:[UIColor clearColor]];
    _detailVehicleConditionTableView.delegate=self;
    _detailVehicleConditionTableView.dataSource=self;
    _detailVehicleConditionTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_detailVehicleConditionTableView];
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(scrollTableView:) userInfo:nil repeats:YES];
//    [_arcImgView setHidden:NO];
//    [_arcImgView.layer addAnimation:_animation forKey:nil];    
}


- (void)requestVehicleDetectionFail:(NSNotification *)aNoti{
    NSString* vin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    [_vehiclesModel requestGetVehicleConditionCheckTimeOut:[NSArray arrayWithObjects:vin, nil]];
}

-(void)handleGetVehicleConditionTimeOut:(NSNotification *)aNoti{
    NSDictionary* dic=(NSDictionary*)[aNoti object];
    _detailVehicleConditionResultArray=[dic objectForKey:@"data"];
    [self startShow];
    
}

- (void)scrollTableView:(NSTimer *)timer{
    CGPoint newContentOffset=_detailVehicleConditionTableView.contentOffset;
    newContentOffset.y+=50;
    [_detailVehicleConditionTableView setContentOffset:newContentOffset];
    if (newContentOffset.y==50*([_detailVehicleConditionResultArray count]-3)) {
        [_myTimer setFireDate:[NSDate distantFuture]];
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
        
        for (int i=0; i<[_detailVehicleConditionResultArray count]; i++) {
            NSString* factorName=[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"factorName"];
            NSString* result=[[[_detailVehicleConditionResultArray objectAtIndex:i] properties] objectForKey:@"result"];
            if (i==[_detailVehicleConditionResultArray count]-1) {
                _suggestTextView.text=[_suggestTextView.text stringByAppendingString:[NSString stringWithFormat:@" %@ is %@ .",factorName,result]];
            }else{
                _suggestTextView.text=[_suggestTextView.text stringByAppendingString:[NSString stringWithFormat:@" %@ is %@ , ",factorName,result]];
            }
        }

    }
    
    
}

#pragma mark -TableView setUp
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_detailVehicleConditionResultArray count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
        cell.detailLabel.text=[NSString stringWithFormat:@" %@ %@",factorName,_totalPoints];

    }else{
         NSString* result=[[[_detailVehicleConditionResultArray objectAtIndex:indexPath.row] properties] objectForKey:@"result"];
        if ([result isEqualToString:@"OK"]){
            cell.iconImgView.image=[UIImage imageNamed:@"greengou.png"];
        }else{
            cell.iconImgView.image=[UIImage imageNamed:@"redgantanhao.png"];
        }
        cell.detailLabel.text=[NSString stringWithFormat:@" %@ %@",factorName,result];
    }
    return  cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return 50;
}
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)viewDidUnload {
    [self setBallImgView:nil];
    [self setArcImgView:nil];
    [self setRestartButton:nil];
    [self setPointLabel:nil];
    [self setBallPointLabel:nil];
    [self setSuggestTextView:nil];
    [super viewDidUnload];
}
#pragma mark -Button Action
- (IBAction)returnBtnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)restartCheckBtnAction:(id)sender {
    
    _restartButton.userInteractionEnabled=NO;
    _detailVehicleConditionResultArray=nil;
    [_detailVehicleConditionTableView reloadData];
    _suggestTextView.text=@"";
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
    
    [_detailVehicleConditionTableView reloadData];
    [[NSNotificationCenter defaultCenter] postNotificationName:ADDetailVehicleConditionToCarNotification object:nil];
    [_myTimer setFireDate:[NSDate distantPast]];
    
}
@end
