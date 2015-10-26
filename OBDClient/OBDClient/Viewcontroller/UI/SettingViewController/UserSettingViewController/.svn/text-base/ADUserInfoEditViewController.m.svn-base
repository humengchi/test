//
//  ADUserInfoEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserInfoEditViewController.h"

@interface ADUserInfoEditViewController ()
@property (nonatomic) UITableView *tableView;
@property (nonatomic) NSArray *dataItems;

@end

@implementation ADUserInfoEditViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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

    _tableView.backgroundColor=[UIColor clearColor];
    _tableView.backgroundView=nil;
    _tableView.autoresizingMask=UIViewAutoresizingFlexibleHeight;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
    
    _dataItems=[NSArray arrayWithObjects:NSLocalizedStringFromTable(@"userPasswordOldKey",@"MyString", @""),NSLocalizedStringFromTable(@"userPasswordKey",@"MyString", @""),NSLocalizedStringFromTable(@"userPasswordRepeatKey",@"MyString", @""), nil];
    
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

-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender==[(UITextField *)self.view viewWithTag:99+_dataItems.count]){
        [sender becomeFirstResponder];
        [self resumeView];
    }else if(sender==[(UITextField *)self.view viewWithTag:sender.tag] ){
        [(UITextField *)[self.view viewWithTag:sender.tag+1] becomeFirstResponder];
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
    if (textField.tag>102) {
        Y=-100.0f;
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

- (void)viewWillAppear:(BOOL)animated{
    self.title=NSLocalizedStringFromTable(@"resetPsw",@"MyString", @"");
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitTap:)];
    self.navigationItem.rightBarButtonItem=barButton;
    if (IOS7_OR_LATER) {
        barButton.tintColor=[UIColor lightGrayColor];
    }
}

-(void)submitTap:(id)sender{
    UITextField * oldPswTextField=(UITextField *)[self.view viewWithTag:100];
    UITextField * newPswTextField=(UITextField *)[self.view viewWithTag:101];
    UITextField * newPswRepeatTextField=(UITextField *)[self.view viewWithTag:102];
//    UITextField * smsNumTextField=(UITextField *)[self.view viewWithTag:103];
//    UITextField * emailTextField=(UITextField *)[self.view viewWithTag:104];
    
    NSString *oldPsw=oldPswTextField.text;
    NSString *newPsw=newPswTextField.text;
    NSString *newPswRepeat=newPswRepeatTextField.text;
//    NSString *smsNum=smsNumTextField.text;
//    NSString *email=emailTextField.text;
    
    if(![oldPsw isEqualToString:[_userInfo objectForKey:@"passwd"]]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"oldpswerr",@"MyString", @"")];
        return;
    }else if (![newPsw isEqualToString:newPswRepeat]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"newpswerr",@"MyString", @"")];
        return;
    }else if ([newPsw isEqualToString: @""]||[newPswRepeat isEqualToString:@""]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"newpswnil",@"MyString", @"")];
        return;
    }else if (newPsw.length<6||![[ADSingletonUtil sharedInstance] isRulesString:newPsw]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"newpswsimple",@"MyString", @"")];
        return;
    }
    else{
        [self.delegate editContactViewController:self didEditContact:[NSArray arrayWithObjects:[_userInfo objectForKey:@"userID"],newPsw,[_userInfo objectForKey:@"smsNum"],[_userInfo objectForKey:@"email"], nil]];
        [self.navigationController popViewControllerAnimated:YES];
    }
    

    
    
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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = _dataItems[indexPath.row];
    cell.backgroundColor=[UIColor whiteColor];
    cell.accessoryType=UITableViewCellAccessoryNone;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    UITextField *valueField=[[UITextField alloc]initWithFrame:CGRectMake(150, 10, 150, 24)];
    valueField.borderStyle=UITextBorderStyleNone;
    valueField.textAlignment=NSTextAlignmentLeft;
    valueField.tag=indexPath.row+100;
    valueField.delegate=self;
    valueField.secureTextEntry=YES;
    [cell addSubview:valueField];
    
    if(indexPath.row==0){
        valueField.text = @"";
        [valueField becomeFirstResponder];
    }else if (indexPath.row==1){
        valueField.text = @"";
    }else if (indexPath.row==2){
        valueField.text = @"";
    }
//    else if (indexPath.row==3){
//        valueField.text = [_userInfo objectForKey:@"smsNum"];
//    }else if (indexPath.row==4){
//        valueField.text = [_userInfo objectForKey:@"email"];
//    }    
    [valueField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    // Configure the cell...
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
