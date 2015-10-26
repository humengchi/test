//
//  ADGroupChatViewController.m
//  OBDClient
//
//  Created by hys on 26/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADGroupChatViewController.h"
#import "ADMessageTableViewCell.h"
#import "ADAppDelegate.h"
//#import "Statics.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
//#import "KKMessageCell.h"
#import "ADChatSettingViewController.h"
#import "IVToastHUD.h"
#import "VoiceConverter.h"
#define padding 20
#define ROW 6

@interface ADGroupChatViewController ()<ADMessageTableViewCellDelegate, NSURLConnectionDelegate>{
    
    float tableviewHeight;
    float Location_y;
    float offset;
    BOOL keyBoardShow;
    
    //获取发送语音消息时的dateString
    NSString *dateString;
    
    //切换聊天模式的状态
    NSInteger senceNum;
    int height; //键盘的高度
    
    int voiceImageViewTag;  //
    int recoderVoiceTime;
    int isLeft;
    
    BOOL overTime;
}

@end

@implementation ADGroupChatViewController
@synthesize recorder;
@synthesize chatWithUsers;
@synthesize messages;
@synthesize list;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (self.avPlay.playing) {
        [self.avPlay stop];
    }
    self.avPlay = nil;
    viewHasLoad = 0;
}

- (void)dealloc
{
    viewHasLoad = 0;
    _refreshHeaderView = nil;
}

- (void)returnBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 最近联系人" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
//    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.0/255.0f green:148.0/255.0f blue:255.0/255.0f alpha:0.8];
    
    viewHasLoad = 1;
    keyBoardShow = NO;
    _chatWithUser = [NSString stringWithFormat:@"%@_%@", [self xmppStream].myJID.user, chatWithUsers.user];
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *currentNUmber = [userDefault objectForKey:[NSString stringWithFormat:@"%@_newsnumber", _chatWithUser]];
    //消息读取完成
    [userDefault setObject:@"0" forKey:[NSString stringWithFormat:@"%@_newsnumber", _chatWithUser]];
    [userDefault synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTableView" object:nil];
    
    NSString* allNumberChats = [NSString stringWithFormat:@"%@_ALLNUMBERCHAT", [self xmppStream].myJID.user];
    if([userDefault objectForKey:allNumberChats]){
        if([currentNUmber integerValue] > 0){
            NSInteger n = [[userDefault objectForKey:allNumberChats] integerValue];
            n -= [currentNUmber integerValue];
            [userDefault setObject:[NSString stringWithFormat:@"%d",n] forKey:allNumberChats];
            [userDefault synchronize];
        }else if([currentNUmber integerValue] < 0){
            NSInteger n = 0;
            [userDefault setObject:[NSString stringWithFormat:@"%d",n] forKey:allNumberChats];
            [userDefault synchronize];
        }
    }
    
    messages = [[NSMutableArray alloc] init];
    list = [[NSMutableArray alloc] init];
    
    if([userDefault objectForKey:_chatWithUser]){
        NSArray *theArray = [userDefault objectForKey:_chatWithUser];
        for(int i = theArray.count-1; i>=0; i--){
            [list addObject:[theArray objectAtIndex:i]];
        }
        if(list.count > ROW){
            for(int i = 0; i < ROW; i++){
                [messages insertObject:[list objectAtIndex:i] atIndex:0];
            }
        }else{
            for(int i = 0; i < list.count; i++){
                if(messages.count == list.count) break;
                [messages insertObject:[list objectAtIndex:messages.count] atIndex:0];
            }
        }
    }
    
    offset = 0;
    //监控键盘弹出、消失
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    _myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 568-30)];
    _myTableView.backgroundColor = [UIColor blackColor];
    _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    [self.view addSubview:_myTableView];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardDisappear)];  
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.delegate = self;
    [_myTableView addGestureRecognizer:tapGesture];
    
    if(IOS7_OR_LATER){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 222;
        [self.view addSubview:view];
        _myTableView.frame = CGRectMake(0, 0, WIDTH, 450);
	}
    if (!IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS6.0 3.5寸屏幕
        _myTableView.frame = CGRectMake(0, 0, WIDTH, 386);
	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        _myTableView.frame = CGRectMake(0, 0, WIDTH, 474);
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 222;
        [self.view addSubview:view];
        _myTableView.frame = CGRectMake(0, 0, WIDTH, 538);
	}
    
   
    
    _keyBoardView = [[UIView alloc] initWithFrame:CGRectMake(0, _myTableView.frame.size.height, WIDTH, 30)];
    _keyBoardView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_keyBoardView];
    
    _messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(30, 3, 290-30, 30-6)];
    _messageTextField.delegate =self;
    _messageTextField.backgroundColor = [UIColor whiteColor];
//    _messageTextField.background = [UIImage imageNamed:@"chat_bottom_textfield.png"];
    _messageTextField.textColor = [UIColor blackColor];
    _messageTextField.returnKeyType = UIReturnKeySend;
    _messageTextField.font = [UIFont systemFontOfSize:12];
    [_messageTextField.layer setCornerRadius:8.0];
    [_messageTextField.layer setBorderWidth:1];
    [_messageTextField.layer setBorderColor:[UIColor grayColor].CGColor];
    [_messageTextField setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    [_keyBoardView addSubview:_messageTextField];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    _sendBtn.frame = CGRectMake(290, 0, 30, 30);
    _sendBtn.backgroundColor = [UIColor whiteColor];
    _sendBtn.tintColor = [UIColor grayColor];
//    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
//    [_sendBtn addTarget:self action:@selector(sendButton:) forControlEvents:UIControlEventTouchUpInside];
    _sendBtn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_keyBoardView addSubview:_sendBtn];
    
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        _myTableView.frame = CGRectMake(0, 64, WIDTH, 450-64);
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        _myTableView.frame = CGRectMake(0, 64, WIDTH, 538-64);
    }
    tableviewHeight = _myTableView.frame.size.height;
    Location_y = _keyBoardView.frame.origin.y;
    //*************************************录音功能按钮的布局*************************************
//    [self audio];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(0, 0, 30, 30);
    self.btn.backgroundColor = [UIColor whiteColor];
//    [self.btn setTitle:@"录音" forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
#ifdef AVAUDIORECORDER
    [self.btn addTarget:self action:@selector(selectAVAudioRecorder:) forControlEvents:UIControlEventTouchUpInside];
#endif
    self.btn.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    self.btn.selected = YES;
    [_keyBoardView addSubview:self.btn];
    
    self.btnRecorder = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnRecorder.frame = _messageTextField.frame;//CGRectMake(40, _myTableView.frame.size.height+1, 240, 28);
    self.btnRecorder.backgroundColor = [UIColor whiteColor];
    [self.btnRecorder setTitle:@"按住 说话" forState:UIControlStateNormal];
    
    [self.btnRecorder setTintColor:[UIColor blackColor]];
    [self.btnRecorder.layer setCornerRadius:8.0]; //设置矩形四个圆角半径
    [self.btnRecorder.layer setBorderWidth:1.0]; //边框宽度
    [self.btnRecorder.layer setBorderColor:[UIColor grayColor].CGColor];
//    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
//    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 0.8, 0.8, 0.8, 1 });
//    [self.btnRecorder.layer setBorderColor:colorref];
    self.btnRecorder.titleLabel.font = [UIFont systemFontOfSize:13.0f];
    [_keyBoardView addSubview:self.btnRecorder];
    [self.btnRecorder addTarget:self action:@selector(btnDown:) forControlEvents:UIControlEventTouchDown];
    [self.btnRecorder addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.btnRecorder addTarget:self action:@selector(btnDragUp:) forControlEvents:UIControlEventTouchDragExit];
    self.btnRecorder.hidden = YES;
    
    //******************************************************************************************
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, 200, 60, 60)];
    [self.view addSubview:self.imageView];
    
    ADAppDelegate *del = [self appDelegate];
    del.messageDelegate = self;
    
    if(_scene == 2){
        [self showMap_qunliao];
//        UIBarButtonItem *changeSence = [[UIBarButtonItem alloc] initWithTitle:@"切换场景" style:UIBarButtonItemStyleBordered target:self action:@selector(changeSence)];
//        [changeSence setTintColor:[UIColor lightGrayColor]];
//        self.navigationItem.rightBarButtonItem = changeSence;
        UIBarButtonItem *changeSence = [[UIBarButtonItem alloc] initWithTitle:@"组员" style:UIBarButtonItemStyleBordered target:self action:@selector(showGroupPeople)];
        [changeSence setTintColor:[UIColor lightGrayColor]];
        self.navigationItem.rightBarButtonItem = changeSence;
        //        senceNum = 1;
    }else{
    
    }
    //切换场景
    UIBarButtonItem *changeSence = [[UIBarButtonItem alloc] initWithTitle:@"切换场景" style:UIBarButtonItemStyleBordered target:self action:@selector(changeSence)];
    [changeSence setTintColor:[UIColor lightGrayColor]];
    
    //设置好友--modify
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"setFriend.png"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(gotoModifyFriend)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *modifyFriendInfo = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[modifyFriendInfo];
    // Do any additional setup after loading the view from its nib.
    
    if (_refreshHeaderView == nil){
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.myTableView.bounds.size.height, self.view.frame.size.width, self.myTableView.bounds.size.height)];
		view.delegate = self;
		[self.myTableView addSubview:view];
		_refreshHeaderView = view;
	}
    if (IOS7_OR_LATER) {            //IOS7.0
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 44)];
        view.backgroundColor = [UIColor blackColor];
        [self.view addSubview:view];
    }
    
//    if(DEVICE_IS_IPHONE5){
//        if(messages.count>7)
//            [_myTableView setContentOffset:CGPointMake(0, (messages.count-7)*75) animated:YES];
//    }else{
//        if(messages.count>6)
//            [_myTableView setContentOffset:CGPointMake(0, (messages.count-6)*75) animated:YES];
//    }
    [self flushTableViewFrame];
    
    
    UISwipeGestureRecognizer *recognizer;
    //向右滑动
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [[self view] addGestureRecognizer:recognizer];
    //向左滑动
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [[self view] addGestureRecognizer:recognizer];
}

#pragma mark -UISwipeGestureRecognizer
//屏幕滑动监测
-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction==UISwipeGestureRecognizerDirectionLeft)
    {
        NSLog(@"swipe left");
//        [self changeSence];
//        senceNum = 0;
        //执行程序
    }
    if(recognizer.direction==UISwipeGestureRecognizerDirectionRight)
    {
        NSLog(@"swipe right");
//        [self changeSence];
//        senceNum = 1;
        //执行程序
    }
}

//跳转到修改好友权限的界面
- (void)gotoModifyFriend
{
    NSLog(@"%@", chatWithUsers.user);
    ADChatSettingViewController *chatSettingVC = [[ADChatSettingViewController alloc] init];
    chatSettingVC.friendJid = chatWithUsers;
    chatSettingVC.friendNameString = self.title;
    chatSettingVC.chatWithUser = _chatWithUser;
    [self.navigationController pushViewController:chatSettingVC animated:YES];
    [_messageTextField resignFirstResponder];
}

//显示和隐藏组员
- (void)showGroupPeople
{
    BOOL hide = [[self.view viewWithTag:2345] isHidden];
    [[self.view viewWithTag:2345] setHidden:(hide?NO:YES)];
}

//群聊显示地图模式
- (void)showMap_qunliao
{
    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 416)];
    _mapView.delegate = self;
    [self.view addSubview:_mapView];
    //==============显示地图上的好友===================
    NSMutableArray *annotationArray = [[NSMutableArray alloc] initWithObjects:
                                       @{@"latitude":@"31.2071" , @"longitude":@"121.65911"},
                                       @{@"latitude":@"31.2073" , @"longitude":@"121.66833"},
                                       @{@"latitude":@"31.2075" , @"longitude":@"121.67855"},
                                       @{@"latitude":@"31.2077" , @"longitude":@"121.63877"},
                                       @{@"latitude":@"31.2079" , @"longitude":@"121.69999"},
                                       @{@"latitude":@"31.2081" , @"longitude":@"121.64833"}, nil];
    NSMutableArray *allCoordinateArr = [[NSMutableArray alloc] init];
    for(NSDictionary *dict in annotationArray){
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[dict objectForKey:@"latitude"]doubleValue];
        coor.longitude = [[dict objectForKey:@"longitude"]doubleValue];
        annotation.coordinate = coor;
//        annotation.title = @"fff";
        [_mapView addAnnotation:annotation];
        CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:coor.latitude longitude:coor.longitude];
        [allCoordinateArr addObject:currentLocation];
    }
    [self setRegion:allCoordinateArr];
    
    //==============================================
    UIScrollView *scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 30)];
    scrollview.tag = 2345;
    scrollview.backgroundColor = [UIColor blackColor];
    scrollview.alpha = 0.7;
    scrollview.contentSize = CGSizeMake(WIDTH, 30);
    for(int i = 0; i < 5; i++){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(5+33*i, 2, 25, 25);
        [btn setImage:[UIImage imageNamed:@"userPhoto.png"] forState:UIControlStateNormal];
        [scrollview addSubview:btn];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(5+33*5, 2, 25, 25);
    [scrollview addSubview:btn];
    [self.view addSubview:scrollview];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, 416)];
        [scrollview setFrame:CGRectMake(0, 64, WIDTH, 30)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 0, WIDTH, 504)];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_mapView setFrame:CGRectMake(0, 64, WIDTH, 504)];
        [scrollview setFrame:CGRectMake(0, 64, WIDTH, 30)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
    }
    
    senceNum = 0;
}

//改变聊天模式
- (void)changeSence
{
    if(senceNum == 1){
        [self showMap_qunliao];
        senceNum = 0;
        UIBarButtonItem *changeSence = [[UIBarButtonItem alloc] initWithTitle:@"组员" style:UIBarButtonItemStyleBordered target:self action:@selector(showGroupPeople)];
        [changeSence setTintColor:[UIColor lightGrayColor]];
        self.navigationItem.rightBarButtonItem = changeSence;
    }else{
        [_mapView removeFromSuperview];
        _mapView.delegate = nil;
        
        [[self.view viewWithTag:2345] removeFromSuperview];
        
        UIBarButtonItem *changeSence = [[UIBarButtonItem alloc] initWithTitle:@"地图模式" style:UIBarButtonItemStyleBordered target:self action:@selector(changeSence)];
        [changeSence setTintColor:[UIColor lightGrayColor]];
        self.navigationItem.rightBarButtonItem = changeSence;
        
        senceNum = 1;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)viewWillAppear:(BOOL)animated{
    
    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(sessionCategory), &sessionCategory);
    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (audioRouteOverride),&audioRouteOverride);
    [_mapView viewWillAppear];
    _mapView.delegate = self;
    viewHasLoad = 1;
    [messages removeAllObjects];
    [list removeAllObjects];
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if([userDefault objectForKey:_chatWithUser]){
        NSArray *theArray = [userDefault objectForKey:_chatWithUser];
        for(int i = theArray.count-1; i>=0; i--){
            [list addObject:[theArray objectAtIndex:i]];
        }
        if(list.count > ROW){
            for(int i = 0; i < ROW; i++){
                [messages insertObject:[list objectAtIndex:i] atIndex:0];
            }
        }else{
            for(int i = 0; i < list.count; i++){
                if(messages.count == list.count) break;
                [messages insertObject:[list objectAtIndex:messages.count] atIndex:0];
            }
        }
    }
    //消息已经阅读过
    [userDefault setObject:@"0" forKey:[NSString stringWithFormat:@"%@_newsnumber", _chatWithUser]];
    [userDefault synchronize];
    
    [self flushTableViewFrame];
}

//*************************************语音发送、录音功能*************************************
//录制语音wav格式，压缩成amr 然后再base64编码成nsstring传输，再解码解压，很简单就实现了。
- (void)audio
{
    NSError *error1 = nil;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error1];
    //录音设置
//    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
//                              [NSNumber numberWithFloat: 8000],AVSampleRateKey,
//                              [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
//                              [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,
//                              [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
//                              [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,
//                              [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
//                              [NSNumber numberWithInt:AVAudioQualityLow],AVEncoderAudioQualityKey,
//                             nil];
    NSDictionary *recordSetting = [[NSDictionary alloc] initWithObjectsAndKeys:
                                   [NSNumber numberWithFloat: 8000.0],AVSampleRateKey, //采样率
                                   [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                   [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,//采样位数 默认 16
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,//通道的数目
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsBigEndianKey,//大端还是小端 是内存的组织方式
                                   //                                   [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,//采样信号是整数还是浮点数
                                   //                                   [NSNumber numberWithInt: AVAudioQualityMedium],AVEncoderAudioQualityKey,//音频编码质量
                                   nil];
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddhhmmss"];
    dateString = [formatter stringFromDate:date];
    
    NSString *strUrl = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@.wav", strUrl, dateString]];
    
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@.wav", strUrl, dateString]];
//    NSURL *soundFileURL = [NSURL URLWithString:[strUrl stringByAppendingPathComponent:@"myReturnSound.wav"]];
    
    NSError *error;
    //初始化
    recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSetting error:&error];
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}

#pragma mark -methods_AVAudioRecorder
//点击输入栏中切换是否语音对话
- (IBAction)selectAVAudioRecorder:(id)sender
{
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"] mutableCopy] containsObject:[chatWithUsers user]]){
        [IVToastHUD showErrorWithStatus:[NSString stringWithFormat:@"你已屏蔽来自好友%@的消息", self.title]];
        return;
    }
    if(_btn.selected == YES){
//        [_btn setTitle:@"T" forState:UIControlStateNormal];
        [self.btn setImage:[UIImage imageNamed:@"chat_bottom_keyboard_press.png"] forState:UIControlStateNormal];
        _btn.selected = NO;
        _btnRecorder.hidden = NO;
        _messageTextField.enabled = NO;
        [_messageTextField resignFirstResponder];
    }else{
//        [_btn setTitle:@"录音" forState:UIControlStateNormal];
        [self.btn setImage:[UIImage imageNamed:@"chat_bottom_voice_nor.png"] forState:UIControlStateNormal];
        _btn.selected = YES;
        _btnRecorder.hidden = YES;
        _messageTextField.enabled = YES;
    }
}

//开始语音录音
- (IBAction)btnDown:(id)sender
{
    if (self.avPlay.playing) {
        [self.avPlay stop];
        if(isLeft){
            UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
            [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying003_ios7@2x.png"]]];
        }else{
            UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
            [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying003_ios7@2x.png"]]];
        }
        [timer_player invalidate];
    }
    [self audio];
    //创建录音文件，准备录音
    if ([recorder prepareToRecord] == YES) {
        //开始
        [recorder record];
    }
    self.imageView.hidden = NO;
    //设置定时检测
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(detectionVoice) userInfo:nil repeats:YES];
}

//结束语音录音
- (IBAction)btnUp:(id)sender
{
    if(overTime){
        return;
    }else{
        NSLog(@"no");
    }
    double cTime = recorder.currentTime;
    [timer invalidate];
    self.imageView.hidden = YES;
    
    recoderVoiceTime = cTime;
    NSLog(@"%lf", cTime);
    if (cTime > 1) {//如果录制时间<2 不发送
        NSLog(@"发出去");
    }else {
        //删除记录的文件
        [IVToastHUD showErrorWithStatus:@"说话时间太短"];
        [recorder deleteRecording];
        NSString* wavFileDirectory = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dateString]stringByAppendingPathExtension:@"wav"];
        NSFileManager *fileManager = [[NSFileManager alloc]init];
        if ([fileManager fileExistsAtPath:wavFileDirectory]) {
            [fileManager removeItemAtPath:wavFileDirectory error:nil];
        }
        //删除存储的
    }
    [recorder stop];
    recorder = nil;
}

//删除语音文件
- (IBAction)btnDragUp:(id)sender
{
    //删除录制文件
    [recorder deleteRecording];
    [recorder stop];
    [timer invalidate];
    NSLog(@"取消发送");
}

//实时监控音量的大小
- (void)detectionVoice
{
    [recorder updateMeters];//刷新音量数据
    //获取音量的平均值  [recorder averagePowerForChannel:0];
    //音量的最大值  [recorder peakPowerForChannel:0];
    
    double lowPassResults = pow(10, (0.05 * [recorder peakPowerForChannel:0]));
    NSLog(@"当前的音量:%lf",lowPassResults);
    //最大50  0
    //图片 小-》大
    if (0<lowPassResults<=0.06) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
    }else if (0.06<lowPassResults<=0.13) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_02.png"]];
    }else if (0.13<lowPassResults<=0.20) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_03.png"]];
    }else if (0.20<lowPassResults<=0.27) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_04.png"]];
    }else if (0.27<lowPassResults<=0.34) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_05.png"]];
    }else if (0.34<lowPassResults<=0.41) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_06.png"]];
    }else if (0.41<lowPassResults<=0.48) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_07.png"]];
    }else if (0.48<lowPassResults<=0.55) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_08.png"]];
    }else if (0.55<lowPassResults<=0.62) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_09.png"]];
    }else if (0.62<lowPassResults<=0.69) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_10.png"]];
    }else if (0.69<lowPassResults<=0.76) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_11.png"]];
    }else if (0.76<lowPassResults<=0.83) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_12.png"]];
    }else if (0.83<lowPassResults<=0.9) {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_13.png"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"record_animate_14.png"]];
    }
    double cTime = recorder.currentTime;
    if(cTime >= 60){
        [self btnUp:nil];
        overTime = YES;
    }else{
        overTime = NO;
    }
}

//实时更新音量大小的描述图片
- (void) updateImage
{
    [self.imageView setImage:[UIImage imageNamed:@"record_animate_01.png"]];
}


//录音结束
-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    self.imageView.hidden = YES;
    NSFileManager *fileManager = [[NSFileManager alloc]init];
    if ([fileManager fileExistsAtPath:[NSString stringWithFormat:@"%@/%@.wav", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], dateString]]) {
        
        if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"] mutableCopy] containsObject:[chatWithUsers user]]){
            [IVToastHUD showErrorWithStatus:[NSString stringWithFormat:@"你已屏蔽来自好友%@的消息", self.title]];
            return;
        }
        
        NSString* wavFileDirectory = [[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:dateString]stringByAppendingPathExtension:@"wav"];
        NSData *postData = [[NSData alloc] initWithContentsOfFile:wavFileDirectory];
        NSLog(@"%lu", (unsigned long)postData.length);
        
    //记录语音聊天记录
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:@"audio1211" forKey:@"msg"];
        [dictionary setObject:@"you" forKey:@"sender"];
        //加入发送时间
        NSDate *nowUTC = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dictionary setObject:[dateFormatter stringFromDate:nowUTC] forKey:@"time"];
        [dictionary setObject:dateString forKey:@"audioUrl"];
        [dictionary setObject:[NSString stringWithFormat:@"%d", (int)recoderVoiceTime] forKey:@"recoderVoiceTime"];
        [messages addObject:dictionary];
        [list insertObject:dictionary atIndex:0];
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        if([userDefault objectForKey:_chatWithUser]){
            theArray = [[userDefault objectForKey:_chatWithUser] mutableCopy];
        }
        [theArray addObject:dictionary];
        [userDefault setObject:theArray forKey:_chatWithUser];
        [userDefault synchronize];
        
        [self flushTableViewFrame];
        

        //传送语音文件到服务器上
        NSString *tempUrl = [[NSTemporaryDirectory() stringByAppendingPathComponent:dateString]stringByAppendingPathExtension:@"amr"];
        [VoiceConverter wavToAmr:wavFileDirectory amrSavePath:tempUrl];
        NSData *tempData = [[NSData alloc] initWithContentsOfFile:tempUrl];
        [self loadAudio:tempData];
    }

}

- (void)loadAudio:(NSData*)audioData
{
//    NSData *imgData=[audioData copy];
    NSString *urlString = POST_URL;
    //建立请求对象
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置请求路径
    [request setURL:[NSURL URLWithString:urlString]];
    //请求方式
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:10];
    
    //一连串上传头标签
    
    NSString *boundary = @"-----------------";//[NSString stringWithString:@"------------------"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    [request addValue:@"utf-8" forHTTPHeaderField:@"Charset"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *fileName = [NSString stringWithFormat:@"%@_%@", [self xmppStream].myJID.user, dateString];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition:form-data;name=\"file\";filename=\"%@.amr\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type:application/octet-stream;charset=utf-8\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:audioData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    //上传文件开始
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if (!result)
    {
        NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        [IVToastHUD showErrorWithStatus:[NSString stringWithFormat:@"语音发送失败！"]];
        NSLog(@"sendAudio:%@", outstring);
    }else{
        NSString *outstring = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
        NSString *fileName = [NSString stringWithFormat:@"#*audio_s*%@_%@", [self xmppStream].myJID.user, dateString];
        [self sendAudioByName:fileName];
        NSLog(@"sendAudio:%@", outstring);
    }
}

//============================================================================================

- (void)sendAudioByName:(NSString*)string
{
    //本地输入框中的信息
    NSString *message = string;
    if (message.length > 0) {
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",chatWithUsers.user, chatWithUsers.domain]];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[self xmppStream].myJID.user, [self xmppStream].myJID.domain]];
        //组合
        [mes addChild:body];
        //发送消息
        [[self xmppStream] sendElement:mes];
        
        self.messageTextField.text = @"";
        
    }

}

//********************************************************************************************

//点击聊天表格键盘消失
- (void)keyBoardDisappear
{
    if (self.avPlay.playing) {
        [self.avPlay stop];
        if(isLeft){
            UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
            [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying003_ios7@2x.png"]]];
        }else{
            UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
            [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying003_ios7@2x.png"]]];
        }
        [timer_player invalidate];
    }
    [_messageTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDelegate
- (void)scrollTableToFoot:(BOOL)animated {
    NSInteger s = [_myTableView numberOfSections];
    if (s<1) return;
    NSInteger r = [_myTableView numberOfRowsInSection:s-1];
    if (r<1) return;
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    
    [_myTableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:animated];
}
- (void)flushTableViewFrame
{
//    if(keyBoardShow == YES){
//        if(DEVICE_IS_IPHONE5){
//            if(messages.count>4)
//                [_myTableView setContentOffset:CGPointMake(0, (messages.count-4)*65) animated:YES];
//        }else{
//            if(messages.count>3)
//                [_myTableView setContentOffset:CGPointMake(0, (messages.count-3)*65) animated:YES];
//        }
//    }else{
//        if(DEVICE_IS_IPHONE5){
//            if(messages.count>7)
//                [_myTableView setContentOffset:CGPointMake(0, (messages.count-7)*65) animated:YES];
//        }else{
//            if(messages.count>6)
//                [_myTableView setContentOffset:CGPointMake(0, (messages.count-6)*65) animated:YES];
//        }
//    }
    [_myTableView reloadData];
    [self scrollTableToFoot:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return messages.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *indentifier = @"ADMessageTableViewCell";
    ADMessageTableViewCell *cell = (ADMessageTableViewCell*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:indentifier];
    if(cell == nil){
        cell = [[ADMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    cell.delegate = self;
    NSMutableDictionary *dict = [messages objectAtIndex:indexPath.row];
    
    //发送者
    NSString *sender = [dict objectForKey:@"sender"];
    //消息
    NSString *message = [dict objectForKey:@"msg"];
    //时间
    NSString *time = [dict objectForKey:@"time"];
    
    CGSize textSize = {260.0 ,10000.0};
    CGSize size = {60, 20};
    if(message.length == 0){
        
    }else{
        size = [message sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode: UILineBreakModeWordWrap];
    }
    size.width +=(padding/2);
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.accessoryType = UITableViewCellAccessoryNone;
//    cell.userInteractionEnabled = NO;
    UIImage *bgImage = nil;
    //发送消息
    if (![sender isEqualToString:@"you"]) {
        //背景图
        bgImage = [[UIImage imageNamed:@"BlueBubble2.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:15];
        [cell.messageContentView setFrame:CGRectMake(padding, padding*2-7, size.width, size.height+10)];
        
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2+7, size.width + padding, size.height + padding)];
        
        cell.senderAndTimeLabel.text = time;//[NSString stringWithFormat:@"%@ %@", [[sender componentsSeparatedByString:@"@"] objectAtIndex:0], time];
    }else {
        bgImage = [[UIImage imageNamed:@"GreenBubble2.png"] stretchableImageWithLeftCapWidth:14 topCapHeight:15];
        
        [cell.messageContentView setFrame:CGRectMake(WIDTH-size.width - padding, padding*2-7, size.width, size.height+10)];
        [cell.bgImageView setFrame:CGRectMake(cell.messageContentView.frame.origin.x - padding/2, cell.messageContentView.frame.origin.y - padding/2+7, size.width + padding, size.height + padding)];
        cell.senderAndTimeLabel.text = time;//[NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] stringForKey:USERID], time];
    }
    cell.bgImageView.image = bgImage;
    if([message isEqualToString:@"audio1211"]){
        if (![sender isEqualToString:@"you"]){
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bgImageView.frame.origin.x+15, cell.bgImageView.frame.origin.y+5, 25, 25)];
            [image setImage:[UIImage imageNamed:@"ReceiverVoiceNodePlaying003_ios7@2x.png"]];
            image.tag = indexPath.row +200;
            [cell addSubview:image];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.origin.x+45, image.frame.origin.y, 30, 25)];
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textColor = [UIColor whiteColor];
            label.text = [NSString stringWithFormat:@"%d''",[[dict objectForKey:@"recoderVoiceTime"] integerValue]];
            [cell addSubview:label];
        }else{
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(cell.bgImageView.frame.origin.x+50, cell.bgImageView.frame.origin.y+5, 25, 25)];
            [image setImage:[UIImage imageNamed:@"SenderVoiceNodePlaying003_ios7@2x.png"]];
            image.tag = indexPath.row +200;
            [cell addSubview:image];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.origin.x-30, image.frame.origin.y, 30, 25)];
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textColor = [UIColor whiteColor];
            label.text = [NSString stringWithFormat:@"%d''",[[dict objectForKey:@"recoderVoiceTime"] integerValue]];
            [cell addSubview:label];
        }
        cell.playBtn.frame = cell.bgImageView.frame;
        cell.playBtn.tag = indexPath.row;
    }else{
        cell.messageContentView.text = message;
        cell.playBtn.hidden = YES;
    }
    cell.messageContentView.textColor = [UIColor whiteColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

//每一行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableDictionary *dict  = [messages objectAtIndex:indexPath.row];
    NSString *msg = [dict objectForKey:@"msg"];
    CGSize textSize = {260.0 , 10000.0};
    CGSize size = [msg sizeWithFont:[UIFont boldSystemFontOfSize:13] constrainedToSize:textSize lineBreakMode:UILineBreakModeWordWrap];
    size.height += padding*2;
    CGFloat heights = size.height < 75 ? 75 : size.height+10;
    return heights;
}


#pragma mark -ADMessageTableViewCellDelegate
//点击语音，播放当前所选的语音内容
- (void)playAudio:(NSInteger)row
{
    NSString *strUrl = [NSString stringWithFormat:@"%@/%@.wav", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [[messages objectAtIndex:row] objectForKey:@"audioUrl"]];
    NSLog(@"%@", strUrl);
    NSURL *url = [NSURL fileURLWithPath:strUrl];
    if (self.avPlay.playing) {
        [self.avPlay stop];
        if(isLeft){
            UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
            [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying003_ios7@2x.png"]]];
        }else{
            UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
            [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying003_ios7@2x.png"]]];
        }
        [timer_player invalidate];
    }
    AVAudioPlayer *player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    NSLog(@"%f", player.volume);
    [player prepareToPlay];
    player.volume=1;//0.0~1.0之间
    player.numberOfLoops = 0;
    if(player == nil) return;
    self.avPlay = player;
    self.avPlay.delegate = self;
    [self.avPlay play];
    if([[[messages objectAtIndex:row] objectForKey:@"sender"] isEqualToString:@"you"]){
        isLeft = 0;
    }else{
        isLeft = 1;
    }
    timer_player = [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(playProgress) userInfo:nil repeats:YES];
    voiceImageViewTag = row +200;
}

- (void)playProgress
{
    static int i = 0;
    if(isLeft){
        UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying00%d_ios7@2x.png",i++%4]]];
    }else{
        UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying00%d_ios7@2x.png",i++%4]]];
    }
}
#pragma mark - AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if(isLeft){
        UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ReceiverVoiceNodePlaying003_ios7@2x.png"]]];
    }else{
        UIImageView *image = (UIImageView *)[self.view viewWithTag:voiceImageViewTag];
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"SenderVoiceNodePlaying003_ios7@2x.png"]]];
    }
    
    [timer_player invalidate];
    timer_player = nil;
}

#pragma mark -method_word
//发送文字消息
- (IBAction)sendButton:(id)sender
{
    if([[[[NSUserDefaults standardUserDefaults] objectForKey:@"blacklist"] mutableCopy] containsObject:[chatWithUsers user]]){
        [IVToastHUD showErrorWithStatus:[NSString stringWithFormat:@"你已屏蔽来自好友%@的消息", self.title]];
        return;
    }
    //本地输入框中的信息
    NSString *message = self.messageTextField.text;
    if (message.length > 0) {
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"chat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@",chatWithUsers.user, chatWithUsers.domain]];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[self xmppStream].myJID.user, [self xmppStream].myJID.domain]];
        //组合
        [mes addChild:body];
        //发送消息
        [[self xmppStream] sendElement:mes];
        
        self.messageTextField.text = @"";
        
        //将新的文字消息防盗messages数组中
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        [dictionary setObject:message forKey:@"msg"];
        [dictionary setObject:@"you" forKey:@"sender"];
        //加入发送时间
        NSDate *nowUTC = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dictionary setObject:[dateFormatter stringFromDate:nowUTC] forKey:@"time"];
        [messages addObject:dictionary];
        [list insertObject:dictionary atIndex:0];
        //保存文字消息到本地        
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        NSMutableArray *theArray = [[NSMutableArray alloc] init];
        if([userDefault objectForKey:_chatWithUser]){
            theArray = [[userDefault objectForKey:_chatWithUser] mutableCopy];
        }
        [theArray addObject:dictionary];
        [userDefault setObject:theArray forKey:_chatWithUser];
        [userDefault synchronize];
        
        [self flushTableViewFrame];
    }
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendButton:nil];
    return YES;
}

//键盘弹出、消失
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    
    //获取键盘的高度
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.2f];
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
//    _messageTextField.frame = CGRectMake(30, Location_y-height, 290-30, _messageTextField.frame.size.height);
//    _sendBtn.frame = CGRectMake(290, Location_y-height-3, 30, 30);
//    _btn.frame = CGRectMake(0, Location_y-height-3, 30, 30);
    CGRect frame = _keyBoardView.frame;
    frame.origin.y = Location_y-height;
    _keyBoardView.frame = frame;
    _myTableView.frame = CGRectMake(0, _myTableView.frame.origin.y, WIDTH, tableviewHeight-height);
    [self flushTableViewFrame];
    [UIView commitAnimations];
    
    keyBoardShow = YES;
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
    //获取键盘的高度
    [UIView beginAnimations:@"animation" context:nil];
    [UIView setAnimationDuration:0.2f];
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    height = keyboardRect.size.height;
//    _messageTextField.frame = CGRectMake(30, _messageTextField.frame.origin.y+height, 290-30, _messageTextField.frame.size.height);
//    _sendBtn.frame = CGRectMake(290, _sendBtn.frame.origin.y+height, 30, 30);
//    _btn.frame = CGRectMake(0, _btn.frame.origin.y+height, 30, 30);
    CGRect frame = _keyBoardView.frame;
    frame.origin.y = Location_y;
    _keyBoardView.frame = frame;
    _myTableView.frame = CGRectMake(0, _myTableView.frame.origin.y, WIDTH, _myTableView.frame.size.height+height);
    [self flushTableViewFrame];
    [UIView commitAnimations];
    
    keyBoardShow = NO;
}

#pragma mark -KKMessageDelegate
//收到新的消息
-(void)newMessageReceived:(NSDictionary *)messageCotent
{
    //消息
    if(viewHasLoad != 1) {
        return;
    }
    int currentrow = messages.count+1;
    [messages removeAllObjects];
    [list removeAllObjects];

    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if([userDefault objectForKey:_chatWithUser]){
        NSArray *theArray = [userDefault objectForKey:_chatWithUser];
        for(int i = theArray.count-1; i>=0; i--){
            [list addObject:[theArray objectAtIndex:i]];
        }
        if(list.count > currentrow){
            for(int i = 0; i < currentrow; i++){
                [messages insertObject:[list objectAtIndex:i] atIndex:0];
            }
        }else{
            for(int i = 0; i < list.count; i++){
                if(messages.count == list.count) break;
                [messages insertObject:[list objectAtIndex:messages.count] atIndex:0];
            }
        }
    }

    //消息已经阅读过
    [userDefault setObject:@"0" forKey:[NSString stringWithFormat:@"%@_newsnumber", _chatWithUser]];
    [userDefault synchronize];
    NSString* allNumberChats = [NSString stringWithFormat:@"%@_ALLNUMBERCHAT", [self xmppStream].myJID.user];
    if([userDefault objectForKey:allNumberChats]){
        NSInteger n = [[userDefault objectForKey:allNumberChats] integerValue];
        n -= 1;
        [userDefault setObject:[NSString stringWithFormat:@"%d",n] forKey:allNumberChats];
        [userDefault synchronize];
    }
    
    [self flushTableViewFrame];
}

#pragma mark -ADAppDelegate
-(ADAppDelegate *)appDelegate{
    return (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

#pragma mark -mapChat
//================================地图聊天模式====================================
//设置地图当前显示的区域
- (void)setRegion:(NSArray * )arr
{
    if ([arr count]!=0) {
        // determine the extents of the trip points that were passed in, and zoom in to that area.
        CLLocationDegrees maxLat = -90;
        CLLocationDegrees maxLon = -180;
        CLLocationDegrees minLat = 90;
        CLLocationDegrees minLon = 180;
        
        for(int i = 0; i < [arr count]; i++)
        {
            CLLocation* currentLocation = [arr objectAtIndex:i];
            if(currentLocation.coordinate.latitude > maxLat)
                maxLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.latitude < minLat)
                minLat = currentLocation.coordinate.latitude;
            if(currentLocation.coordinate.longitude > maxLon)
                maxLon = currentLocation.coordinate.longitude;
            if(currentLocation.coordinate.longitude < minLon)
                minLon = currentLocation.coordinate.longitude;
        }
        
        BMKCoordinateRegion region;
        region.center.latitude     = (maxLat + minLat) / 2;
        region.center.longitude    = (maxLon + minLon) / 2;
        region.span.latitudeDelta  = maxLat - minLat;
        region.span.longitudeDelta = maxLon - minLon;
        [_mapView setRegion:region];
        
    }else {
        //"no data！";
    }
}

//添加车辆的位置
- (void)showAllVehicle
{
    CLLocationCoordinate2D authCoor;
    BMKPointAnnotation *point=[[BMKPointAnnotation alloc]init];
    point.coordinate=authCoor;
    
    point.title=@"h";
    point.subtitle=@"m";
    [_mapView addAnnotation:point];
    
    [_mapView setZoomLevel:14];
    [_mapView setCenterCoordinate:authCoor animated:YES];
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    CLLocationCoordinate2D coor;
    coor=view.annotation.coordinate;
    [mapView setCenterCoordinate:coor animated:YES];

}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    static int tag = 0;
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                                   reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorRed;
        newAnnotationView.enabled=YES;
        newAnnotationView.enabled3D=YES;
        newAnnotationView.animatesDrop = NO;//标注的动画效果.
//        newAnnotationView.selected = YES;
//        newAnnotationView.image = nil;//[UIImage imageNamed:@"userPhoto.png"];
        NSLog(@"%lf,%lf,%lf,%lf", newAnnotationView.frame.origin.x, newAnnotationView.frame.origin.y, newAnnotationView.frame.size.width, newAnnotationView.frame.size.height);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -20, 30, 17)];
        label.backgroundColor = [UIColor blackColor];
        label.textColor = [UIColor whiteColor];
        label.alpha = 0.5;
        label.font = [UIFont systemFontOfSize:10.0f];
        label.textAlignment = UITextAlignmentCenter;
        label.text = @"匹夫";
        [newAnnotationView addSubview:label];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, 30, 30);//newAnnotationView.frame;//
        btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"userPhoto.png"]];
        btn.tag = 10001+ tag++;
        [btn addTarget:self action:@selector(clickHeadImage:) forControlEvents:UIControlEventTouchUpInside];
        [newAnnotationView addSubview:btn];
        
        BMKPointAnnotation *newAnnotation=[[BMKPointAnnotation alloc]init];
        
        newAnnotation= annotation;
        newAnnotation.title= @"匹夫";
        newAnnotationView.annotation=newAnnotation;
        
        newAnnotationView.animatesDrop = NO;
        return newAnnotationView;
    }
    return nil;
}

//点击头像私聊
- (IBAction)clickHeadImage:(id)sender
{
    NSLog(@"%d",((UIButton*)sender).tag);
    [self changeSence];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
	
}

- (void)doneLoadingTableViewData{
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.myTableView];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
//	[self updateTableViewUI];
}

#pragma mark EGORefreshTableHeaderDelegate Methods
//下拉到一定距离，手指放开时调用
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    
	[self reloadTableViewDataSource];
    
    //停止加载，弹回下拉
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
    
    [self performSelector:@selector(updateUI) withObject:nil afterDelay:2.0];
    
}

- (void)updateTableViewUI
{
    if(keyBoardShow == NO){
        if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
            _myTableView.frame = CGRectMake(0, 64, WIDTH, 450-64);
        }
        if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
            _myTableView.frame = CGRectMake(0, 64, WIDTH, 538-64);
        }
    }else{
        if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
            _myTableView.frame = CGRectMake(0, 64, WIDTH, tableviewHeight-height-64);
        }
        if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
            _myTableView.frame = CGRectMake(0, 64, WIDTH, tableviewHeight-height-64);
        }
    }
    NSLog(@"%lf---%lf", _myTableView.frame.origin.x, _myTableView.frame.size.height);
    [_myTableView reloadData];
}

- (void)updateUI {
    
    for(int i = 0; i < ROW; i++){
        if(messages.count == list.count) break;
        [messages insertObject:[list objectAtIndex:messages.count] atIndex:0];
    }
    [self updateTableViewUI];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _reloading; // should return if data source model is reloading
	
}

//取得下拉刷新的时间
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}


@end
