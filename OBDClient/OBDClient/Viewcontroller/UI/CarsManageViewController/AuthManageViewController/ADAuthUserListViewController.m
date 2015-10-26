//
//  ADAuthUserListViewController.m
//  OBDClient
//
//  Created by lbs anydata on 13-10-30.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADAuthUserListViewController.h"

@interface ADAuthUserListViewController ()

@end

@implementation ADAuthUserListViewController

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
    self.title=NSLocalizedStringFromTable(@"NewlyauthorizedusersKey",@"MyString", @"");
    _lab.text=NSLocalizedStringFromTable(@"PleaseinputtheauthorizeduserIDKey",@"MyString", @"");
    UIBarButtonItem *doneButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(authTap:)];
    
    self.navigationItem.rightBarButtonItem=doneButtonItem;
    
    
    if (IOS7_OR_LATER) {
        doneButtonItem.tintColor=[UIColor lightGrayColor];
    }
}

- (IBAction)authTap:(id)sender {
    if([self.authUserID.text isEqualToString:[ADSingletonUtil sharedInstance].globalUserBase.uname]){
        [IVToastHUD showAsToastErrorWithStatus:NSLocalizedStringFromTable(@"manageSelfKey",@"MyString", @"")];
        return;
    }
    [self.delegate editContactViewController:self didEditContact:[NSArray arrayWithObjects:[ADSingletonUtil sharedInstance].currentDeviceBase.d_vin,self.authUserID.text,nil]];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)viewDidUnload {
    [self setAuthUserID:nil];
    [self setLab:nil];
    [super viewDidUnload];
}
@end
