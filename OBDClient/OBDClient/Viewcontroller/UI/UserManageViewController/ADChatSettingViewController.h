//
//  ADChatSettingViewController.h
//  OBDClient
//
//  Created by hys on 20/8/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPP.h"

@interface ADChatSettingViewController : UIViewController<UIAlertViewDelegate>
{
    __weak IBOutlet UILabel *friendName;
    __weak IBOutlet UISwitch *mySwitch;
    __weak IBOutlet UIImageView *headImageView;
    __weak IBOutlet UIButton *deleteMemory;

}

@property (nonatomic, strong) XMPPJID *friendJid;

@property (nonatomic, strong) NSString *friendNameString;

@property (nonatomic, strong) NSString *chatWithUser;

- (IBAction)switchButtonPressed:(id)sender;

- (IBAction)deleteFriendButtonPressed:(id)sender;

- (IBAction)deleteMemory:(id)sender;

@end
