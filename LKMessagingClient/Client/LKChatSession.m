//
//  ChatSession.m
//  Hyphenate
//
//  Created by cptech on 2017/11/13.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import "LKChatSession.h"

@implementation LKChatSession

- (instancetype)initWithDevice:(NSString *)aDevice os:(NSString *)os osVersion:(NSString *)osVersion app:(NSString *)app appVersion:(NSString *)appVersion token:(NSString *)token{
    
    if(self = [super init]){
        _device = aDevice;
        _os = os;
        _osVersion = osVersion;
        _app = app;
        _appVersion = appVersion;
        _token = token;
    }
    return self;
}

@end
