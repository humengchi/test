//
//  QueryResultsViewController.h
//  OBDClient
//
//  Created by hys on 26/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QueryResultsCell.h"
#import "PeripheralViewController.h"

@interface QueryResultsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView* queryResultsTableView;

@end
