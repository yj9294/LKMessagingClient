//
//  LKMessage.m
//  Hyphenate
//
//  Created by cptech on 2017/11/16.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import "LKMessage.h"

@implementation LKMessage
- (id)initWithConversationID:(NSString *)aConversationId from:(NSString *)aFrom to:(NSString *)aTo body:(LKMessageBody *)aBody ext:(NSDictionary *)aExt
{
    if(self = [super init])
    {
        _conversationId = aConversationId;
        _from = aFrom;
        _to   = aTo;
        _body = aBody;
        _ext  = aExt;
    }
    return self;
}

- (id)initWithMsgID:(NSString *)aMsgId from:(NSString *)aFrom to:(NSString *)aTo body:(LKMessageBody *)aBody ext:(NSDictionary *)aExt
{
    if(self = [super init])
    {
        _messageId = aMsgId;
        _from = aFrom;
        _to   = aTo;
        _body = aBody;
        _ext  = aExt;
    }
    return self;
}
@end
