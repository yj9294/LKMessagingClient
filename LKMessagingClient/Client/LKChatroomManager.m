//
//  LKChatroomManager.m
//  LKMessagingClient
//
//  Created by cptech on 2018/2/23.
//  Copyright © 2018年 links123_yj. All rights reserved.
//

#import "LKChatroomManager.h"
#import "LKError.h"
#import "LKClient.h"
#import "LKChatroomHandler.h"
#import "DBManager.h"

@interface LKChatroomManager()

@property (nonatomic, strong)LKClient *client;
@property (nonatomic, strong)DBManager *db;

@end


@implementation LKChatroomManager

- (instancetype)init
{
    if (self = [super init]) {
        _client = [LKClient sharedClient];
        _db = [DBManager sharedManager];
    }
    return self;
}
/**
 *  创建聊天室 {"subject":"test","description":"test chatroom","welcome_message":"welcome to chatroom","max":1000}
 *
 */
- (void)createRoom:(LKChatroom *)room  block:(void(^)(NSString *roomId)) block{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room.subject, @"subject",room.descrip,@"description",room.welcomeMessage,@"welcome_message",@(room.maxOccupantsCount),@"max",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKCreateChatroomHandler *handler = [[LKCreateChatroomHandler alloc] init];
    handler.succeed = ^(NSString *roomId) {
        block(roomId);
    };

    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(nil);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/create/chatroom" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}
/**
 *  销毁聊天室 {"room_id":"5a8bce182b934169cf517b41"}
 *
 */
- (void)destroyChatroom:(NSString *)room_id block:(void(^)(BOOL bSuccess)) block{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/destroy/chatroom" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}
/**
 *  加入聊天室{"room_id":"5a8bce182b934169cf517b41","member":45}
 *
 */
- (void)joinChatroom:(NSString *)room_id block:(void (^)(BOOL))block{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/join/chatroom" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  离开聊天室 {"room_id":"5a8bce182b934169cf517b41"}
 *
 */
- (void)leaveChatroom:(NSString *)room_id block:(void (^)(BOOL))block{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",nil];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/leave/chatroom" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}
/**
 *  获取聊天室详情 {"room_id":"5a8bce182b934169cf517b41","fetch_members":true}
 *
 */
- (void)fetchChatRoomMembersFromServer:(NSString *)room_id block:(void(^)(LKChatroom *room,NSArray *array)) block{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",@YES,@"fetch_members", nil];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKFetchRoomDetailHandler *handler = [[LKFetchRoomDetailHandler alloc] init];
    
    handler.succeed = ^(LKChatroom *room,NSArray *array) {
        //   aCompletionBlock(aMessage2, nil);
        block(room,array);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(nil,nil);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/get/chatroom/profile" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
    
}


/**
 *  获取置顶聊天室列表 {"lang":"en-us","cache_time":1519251378}
 *
 */
- (void)getStickRoomWithLang:(NSString *)lang block:(void (^)(NSArray *roomList))block{
    
//    NSInteger cache_time = [[NSUserDefaults standardUserDefaults]integerForKey:@"chatroom_last_cache_time"];
    NSInteger cache_time = 0;

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:lang, @"lang",@(cache_time) ,@"cache_time",nil];

    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKStickroomHandler *handler = [[LKStickroomHandler alloc] init];
    
    handler.succeed = ^(NSInteger server_time, NSArray *room_list) {
        //   aCompletionBlock(aMessage2, nil);
        NSLog(@"%s success", __func__);
        [[NSUserDefaults standardUserDefaults]setInteger:server_time forKey:@"chatroom_last_cache_time"];
        block(room_list);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(nil);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/fetch/stick/chatroom" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  获取聊天室详情 {"room_id":"5a8bce182b934169cf517b41","fetch_members":false}
 *
 */
- (void)fetchChatRoomFromServer:(NSString *)room_id block:(void(^)(LKChatroom *room)) block{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",@NO,@"fetch_members", nil];
    
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKFetchRoomDetailHandler *handler = [[LKFetchRoomDetailHandler alloc] init];
    
    handler.succeed = ^(LKChatroom *room,NSArray *array) {
        //   aCompletionBlock(aMessage2, nil);
        block(room);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(nil);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/get/chatroom/profile" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}
/**
 *  添加管理员 {"room_id":"5a8bce182b934169cf517b41","admin_id":217}
 *
 */
- (void)addChatRoom:(NSString *)room_id admin_id:(int)admin_id block:(void (^)(BOOL))block {
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",@(admin_id),@"admin_id",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/add/chatroom/admin" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  删除管理员 {"room_id":"5a8bce182b934169cf517b41","admin_id":217}
 *
 */
- (void)removeChatRoom:(NSString *)room_id admin_id:(int)admin_id block:(void (^)(BOOL))block {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",@(admin_id),@"admin_id",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/remove/chatroom/admin" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  删除聊天室成员 {"room_id":"5a8bce182b934169cf517b41","member":217}
 *
 */
- (void)removeChatRoom:(NSString *)room_id member:(int)member_id block:(void (^)(BOOL))block {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",@(member_id),@"member",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/remove/chatroom/member" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  批量删除聊天室成员 {"room_id":"5a8bce182b934169cf517b41","member":[21,45]}
 *
 */
- (void)removeChatRoom:(NSString *)room_id members:(NSArray *)member_list block:(void (^)(BOOL))block {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",member_list,@"members",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/remove/chatroom/members" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  修改聊天室描述信息  {"room_id":"5a8bce182b934169cf517b41","description":"new description"}
 *
 */
- (void)updateChatroom:(NSString *)room_id description:(NSString *)description block:(void (^)(BOOL))block {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",description,@"description",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/update/chatroom/description" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  修改聊天室公告 {"room_id":"5a8bce182b934169cf517b41","notice":"new notice"}
 *
 */
- (void)updateChatroom:(NSString *)room_id notice:(NSString *)notice block:(void (^)(BOOL))block {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",notice,@"notice",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/update/chatroom/notice" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

/**
 *  修改聊天室名称 {"room_id":"5a8bce182b934169cf517b41","subject":"new subject"}
 *
 */
- (void)updateChatroom:(NSString *)room_id subject:(NSString *)subject block:(void (^)(BOOL))block {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:room_id, @"room_id",subject,@"subject",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKChatroomHandler *handler = [[LKChatroomHandler alloc] init];
    
    handler.succeed = ^(BOOL aBool) {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/update/chatroom/subject" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}


@end
