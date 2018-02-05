//
//  FriendModel.h
//  WordWheat
//
//  Created by Tang on 2017/12/8.
//  Copyright © 2017年 www.links123.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject
@property (nonatomic) int friend_id;
@property (nonatomic, strong) NSString *friend_nickname;
@property (nonatomic, strong) NSString *friend_avatar;
@property (nonatomic, strong) NSString *friend_mark;
@property (nonatomic) int friend_is_teacher;
@property (nonatomic) int is_masking;
@property (nonatomic, strong) NSString *friend_first_letter;
@property (nonatomic) int friend_type;
@property (nonatomic) int is_stick;
@property (nonatomic) int no_disturbing;

@end
