//
//  ADRoomChatViewController.m
//  OBDClient
//
//  Created by hmc on 13/11/14.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADRoomChatViewController.h"

@interface ADRoomChatViewController ()

@end

@implementation ADRoomChatViewController

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
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UIbutton_Methods

- (IBAction)createRoom:(UIButton *)sender
{
    [[self appDelegate] initxmpproom];
}

- (IBAction)joinRoom:(UIButton *)sender
{
    [[self appDelegate] joinroom];
}

//发送群消息
- (IBAction)sendPress:(UIButton *)sender
{
    //本地输入框中的信息
    NSString *message = self.sendtextfield.text;
    self.sendtextfield.text = @"";
    [self.sendtextfield resignFirstResponder];
    
    //本地输入框中的信息
    if (message.length > 0) {
        //XMPPFramework主要是通过KissXML来生成XML文件
        //生成<body>文档
        NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
        [body setStringValue:message];
        //生成XML消息文档
        NSXMLElement *mes = [NSXMLElement elementWithName:@"message"];
        //消息类型
        [mes addAttributeWithName:@"type" stringValue:@"groupchat"];
        //发送给谁
        [mes addAttributeWithName:@"to" stringValue:[NSString stringWithFormat:@"%@@%@", @"groupchat", [self xmppStream].myJID.domain]];
        //由谁发送
        [mes addAttributeWithName:@"from" stringValue:[NSString stringWithFormat:@"%@@%@",[self xmppStream].myJID.user, [self xmppStream].myJID.domain]];
        //组合
        [mes addChild:body];
        //发送消息
        [[self xmppStream] sendElement:mes];
        
    }
}

#pragma mark -ADAppDelegate
-(ADAppDelegate *)appDelegate{
    return (ADAppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(XMPPStream *)xmppStream{
    
    return [[self appDelegate] xmppStream];
}

-(XMPPRoom *)xmppRoom{
    
    return [[self appDelegate] xmppRoom];
}

@end
