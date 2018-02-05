//
//  LKError.h
//  Hyphenate
//
//  Created by cptech on 2017/11/15.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKError : NSError

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, strong) NSString *message;

@end
