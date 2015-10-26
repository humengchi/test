//
//  ADAboutViewController.m
//  OBDClient
//
//  Created by hys on 30/10/13.
//  Copyright (c) 2013年 AnyData.com. All rights reserved.
//

#import "ADAboutViewController.h"
#import "ADSharedModel.h"

@interface ADAboutViewController ()<UIActionSheetDelegate>
@property (nonatomic) ADSharedModel * sharedModel;
@end

@implementation ADAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sharedModel = [[ADSharedModel alloc]init];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"app_bg~ipjone.png"]]];
    self.title=NSLocalizedStringFromTable(@"aboutKey",@"MyString", @"");
    
    NSString *executableFile = NSLocalizedStringFromTable(@"productName",@"MyString", @"");
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    
    self.versionTextLabel.text=[NSString stringWithFormat:@"%@ %@",executableFile,version];
    
    _shareLabel.text=NSLocalizedStringFromTable(@"shareKey",@"MyString", @"");
    _lab1.text=NSLocalizedStringFromTable(@"PrivacypolicyKey",@"MyString", @"");
    
    _lab2.text=NSLocalizedStringFromTable(@"termsofservicesKey",@"MyString", @"");
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        CGRect frame=_ImgView1.frame;
        frame.origin.y+=64;
        [_ImgView1 setFrame:frame];
        
        frame=_versionTextLabel.frame;
        frame.origin.y+=64;
        [_versionTextLabel setFrame:frame];
        
        frame=_shareLabel.frame;
        frame.origin.y+=64;
        [_shareLabel setFrame:frame];
        
        frame=_lab1.frame;
        frame.origin.y+=64;
        [_lab1 setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y+=64;
        [_lab2 setFrame:frame];
        
        frame=_buttonWX.frame;
        frame.origin.y+=64;
        [_buttonWX setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];

	}
    if (!IOS7_OR_LATER && DEVICE_IS_IPHONE5) {            //IOS6.0 4.0寸屏幕
        CGRect frame=_shareLabel.frame;
        frame.origin.y+=88;
        [_shareLabel setFrame:frame];
        
        frame=_lab1.frame;
        frame.origin.y+=88;
        [_lab1 setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y+=88;
        [_lab2 setFrame:frame];
        
        frame=_buttonWX.frame;
        frame.origin.y+=88;
        [_buttonWX setFrame:frame];
    }
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        CGRect frame=_ImgView1.frame;
        frame.origin.y+=64;
        [_ImgView1 setFrame:frame];
        
        frame=_versionTextLabel.frame;
        frame.origin.y+=64;
        [_versionTextLabel setFrame:frame];
        
        frame=_shareLabel.frame;
        frame.origin.y+=152;
        [_shareLabel setFrame:frame];
        
        frame=_buttonWX.frame;
        frame.origin.y+=152;
        [_buttonWX setFrame:frame];
        
        frame=_lab1.frame;
        frame.origin.y+=152;
        [_lab1 setFrame:frame];
        
        frame=_lab2.frame;
        frame.origin.y+=152;
        [_lab2 setFrame:frame];
        
        UIView* view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        [view setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:view];
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setVersionTextLabel:nil];
    [self setShareLabel:nil];
    [self setLab1:nil];
    [self setLab2:nil];
    [self setButtonWX:nil];
    [super viewDidUnload];
}
- (IBAction)shareToWX:(UIButton *)sender {
    UIActionSheet * actionSheet = [[UIActionSheet alloc]initWithTitle:@"选择微信分享方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享给微信好友" otherButtonTitles:@"分享到朋友圈", nil];
    actionSheet.delegate=self;
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            [_sharedModel changeScene:0];
            [_sharedModel sendLinkContent];
            break;
        case 1:
            [_sharedModel changeScene:1];
            [_sharedModel sendLinkContent];
            break;
        default:
            break;
    }
    
}

@end
