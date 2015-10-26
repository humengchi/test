//
//  ADMaintainAddViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-16.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMaintainAddViewController.h"

@interface ADMaintainAddViewController ()
@property (nonatomic) NSArray *itemData;
@property (nonatomic) NSMutableArray *itemDataEXP;
@property (nonatomic) NSMutableArray *itemDataNOEXP;
@property (nonatomic) NSMutableArray *itemSubmit;

@end

@implementation ADMaintainAddViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _maintainModel=[[ADMaintainModel alloc]init];
        [_maintainModel addObserver:self
                         forKeyPath:KVO_MAINTAIN_ITEMS_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(setItemsSuccess:)
                           name:ADMaintainModelSetItemsSuccessNotification
                         object:nil];
    }
    return self;
}

- (void)dealloc
{
    [_maintainModel removeObserver:self forKeyPath:KVO_MAINTAIN_ITEMS_PATH_NAME];
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADMaintainModelSetItemsSuccessNotification
                        object:nil];
    [_maintainModel cancel];
}

- (void)setItemsSuccess:(NSNotification *)aNoti
{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    [self.delegate editContactViewController:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _itemSubmit= [[NSMutableArray alloc]init];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"saveKey",@"MyString", @"") style:UIBarButtonItemStyleDone     target:self action:@selector(saveTap:)];
    self.navigationItem.rightBarButtonItem=barButton;
    if (IOS7_OR_LATER) {
        barButton.tintColor=[UIColor lightGrayColor];
    }
    // 获取系统当前时间
    NSDate * date = [NSDate date];
    _currentDate = date;
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString * na = [df stringFromDate:currentDate];
    self.dateTextField.text=na;
    
    self.mileageTextField.text = [ADSingletonUtil sharedInstance].currentDeviceBase.TotalMilage;
    
    self.navigationItem.leftBarButtonItem=nil;
    self.title=NSLocalizedStringFromTable(@"ThenewmaintenanceKey",@"MyString", @"");
    
    CGRect rectLine = CGRectMake(0, 100, WIDTH, 1);
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:rectLine];
    lineLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    
    [self.view addSubview:lineLabel];
    
//    self.view.backgroundColor=[UIColor whiteColor];
    _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 101, self.view.bounds.size.width, self.view.bounds.size.height-101) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource = self;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorColor = [UIColor clearColor];

    [self.view addSubview:_tableView];
    
    //指定本身为代理
    self.dateTextField.delegate = self;
    self.mileageTextField.delegate = self;
    
    //注册键盘响应事件方法
    [self.dateTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.mileageTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
//    gesture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:gesture];
    
    
    [_maintainModel requestVehicleMaintainItemsWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin ]];
    
    _maintainTimeLable.text=NSLocalizedStringFromTable(@"maintainTimeKey",@"MyString", @"");
    
    _maintainMileageLabel.text=NSLocalizedStringFromTable(@"maintainMileageKey",@"MyString", @"");
    
    _kmLabel.text=NSLocalizedStringFromTable(@"kmKey",@"MyString", @"");
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_maintainTimeLable.frame;
        frame.origin.y+=64;
        [_maintainTimeLable setFrame:frame];
        
        frame=_dateTextField.frame;
        frame.origin.y+=64;
        [_dateTextField setFrame:frame];
        
        frame=_maintainMileageLabel.frame;
        frame.origin.y+=64;
        [_maintainMileageLabel setFrame:frame];
        
        frame=_mileageTextField.frame;
        frame.origin.y+=64;
        [_mileageTextField setFrame:frame];
        
        frame=_kmLabel.frame;
        frame.origin.y+=64;
        [_kmLabel setFrame:frame];
        
        frame=lineLabel.frame;
        frame.origin.y+=64;
        [lineLabel setFrame:frame];
        
        [_tableView setFrame:CGRectMake(0, 165, WIDTH, 379)];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_tableView setFrame:CGRectMake(0, 101, WIDTH, 467)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_maintainTimeLable.frame;
        frame.origin.y+=64;
        [_maintainTimeLable setFrame:frame];
        
        frame=_dateTextField.frame;
        frame.origin.y+=64;
        [_dateTextField setFrame:frame];
        
        frame=_maintainMileageLabel.frame;
        frame.origin.y+=64;
        [_maintainMileageLabel setFrame:frame];
        
        frame=_mileageTextField.frame;
        frame.origin.y+=64;
        [_mileageTextField setFrame:frame];
        
        frame=_kmLabel.frame;
        frame.origin.y+=64;
        [_kmLabel setFrame:frame];
        
        frame=lineLabel.frame;
        frame.origin.y+=64;
        [lineLabel setFrame:frame];
        
        [_tableView setFrame:CGRectMake(0, 165, WIDTH, 467)];
	}
    _dateView=[[UIView alloc]initWithFrame:CGRectMake(0, 70, WIDTH, 270)];
    [_dateView setBackgroundColor:[UIColor colorWithRed:58.0/255.0 green:58.0/255.0 blue:58.0/255.0 alpha:1.0]];
    [_dateView setHidden:YES];
    [self.view addSubview:_dateView];
    
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 150)];
    _datePicker.datePickerMode=UIDatePickerModeDate;
    [_dateView addSubview:_datePicker];
    
    UIButton* okBtn=[[UIButton alloc]initWithFrame:CGRectMake(60, 225, 70, 40)];
    [okBtn setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(sureBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_dateView addSubview:okBtn];
    
    UIButton* cancleBtn=[[UIButton alloc]initWithFrame:CGRectMake(190, 225, 70, 40)];
    [cancleBtn setBackgroundColor:[UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1.0]];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_dateView addSubview:cancleBtn];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//====================选择时间======================
- (void)showDateView{
    [_mileageTextField resignFirstResponder];
    [_dateView setHidden:NO];
    [_datePicker setDate:_currentDate];
}

- (void)cancleBtn:(id)sender{
    [_dateView setHidden:YES];
}

- (void)sureBtn:(id)sender{
    [_dateView setHidden:YES];
    _currentDate=[_datePicker date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMdd"];
    if([[formatter stringFromDate:[NSDate date]]integerValue]>=[[formatter stringFromDate:_currentDate]integerValue]){
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _dateTextField.text=[formatter stringFromDate:_currentDate];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
        _dateTextField.text=[formatter stringFromDate:[NSDate date]];
    }
    
}

//====================选择时间======================

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField == _dateTextField){
        [_dateTextField resignFirstResponder];
        [self showDateView];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *headerView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    headerView.backgroundColor = [UIColor darkGrayColor];
    headerView.alpha=0.75;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 5, 20, 9.5);
    [button setBackgroundImage:[UIImage imageNamed:@"vehicle_list_header.png"] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor clearColor];
    [headerView addSubview:button];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.view.bounds.size.width-20, 20)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [headerView addSubview:label];
    
    if(section == 0){
        label.text = NSLocalizedStringFromTable(@"GeneralprojectKey",@"MyString", @"");
    }else if (section==1){
        label.text = NSLocalizedStringFromTable(@"MoreprojectKey",@"MyString", @"");
    }
    
    return headerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headTitle=@"";
    if (section==0) {
        headTitle=NSLocalizedStringFromTable(@"GeneralprojectKey",@"MyString", @"");
        
    }else if (section==1){
        headTitle=NSLocalizedStringFromTable(@"MoreprojectKey",@"MyString", @"");
    }
    
    return headTitle;
}

// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

//每个区里有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0){
        if(_itemDataEXP.count==0){
            return 1;
        }else{
            return _itemDataEXP.count;
        }
    }else if (section==1){
        if(_itemDataNOEXP.count==0){
            return 1;
        }else{
            return _itemDataNOEXP.count;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }

    
    
    
    if (indexPath.section==0) {
        if(_itemDataEXP.count==0){
            cell.textLabel.text =NSLocalizedStringFromTable(@"NomaintenanceprojectKey",@"MyString", @"");
        }else{
            NSMutableDictionary *dataExp=_itemDataEXP[indexPath.row];
            cell.detailTextLabel.text=@"";
            cell.textLabel.text = [dataExp objectForKey:@"Name"];
            if([[dataExp objectForKey:@"selected"] isEqual:@"YES"]){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            
        }
        
    }else if (indexPath.section==1){
        if(_itemDataNOEXP.count==0){
            cell.textLabel.text =NSLocalizedStringFromTable(@"NomaintenanceprojectKey",@"MyString", @"");
        }else{
            NSMutableDictionary *dataNoExp=_itemDataNOEXP[indexPath.row];
            cell.detailTextLabel.text=@"";
            cell.textLabel.text = [dataNoExp objectForKey:@"Name"];
            if([[dataNoExp objectForKey:@"selected"] isEqual:@"YES"]){
                cell.accessoryType=UITableViewCellAccessoryCheckmark;
            }else{
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
        }
        
    }
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,40, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    cell.textLabel.textColor=[UIColor whiteColor];
    cell.backgroundColor=[UIColor clearColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0&&_itemDataEXP.count>0){
        NSString *selected=[_itemDataEXP[indexPath.row] objectForKey:@"selected"];
        if([selected isEqual:@"NO"]){
            [_itemDataEXP[indexPath.row] setObject:@"YES" forKey:@"selected"];
            [_itemSubmit addObject:[_itemDataEXP[indexPath.row] objectForKey:@"ItemID" ]];

        }else{
            [_itemDataEXP[indexPath.row] setObject:@"NO" forKey:@"selected"];
            [_itemSubmit removeObject:[_itemDataEXP[indexPath.row] objectForKey:@"ItemID" ]];
        }
        
    }else if (indexPath.section==1&&_itemDataNOEXP.count>0){
        NSString *selectedto=[_itemDataNOEXP[indexPath.row] objectForKey:@"selected"];
        if([selectedto isEqual:@"NO"]){
            [_itemDataNOEXP[indexPath.row] setObject:@"YES" forKey:@"selected"];
            [_itemSubmit addObject:[_itemDataNOEXP[indexPath.row] objectForKey:@"ItemID"]];
        }else{
            [_itemDataNOEXP[indexPath.row] setObject:@"NO" forKey:@"selected"];
            [_itemSubmit removeObject:[_itemDataNOEXP[indexPath.row] objectForKey:@"ItemID"]];
        }
    }
    NSLog(@"%@",_itemSubmit);
    [_tableView reloadData];
    
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == _maintainModel) {
        if ([keyPath isEqualToString:KVO_MAINTAIN_ITEMS_PATH_NAME]) {
            _itemData=_maintainModel.vehicleMaintainItems;
            _itemDataEXP = [[NSMutableArray alloc]init];
            _itemDataNOEXP= [[NSMutableArray alloc]init];
            for(NSMutableDictionary *data in _itemData){
                NSNumber *expFlag=[data objectForKey:@"expFlag"];
                if ([expFlag intValue]==1) {
                    [_itemDataEXP addObject:data];
                }else if ([expFlag intValue]==0){
                    [_itemDataNOEXP addObject:data];
                }
            }
            [_tableView reloadData];
            
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (IBAction)saveTap:(id)sender {
    [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    [_maintainModel saveVehicleMaintainItemsWithArguments:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,self.dateTextField.text,self.mileageTextField.text,_itemSubmit, nil]];
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.dateTextField resignFirstResponder];
//    [ADSingletonUtil sharedInstance].currentDeviceBase.TotalMilage
    if([self.mileageTextField.text floatValue] > [[ADSingletonUtil sharedInstance].currentDeviceBase.TotalMilage floatValue]){
        self.mileageTextField.text = [ADSingletonUtil sharedInstance].currentDeviceBase.TotalMilage;
    }
    [self.mileageTextField resignFirstResponder];
}

//点击键盘上的按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender == self.dateTextField) {
        [self.mileageTextField becomeFirstResponder];
    }else if (sender == self.mileageTextField){
        [self hidenKeyboard];
    }
    
}

- (void)viewDidUnload {
    [self setDateTextField:nil];
    [self setMileageTextField:nil];
    [self setMaintainTimeLable:nil];
    [self setMaintainMileageLabel:nil];
    [self setKmLabel:nil];
    [super viewDidUnload];
}
@end
