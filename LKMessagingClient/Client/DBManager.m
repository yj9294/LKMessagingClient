//
//  DBManager.m
//  Hyphenate
//
//  Created by Tang on 2017/11/29.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import "DBManager.h"
#import "FMDB.h"
#import "LKMessage.h"
#import "LKTextMessageBody.h"
#import "ChatModel.h"
#define MYLog(...)  NSLog(__VA_ARGS__)

@interface DBManager ()

@property (nonatomic, strong) FMDatabaseQueue *queue;

@end

@implementation DBManager

#pragma mark datebase init
+ (instancetype)sharedManager {
    static DBManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        
        // init FMDBQueue
        NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *dbPath = [docPath stringByAppendingPathComponent:@"chat.sqlite"];
        NSLog(@"%@", dbPath);
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        self.queue = queue;
        
        if (!queue) NSLog(@"ERR: create database fail");
        
        //NSLog(@"DBPath: %@", dbPath);
        
        [queue inDatabase:^(FMDatabase *db) {

//            NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'ContactFans' (user_id INTEGER, user_nickname TEXT, user_avatar TEXT, user_mark TEXT, user_is_teacher INTEGER, user_first_letter TEXT)"];
//            BOOL  success1 = [db executeUpdate:sqlStr];
//
//            if (!success1) NSLog(@"ERR: create table 'ContactFans' fail");
            
            NSString *sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'ContactFriends' (user_id, friend_id INTEGER, friend_nickname TEXT, friend_avatar TEXT, friend_mark TEXT, friend_is_teacher INTEGER, friend_first_letter TEXT, friend_type INTEGER, is_masking INTEGER, is_stick INTEGER, no_disturbing INTEGER)"];
            BOOL success1 = [db executeUpdate:sqlStr];
            
            if (!success1) NSLog(@"ERR: create table 'ContactFriends' fail");
            
            
            sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'MessageData' (msgId TEXT, conversationId TEXT, fromId TEXT, toId TEXT, type TEXT, bodyType TEXT, bodyMessage TEXT, localTime INTEGER, serviceTime INTEGER, direction INTEGER, status INTEGER, isDelivered INTEGER, isAcked INTEGER)"];
            success1 = [db executeUpdate:sqlStr];
            
            if (!success1) NSLog(@"ERR: create table 'MessageData' fail");
            
            
            sqlStr = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS 'ConversationData' (conversationId TEXT, type INTEGER, fromUserId TEXT, unReadCount INTEGER, latestMessageText TEXT, latestMessageTime INTEGER)"];
            success1 = [db executeUpdate:sqlStr];
            
            if (!success1) NSLog(@"ERR: create table 'ConversationData' fail");
            
    
        }];
    }
    return self;
}

#pragma mark contacts
- (NSArray *)dbGetAttentions:(int)user_id
{
    __block NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE user_id=%d", user_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            int type = [resultSet intForColumn:@"friend_type"];
            if (type == 1 || type == 2 || type == 4)
            {
                FriendModel *friend = [[FriendModel alloc]init];
                friend.friend_id = [resultSet intForColumn:@"friend_id"];
                friend.friend_is_teacher = [resultSet intForColumn:@"friend_is_teacher"];
                friend.friend_type = [resultSet intForColumn:@"friend_type"];
                friend.friend_nickname = [resultSet stringForColumn:@"friend_nickname"];
                friend.friend_mark = [resultSet stringForColumn:@"friend_mark"];
                friend.friend_avatar = [resultSet stringForColumn:@"friend_avatar"];
                friend.friend_first_letter = [resultSet stringForColumn:@"friend_first_letter"];
                friend.is_masking = [resultSet intForColumn:@"is_masking"];
                friend.is_stick = [resultSet intForColumn:@"is_stick"];
                friend.no_disturbing = [resultSet intForColumn:@"no_disturbing"];
                [array addObject:friend];
            }
            
        }
        
        [resultSet close];
    }];
    return array;
}
- (NSArray *)dbGetFans:(int)user_id
{
    __block NSMutableArray *array = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE friend_id=%d", user_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            int type = [resultSet intForColumn:@"friend_type"];
            if (type == 1 || type == 4)
            {
                FriendModel *friend = [[FriendModel alloc]init];
                friend.friend_id = [resultSet intForColumn:@"user_id"];
                friend.friend_is_teacher = [resultSet intForColumn:@"friend_is_teacher"];
                friend.friend_type = [resultSet intForColumn:@"friend_type"];
                friend.friend_nickname = [resultSet stringForColumn:@"friend_nickname"];
                friend.friend_mark = [resultSet stringForColumn:@"friend_mark"];
                friend.friend_avatar = [resultSet stringForColumn:@"friend_avatar"];
                friend.friend_first_letter = [resultSet stringForColumn:@"friend_first_letter"];
                friend.is_masking = [resultSet intForColumn:@"is_masking"];
                friend.is_stick = [resultSet intForColumn:@"is_stick"];
                friend.no_disturbing = [resultSet intForColumn:@"no_disturbing"];
                [array addObject:friend];
            }
            
        }
        
        [resultSet close];
    }];
    return array;
}

- (BOOL)isUserHasMask:(int)user_id
{
    __block BOOL bMask = false;
    int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE user_id=%d AND friend_id=%d", userID, user_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            bMask = [resultSet intForColumn:@"is_masking"];
        }
        
        [resultSet close];
    }];
    return bMask;
}

- (BOOL)isUserStick:(int)user_id
{
    __block BOOL bMask = false;
    int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE user_id=%d AND friend_id=%d", userID, user_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            bMask = [resultSet intForColumn:@"is_stick"];
        }
        
        [resultSet close];
    }];
    return bMask;
}

- (void)setUserStick:(int)user_id bStick:(BOOL)bStick
{
    int meID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE user_id=%d AND friend_id=%d", meID, user_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        if (resultSet.next) {
             BOOL success1 = [db executeUpdate:@"UPDATE 'ContactFriends' SET is_stick=? WHERE friend_id=? AND user_id=?", @(bStick), @(user_id), @(meID)];
        }else{
            BOOL success1 = [db executeUpdate:@"INSERT INTO 'ContactFriends'(friend_id, is_stick, user_id) VALUES (?, ?, ?)",@(user_id), @(bStick), @(meID)];
        }
        
        [resultSet close];
    }];
}

- (int)getUserAttentionType:(int)user_id
{
    __block int type = 0;
    int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE user_id=%d AND friend_id=%d", userID, user_id];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            type = [resultSet intForColumn:@"friend_type"];
            
        }
        
        [resultSet close];
    }];
    return type;
}

- (BOOL)isUserHasAttention:(int)user_id
{
    BOOL bAttention = false;
    int type = [self getUserAttentionType:user_id];
    if (type == 1 || type == 2 || type == 4)
    {
        bAttention = true;
    }
//    int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
//    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE user_id=%d AND friend_id=%d", userID, user_id];
//        FMResultSet *resultSet = [db executeQuery:sqlStr];
//        while (resultSet.next) {
//            int type = [resultSet intForColumn:@"friend_type"];
//            if (type == 1 || type == 2 || type == 4)
//            {
//                bAttention = true;
//                break;
//            }
//
//        }
//
//        [resultSet close];
//    }];
    return bAttention;
}

- (void)dbAddAttentions:(NSArray *)array user_id:(int)user_id
{
    [self.queue inDatabase:^(FMDatabase *db) {
        for (FriendModel *friend in array) {
            
                NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE friend_id=%d AND user_id=%d", friend.friend_id, user_id];
                BOOL success1;
                FMResultSet *resultSet = [db executeQuery:sqlStr];
                if (resultSet.next) {
               
                    success1 = [db executeUpdate:@"UPDATE 'ContactFriends' SET friend_is_teacher=?, friend_type=?, friend_avatar=?, friend_nickname=?, friend_mark=?, friend_first_letter=?, is_masking=?, is_stick=?, no_disturbing=? WHERE friend_id=? AND user_id=?",  @(friend.friend_is_teacher), @(friend.friend_type), friend.friend_avatar, friend.friend_nickname, friend.friend_mark, friend.friend_first_letter, @(friend.is_masking), @(friend.is_stick), @(friend.no_disturbing), @(friend.friend_id), @(user_id)];
                }
                else
                {
                    
                    success1 = [db executeUpdate:@"INSERT INTO 'ContactFriends'(friend_id, friend_is_teacher, friend_type, friend_avatar, friend_nickname, friend_mark, friend_first_letter, is_masking, is_stick, no_disturbing, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",@(friend.friend_id), @(friend.friend_is_teacher), @(friend.friend_type), friend.friend_avatar, friend.friend_nickname, friend.friend_mark, friend.friend_first_letter, @(friend.is_masking), @(friend.is_stick), @(friend.no_disturbing), @(user_id)];
                
                   
                }
                [resultSet close];
           // }
        }
        
    }];
}

- (void)dbAddFans:(NSArray *)array user_id:(int)user_id
{
    [self.queue inDatabase:^(FMDatabase *db) {
        for (FriendModel *friend in array) {
            NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE friend_id=%d AND user_id=%d",user_id, friend.friend_id];
            BOOL success1;
            FMResultSet *resultSet = [db executeQuery:sqlStr];
            if (resultSet.next) {
                success1 = [db executeUpdate:@"UPDATE 'ContactFriends' SET friend_is_teacher=?, friend_type=?, friend_avatar=?, friend_nickname=?, friend_mark=?, friend_first_letter=?, is_masking=?, is_stick=?, no_disturbing=?  WHERE friend_id=? AND user_id=?",  @(friend.friend_is_teacher), @(friend.friend_type), friend.friend_avatar, friend.friend_nickname, friend.friend_mark, friend.friend_first_letter, @(friend.is_masking), @(friend.is_stick), @(friend.no_disturbing), @(user_id), @(friend.friend_id)];

                
            }
            else
            {
                success1 = [db executeUpdate:@"INSERT INTO 'ContactFriends'(friend_id, friend_is_teacher, friend_type, friend_avatar, friend_nickname, friend_mark, friend_first_letter, is_masking, is_stick, no_disturbing, user_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", @(user_id), @(friend.friend_is_teacher), @(friend.friend_type), friend.friend_avatar, friend.friend_nickname, friend.friend_mark, friend.friend_first_letter, @(friend.is_masking), @(friend.is_stick), @(friend.no_disturbing), @(friend.friend_id)];
            }
            [resultSet close];

        }
        
    }];
}


#pragma mark conversation
- (NSArray *)dbGetAllConversations
{
    __block NSMutableArray *array = [NSMutableArray array];
    __block NSMutableArray *arrayStick = [NSMutableArray array];
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ConversationData' WHERE fromUserId='%d' order by latestMessageTime desc", userID];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
  
            NSString *conId =  [resultSet stringForColumn:@"conversationId"];
         //   BOOL bStick = [self isUserStick:conId.intValue];
            int type =  [resultSet intForColumn:@"type"];
            LKConversation *con = [[LKConversation alloc]initWithId:conId andType:type];
            con.unreadMessagesCount = [resultSet intForColumn:@"unReadCount"];
            con.latestMessageText = [resultSet stringForColumn:@"latestMessageText"];
            con.latestMessageTime = [resultSet intForColumn:@"latestMessageTime"];
            con.from = [resultSet stringForColumn:@"fromUserId"];
            {
                int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
                NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ContactFriends' WHERE user_id=%d AND friend_id=%d", userID, conId.intValue];
                FMResultSet *resultSet = [db executeQuery:sqlStr];
                if (resultSet.next) {
                    con.bStick = [resultSet intForColumn:@"is_stick"];
                }
                
                [resultSet close];
            }
            
            if (![array containsObject:con])
            {
                if(con.bStick)
                {
                    [arrayStick addObject:con];
                }
                else{
                    [array addObject:con];
                }
            }
        }
        [resultSet close];
    }];
    [arrayStick addObjectsFromArray:array];
    return arrayStick;
}

- (LKConversation *)dbGetConversation:(NSString *)aConversationId
                               type:(LKConversationType)aType
{
    
    __block LKConversation *conver = nil;
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ConversationData' WHERE conversationId='%@' AND type='%d' AND fromUserId='%d'", aConversationId, aType, userID];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        
        // int total = 0;
        
        while (resultSet.next) {
            conver = [[LKConversation alloc]initWithId:[resultSet stringForColumn:@"conversationId"] andType:[resultSet intForColumn:@"type"]];
            conver.unreadMessagesCount = [resultSet intForColumn:@"unReadCount"];
            conver.latestMessageText = [resultSet stringForColumn:@"latestMessageText"];
            conver.latestMessageTime = [resultSet intForColumn:@"latestMessageTime"];
            conver.from = [resultSet stringForColumn:@"fromUserId"];
        }
        
        [resultSet close];
    }];
    return conver;
}

- (LKConversation *)dbCreateConversation:(NSString *)aConversationId
                                 type:(LKConversationType)aType
{
    LKConversation *conver = [[LKConversation alloc]initWithId:aConversationId andType:aType];
    
    return conver;
}

//- (void)dbDeleteConversation:(NSString *)aConversationId
//{
//    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        NSString *sqlStr = [NSString stringWithFormat:@"DELETE * FROM 'ConversationData' WHERE conversationId='%@'", aConversationId];
//        FMResultSet *resultSet = [db executeQuery:sqlStr];
//        [resultSet close];
//    }];
//}

- (void)dbUpdateConversation:(LKConversation *)aConversation
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ConversationData' WHERE conversationId='%@' AND type='%d' AND fromUserId='%d'", aConversation.conversationId, LKConversationTypeChat, userID];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
   //     LKTextMessageBody *body = (LKTextMessageBody *)msg.body;
        
        // int total = 0;
        BOOL success1;
        if (resultSet.next) {
//            int count = [resultSet intForColumn:@"unReadCount"];
            int account = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
//            if (account == msg.to.intValue) {
//                count++;
//            }
            success1 = [db executeUpdate:@"UPDATE 'ConversationData' SET unReadCount=?, latestMessageText=?, latestMessageTime=?, fromUserId=? WHERE conversationId=?", @(aConversation.unreadMessagesCount), aConversation.latestMessageText, @(aConversation.latestMessageTime), @(account), aConversation.conversationId];
        }
        else
        {
//            int count = 0;
            int account = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
//            if (account == msg.to.intValue) {
//                count++;
//            }
            success1 = [db executeUpdate:@"INSERT INTO 'ConversationData'(conversationId, type, fromUserId, unReadCount, latestMessageText, latestMessageTime) VALUES (?, ?, ?, ?, ?, ?)", aConversation.conversationId, @(LKConversationTypeChat), @(account), @(aConversation.unreadMessagesCount), aConversation.latestMessageText, @(aConversation.latestMessageTime)];
        }
        
        [resultSet close];
    }];
}

- (void)dbUpdateConversation:(NSString *)aConversationId latestMessage:(LKMessage *)msg
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        int userID = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ConversationData' WHERE conversationId='%@' AND type='%d' AND fromUserId='%d'", aConversationId, LKConversationTypeChat, userID];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        LKTextMessageBody *body = (LKTextMessageBody *)msg.body;
        
        // int total = 0;
        //切换用户时fromUserId就是标志位
        BOOL success1;
        if (resultSet.next) {
            int count = [resultSet intForColumn:@"unReadCount"];
            int account = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
            if (LKMessageDirectionReceive == msg.direction) {
                count++;
            }
            success1 = [db executeUpdate:@"UPDATE 'ConversationData' SET unReadCount=?, latestMessageText=?, latestMessageTime=?, fromUserId=? WHERE conversationId=?", @(count), body.text, @(msg.timestamp), @(account), aConversationId];
        }
        else
        {
            int count = 0;
            int account = (int) [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
            if (LKMessageDirectionReceive == msg.direction) {
                count++;
            }
            success1 = [db executeUpdate:@"INSERT INTO 'ConversationData'(conversationId, type, fromUserId, unReadCount, latestMessageText, latestMessageTime) VALUES (?, ?, ?, ?, ?, ?)", aConversationId, @(LKConversationTypeChat), @(account), @(count), body.text, @(msg.timestamp)];
        }
        
        [resultSet close];
    }];
}

- (void)dbConversationReadAMessage:(NSString *)aConversationId
{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ConversationData' WHERE conversationId='%@'", aConversationId];
        BOOL success1;
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        if (resultSet.next) {
            int count = [resultSet intForColumn:@"unReadCount"] - 1;
            success1 = [db executeUpdate:@"UPDATE 'ConversationData' SET unReadCount=? WHERE conversationId=?", count, aConversationId];
        }
        [resultSet close];
    }];
}

- (void)dbConversationReadAllMessage:(NSString *)aConversationId
{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'ConversationData' WHERE conversationId='%@'", aConversationId];
        BOOL success1;
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        if (resultSet.next) {
            int count = 0;
            success1 = [db executeUpdate:@"UPDATE 'ConversationData' SET unReadCount=? WHERE conversationId=?", count, aConversationId];
        }
        [resultSet close];
    }];
}

- (int)dbGetAllUnreadCount
{
    int count = 0;
    NSArray *arr = [self dbGetAllConversations];
    for (LKConversation *con in arr) {
        count += con.unreadMessagesCount;
    }
    return count;
}

/**
 Message
 */

- (void)dbDeleteMessageByConversationId:(NSString *)aConversationId
{
    [self.queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE * FROM 'MessageData' WHERE conversationId='%@'", aConversationId];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        [resultSet close];
    }];
}

- (void)dbUpdateMessageServiced:(LKMessage *)aMessage
{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'MessageData' WHERE msgId='%@'", aMessage.messageId];
        BOOL success1;
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        if (resultSet.next) {
            success1 = [db executeUpdate:@"UPDATE 'MessageData' SET isDelivered=1 WHERE msgId=?", aMessage.messageId];
        }
        [resultSet close];
    }];
}

- (void)dbUpdateMessageRead:(LKMessage *)aMessage
{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'MessageData' WHERE msgId='%@'", aMessage.messageId];
        BOOL success1;
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        if (resultSet.next) {
            success1 = [db executeUpdate:@"UPDATE 'MessageData' SET isAcked=1 WHERE msgId=?", aMessage.messageId];
        }
        [resultSet close];
    }];
}

- (void)dbUpdateMessage:(LKMessage *)aMessage
{
    LKTextMessageBody *body = (LKTextMessageBody *)aMessage.body;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'MessageData' WHERE msgId='%@'", aMessage.messageId];
        BOOL success1;
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        if (resultSet.next) {
            success1 = [db executeUpdate:@"UPDATE 'MessageData' SET conversationId=?, fromId=?, toId=?, type=?, bodyType=?, bodyMessage=?, localTime=?, serviceTime=?, direction=?, status=?, isDelivered=?, isAcked=? WHERE msgId=?", aMessage.conversationId, aMessage.from, aMessage.to, @(aMessage.chatType), @(aMessage.body.type), body.text, @(aMessage.timestamp), @(aMessage.localTime), @(aMessage.direction), @(aMessage.status), @(aMessage.isDeliverAcked), @(aMessage.isReadAcked), aMessage.messageId];
        }
        else
        {
          //  conversationId TEXT, from TEXT, to TEXT, type TEXT, bodyType TEXT, bodyMessage TEXT, localTime INTEGER, serviceTime INTEGER, direction INTEGER, status INTEGER, isDelivered INTEGER, isAcked INTEGER, date DATETIME)
            success1 = [db executeUpdate:@"INSERT INTO 'MessageData'(msgId, conversationId, fromId, toId, type, bodyType, bodyMessage, localTime, serviceTime, direction, status, isDelivered, isAcked) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",aMessage.messageId, aMessage.conversationId, aMessage.from, aMessage.to, @(aMessage.chatType), @(aMessage.body.type), body.text, @(aMessage.timestamp), @(aMessage.localTime), @(aMessage.direction), @(aMessage.status), @(aMessage.isDeliverAcked), @(aMessage.isReadAcked)];
        }
        [resultSet close];

        
    }];
}

- (void)dbSetAllMsgRead:(int)userId
               toId:(NSString *)toId
{
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'MessageData' WHERE fromId=%@ AND toId=%d", toId, userId];
        BOOL success1;
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            success1 = [db executeUpdate:@"UPDATE 'MessageData' SET isAcked=1 WHERE msgId=?", [resultSet stringForColumn:@"msgId"]];
        }
        [resultSet close];
    }];
    return ;
}

- (int)dbGetAllMsgRead:(int)userId
              toId:(NSString *)toId
{
    __block int count = 0;
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'MessageData' WHERE fromId=%@ AND toId=%d AND isAcked=0", toId, userId];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            count++;
        }
        [resultSet close];
    }];
    return count;
}

- (NSArray *)dbGetAllMsg:(int)userId
               toId:(NSString *)toId
{
    __block NSMutableArray *array = [NSMutableArray array];
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'MessageData' WHERE fromId=%d AND toId=%@", userId, toId];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            ChatModel *model = [[ChatModel alloc]init];
            model.isMe = [resultSet intForColumn:@"direction"]==LKMessageDirectionSend;
            model.log = [resultSet stringForColumn:@"bodyMessage"];
            model.time = [resultSet intForColumn:@"localTime"];
            model.friendId = [toId intValue];
            model.isRead = [resultSet intForColumn:@"isAcked"];
            [array addObject:model];
        }
        [resultSet close];
    }];
    
    if (userId == [toId intValue]) {
        return array;
    }
    
    [self.queue inDatabase:^(FMDatabase *db) {
        
        NSString *sqlStr = [NSString stringWithFormat:@"SELECT * FROM 'MessageData' WHERE fromId=%@ AND toId=%d", toId, userId];
        FMResultSet *resultSet = [db executeQuery:sqlStr];
        while (resultSet.next) {
            ChatModel *model = [[ChatModel alloc]init];
            model.isMe = NO;
            model.log = [resultSet stringForColumn:@"bodyMessage"];
            model.time = [resultSet intForColumn:@"localTime"];
            model.friendId = [toId intValue];
            model.isRead = [resultSet intForColumn:@"isAcked"];
            [array addObject:model];
        }
        [resultSet close];
    }];
    
    [array sortUsingComparator:^NSComparisonResult(ChatModel * obj1, ChatModel * obj2) {
        if (obj1.time < obj2.time) {
            return NSOrderedAscending;
        }
        else
        {
            return NSOrderedDescending;
        }
    }];
    return array;
}

- (void)dbDeleteConversation:(NSString *)aConversationId
{
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM 'ConversationData' WHERE conversationId='%@' AND type='%d'", aConversationId, LKConversationTypeChat];
        //  NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM 'MessageData' WHERE fromId=%d AND toId=%d", friend_id, user_id];
        [db executeUpdate:sqlStr];
        MYLog(@"%@",db.lastErrorMessage);
    }];
}

//根据用户id和好友id删除两人之间的对话
- (BOOL)dbDeleteAllMsg:(int)userId toId:(NSString *)toId{
    __block BOOL result,result1;
    
    
    
    [self.queue inDatabase:^(FMDatabase *db) {
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM 'MessageData' WHERE fromId=%@ AND toId=%d", toId, userId];
       result = [db executeUpdate:sqlStr];
        MYLog(@"%@",db.lastErrorMessage);
    }];
    
    [self.queue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString *sqlStr = [NSString stringWithFormat:@"DELETE FROM 'MessageData' WHERE fromId=%d AND toId=%@",  userId, toId];
        result1 = [db executeUpdate:sqlStr];
        MYLog(@"%@",db.lastErrorMessage);
    } ];
    return result&&result1;
}

@end
