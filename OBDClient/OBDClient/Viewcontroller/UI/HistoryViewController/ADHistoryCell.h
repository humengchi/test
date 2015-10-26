//
//  ADHistoryCell.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-27.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseCell.h"
#import "ADHistoryPoint.h"

@interface ADHistoryCell : ADBaseCell
{
    NSDictionary *_historyPoint;
}

@property (nonatomic)UILabel *startPointLabel;
@property (nonatomic)UILabel *stopPointLabel;
@property (nonatomic)UILabel *startTimeLabel;
@property (nonatomic)UILabel *stopTimeLabel;
@property (nonatomic)UILabel *meterLabel;
@property (nonatomic)UILabel *stopIntervalLabel;
@property (nonatomic)UILabel *leaveFuelLabel;
@property (nonatomic)UILabel *usedFuelLabel;
- (id)initWithFrame:(CGRect)frame;

- (void)updateUIByHistoryPoint:(NSDictionary *)aHistoryPoint andDrual:(NSString *)drual;


@end
