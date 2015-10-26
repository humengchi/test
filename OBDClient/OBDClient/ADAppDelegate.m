//
//  AppDelegate.m
//  OBDClient
//
//  Created by 胡梦驰 on 15/9/1.
//  Copyright (c) 2015年 胡梦驰. All rights reserved.
//

#import "ADAppDelegate.h"
#import "ADSingletonUtil.h"


@implementation ADAppDelegate
@synthesize xmppStream;
@synthesize chatDelegate;
@synthesize messageDelegate;
@synthesize xmppRoom;

@synthesize bufferData;

+ (void)initialize               //创建函数
{
    if (self == [ADAppDelegate class]) {
        [ADLogger init];//init logger first.
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions   //运行函数
{
#ifdef HMC
    //监听车友聊天登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connect) name:@"chattingConnect" object:nil];
#endif
    
    InstallUncaughtExceptionHandler();
    [WXApi registerApp:@"wx9be900165a720825"];
    NSUserDefaults *defaults =[NSUserDefaults standardUserDefaults];
    NSString *server_url = [defaults objectForKey:@"server_url"];
    NSString *server_url_zend = [defaults objectForKey:@"server_url_zend"];
    if((server_url==nil)||(server_url_zend==nil)){
        [defaults setObject:@"http://106.3.226.182/" forKey:@"server_url"];
        [defaults setObject:@"http://106.3.226.182/zend_obd/" forKey:@"server_url_zend"];//180.166.124.142:9983
        [defaults setObject:@"163服务器" forKey:@"server_name"];
        [defaults synchronize];
    }
    [defaults setObject:@"http://106.3.226.182/" forKey:@"server_url"];
    [defaults setObject:@"http://106.3.226.182/zend_obd/" forKey:@"server_url_zend"];//180.166.124.142:9983
    [defaults setObject:@"163服务器" forKey:@"server_name"];
    [defaults synchronize];
    [ADSingletonUtil sharedInstance].firstLogin = YES;
    
    _mapManager = [[BMKMapManager alloc] init];     //百度地图API的管理器创建
    BOOL ret = [_mapManager start:@"kTaZyN7YV0UYlFNO06BN1gpP" generalDelegate:nil];
    if (!ret) {
        ADLogE(@"manager start failed!");
    }
    
    [self customizeUIAppearence];       //对导航栏进行全局设置
    self.window = [[ADMainWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];  //返回的是带有状态栏的矩形
    
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //如果是第一次启动的话,使用UserGuideViewController (用户引导页面) 作为根视图
        ADUserGuideViewController *userGuideViewController = [[ADUserGuideViewController alloc] init];
        self.window.rootViewController = userGuideViewController;
        [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"isIgnore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        //如果不是第一次启动的话,使用LoginViewController作为根视图
        [self.window transitionToLoginViewController];     //跳转到登录界面
        
    }
    
    [self.window makeKeyAndVisible];         //让包含了视图控制器视图的Window窗口显示在屏幕
    
    [BPush registerChannel:launchOptions apiKey:@"KbYdK4HxQcdlChNwDEPDoHIf" pushMode:BPushModeProduction withFirstAction:@"打开" withSecondAction:@"关闭" withCategory:@"" isDebug:NO];
    // [BPush setAccessToken:@"3.ad0c16fa2c6aa378f450f54adb08039.2592000.1367133742.282335-602025"];  // 可选。api key绑定时不需要，也可在其它时机调用
    //消息推送注册
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings
                                                                             settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)
                                                                             categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
    }
    
    if (launchOptions != nil)
    {
        NSDictionary* dictionary = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (dictionary != nil)
        {
            NSLog(@"Launched from push notification: %@", dictionary);
            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
            [ADSingletonUtil sharedInstance].autoMsgCenter=YES;
            //            [self.window transitionToMainViewController];
        }
    }
    
    turnSockets = [[NSMutableArray alloc] init];
    
    return YES;
}

- (void)customizeUIAppearence
{
    UIColor *barColor = COLOR_RGB(255, 255, 255);//COLOR_RGB(44, 114, 184);
    UIColor *titleColor = COLOR_RGB(201, 200, 196);
    UIColor *itemColor =  COLOR_RGB(43, 43, 43);
    UIImage *barBkgImg = [UIImage imageNamed:@"app_topbar_bg~iphone.png"];
    NSDictionary *titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         titleColor,UITextAttributeTextColor,
                                         [UIColor blackColor], UITextAttributeTextShadowColor,
                                         [NSValue valueWithUIOffset:UIOffsetMake(1.f, 1.f)], UITextAttributeTextShadowOffset, nil];               //标题文本属性词典
    [[ADStyleNavigationBar appearance] setTintColor:barColor];     //设置导航栏的全局显示方式
    [[ADStyleNavigationBar appearance] setBackgroundImage:barBkgImg];    //设置导航栏的全局背景图片
    [[ADStyleNavigationBar appearance] setTitleTextAttributes:titleTextAttributes];   // 为导航栏设置全局标题文本属性
    [[UIBarButtonItem  appearance]  setTintColor:itemColor];
    //    [[ADStyleNavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    //    [[ADStyleNavigationBar appearance] setBackgroundColor:[UIColor blackColor]];
}

-(void) onResp:(BaseResp*)resp
{
    NSLog(@"res");
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
        NSString *strMsg;
        if(resp.errCode == 0){
            strMsg = @"分享成功！";
        }else{
            strMsg = @"分享失败！";
            //            strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        }
        //        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
#ifdef HMC
    [self disconnect];
#endif
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [BPush registerDeviceToken:deviceToken]; // 必须
    
    [BPush bindChannelWithCompleteHandler:^(id result, NSError *error) {
        NSDictionary* res = [[NSDictionary alloc] initWithDictionary:result];
        NSString *appid = [res valueForKey:BPushRequestAppIdKey];
        NSString *userid = [res valueForKey:BPushRequestUserIdKey];
        NSString *channelid = [res valueForKey:BPushRequestChannelIdKey];
        int returnCode = [[res valueForKey:BPushRequestErrorCodeKey] intValue];
        NSString *requestid = [res valueForKey:BPushRequestRequestIdKey];
        [ADSingletonUtil sharedInstance].push_appid = appid;
        [ADSingletonUtil sharedInstance].push_userid = userid;
        [ADSingletonUtil sharedInstance].push_channelid = channelid;
        NSLog(@"APPID:%@,USERID:%@,CHANNELID:%@,RETURNCODE:%d,REQUESTID:%@",appid,userid,channelid,returnCode,requestid);
    }]; // 必须。
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo      //处理接收到的push
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [BPush handleNotification:userInfo]; // 可选
    UIAlertView* alert=[[UIAlertView alloc]initWithTitle:@"" message:@"有新消息，是否查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
#ifdef HMC
    if([ADSingletonUtil sharedInstance].chattingIsLogin){
        [self connect];
    }
#endif
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if ([UIApplication sharedApplication].applicationIconBadgeNumber!=0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        [self.window transitionToMainViewController];
        [ADSingletonUtil sharedInstance].autoMsgCenter = YES;
        [self.window transitionToMainViewController];
    }
    //    [self connect];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [ADSingletonUtil sharedInstance].autoMsgCenter = YES;
        [self.window transitionToMainViewController];
    }
}

//XMPP方法method
-(void)setupStream{
    //初始化XMPPStream
    xmppStream = [[XMPPStream alloc] init];
    [xmppStream addDelegate:self delegateQueue:dispatch_get_current_queue()];
    //    dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    //dispatch_get_current_queue()
    xmppPing = [[XMPPPing alloc]init];
    xmppPing.respondsToQueries = YES;
    [xmppPing activate:xmppStream];
    xmppReconnect = [[XMPPReconnect alloc]init];
    xmppReconnect.autoReconnect = YES;
    [xmppReconnect activate:xmppStream];
    
}

-(void)goOnline{
    //发送在线状态
    XMPPPresence *presence = [XMPPPresence presence];
    [[self xmppStream] sendElement:presence];
}

-(void)goOffline{
    //发送下线状态
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    [[self xmppStream] sendElement:presence];
}

-(BOOL)connect{
    [self setupStream];
    //从本地取得用户名，密码和服务器地址
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
#ifndef LOGIN_XMPP
    [defaults setObject:@"zjf1" forKey:USERID];
    [defaults setObject:@"111111" forKey:PASS];
#endif
    [defaults setObject:@"180.166.124.142:9983" forKey:SERVER];   //180.166.124.142:9983  192.168.0.163
    [defaults synchronize];
    NSString *userId = [defaults stringForKey:USERID];
    NSString *pass = [defaults stringForKey:PASS];
    NSString *server = [defaults stringForKey:SERVER];
    
    if (![xmppStream isDisconnected]) {
        return YES;
    }
    if (userId == nil) {
        return NO;
    }
    //设置用户
    //    [xmppStream setMyJID:[XMPPJID jidWithString:userId]];
    xmppStream.myJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@pc163.anydata.sh",userId]];
    //设置服务器
    [xmppStream setHostName:server];
    //    [xmppStream setHostPort:(UInt16)9983];
    //密码
    password = pass;
    //连接服务器
    NSError *error = nil;
    if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
                                                            message:@"See console for error details."
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        DDLogError(@"Error connecting: %@", error);
        
        return NO;
    }
    return YES;
}

-(void)disconnect{
    [self goOffline];
    [xmppStream disconnect];
    
}

#pragma mark -XMPPRoom
-(void)initxmpproom
{
    xmppRoomStorage = [[XMPPRoomCoreDataStorage alloc] init];
    if (xmppRoomStorage==nil) {
        NSLog(@"nil");
        xmppRoomStorage = [[XMPPRoomCoreDataStorage alloc] init];
    }
    XMPPJID *roomJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@pc163.anydata.sh",@"groupchat2"]];
    xmppRoom = [[XMPPRoom alloc] initWithRoomStorage:xmppRoomStorage jid:roomJID
                                       dispatchQueue:dispatch_get_main_queue()];
    
    [xmppRoom activate:xmppStream];
    
    // 在聊天是显示的昵称
    [xmppRoom joinRoomUsingNickname:@"hmc" history:nil];
    
    [xmppRoom fetchConfigurationForm];
    
    [xmppRoom addDelegate:self delegateQueue:dispatch_get_main_queue()];
}

-(void)joinroom
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [xmppRoom fetchConfigurationForm];
    [xmppRoom joinRoomUsingNickname:[NSString stringWithFormat:@"%@@pc163.anydata.sh",[defaults stringForKey:USERID]] history:nil];
}

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
    [sender fetchConfigurationForm];
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
    DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}


#pragma mark -XMPPRoomDelegate
- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
    NSLog(@"群发言了。。。。");
    
    NSString *type = [[message attributeForName:@"type"] stringValue];
    if ([type isEqualToString:@"groupchat"]) {
        NSString *msg = [[message elementForName:@"body"] stringValue];
        //        NSString *timexx = [[message attributeForName:@"stamp"] stringValue];
        NSString *from = [[message attributeForName:@"from"] stringValue];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:msg forKey:@"body"];
        [dict setObject:from forKey:@"from"];
        
        //消息委托
        [messageDelegate newMessageReceived:dict];
    }
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    NSLog(@"新人加入群聊");
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID withPresence:(XMPPPresence *)presence
{
    NSLog(@"有人退出群聊");
}

#pragma mark -XmppStreamDelegate
//连接服务器
- (void)xmppStreamDidConnect:(XMPPStream *)sender{
    
    isOpen = YES;
    NSError *error = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults stringForKey:PASS] == nil){
        return;
    }
    //验证密码
    [[self xmppStream] authenticateWithPassword:password error:&error];
    
}

//验证通过
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    if(![ADSingletonUtil sharedInstance].chattingIsLogin)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoticeChattingLoginIsSuccess" object:@"success"];
    [self goOnline];
}

//验证失败
- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
    if(![ADSingletonUtil sharedInstance].chattingIsLogin)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NoticeChattingLoginIsSuccess" object:@"fail"];
    NSLog(@"验证失败!");
}

//收到消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    if(![[[message attributeForName:@"type"] stringValue] isEqualToString:@"chat"])
        return;
    NSString *msg = [[message elementForName:@"body"] stringValue];
    NSString *from = [[message attributeForName:@"from"] stringValue];
    
    if(msg == nil) return;
    //如果用户存在黑名单中，则消息收不到
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"] mutableCopy] containsObject:[[from componentsSeparatedByString:@"@"] firstObject]]){
        return;
    }
    //收到消息声音提示
    NSString *path = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    NSURL *url = [NSURL fileURLWithPath:path];
    SystemSoundID soundId;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundId);
    AudioServicesPlaySystemSound(soundId);
    //    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate); //震动
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    //存储接收到的语音消息
    if([msg hasPrefix:@"#*audio_s*"]){
        NSString *audioString = [msg substringFromIndex:10];
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMddhhmmss"];
        
        
        NSString *urlAsString = [NSString stringWithFormat:@"%@%@.amr", GET_URL, audioString];
        NSURL    *url = [NSURL URLWithString:urlAsString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSError *error = nil;
        NSData   *data = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil
                                                           error:&error];
        NSString *dateTime = [formatter stringFromDate:date];
        NSLog(@"url%@", urlAsString);
        /* 下载的数据 */
        if (data != nil){
            NSLog(@"下载成功");
            NSString* wavFileDirectory = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dateTime]stringByAppendingPathExtension:@"wav"];
            NSString *tempUrl = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:audioString]stringByAppendingPathExtension:@"amr"];
            if ([data writeToFile:tempUrl atomically:YES]) {
                NSData *tempData = [[NSData alloc] initWithContentsOfFile:tempUrl];
                NSLog(@"%lu---%lu", (unsigned long)data.length, (unsigned long)tempData.length);
                [VoiceConverter amrToWav:tempUrl wavSavePath:wavFileDirectory];
                
                [dict setObject:dateTime forKey:@"audioUrl"];
                [dict setObject:@"audio1211" forKey:@"msg"];
                [dict setObject:from forKey:@"sender"];
//                [dict setObject:[Statics getCurrentTime] forKey:@"time"];
                [dict setObject:@"2015-09-01" forKey:@"time"];
                
                NSData *wavData = [[NSData alloc] initWithContentsOfFile:wavFileDirectory];
                AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:wavFileDirectory] error:nil];
                NSLog(@"%lu", (unsigned long)wavData.length);
                
                [dict setObject:[NSString stringWithFormat:@"%d", ((int)player.duration)>60?60:((int)player.duration)] forKey:@"recoderVoiceTime"];
                NSString* chatWithUser = [NSString stringWithFormat:@"%@_%@", [self xmppStream].myJID.user, [[from componentsSeparatedByString:@"@"] firstObject]];
                NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
                NSMutableArray *theArray = [[NSMutableArray alloc] init];
                if([userDefault objectForKey:chatWithUser])
                    theArray = [[userDefault objectForKey:chatWithUser] mutableCopy];
                [theArray addObject:dict];
                [userDefault setObject:theArray forKey:chatWithUser];
                [userDefault synchronize];
            }
            else
            {
                NSLog(@"保存失败.");
            }
        } else {
            NSLog(@"%@", error);
        }
        
    }else{
        //存储接收到的消息
        [dict setObject:msg forKey:@"msg"];
        [dict setObject:from forKey:@"sender"];
        //        [dict setObject:[Statics getCurrentTime] forKey:@"time"];
        [dict setObject:@"2015-09-01" forKey:@"time"];
        NSString* chatWithUser = [NSString stringWithFormat:@"%@_%@", [self xmppStream].myJID.user, [[from componentsSeparatedByString:@"@"] firstObject]];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        if([userDefault objectForKey:chatWithUser])
            theArray = [[userDefault objectForKey:chatWithUser] mutableCopy];
        [theArray addObject:dict];
        [userDefault setObject:theArray forKey:chatWithUser];
        [userDefault synchronize];
    }
    //记录接收消息的数量
    NSString* chatWithUser = [NSString stringWithFormat:@"%@_%@", [self xmppStream].myJID.user, [[from componentsSeparatedByString:@"@"] firstObject]];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *key = [NSString stringWithFormat:@"%@_newsnumber", chatWithUser];
    if([userDefault objectForKey:key]){
        NSInteger n = [[userDefault objectForKey:key] integerValue];
        n++;
        [userDefault setObject:[NSString stringWithFormat:@"%d",n] forKey:key];
        [userDefault synchronize];
    }else{
        [userDefault setObject:@"1" forKey:key];
        [userDefault synchronize];
    }
    
    //设置最近联系人
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *_rosterArray = [[NSMutableArray alloc] init];
    if([userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]]){
        _rosterArray = [[userDefaults objectForKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]] mutableCopy];
    }
    NSString *userContacts = [NSString stringWithFormat:@"%@", [[from componentsSeparatedByString:@"@"] firstObject]];
    if([_rosterArray containsObject:userContacts]){
        if(_rosterArray.count == 1){
            [_rosterArray removeAllObjects];
        }else{
            [_rosterArray removeObject:userContacts];
        }
    }
    
    [_rosterArray insertObject:userContacts atIndex:0];
    [userDefaults setObject:_rosterArray forKey:[NSString stringWithFormat:@"%@_nearContactFriends", [self xmppStream].myJID.user]];
    [userDefaults synchronize];
    
    //通知好友列表有消息，基数+1（消息的数量），刷新tableview
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
    //消息委托(这个后面讲)
    
    //    接收到的所有未读的新消息
    NSString* allNumberChats = [NSString stringWithFormat:@"%@_ALLNUMBERCHAT", [self xmppStream].myJID.user];
    if([userDefault objectForKey:allNumberChats]){
        NSInteger n = [[userDefault objectForKey:allNumberChats] integerValue];
        n++;
        [userDefault setObject:[NSString stringWithFormat:@"%d",n] forKey:allNumberChats];
        [userDefault synchronize];
    }else{
        [userDefault setObject:@"1" forKey:allNumberChats];
        [userDefault synchronize];
    }
    //通知车友主界面获得到新的数据，更新UI
    [[NSNotificationCenter defaultCenter] postNotificationName:@"GETNEWINFO_ALLNUMBER" object:nil];
    [messageDelegate newMessageReceived:dict];
}

//收到好友状态
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    //取得好友状态
    NSString *presenceType = [presence type]; //online/offline
    //当前用户
    NSString *userId = [[sender myJID] user];
    //在线用户
    NSString *presenceFromUser = [[presence from] user];
    
    if (![presenceFromUser isEqualToString:userId]) {
        
        //在线状态
        if ([presenceType isEqualToString:@"available"]) {
            
            //用户列表委托(后面讲)
            [chatDelegate newBuddyOnline:[NSString stringWithFormat:@"%@", presenceFromUser]];
            
        }else if ([presenceType isEqualToString:@"unavailable"]) {
            //用户列表委托(后面讲)
            [chatDelegate buddyWentOffline:[NSString stringWithFormat:@"%@", presenceFromUser]];
        }
    }
}

//获取好友列表
- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
    if([@"get" isEqualToString:iq.type]){
        DDLogVerbose(@"---------- xmppStream:didReceiveIQ: ----------");
    }
    
    NSMutableArray *roster = [[NSMutableArray alloc] init];
    if ([@"result" isEqualToString:iq.type]) {
        NSXMLElement *query = iq.childElement;
        if([@"jabber:iq:roster" isEqualToString:query.xmlns]){
            if ([@"query" isEqualToString:query.name]) {
                NSArray *items = [query children];
                for (NSXMLElement *item in items) {
                    NSString *jid = [item attributeStringValueForName:@"jid"];
                    XMPPJID *xmppJID = [XMPPJID jidWithString:jid];
                    [roster addObject:xmppJID];
                }
            }
        }
    }
    //
    [chatDelegate getRoster:roster];
    
    return YES;
}

#pragma mark -register
- (void)xmppStreamDidRegister:(XMPPStream *)sender
{
    NSLog(@"register success!!");
}

- (void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error
{
    NSLog(@"register fail!!");
}

@end
