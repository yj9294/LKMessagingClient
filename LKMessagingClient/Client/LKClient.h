//
//  LinkExportClient.h
//  Hyphenate
//
//  Created by cptech on 2017/11/13.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <Export/Export.h>

#import "LKError.h"
#import "LKTextMessageBody.h"


#import "LKMessage.h"
#import "LKChatSession.h"

#import "LKHandler.h"

#import "LKClientDelegate.h"
#import "LKChatManagerDelegate.h"

#import "LKIChatManager.h"
#import "LKIChatroomManager.h"

//#import "DBManager.h"
#import "LKIContactManager.h"
@interface LKClient : NSObject

//{
//    EMPushOptions *_pushOptions;
//}

/*!
 *  \~chinese
 *  SDK版本号
 *
 *  \~english
 *  SDK version
 */
@property (nonatomic, strong, readonly) NSString *version;

/*!
 *  \~chinese
 *  当前登录账号
 *
 *  \~english
 *  Current logged in user's username
 */
@property (nonatomic, strong, readonly) NSString *currentUsername;

///*!
// *  \~chinese
// *  SDK属性
// *
// *  \~english
// *  SDK setting options
// */
//@property (nonatomic, strong, readonly) EMOptions *options;
//
///*!
// *  \~chinese
// *  推送设置
// *
// *  \~english
// *  Apple Push Notification Service setting
// */
//@property (nonatomic, strong, readonly) EMPushOptions *pushOptions;

/*!
 *  \~chinese
 *  聊天模块
 *
 *  \~english
 *  Chat Management
 */
//@property (nonatomic, strong, readonly) id<IEMChatManager> chatManager;

///*!
// *  \~chinese
// *  好友模块
// *
// *  \~english
// *  Contact Management
// */
//@property (nonatomic, strong, readonly) id<IEMContactManager> contactManager;

///*!
// *  \~chinese
// *  群组模块
// *
// *  \~english
// *  Group Management
// */
//@property (nonatomic, strong, readonly) id<IEMGroupManager> groupManager;

///*!
// *  \~chinese
// *  聊天室模块
// *
// *  \~english
// *  Chat room Management
// */
//@property (nonatomic, strong, readonly) id<IEMChatroomManager> roomManager;

/*!
 *  \~chinese
 *  用户是否已登录
 *
 *  \~english
 *  If a user logged in
 */
@property (nonatomic, readonly) BOOL isLoggedIn;

/*!
 *  \~chinese
 *  用户是否开启自动登陆
 */
@property (nonatomic, readonly) BOOL isAuthLoggedIn;

/*!
 *  \~chinese
 *  是否连上聊天服务器
 *
 *  \~english
 *  Connection status to Hyphenate IM server
 */
//@property (nonatomic, readonly) BOOL isConnected;

/*!
 *  \~chinese
 *  发送心跳包时间
 *
 */
@property (nonatomic, assign) NSTimeInterval retryInterval;

/*!
 *  \~chinese
 *  获取SDK实例
 *
 *  \~english
 *  Get SDK singleton instance
 */
+ (instancetype)sharedClient;

- (instancetype)initWithOptions:(NSDictionary *)options;

/*!
 *  \~chinese
 *  开启链接
 *
 */
//- (BOOL)openConnect;
//
///*!
// *  \~chinese
// *  关闭链接
// *
// */
//- (BOOL)closeConnect;

/*!
 *  \~chinese
 *  聊天管理
 *
 */
@property (nonatomic, strong, readonly) id<LKIChatManager> chatManager;

@property (nonatomic, strong, readonly) id<LKIContactManager> contactManager;

@property (nonatomic, strong, readonly) id<LKIChatroomManager> roomManager;

///*!
// *  \~chinese
// *  初始化会话
// *
// *
// *  param successful 成功
// *  param error 错误
// *
// */
//- (void)initializeSessionSuccessful:(void(^)(NSDictionary *result))successful error:(void(^)(LKError *err))error;
//
///*!
// *  \~chinese
// *  心跳包
// *
// *  param successful 成功
// *  param error 错误
// *
// */
//- (void)heartbeatSuccessful:(void(^)(NSDictionary *result))successful error:(void(^)(LKError *err))error;
//
///*!
// *  \~chinese
// *  登陆操作(同步调用，阻塞住线程)
// *
// *
// *  param aUsername 账户
// *  param aPassword 密码
// *
// */
//
//- (LKError *)loginWithUsername:(NSString *)     aUsername
//                       password:(NSString *)     aPassword;


/*!
 *  \~chinese
 *  登陆操作(同步调用)
 *
 *
 *  param aUsername 账户
 *  param aPassword 密码
 *
 */

- (void)login;

- (void) loginWithUsername:(NSString *)aUsername
                  password:(NSString *)aPassword
                completion:(void(^)(NSString *aUsername, LKError *aError))aCompletionBlock;
- (void)loginWithToken:(NSString *)token;

//- (void) loginWithUsername:(NSString *)aUsername
//                  password:(NSString *)aPassword
//                completion:(void(^)(NSString *aUsername, LKError *aError))aCompletionBlock;
/*!
 *  \~chinese
 *  登出操作(异步返回)
 *
 *
 * param aCompletionBlock 回调block
 *
 */

//- (void)sendMessage:(LKMessage *)aMessage progress:(void (^)(int))aProgressBlock completion:(void (^)(LKMessage *, LKError *))aCompletionBlock;
//
//- (void)sendMessageReadAck:(LKMessage *)aMessage
//                completion:(void (^)(LKMessage *aMessage, LKError *aError))aCompletionBlock;
//
//- (void)deleteMessage:(NSString *)msg_id
//                completion:(void (^)(LKMessage *aMessage, LKError *aError))aCompletionBlock;

- (void)logoutCompletion:(void(^)(LKError *aError))aCompletionBlock;

- (BOOL)asyncSend:(NSString*)operator param:(NSData*)param callback:(id<ExportRequestStatusCallback>)callback error:(NSError**)error;
/*!
 *  \~chinese
 *  获取用户设备信息
 *
 *
 * param aCompletionBlock 回调block
 *
 */



- (void)getDeviceInfo:(void(^)(NSArray  <LKChatSession *> *sessionList, LKError *aError))aCompletionBlock;

- (int)getUnreadMsgCount;

@end
