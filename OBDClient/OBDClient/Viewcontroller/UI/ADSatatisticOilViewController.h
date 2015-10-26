//
//  ADSatatisticOilViewController.h
//  OBDClient
//
//  Created by hys on 7/7/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#include "ADDefine.h"
#import "ADCountCenterModel.h"

@interface ADSatatisticOilViewController : UIViewController<CPTBarPlotDataSource,ADCountCenterDeleagte>

@property(strong,nonatomic)ADCountCenterModel* countCenterModel;

@property(strong,nonatomic)CPTXYGraph* barChart;

@property(strong,nonatomic)CPTBarPlot* barPlot;

@property(strong,nonatomic)CPTXYPlotSpace* plotSpace;

@property(strong,nonatomic)NSMutableArray *resultArray;

@property(strong,nonatomic)UILabel* monthMeliageCountLabel;

@property(strong,nonatomic)UILabel* dayAverageMeliageLabel;

@property(strong,nonatomic)UILabel* showTimeLabel;

@end
