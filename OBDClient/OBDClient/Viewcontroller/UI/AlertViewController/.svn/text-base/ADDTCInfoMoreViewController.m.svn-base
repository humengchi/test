//
//  ADDTCInfoMoreViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-1.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADDTCInfoMoreViewController.h"

@interface ADDTCInfoMoreViewController ()

@end

@implementation ADDTCInfoMoreViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil code:(NSString *)code
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dtcsModel = [[ADDTCsModel alloc]init];
        _dtcCode = code;
        [_dtcsModel addObserver:self
                     forKeyPath:KVO_DTCS_INFO_PATH_NAME
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    }
    return self;
}

-(void)dealloc
{
    [_dtcsModel removeObserver:self
                    forKeyPath:KVO_DTCS_INFO_PATH_NAME];
    [_dtcsModel cancel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title=_dtcCode;
    _moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, self.view.bounds.size.height-10)];
    _moreLabel.numberOfLines=0;
    _moreLabel.textAlignment=NSTextAlignmentLeft;
//    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    _moreLabel.textColor=[UIColor grayColor];
    UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];
    _moreLabel.font=dateFont;
    _moreLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _moreLabel.backgroundColor=[UIColor clearColor];
    [self.view addSubview: _moreLabel];
    
    
    
//    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _tableView.backgroundColor=[UIColor clearColor];
//    _tableView.delegate=self;
//    _tableView.dataSource=self;
//    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//    _tableView.separatorColor = [UIColor clearColor];
//    [self.view addSubview:_tableView];
    
    [_dtcsModel requestDTCInfoWithArguments:[NSArray arrayWithObjects:[NSArray arrayWithObject:_dtcCode],@"obd_demo",[ADSingletonUtil sharedInstance].currentDeviceBase.BrandID,nil]];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _dtcsModel) {
        if ([keyPath isEqualToString:KVO_DTCS_INFO_PATH_NAME]) {
            //TODO:
            if(_dtcsModel.dtcsInfo.count==0){
                 [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"code201",@"MyString", @"")];
            }else{
                NSDictionary *dtcInfo=_dtcsModel.dtcsInfo[0];
                _moreLabel.text=[NSString stringWithFormat:@"%@:%@\n\n%@:\n%@",NSLocalizedStringFromTable(@"effectKey",@"MyString", @""),[dtcInfo objectForKey:@"type"],NSLocalizedStringFromTable(@"detailedDescriptionKey",@"MyString", @""),[dtcInfo objectForKey:@"more"]];
                
                
                CGSize maximumSize = CGSizeMake(300, 9999);
                UIFont *dateFont = [UIFont fontWithName:@"Helvetica" size:14];
                CGSize dateStringSize = [_moreLabel.text sizeWithFont:dateFont
                                                    constrainedToSize:maximumSize
                                                        lineBreakMode:_moreLabel.lineBreakMode];
                CGRect dateFrame = CGRectMake(10, 10, 300, dateStringSize.height);
                _moreLabel.frame = dateFrame;
            }
            
            return;
        }
    }
    return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 51;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - UITableViewDataDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[_dtcsModel.dtcsInfo count]);
    return [_dtcsModel.dtcsInfo count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    
    UIColor *labelColor = COLOR_RGB(255, 255, 255);
    cell.textLabel.textColor = labelColor;
    NSDictionary *data = _dtcsModel.dtcsInfo[indexPath.row];
    cell.textLabel.text = [data objectForKey:@"more"];
    cell.accessoryType=UITableViewCellAccessoryNone;
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0,50, cell.bounds.size.width, 1)];
    lineView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"vehicle_list_line.png"]];
    [cell addSubview:lineView];
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
