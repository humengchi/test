//
//  ADGroupChatViewController.h
//  OBDClient
//
//  Created by hys on 26/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMessageDelegate.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "VoiceConverter.h"
#import <BaiduMapAPI/BMapKit.h>
#import "IVToastHUD.h"


#import "XMPPJID.h"

#import "EGORefreshTableHeaderView.h"

#define AVAUDIORECORDER //是否关闭语音功能

#define POST_URL @"http://180.166.124.142:9983/im/sendRec.php"

@interface ADGroupChatViewController : UIViewController<AVAudioRecorderDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,  KKMessageDelegate, UIGestureRecognizerDelegate, BMKMapViewDelegate, NSStreamDelegate,EGORefreshTableHeaderDelegate,EGORefreshTableHeaderDelegate, AVAudioPlayerDelegate>
{
    //录音功能参数
//    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSTimer *timer_player;
    //*************************
    NSStream *stream;
    
    int flag ; //操作标志 0为发送 1为接收
    
    NSInteger viewHasLoad; //是否已经进入该界面
    
    //下拉刷新
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;

}
@property (nonatomic, strong) IBOutlet UIView *keyBoardView;

@property (nonatomic, strong) IBOutlet UITableView      *myTableView;
@property (nonatomic, strong) IBOutlet UITextField      *messageTextField;
@property (nonatomic, strong) IBOutlet UIButton         *sendBtn;
@property (nonatomic, retain) NSString                  *chatWithUser;
@property (nonatomic, strong) NSMutableArray            *messages;        //所有消息的列表
@property (nonatomic, strong) NSMutableArray            *list;        //所有消息的列表
//************录音功能参数******************************************
@property (retain, nonatomic) IBOutlet UIButton         *btn;
@property (retain, nonatomic) IBOutlet UIButton         *btnRecorder;
@property (retain, nonatomic) IBOutlet UIImageView      *imageView;
@property (retain, nonatomic) IBOutlet UIButton         *playBtn;
@property (retain, nonatomic) AVAudioPlayer             *avPlay;
@property (strong, nonatomic) AVAudioRecorder           *recorder;
//****************************************************************

//***************地图模式聊天***************************************
@property (nonatomic) BMKMapView *mapView;
//****************************************************************

@property (nonatomic, retain) NSInputStream             *inputStream;

@property (nonatomic, retain) NSOutputStream            *outputStream;

@property (nonatomic, assign) NSInteger                 scene; //是否在线、是否为群聊

@property(nonatomic, retain) XMPPJID *chatWithUsers;

- (IBAction)sendButton:(id)sender;


//下拉刷新
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
