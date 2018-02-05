//
//  RegionInfo.h
//  WordWheat
//
//  Created by hhsoft on 15/12/10.
//  Copyright © 2015年 www.huahansoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegionInfo : NSObject
/**
 *  国家id
 */
@property(nonatomic,assign)NSInteger regionCountryID;
/**
 *  国家
 */
/**
 *  省份ID
 */
@property(nonatomic,assign)NSInteger regionProvinceID;
/**
 *  省份
 */
@property(nonatomic,copy)NSString *regionProvinceName;
/**
 *  城市ID
 */
@property(nonatomic,assign)NSInteger regionCityID;
/**
 *  城市名称
 */
@property(nonatomic,copy)NSString *regionCityName;
/**
 *  地区ID
 */
@property(nonatomic,assign)NSInteger regionDistID;
/**
 *  地区名称
 */
@property(nonatomic,copy)NSString *regionDistName;

@end
