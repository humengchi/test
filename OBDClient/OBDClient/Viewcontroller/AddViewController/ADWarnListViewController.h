//
//  ADWarnListViewController.h
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADGetGroupMessageModel.h"
#import "ADSingletonUtil.h"
#import "ADWarnCell.h"
#import "MessageViewController.h"
#import "ADSetReadFlagForGroupMessageModel.h"
#import "ADWarnDetailViewController.h"
#import "ADDeleteCurrentMessagesModel.h"
#import "IVToastHUD.h"


extern NSString* const ADWarnDetailNotification;

extern NSString* const ADWarnListReadFlagNotification;

@interface ADWarnListViewController : UIViewController<ADGetGroupMessageDelegate,UITableViewDelegate,UITableViewDataSource,ADSetReadFlagForGroupMessageDelegate,ADDeleteCurrentMessagesDelegate>



@property(strong,nonatomic)UITableView* warnListTableView;

@property(strong,nonatomic)NSMutableArray* currentDataArray;

@property(strong,nonatomic)ADGetGroupMessageModel* getGroupMessageModel;

@property(strong,nonatomic)ADSetReadFlagForGroupMessageModel* setReadFlagForGroupMessageModel;

@property(strong,nonatomic)ADDeleteCurrentMessagesModel* deleteCurrentMessagesModel;

@property(strong,nonatomic)NSString* currentNotificationType;

@property(strong,nonatomic)UIBarButtonItem *editItem;

@property(nonatomic)int deleteRow;


@end
