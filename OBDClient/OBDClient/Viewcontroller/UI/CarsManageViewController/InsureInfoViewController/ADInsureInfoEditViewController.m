//
//  ADInsureInfoEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-9.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADInsureInfoEditViewController.h"

@interface ADInsureInfoEditViewController ()
@property (nonatomic) NSArray *dataArray;
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADInsureInfoEditViewController

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
    self.navigationItem.leftBarButtonItem=nil;
    self.title=NSLocalizedStringFromTable(@"editKey", @"MyString", nil);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(editTap:)];
    
    _dataItems=@[NSLocalizedStringFromTable(@"InsurancecompanynameKey",@"MyString", @""),NSLocalizedStringFromTable(@"CustomerservicephoneKey",@"MyString", @""),NSLocalizedStringFromTable(@"policynumberKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"altfNumberKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"policyeffectivedateKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"policyexpirationDateKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"ClaimsOfficerKey",@"MyString", @""),NSLocalizedStringFromTable(@"ClaimsOfficerphoneKey",@"MyString", @""),NSLocalizedStringFromTable(@"PolicydetailsKey",@"MyString", @""),
                 NSLocalizedStringFromTable(@"PolicyMark",@"MyString", @"")
                 ];
    self.title=NSLocalizedStringFromTable(@"InsuranceinformationKey",@"MyString", @"");
    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
		[self setExtraCellLineHidden:_tableView];
        self.navigationItem.rightBarButtonItem.tintColor=[UIColor lightGrayColor];
    }

    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
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
        valueField.text = _vehicleInsure.insuranceCompany;
    }else if (indexPath.row==1){
        valueField.text = _vehicleInsure.customerServicePhone;
    }else if (indexPath.row==2){
        valueField.text = _vehicleInsure.policyNumber;
    }else if (indexPath.row==3){
        valueField.text = _vehicleInsure.aitfNumber;
    }else if (indexPath.row==4){
        valueField.text = (NSString *)_vehicleInsure.effectiveDate;
    }else if (indexPath.row==5){
        valueField.text = (NSString *)_vehicleInsure.expirationDate;
    }else if (indexPath.row==6){
        valueField.text = _vehicleInsure.claimClerk;
    }else if (indexPath.row==7){
        valueField.text = _vehicleInsure.claimClerkPhone;
    }else if (indexPath.row==8){
        valueField.text = _vehicleInsure.detailInfo;
    }else if (indexPath.row==9){
        valueField.text = _vehicleInsure.mark;
    }
    
    [valueField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    cell.backgroundColor=[UIColor whiteColor];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}


- (void)viewWillAppear:(BOOL)animated{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [(UITextField *)[self.view viewWithTag:101] becomeFirstResponder];
}

- (IBAction)editTap:(id)sender {
    UITextField *insuranceCompanyTextField=(UITextField *)[self.view viewWithTag:100];
    UITextField *customerServicePhoneTextField=(UITextField *)[self.view viewWithTag:101];
    UITextField *policyNumberTextField=(UITextField *)[self.view viewWithTag:102];
    UITextField *aitfNumberTextField=(UITextField *)[self.view viewWithTag:103];
    UITextField *effectDateTextField=(UITextField *)[self.view viewWithTag:104];
    UITextField *expirationDateTextField=(UITextField *)[self.view viewWithTag:105];
    UITextField *claimClerkTextField=(UITextField *)[self.view viewWithTag:106];
    UITextField *claimClerkPhoneTextField=(UITextField *)[self.view viewWithTag:107];
    UITextField *detailInfoTextField=(UITextField *)[self.view viewWithTag:108];
    UITextField *markTextField=(UITextField *)[self.view viewWithTag:109];
    
    
    _dataArray=[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,insuranceCompanyTextField.text,customerServicePhoneTextField.text,policyNumberTextField.text,aitfNumberTextField.text,effectDateTextField.text,expirationDateTextField.text,claimClerkTextField.text,claimClerkPhoneTextField.text,detailInfoTextField.text,markTextField.text,nil];
    [self.delegate editContactViewController:self didEditContact:_dataArray];
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移Y个单位，按实际情况设置
    float Y = 0.0f;
    float H = 0.0f;
    if (textField.tag>100) {
        Y=-(textField.tag-100)*40;
        H=(textField.tag-100)*40;
    }
    CGRect rect=CGRectMake(0.0f,Y,width,height+H);
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
        [sender becomeFirstResponder];
        [self hidenKeyboard];
    }
    else{
        [(UITextField *)[self.view viewWithTag:sender.tag+1] becomeFirstResponder];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self hidenKeyboard];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
