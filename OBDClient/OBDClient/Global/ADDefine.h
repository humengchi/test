//
//  ADDefine.h
//  OBDClient
//
//  Created by hys on 20/2/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#ifndef OBDClient_ADDefine_h
#define OBDClient_ADDefine_h

#define IOS7_OR_LATER	( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define DEVICE_IS_IPHONE5 ([[UIScreen mainScreen] bounds].size.height == 568)


#endif

//#define HMC             //车友登录
//
//#define LOGIN_XMPP      //车友登录-用户名密码和主界面登录的信息一样
//
//#define REGISTER_XMPP   //车友注册


#define USERID @"ChattingUserId"
#define PASS @"ChattingPasswd"
#define SERVER @"ChattingServer"