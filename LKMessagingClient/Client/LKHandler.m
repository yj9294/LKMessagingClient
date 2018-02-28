//
//  LKhandler.m
//  Hyphenate
//
//  Created by cptech on 2017/11/15.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import "LKHandler.h"
#import "LKClient.h"

@implementation LKHandler
#pragma mark - ExportRequestStatusCallback
- (void)onEnd{
    NSLog(@"%s",__func__);
    
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"Start session error:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"初始化会话信息失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
    NSLog(@"%s",__func__);
    
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    NSLog(@"%s",__func__);
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
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:headerDic,@"header",bodyDic,@"body",nil];
    self.succeed(result);
}

@end

@implementation LKHeartbeatHandler
#pragma mark - ExportRequestStatusCallback
- (void)onEnd{
    
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"%s",__func__);
    NSLog(@"Heartbeat error:%@,code = %ld",message,status);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"心跳包链接失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
 //   NSLog(@"%s",__func__);
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
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:headerDic,@"header",bodyDic,@"body",nil];
    self.succeed(result);
}

@end

@implementation LKLoginHandler
#pragma mark - LKLoginHandler
- (void)onEnd{
    NSLog(@"%s",__func__);
    
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"login error:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"登录或登出失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
    NSLog(@"%s",__func__);
    
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    NSLog(@"%s",__func__);
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
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:headerDic,@"header",bodyDic,@"body",nil];
    self.succeed(result);
}
@end

@implementation LKLogoutHandler
#pragma mark - LKLogoutHandler
- (void)onEnd{
    NSLog(@"%s",__func__);
    
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"login error:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"登录或登出失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
    NSLog(@"%s",__func__);
    
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    NSLog(@"%s",__func__);
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
    NSDictionary *result = [NSDictionary dictionaryWithObjectsAndKeys:headerDic,@"header",bodyDic,@"body",nil];
    self.succeed(result);
}
@end

@implementation LKDelegateHandler

- (void)handle:(NSData *)header body:(NSData *)body{
    NSDictionary *headerDic;
    NSArray *bodyArray;
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
        bodyArray = @[];
    }
    
    LKMessage *msgCallBack = nil;
  //  NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *bodyDic in bodyArray) {
        NSLog(@"收到消息:%@", bodyDic);
        LKTextMessageBody *messageBody = [[LKTextMessageBody alloc] initWithText:bodyDic[@"msg"][@"message"]];
        if([bodyDic[@"msg"][@"type"] isEqualToString:@"text"]){
            messageBody.type = LKMessageBodyTypeText;
        }
        
        NSString *type = bodyDic[@"msg"][@"type"];
        if ([type isEqualToString:@"cmd"])
        {
            NSString *action = bodyDic[@"msg"][@"action"];
            if ([action isEqualToString:@"serviced"])
            {
                [[LKClient sharedClient].chatManager deleteMessage:bodyDic[@"msg_id"] completion:^(LKMessage *aMessage, LKError *aError) {
                    ;
                }];
            }
            else if ([action isEqualToString:@"read"]) {
    
                LKMessage *msg = [[LKMessage alloc]init];
                msg.messageId = bodyDic[@"msg"][@"msg_id"];
            }
        }
        else
        {
            int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
            NSString *from = bodyDic[@"from"];
            NSString *to = bodyDic[@"to"];
            NSString *conId = bodyDic[@"from"];
         //   if (to.intValue == userID)
            {
                //所有收到的消息都发送回执
                LKMessage *msg = [[LKMessage alloc]initWithMsgID:bodyDic[@"msg_id"] from:bodyDic[@"to"] to:bodyDic[@"from"] body:messageBody ext:bodyDic[@"ext"]];
                msg.timestamp = [bodyDic[@"create_at"]intValue];
                msg.conversationId = bodyDic[@"to"];
                [[LKClient sharedClient].chatManager sendMessageReadAck:msg completion:^(LKMessage *aMessage, LKError *aError) {
                    // NSLog(@"ddddddd");
                }];
            }
            
            if (from.intValue == userID)
            {
                conId = bodyDic[@"to"];
            }
           
            //保存收到的消息到数据库
            {
                LKTextMessageBody *messageBody = [[LKTextMessageBody alloc] initWithText:bodyDic[@"msg"][@"message"]];
                messageBody.type = LKMessageBodyTypeText;
                LKMessage *message = [[LKMessage alloc] initWithMsgID:bodyDic[@"msg_id"] from:bodyDic[@"from"] to:bodyDic[@"to"] body:messageBody ext:bodyDic[@"ext"]];
                message.conversationId = conId;
                message.timestamp = [bodyDic[@"create_at"]intValue];
                message.localTime = [[NSDate date]timeIntervalSince1970];
                if (from.intValue == to.intValue) {
                    message.direction = LKMessageDirectionReceive;
                }
                else
                {
                    message.direction = from.intValue != userID ;
                }
                //LKMessageDirectionReceive;
         //       [[DBManager sharedManager]dbUpdateMessage:message];
                LKChatType chatType;
                if([bodyDic[@"type"] isEqualToString:@"chat"]){
                    chatType = LKChatTypeChat;
                }
                else if([bodyDic[@"type"] isEqualToString:@"room"]){
                    chatType = LKChatTypeChatRoom;
                }
                else
                    chatType = LKChatTypeGroupChat;
                
                LKConversation *con = [[LKConversation alloc]initWithId:message.conversationId andType:(LKConversationType)chatType];
                LKError *err;
                message.chatType = chatType;
                [con appendMessage:message error:&err];
                msgCallBack = message;
            }
        }
    }
    if (msgCallBack) {
        self.succeed(msgCallBack);
    }
    
}
@end


@implementation LKMultiDeviceHandler

- (void)handle:(NSData *)header body:(NSData *)body{
    NSDictionary *headerDic;
    NSArray *bodyArray;
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
        bodyArray = @[];
        return;
    }
    
    for (NSDictionary *dic in bodyArray) {
        if ([dic[@"type"] isEqualToString:@"message"]) {
            int event = [dic[@"ext"][@"event"] intValue];
            int from = [dic[@"msg"][@"from"] intValue];
            int to = [dic[@"msg"][@"to"] intValue];
            self.onMessage(event, from, to);
        }
        else if ([dic[@"type"] isEqualToString:@"contact"]){
            int event = [dic[@"ext"][@"event"] intValue];
            self.onContact(event);
        }
        else if ([dic[@"type"] isEqualToString:@"group"]){
            int event = [dic[@"ext"][@"event"] intValue];
            self.onGroup(event);
        }
        
    }
}
@end


@implementation LKAcquireHandler
#pragma mark - ExportRequestStatusCallback
- (void)onEnd{
    NSLog(@"%s",__func__);
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"session list error:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"登录或登出失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    self.failure(error);
}
- (void)onStart{
    NSLog(@"%s",__func__);
}
- (void)onSuccess:(NSData*)header body:(NSData*)body{
    NSLog(@"%s",__func__);
    NSArray *bodyArray;
    if(body){
        bodyArray = [NSJSONSerialization JSONObjectWithData:body options:NSJSONReadingMutableContainers error:nil];
    }
    NSMutableArray *sessionList = [[NSMutableArray alloc] init];
    for(int i =0 ; i<bodyArray.count;i++){
        LKChatSession *session = [self parseSessionWithJsonDic:bodyArray[0]];
        [sessionList addObject:session];
    }
    
    self.succeed(sessionList);
    
}
- (LKChatSession *)parseSessionWithJsonDic:(NSDictionary *)jsonDic{
    
    return [[LKChatSession alloc] initWithDevice:jsonDic[@"device"]
                                              os:jsonDic[@"os"]
                                       osVersion:jsonDic[@"os_version"]
                                             app:jsonDic[@"app"]
                                      appVersion:jsonDic[@"app_version"]
                                           token:jsonDic[@"token"]];
}
@end



@implementation LKConnectionHandler
#pragma mark - ExportRequestStatusCallback
- (void)handle:(NSData *)header body:(NSData *)body{
    NSLog(@"%s", __func__);
}

@end
