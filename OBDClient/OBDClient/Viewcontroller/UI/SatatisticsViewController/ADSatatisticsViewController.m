//
//  ADSatatisticsViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADSatatisticsViewController.h"
#import "ADSatatisticDetailViewController.h"
#import "ADSatatisticOilViewController.h"
#import "ADSatatisticAverageOilViewController.h"
#import "ADSatatisticPriceViewController.h"

@interface ADSatatisticsViewController ()
@property (nonatomic) NSArray *itemData;
@property (nonatomic) UITableView * tableView;
@end

@implementation ADSatatisticsViewController

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
    _itemData=@[NSLocalizedStringFromTable(@"TheaveragefuelconsumptionKey",@"MyString", @""),NSLocalizedStringFromTable(@"totalMileageKey",@"MyString", @""),NSLocalizedStringFromTable(@"ThetotalfuelconsumptionKey",@"MyString", @""),NSLocalizedStringFromTable(@"OilcostsKey",@"MyString", @""),NSLocalizedStringFromTable(@"GreenDriveKey",@"MyString", @"")];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView=nil;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view from its nib.
    
    if (IOS7_OR_LATER) {
        CGRect frame=self.tableView.frame;
        frame.origin.y+=64;
        [self.tableView setFrame:frame];
		[self setExtraCellLineHidden:self.tableView];
    }

}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"tongjiappear");
    self.title=NSLocalizedStringFromTable(@"StatisticsCenterKey",@"MyString", @"");
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
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
    return _itemData.count;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,40, WIDTH, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
    cell.accessoryView=buttonRight;
    
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.text = _itemData[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *className=@"";
    if(indexPath.row==4){
        className=@"ADGreenDriveViewController";
        [self tableViewSelectedHandleInSubClasses:className];
    }else if (indexPath.row==1){
        ADSatatisticDetailViewController* view=[[ADSatatisticDetailViewController alloc]init];
        view.satatisticTitle=[tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self.navigationController pushViewController:view animated:YES];
    }else if (indexPath.row == 2){
        NSLog(@"总耗油量");
        ADSatatisticOilViewController *view = [[ADSatatisticOilViewController alloc] init];
        view.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
        [self. navigationController pushViewController:view animated:YES];
    }else if(indexPath.row == 0){
//        ADSatatisticAverageOilViewController *view = [[ADSatatisticAverageOilViewController alloc] init];
//        view.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
//        [self.navigationController pushViewController:view animated:YES];
    }else if(indexPath.row == 3){
//        ADSatatisticPriceViewController *view = [[ADSatatisticPriceViewController alloc] init];
//        view.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
//        [self.navigationController pushViewController:view animated:YES];
    }
    else{
//        RootViewController *satatisticDetailView=[[RootViewController alloc]init];
//        satatisticDetailView.title=_itemData[indexPath.row];
//        [self.navigationController pushViewController:satatisticDetailView animated:YES];
    }
    
}

- (void)tableViewSelectedHandleInSubClasses:(NSString *)className
{
    UIViewController *viewController = [[NSClassFromString(className) alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
