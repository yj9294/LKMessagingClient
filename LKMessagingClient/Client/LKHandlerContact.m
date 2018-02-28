//
//  LKHandlerContact.m
//  WordWheat
//
//  Created by Tang on 2017/12/18.
//  Copyright © 2017年 www.links123.com. All rights reserved.
//

#import "LKHandlerContact.h"
#import "LKContactManager.h"
#import "FriendModel.h"
#import "DBManager.h"

@implementation LKContectGetHandler
#pragma mark - LKContectGetHandler
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
    
    NSInteger server_time =  [bodyDic[@"server_time"]integerValue];
    NSArray *arrayFriends = bodyDic[@"followers"];
    NSArray *arrayFans = bodyDic[@"fans"];
    NSString *avatar_prefix = bodyDic[@"avatar_prefix"];
    int userID = (int)[[NSUserDefaults standardUserDefaults]  integerForKey:@"userID"];
    {
        NSMutableArray *arr1 = [NSMutableArray array];
        for (NSDictionary *dicFriend in arrayFriends) {
            FriendModel *friend = [[FriendModel alloc]init];
            friend.friend_type = [dicFriend[@"type"]intValue];
            friend.friend_id = [dicFriend[@"friend_id"]intValue];
            friend.friend_avatar = [avatar_prefix stringByAppendingString:dicFriend[@"friend_avatar"]];
            friend.friend_first_letter = dicFriend[@"friend_first_letter"];
            friend.friend_nickname = dicFriend[@"friend_nickname"];
            friend.friend_mark = dicFriend[@"friend_mark"];
            friend.is_masking = [dicFriend[@"is_masking"]intValue];
            friend.friend_is_teacher = [dicFriend[@"friend_is_teacher"]intValue];
            friend.is_stick = [dicFriend[@"is_stick"]intValue];
            friend.no_disturbing = [dicFriend[@"no_disturbing"]intValue];
            [arr1 addObject:friend];
            
        }
        if (arr1.count > 0) {
            [[DBManager sharedManager]dbAddAttentions:arr1 user_id:userID];
        }
        
    }
    {
        NSMutableArray *arr1 = [NSMutableArray array];
        for (NSDictionary *dicFriend in arrayFans) {
            FriendModel *friend = [[FriendModel alloc]init];
            friend.friend_type = [dicFriend[@"type"]intValue];
            friend.friend_id = [dicFriend[@"user_id"]intValue];
            friend.friend_is_teacher = [dicFriend[@"user_is_teacher"]intValue];
            friend.friend_avatar = [avatar_prefix stringByAppendingString:dicFriend[@"user_avatar"]];
            friend.friend_first_letter = dicFriend[@"user_first_letter"];
            friend.friend_nickname = dicFriend[@"user_nickname"];
            friend.friend_mark = dicFriend[@"user_mark"];
            friend.is_masking = [dicFriend[@"is_masking"]intValue];
            friend.is_stick = [dicFriend[@"is_stick"]intValue];
            friend.no_disturbing = [dicFriend[@"no_disturbing"]intValue];
            [arr1 addObject:friend];
            
        }
        if (arr1.count > 0) {
            [[DBManager sharedManager]dbAddFans:arr1 user_id:userID];
        }
        
        //  [[DBManager sharedManager]dbAddFriends:arr1];
    }
    
    self.succeed(server_time);
}
@end

@implementation LKContectAddDeleteHandler
#pragma mark - LKContectAddDeleteHandler
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
    //    LKTextMessageBody *messageBody = [[LKTextMessageBody alloc] initWithText:bodyDic[@"msg"][@"message"]];
    //    if([bodyDic[@"msg"][@"message"] isEqualToString:@"text"]){
    //        messageBody.type = LKMessageBodyTypeText;
    //    }
    //
    //    LKMessage *message = [[LKMessage alloc] initWithMsgID:bodyDic[@"msg_id"] from:bodyDic[@"contact"] to:bodyDic[@"uid"] body:messageBody ext:bodyDic[@"ext"]];
    [[LKClient sharedClient].contactManager getAllFriendFromServer:^(BOOL bSuccess) {
        self.succeed();
    }];
    
}
@end


@implementation LKContactChangedHandler

- (void)handle:(NSData *)header body:(NSData *)body{
    NSDictionary *headerDic;
    NSDictionary *bodyArray;
    if(header){
        headerDic = [NSJSONSerialization JSONObjectWithData:header options:NSJSONReadingMutableContainers error:nil];
    }
    if(body){
        bodyArray = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];
    }
    if(!headerDic){
        headerDic = @{};
    }
    if(!bodyArray){
        return;
    }
    
    NSString *action = bodyArray[@"msg"][@"action"];
    NSLog(@"联系人变化: %@", action);
    
    if ([action isEqualToString:@"invited"]) {
        NSString *fid = bodyArray[@"from"];
        NSString *str = bodyArray[@"msg"][@"message"];
        _onInviate(fid.intValue, str);
    }
    else if ([action isEqualToString:@"agree"] || [action isEqualToString:@"reject"] || [action isEqualToString:@"delete"] || [action isEqualToString:@"add"]) {
        
        [[LKClient sharedClient].contactManager getAllFriendFromServer:^(BOOL bSuccess) {
            // self.succeed();
        }];
    }
}
@end
