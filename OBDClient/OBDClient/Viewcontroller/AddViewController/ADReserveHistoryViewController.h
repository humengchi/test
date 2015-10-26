//
//  ADReserveHistoryViewController.h
//  OBDClient
//
//  Created by hys on 19/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADReserveModel.h"
#import "ADReserveHistoryCell.h"
#import "ADSingletonUtil.h"

#include "ADDefine.h"

@interface ADReserveHistoryViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,ADReserveDelegate>

@property(strong,nonatomic)UITableView* reserveHistoryTableView;

@property(strong,nonatomic)ADReserveModel* reserveModel;

@property(strong,nonatomic)NSArray* dataArray;

- (IBAction)historyButtonAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *BtnOne;
@property (weak, nonatomic) IBOutlet UIButton *BtnTwo;
@property (weak, nonatomic) IBOutlet UIButton *BtnThree;
@property (weak, nonatomic) IBOutlet UIButton *BtnFour;
@property (weak, nonatomic) IBOutlet UIButton *BtnFive;
@property (weak, nonatomic) IBOutlet UIImageView *LineOne;
@property (weak, nonatomic) IBOutlet UIImageView *LineTwo;
@property (weak, nonatomic) IBOutlet UIImageView *LineThree;
@property (weak, nonatomic) IBOutlet UIImageView *LineFour;
@property (weak, nonatomic) IBOutlet UIImageView *LineFive;
@end
