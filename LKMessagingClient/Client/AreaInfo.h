//
//  AreaInfo.h
//  WordWheat
//
//  Created by hhsoft on 15/12/8.
//  Copyright © 2015年 www.huahansoft.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaInfo : NSObject
/**
 *  国家前缀
 */
@property(nonatomic,copy)NSString *areaPrefix;
/**
 *  国家
 */
@property(nonatomic,copy)NSString *areaCountries;

/**
 *  指数(首字母)
 */
@property(nonatomic,copy)NSString *areaIndexName;


-(instancetype)initWithAreaPrefix:(NSString *)areaPrefix AreaCountry:(NSString *)areaCountry AreaIndexName:(NSString *)areaIndexName;

@end
