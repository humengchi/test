//
//  ADWarnDetailViewController.m
//  OBDClient
//
//  Created by hys on 16/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADWarnDetailViewController.h"
#import "ADSharedModel.h"

NSString* const ADWarnDetailReadFlagNotification=@"ADWarnDetailReadFlagNotification";

@interface ADWarnDetailViewController ()<UIActionSheetDelegate>
@property (nonatomic) ADSharedModel *sharedModel;
@end

@implementation ADWarnDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _setReadFlagForCurrentMessageModel=[[ADSetReadFlagForCurrentMessageModel alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMessageData:) name:ADWarnDetailNotification object:nil];
        _sharedModel = [[ADSharedModel alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~iphone.png"]]];
    
    UIBarButtonItem* sharedButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"微信分享" style:UIBarButtonItemStylePlain target:self action:@selector(sharedMessage:)];
    sharedButtonItem.tintColor = [UIColor lightGrayColor];
    self.navigationItem.rightBarButtonItem=sharedButtonItem;
    
    self.title=NSLocalizedStringFromTable(@"detailsKey",@"MyString", @"");
}

- (void)sharedMessage:(id)sender{
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择微信分享方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享给微信好友" otherButtonTitles:@"分享到朋友圈", nil];
    actionSheet.delegate=self;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [_sharedModel changeScene:0];
            [_sharedModel sendTextContent:[NSString stringWithFormat:@"%@:%@",_warnTitle,_warnContent]];
            break;
        case 1:
            [_sharedModel changeScene:1];
            [_sharedModel sendTextContent:[NSString stringWithFormat:@"%@:%@",_warnTitle,_warnContent]];
            break;
        default:
            break;
    }
    
}


#pragma mark -Notification
- (void)handleMessageData:(NSNotification *)aNoti{
    _warn=(NSDictionary*)[aNoti object];
    _warnTitle=[_warn objectForKey:@"title"];
    _warnPiority=[_warn objectForKey:@"piority"];
    _warnTime=[_warn objectForKey:@"createTime"];
    _warnContent=[_warn objectForKey:@"content"];
    _warnTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 6, WIDTH, 40)];
    _warnPiorityLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 46, WIDTH, 40)];
    _warnTimeLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 86, WIDTH, 40)];
    _warnContentLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 126, 315, 40)];

    _warnTitleLabel.text=[NSString stringWithFormat:@"告警名称:%@",_warnTitle];
    _warnTitleLabel.textColor=[UIColor whiteColor];
    [_warnTitleLabel setBackgroundColor:[UIColor clearColor]];
    
    _warnPiorityLabel.text=[NSString stringWithFormat:@"告警危害程度:%@",_warnPiority];
     _warnPiorityLabel.textColor=[UIColor whiteColor];
    [_warnPiorityLabel setBackgroundColor:[UIColor clearColor]];
    
    _warnTimeLabel.text=[NSString stringWithFormat:@"时间:%@",_warnTime];
     _warnTimeLabel.textColor=[UIColor whiteColor];
    [_warnTimeLabel setBackgroundColor:[UIColor clearColor]];
    
    _warnContentLabel.text=[NSString stringWithFormat:@"告警详细:%@",_warnContent];
    _warnContentLabel.lineBreakMode = UILineBreakModeWordWrap;
    _warnContentLabel.numberOfLines = 0;
     _warnContentLabel.textColor=[UIColor whiteColor];
    [_warnContentLabel setBackgroundColor:[UIColor clearColor]];
    
    
    [self.view addSubview:_warnTitleLabel];
    [self.view addSubview:_warnPiorityLabel];
    [self.view addSubview:_warnTimeLabel];
    [self.view addSubview:_warnContentLabel];
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        [_warnTitleLabel setFrame:CGRectMake(10, 70, WIDTH, 40)];
        [_warnPiorityLabel setFrame:CGRectMake(10, 110, WIDTH, 40)];
        [_warnTimeLabel setFrame:CGRectMake(10, 150, WIDTH, 40)];
        [_warnContentLabel setFrame:CGRectMake(10, 190, WIDTH, 40)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        [_warnTitleLabel setFrame:CGRectMake(10, 70, WIDTH, 40)];
        [_warnPiorityLabel setFrame:CGRectMake(10, 110, WIDTH, 40)];
        [_warnTimeLabel setFrame:CGRectMake(10, 150, WIDTH, 40)];
        [_warnContentLabel setFrame:CGRectMake(10, 190, WIDTH, 40)];
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}

    
    NSString* messageID=[_warn objectForKey:@"id"];
    [_setReadFlagForCurrentMessageModel startCallWithArguments:[NSArray arrayWithObjects:messageID, nil]];
    _setReadFlagForCurrentMessageModel.setReadFlagForCurrentMessageDelegate=self;
    
    
}


#pragma mark -Button Action
//-(void)setReadFlagForCurrentMessage:(id)sender{
//    _setReadFlagForCurrentMessageModel=[[ADSetReadFlagForCurrentMessageModel alloc]init];
//    NSString* msgID=[_warn objectForKey:@"id"];   
//    [_setReadFlagForCurrentMessageModel startCallWithArguments:[NSArray arrayWithObjects:msgID, nil]];
//    _setReadFlagForCurrentMessageModel.setReadFlagForCurrentMessageDelegate=self;
//}

-(void)handleSetReadFlagForCurrentMessageData:(NSDictionary *)dictionary{
    NSString* resultCode=[dictionary objectForKey:@"resultCode"];
    if ([resultCode isEqualToString:@"200"]) {
        NSString* resultMsg=[dictionary objectForKey:@"resultMsg"];
        NSLog(@"%@",resultMsg);
        [[NSNotificationCenter defaultCenter] postNotificationName:ADWarnDetailReadFlagNotification object:nil];
    }else{
        NSString* resultMsg=[dictionary objectForKey:@"resultMsg"];
        NSLog(@"%@",resultMsg);
    }
}
-(void)WarnDetailBackButton:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
