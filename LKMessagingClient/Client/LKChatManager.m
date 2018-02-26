//
//  LKChatManager.m
//  WordWheat
//
//  Created by Tang on 2018/1/10.
//  Copyright © 2018年 www.links123.com. All rights reserved.
//

#import "LKChatManager.h"
#import "LKMessage.h"
#import "LKMessageBody.h"
#import "LKTextMessageBody.h"
#import "DBManager.h"
//#import "LKHandlerMsg.h"
#import "LKClient.h"
#import "LKHandlerConversation.h"
@interface LKChatManager()<ExportRequestStatusCallback>
@property (nonatomic, strong) DBManager *db;
@property (nonatomic, strong) LKClient *client;
@property (nonatomic, copy) void (^succeed)(LKMessage *aMessage);
@property (nonatomic, copy) void (^failure)(LKError *err);
@end
@implementation LKChatManager
//singleton_implementation(LKContactManager);

- (instancetype)init
{
    if (self = [super init]) {
        _client = [LKClient sharedClient];
        _db = [DBManager sharedManager];
    }
    return self;
}


- (void)addDelegate:(id)delegate {
     NSLog(@"%s not implement!", __func__);
}

- (void)deleteConversation:(NSString *)aConversationId isDeleteMessages:(BOOL)aIsDeleteMessages completion:(void (^)(NSString *, LKError *))aCompletionBlock {
   //  NSLog(@"%s not implement!", __func__);
    
    int user_id = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
    [_db dbDeleteConversation:aConversationId];
    if (aIsDeleteMessages) {
        BOOL result = [_db dbDeleteAllMsg:user_id toId:aConversationId];
    }
    aCompletionBlock(aConversationId, nil);
}

- (void)deleteConversations:(NSArray *)aConversations isDeleteMessages:(BOOL)aIsDeleteMessages completion:(void (^)(LKError *))aCompletionBlock {
    NSLog(@"%s not implement!", __func__);
}

- (void)downloadMessageAttachment:(LKMessage *)aMessage progress:(void (^)(int))aProgressBlock completion:(void (^)(LKMessage *, LKError *))aCompletionBlock {
     NSLog(@"%s not implement!", __func__);
}

- (void)downloadMessageThumbnail:(LKMessage *)aMessage progress:(void (^)(int))aProgressBlock completion:(void (^)(LKMessage *, LKError *))aCompletionBlock {
     NSLog(@"%s not implement!", __func__);
}

- (void)getAllConversations:(void (^)(NSArray * array)) aCompletionBlock
//- (NSArray *)getAllConversations
{
    NSInteger lastPullTime = [[NSUserDefaults standardUserDefaults]integerForKey:@"conversations_last_pull"];
    if (lastPullTime == 0) {
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@(0), @"last_pull", nil];
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        LKError *err0 = nil;
        LKHandlerConversation *handler = [[LKHandlerConversation alloc]init];
        handler.succeed = ^(NSArray *array) {
            [self importConversations:array completion:^(LKError *aError) {
                aCompletionBlock([_db dbGetAllConversations]);
            }];
            NSLog(@"%s success", __func__);
            NSInteger time = [[NSDate date]timeIntervalSince1970];
            [[NSUserDefaults standardUserDefaults]setInteger:time forKey:@"conversations_last_pull"];
        };
        handler.failure = ^(LKError *err) {
            ;
        };
        [_client asyncSend:@"/v1/get/all/conversation" param:data callback:handler error:&err0];
        if(err0){
          handler.failure(err0);
        }
       
    }
    else
    {
        aCompletionBlock([_db dbGetAllConversations]);
    }
}


- (LKConversation *)getConversation:(NSString *)aConversationId type:(LKConversationType)aType createIfNotExist:(BOOL)aIfCreate {
  //   NSLog(@"%s not implement!", __func__);
    LKConversation *con = [[DBManager sharedManager]dbGetConversation:aConversationId type:aType];
    return con;
}

- (NSString *)getMessageAttachmentPath:(NSString *)aConversationId {

    NSLog(@"%s not implement!", __func__);
    return nil;
}
- (NSArray *)getAllMessageOfAConversatioin:(NSString *)friend_id
{
    int user_id = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
    return [_db dbGetAllMsg:user_id toId:friend_id];
}

- (void)importConversations:(NSArray *)aConversations completion:(void (^)(LKError *))aCompletionBlock {
    for (LKConversation *conv in aConversations) {
        [_db dbUpdateConversation:conv];
    }
    aCompletionBlock(nil);
}

- (void)importMessages:(NSArray *)aMessages completion:(void (^)(LKError *))aCompletionBlock {
     NSLog(@"%s not implement!", __func__);
}

- (void)removeDelegate {
     NSLog(@"%s not implement!", __func__);
}




- (void)updateMessage:(LKMessage *)aMessage completion:(void (^)(LKMessage *, LKError *))aCompletionBlock {
    NSLog(@"%s not implement!", __func__);
}

- (void)sendMessageReadAck:(LKMessage *)aMessage
                completion:(void (^)(LKMessage *aMessage, LKError *aError))aCompletionBlock
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:aMessage.messageId,@"msg_id", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    //LKSendMsgHandler *handler = [[LKSendMsgHandler alloc] init];
    
    self.succeed = ^(LKMessage *aMessage2) {
        //NSLog(@"发送回执成功");
    };
    self.failure = ^(LKError *err) {
        aCompletionBlock(nil,err);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/mark/message/serviced" param:data callback:self error:&err0];
    if(err0){
        aCompletionBlock(nil,err0);
    }
}

- (void)sendMessage:(LKMessage *)aMessage progress:(void (^)(int))aProgressBlock completion:(void (^)(LKMessage *, LKError *))aCompletionBlock{
    
    /*
     public final static String CHATTYPE_USER = "chat";
     
     public final static String CMD_ACTION_SERVICED = "serviced";
     public final static String CMD_ACTION_READ = "read";
     
     public final static String MESSAGEBODY_TYPE_TEXT = "text";
     public final static String MESSAGEBODY_TYPE_CMD = "cmd";
     */
    LKTextMessageBody *body = (LKTextMessageBody *)aMessage.body;
    NSString *bodyType;
    NSString *chatType;
    switch (body.type) {
        case LKMessageBodyTypeText:
            bodyType = @"text";
            break;
            
        default:
            break;
    }
    switch (aMessage.chatType) {
        case LKChatTypeChat:
            chatType = @"chat";
            break;
        case LKChatTypeChatRoom:
            chatType = @"room";
            break;
            
        default:
            break;
    }
    NSDictionary *message = [NSDictionary dictionaryWithObjectsAndKeys:bodyType,@"type",body.text,@"message", nil];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:aMessage.from,@"from",chatType,@"type",aMessage.to,@"to",message ,@"msg",aMessage.ext,@"ext",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
  //  LKSendMsgHandler *handler = [[LKSendMsgHandler alloc] init];
    
    self.succeed = ^(LKMessage *aMessage2) {
        aMessage.messageId = aMessage2.messageId;
        aMessage.timestamp = [[NSDate date]timeIntervalSince1970];
        aMessage.localTime = [[NSDate date]timeIntervalSince1970];
        //    aMessage.body = body;
        aMessage.direction = LKMessageDirectionSend;
        LKConversation *con = [[LKConversation alloc]initWithId:aMessage.conversationId andType:LKConversationTypeChat];
        LKError *err;
        [con appendMessage:aMessage error:&err];
        aCompletionBlock(aMessage2, nil);
        [[NSNotificationCenter defaultCenter]postNotificationName:@"sendMessageNotify" object:nil];
    };
    self.failure = ^(LKError *err) {
        aCompletionBlock(nil,err);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/send/message" param:data callback:self error:&err0];
    if(err0){
        aCompletionBlock(nil,err0);
    }
    
}

- (void)deleteMessage:(NSString *)msg_id
           completion:(void (^)(LKMessage *aMessage, LKError *aError))aCompletionBlock
{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:msg_id,@"msg_id",nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
   // LKSendMsgHandler *handler = [[LKSendMsgHandler alloc] init];
    
    self.succeed = ^(LKMessage *aMessage2) {
        aCompletionBlock(aMessage2, nil);
    };
    self.failure = ^(LKError *err) {
        aCompletionBlock(nil,err);
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/delete/message" param:data callback:self error:&err0];
    if(err0){
        aCompletionBlock(nil,err0);
    }
}

- (void)resendMessage:(LKMessage *)aMessage progress:(void (^)(int))aProgressBlock completion:(void (^)(LKMessage *, LKError *))aCompletionBlock {
    [self sendMessage:aMessage progress:aProgressBlock completion:aCompletionBlock];
}

- (void)readAllMsgOfUser:(int)userId toServer:(BOOL)bToServer
{
    if (bToServer) {
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d", userId], @"contact",nil];
        NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        
        //   LKSendMsgHandler *handler = [[LKSendMsgHandler alloc] init];
        __weak typeof (self)weakSelf = self;
        self.succeed = ^(LKMessage *aMessage) {
            NSLog(@"read all success");
            LKConversation *con = [weakSelf getConversation:[NSString stringWithFormat:@"%d", userId] type:LKConversationTypeChat createIfNotExist:false];
            LKError *err;
            [con markAllMessagesAsRead:&err];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"readAllMessageNotify" object:con.conversationId];
        };
        
        self.failure = ^(LKError *err) {
            //  aCompletionBlock(nil,err);
            // block(false);
            NSLog(@"read all fail");
        };
        
        LKError *err0 = nil;
        [_client asyncSend:@"/v1/mark/messages/read" param:data callback:self error:&err0];
        if(err0){
            NSLog(@"asyncSend fail");
            // aCompletionBlock(nil,err0);
        }
    }
    else
    {
        LKConversation *con = [self getConversation:[NSString stringWithFormat:@"%d", userId] type:LKConversationTypeChat createIfNotExist:false];
        LKError *err;
        [con markAllMessagesAsRead:&err];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"readAllMessageNotify" object:con.conversationId];
    }
    
}

- (void)getHistoryMsg:(int)friend_id  completion:(void (^)(void))aCompletionBlock
{
    NSString *consationId = [NSString stringWithFormat:@"%d", friend_id];
    LKConversation *con=  [self getConversation:consationId type:LKConversationTypeChat createIfNotExist:true];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:consationId,@"conversation_id", @(con.latestMessageTime), @"last_pull", @(20), @"limit", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
     LKHandler *handler = [[LKHandler alloc] init];
    
    handler.succeed = ^(NSDictionary *result) {
        aCompletionBlock();
        [[NSNotificationCenter defaultCenter]postNotificationName:@"readAllMessageNotify" object:con.conversationId];
    };
    handler.failure = ^(LKError *err) {
        aCompletionBlock();
    };
    
    LKError *err0 = nil;
    [_client asyncSend:@"/v1/history/message" param:data callback:handler error:&err0];
    if(err0){
        aCompletionBlock();
    }
 //   {"conversation_id":"", "last_pull":"", "limit":""}
}


#pragma mark callback
- (void)onEnd{
   // NSLog(@"%s",__func__);
}
- (void)onError:(long)status message:(NSString*)message{
    NSLog(@"Send message ERROR:%@",message);
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
     //   bodyDic = @{};
        self.succeed(nil);
        return;
    }
    
    LKTextMessageBody *messageBody = [[LKTextMessageBody alloc] initWithText:bodyDic[@"msg"][@"message"]];
    if([bodyDic[@"msg"][@"message"] isEqualToString:@"text"]){
        messageBody.type = LKMessageBodyTypeText;
    }
    
    LKMessage *message = [[LKMessage alloc] initWithMsgID:bodyDic[@"msg_id"] from:bodyDic[@"contact"] to:bodyDic[@"uid"] body:messageBody ext:bodyDic[@"ext"]];
    self.succeed(message);
}

@end
