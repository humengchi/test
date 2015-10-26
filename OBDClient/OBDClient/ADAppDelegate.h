//
//  AppDelegate.h
//  OBDClient
//
//  Created by 胡梦驰 on 15/9/1.
//  Copyright (c) 2015年 胡梦驰. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADMainWindow.h"
#import <BaiduMapAPI/BMapKit.h>
#import "WXApi.h"
#import "ADUncaughtExceptionHandler.h"
#import "XMPPFramework.h"
//#import "Statics.h"
#import "BPush.h"
#import "KKChatDelegate.h"
#import "KKMessageDelegate.h"
#import "DDLog.h"
#import "DDTTYLogger.h"

#import "XMPPPing.h"
#import "XMPPReconnect.h"

#import <AudioToolbox/AudioToolbox.h>

#import "VoiceConverter.h"

#import <AVFoundation/AVFoundation.h>



#define GET_URL @"http://180.166.124.142:9983/im/getRec.php?fileName="

@interface ADAppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate, XMPPStreamDelegate, XMPPRoomDelegate>
{
    BMKMapManager *_mapManager;
    XMPPStream *xmppStream;
    XMPPPing *xmppPing;
    XMPPReconnect *xmppReconnect;
    XMPPRoomCoreDataStorage *xmppRoomStorage;
    XMPPRoom *xmppRoom;
    
    NSString *password;  //密码
    BOOL isOpen;  //xmppStream是否开着
    
    NSMutableArray *turnSockets;
}
@property (strong, nonatomic) ADMainWindow *window;

@property(nonatomic, readonly)XMPPStream *xmppStream;
@property(nonatomic, readonly)XMPPRoom *xmppRoom;

@property(nonatomic, retain)id chatDelegate;
@property(nonatomic, retain)id messageDelegate;

@property (strong,nonatomic) NSMutableData *bufferData;

- (void)connectViaXEP65:(XMPPJID *)jid;

//是否连接
-(BOOL)connect;
//断开连接
-(void)disconnect;

//设置XMPPStream
-(void)setupStream;
//上线
-(void)goOnline;
//下线
-(void)goOffline;

//注册新用户
-(void)registerUser;


//初始化群聊
-(void)initxmpproom;

//加入群聊
-(void)joinroom;

@end


