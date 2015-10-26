//
//  ADVehicleBaseInfoEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-12-3.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleBaseInfoEditViewController.h"
#import "ADVehicleModelTypeChangeViewController.h"
#import "ADOilTypeSelectViewController.h"

@interface ADVehicleBaseInfoEditViewController ()<ADSelectItemDelegate>
{
    NSString *beSavedOilType;
}
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADVehicleBaseInfoEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    if(_refreshFlag){
        UILabel *typeLabel=(UILabel *)[self.view viewWithTag:100];
        typeLabel.text=_besavedType;
    }else{
        _besavedNum=[_baseInfo objectForKey:@"ModelNumID"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title=NSLocalizedStringFromTable(@"editKey", @"MyString", nil);
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitTap:)];
    self.navigationItem.rightBarButtonItem = menuItem;
    
    _dataItems=@[NSLocalizedStringFromTable(@"StylesKey", @"MyString", nil),NSLocalizedStringFromTable(@"typeoffuelKey", @"MyString", nil),NSLocalizedStringFromTable(@"vehicleNickname", @"MyString", nil),NSLocalizedStringFromTable(@"DrivinglicensenumberKey", @"MyString", nil)];
    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
        [self setExtraCellLineHidden:_tableView];
        menuItem.tintColor=[UIColor lightGrayColor];
    }
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    _besavedNum=[_baseInfo objectForKey:@"ModelNumID"];
}

- (void) selectItemViewController:(ADOilTypeSelectViewController *) selectViewController didSelectItem:(NSString * ) item{
    beSavedOilType=item;
    UILabel *oilTypeLabel=(UILabel *)[self.view viewWithTag:101];
    oilTypeLabel.text=[self getOilType:item];
}

- (IBAction)submitTap:(id)sender{
//    UITextField *oilTypeField=(UITextField *)[self.view viewWithTag:101];
    UITextField *nickNameField=(UITextField *)[self.view viewWithTag:102];
    UITextField *licenseNumField=(UITextField *)[self.view viewWithTag:103];
//    NSLog(@"%@",[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,nickNameField.text,beSavedOilType==nil?[_baseInfo objectForKey:@"oilType"]:beSavedOilType,_besavedNum,licenseNumField.text, nil]);
    [self.delegate editContactViewController:self didEditContact:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,nickNameField.text,beSavedOilType==nil?[_baseInfo objectForKey:@"oilType"]:beSavedOilType,_besavedNum,licenseNumField.text, nil]];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        return 60;
    }else{
        return 40;
    }
}

// 有几个区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row==0){
        ADVehicleModelTypeChangeViewController *viewController=[[ADVehicleModelTypeChangeViewController alloc]initWithNibName:nil bundle:nil];
        viewController.typeFlag=0;
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (indexPath.row==1){
        ADOilTypeSelectViewController *oilTypeView=[[ADOilTypeSelectViewController alloc]init];
        oilTypeView.delegate=self;
        [self.navigationController pushViewController:oilTypeView animated:YES];
    }
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
    if(indexPath.row==0){
        UILabel *valueField=[[UILabel alloc]initWithFrame:CGRectMake(100, 10, 180, 48)];
        valueField.textAlignment=NSTextAlignmentRight;
        valueField.tag=indexPath.row+100;
        [cell addSubview:valueField];
        valueField.text=[NSString stringWithFormat:@"%@%@%@",[[_baseInfo objectForKey:@"Brand"] substringFromIndex:2],[[_baseInfo objectForKey:@"ModelName"] substringFromIndex:2],[_baseInfo objectForKey:@"Type"]];
        valueField.numberOfLines=0;
        valueField.textColor=DEFAULT_DETAILTEXT_COLOR;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.row==1){
        UILabel *valueField=[[UILabel alloc]initWithFrame:CGRectMake(100, 8, 180, 24)];
        valueField.textAlignment=NSTextAlignmentRight;
        valueField.tag=indexPath.row+100;
        [cell addSubview:valueField];
        valueField.text=[self getOilType:[_baseInfo objectForKey:@"oilType"]];
        valueField.numberOfLines=0;
        valueField.textColor=DEFAULT_DETAILTEXT_COLOR;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        UITextField *valueField=[[UITextField alloc]initWithFrame:CGRectMake(200, 10, 100, 24)];
        valueField.borderStyle=UITextBorderStyleNone;
        valueField.textAlignment=NSTextAlignmentRight;
        valueField.tag=indexPath.row+100;
        valueField.delegate=self;
        [cell addSubview:valueField];
        
        if (indexPath.row==2){
            valueField.text=[_baseInfo objectForKey:@"nickName"];
        }else if (indexPath.row==3){
            valueField.text=[_baseInfo objectForKey:@"licenseNumber"];
        }else{
            valueField.text=@"";
        }
        valueField.textColor=DEFAULT_DETAILTEXT_COLOR;
        [valueField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    //    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

- (NSString*)getOilType:(NSString *)type{
    NSString *typeString ;
    if([type intValue]==0){
        typeString=@"90#";
    }else if([type intValue]==1){
        typeString=@"93#";
    }else if ([type intValue]==2){
        typeString = @"97#";
    }else if ([type intValue]==3){
        typeString = @"90#";
    }
    return typeString;
}

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender==[(UITextField *)self.view viewWithTag:103]){
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
        Y = -110.0f;
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
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
