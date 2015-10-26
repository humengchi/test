//
//  ADCarManagerItemViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-9-15.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADBaseViewController.h"

@interface ADCarManagerItemViewController : ADBaseViewController<UIWebViewDelegate>

@property (nonatomic) NSString *carManagerItemTitle;

@property (nonatomic, strong) IBOutlet UIWebView *helpWebView;
@end
