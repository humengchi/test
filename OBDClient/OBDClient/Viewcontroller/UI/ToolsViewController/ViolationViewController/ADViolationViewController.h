//
//  ADViolationViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-18.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADMenuBaseViewController.h"

@interface ADViolationViewController : ADMenuBaseViewController
@property (nonatomic) NSString *toolTitle;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@end
