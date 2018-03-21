//
//  LKHandlerMsg.h
//  WordWheat
//
//  Created by Tang on 2017/12/18.
//  Copyright © 2017年 www.links123.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LKClient.h"
@interface LKHandlerConversation : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(NSArray *arry);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end

@interface LKHandlerConDelete : NSObject <ExportRequestStatusCallback>

@property (nonatomic, copy) void (^succeed)(BOOL *ret);

@property (nonatomic, copy) void (^failure)(LKError *err);

@end
