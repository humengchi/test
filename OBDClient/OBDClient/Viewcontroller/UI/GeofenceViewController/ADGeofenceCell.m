//
//  ADGeofenceCell.m
//  OBDClient
//
//  Created by Holyen Zou on 13-5-10.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGeofenceCell.h"

@implementation ADGeofenceCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
       geofenceBase:(ADGeofenceBase *)aGeofenceBase
       buttonTarget:(id)aTarget
       buttonAction:(SEL)aButtonAction
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _geofenceBase = aGeofenceBase;
//        self.labelMargin = 10;
//        self.detailLabelMargin = 200;
        [self updateCellWithGeofenceBase:_geofenceBase];
        
        _search = [[BMKPoiSearch alloc]init];
        _search.delegate=self;
        
        CLLocationCoordinate2D pt = (CLLocationCoordinate2D){_geofenceBase.lat1,_geofenceBase.lng1};
//        [_search reverseGeocode:pt];
    }
    
    return self;
}

- (void)onGetPoiDetailResult:(BMKPoiSearch*)searcher result:(BMKPoiDetailResult*)poiDetailResult errorCode:(BMKSearchErrorCode)errorCode{
    self.detailTextLabel.text=poiDetailResult.address;
}

- (void)updateCellWithGeofenceBase:(ADGeofenceBase *)aGeofenceBase
{
    self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
//    self.textLabel.text = aGeofenceBase.geoName;
    if([aGeofenceBase.applyField isEqualToString:@"0"]){
        self.textLabel.text = [NSString stringWithFormat:@"%@(%@)",aGeofenceBase.geoName,NSLocalizedStringFromTable(@"geosuccess", @"MyString", @"")];
        
//        self.detailTextLabel.text =NSLocalizedStringFromTable(@"geosuccess",@"MyString", @"");
    }else{
        self.textLabel.text = [NSString stringWithFormat:@"%@(%@)",aGeofenceBase.geoName,NSLocalizedStringFromTable(@"geosync", @"MyString", @"")]; //等待同步
//        self.detailTextLabel.text =NSLocalizedStringFromTable(@"geosync",@"MyString", @"");
        if([aGeofenceBase.cmdType isEqualToString:@"0"]){
            self.textLabel.text = [NSString stringWithFormat:@"%@(%@)",aGeofenceBase.geoName,NSLocalizedStringFromTable(@"geodeleting", @"MyString", @"")];  //等待删除
//            self.detailTextLabel.text =NSLocalizedStringFromTable(@"geodeleting",@"MyString", @"");
        }
    }
    
//    [self updateStatus:aGeofenceBase.applyField];
}

- (void)updateStatus:(NSString *)aCheck
{
    UIImage *image;
    if ([aCheck isEqualToString:@"1"]) {
        image = [UIImage imageNamed:@"cell_accessory_check_on.png"];
    } else {
        image = [UIImage imageNamed:@"cell_accessory_check_off.png"];
    }
    [_statusButton setBackgroundImage:image forState:UIControlStateNormal];
    [_statusButton setBackgroundImage:image forState:UIControlStateHighlighted];
    [_statusButton setBackgroundImage:image forState:UIControlStateSelected];
}

- (IBAction)statusButtonTap:(id)sender
{

}

@end