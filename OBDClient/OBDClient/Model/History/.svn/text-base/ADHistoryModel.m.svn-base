//
//  ADHistoryModel.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-17.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADHistoryModel.h"

NSString * const ADHistoryModelRequestSuccessNotification = @"ADHistoryModelRequestSuccessNotification";
NSString * const ADHistoryModelRequestFailNotification = @"ADHistoryModelRequestFailNotification";
NSString * const ADHistoryModelRequestTimeoutNotification = @"ADHistoryModelRequestTimeoutNotification";

NSString * const ADHistoryModelRequestAlertsSuccessNotification = @"ADHistoryModelRequestAlertsSuccessNotification";
NSString * const ADHistoryModelRequestAlertsFailNotification = @"ADHistoryModelRequestAlertsFailNotification";
NSString * const ADHistoryModelRequestAlertsTimeoutNotification = @"ADHistoryModelRequestAlertsTimeoutNotification";
NSString * const ADHistoryModelLoginTimeOutNotification = @"ADHistoryModelLoginTimeOutNotification";

@implementation ADHistoryModel

- (id)init
{
    if (self = [super init]) {
        self.totalHistoryPoints = [[NSMutableDictionary alloc] init];
        self.historyPoints = [[NSMutableArray alloc] init];
        _requestType = HISTORYMODEL_NEW;
        _row = 30;
        _page = 1;
    }
    return self;
}

//存入 字典中
- (void)handleReceiveData:(NSArray *)aDataArray
{
    NSMutableArray *diffDate = [NSMutableArray array];
    for (ADHistoryPoint *historyPoint in aDataArray)
    {
        BOOL hasDate = NO;
        for (NSString *dateStr in diffDate) {
            if ([dateStr isEqualToString:[historyPoint serverDate]]) {
                hasDate = YES;
                break;
            }
        }
        if (!hasDate) {
            [diffDate addObject:historyPoint.serverDate];
        }
        
    }
    
    for (NSString *key in diffDate) {
        NSMutableArray *arrayTem = [NSMutableArray array];
        for (ADHistoryPoint *historyPoint in aDataArray) {
            if ([key isEqualToString:historyPoint.serverDate]) {
                [arrayTem addObject:historyPoint];
            }
        }        
        
        NSMutableArray *array = [self.totalHistoryPoints objectForKey:key];
        if (!array) {
            array = [NSMutableArray array];
        }
        [array addObjectsFromArray:arrayTem];
        [self.totalHistoryPoints setObject:array forKey:key];
    }
}

- (void)requestFinishedHandleWithData:(NSArray*)aDataArray
{
    if (_requestType == HISTORYMODEL_ALERT ||
        _requestType == HISTORYMODEL_CONTINUE ||
        _requestType == HISTORYMODEL_NEW ||
        _requestType == HISTORYMODEL_TRACKS) {
        NSMutableArray *historyPointTempArray = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (ASObject *asObject in aDataArray) {
            NSDictionary *data = [asObject properties];
            [historyPointTempArray addObject:data];
        }
        if (_requestType == HISTORYMODEL_CONTINUE || _requestType == HISTORYMODEL_NEW) {
            
            self.historyPoints = historyPointTempArray;
            [self postSuccessNoti];
            
        } else if (_requestType == HISTORYMODEL_ALERT) {
            self.alerts = historyPointTempArray;
            [self postSuccessNoti];
        }else if (_requestType == HISTORYMODEL_TRACKS){
            [self postSuccessNoti];
            self.historyTracks =historyPointTempArray;
        }
    }else if (_requestType==HISTORYMODEL_TRACKPOINTS){
        NSMutableArray *historyPointTempArray = [[NSMutableArray alloc] initWithCapacity:[aDataArray count]];
        for (ASObject *asObject in aDataArray) {
            NSDictionary *data = [asObject properties];
//            if([[data objectForKey:@"latitude"] intValue]!=0||[[data objectForKey:@"longitude"] intValue]!=0){
//            NSLog(@"%@",[data objectForKey:@"code"]);
                [historyPointTempArray addObject:data];
//            }
        }
        [self postSuccessNoti];
        self.trackPoints = historyPointTempArray;
    }
    else {
        NSAssert(0, @"not handle request type");
    }
}

- (void)requestAlertsWithDeviceID:(NSString *)aDeviceID
                        startDate:(NSDate *)aStartDate
                          endDate:(NSDate *)aEndDate
                             type:(NSString *)aType
                              row:(NSString *)aRow
                             page:(NSString *)aPage
{
    _requestType = HISTORYMODEL_ALERT;
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLog(@"%@-----%@",[format stringFromDate:aStartDate],[format stringFromDate:aEndDate]);
    NSArray *argus = [NSArray arrayWithObjects:aDeviceID, [format stringFromDate:aStartDate], [format stringFromDate:aEndDate], aType, aRow, aPage, nil];
    [super startCallWithService:API_DEVICE_HISTORY_SERVICE
                         method:API_DEVICE_HISTORYS_METHOD
                      arguments:[self argumentConfig:argus]];
}

- (void)requestHistoryWithMode:(ADHistoryModelRequestType)aRequestType
                      DeviceID:(NSString *)aDeviceID
                     startDate:(NSDate *)aStartDate
                       endDate:(NSDate *)aEndDate
{
    _requestType=aRequestType;
    NSString *startDate = [[NSString stringWithFormat:@"%@",aStartDate] substringToIndex:20];
    NSString *endDate = [[NSString stringWithFormat:@"%@",aEndDate] substringToIndex:20];
    
    NSArray *argus = [NSArray arrayWithObjects:@"obd_demo",aDeviceID, startDate, endDate,nil];
    [super startCallWithService:API_DEVICE_HISTORY_SERVICE
                         method:API_DEVICE_HISTORY_METHOD
                      arguments:argus];
}

- (void)requestTrackPointsWithAcctID:(NSString *)aAcctID
                            DeviceID:(NSString *)aDeviceID
                           startDate:(NSDate *)aStartDate
                             endDate:(NSDate *)aEndDate
{
    _requestType=HISTORYMODEL_TRACKPOINTS;
    [super startCallWithService:API_DEVICE_HISTORY_SERVICE method:API_DEVICE_HISTORY_TRACKPOINTS_METHOD arguments:[NSArray arrayWithObjects:aAcctID,aDeviceID,aStartDate,aEndDate, nil]];
}

- (void)postSuccessNoti
{
    if (_requestType == HISTORYMODEL_NEW || _requestType == HISTORYMODEL_CONTINUE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelRequestSuccessNotification
                                                            object:self];
    } else if (_requestType == HISTORYMODEL_ALERT) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelRequestAlertsSuccessNotification
                                                            object:self];
    }
}

- (void)postFailNoti
{
    if (_requestType == HISTORYMODEL_NEW || _requestType == HISTORYMODEL_CONTINUE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelRequestFailNotification
                                                            object:self];
    } else if (_requestType == HISTORYMODEL_ALERT) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelRequestAlertsFailNotification
                                                            object:self];
    }else if (_requestType == HISTORYMODEL_TRACKS) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelRequestAlertsFailNotification
                                                            object:self];
    }
}

- (void)postTimeoutNoti
{
    if (_requestType == HISTORYMODEL_NEW || _requestType == HISTORYMODEL_CONTINUE) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelRequestTimeoutNotification
                                                            object:self];
    } else if (_requestType == HISTORYMODEL_ALERT) {
        [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelRequestAlertsTimeoutNotification
                                                            object:self];
    }
}

- (void)remotingDidFinishHandleWithCall:(AMFRemotingCall *)aRemotingCall
                         receivedObject:(NSObject *)object
{
//    NSLog(@"%@",object);
    
    NSString *resultCode = [(NSDictionary *)object objectForKey:@"resultCode"];
    
    if ([resultCode isKindOfClass:[NSNull class]]) {
        [self postFailNoti];
        
        NSAssert(0,@"the data return, is null~. ADHistoryModel");
        return;
    }
    
    if ([resultCode isEqualToString:@"200"]) {
        NSArray *dataArray = [(NSDictionary *)object objectForKey:@"data"];
        [self requestFinishedHandleWithData:dataArray];
    }
    else
    {
        if (_requestType==HISTORYMODEL_ALERT) {
            if ([resultCode isEqualToString:@"202"]||[resultCode isEqualToString:@"203"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:ADHistoryModelLoginTimeOutNotification object:nil];
            }
        }
        _row = (_row - 1 > 1 ? 1 : _row - 1);
        [self postFailNoti];
    }
}

- (void)remotingDidFailHandleWithCall:(AMFRemotingCall *)aRemotingCall
                                error:(NSError *)aError
{
    _row = (_row - 1 > 1 ? 1 : _row - 1);
    [self postFailNoti];
}

#pragma mark -

- (void)insertHistoryPoints:(NSArray *)array atIndexes:(NSIndexSet *)indexes
{
    [_historyPoints insertObjects:array atIndexes:indexes];
}

- (void)insertObject:(ADHistoryPoint *)object inHistoryPointsAtIndex:(NSUInteger)index
{
    [_historyPoints insertObject:object atIndex:index];
}

@end
