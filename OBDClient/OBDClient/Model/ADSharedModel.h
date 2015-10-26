//
//  ADSharedModel.h
//  OBDClient
//
//  Created by lbs anydata on 14-2-21.
//  Copyright (c) 2014年 AnyData.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXApi.h"

@interface ADSharedModel : NSObject
{
    enum WXScene _scene;
}

- (void) sendTextContent:(NSString *)content;

- (void) sendLinkContent;

- (void) sendImageContentWithImage:(UIImage *)aImage;

- (void) sendLinkContentWithTitle:(NSString *)aTitle description:(NSString *)aDescription image:(NSString *)aImage url:(NSString *)aUrl;

- (void)changeScene:(int)index;

@end
