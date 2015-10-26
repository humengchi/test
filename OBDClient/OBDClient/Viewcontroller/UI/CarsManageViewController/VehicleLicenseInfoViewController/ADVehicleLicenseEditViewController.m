//
//  ADVehicleLicenseEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleLicenseEditViewController.h"

@interface ADVehicleLicenseEditViewController ()
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) ADVehicleBase *vehicleLicenseInfo;
@end

@implementation ADVehicleLicenseEditViewController

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
    self.title=NSLocalizedStringFromTable(@"editKey", @"MyString", nil);
    self.navigationItem.leftBarButtonItem=nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editTap:)];
    if (IOS7_OR_LATER) {
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor lightGrayColor];
    }
    _dataItems=@[
                NSLocalizedStringFromTable(@"carownernameKey",@"MyString", @""),
                NSLocalizedStringFromTable(@"enginenumberKey",@"MyString", @""),
                NSLocalizedStringFromTable(@"latestannualinspectiontimeKey",@"MyString", @""),
                NSLocalizedStringFromTable(@"RegistrationTypeofvehicleKey",@"MyString", @""),
                NSLocalizedStringFromTable(@"RegistrationlocationKey",@"MyString", @""),
                NSLocalizedStringFromTable(@"RegistrationdateKey",@"MyString", @"")
                 ];
    self.title=NSLocalizedStringFromTable(@"DrivinglicenseinformationKey",@"MyString", @"");
    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
		[self setExtraCellLineHidden:_tableView];
    }

    
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    _vehicleLicenseInfo = [ADSingletonUtil sharedInstance].vehicleInfo;

    
    //添加手势，点击屏幕其他区域关闭键盘的操作
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self.tableView action:@selector(hidenKeyboard)];
//    gesture.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:gesture];
    
    
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
    return _dataItems.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _dataItems[indexPath.row];
    
    UITextField *valueField=[[UITextField alloc]initWithFrame:CGRectMake(200, 10, 100, 24)];
    valueField.borderStyle=UITextBorderStyleNone;
    valueField.textAlignment=NSTextAlignmentRight;
    valueField.tag=indexPath.row+100;
    valueField.delegate=self;
    [cell addSubview:valueField];
    
    if(indexPath.row==0){
        valueField.text = _vehicleLicenseInfo.ownerName;
    }else if (indexPath.row==1){
        valueField.text = _vehicleLicenseInfo.ein;
    }else if (indexPath.row==2){
        valueField.text = (NSString *)_vehicleLicenseInfo.inspectionDate;
    }else if (indexPath.row==3){
        valueField.text = _vehicleLicenseInfo.licenseModel;
    }else if (indexPath.row==4){
        valueField.text = _vehicleLicenseInfo.licensePlace;
    }else if (indexPath.row==5){
        valueField.text = (NSString *)_vehicleLicenseInfo.licenseDate;
    }
    
    [valueField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
- (IBAction)editTap:(id)sender {
    UITextField *ownerName=(UITextField *)[self.view viewWithTag:100];
    UITextField *ein=(UITextField *)[self.view viewWithTag:101];
    UITextField *licenseDate=(UITextField *)[self.view viewWithTag:105];
    UITextField *licensePlace=(UITextField *)[self.view viewWithTag:104];
    UITextField *inspectionDate=(UITextField *)[self.view viewWithTag:102];
    UITextField *licenseModel=(UITextField *)[self.view viewWithTag:103];
    
    _dataArray=[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin, ownerName.text,ein.text,licenseDate.text,licensePlace.text,licenseModel.text,inspectionDate.text,nil];
    
    [self.delegate editContactViewController:self didEditContact:_dataArray];
    [self.navigationController popViewControllerAnimated:YES];

}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移30个单位，按实际情况设置
    float Y = 0.0f;
    if (textField.tag>102) {
        Y=-80;
    }
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    float Y = 0.0f;
    CGRect rect=CGRectMake(0.0f,Y,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}

//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.view endEditing:YES];
    [self resumeView];
}

//点击键盘上的按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender==[(UITextField *)self.view viewWithTag:99+_dataItems.count]){
        [self hidenKeyboard];
    }
    else{
        [(UITextField *)[self.view viewWithTag:sender.tag+1] becomeFirstResponder];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [self hidenKeyboard];
}
@end
