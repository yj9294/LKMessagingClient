//
//  LKMessageBodyTypeText.h
//  Hyphenate
//
//  Created by mac on 2017/11/16.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKMessageBody.h"

@interface LKTextMessageBody : LKMessageBody
@property (nonatomic, strong) NSString *actioin;
/*!
 *  \~chinese
 *  文本内容
 */
@property (nonatomic, copy, readonly) NSString *text;

/*!
 *  \~chinese
 *  初始化文本消息体
 *
 *  @param aText   文本内容
 *
 *  @result 文本消息体实例
 *
 */
- (instancetype)initWithText:(NSString *)aText;

@end
