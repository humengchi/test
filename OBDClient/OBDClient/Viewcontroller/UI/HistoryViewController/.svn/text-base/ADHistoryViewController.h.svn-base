//
//  ADHistoryViewController.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"
#import "DMLazyScrollView.h"
#import "ADPageIndicatorView.h"
#import "ADHistoryModel.h"
#import "NSDate+Helper.h"

@interface ADHistoryViewController : ADMenuBaseViewController <DMLazyScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    ADPageIndicatorView *_pageIndicatorView;
    DMLazyScrollView *_lazyScrollView;
    NSMutableArray *_viewControllerArray;
    ADHistoryModel *_historyModel;
    NSArray *_dates;
    NSUInteger _currentSelectedIndex;
}


@end
