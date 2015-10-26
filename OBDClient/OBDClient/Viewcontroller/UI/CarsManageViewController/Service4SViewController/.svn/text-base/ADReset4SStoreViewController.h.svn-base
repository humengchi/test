//
//  ADReset4SStoreViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-11-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
#import "ADVehiclesModel.h"
@class ADReset4SStoreViewController;
@protocol ADEditBind4sInfoDelegate <NSObject>

-(void)editContactViewController:(ADReset4SStoreViewController *)viewController didEditContact:(NSArray *)editContact;

@end

@interface ADReset4SStoreViewController : ADBaseViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic) UISearchBar *searchBar;
@property (nonatomic) UISearchDisplayController *displayController;
@property (nonatomic) UITableView *tableView;
@property (nonatomic) UITableView *resultTableView;
@property (weak,nonatomic) id<ADEditBind4sInfoDelegate> delegate;

@property (nonatomic) ADVehiclesModel *vehiclesModel;
@end
