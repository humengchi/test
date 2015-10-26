//
//  ADToolsViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//
#import "ADMenuBaseViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface ADToolsViewController : ADMenuBaseViewController<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *arr;

@end
