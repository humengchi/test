//
//  ADMessageTableViewCell.m
//  OBDClient
//
//  Created by hys on 17/7/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADMessageTableViewCell.h"

@implementation ADMessageTableViewCell

@synthesize delegate;

@synthesize senderAndTimeLabel, bgImageView,messageContentView, playBtn;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //日期标签
        senderAndTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 20)];
        senderAndTimeLabel.backgroundColor = [UIColor clearColor];
        //居中显示
        senderAndTimeLabel.textAlignment = NSTextAlignmentCenter;
        senderAndTimeLabel.font = [UIFont systemFontOfSize:11.0];
        //文字颜色
        senderAndTimeLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:senderAndTimeLabel];
        
        //背景图
        bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:bgImageView];
        
        //聊天信息
        messageContentView = [[UITextView alloc] init];
        messageContentView.backgroundColor = [UIColor clearColor];
        messageContentView.textColor = [UIColor whiteColor];
        //不可编辑
        messageContentView.editable = NO;
//        messageContentView.scrollEnabled = NO;
//        [messageContentView sizeToFit];
        [self.contentView addSubview:messageContentView];
        
        playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        playBtn.backgroundColor = [UIColor clearColor];        
        [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:playBtn];
    }
    
    return self;
    
}

- (IBAction)play:(UIButton*)sender
{
    [delegate playAudio:sender.tag];
}


- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
