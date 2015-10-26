//
//  ADUserInfoEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-26.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"

@class ADUserInfoEditViewController;
@protocol ADEditUserInfoDelegate <NSObject>

- (void) editContactViewController:(ADUserInfoEditViewController *) editController didEditContact:(NSArray * ) contact;   //contact  [NSArray arrayWithObjects:[_userInfo objectForKey:@"userID"],newPsw,[_userInfo objectForKey:@"smsNum"],[_userInfo objectForKey:@"email"], nil]

@end

@interface ADUserInfoEditViewController : ADBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (weak, nonatomic) id<ADEditUserInfoDelegate> delegate;
@property (nonatomic) NSDictionary *userInfo;
@end
