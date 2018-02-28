//
//  LKContactManager.m
//  WordWheat
//
//  Created by Tang on 2018/1/8.
//  Copyright © 2018年 www.links123.com. All rights reserved.
//

#import "LKContactManager.h"
//#import "LKContectGetHandler.h"
#import "LKHandlerContact.h"
#import "LKClient.h"
#import "DBManager.h"
@interface LKContactManager()
@property (nonatomic, strong)LKClient *client;
@property (nonatomic, strong)DBManager *db;
@end
@implementation LKContactManager
//singleton_implementation(LKContactManager);

- (instancetype)init
{
    if (self = [super init]) {
        _client = [LKClient sharedClient];
        _db = [DBManager sharedManager];
    }
    return self;
}

- (void)acceptInvitation:(int)userId {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", userId], @"fid",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKContectAddDeleteHandler *handler = [[LKContectAddDeleteHandler alloc] init];
    
    handler.succeed = ^() {
        //   aCompletionBlock(aMessage2, nil);
        //  block(true);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactChangedNotify" object:@(userId)];
        NSLog(@"acceptInvitation success");
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        //    block(false);
        NSLog(@"acceptInvitation fail");
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/add/contact/agree" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

- (void)declineInvitation:(int)userId {
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", userId], @"fid",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKContectAddDeleteHandler *handler = [[LKContectAddDeleteHandler alloc] init];
    
    handler.succeed = ^() {
        //   aCompletionBlock(aMessage2, nil);
        //   block(true);
        //  [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactChangedNotify" object:@(userId)];
        NSLog(@"declineInvitation success");
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        //    block(false);
        NSLog(@"declineInvitation fail");
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/add/contact/reject" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}


- (void)addContact:(int)userId  block:(void(^)(BOOL bSuccess)) block{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", userId], @"to_add_username", @"intersting", @"reason",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    
    LKContectAddDeleteHandler *handler = [[LKContectAddDeleteHandler alloc] init];
    
    handler.succeed = ^() {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactChangedNotify" object:@(userId)];
        NSLog(@"add success");
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        block(false);
        NSLog(@"add fail");
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/add/contact" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

- (void)addUserToBlackList:(int)userId {
    NSLog(@"%s not implement!", __func__);
}



- (void) getAllFriendFromServer:(void(^)(BOOL bSuccess)) block
{
    NSInteger lastPullTime = [[NSUserDefaults standardUserDefaults]integerForKey:@"contact_last_pull"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(lastPullTime), @"last_pull", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    LKContectGetHandler *handler = [[LKContectGetHandler alloc] init];
    
    handler.succeed = ^(NSInteger server_time) {
        //   aCompletionBlock(aMessage2, nil);
        NSLog(@"%s success", __func__);
        [[NSUserDefaults standardUserDefaults]setInteger:server_time forKey:@"contact_last_pull"];
        block(true);
        
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/get/all/contact" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

- (void)setStickOfUser:(int)userId bStick:(BOOL)bStick block:(void(^)(BOOL bSuccess)) block
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", userId], @"fid", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    LKContectGetHandler *handler = [[LKContectGetHandler alloc] init];
    
    handler.succeed = ^(NSInteger server_time) {
        //   aCompletionBlock(aMessage2, nil);
        NSLog(@"%s success", __func__);
        [_db setUserStick:userId bStick:bStick];
      //  [[NSUserDefaults standardUserDefaults]setInteger:server_time forKey:@"contact_last_pull"];
         [[NSNotificationCenter defaultCenter]postNotificationName:@"stickChangedNotify" object:nil];
        
        block(true);
        
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        NSLog(@"%s fail",  __func__);
        block(false);
    };
    
    LKError *err0 = nil;
    if (bStick) {
        [_client asyncSend:@"/v1/add/contact/stick" param:data callback:handler error:&err0];
    }
    else
    {
        [_client asyncSend:@"/v1/remove/contact/stick" param:data callback:handler error:&err0];
    }
    
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}


- (NSArray *)getBlackListFromServer {
    NSLog(@"%s not implement!", __func__);
    return nil;
}

- (NSArray *)getBlackListUsername {
    NSLog(@"%s not implement!", __func__);
    return nil;
}

- (int)getSelfIdsOnOtherPlatform {
    NSLog(@"%s not implement!", __func__);
    return 0;
}

- (void) removeContact:(int)userId block:(void(^)(BOOL bSuccess))block
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", userId], @"fid", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    LKContectAddDeleteHandler *handler = [[LKContectAddDeleteHandler alloc] init];
    
    handler.succeed = ^() {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactChangedNotify" object:@(userId)];
        NSLog(@"remove success");
        
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        block(false);
        NSLog(@"remove fail");
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/delete/contact" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}


- (void)addMaskContact:(int)friend_id completion:(void(^)(BOOL bSuccess)) block
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", friend_id], @"fid", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    LKContectAddDeleteHandler *handler = [[LKContectAddDeleteHandler alloc] init];
    
    handler.succeed = ^() {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactChangedNotify" object:@(friend_id)];
        NSLog(@"add mask success");
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        block(false);
        NSLog(@"add mask fail");
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/add/contact/masking" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}

- (void)removeMaskContact:(int)friend_id completion:(void(^)(BOOL bSuccess)) block
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", friend_id], @"fid", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    LKContectAddDeleteHandler *handler = [[LKContectAddDeleteHandler alloc] init];
    
    handler.succeed = ^() {
        //   aCompletionBlock(aMessage2, nil);
        block(true);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"ContactChangedNotify" object:@(friend_id)];
        NSLog(@"remove mask success");
    };
    handler.failure = ^(LKError *err) {
        //  aCompletionBlock(nil,err);
        block(false);
        NSLog(@"remove mask fail");
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/remove/contact/masking" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"asyncSend fail");
        // aCompletionBlock(nil,err0);
    }
}


- (void)removeUserFromBlackList:(int)userId {
    NSLog(@"%s not implement!", __func__);
}

- (NSArray *)getAttentions:(int)user_id {
    return [_db dbGetAttentions:user_id];
}


- (NSArray *)getFans:(int)user_id {
    return [_db dbGetFans:user_id];
}
- (NSArray *)getFriends:(int)user_id{
    return [_db dbGetFriends:user_id];
}

- (int)getUserAttentionType:(int)user_id {
    return [_db getUserAttentionType:user_id];
}


- (BOOL)isUserHasAttention:(int)user_id {
    return [_db isUserHasAttention:user_id];
}


- (BOOL)isUserHasMask:(int)user_id {
    return [_db isUserHasMask:user_id];
}

- (BOOL)isUserStick:(int)user_id{
    return [_db isUserStick:user_id];
}

@end
