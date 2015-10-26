//
//  LatestInformationViewController.h
//  V3ViewController
//
//  Created by hys on 12/9/13.
//  Copyright (c) 2013年 hys. All rights reserved.
//

#import <UIKit/UIKit.h>
#include "ADDefine.h"


@interface LatestInformationViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIWebView* webView;

@end
