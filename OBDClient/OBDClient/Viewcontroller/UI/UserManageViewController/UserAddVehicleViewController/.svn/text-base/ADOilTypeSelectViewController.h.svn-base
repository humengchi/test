//
//  ADOilTypeSelectViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-12-5.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"
@class ADOilTypeSelectViewController;
@protocol ADSelectItemDelegate <NSObject>

- (void) selectItemViewController:(ADOilTypeSelectViewController *) selectViewController didSelectItem:(NSString * ) item;

@end

@interface ADOilTypeSelectViewController : ADBaseViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak,nonatomic)id<ADSelectItemDelegate>delegate;
@end
