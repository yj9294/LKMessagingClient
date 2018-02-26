//
//  LKChatroomManagerDelegate.h
//  LKMessagingClient
//
//  Created by cptech on 2018/2/23.
//  Copyright © 2018年 links123_yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LKChatroomManagerDelegate <NSObject>

@optional

/*!
 *  \~chinese
 *  有用户加入聊天室
 *
 *  @param aChatroom    加入的聊天室
 *  @param aUsername    加入者
 *
 *  \~english
 *  Delegate method will be invoked when a user joins a chatroom.
 *
 *  @param aChatroom    Joined chatroom
 *  @param aUsername    The user who joined chatroom
 */
- (void)userDidJoinChatroom:(LKChatroom *)aChatroom
                       user:(NSString *)aUsername;

/*!
 *  \~chinese
 *  有用户离开聊天室
 *
 *  @param aChatroom    离开的聊天室
 *  @param aUsername    离开者
 */
- (void)userDidLeaveChatroom:(LKChatroom *)aChatroom
                        user:(NSString *)aUsername;

@end
