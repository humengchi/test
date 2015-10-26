//
//  ADHistoryModel.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-17.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"
#import "ADHistoryPoint.h"
#import "NSDate+Helper.h"

#define KVO_HISTORY_PATH_NAME              @"historyPoints"
#define KVO_ALERT_PATH_NAME                @"alerts"
#define KVO_HISTORY_TRACK_POINTS_PATH_NAME @"trackPoints"
#define KVO_HISTORY_TRACKS_PATH_NAME @"historyTracks"

typedef enum
{
    HISTORYMODEL_NEW = 1,
    HISTORYMODEL_CONTINUE = 2,
    HISTORYMODEL_ALERT  =3,
    HISTORYMODEL_TRACKPOINTS = 4,
    HISTORYMODEL_TRACKS = 5
} ADHistoryModelRequestType;

extern NSString * const ADHistoryModelRequestSuccessNotification;
extern NSString * const ADHistoryModelRequestFailNotification;
extern NSString * const ADHistoryModelRequestTimeoutNotification;

extern NSString * const ADHistoryModelRequestAlertsSuccessNotification;
extern NSString * const ADHistoryModelRequestAlertsFailNotification;
extern NSString * const ADHistoryModelRequestAlertsTimeoutNotification;

extern NSString * const ADHistoryModelLoginTimeOutNotification;

@interface ADHistoryModel : ADModelBase
{
    ADHistoryModelRequestType _requestType;
    NSInteger _row;//count of one page.default 1
    NSInteger _page;//current index of page.default 15
    NSInteger _count;//total count, just correct when user request all data.
}

@property (nonatomic, strong) NSMutableArray *historyPoints;

@property (nonatomic,strong) NSMutableArray *historyTracks;

@property (nonatomic, strong) NSMutableArray *alerts;

@property (nonatomic) NSMutableArray *trackPoints;

@property (nonatomic, strong) NSMutableDictionary *totalHistoryPoints;//key :NSDate ;value nsarray,handle data

- (void)requestHistoryWithMode:(ADHistoryModelRequestType)aRequestType
                      DeviceID:(NSString *)aDeviceID
                     startDate:(NSDate *)aStartDate
                       endDate:(NSDate *)aEndDate;

//- (void)requestAlertsWithDeviceID:(NSString *)aDeviceID
//                        startDate:(NSDate *)aStartDate
//                          endDate:(NSDate *)aEndDate;

- (void)requestAlertsWithDeviceID:(NSString *)aDeviceID
                        startDate:(NSDate *)aStartDate
                          endDate:(NSDate *)aEndDate
                             type:(NSString *)aType
                              row:(NSString *)aRow
                             page:(NSString *)aPage;

- (void)requestTrackPointsWithAcctID:(NSString *)aAcctID
                            DeviceID:(NSString *)aDeviceID
                           startDate:(NSDate *)aStartDate
                             endDate:(NSDate *)aEndDate;

@end
