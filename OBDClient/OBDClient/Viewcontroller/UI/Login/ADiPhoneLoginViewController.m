//
//  ADiPhoneLoginViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADiPhoneLoginViewController.h"

@interface ADiPhoneLoginViewController ()

@end

@implementation ADiPhoneLoginViewController

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
    
}

- (void)loginTap:(id)sender
{
    [super loginTap:sender];
}

-(void)registerButton:(id)sender{
    [super registerButton:sender];
}
- (void)visitorTap:(id)sender {
    [super visitorTap:sender];
}

- (void)viewDidUnload {
//    [self setLoginBtn:nil];
//    [self setRegisterBtn:nil];
    [super viewDidUnload];
}
@end
