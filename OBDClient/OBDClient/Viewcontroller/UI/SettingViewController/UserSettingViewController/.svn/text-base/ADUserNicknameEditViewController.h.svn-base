//
//  ADUserNicknameEditViewController.h
//  OBDClient
//
//  Created by lbs anydata on 13-12-12.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADBaseViewController.h"

@class ADUserNicknameEditViewController;
@protocol ADEditUserNicknameDelegate <NSObject>

- (void) editNicknameViewController:(ADUserNicknameEditViewController *) editController didEditContact:(NSArray * ) contact;

@end

@interface ADUserNicknameEditViewController : ADBaseViewController
@property (weak,nonatomic) id<ADEditUserNicknameDelegate>delegate;
@end
