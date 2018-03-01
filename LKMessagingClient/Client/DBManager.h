//
//  DBManager.h
//  Hyphenate
//
//  Created by Tang on 2017/11/29.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKConversation.h"
#import "FriendModel.h"

//typedef NS_ENUM(int, FRIEND_TYPE) {
//    TYPE_ATTENTION = 1,
//    TYPE_FANS = 2,
//    TYPE_FRIEND = 3,
//};

@interface DBManager : NSObject

+ (instancetype)sharedManager;

- (NSArray *)dbGetAttentions:(int)user_id;
- (NSArray *)dbGetFans:(int)user_id;
- (NSArray *)dbGetFriends:(int)user_id;
- (void)dbAddAttentions:(NSArray *)array user_id:(int)user_id;
- (void)dbAddFans:(NSArray *)array user_id:(int)user_id;
//- (void)dbRemoveFans:(int)friend_id user_id:(int)user_id;
//- (void)dbRemoveAttention:(int)friend_id user_id:(int)user_id;
- (BOOL)isUserHasAttention:(int)user_id;
- (int)getUserAttentionType:(int)user_id;
- (BOOL)isUserHasMask:(int)user_id;
- (BOOL)isUserStick:(int)user_id;
- (void)setUserStick:(int)user_id bStick:(BOOL)bStick;

- (NSArray *)dbGetAllConversations;
- (LKConversation *)dbGetConversation:(NSString *)aConversationId
                                 type:(LKConversationType)aType;
//
//- (LKConversation *)dbCreateConversation:(NSString *)aConversationId
//                                    type:(LKConversationType)aType;
//- (void)dbDeleteConversation:(NSString *)aConversationId;

- (void)dbDeleteConversation:(NSString *)aConversationId;
- (void)dbUpdateConversation:(NSString *)aConversationId latestMessage:(LKMessage *)msg;
- (void)dbUpdateConversation:(LKConversation *)aConversation;
- (void)dbConversationReadAMessage:(NSString *)aConversationId;
- (void)dbConversationReadAllMessage:(NSString *)aConversationId;


- (void)dbDeleteMessageByConversationId:(NSString *)aConversationId;
- (void)dbUpdateMessage:(LKMessage *)aMessage;
- (void)dbUpdateMessageServiced:(LKMessage *)aMessage;
- (void)dbUpdateMessageRead:(LKMessage *)aMessage;

- (int)dbGetAllUnreadCount;

- (NSArray *)dbGetAllMsg:(NSString *)toId;

- (NSArray *)dbGetAllMsg:(int)userId
               toId:(NSString *)toId;
//根据用户id和好友id删除两人之间的对话
- (BOOL)dbDeleteAllMsg:(int)userId toId:(NSString *)toId;
//根据聊天室id删除聊天室消息
- (BOOL)dbDeleteAllRoomMsg:(NSString *)roomId;
- (void)dbSetAllMsgRead:(int)userId
              toId:(NSString *)toId;

- (int)dbGetAllMsgRead:(int)userId
             toId:(NSString *)toId;
@end
