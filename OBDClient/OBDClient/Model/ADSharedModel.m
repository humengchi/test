//
//  ADSharedModel.m
//  OBDClient
//
//  Created by lbs anydata on 14-2-21.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import "ADSharedModel.h"

@implementation ADSharedModel

- (id)init
{
    if (self = [super init])
    {
        _scene = WXSceneSession;
    }
    return self;
}

- (void)changeScene:(int)index{
    if(index == 0){
        _scene = WXSceneSession;
    }else if (index == 1){
        _scene = WXSceneTimeline;
    }
}

- (void) sendTextContent:(NSString *)content
{
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = [NSString stringWithFormat:@"车随行给我推送了消息：<%@>%@",content,@"你也来体验一下！https://itunes.apple.com/us/app/che-sui-xing/id789620165?ls=1&mt=8"];
    req.bText = YES;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendLinkContentWithTitle:(NSString *)aTitle description:(NSString *)aDescription image:(NSString *)aImage url:(NSString *)aUrl{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = aTitle;
    message.description = aDescription;
    [message setThumbImage:[UIImage imageNamed:aImage]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = aUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendLinkContent
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"车随行";
    message.description = @"一款融汽车安全驾驶助手、远程诊断及LBS位置服务为一体的智能型客户端产品，该产品不仅有综合报警信息、数据采集分析等基本功能，还增加了定位追踪、地图导航和行车记录，帮助消费者了解自己的爱车，具有更完美的驾驶体验。";
    [message setThumbImage:[UIImage imageNamed:@"icon.png"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://mp.weixin.qq.com/mp/appmsg/show?__biz=MzA4NzMwNDUwMQ==&appmsgid=200039988&itemidx=1&sign=abdca3946d4c6261a9cec687e6c2d174#wechat_redirect";
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (void) sendImageContentWithImage:(UIImage *)aImage
{
    WXMediaMessage *message = [WXMediaMessage message];
    
    [message setThumbImage:[self scaleImage:aImage ToSize:CGSizeMake(300, 300)]];
    
    WXImageObject *ext = [WXImageObject object];
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"icon" ofType:@"png"];
//    NSLog(@"filepath :%@",filePath);
//    ext.imageData = [NSData dataWithContentsOfFile:filePath];
//    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation([self scaleImage:aImage ToSize:CGSizeMake(600, 600)]);
//    ext.imageUrl=@"https://itunes.apple.com/us/app/che-sui-xing/id789620165?ls=1&mt=8";
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = _scene;
    
    [WXApi sendReq:req];
}

- (UIImage *)scaleImage:(UIImage *)aImage ToSize:(CGSize)newSize{
    UIGraphicsBeginImageContext(newSize);
    [aImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
