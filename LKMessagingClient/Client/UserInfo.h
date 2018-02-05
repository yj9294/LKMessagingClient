//
//  UserInfo.h
//  WordWheat
//
//  Created by hhsoft on 15/12/8.
//  Copyright © 2015年 www.huahansoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AreaInfo.h"
@class RegionInfo;
@interface UserInfo : NSObject

/**
 *  用户ID
 */
@property(nonatomic,assign)NSInteger userID;
/**
 *  用户名
 */
@property(nonatomic,copy)NSString *userName;
/**
 *  用户昵称
 */
@property(nonatomic,copy)NSString *userNickName;
/**
 *  用户手机号
 */
@property(nonatomic,copy)NSString *userPhone;
/**
 *  国家信息
 */
@property(nonatomic,strong)AreaInfo *areaInfo;
/**
 *  用户头像
 */
@property(nonatomic,copy)NSString *userImg;
@property(nonatomic,copy)NSString *avatar;
/**
 *  邮箱
 */
@property(nonatomic,copy)NSString *userEmail;
/**
 *  验证邮箱
 */
@property(nonatomic,copy)NSString *verifyEmail;
/**
 *  验证手机号
 */
@property(nonatomic,copy)NSString *verifyPhone;

@property(nonatomic,assign)NSInteger userStatus;

@property(nonatomic,copy)NSString *userToken;
/**
 *  生日
 */
@property(nonatomic,copy)NSString *userBirthday;
/**
 *  另客号
 */
@property(nonatomic,copy)NSString *userLinker;
/**
 *  来源  1：web；2：app
 */
@property(nonatomic,assign)NSInteger from;
/**
 *  创建时间
 */
@property(nonatomic,copy)NSString *userCreateTime;
/**
 *  结束时间
 */
@property(nonatomic,copy)NSString *userUpDate;
/**
 *  性别 1：男；2：女
 */
@property(nonatomic,assign)NSInteger userGender;
/**
 *  地区信息
 */
@property(nonatomic,strong)RegionInfo *regionInfo;
/**
 *  星座ID
 */
@property(nonatomic,assign)NSInteger userStarSignID;
/**
 *  星座
 */
@property(nonatomic,copy)NSString *userStarSignName;
/**
 *  介绍；引进；采用；入门；传入
 */
@property(nonatomic,copy)NSString *userIntroduction;
/**
 *  学校
 */
@property(nonatomic,copy)NSString *userUniversity;
/**
 *  网站
 */
@property(nonatomic,copy)NSString *userWebsite;

//个人设置

@property (nonatomic, copy) NSDictionary *setting;

@property (nonatomic, copy) NSString *signature;

@end
