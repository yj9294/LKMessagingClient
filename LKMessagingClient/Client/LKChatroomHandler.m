//
//  LKChatroomHandler.m
//  LKMessagingClient
//
//  Created by cptech on 2018/2/23.
//  Copyright © 2018年 links123_yj. All rights reserved.
//

#import "LKChatroomHandler.h"
#import "LKChatroom.h"

@implementation LKChatroomHandler
- (void)onEnd{
    NSLog(@"%s",__func__);
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"LKContectGetHandler ERROR:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"发送失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    
    NSDictionary *headerDic;
    NSDictionary *bodyDic;
    if(header){
        headerDic = [NSJSONSerialization JSONObjectWithData:header options:NSJSONReadingMutableContainers error:nil];
    }
    if(body){
        bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];
    }
    if(!headerDic){
        headerDic = @{};
    }
    if(!bodyDic){
        bodyDic = @{};
    }
    self.succeed(true);
}
@end

@implementation LKCreateChatroomHandler
- (void)onEnd{
    NSLog(@"%s",__func__);
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"LKContectGetHandler ERROR:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"发送失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    
    NSDictionary *headerDic;
    NSDictionary *bodyDic;
    if(header){
        headerDic = [NSJSONSerialization JSONObjectWithData:header options:NSJSONReadingMutableContainers error:nil];
    }
    if(body){
        bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];
    }
    if(!headerDic){
        headerDic = @{};
    }
    if(!bodyDic){
        bodyDic = @{};
    }
    NSString *roomId = [bodyDic objectForKey:@"cid"];
    self.succeed(roomId);
}
@end


@implementation LKStickroomHandler
- (void)onEnd{
    NSLog(@"%s",__func__);
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"LKContectGetHandler ERROR:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"发送失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    
    NSDictionary *headerDic;
    NSDictionary *bodyDic;
    if(header){
        headerDic = [NSJSONSerialization JSONObjectWithData:header options:NSJSONReadingMutableContainers error:nil];
    }
    if(body){
        bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];
    }
    if(!headerDic){
        headerDic = @{};
    }
    if(!bodyDic){
        bodyDic = @{};
    }
    NSMutableArray *array = [NSMutableArray array];
    if([[bodyDic objectForKey:@"chat_room"] isKindOfClass:[NSArray class]]){
        for(NSDictionary *dic in [bodyDic objectForKey:@"chat_room"]){
            LKChatroom *room = [[LKChatroom alloc] init];
            room.subject = dic[@"name"];
            if([bodyDic objectForKey:@"avatar_prefix"])
                [[NSUserDefaults standardUserDefaults] setObject:[bodyDic objectForKey:@"avatar_prefix"] forKey:@"avatar_prefix"];
            room.avatar = [NSString stringWithFormat:@"%@%@",[bodyDic objectForKey:@"avatar_prefix"],dic[@"avatar"]];
            room.chatroomId = dic[@"id"];
            [array addObject:room];
        }
    }
    NSInteger time = [[bodyDic objectForKey:@"server_time"] integerValue];
    
    self.succeed(time,array);
}
@end


@implementation LKFetchRoomDetailHandler
- (void)onEnd{
    NSLog(@"%s",__func__);
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"LKContectGetHandler ERROR:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"发送失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    
    NSDictionary *headerDic;
    NSDictionary *bodyDic;
    if(header){
        headerDic = [NSJSONSerialization JSONObjectWithData:header options:NSJSONReadingMutableContainers error:nil];
    }
    if(body){
        bodyDic = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];
    }
    if(!headerDic){
        headerDic = @{};
    }
    if(!bodyDic){
        bodyDic = @{};
    }
    LKChatroom *room = [[LKChatroom  alloc] init];
    if([bodyDic objectForKey:@"profile"]){
        room.chatroomId = bodyDic[@"profile"][@"id"];
        room.notice     = bodyDic[@"profile"][@"notice"];
        room.avatar     = bodyDic[@"profile"][@"avatar"];
        room.welcomeMessage = bodyDic[@"profile"][@"welcome_message"];
        room.maxOccupantsCount = [bodyDic[@"profile"][@"max"] integerValue];
        room.membersCount      = [bodyDic[@"profile"][@"count"] integerValue];
        room.descrip           = bodyDic[@"profile"][@"description"];
        room.subject           = bodyDic[@"profile"][@"name"];
        room.cover             = bodyDic[@"profile"][@"cover"];
        if([bodyDic[@"user_type"] integerValue] == 1){
            room.permissionType = LKChatroomPermissionTypeOwner;
        }
        else if([bodyDic[@"user_type"] integerValue] == 2){
            room.permissionType = LKChatroomPermissionTypeAdmin;
        }
        else if([bodyDic[@"user_type"] integerValue] == 9){
            room.permissionType = LKChatroomPermissionTypeMember;
        }
        else
            room.permissionType = LKChatroomPermissionTypeNone;
    }
    NSMutableArray *array = [NSMutableArray array];
    if([[bodyDic objectForKey:@"members"] isKindOfClass:[NSArray class]]){
        for(NSDictionary *dic in bodyDic[@"members"]){
            LKChatroomMemeber *member = [[LKChatroomMemeber alloc] init];
            member.userId = dic[@"user_id"];
            member.mark   = dic[@"mark"];
            member.nickname = dic[@"nickname"];
            member.firstLetter = dic[@"first_letter"];
            NSString *avatarPrefix = [[NSUserDefaults standardUserDefaults] objectForKey:@"avatar_prefix"];
            member.avatar      = [NSString stringWithFormat:@"%@%@",avatarPrefix,dic[@"avatar"]];
            if([dic[@"type"] integerValue] == 1){
                member.type = LKChatroomPermissionTypeOwner;
            }
            else if([dic[@"type"] integerValue] == 2){
                member.type = LKChatroomPermissionTypeAdmin;
            }
            else if([dic[@"type"] integerValue] == 9){
                member.type = LKChatroomPermissionTypeMember;
            }
            else
                member.type = LKChatroomPermissionTypeNone;
            [array addObject:member];
        }
    }
    self.succeed(room,array);
}
@end
