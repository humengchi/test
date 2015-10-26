//
//  ADHealthyHistoryViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-16.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHealthyHistoryViewController.h"

@interface ADHealthyHistoryViewController ()
@property (nonatomic) NSArray *itemData;
@property (nonatomic) NSArray *itemTimeData;
@end

@implementation ADHealthyHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _maintainModel = [[ADMaintainModel alloc]init];
        [_maintainModel addObserver:self
                        forKeyPath:KVO_MAINTAIN_HISTORY_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:nil];
        
    }
    return self;
}

- (void)dealloc
{
    [_maintainModel removeObserver:self forKeyPath:KVO_MAINTAIN_HISTORY_PATH_NAME];
    [_maintainModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem=nil;
    
    if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=self.view.bounds;
        frame.origin.y+=64;
        frame.size.height-=64;
        _tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        [self setExtraCellLineHidden:_tableView];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=self.view.bounds;
        frame.origin.y+=64;
        frame.size.height-=64;
        _tableView=[[UITableView alloc]initWithFrame:frame style:UITableViewStylePlain];
        [self setExtraCellLineHidden:_tableView];
	}

    
    _tableView.backgroundView=nil;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_tableView];
    
    [_maintainModel requestVehicleMaintainHistoryListWithArguments:[NSArray arrayWithObject:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID]];
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
    self.title=NSLocalizedStringFromTable(@"MaintenancehistoryKey",@"MyString", @"");
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
    return _itemData.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    NSDictionary *data=_itemData[indexPath.row];
    cell.textLabel.text = [data objectForKey:@"Name"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@,%@%@",[data objectForKey:@"MtDate"],[data objectForKey:@"MtMileage"],NSLocalizedStringFromTable(@"kmKey",@"MyString", @"")];
    cell.backgroundColor=[UIColor whiteColor];
    
    // Configure the cell...
    return cell;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
    if (object == _maintainModel) {
        if ([keyPath isEqualToString:KVO_MAINTAIN_HISTORY_PATH_NAME]) {
            _itemData=_maintainModel.vehicleMaintainHistoryList;
            [_tableView reloadData];
            
            return;
        }
    }
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}


@end
