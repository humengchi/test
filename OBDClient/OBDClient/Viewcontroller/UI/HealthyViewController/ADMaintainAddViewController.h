//
//  ADMaintainAddViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-10-16.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "ADMaintainModel.h"

@class ADMaintainAddViewController;
@protocol ADAddMaintainItemsDelegate <NSObject>

- (void) editContactViewController:(ADMaintainAddViewController *) vehicleMaintainItemsAddViewController;

@end

@interface ADMaintainAddViewController : ADMenuBaseViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic) UITableView *tableView;
@property (nonatomic) ADMaintainModel *maintainModel;
- (IBAction)saveTap:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *mileageTextField;
@property (weak, nonatomic) IBOutlet UILabel *maintainTimeLable;
@property (weak, nonatomic) IBOutlet UILabel *maintainMileageLabel;
@property (weak, nonatomic) IBOutlet UILabel *kmLabel;

@property(strong,nonatomic)UIDatePicker* datePicker;
@property(strong,nonatomic)NSDate* currentDate;
@property(strong,nonatomic)UIView* dateView;

@property (weak, nonatomic) id<ADAddMaintainItemsDelegate> delegate;
@end
