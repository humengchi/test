//
//  ADUserSettingViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-28.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserSettingViewController.h"
#import "ADUserDriveCardSettingViewController.h"
#import "ADUserInfoSettingViewController.h"

@interface ADUserSettingViewController ()
@property (nonatomic) NSArray *dataItems;
@end

@implementation ADUserSettingViewController

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
    self.title=NSLocalizedStringFromTable(@"userSettingKey",@"MyString", @"");
    
    UITableView *tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.backgroundView=nil;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:tableView];
    
    if (IOS7_OR_LATER) {
        CGRect frame=tableView.frame;
        frame.origin.y+=64;
        [tableView setFrame:frame];
		[self setExtraCellLineHidden:tableView];
    }

    _dataItems=@[NSLocalizedStringFromTable(@"userInfoSettingKey",@"MyString", @""),NSLocalizedStringFromTable(@"userDriveCardKey",@"MyString", @"")];
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    cell.textLabel.font=[UIFont systemFontOfSize:16];
    cell.textLabel.text = _dataItems[indexPath.row];
    cell.backgroundColor=[UIColor clearColor];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,40, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
    cell.accessoryView=buttonRight;
    
    
    // Configure the cell...
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}

-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row==0){
        ADUserInfoSettingViewController *userInfoSetting = [[ADUserInfoSettingViewController alloc]init];
        [self.navigationController pushViewController:userInfoSetting animated:YES];
    }else if (indexPath.row==1){
        ADUserDriveCardSettingViewController *driveCardSetting = [[ADUserDriveCardSettingViewController alloc]init];
        [self.navigationController pushViewController:driveCardSetting animated:YES];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
