//
//  MessageViewController.h
//  OBDClient
//
//  Created by hys on 17/9/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADGetMessageGroupModel.h"
#import "ADSingletonUtil.h"
#import "ADWarnListViewController.h"
#import "ADSetReadFlagForAllMessageModel.h"
#import "MessageCell.h"
#import "ADWarnDetailViewController.h"
#include "ADDefine.h"

extern NSString * const ADNotificationTypeNotification;

@interface MessageViewController : UIViewController<ADGetMessageGroupDelegate,ADSetReadFlagForAllMessageDelegate,UITableViewDelegate,UITableViewDataSource>



@property(strong,nonatomic)UITableView* messageCenterTableView;

@property(strong,nonatomic)ADGetMessageGroupModel* getMessageGroupModel;

@property(strong,nonatomic)ADSetReadFlagForAllMessageModel* setReadFlagForAllMessageModel;

@property(strong,nonatomic)NSArray* messageGroupDataArray;


@end
