//
//  ADUserAddVehicleViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-24.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserAddVehicleViewController.h"
#import "ADVehicleModelTypeChangeViewController.h"
#import "ADBindDeviceViewController.h"
#import "ADOilTypeSelectViewController.h"

@interface ADUserAddVehicleViewController ()<ADSelectItemDelegate>
@property (nonatomic) NSArray *dataItems;
@property (nonatomic) UITableView *tableView;
@end

@implementation ADUserAddVehicleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel = [[ADVehiclesModel alloc]init];
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        [notiCenter addObserver:self
                       selector:@selector(addVehicleSuccess:)
                           name:ADVehiclesModelAddVehicleSuccessNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(addVehicleExsit:)
                           name:ADVehiclesModelAddVehicleExistNotification
                         object:nil];
        [notiCenter addObserver:self
                       selector:@selector(addVehicleError:)
                           name:ADVehiclesModelAddVehicleErrorNotification
                         object:nil];
        
    }
    return self;
}

- (void)dealloc
{
    NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelAddVehicleSuccessNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelAddVehicleExistNotification
                        object:nil];
    [notiCenter removeObserver:self
                          name:ADVehiclesModelAddVehicleErrorNotification
                        object:nil];
    [_vehiclesModel cancel];
}

- (void)addVehicleSuccess:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_SUCCESS message:nil];
    ADBindDeviceViewController *bindView = [[ADBindDeviceViewController alloc]initWithNibName:nil bundle:nil];
    bindView.beSavedVin = [aNoti.userInfo objectForKey:@"data"];
//    NSLog(@"%@",[aNoti.userInfo objectForKey:@"data"]);
    [self.navigationController pushViewController:bindView animated:YES];
    
}

- (void)addVehicleExsit:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:NSLocalizedStringFromTable(@"vehiclealreadyexistsKey",@"MyString", @"")];
}

- (void)addVehicleError:(NSNotification *)aNoti{
    [IVToastHUD endRequestWithResultType:IV_TOAST_REQUEST_FIAL message:@"系统错误"];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.navigationItem.leftBarButtonItem=nil;
    self.title=NSLocalizedStringFromTable(@"addvehicleKey",@"MyString", @"");
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithTitle:NSLocalizedStringFromTable(@"nextstepKey",@"MyString", @"") style:UIBarButtonItemStyleDone target:self action:@selector(nextTap:)];
    self.navigationItem.rightBarButtonItem=barButton;
    if (IOS7_OR_LATER) {
        barButton.tintColor=[UIColor lightGrayColor];
    }
    _dataItems=@[NSLocalizedStringFromTable(@"TypeofvehicleKey", @"MyString", nil),NSLocalizedStringFromTable(@"typeoffuelKey", @"MyString", nil),NSLocalizedStringFromTable(@"carnickNameKey", @"MyString", nil),NSLocalizedStringFromTable(@"DrivinglicensenumberKey", @"MyString", nil),NSLocalizedStringFromTable(@"framenumberKey",@"MyString", @"")];
    
    if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-74) style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 220) style:UITableViewStylePlain];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 220) style:UITableViewStylePlain];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    _beSavedModelNumID=@"";
    _beSavedOilType=@"";
    
    
    
//    _typeLabel.text=NSLocalizedStringFromTable(@"TypeofvehicleKey",@"MyString", @"");
//    
//    
//    _nicknameLabel.text=NSLocalizedStringFromTable(@"carnickNameKey",@"MyString", @"");
//    
//    _oiltypeLabel.text=NSLocalizedStringFromTable(@"typeoffuelKey",@"MyString", @"");
//    
//    _frameLabel.text=NSLocalizedStringFromTable(@"framenumberKey",@"MyString", @"");
//    
//    _drivenumLabel.text=NSLocalizedStringFromTable(@"DrivinglicensenumberKey",@"MyString", @"");

    
}


- (void) selectItemViewController:(ADOilTypeSelectViewController *) selectViewController didSelectItem:(NSString * ) item{
    _beSavedOilType=item;
     UILabel *oilTypeLabel=(UILabel *)[self.view viewWithTag:101];
    oilTypeLabel.text=[self getOilType:item];
}

- (void)viewWillAppear:(BOOL)animated{
    if(_refreshFlag){
        UILabel *typeLabel=(UILabel *)[self.view viewWithTag:100];
        typeLabel.text=_beSavedType;
    }
}

- (IBAction)nextTap:(id)sender
{
    UITextField *nickNameField=(UITextField *)[self.view viewWithTag:102];
    UITextField *licenseNumField=(UITextField *)[self.view viewWithTag:103];
    UITextField *vinField=(UITextField *)[self.view viewWithTag:104];
    if([_beSavedModelNumID isEqualToString:@""]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"PleaseselectvehicletypeKey",@"MyString", @"")];
    }else if ([_beSavedOilType isEqualToString:@""]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"pleaseSelectOilTypeKey",@"MyString", @"")];
    }
    else if ([vinField.text isEqualToString:@""]||vinField.text==nil){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"pleaseEntervinKey",@"MyString", @"")];
    }else if ([licenseNumField.text isEqualToString:@""]||vinField.text==nil){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"pleaseEnterLicenseNumKey",@"MyString", @"")];
    }else{
        [_vehiclesModel addVehicleWithArguments:[NSArray arrayWithObjects:vinField.text,nickNameField.text==nil?@"":nickNameField.text,_beSavedOilType,_beSavedModelNumID,licenseNumField.text,[ADSingletonUtil sharedInstance].globalUserBase.userID, nil]];
        [IVToastHUD showAsToastWithStatus:NSLocalizedStringFromTable(@"loadingKey",@"MyString", @"")];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    [self resumeView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
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
        viewController.senderPage=@"addVehicle";
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
        UILabel *valueField=[[UILabel alloc]initWithFrame:CGRectMake(100, 5, 180, 50)];
        valueField.textAlignment=NSTextAlignmentRight;
        valueField.tag=indexPath.row+100;
        [cell addSubview:valueField];
        valueField.numberOfLines=0;
        valueField.textColor=[UIColor lightGrayColor];
        valueField.text=NSLocalizedStringFromTable(@"needselect",@"MyString", @"");
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        
    }else if (indexPath.row==1){
        UILabel *valueField=[[UILabel alloc]initWithFrame:CGRectMake(100, 8, 180, 24)];
        valueField.textAlignment=NSTextAlignmentRight;
        valueField.tag=indexPath.row+100;
        [cell addSubview:valueField];
        valueField.numberOfLines=0;
        valueField.textColor=[UIColor lightGrayColor];
        valueField.text=NSLocalizedStringFromTable(@"needselect",@"MyString", @"");
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        UITextField *valueField=[[UITextField alloc]initWithFrame:CGRectMake(200, 8, 100, 24)];
        valueField.borderStyle=UITextBorderStyleNone;
        valueField.textAlignment=NSTextAlignmentRight;
        valueField.textColor=DEFAULT_DETAILTEXT_COLOR;
        valueField.tag=indexPath.row+100;
        valueField.delegate=self;
        [cell addSubview:valueField];
        if(indexPath.row==3||indexPath.row==4){
            valueField.placeholder=NSLocalizedStringFromTable(@"requiredfields",@"MyString", @"");
        }
        
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
        typeString = @"90#c";
    }
    return typeString;
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
        Y = -60.0f;
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
