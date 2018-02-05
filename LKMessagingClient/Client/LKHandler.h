//
//  LKhandler.h
//  Hyphenate
//
//  Created by cptech on 2017/11/15.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKClient.h"
#import "LKHandlerContact.h"
//#import "LKHandlerMsg.h"

@interface LKHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSDictionary *result);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKHeartbeatHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSDictionary *result);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKLoginHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSDictionary *result);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKLogoutHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSDictionary *result);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKDelegateHandler :  NSObject <ExportHandler>
@property (nonatomic, copy) void (^succeed)(LKMessage *aMessage);
@end



@interface LKAcquireHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSArray <LKChatSession *> *list);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKConnectionHandler :  NSObject <ExportHandler>
//@property (nonatomic, copy) void (^succeed)(LKMessage *aMessage);
@property (nonatomic, copy) void (^onConnection)(LKMessage *aMessage);

@property (nonatomic, copy) void (^onDisconnect)(LKError *err);
@end

@interface LKMultiDeviceHandler :  NSObject <ExportHandler>
@property (nonatomic, copy) void (^onMessage)(int event, int from, int to);
@property (nonatomic, copy) void (^onContact)(int event);
@property (nonatomic, copy) void (^onGroup)(int event);
@end


