//
//  AreaInfo.m
//  WordWheat
//
//  Created by hhsoft on 15/12/8.
//  Copyright © 2015年 www.huahansoft.com. All rights reserved.
//

#import "AreaInfo.h"

@implementation AreaInfo

-(instancetype)init{
    if ([super init]) {
        _areaCountries = Localized(@"area_China", nil);
        _areaPrefix=@"86";
    }
    return self;
}
-(instancetype)initWithAreaPrefix:(NSString *)areaPrefix AreaCountry:(NSString *)areaCountry AreaIndexName:(NSString *)areaIndexName{
    if ([super init]) {
        _areaCountries=areaCountry;
        _areaPrefix=areaPrefix;
        _areaIndexName=areaIndexName;
    }
    return self;
}
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_areaCountries forKey:@"areaCountries"];

}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super init]) {
        _areaCountries = [aDecoder decodeObjectForKey:@"areaCountries"];
    }
    return self;
}
@end
