//
//  ADModifyPhoneRentViewController.m
//  OBDClient
//
//  Created by hmc on 13/10/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADModifyPhoneRentViewController.h"

@interface ADModifyPhoneRentViewController ()

@end

@implementation ADModifyPhoneRentViewController

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
    self.title = @"修改号码";
    self.view.backgroundColor = [UIColor blackColor];
    if(IOS7_OR_LATER){
        UIView *views = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
        views.backgroundColor = [UIColor grayColor];
        [self.view addSubview:views];
    }
    
    [_phoneTextField.layer setCornerRadius:7];
    [_phoneTextField.layer setBorderWidth:1];
    [_phoneTextField.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    [_modifyBtn.layer setCornerRadius:7];
    [_modifyBtn.layer setBorderWidth:0.5];
    [_modifyBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
    [_modifyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _modifyBtn.backgroundColor = [UIColor lightGrayColor];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.phoneTextField.text = [defaults objectForKey:@"rentPhone"];
    [self.phoneTextField becomeFirstResponder];
    
    if(!IOS7_OR_LATER){
        [_modifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitButtonPressed:(id)sender
{
    if(_phoneTextField.text.length == 0){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"号码不能为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.phoneTextField.text forKey:@"rentPhone"];
    [defaults synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
