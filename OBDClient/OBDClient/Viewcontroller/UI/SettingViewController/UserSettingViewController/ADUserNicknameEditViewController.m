//
//  ADUserNicknameEditViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-12-12.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADUserNicknameEditViewController.h"

@interface ADUserNicknameEditViewController ()
@property (nonatomic) UITextField *nickNameTextField;
@end

@implementation ADUserNicknameEditViewController

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
    self.title=NSLocalizedStringFromTable(@"updateNickname",@"MyString", @"");
    UILabel *nickNameLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 110, 25)];
    nickNameLabel.text=NSLocalizedStringFromTable(@"nikcNameKey",@"MyString", @"");
    nickNameLabel.backgroundColor=[UIColor clearColor];
    nickNameLabel.textColor=[UIColor whiteColor];
    nickNameLabel.textAlignment=NSTextAlignmentRight;
    _nickNameTextField =[[UITextField alloc]initWithFrame:CGRectMake(125, 20, 160, 25)];
    _nickNameTextField.borderStyle=UITextBorderStyleRoundedRect;
    _nickNameTextField.text=[[ADSingletonUtil sharedInstance].userInfo objectForKey:@"fullname"];
    [self.view addSubview:nickNameLabel];
    [self.view addSubview:_nickNameTextField];
    
    UIBarButtonItem *doneButton=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(submitTap:)];
    self.navigationItem.rightBarButtonItem=doneButton;
    if (IOS7_OR_LATER) {
        doneButton.tintColor=[UIColor lightGrayColor];
        [nickNameLabel setFrame:CGRectMake(10, 84, 110, 25)];
        [_nickNameTextField setFrame:CGRectMake(125, 84, 160, 25)];
    }
	// Do any additional setup after loading the view.
}

-(void)submitTap:(id)sender{
    [self.delegate editNicknameViewController:self didEditContact:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].globalUserBase.userID,_nickNameTextField.text, nil]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
