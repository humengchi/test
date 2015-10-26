//
//  KKMessageDelegate.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-13.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKMessageDelegate <NSObject>

-(void)newMessageReceived:(NSDictionary *)messageContent;

@end
