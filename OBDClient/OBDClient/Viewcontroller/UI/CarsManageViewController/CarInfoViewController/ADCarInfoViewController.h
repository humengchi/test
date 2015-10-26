//
//  ADCarInfoViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "ADVehiclesModel.h"
@interface ADCarInfoViewController : ADMenuBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic) ADVehiclesModel *vehiclesModel;
@property (nonatomic) NSString *beSavedModelNumID;
@end
