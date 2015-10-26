//
//  ADDetailVehicleConditionViewController.h
//  OBDClient
//
//  Created by hys on 27/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarAssistantViewController.h"
#import "ADDetailVehicleConditionCell.h"
#import "ADVehiclesModel.h"
#import "ADDetailVehicleConditionCell.h"

#define degreesToRadians(x) (M_PI*(x)/180.0)
//extern NSString * const ADDetailVehicleConditionToCarNotification;

@interface ADDetailVehicleConditionViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)ADVehiclesModel* vehiclesModel;
@property(strong,nonatomic)UITableView* detailVehicleConditionTableView;
@property(strong,nonatomic)NSArray* detailVehicleConditionResultArray;
@property (weak, nonatomic) IBOutlet UIImageView *ballImgView;
@property (weak, nonatomic) IBOutlet UIImageView *arcImgView;
@property(strong,nonatomic)NSString* totalPoints;
@property (weak, nonatomic) IBOutlet UILabel *pointLabel;
@property(strong,nonatomic)CABasicAnimation* animation;
@property (weak, nonatomic) IBOutlet UIButton *restartButton;
@property (weak, nonatomic) IBOutlet UITextView *suggestTextView;

@property (weak, nonatomic) IBOutlet UILabel *ballPointLabel;
@property(strong,nonatomic)NSTimer* myTimer;

- (IBAction)returnBtnAction:(id)sender;

- (IBAction)restartCheckBtnAction:(id)sender;
@end
