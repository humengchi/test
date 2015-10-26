//
//  ADOilTypeSelectViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-12-5.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADOilTypeSelectViewController.h"

@interface ADOilTypeSelectViewController ()
{
    NSIndexPath *lastIndexPath;
    NSString *selectItem;
}
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataItems;
@end

@implementation ADOilTypeSelectViewController

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
    self.title=NSLocalizedStringFromTable(@"typeoffuelKey",@"MyString", @"");
    
	if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 176) style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 176) style:UITableViewStylePlain];
    }
    
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 176) style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, 176) style:UITableViewStylePlain];
    }

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_tableView];
    _dataItems=@[@"90#",@"93#",@"97#",@"90#c"];
    
    lastIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    
}

- (void)viewDidUnload{
    self.delegate=nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    [self.delegate selectItemViewController:self didSelectItem:selectItem];
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
    cell.textLabel.text=_dataItems[indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    // Configure the cell...
    return cell;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int newRow = [indexPath row];
    int oldRow = [lastIndexPath row];
    if (newRow != oldRow)
    {
        UITableViewCell *newCell = [tableView cellForRowAtIndexPath:
                                    indexPath];
        newCell.accessoryType = UITableViewCellAccessoryCheckmark;
        newCell.textLabel.textColor=DEFAULT_DETAILTEXT_COLOR;
        
        UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:
                                    lastIndexPath];
        oldCell.accessoryType = UITableViewCellAccessoryNone;
        oldCell.textLabel.textColor=[UIColor blackColor];
        lastIndexPath = indexPath;
    }
    selectItem= [NSString stringWithFormat:@"%d",indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
