//
//  UserInfo.m
//  WordWheat
//
//  Created by hhsoft on 15/12/8.
//  Copyright © 2015年 www.huahansoft.com. All rights reserved.
//

#import "UserInfo.h"
#import "AreaInfo.h"
#import "RegionInfo.h"
@implementation UserInfo
-(instancetype)init
{
    if (self==[super init]) {
        _userID=0;
        _userName=@"";
        _userNickName=@"";
        _userPhone=@"";
        _verifyEmail=@"";
        _userEmail=@"";
        _verifyPhone=@"";
        _userImg=@"";
        _userStatus=0;
        _userGender=1;
        _userToken=@"";
        _areaInfo=[[AreaInfo alloc] init];
        _regionInfo=[[RegionInfo alloc] init];
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_userID forKey:@"user_id"];
    [aCoder encodeObject:_userToken forKey:@"user_Token"];
    [aCoder encodeObject:_userNickName forKey:@"nickname"];
    [aCoder encodeObject:_userImg forKey:@"avatar"];
    [aCoder encodeObject:_areaInfo forKey:@"areaInfo"];
    [aCoder encodeObject:_userBirthday forKey:@"userBirthday"];
    [aCoder encodeObject:_userLinker forKey:@"userLinker"];
    [aCoder encodeObject:@(_userGender) forKey:@"userGender"];
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _userID = [aDecoder decodeIntegerForKey:@"user_id"];
        _userToken = [aDecoder decodeObjectForKey:@"user_Token"];
        _userNickName = [aDecoder decodeObjectForKey:@"nickname"];
        _userImg = [aDecoder decodeObjectForKey:@"avatar"];
        _areaInfo = [aDecoder decodeObjectForKey:@"areaInfo"];
        _userBirthday = [aDecoder decodeObjectForKey:@"userBirthday"];
        _userLinker = [aDecoder decodeObjectForKey:@"userLinker"];
        _userGender = [[aDecoder decodeObjectForKey:@"userGender"] integerValue];
    }
    return self;
}
@end
