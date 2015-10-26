//
//  ADVehicleCommandViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-11-4.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADVehicleCommandViewController.h"

@interface ADVehicleCommandViewController ()

@end

@implementation ADVehicleCommandViewController

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
    self.title=NSLocalizedStringFromTable(@"RemotecommandKey",@"MyString", @"");
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
