//
//  LKMessageBodyTypeText.m
//  Hyphenate
//
//  Created by mac on 2017/11/16.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import "LKTextMessageBody.h"

@implementation LKTextMessageBody
- (instancetype)initWithText:(NSString *)aText{
    if(self = [super init]){
        _text = aText;
    }
    return self;
}
@end
