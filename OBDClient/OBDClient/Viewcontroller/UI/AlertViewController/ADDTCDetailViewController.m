//
//  ADDTCDetailViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-31.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDTCDetailViewController.h"
#import "ADDTCDetailCell.h"
#import "ADDTCInfoMoreViewController.h"

@interface ADDTCDetailViewController ()

@end

@implementation ADDTCDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dtcBase:(ADDTCBase *)aDTCBase
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dtcBase = aDTCBase;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=NSLocalizedStringFromTable(@"descriptionInformationKey",@"MyString", @"");
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.separatorColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundView=nil;
    _tableView.backgroundColor=[UIColor clearColor];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 81;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dtcBase.Num_of_DTC>10?10:_dtcBase.Num_of_DTC;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.navigationController pushViewController:[[ADDTCInfoMoreViewController alloc] initWithNibName:nil bundle:nil code:[[_tableView cellForRowAtIndexPath:indexPath].textLabel.text substringFromIndex:6]] animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *idStr = @"ADDTCDetailViewController.cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idStr];
    NSString *dtcCode;
    NSString *dtcContent;
    if (indexPath.row == 0) {
        dtcCode = [_dtcBase.DTC_1 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_1 substringFromIndex:7];
    } else if (indexPath.row == 1) {
        dtcCode = [_dtcBase.DTC_2 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_2 substringFromIndex:7];
    } else if (indexPath.row == 2) {
        dtcCode = [_dtcBase.DTC_3 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_3 substringFromIndex:7];
    }else if (indexPath.row == 3) {
        dtcCode = [_dtcBase.DTC_4 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_4 substringFromIndex:7];
    } else if (indexPath.row == 4) {
        dtcCode = [_dtcBase.DTC_5 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_5 substringFromIndex:7];
    } else if (indexPath.row == 5) {
        dtcCode = [_dtcBase.DTC_6 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_6 substringFromIndex:7];
    } else if (indexPath.row == 6) {
        dtcCode = [_dtcBase.DTC_6 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_6 substringFromIndex:7];
    } else if (indexPath.row == 7) {
        dtcCode = [_dtcBase.DTC_8 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_8 substringFromIndex:7];
    } else if (indexPath.row == 8) {
        dtcCode = [_dtcBase.DTC_9 substringToIndex:5];
        dtcContent = [_dtcBase.DTC_9 substringFromIndex:7];
    }    
    else {
        NSAssert(0, @"not handle row~");
    }
//    if (!cell) {
        cell = [[ADDTCDetailCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:idStr
                                              dtcCode:dtcCode
                                           dtcContent:dtcContent];
//    }
    [(ADDTCDetailCell *)cell updateUIBydtcCode:dtcCode dtcContent:dtcContent];
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,80, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonRight.frame = CGRectMake(0, 10, 6, 6.5);
    [buttonRight setBackgroundImage:[UIImage imageNamed:@"vehicle_list_right.png"] forState:UIControlStateNormal];
    cell.accessoryView=buttonRight;
    
    return cell;
}

@end
