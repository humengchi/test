//
//  SpeedDialCell.h
//  OBDClient
//
//  Created by hys on 30/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADSingletonUtil.h"

@protocol SpeedDialCellDelegate <NSObject>

- (void)setupPhone:(NSInteger)tag;

@end

@interface SpeedDialCell : UITableViewCell<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *speedDialName;
@property (weak, nonatomic) IBOutlet UILabel *speedPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *callButton;
@property (weak, nonatomic) IBOutlet UIButton *modifyTelButton;
@property (weak, nonatomic) IBOutlet UIImageView *seperatorLineImgView;
@property (strong, nonatomic) NSString *tel;

@property (nonatomic, strong) id<SpeedDialCellDelegate>delegate;
- (IBAction)CallButtonAction:(id)sender;

@end
