//
//  ADUserDriverLicenseEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"

@class ADUserDriverLicenseEditViewController;
@protocol ADEditUserDriverLicenseInfoDelegate <NSObject>

- (void) editContactViewController:(ADUserDriverLicenseEditViewController *) editController didEditContact:(NSArray * ) contact;

@end


@interface ADUserDriverLicenseEditViewController : ADBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic) NSDictionary *DriverLicenseInfo;
@property (weak,nonatomic) id<ADEditUserDriverLicenseInfoDelegate> delegate;
@end
