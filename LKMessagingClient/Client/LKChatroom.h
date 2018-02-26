//
//  LKChatroom.h
//  LKMessagingClient
//
//  Created by cptech on 2018/2/23.
//  Copyright © 2018年 links123_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 *  \~chinese
 *  聊天室成员类型
 *
 *  \~english
 *  Chat room permission type
 */
typedef enum{
    LKChatroomPermissionTypeNone   = -1,    /*! \~chinese 未知 \~english Unknown */
    LKChatroomPermissionTypeMember = 0,     /*! \~chinese 普通成员 \~english Normal member */
    LKChatroomPermissionTypeAdmin,          /*! \~chinese 群组管理员 \~english Group admin */
    LKChatroomPermissionTypeOwner,          /*! \~chinese 群主 \~english Group owner  */
}LKChatroomPermissionType;

@interface LKChatroom : NSObject

/*!
 *  \~chinese
 *  聊天室ID
 *
 */
@property (nonatomic, copy) NSString *chatroomId;

/*!
 *  \~chinese
 *  聊天室的主题
 *
 */
@property (nonatomic, copy) NSString *subject;

/*!
 *  \~chinese
 *  聊天室的描述
 *
 */
@property (nonatomic, copy) NSString *descrip;

/*!
 *  \~chinese
 *  聊天室的公告
 *
 */
@property (nonatomic, copy) NSString *notice;
/*!
 *  \~chinese
 *  聊天室的所有者，需要获取聊天室详情
 *
 *  聊天室的所有者只有一人
 *
 */
@property (nonatomic, copy) NSString *owner;

/*!
 *  \~chinese
 *  聊天室的管理者，拥有群的最高权限，需要获取群详情
 *
 *
 */
@property (nonatomic, copy) NSArray *adminList;

/*!
 *  \~chinese
 *  聊天室的成员列表，需要获取聊天室详情
 */
@property (nonatomic, copy) NSArray *memberList;

/*!
 *  \~chinese
 *  聊天室的黑名单，需要先调用获取群黑名单方法
 *
 *  需要owner权限才能查看，非owner返回nil
 *
 */
@property (nonatomic, strong) NSArray *blacklist;

/*!
 *  \~chinese
 *  聊天室的被禁言列表<NSString>
 *
 *  需要owner权限才能查看，非owner返回nil
 */
@property (nonatomic, strong) NSArray *muteList;

/*!
 *  \~chinese
 *  当前登录账号的聊天室成员类型
 *
 */
@property (nonatomic, assign) LKChatroomPermissionType permissionType;

/*!
 *  \~chinese
 *  聊天室的最大人数，如果没有获取聊天室详情将返回0
 *
 */
@property (nonatomic,assign) NSInteger maxOccupantsCount;

/*!
 *  \~chinese
 *  聊天室的当前人数，如果没有获取聊天室详情将返回0
 */
@property (nonatomic, assign) NSInteger occupantsCount;

/*!
 *  \~chinese
 *  获取聊天室实例
 *
 *  @param aChatroomId   聊天室ID
 *
 *  @result 聊天室实例
 */
+ (instancetype)chatroomWithId:(NSString *)aChatroomId;

/*!
 *  \~chinese
 *  聊天室的成员列表，需要获取聊天室详情
 *
 */
@property (nonatomic, copy) NSArray *members;

/*!
 *  \~chinese
 *  聊天室的当前人数，如果没有获取聊天室详情将返回0
 *
 */
@property (nonatomic, assign) NSInteger membersCount;
/*!
 *  \~chinese
 *  聊天室的图标
 *
 */
@property (nonatomic, copy) NSString *avatar;

/*!
 *  \~chinese
 *  聊天室的大图
 *
 */
@property (nonatomic, copy) NSString *cover;
/*!
 *  \~chinese
 *  聊天室的公告
 *
 */
@property (nonatomic, copy) NSString *welcomeMessage;

/*!
 *  \~chinese
 *  初始化聊天室实例
 *
 */
- (instancetype)init;

@end

@interface LKChatroomMemeber : NSObject

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *nickname;

@property (nonatomic, copy) NSString *avatar;

@property (nonatomic, copy) NSString *mark;

@property (nonatomic, assign) LKChatroomPermissionType type;

@property (nonatomic, copy) NSString *firstLetter;

@end

