//
//  ADSummaryModel.h
//  OBDClient
//
//  Created by hys on 7/3/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADModelBase.h"

@protocol ADSummaryDelegate;

typedef enum{
    SUMMARY_SETMELIAGE=1,
    SUMMARY_UPDATEMELIAGE=2
} ADSummaryRequestType;

@interface ADSummaryModel : ADModelBase{
    ADSummaryRequestType* _requestType;
    NSArray* _arguments;
    id<ADSummaryDelegate>summaryDelegate;
}


//delegate置为弱引用，否则影响内存释放
@property(weak,nonatomic)id<ADSummaryDelegate>summaryDelegate;

- (void)setTotalMeliage:(NSArray *)aArguments;

- (void)updateMeliage:(NSArray *)aArguments;

@end

@protocol ADSummaryDelegate <NSObject>

-(void)handleSetTotalMilageData:(NSDictionary*)dictionary;

-(void)handleUpdateMeliageDate:(NSDictionary*)dictionary;

@end