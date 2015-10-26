//
//  ADMoreInfoViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-29.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMoreInfoViewController.h"

@interface ADMoreInfoViewController ()

@end

@implementation ADMoreInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _vehiclesModel=[[ADVehiclesModel alloc]init];
        
        _pidModel=[[ADPIDModel alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleVehicleStatusDeatail:) name:ADVehiclesModelGetStatusDeatailNotification object:nil];
        
        [_pidModel addObserver:self
                    forKeyPath:KVO_CURRENT_PID_PATH_NAME
                       options:NSKeyValueObservingOptionNew
                       context:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(LoginTimeOut)
                                                     name:ADPIDModelLoginTimeOutNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [_pidModel removeObserver:self forKeyPath:KVO_CURRENT_PID_PATH_NAME];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"detailedInformationKey",@"MyString", @"");
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    
    
    _vehicleStatusTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _vehicleStatusTableView.delegate=self;
    _vehicleStatusTableView.dataSource=self;
    _vehicleStatusTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
    [_vehicleStatusTableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_vehicleStatusTableView];

    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_vehicleStatusTableView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_vehicleStatusTableView setFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_vehicleStatusTableView setFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64)];
	}


    
    NSString* dvin=[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin;
    [_vehiclesModel requestGetVehicleStatusDeatail:[NSArray arrayWithObjects:dvin, nil]];
    
    [_pidModel requestPIDWithDeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID isContinue:NO];

}

-(void)handleVehicleStatusDeatail:(NSNotification *)aNoti{
    NSDictionary* statusdic=[aNoti object];
    _statusDeatailArray=[statusdic objectForKey:@"data"];
//    for (ASObject* obj in _statusDeatailArray) {
//        NSDictionary* dic=[obj properties];
//        NSLog(@"%@,%@",[dic objectForKey:@"pidContent"],[dic objectForKey:@"value"]);
//    }
//    [_vehicleStatusTableView reloadData];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _pidModel) {
        if ([keyPath isEqualToString:KVO_CURRENT_PID_PATH_NAME]) {
            if(_pidModel.pids.count==0){
                [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
            }else{
                _obdArray=[[NSMutableArray alloc]init];
                _obdArray=[NSMutableArray arrayWithArray:_pidModel.pids];
                [_obdArray removeObjectAtIndex:3];
                [_obdArray removeObjectAtIndex:3];
                [_vehicleStatusTableView reloadData];
            }
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -setup tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1+[_statusDeatailArray count]+[_obdArray count];
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier=@"ADMoreInfoCell";
    ADMoreInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell==nil)
    {
        NSArray*xib=[[NSBundle mainBundle] loadNibNamed:@"ADMoreInfoCell" owner:self options:nil];
        cell=(ADMoreInfoCell*)[xib objectAtIndex:0];
        
    }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    if (indexPath.row==0) {
        cell.keyLabel.text=NSLocalizedStringFromTable(@"dataItemKey",@"MyString", @"");
        cell.valueLabel.text=NSLocalizedStringFromTable(@"currentValueKey",@"MyString", @"");
        cell.referenceLabel.text=NSLocalizedStringFromTable(@"referenceKey",@"MyString", @"");
    }else if (indexPath.row<9){
        NSDictionary* dic=[[_statusDeatailArray objectAtIndex:indexPath.row-1] properties];
        cell.keyLabel.text=NSLocalizedStringFromTable([dic objectForKey:@"pidContent"],@"MyString", @"");
//        cell.keyLabel.text=[dic objectForKey:@"pidContent"];
        NSString* value=[dic objectForKey:@"value"];
        if ([value isEqual:[NSNull null]]||[value isEqual:@""]) {
            cell.valueLabel.text=@"-";
        }else{
            cell.valueLabel.text=[dic objectForKey:@"value"];
        }
        if (indexPath.row==3) {
            cell.referenceLabel.text=@"-";
        }else{
            cell.referenceLabel.text=[NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"pidValueMin"],[dic objectForKey:@"pidValueMax"]];
        }
    }else{
        NSLog(@"%d",indexPath.row);
        NSDictionary* dic=[_obdArray objectAtIndex:indexPath.row-9];
        cell.keyLabel.text=[dic objectForKey:@"pidContent"];
        cell.valueLabel.text=@"-";
        cell.referenceLabel.text=[NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"pidValueMin"],[dic objectForKey:@"pidValueMax"]];
    }
    
    UIFont* front17=[UIFont systemFontOfSize:17.0f];
    CGFloat height;
    CGSize size=[cell.keyLabel.text sizeWithFont:front17 constrainedToSize:CGSizeMake(155, 999)];
    height=size.height;
    
    CGRect frame=cell.frame;
    if (height>44) {
        frame.size.height=height;
    }else{
        frame.size.height=44;
    }
    height=frame.size.height;
    [cell setFrame:frame];
    
    CGRect labelFrame=cell.keyLabel.frame;
    labelFrame.size.height=frame.size.height;
    [cell.keyLabel setFrame:labelFrame];

    labelFrame=cell.valueLabel.frame;
    labelFrame.size.height=frame.size.height;
    [cell.valueLabel setFrame:labelFrame];

    labelFrame=cell.referenceLabel.frame;
    labelFrame.size.height=frame.size.height;
    [cell.referenceLabel setFrame:labelFrame];

    
    CGRect ImgFrame;
    ImgFrame=cell.oneImgView.frame;
    ImgFrame.size.height=height;
    [cell.oneImgView setFrame:ImgFrame];

    ImgFrame=cell.twoImgView.frame;
    ImgFrame.size.height=height;
    [cell.twoImgView setFrame:ImgFrame];
    
    ImgFrame=cell.bottomImgView.frame;
    ImgFrame.origin.y=height-1;
    [cell.bottomImgView setFrame:ImgFrame];
    
//    UIImageView* bottomImgView=[[UIImageView alloc]initWithFrame:CGRectMake(0, height-1, WIDTH, 2)];
//    bottomImgView.image=[UIImage imageNamed:@"xiline.png"];
//    [cell addSubview:bottomImgView];
    [cell setBackgroundColor:[UIColor clearColor]];
    return cell;

}



-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell=[self tableView:_vehicleStatusTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)LoginTimeOut{
    UIViewController* login=[[ADiPhoneLoginViewController alloc]initWithNibName:nil bundle:nil];
    [self.view.window setRootViewController:login];
}

@end
