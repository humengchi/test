//
//  ADWebNewsViewController.h
//  OBDClient
//
//  Created by hys on 25/11/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADGetNewsModel.h"
#import "CarAssistantViewController.h"

@interface ADWebNewsViewController : UIViewController<ADGetNewsDelegate,UIWebViewDelegate>

@property(strong, nonatomic)UIActivityIndicatorView *acIndicator;

@property(strong,nonatomic)UIWebView* webView;

@property(strong,nonatomic)ADGetNewsModel* getNewsModel;

@property(strong,nonatomic)NSArray* newsArray;

@property(nonatomic)int ID;


@end
