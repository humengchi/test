//
//  ADUserManageViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-6-25.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "ADDevicesModel.h"
#import "ADUsersMapViewController.h"
#import "ADVehiclesModel.h"


@interface ADUserManageViewController : ADMenuBaseViewController <UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
//    BOOL _isAutoNavigation;
}
@property (nonatomic) BOOL isAutoNavigation;

@property (nonatomic, strong, readonly) ADDevicesModel *devicesModel;

@property (nonatomic) ADVehiclesModel *vehiclesModes;

@property (nonatomic, strong) ADDeviceBase *currentDeviceBase;

@property (nonatomic) ADDeviceBase *selectDevice;

-(void)setRefresh;

//@property (weak, nonatomic) IBOutlet ADCarsShowView *carsShowView;


@end