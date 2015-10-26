//
//  ADVehiclePidInfoViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-11.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehiclePidInfoViewController.h"
#import "ADPIDModel.h"
@interface ADVehiclePidInfoViewController ()
@property (nonatomic) ADPIDModel *pidModel;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADVehiclePidInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _pidModel = [[ADPIDModel alloc]init];
        [_pidModel addObserver:self
                         forKeyPath:KVO_CURRENT_PID_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(getDevicePidListFail:)
                           name:ADPIDModelRequestCurrentPIDFailNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(getDevicePidListSuccess:)
                           name:ADPIDModelRequestCurrentPIDSuccessNotification
                         object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADPIDModelLoginTimeOutNotification
                                                   object:nil];
        
        
    }
    return self;
}

- (void)dealloc{
    [_pidModel removeObserver:self
                        forKeyPath:KVO_CURRENT_PID_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADPIDModelRequestCurrentPIDFailNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADPIDModelRequestCurrentPIDSuccessNotification
                        object:nil];
    [_pidModel cancel];
}

- (void)getDevicePidListFail:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:[[ADSingletonUtil sharedInstance] errorStringByResultCode:[aNoti.userInfo objectForKey:@"resultCode"]]];
}

- (void)getDevicePidListSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
}


- (void)viewWillAppear:(BOOL)animated{
    self.title=NSLocalizedStringFromTable(@"OBDParametersKey",@"MyString", @"");;
    self.navigationItem.leftBarButtonItem=nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    if (IOS7_OR_LATER) {
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
		[self setExtraCellLineHidden:_tableView];
    }
    
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_pidModel requestPIDWithDeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID isContinue:NO];
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark - Table view data source
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
    return _pidModel.pids.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"ADVehiclePidInfoCell";
    ADVehiclePidInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"ADVehiclePidInfoCell" owner:self options:nil];
        cell=(ADVehiclePidInfoCell*)[xib objectAtIndex:0];
        
    }
        if (indexPath.row==0) {
        cell.pidLabel.text=@"支持的PID";
        cell.contentLabel.text=@"参数内容";
        cell.minLabel.text=@"最小值";
        cell.maxLabel.text=@"最大值";
        cell.unitLabel.text=@"单位";
        
    }else{
        NSDictionary *pid=_pidModel.pids[indexPath.row-1];
        cell.pidLabel.text=[pid objectForKey:@"pidCode"];
        cell.contentLabel.text=[pid objectForKey:@"pidContent"];
        cell.minLabel.text=[pid objectForKey:@"pidValueMin"];
        cell.maxLabel.text=[pid objectForKey:@"pidValueMax"];
        cell.unitLabel.text=[pid objectForKey:@"pidUnit"];
    }
    
    UIFont* front14=[UIFont systemFontOfSize:14.0f];
    CGFloat height;
    CGSize size=[cell.contentLabel.text sizeWithFont:front14 constrainedToSize:CGSizeMake(155, 999)];
    height=size.height;
    CGRect frame=cell.frame;
    if (height>51) {
        frame.size.height=height;
    }else{
        frame.size.height=51;
    }
    [cell setFrame:frame];
    
    CGRect labelFrame=cell.pidLabel.frame;
    labelFrame.size.height=frame.size.height-1;
    [cell.pidLabel setFrame:labelFrame];
    
    labelFrame=cell.contentLabel.frame;
    labelFrame.size.height=frame.size.height-1;
    [cell.contentLabel setFrame:labelFrame];
    
    labelFrame=cell.minLabel.frame;
    labelFrame.size.height=frame.size.height-1;
    [cell.minLabel setFrame:labelFrame];
    
    labelFrame=cell.maxLabel.frame;
    labelFrame.size.height=frame.size.height-1;
    [cell.maxLabel setFrame:labelFrame];
    
    labelFrame=cell.unitLabel.frame;
    labelFrame.size.height=frame.size.height-1;
    [cell.unitLabel setFrame:labelFrame];
    
    CGRect bottomIVFrame=cell.bottomImgView.frame;
    bottomIVFrame.origin.y=frame.size.height-1;
    [cell.bottomImgView setFrame:bottomIVFrame];
    
    CGRect ImgViewFrame=cell.onelineImgView.frame;
    ImgViewFrame.size.height=frame.size.height;
    [cell.onelineImgView setFrame:ImgViewFrame];
    
    ImgViewFrame=cell.twolineImgView.frame;
    ImgViewFrame.size.height=frame.size.height;
    [cell.twolineImgView setFrame:ImgViewFrame];
    
    ImgViewFrame=cell.threelineImgView.frame;
    ImgViewFrame.size.height=frame.size.height;
    [cell.threelineImgView setFrame:ImgViewFrame];

    
    ImgViewFrame=cell.fourlineImgView.frame;
    ImgViewFrame.size.height=frame.size.height;
    [cell.fourlineImgView setFrame:ImgViewFrame];

    cell.backgroundColor=[UIColor clearColor];
//    [cell.contentLabel sizeToFit];
    
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString* heightStr=[_heightArray objectAtIndex:indexPath.row];
//    CGFloat height=[heightStr floatValue];
    UITableViewCell* cell=[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _pidModel) {
        if ([keyPath isEqualToString:KVO_CURRENT_PID_PATH_NAME]) {
            if(_pidModel.pids.count==0){
                [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
            }else{
                [_tableView reloadData];
                _heightArray=[NSMutableArray arrayWithCapacity:[_pidModel.pids count]];
            }
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
