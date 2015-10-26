//
//  ADVehicleSettingConfigEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleSettingConfigEditViewController.h"
#import "ADVehicleSettingConfigCell.h"

@interface ADVehicleSettingConfigEditViewController ()
@property (nonatomic) UITableView *tableView;
@end

@implementation ADVehicleSettingConfigEditViewController

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
    self.navigationItem.leftBarButtonItem=nil;
    self.title=@"编辑";
//    self.view.backgroundColor=[UIColor whiteColor];
    
    UIBarButtonItem *menuItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(submitTap:)];
    self.navigationItem.rightBarButtonItem = menuItem;
    if (IOS7_OR_LATER) {
        menuItem.tintColor=[UIColor lightGrayColor];
    }

    if (!IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    }
    if (IOS7_OR_LATER) {
        _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        CGRect frame=_tableView.frame;
        frame.origin.y+=64;
        [_tableView setFrame:frame];
		[self setExtraCellLineHidden:_tableView];
    }
    
   
//    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
}

-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

-(void)hidenKeyboard
{
    [self resumeView];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitTap:(id)sender{
    [self.view endEditing:YES];
    [self.delegate editContactViewController:self didEditContact:_settingConfigItemsDefaultValues];
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
    return _settingConfigItems.count;
}
//某区某行显示什么
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifierStr = @"ADVehicleSettingConfigEditViewController.cell";
    ADVehicleSettingConfigCell*cell = [tableView dequeueReusableCellWithIdentifier:identifierStr];
//    if (!cell) {
        cell = [[ADVehicleSettingConfigCell alloc]initWithFrame:CGRectZero];
//    }
    if(_settingConfigItemsDefaultValues.count!=0&&_settingConfigItemsDefaultValues[indexPath.row]!=[NSNull null]){
        if(indexPath.row==0){
            cell.valueTextField.text=_settingConfigItemsDefaultValues[0];
            cell.valueTextField.tag=100;
        }else if (indexPath.row==1){
            cell.valueTextField.text=_settingConfigItemsDefaultValues[2];
            cell.valueTextField.tag=102;
        }else if (indexPath.row==2){
            cell.valueTextField.text=_settingConfigItemsDefaultValues[16];
            cell.valueTextField.tag=116;
        }else if (indexPath.row==3){
            cell.valueTextField.text=_settingConfigItemsDefaultValues[21];
            cell.valueTextField.tag=121;
        }else{
            cell.valueTextField.text=@"";
        }
    }else{
        cell.valueTextField.text=@"";
    }
    
    
    cell.valueTextField.delegate=self;
//    cell.valueTextField.tag=indexPath.row+100;
    [cell.valueTextField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
//    if(indexPath.row==0){
//        [cell.valueTextField becomeFirstResponder];
//    }
//    cell.textLabel.text=_settingConfigItems[indexPath.row];
    cell.textLabel.text=NSLocalizedStringFromTable(_settingConfigItems[indexPath.row],@"MyString", @"");
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor=[UIColor whiteColor];
    return cell;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if(_settingConfigItemsDefaultValues.count==0){
        return;
    }
    [_settingConfigItemsDefaultValues replaceObjectAtIndex:textField.tag-100 withObject:textField.text];
    NSLog(@"%@",_settingConfigItemsDefaultValues);
}

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if(sender==[(UITextField *)self.view viewWithTag:121]){
        [sender becomeFirstResponder];
        [self hidenKeyboard];
    }
    else if(sender==[(UITextField *)self.view viewWithTag:100]){
        [(UITextField *)[self.view viewWithTag:102] becomeFirstResponder];
    }else if(sender==[(UITextField *)self.view viewWithTag:102]){
        [(UITextField *)[self.view viewWithTag:116] becomeFirstResponder];
    }else if(sender==[(UITextField *)self.view viewWithTag:116]){
        [(UITextField *)[self.view viewWithTag:121] becomeFirstResponder];
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
    if (textField.tag==121) {
        Y=-40;
        H=40;
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

@end
