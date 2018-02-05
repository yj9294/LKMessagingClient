//
//  LKMessageBody.h
//  Hyphenate
//
//  Created by mac on 2017/11/16.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
typedef enum{
    LKMessageBodyTypeText   = 0,    /*! \~chinese 文本类型 \~english Text */
    LKMessageBodyTypeImage,         /*! \~chinese 图片类型 \~english Image */
    LKMessageBodyTypeVideo,         /*! \~chinese 视频类型 \~english Video */
    LKMessageBodyTypeLocation,      /*! \~chinese 位置类型 \~english Location */
    LKMessageBodyTypeVoice,         /*! \~chinese 语音类型 \~english Voice */
    LKMessageBodyTypeFile,          /*! \~chinese 文件类型 \~english File */
    LKMessageBodyTypeCmd,           /*! \~chinese 命令类型 \~english Command */
}LKMessageBodyType;

/*!
 *  \~chinese
 *  消息体
 *
 *  \~english
 *  Message body
 */
@interface LKMessageBody : NSObject

/*!
 *  \~chinese
 *  消息体类型
 *
 *  \~english
 *  Message body type
 */
@property (nonatomic, assign) LKMessageBodyType type;



@end
