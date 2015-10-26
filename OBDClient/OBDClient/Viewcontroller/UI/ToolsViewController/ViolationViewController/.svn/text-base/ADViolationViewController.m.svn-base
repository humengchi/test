//
//  ADViolationViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-9-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADViolationViewController.h"

@interface ADViolationViewController ()

@end

@implementation ADViolationViewController

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
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]];
    self.title=self.toolTitle;
    self.navigationItem.leftBarButtonItem=nil;
    // Do any additional setup after loading the view from its nib.
//    UIImageView* imgView=[[UIImageView alloc]initWithFrame:self.view.frame];
//    imgView.image=[UIImage imageNamed:@"weizhangchaxun.png"];
//    [self.view addSubview:imgView];
    
    
    _lab1.text=NSLocalizedStringFromTable(@"DrivinglicensenumberKey",@"MyString", @"");
    
    _lab2.text=NSLocalizedStringFromTable(@"enginenumberKey",@"MyString", @"");
    
    _lab3.text=NSLocalizedStringFromTable(@"areaKey",@"MyString", @"");
    
    [_queryBtn setTitle:NSLocalizedStringFromTable(@"queryKey",@"MyString", @"") forState:UIControlStateNormal];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLab1:nil];
    [self setLab2:nil];
    [self setLab3:nil];
    [self setQueryBtn:nil];
    [self setLab3:nil];
    [super viewDidUnload];
}
@end
