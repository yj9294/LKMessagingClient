//
//  LKChatManager.h
//  Hyphenate
//
//  Created by cptech on 2017/11/16.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKError.h"
#import "LKMessage.h"
#import "LKConversation.h"
#import "LKChatManagerDelegate.h"
@protocol LKIChatManager <NSObject>

@required

#pragma mark - Delegate

/*!
 *  \~chinese
 *  添加回调代理
 *
 */
- (void)addDelegate:(id<LKChatManagerDelegate>) delegate;

/*!
 *  \~chinese
 *  移除回调代理
 *
 */
- (void)removeDelegate;

#pragma mark - Conversation

/*!
 *  \~chinese
 *  获取所有会话，如果内存中不存在会从DB中加载
 * 
 */
- (void)getAllConversations:(void (^)(NSArray * array)) aCompletionBlock;

/*!
 *  \~chinese
 *  获取一个会话
 *
 *  @param aConversationId  会话ID
 *  @param aType            会话类型
 *  @param aIfCreate        如果不存在是否创建
 *
 *  @result 会话对象
 *
 *
 */
- (LKConversation *)getConversation:(NSString *)aConversationId
                               type:(LKConversationType)aType
                   createIfNotExist:(BOOL)aIfCreate;

/*!
 *  \~chinese
 *  删除会话
 *
 *  @param aConversationId      会话ID
 *  @param aIsDeleteMessages    是否删除会话中的消息
 *  @param aCompletionBlock     完成的回调
 *
 */
- (void)deleteConversation:(NSString *)aConversationId
          isDeleteMessages:(BOOL)aIsDeleteMessages
                completion:(void (^)(NSString *aConversationId, LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  删除一组会话
 *
 *  @param aConversations       会话列表<EMConversation>
 *  @param aIsDeleteMessages    是否删除会话中的消息
 *  @param aCompletionBlock     完成的回调
 *
 */
- (void)deleteConversations:(NSArray *)aConversations
           isDeleteMessages:(BOOL)aIsDeleteMessages
                 completion:(void (^)(LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  导入一组会话到DB
 *
 *  @param aConversations   会话列表<EMConversation>
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)importConversations:(NSArray *)aConversations
                 completion:(void (^)(LKError *aError))aCompletionBlock;

#pragma mark - Message

/*!
 *  \~chinese
 *  获取消息附件路径, 存在这个路径的文件，删除会话时会被删除
 *
 *  @param aConversationId  会话ID
 *
 *  @result 附件路径
 *
 */
- (NSString *)getMessageAttachmentPath:(NSString *)aConversationId;

/*!
 *  \~chinese
 *  导入一组消息到DB
 *
 *  @param aMessages        消息列表<EMMessage>
 *  @param aCompletionBlock 完成的回调
 *
 */
- (void)importMessages:(NSArray *)aMessages
            completion:(void (^)(LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  更新消息到DB
 *
 *  @param aMessage         消息
 *  @param aCompletionBlock 完成的回调
 *
 */
- (void)updateMessage:(LKMessage *)aMessage
           completion:(void (^)(LKMessage *aMessage, LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  发送消息已读回执
 *
 *  异步方法
 *
 *  @param aMessage             消息
 *  @param aCompletionBlock     完成的回调
 *
 */
- (void)sendMessageReadAck:(LKMessage *)aMessage
                completion:(void (^)(LKMessage *aMessage, LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  发送消息
 *
 *  @param aMessage         消息
 *  @param aProgressBlock   附件上传进度回调block
 *  @param aCompletionBlock 发送完成回调block
 *
 */
- (void)sendMessage:(LKMessage *)aMessage
           progress:(void (^)(int progress))aProgressBlock
         completion:(void (^)(LKMessage *message, LKError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  重发送消息
 *
 *  @param aMessage         消息
 *  @param aProgressBlock   附件上传进度回调block
 *  @param aCompletionBlock 发送完成回调block
 *
 */
- (void)resendMessage:(LKMessage *)aMessage
             progress:(void (^)(int progress))aProgressBlock
           completion:(void (^)(LKMessage *message, LKError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  下载缩略图（图片消息的缩略图或视频消息的第一帧图片），SDK会自动下载缩略图，所以除非自动下载失败，用户不需要自己下载缩略图
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletionBlock    下载完成回调block
 *
 */
- (void)downloadMessageThumbnail:(LKMessage *)aMessage
                        progress:(void (^)(int progress))aProgressBlock
                      completion:(void (^)(LKMessage *message, LKError *error))aCompletionBlock;

/*!
 *  \~chinese
 *  下载消息附件（语音，视频，图片原图，文件），SDK会自动下载语音消息，所以除非自动下载语音失败，用户不需要自动下载语音附件
 *
 *  异步方法
 *
 *  @param aMessage            消息
 *  @param aProgressBlock      附件下载进度回调block
 *  @param aCompletionBlock    下载完成回调block
 *
 */
- (void)downloadMessageAttachment:(LKMessage *)aMessage
                         progress:(void (^)(int progress))aProgressBlock
                       completion:(void (^)(LKMessage *message, LKError *error))aCompletionBlock;



- (void)readAllMsgOfUser:(int)userId toServer:(BOOL)bToServer;

- (void)deleteMessage:(NSString *)msg_id
           completion:(void (^)(LKMessage *aMessage, LKError *aError))aCompletionBlock;

- (NSArray *)getAllMessageOfAConversatioin:(NSString *)friend_id;

//- (void)getHistoryMsg:(int)friend_id completion:(void (^)(void))aCompletionBlock;
@end
