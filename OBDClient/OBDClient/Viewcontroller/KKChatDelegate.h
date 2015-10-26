//
//  KKChatDelegate.h
//  XmppDemo
//
//  Created by 夏 华 on 12-7-13.
//  Copyright (c) 2012年 无锡恩梯梯数据有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KKChatDelegate <NSObject>

-(void)newBuddyOnline:(NSString *)buddyName;
-(void)buddyWentOffline:(NSString *)buddyName;
-(void)getRoster:(NSArray*)theArray;
-(void)didDisconnect;

@end
