//
//  LKContactManager.h
//  Hyphenate
//
//  Created by Tang on 2017/12/6.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LKIContactManager <NSObject>

@required
- (void) getAllFriendFromServer:(void(^)(BOOL bSuccess)) block;
- (void) addContact:(int)userId block:(void(^)(BOOL bSuccess)) block;
//- (void) removeContact:(int)userId;
- (void) removeContact:(int)userId block:(void(^)(BOOL bSuccess))block;
- (void) acceptInvitation:(int)userId;
- (void) declineInvitation:(int)userId;
- (NSArray *) getBlackListFromServer;
- (NSArray *) getBlackListUsername;
- (void) addUserToBlackList:(int)userId;
- (void) removeUserFromBlackList:(int)userId;
- (int) getSelfIdsOnOtherPlatform;

- (void)addMaskContact:(int)friend_id completion:(void(^)(BOOL bSuccess)) block;
- (void)removeMaskContact:(int)friend_id completion:(void(^)(BOOL bSuccess)) block;
- (void)setStickOfUser:(int)userId bStick:(BOOL)bStick block:(void(^)(BOOL bSuccess)) block;
- (NSArray *)getAttentions:(int)user_id;
- (NSArray *)getFans:(int)user_id;
- (NSArray *)getFriends:(int)user_id;
- (BOOL)isUserHasAttention:(int)user_id;
- (int)getUserAttentionType:(int)user_id;
- (BOOL)isUserHasMask:(int)user_id;
- (BOOL)isUserStick:(int)user_id;
@end
