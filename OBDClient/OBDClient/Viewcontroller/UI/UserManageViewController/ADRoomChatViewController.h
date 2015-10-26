//
//  ADRoomChatViewController.h
//  OBDClient
//
//  Created by hmc on 13/11/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADAppDelegate.h"

@interface ADRoomChatViewController : ADBaseViewController

@property (nonatomic, strong) IBOutlet UITextField *sendtextfield;

- (IBAction)createRoom:(UIButton *)sender;

- (IBAction)joinRoom:(UIButton *)sender;

- (IBAction)sendPress:(UIButton *)sender;

@end
