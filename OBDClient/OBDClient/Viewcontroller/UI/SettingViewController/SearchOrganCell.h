//
//  SearchOrganCell.h
//  OBDClient
//
//  Created by hys on 20/12/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const ADSendToUserLocationSettingNotification;

@interface SearchOrganCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnOne;
@property (weak, nonatomic) IBOutlet UIButton *btnTwo;
@property (weak, nonatomic) IBOutlet UIButton *btnThree;
@property (weak, nonatomic) IBOutlet UIButton *btnFour;
@property (weak, nonatomic) IBOutlet UILabel *labOne;
@property (weak, nonatomic) IBOutlet UILabel *labTwo;
@property (weak, nonatomic) IBOutlet UILabel *labThree;
@property (weak, nonatomic) IBOutlet UILabel *labFour;
- (IBAction)TurnPageAction:(id)sender;

@end
