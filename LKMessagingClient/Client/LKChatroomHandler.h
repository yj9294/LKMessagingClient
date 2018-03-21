//
//  LKChatroomHandler.h
//  LKMessagingClient
//
//  Created by cptech on 2018/2/23.
//  Copyright © 2018年 links123_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKChatroom.h"
#import "ChatModel.h"
#import "LKClient.h"

@interface LKChatroomHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(BOOL aBool);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKCreateChatroomHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSString *roomId);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKJoinChatroomHandler :  NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSArray <ChatModel *> *messageArray);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKGetHistoryHandler: NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSArray <ChatModel *> *messageArray);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKStickroomHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSInteger server_time, NSArray *room_list);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKFetchRoomDetailHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(LKChatroom *room,NSArray *memberList);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKFetchMembersAuthorityHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSArray *memberList);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end
