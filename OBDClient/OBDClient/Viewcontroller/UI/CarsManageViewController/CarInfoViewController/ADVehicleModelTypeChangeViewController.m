//
//  ADVehicleModelTypeChangeViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-11.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleModelTypeChangeViewController.h"
#import "ADVehiclesModel.h"
#import "ADCarInfoViewController.h"
#import "ADUserAddVehicleViewController.h"
#import "ADVehicleBaseInfoEditViewController.h"

@interface ADVehicleModelTypeChangeViewController ()
@property (nonatomic) ADVehiclesModel *vehiclesModel;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *vehicleModelTypeList;
@end

@implementation ADVehicleModelTypeChangeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _vehiclesModel=[[ADVehiclesModel alloc]init];
        [_vehiclesModel addObserver:self
                         forKeyPath:KVO_VEHICLE_MODELTYPE_LIST_PATH_NAME
                            options:NSKeyValueObservingOptionNew
                            context:nil];
    }
    return self;
}

-(void)dealloc{
    [_vehiclesModel removeObserver:self forKeyPath:KVO_VEHICLE_MODELTYPE_LIST_PATH_NAME];
    [_vehiclesModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64) style:UITableViewStylePlain];
    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];

	}

    
    
    [_vehiclesModel requestVehicleModelTypeListWithArguments:[NSArray arrayWithObjects:[NSString stringWithFormat:@"%@",_typeID],[NSString stringWithFormat:@"%u",_typeFlag], nil]];
}

- (void)viewDidAppear:(BOOL)animated{

}

- (void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.leftBarButtonItem=nil;
    if (_typeFlag==BRAND_TYPE) {
        self.title=NSLocalizedStringFromTable(@"SelectthebrandKey",@"MyString", @"");
    }else if (_typeFlag==MODEL_TYPE){
        self.title=NSLocalizedStringFromTable(@"SelectthetypeKey",@"MyString", @"");
    }else if (_typeFlag==STYLE_TYPE){
        self.title=NSLocalizedStringFromTable(@"SelectthestyleKey",@"MyString", @"");
    }
    
    
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
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, WIDTH-20, 20)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.8];
    label.textAlignment = UITextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor=[UIColor clearColor];
    [headerView addSubview:label];
    
    if (_typeFlag==BRAND_TYPE) {
        label.text=NSLocalizedStringFromTable(@"PleaseselectvehiclebrandKey",@"MyString", @"");
    }else if (_typeFlag==MODEL_TYPE){
        label.text=NSLocalizedStringFromTable(@"PleaseselectvehicletypeKey",@"MyString", @"");
    }else if (_typeFlag==STYLE_TYPE){
        label.text=NSLocalizedStringFromTable(@"PleaseselectvehiclestyleKey",@"MyString", @"");
    }
    
    return headerView;
}



- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString *headTitle=@"";
    if (_typeFlag==BRAND_TYPE) {
        headTitle=NSLocalizedStringFromTable(@"PleaseselectvehiclebrandKey",@"MyString", @"");
    }else if (_typeFlag==MODEL_TYPE){
        headTitle=NSLocalizedStringFromTable(@"PleaseselectvehicletypeKey",@"MyString", @"");
    }else if (_typeFlag==STYLE_TYPE){
        headTitle=NSLocalizedStringFromTable(@"PleaseselectvehiclestyleKey",@"MyString", @"");
    }
    return headTitle;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_typeFlag==BRAND_TYPE) {
        ADVehicleModelTypeChangeViewController *viewController=[[ADVehicleModelTypeChangeViewController alloc]initWithNibName:nil bundle:nil];
        viewController.typeFlag=MODEL_TYPE;
        viewController.senderPage=_senderPage;
        NSDictionary *vehicleModelType=_vehicleModelTypeList[indexPath.row];
        viewController.typeID=[vehicleModelType objectForKey:@"BrandID"];
        viewController.besavedBrand=[[vehicleModelType objectForKey:@"Brand"] substringFromIndex:2];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (_typeFlag==MODEL_TYPE){
        ADVehicleModelTypeChangeViewController *viewController=[[ADVehicleModelTypeChangeViewController alloc]initWithNibName:nil bundle:nil];
        viewController.typeFlag=STYLE_TYPE;
        viewController.senderPage=_senderPage;
        NSDictionary *vehicleModelType=_vehicleModelTypeList[indexPath.row];
        viewController.typeID=[vehicleModelType objectForKey:@"ModelID"];
        viewController.besavedBrand=_besavedBrand;
        viewController.besavedModel=[[vehicleModelType objectForKey:@"ModelName"] substringFromIndex:2];
        [self.navigationController pushViewController:viewController animated:YES];
    }else if (_typeFlag==STYLE_TYPE){
        if([_senderPage isEqualToString:@"addVehicle"]){
            ADUserAddVehicleViewController *userAddViewControllor=[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)];
            
            NSDictionary *vehicleModelType=_vehicleModelTypeList[indexPath.row];
            userAddViewControllor.beSavedModelNumID=[vehicleModelType objectForKey:@"ModelNumID"];
            userAddViewControllor.beSavedType=[NSString stringWithFormat:@"%@%@%@",_besavedBrand,_besavedModel,[vehicleModelType objectForKey:@"Type"]];
            userAddViewControllor.refreshFlag=YES;
            [self.navigationController popToViewController: userAddViewControllor animated:YES];
        }else{
            ADVehicleBaseInfoEditViewController *editViewControllor=[self.navigationController.viewControllers objectAtIndex: ([self.navigationController.viewControllers count] -4)];
            
            NSDictionary *vehicleModelType=_vehicleModelTypeList[indexPath.row];
            editViewControllor.besavedNum=[vehicleModelType objectForKey:@"ModelNumID"];
            editViewControllor.besavedType=[NSString stringWithFormat:@"%@%@%@",_besavedBrand,_besavedModel,[vehicleModelType objectForKey:@"Type"]];
            editViewControllor.refreshFlag=YES;
            [self.navigationController popToViewController: editViewControllor animated:YES];
        }
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
    return _vehicleModelTypeList.count;
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
    NSDictionary *vehicleModelType=_vehicleModelTypeList[indexPath.row];
    
    if (_typeFlag==BRAND_TYPE) {
        cell.textLabel.text = [vehicleModelType objectForKey:@"Brand"] ;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (_typeFlag==MODEL_TYPE){
        cell.textLabel.text = [vehicleModelType objectForKey:@"ModelName"] ;
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }else if (_typeFlag==STYLE_TYPE){
        cell.textLabel.text = [vehicleModelType objectForKey:@"Type"] ;
        cell.accessoryType=UITableViewCellAccessoryNone;
    }
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,40, WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    if(_typeFlag!=STYLE_TYPE){
        UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
        buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
        [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
        cell.accessoryView=buttonRight;
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    // Configure the cell...
    return cell;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == _vehiclesModel) {
        if ([keyPath isEqualToString:KVO_VEHICLE_MODELTYPE_LIST_PATH_NAME]) {
            _vehicleModelTypeList=_vehiclesModel.vehicleModelTypeList;
            [_tableView reloadData];
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

@end
