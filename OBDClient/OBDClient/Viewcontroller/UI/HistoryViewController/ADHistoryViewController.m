//
//  ADHistoryViewController.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-2.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHistoryViewController.h"
#import "ADHistoryByDayViewController.h"
#import "NSMutableArray+Helper.h"
#import "ADHistroyMapViewController.h"

#define ARC4RANDOM_MAX	0x100000000

@interface ADHistoryViewController ()<ADClickCellViewDelegate>

@end

@implementation ADHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _historyModel = [[ADHistoryModel alloc] init];
        
        _dates = [self calculateDateInfo];
        _viewControllerArray = [[NSMutableArray alloc] initWithCapacity:[_dates count]];
        for (NSUInteger k = 0; k < [_dates count]; ++k) {
            [_viewControllerArray addObject:[NSNull null]];
        }

        _currentSelectedIndex = [_dates count] - 1;
        [_historyModel addObserver:self
                        forKeyPath:KVO_HISTORY_TRACKS_PATH_NAME
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestFinished:)
                                                     name:ADHistoryModelRequestSuccessNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestFail:)
                                                     name:ADHistoryModelRequestAlertsFailNotification
                                                   object:nil];
        
        
    }
    return self;
}

- (void)dealloc
{
    [_historyModel removeObserver:self
                       forKeyPath:KVO_HISTORY_TRACKS_PATH_NAME];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADHistoryModelRequestSuccessNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:ADHistoryModelRequestAlertsFailNotification
                                                  object:nil];
}

- (void)requestFinished:(NSNotification *)aNoti
{
    
}

- (void)requestFail:(NSNotification *)aNoti
{
    [IVToastHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"NotrackrecordKey",@"MyString", @"")];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = NSLocalizedStringFromTable(@"historicaltrackKey",@"MyString", @"");
    self.view.backgroundColor=[UIColor whiteColor];
    //pageIndicatorView:

    [self.navigationController  setToolbarHidden:NO animated:NO];
    _pageIndicatorView = [[ADPageIndicatorView alloc] initWithFrame:CGRectMake(0,0, WIDTH, 44) dates:_dates];
    [self.navigationController.toolbar addSubview:_pageIndicatorView];
    self.navigationController.toolbar.backgroundColor=[UIColor clearColor];
    [self.navigationController.toolbar setBackgroundImage:[UIImage imageNamed:@"toolbar_bg.png"] forToolbarPosition:UIToolbarPositionBottom barMetrics:UIBarMetricsDefault];
    
    _lazyScrollView = [[DMLazyScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, self.view.bounds.size.height)];
    _lazyScrollView.controlDelegate = self;
    __weak __typeof(&*self)weakSelf = self;
    _lazyScrollView.dataSource = ^(NSUInteger index)
    {
        return [weakSelf controllerAtIndex:index];
    };
    _lazyScrollView.numberOfPages = [_dates count];
    [self.view addSubview:_lazyScrollView];
    [_lazyScrollView setPage:[_dates count] - 1 animated:NO];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
//        [_pageIndicatorView setFrame:CGRectMake(0, 64, WIDTH, 44)];
//        [_lazyScrollView setFrame:CGRectMake(0, 64, WIDTH, self.view.bounds.size.height)];
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        
	}

    
    
}

/* calculate the calendar does not use algorithm,following use the ios sdk to calculate.later will use algorithm replace of the sdk calculate. **/
- (NSArray *)calculateDateInfo
{
    /* gain the 2years date **/
    
    NSCalendar *currentCalendar = [NSCalendar currentCalendar];
    NSDate *currentDate = [NSDate date];
//    ADLogV(@"currentDate: %@",currentDate);
    NSDateComponents *dateComponents = [currentCalendar components:(NSYearCalendarUnit |
                                                                    NSMonthCalendarUnit |
                                                                    NSDayCalendarUnit |
                                                                    NSHourCalendarUnit |
                                                                    NSMinuteCalendarUnit |
                                                                    NSSecondCalendarUnit)
                                                          fromDate:currentDate];
    NSInteger iCurYear = [dateComponents year];
    NSInteger iCurMonth = [dateComponents month];
    NSInteger iCurDay = [dateComponents day];//将fromDate 按UTC时间来分解出本地时间,Fuck****
    
    NSMutableArray *totalDate = [NSMutableArray array];
    NSUInteger yearsAmount = 2;
    
    for (int i = iCurYear - (yearsAmount - 1); i <= iCurYear; i ++) {
        
        NSRange monthsOfOneYear;
        NSDate *dateForRange;
        if (i == iCurYear) {
            //current year:
            dateForRange = currentDate;
        } else
        {
            dateForRange = [NSDate dateWithYear:i month:1 day:1];
        }
        monthsOfOneYear = [currentCalendar rangeOfUnit:NSMonthCalendarUnit
                                                inUnit:NSYearCalendarUnit
                                               forDate:dateForRange];
        for (int j = 1; j <= monthsOfOneYear.length; j ++) {
            //calculate days in month.
            NSRange daysOfOneMonth = [currentCalendar rangeOfUnit:NSDayCalendarUnit
                                                           inUnit:NSMonthCalendarUnit
                                                          forDate:[NSDate dateWithYear:i month:j day:1]];
            for (int z = 1; z <= daysOfOneMonth.length; z ++) {
                if (i < iCurYear || (i == iCurYear && j < iCurMonth) || (i == iCurYear && j == iCurMonth && z <= iCurDay)) {
                    [totalDate addObject:[NSDate dateWithYear:i month:j day:z]];
                }
            }
        }
        
    }
    return totalDate;
}

- (void)updateDetailUI
{
//    [self requestHistorysByIndex:_currentSelectedIndex];
}

- (void)requestHistorysByIndex:(NSUInteger)aIndex
{
//    ADLogV(@"selected date:%@ next day:%@", [_dates objectAtIndex:aIndex],[(NSDate *)[_dates objectAtIndex:aIndex] dateByAddingTimeInterval:60*60*24*1]);
    NSDate *currentDay = [_dates objectAtIndex:aIndex];
    NSDate *nextDay = [currentDay dateByAddingTimeInterval:60*60*24*1];
    [_historyModel requestHistoryWithMode:HISTORYMODEL_TRACKS
                                 DeviceID:[ADSingletonUtil sharedInstance].currentDeviceBase.deviceID
                                startDate:currentDay
                                  endDate:nextDay];
}

- (UIViewController *)controllerAtIndex:(NSInteger)index
{
    if (index > _viewControllerArray.count || index < 0) return nil;
    id res = [_viewControllerArray objectAtIndex:index];
    if (res == [NSNull null]) {
        ADHistoryByDayViewController *contr = [[ADHistoryByDayViewController alloc] initWithNibName:nil bundle:nil];
        contr.delegate=self;
        [_viewControllerArray replaceObjectAtIndex:index withObject:contr];
        return contr;
    }
    return res;
}

- (void) clickCellViewController:(ADHistoryByDayViewController *) historyByDayView Argumets:(NSArray *)aArgumets{
    ADHistroyMapViewController *historyMapView=[[ADHistroyMapViewController alloc]initWithNibName:nil bundle:nil data:aArgumets];
    [self.navigationController pushViewController:historyMapView animated:YES];
//    [self presentViewController:historyMapView animated:YES completion:nil];
}

- (void)lazyScrollViewDidScroll:(DMLazyScrollView *)pagingView at:(CGPoint)visibleOffset
{
//    ADLogV(@"lazyScrollViewDidScroll visibleOffset: [%f, %f]",visibleOffset.x, visibleOffset.y);
}

- (void)lazyScrollViewDidEndDragging:(DMLazyScrollView *)pagingView
{
//    ADLogV(@"lazyScrollViewDidEndDragging");
}

- (void)lazyScrollViewDidEndDecelerating:(DMLazyScrollView *)pagingView atPageIndex:(NSInteger)pageIndex
{
//    ADLogV(@"lazyScrollViewDidEndDecelerating at %d", pageIndex);
}

- (void)lazyScrollView:(DMLazyScrollView *)pagingView
    currentPageChanged:(NSInteger)currentPageIndex
{
    _currentSelectedIndex = currentPageIndex;
    [_pageIndicatorView updateUIByIndex:currentPageIndex];
    [self requestHistorysByIndex:_currentSelectedIndex];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (object == _historyModel) {
        if ([keyPath isEqualToString:KVO_HISTORY_TRACKS_PATH_NAME]) {
            if(_historyModel.historyTracks.count==0){
                [IVToastHUD showSuccessWithStatus:NSLocalizedStringFromTable(@"NotrackrecordKey",@"MyString", @"")];
            }else{
                [(ADHistoryByDayViewController *)[_viewControllerArray objectAtIndex:_currentSelectedIndex] updateUIByDataSource:_historyModel.historyTracks];
            }
            
            return;
        }
    }
    
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return [[ADSingletonUtil sharedInstance].devices count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return ((ADDeviceBase *)[[ADSingletonUtil sharedInstance].devices objectAtIndex:row]).nickname;
}

@end
