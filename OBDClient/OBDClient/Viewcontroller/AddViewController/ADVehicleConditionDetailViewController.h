//
//  ADVehicleConditionDetailViewController.h
//  OBDClient
//
//  Created by hys on 25/2/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CarAssistantViewController.h"
#import "ADDetailVehicleConditionCell.h"
#import "ADVehiclesModel.h"
#import "ADDetailVehicleConditionCell.h"

#include "ADDefine.h"
#define degreesToRadians(x) (M_PI*(x)/180.0)

extern NSString * const ADDetailVehicleConditionToCarNotification;

@interface ADVehicleConditionDetailViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)ADVehiclesModel* vehiclesModel;
@property(strong,nonatomic)UITableView* detailVehicleConditionTableView;
@property(strong,nonatomic)UITableView* suggestionTableView;
@property(strong,nonatomic)NSArray* detailVehicleConditionResultArray;
@property(strong,nonatomic)NSMutableArray* suggestionResultArray;
@property(strong,nonatomic)UIImageView* ballImgView;
@property(strong,nonatomic)UIImageView* arcImgView;
@property(strong,nonatomic)NSString* totalPoints;
@property(strong,nonatomic)UILabel* pointLabel;
@property(strong,nonatomic)CABasicAnimation* animation;
@property(strong,nonatomic)UIButton* returnButton;
@property(strong,nonatomic)UIButton* restartButton;
@property(strong,nonatomic)UITextView* suggestTextView;
@property(strong,nonatomic)UILabel* ballPointLabel;
@property(strong,nonatomic)NSTimer* myTimer1;



@end










