//
//  LKChatManagerDelegate.h
//  Hyphenate
//
//  Created by cptech on 2017/11/23.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
@class LKMessage;
@protocol LKChatManagerDelegate <NSObject>
#pragma mark - Conversation

/*!
 *  \~chinese
 *  会话列表发生变化
 *
 */
- (void)conversationListDidUpdate:(NSArray *)aConversationList;

#pragma mark - Message

/*!
 *  \~chinese
 *  收到消息
 *
 */
- (void)messagesDidReceive:(LKMessage *)aMessages;

/*!
 *  \~chinese
 *  收到消息
 *
 */
- (void)onConnection;
- (void)onDisconnection;
@end
