//
//  ADChatSettingViewController.m
//  OBDClient
//
//  Created by hys on 20/8/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADChatSettingViewController.h"

@interface ADChatSettingViewController ()

@end

@implementation ADChatSettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    friendName.text = _friendNameString;
    self.title = @"聊天设置";
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *blackList = [[NSMutableArray alloc] init];
    if([userDefaults objectForKey:@"blacklist"]){
        blackList = [[userDefaults objectForKey:@"blacklist"] mutableCopy];
        if([blackList containsObject:_friendJid.user]){
            [mySwitch setOn:YES animated:YES];
        }else{
            [mySwitch setOn:NO animated:YES];
        }
    }else{
        [mySwitch setOn:NO animated:YES];
    }
    
    if (IOS7_OR_LATER && !DEVICE_IS_IPHONE5) {            //IOS7.0 3.5寸屏幕
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 222;
        [self.view addSubview:view];
	}
    
    if (IOS7_OR_LATER && DEVICE_IS_IPHONE5) {             //IOS7.0 4.0寸屏幕
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
        view.backgroundColor = [UIColor grayColor];
        view.tag = 222;
        [self.view addSubview:view];
	}
    self.view.backgroundColor=[UIColor blackColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:0.0/255.0f green:148.0/255.0f blue:255.0/255.0f alpha:0.8];
    if (IOS7_OR_LATER){
        deleteMemory.layer.cornerRadius = 4;
        headImageView.layer.cornerRadius = 8;
    }else{
        [deleteMemory setTintColor:[UIColor blackColor]];
        [deleteMemory setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [deleteMemory setBackgroundColor:[UIColor clearColor]];
        CGRect frame = mySwitch.frame;
        frame.origin.x -= 5;
        mySwitch.frame = frame;
    }
    NSArray *theArray = [[NSUserDefaults standardUserDefaults] objectForKey:_chatWithUser];
    if(theArray.count <= 0){
        deleteMemory.enabled = NO;
    }
//    NSArray *thearray = [self.navigationController.viewControllers copy];
//    int d = thearray.count;
//    NSLog(@"%d", d);
    // Do any additional setup after loading the view from its nib.
}

- (void)returnBack
{
//    [self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - method
- (IBAction)switchButtonPressed:(id)sender
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *blackList = [[NSMutableArray alloc] init];
    if([userDefaults objectForKey:@"blacklist"]){
        blackList = [[userDefaults objectForKey:@"blacklist"] mutableCopy];
    }
    UISwitch *switchs = (UISwitch*)sender;
    if(switchs.on == YES){
        if([blackList containsObject:_friendJid.user]){
            
        }else{
            [blackList addObject:_friendJid.user];
        }
    }else{
        if([blackList containsObject:_friendJid.user]){
            [blackList removeObject:_friendJid.user];
        }else{
            
        }
    }
    [userDefaults setObject:blackList forKey:@"blacklist"];
    [userDefaults synchronize];
}

- (IBAction)deleteFriendButtonPressed:(id)sender
{

}

- (IBAction)deleteMemory:(id)sender
{
    NSArray *theArray = [[NSUserDefaults standardUserDefaults] objectForKey:_chatWithUser];
    if(theArray.count > 0){
        for(int i = 0; i < theArray.count; i++){
            NSMutableDictionary *dict = [theArray objectAtIndex:i];
            //消息
            NSString *message = [dict objectForKey:@"msg"];
            if([message isEqualToString:@"audio1211"]){
                NSString *strUrl = [NSString stringWithFormat:@"%@/%@.wav", [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], [[theArray objectAtIndex:i] objectForKey:@"audioUrl"]];
                NSFileManager *fileManger = [NSFileManager defaultManager];
                if([fileManger fileExistsAtPath:strUrl]){
                    [fileManger removeItemAtPath:strUrl error:nil];
                }
            }
        }
    }
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:nil forKey:_chatWithUser];
    [userDefault synchronize];
    UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"删除成功！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertview.tag = 2222;
    [alertview show];
    deleteMemory.enabled = NO;
}

#pragma mark -UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 2222){
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
