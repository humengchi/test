//
//  ADRecentHistroyViewController.h
//  OBDClient
//
//  Created by hys on 7/7/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADRecentHistroyDelegate <NSObject>

- (void)fllush:(NSDate*)theDate;

@end

@interface ADRecentHistroyViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) IBOutlet UITableView *myTableView;
@property (nonatomic, retain) NSMutableArray *theArray;
@property (nonatomic, strong) id<ADRecentHistroyDelegate> delegate;

@end
