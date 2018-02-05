//
//  LKHandlerMsg.m
//  WordWheat
//
//  Created by Tang on 2017/12/18.
//  Copyright © 2017年 www.links123.com. All rights reserved.
//

#import "LKHandlerConversation.h"
#import "LKConversation.h"
@implementation LKHandlerConversation
#pragma mark - ExportRequestStatusCallback
- (void)onEnd{
    NSLog(@"%s",__func__);
}
- (void)onError:(long)status message:(NSString*)message{
//    NSLog(@"Send message ERROR:%@",message);
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"发送失败", NSLocalizedDescriptionKey,[NSString stringWithFormat:@"失败原因：%@。",message], NSLocalizedFailureReasonErrorKey, @"恢复建议：请联系管理员。",NSLocalizedRecoverySuggestionErrorKey,nil];
    LKError *error = [[LKError alloc] initWithDomain:NSCocoaErrorDomain code:status userInfo:userInfo];
    
    self.failure(error);
}
- (void)onStart{
}

- (void)onSuccess:(NSData*)header body:(NSData*)body{
    
    NSDictionary *headerDic;
    NSArray *bodyDic;
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
        self.succeed(nil);
    }
    else {
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *convDic in bodyDic) {
            int user_id = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
            NSString *convId = convDic[@"from"];
            if ([convDic[@"from"] intValue] == user_id) {
                convId = convDic[@"to"];
            }
            LKConversation *conv = [[LKConversation alloc]initWithId:convId andType:LKConversationTypeChat];
            conv.unreadMessagesCount = [convDic[@"num"] intValue];
            conv.latestMessageText = convDic[@"msg"][@"message"];
            conv.latestMessageTime = [convDic[@ "update_at"] intValue];
            conv.from = convId;
            [array addObject:conv];
        }
        self.succeed(array);
    }
}
@end
