//
//  ADMessageTableViewCell.h
//  OBDClient
//
//  Created by hys on 17/7/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ADMessageTableViewCellDelegate <NSObject>

- (void)playAudio:(NSInteger)row;

@end

@interface ADMessageTableViewCell : UITableViewCell

@property(nonatomic, retain) UILabel *senderAndTimeLabel;
@property(nonatomic, retain) UITextView *messageContentView;
@property(nonatomic, retain) UIImageView *bgImageView;
@property(nonatomic, retain) IBOutlet UIButton *playBtn;
@property(nonatomic, strong) id<ADMessageTableViewCellDelegate> delegate;

@end
