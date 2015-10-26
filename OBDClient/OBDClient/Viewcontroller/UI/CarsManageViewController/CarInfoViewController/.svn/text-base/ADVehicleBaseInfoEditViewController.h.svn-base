//
//  ADVehicleBaseInfoEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-12-3.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"

@class ADVehicleBaseInfoEditViewController;
@protocol ADEditVehicleBaseInfoDelegate <NSObject>

- (void) editContactViewController:(ADVehicleBaseInfoEditViewController *) editViewController didEditContact:(NSArray * ) contact;

@end

@interface ADVehicleBaseInfoEditViewController : ADBaseViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic) NSDictionary *baseInfo;
@property (weak,nonatomic) id<ADEditVehicleBaseInfoDelegate> delegate;
@property (nonatomic) NSString * besavedNum;
@property (nonatomic) NSString * besavedType;
@property (nonatomic) BOOL refreshFlag;

@end
