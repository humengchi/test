//
//  SpeedDialCell.m
//  OBDClient
//
//  Created by hys on 30/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "SpeedDialCell.h"

@implementation SpeedDialCell
@synthesize delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)CallButtonAction:(id)sender {
    UIButton* btn=(UIButton*)sender;
    int tag=btn.tag;
    if(tag >= 20){
        if(tag == 20 || tag == 22){
            [delegate setupPhone:1];
        }else if(tag == 21){
            [delegate setupPhone:2];
        }else{
            [delegate setupPhone:3];
        }
        return;
    }
//    switch (tag) {
//        case 10:
//            self.tel = @"111";
//            break;
//        case 11:
//            self.tel = @"112";
//            break;
//        case 12:
//            if(![[ADSingletonUtil sharedInstance].currentDeviceBase.customerServicePhone isEqualToString:@""]){
//                self.tel = [ADSingletonUtil sharedInstance].currentDeviceBase.customerServicePhone;
//            }
//            break;
//        case 13:
//            self.tel = @"96822";
//            break;
//        case 14:
//            self.tel = @"110";
//            break;
//        case 15:
//            self.tel = @"120";
//        default:
//            break;
//    }
    if(self.tel.length){
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"是否拨打%@", self.tel] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alertview.tag = tag;
        [alertview show];
    }else{
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"对不起您还未设置快捷号码！\n是否现在设置？" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        alertview.tag = 10+tag;
        [alertview show];
    }
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag > 16){
        if(buttonIndex == 0){
            NSLog(@"%d", alertView.tag);
        }else{
            NSLog(@"%d", alertView.tag);
            if(alertView.tag == 20 || alertView.tag == 22){
                [delegate setupPhone:1];
            }else if(alertView.tag == 21){
                [delegate setupPhone:2];
            }else{
                [delegate setupPhone:3];
            }
        }
    }else{
        if(buttonIndex == 0){
            NSLog(@"%d", alertView.tag);
        }else{
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.tel]]];
            NSLog(@"%d", alertView.tag);
        }
    }
}
@end
