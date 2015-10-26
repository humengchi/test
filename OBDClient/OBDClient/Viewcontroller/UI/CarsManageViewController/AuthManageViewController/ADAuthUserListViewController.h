//
//  ADAuthUserListViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-30.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"

@class ADAuthUserListViewController;
@protocol ADEditAuthInfoDelegate <NSObject>

- (void) editContactViewController:(ADAuthUserListViewController *) authUserEditViewController didEditContact:(NSArray * ) contact;

@end

@interface ADAuthUserListViewController : ADBaseViewController

@property (weak, nonatomic) IBOutlet UITextField *authUserID;
@property (weak, nonatomic) IBOutlet UILabel *lab;

@property (weak, nonatomic) id<ADEditAuthInfoDelegate> delegate;
@end
