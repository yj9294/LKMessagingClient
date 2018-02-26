//
//  LKIChatroomManager.h
//  LKMessagingClient
//
//  Created by cptech on 2018/2/23.
//  Copyright © 2018年 links123_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKChatroom.h"

@protocol LKIChatroomManager <NSObject>
@required
// 创建聊天室
- (void)createRoom:(LKChatroom *)room  block:(void(^)(NSString *roomId)) block;
//销毁聊天室
- (void)destroyChatroom:(NSString *)room_id block:(void(^)(BOOL bSuccess)) block;
//加入聊天室
- (void)joinChatroom:(NSString *)room_id block:(void(^)(BOOL bSuccess))block;
// 离开聊天室
- (void)leaveChatroom:(NSString *)room_id block:(void(^)(BOOL bSuccess)) block;

// 修改聊天室名称
- (void)updateChatroom:(NSString *)room_id subject:(NSString *)subject block:(void(^)(BOOL bSuccess)) block;
//修改聊天室描述信息
- (void)updateChatroom:(NSString *)room_id description:(NSString *)description block:(void(^)(BOOL bSuccess)) block;
// 修改聊天室公告
- (void)updateChatroom:(NSString *)room_id notice:(NSString *)notice block:(void(^)(BOOL bSuccess)) block;
//添加管理员
- (void)addChatRoom:(NSString *)room_id admin_id:(int)admin_id block:(void(^)(BOOL bSuccess)) block;
//删除管理员
- (void)removeChatRoom:(NSString *)room_id admin_id:(int)admin_id block:(void(^)(BOOL bSuccess)) block;
// 删除聊天室成员
- (void)removeChatRoom:(NSString *)room_id member:(int)member_id block:(void(^)(BOOL bSuccess)) block;
// 批量删除聊天室成员
- (void)removeChatRoom:(NSString *)room_id members:(NSArray *)member_list block:(void(^)(BOOL bSuccess)) block;


//获取聊天室详情 包括成员
- (void)fetchChatRoomMembersFromServer:(NSString *)room_id block:(void(^)(LKChatroom *room,NSArray *array)) block;
//获取聊天室详情 不包括成员信息
- (void)fetchChatRoomFromServer:(NSString *)room_id block:(void(^)(LKChatroom *room)) block;
//获取置顶聊天室列表
- (void)getStickRoomWithLang:(NSString *)lang block:(void(^)(NSArray *roomList)) block;

@end