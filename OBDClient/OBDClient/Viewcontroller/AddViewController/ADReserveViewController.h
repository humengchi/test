//
//  ADReserveViewController.h
//  OBDClient
//
//  Created by hys on 4/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADReserveModel.h"
#import "ADSingletonUtil.h"
#import "ADReserveHistoryViewController.h"
#import "IVToastHUD.h"

#include "ADDefine.h"

@interface ADReserveViewController : UIViewController<UITextViewDelegate,ADReserveDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
- (IBAction)dateButtonAction:(id)sender;

@property(strong,nonatomic)UIView* dateView;
@property(strong,nonatomic)UIDatePicker* datePicker;

@property (weak, nonatomic) IBOutlet UITextView *remarksTextView;

@property(strong,nonatomic)ADReserveModel* reserveModel;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

- (IBAction)selectType:(id)sender;

- (IBAction)submitAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *ImgViewZero;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *ImgViewThree;

@property(nonatomic)NSInteger type;
@property(strong,nonatomic)NSString* date;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *currentCarLabel;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UIImageView *line3;
@property (weak, nonatomic) IBOutlet UIImageView *line4;
@property (weak, nonatomic) IBOutlet UIImageView *line5;
@property (weak, nonatomic) IBOutlet UIImageView *line6;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *lab4;
@property (weak, nonatomic) IBOutlet UIButton *BtnZero;
@property (weak, nonatomic) IBOutlet UILabel *lab5;
@property (weak, nonatomic) IBOutlet UIButton *BtnOne;
@property (weak, nonatomic) IBOutlet UILabel *lab6;
@property (weak, nonatomic) IBOutlet UIButton *BtnTwo;
@property (weak, nonatomic) IBOutlet UILabel *lab7;
@property (weak, nonatomic) IBOutlet UIButton *BtnThree;
@property (weak, nonatomic) IBOutlet UILabel *lab8;
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UILabel *lab9;

@end
