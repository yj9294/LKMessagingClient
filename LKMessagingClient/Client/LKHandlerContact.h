//
//  LKHandlerContact.h
//  WordWheat
//
//  Created by Tang on 2017/12/18.
//  Copyright © 2017年 www.links123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKClient.h"

@interface LKContectGetHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSInteger server_time);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end


@interface LKContectAddDeleteHandler : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(void);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end
