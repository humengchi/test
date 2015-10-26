//
//  ADUserDriverLicenseEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserDriverLicenseEditViewController.h"

@interface ADUserDriverLicenseEditViewController ()
@property (nonatomic) NSArray *itemsData;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADUserDriverLicenseEditViewController

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
	self.title=NSLocalizedStringFromTable(@"driveLisenceKey",@"MyString", @"");
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitTap:)];
    self.navigationItem.rightBarButtonItem=barButton;
    if (IOS7_OR_LATER) {
        barButton.tintColor=[UIColor lightGrayColor];
    }
    _itemsData=[NSArray arrayWithObjects:
                NSLocalizedStringFromTable(@"docNo",@"MyString", @""),NSLocalizedStringFromTable(@"userName",@"MyString", @""),NSLocalizedStringFromTable(@"initialDate",@"MyString", @""),NSLocalizedStringFromTable(@"licenseNo",@"MyString", @""),NSLocalizedStringFromTable(@"licensePlace",@"MyString", @""),NSLocalizedStringFromTable(@"permissionDriverType",@"MyString", @""),NSLocalizedStringFromTable(@"points",@"MyString", @""),NSLocalizedStringFromTable(@"status",@"MyString", @""),NSLocalizedStringFromTable(@"validDate",@"MyString", @""),
                NSLocalizedStringFromTable(@"certificationDate",@"MyString", @""),nil];
    
    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        frame.size.height=240;
        [_tableView setFrame:frame];
    }
    

    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
}

-(void)submitTap:(id)sender{
    UITextField * docNoTextField=(UITextField *)[self.view viewWithTag:100];
    UITextField * userNameTextField=(UITextField *)[self.view viewWithTag:101];
    UITextField * initialDateTextField=(UITextField *)[self.view viewWithTag:102];
    UITextField * licenseNoTextField=(UITextField *)[self.view viewWithTag:103];
    UITextField * licensePlaceTextField=(UITextField *)[self.view viewWithTag:104];
    UITextField * permissionDriverTypeTextField=(UITextField *)[self.view viewWithTag:105];
    UITextField * pointsTextField=(UITextField *)[self.view viewWithTag:106];
//    UITextField * statusTextField=(UITextField *)[self.view viewWithTag:107];
    UITextField * validDateTextField=(UITextField *)[self.view viewWithTag:108];
    UITextField * certificationDateTextField=(UITextField *)[self.view viewWithTag:109];

    
    [self.delegate editContactViewController:self didEditContact:[NSArray arrayWithObjects:[_DriverLicenseInfo objectForKey:@"userID"],licenseNoTextField.text,docNoTextField.text,userNameTextField.text,licensePlaceTextField.text,permissionDriverTypeTextField.text,pointsTextField.text,initialDateTextField.text,validDateTextField.text,certificationDateTextField.text, nil]];
    [self.navigationController popViewControllerAnimated:YES];

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
    return _itemsData.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    UITextField *valueField=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 150, 24)];
    valueField.borderStyle=UITextBorderStyleNone;
    valueField.textAlignment=NSTextAlignmentRight;
    valueField.tag=indexPath.row+100;
    valueField.delegate=self;
    [cell addSubview:valueField];
    
    if(indexPath.row==0){
        valueField.text = [_DriverLicenseInfo objectForKey:@"docNo"];
        [valueField becomeFirstResponder];
    }else if (indexPath.row==1){
        valueField.text = [_DriverLicenseInfo objectForKey:@"userName"];
    }else if (indexPath.row==2){
        valueField.text = [_DriverLicenseInfo objectForKey:@"initialDate"];
    }
    else if (indexPath.row==3){
        valueField.text = [_DriverLicenseInfo objectForKey:@"licenseNo"];
    }else if (indexPath.row==4){
        valueField.text = [_DriverLicenseInfo objectForKey:@"licensePlace"];
    }else if (indexPath.row==5){
        valueField.text = [_DriverLicenseInfo objectForKey:@"permissionDriverType"];
    }else if (indexPath.row==6){
        valueField.text = [_DriverLicenseInfo objectForKey:@"points"];
    }else if (indexPath.row==7){
        valueField.text = [_DriverLicenseInfo objectForKey:@"status"];
    }else if (indexPath.row==8){
        valueField.text = [_DriverLicenseInfo objectForKey:@"validDate"];
    }else if (indexPath.row==9){
        valueField.text = [_DriverLicenseInfo objectForKey:@"certificationDate"];
    }
    [valueField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    cell.textLabel.text =_itemsData[indexPath.row];
        cell.backgroundColor=[UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    // Configure the cell...
    return cell;
}

-(void)hidenKeyboard
{
    [self resumeView];
    [self.view endEditing:YES];
    
}

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender==[(UITextField *)self.view viewWithTag:99+_itemsData.count]){
        [sender becomeFirstResponder];
        [self resumeView];
    }else if(sender==[(UITextField *)self.view viewWithTag:sender.tag] ){
        [(UITextField *)[self.view viewWithTag:sender.tag+1] becomeFirstResponder];
    }
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
