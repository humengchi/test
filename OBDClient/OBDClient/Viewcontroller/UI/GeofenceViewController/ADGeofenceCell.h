//
//  ADGeofenceCell.h
//  OBDClient
//
//  Created by Holyen Zou on 13-5-10.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseCell.h"
#import "ADGeofenceBase.h"
#import <BaiduMapAPI/BMapKit.h>

@interface ADGeofenceCell : UITableViewCell<BMKPoiSearchDelegate>
{
    UIButton *_statusButton;
    ADGeofenceBase *_geofenceBase;
    id __weak _buttonTarget;
    SEL _buttonAction;
    BMKPoiSearch *_search;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
       geofenceBase:(ADGeofenceBase *)aGeofenceBase
       buttonTarget:(id)aTarget
       buttonAction:(SEL)aButtonAction;

- (void)updateCellWithGeofenceBase:(ADGeofenceBase *)aGeofenceBase;

@end
