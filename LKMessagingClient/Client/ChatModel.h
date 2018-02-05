//
//  ChatModel.h
//  WordWheat
//
//  Created by Tang on 2017/11/2.
//  Copyright © 2017年 www.links123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *log;
@property (nonatomic) int isRead;
@property (nonatomic) int time;
@property (nonatomic) int isMe;
@property (nonatomic) int friendId;
@end
