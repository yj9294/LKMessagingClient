//
//  LKConversation.h
//  Hyphenate
//
//  Created by cptech on 2017/11/16.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *  Conversation type
 */
typedef enum{
    LKConversationTypeChat  = 0,    /*! \~chinese 单聊会话 \~english one to one chat room type */
    LKConversationTypeGroupChat,    /*! \~chinese 群聊会话 \~english Group chat room type */
    LKConversationTypeChatRoom      /*! \~chinese 聊天室会话 \~english Chatroom chat room type */
} LKConversationType;

/*
 *  \~chinese
 *  消息搜索方向
 *
 *  \~english
 *  Message search direction
 */
typedef enum{
    LKMessageSearchDirectionUp  = 0,    /*! \~chinese 向上搜索 \~english Search older messages */
    LKMessageSearchDirectionDown        /*! \~chinese 向下搜索 \~english Search newer messages */
} LKMessageSearchDirection;

@class LKMessage;
@class LKError;

/*!
 *  \~chinese
 *  聊天会话
 *
 *  \~english
 *  Chat conversation
 */
@interface LKConversation : NSObject

/*!
 *  \~chinese
 *  会话唯一标识
 *
 *  \~english
 *  Unique identifier of conversation
 */
@property (nonatomic, copy, readonly) NSString *conversationId;

/*!
 *  \~chinese
 *  会话类型
 *
 *  \~english
 *  Conversation type
 */
@property (nonatomic, assign, readonly) LKConversationType type;

/*!
 *  \~chinese
 *   会话未读消息数量
 *
 *  \~english
 *  Count of unread messages
 */
@property (nonatomic, assign) int unreadMessagesCount;
@property (nonatomic, strong) NSString *latestMessageText;
@property (nonatomic ) int latestMessageTime;
@property (nonatomic, strong) NSString *from;
@property (nonatomic ) BOOL bStick;
/*!
 *  \~chinese
 *  会话扩展属性
 *
 *  \~english
 *  Conversation extension property
 */
@property (nonatomic, copy) NSDictionary *ext;

/*!
 *  \~chinese
 *  会话最新一条消息
 *
 *  \~english
 *  Conversation latest message
 */
@property (nonatomic, strong) LKMessage *latestMessage;

/*!
 *  \~chinese
 *  插入一条消息，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage 消息实例
 *  @param pError   错误信息
 *
 */
- (void)insertMessage:(LKMessage *)aMessage
                error:(LKError **)pError;

/*!
 *  \~chinese
 *  插入一条消息到会话尾部，消息的conversationId应该和会话的conversationId一致，消息会被插入DB，并且更新会话的latestMessage等属性
 *
 *  @param aMessage 消息实例
 *  @param pError   错误信息
 *
 */
- (void)appendMessage:(LKMessage *)aMessage
                error:(LKError **)pError;

/*!
 *  \~chinese
 *  删除一条消息
 *
 *  @param aMessageId   要删除消失的ID
 *  @param pError       错误信息
 *
 */
- (void)deleteMessageWithId:(NSString *)aMessageId
                      error:(LKError **)pError;

/*!
 *  \~chinese
 *  删除该会话所有消息
 *  @param pError       错误信息
 */
- (void)deleteAllMessages:(LKError **)pError;

/*!
 *  \~chinese
 *  更新一条消息，不能更新消息ID，消息更新后，会话的latestMessage等属性进行相应更新
 *
 *  @param aMessage 要更新的消息
 *  @param pError   错误信息
 *
 */
- (void)updateMessageChange:(LKMessage *)aMessage
                      error:(LKError **)pError;

/*!
 *  \~chinese
 *  将消息设置为已读
 *
 *  @param aMessageId   要设置消息的ID
 *  @param pError       错误信息
 *
 *
 */
- (void)markMessageAsReadWithId:(NSString *)aMessageId
                          error:(LKError **)pError;

/*!
 *  \~chinese
 *  将所有未读消息设置为已读
 *
 *  @param pError   错误信息
 *
 *
 */
- (void)markAllMessagesAsRead:(LKError **)pError;

/*!
 *  \~chinese
 *  获取指定ID的消息
 *
 *  @param aMessageId       消息ID
 *  @param pError           错误信息
 *
 *
 */
- (LKMessage *)loadMessageWithId:(NSString *)aMessageId
                           error:(LKError **)pError;

/*!
 *  \~chinese
 *  收到的对方发送的最后一条消息
 *
 *  @result 消息实例
 *
 */
- (LKMessage *)lastReceivedMessage;

#pragma mark - Async method

/*!
 *  \~chinese
 *  从数据库获取指定数量的消息，取到的消息按时间排序，并且不包含参考的消息，如果参考消息的ID为空，则从最新消息取
 *
 *  @param aMessageId       参考消息的ID
 *  @param count            获取的条数
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
 */
- (void)loadMessagesStartFromId:(NSString *)aMessageId
                          count:(int)aCount
                searchDirection:(LKMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取指定类型的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息取，如果aCount小于等于0当作1处理
 *
 *  @param aTimestamp       参考时间戳
 *  @param aCount           获取的条数
 *  @param aUsername        消息发送方，如果为空则忽略
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)loadMessagesWithTimestamp:(long long)aTimestamp
                       count:(int)aCount
                    fromUser:(NSString*)aUsername
             searchDirection:(LKMessageSearchDirection)aDirection
                  completion:(void (^)(NSArray *aMessages, LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取包含指定内容的消息，取到的消息按时间排序，如果参考的时间戳为负数，则从最新消息向前取，如果aCount小于等于0当作1处理
 *
 *  @param aKeywords        搜索关键字，如果为空则忽略
 *  @param aTimestamp       参考时间戳
 *  @param aCount           获取的条数
 *  @param aSender          消息发送方，如果为空则忽略
 *  @param aDirection       消息搜索方向
 *  @param aCompletionBlock 完成的回调
 *
 *  \~english
 *  Load messages with specified keyword, returning messages are sorted by receiving timestamp. If reference timestamp is negative, load from the latest messages; if message count is negative, count deal with 1 and load one message that meet the condition.
 *
 */
- (void)loadMessagesWithKeyword:(NSString*)aKeyword
                      timestamp:(long long)aTimestamp
                          count:(int)aCount
                       fromUser:(NSString*)aSender
                searchDirection:(LKMessageSearchDirection)aDirection
                     completion:(void (^)(NSArray *aMessages, LKError *aError))aCompletionBlock;

/*!
 *  \~chinese
 *  从数据库获取指定时间段内的消息，取到的消息按时间排序，为了防止占用太多内存，用户应当制定加载消息的最大数
 *
 *  @param aStartTimestamp  毫秒级开始时间
 *  @param aEndTimestamp    结束时间
 *  @param aCount           加载消息最大数
 *  @param aCompletionBlock 完成的回调
 *
 *
 */
- (void)loadMessagesFrom:(long long)aStartTimestamp
                      to:(long long)aEndTimestamp
                   count:(int)aCount
              completion:(void (^)(NSArray *aMessages, LKError *aError))aCompletionBlock;

- (instancetype)initWithId:(NSString *)ID andType:(LKConversationType)type;

@end
