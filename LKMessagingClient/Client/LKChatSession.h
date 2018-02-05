//
//  ChatSession.h
//  Hyphenate
//
//  Created by cptech on 2017/11/13.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKChatSession : NSObject

@property (nonatomic, readonly) NSString *device;

@property (nonatomic, readonly) NSString *os;

@property (nonatomic, readonly) NSString *osVersion;

@property (nonatomic, readonly) NSString *app;

@property (nonatomic, readonly) NSString *appVersion;

@property (nonatomic, readonly) NSString *token;

- (instancetype)initWithDevice:(NSString *)aDevice os:(NSString *)os osVersion:(NSString *)osVersion app:(NSString *)app appVersion:(NSString *)appVersion token:(NSString *)token;
@end
