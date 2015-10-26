//
//  ADVehicleSellInfoEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleSellInfoEditViewController.h"

@interface ADVehicleSellInfoEditViewController ()
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADVehicleSellInfoEditViewController

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
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitTap:)];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    if (IOS7_OR_LATER) {
        menuItem.tintColor=[UIColor lightGrayColor];
    }
    _dataItems=@[
                 NSLocalizedStringFromTable(@"DateofproductionKey", @"MyString", nil),
                 NSLocalizedStringFromTable(@"buyDateKey", @"MyString", nil),
                 NSLocalizedStringFromTable(@"salesCompanyKey", @"MyString", nil),NSLocalizedStringFromTable(@"salesCompanyPhoneKey", @"MyString", nil),NSLocalizedStringFromTable(@"salesPersonKey", @"MyString", nil),NSLocalizedStringFromTable(@"salesPersonPhoneKey", @"MyString", nil),NSLocalizedStringFromTable(@"salesContractNumberKey", @"MyString", nil)
                 ];
    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        frame.size.height=300;
        [_tableView setFrame:frame];
    }

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    
}

- (IBAction)submitTap:(id)sender{
    UITextField *manufactureDateField=(UITextField *)[self.view viewWithTag:100];
    UITextField *salesCompanyField=(UITextField *)[self.view viewWithTag:102];
    UITextField *salesCompanyPhoneField=(UITextField *)[self.view viewWithTag:103];
    UITextField *salesPersonField=(UITextField *)[self.view viewWithTag:104];
    UITextField *salesPersonPhoneField=(UITextField *)[self.view viewWithTag:105];
    UITextField *buyDateField=(UITextField *)[self.view viewWithTag:101];
    UITextField *salesContractNumberField=(UITextField *)[self.view viewWithTag:106];
    [self.delegate editContactViewController:self didEditContact:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,manufactureDateField.text,(NSString *)salesCompanyField.text,(NSString *)salesCompanyPhoneField.text,(NSString *)salesPersonField.text,(NSString *)salesPersonPhoneField.text,(NSString *)buyDateField.text,(NSString *)salesContractNumberField.text,_oldVehicleInfo.StoreID, nil]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        [(UITextField *)[self.view viewWithTag:100] becomeFirstResponder];
    }else{
        [(UITextField *)[self.view viewWithTag:100+indexPath.row] becomeFirstResponder];
    }
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
        valueField.text = (NSString *)_oldVehicleInfo.manufactureDate;
        [valueField becomeFirstResponder];
    }else if (indexPath.row==1){
        valueField.text = (NSString *)_oldVehicleInfo.buyDate;
    }else if (indexPath.row==2){
        valueField.text = _oldVehicleInfo.salesCompany;
    }else if (indexPath.row==3){
        valueField.text = _oldVehicleInfo.salesCompanyPhone;
    }else if (indexPath.row==4){
        valueField.text = _oldVehicleInfo.salesPerson;
    }else if (indexPath.row==5){
        valueField.text = _oldVehicleInfo.salesPersonPhone;
    }else if (indexPath.row==6){
        valueField.text = _oldVehicleInfo.salesContractNumber;
    }
    
    [valueField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender==[(UITextField *)self.view viewWithTag:99+_dataItems.count]){
        [self hidenKeyboard];
    }
    else{
        [(UITextField *)[self.view viewWithTag:sender.tag+1] becomeFirstResponder];
    }
    
}

-(void)hidenKeyboard
{
    [self.view endEditing:YES];
    [self resumeView];
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
    if(textField.tag>102){
        Y = -130.0f;
    }
    if (textField.tag>103){
        Y = -150.0f;
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

@end
