//
//  LinkExportClient.m
//  Hyphenate
//
//  Created by cptech on 2017/11/13.
//  Copyright © 2017年 cptech_yj. All rights reserved.
//

#import "LKClient.h"
#import "DBManager.h"
//#import "HHSoftReachability.h"
#import "Reachability.h"
//#import "LKIContactManager.h"
#import "LKContactManager.h"
#import "LKChatManager.h"
#import <UserNotifications/UserNotifications.h>
//#import "UserInfoEngine.h"
@interface LKClient () <ExportReadyStateCallback>
@property (nonatomic, strong) DBManager *db;
@property (nonatomic, strong) Reachability *hostReachability;
@property (nonatomic, strong) Reachability *internetReachability;
@property (nonatomic, strong) LKConnectionHandler *handlerConn;

@end


@implementation LKClient {
    
    ExportClient *client;
}


+ (instancetype)sharedClient {
    static LKClient *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LKClient alloc] init];
    });
    return manager;
}

- (instancetype)initWithOptions:(NSDictionary *)options {
    
    if (self = [super init]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _contactManager = [[LKContactManager alloc]init];
            _chatManager = [[LKChatManager alloc]init];
            _db = [DBManager sharedManager];
            _handlerConn = [[LKConnectionHandler alloc]init];
            _handlerConn.onConnection = ^(LKMessage *aMessage) {
                NSLog(@"网络已连接");

                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"connectedNotify" object:aMessage];
            };
            
            _handlerConn.onDisconnect = ^(LKError *err) {
                NSLog(@"网络已断开");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"disconnectedNotify" object:nil];
            };
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(reachabilityChanged:)
                                                         name:kReachabilityChangedNotification2
                                                       object:nil];
            
            
            self.hostReachability = [Reachability reachabilityForInternetConnection];
            [self.hostReachability startNotifier];
            
            self.internetReachability = [Reachability reachabilityForInternetConnection];
            [self.internetReachability startNotifier];
            NSString *ip = options[@"ip"];
            NSNumber *port = options[@"port"];
            
             client = [[ExportClient alloc] init:ip port:port.intValue readyStateCallback:self];
          //  client = [[ExportClient alloc] init:@"121.41.20.11" port:8080 readyStateCallback:self];
            [client setDebug:true];
            
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(appDidChangeState:)
                                                    name:UIApplicationDidBecomeActiveNotification
                                                       object:nil];
            
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(appDidChangeState:)
                                                         name:UIApplicationDidEnterBackgroundNotification
                                                       object:nil];
            
           
        });
    }
    return self;
}

- (void)appDidChangeState:(NSNotification *)notify
{
    NSDictionary *param = @{@"status":@"on"};
    if ([notify.name isEqualToString:@"UIApplicationDidEnterBackgroundNotification"]) {
        param = @{@"status":@"off"};
    }
    NSError *err0 = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    LKHandler *handler = [[LKHandler alloc] init];
    handler.succeed = ^(NSDictionary *result) {
    };
    handler.failure = ^(LKError *err) {
    };
    [client asyncSend:@"/v1/session/status" param:data callback:handler error:&err0];
    if(err0){
        
    }
    
}

- (void)onClose
{
    NSLog(@"%s", __func__);
    _handlerConn.onDisconnect(nil);
}
- (void)onError:(NSString*)err
{
    NSLog(@"%s", __func__);
}
- (void)onOpen
{
    NSLog(@"%s", __func__);
    _handlerConn.onConnection(nil);
    [self initSession];
    
    [self heartbeatSuccessful:^(NSDictionary *result) {
        NSLog(@"心跳包:%@", [NSDate date]);
        //   NSLog(@"心跳包：header:%@,body:%@",result[@"header"][@"value"],result[@"body"][@"value"]);
    } error:^(LKError *err) {
        
    }];
}


- (void)initializeSessionSuccessful:(void(^)(NSDictionary *result))successful error:(void(^)(LKError *err))error{
    //设置心跳包时间
    _retryInterval = 10;
    //初始化会话
    NSString *osVer = [[UIDevice currentDevice] systemVersion];
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *localVersionShort = dic[@"CFBundleShortVersionString"];
    NSString *devToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"deviceTokenForIM"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"mobile",@"device",@"iOS",@"os", osVer,@"os_version",@"WordWheat",@"app",localVersionShort,@"app_version",@{},@"tag", devToken, @"push_token", nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
    LKHandler *handler = [[LKHandler alloc] init];
    handler.succeed = ^(NSDictionary *result) {
        successful(result);
    };
    handler.failure = ^(LKError *err) {
        error(err);
    };
    NSError *err0 =nil;
    [client syncSend:@"/v1/session/start" param:data callback:handler error:&err0];
    if(err0){
        NSLog(@"%@",err0);
        error((LKError *)err0);
    }
}

- (void)initSession{

    NSString *sid = [[NSUserDefaults standardUserDefaults] valueForKey:@"sid"];
    if (sid) {
        NSLog(@"old sid = %@", sid);
        [client setRequestProperty:@"sid" value:sid];
    }
    
    [self initializeSessionSuccessful:^(NSDictionary *result) {
        if (!sid)
        {
            NSLog(@"new sid = %@", result[@"body"][@"value"]);
            if(result[@"body"][@"value"])
                //存sid在磁盘上
                [[NSUserDefaults standardUserDefaults] setValue:result[@"body"][@"value"] forKey:@"sid"];
            [client setRequestProperty:@"sid" value:result[@"body"][@"value"]];
        }
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
           
            [self login];
        });
        
        
    } error:^(LKError *err) {
       // [self openConnect];
    }];
    
}

- (void)heartbeatSuccessful:(void(^)(NSDictionary *result))successful error:(void(^)(LKError *err))error{
    __block LKHeartbeatHandler *handler = [[LKHeartbeatHandler alloc] init];
    handler.succeed = ^(NSDictionary *result) {
        successful(result);
    };
    handler.failure = ^(LKError *err) {
        error(err);
    };
    dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSError *err0 = nil;
        [client ping:_retryInterval param:nil callback:handler error:&err0];
        if(err0){
            NSLog(@"%@",err0);
            error((LKError *)err0);
        }
    });
}
- (LKError *) loginWithUsername:(NSString *)     aUsername
                       password:(NSString *)     aPassword{
    
   __block LKError *error = nil;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:aUsername,@"id",aPassword,@"password",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    LKLoginHandler *handler = [[LKLoginHandler alloc] init];

    handler.succeed = ^(NSDictionary *result) {

    };
    handler.failure = ^(LKError *err) {
        error = err;
    };
    [client syncSend:@"/v1/session/bind/uid" param:data callback:handler error:&error];
    return error;
}

- (void)loginWithToken:(NSString *)token
{
    __block LKError *error = nil;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:token, @"token",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    LKLoginHandler *handler = [[LKLoginHandler alloc] init];
    
    handler.succeed = ^(NSDictionary *result) {
      //  aCompletionBlock(aUsername,error);
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"Chat_Login"];
        NSLog(@"登录成功");
        [self addRxProcess];
    };
    handler.failure = ^(LKError *err) {
       // aCompletionBlock(aUsername,err);
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Chat_Login"];
         NSLog(@"登录失败%@", err);
    };
    
    [client syncSend:@"/v1/session/bind/uid/by/token" param:data callback:handler error:&error];
    if(error){
       // aCompletionBlock(aUsername,error);
         NSLog(@"登录失败%@", error);
    }
}

- (void)login
{
    NSString *account = [NSString stringWithFormat:@"%ld", [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"]] ;
    NSString *pwd = [[NSUserDefaults standardUserDefaults] stringForKey:@"chat_password"];
    if (account && pwd) {
        //登陆
        [self loginWithUsername:account password:pwd completion:^(NSString *aUsername, LKError *aError) {
            if(!aError){
                NSLog(@"登录成功");
                [self addRxProcess];
            }
            else{
                NSLog(@"登录失败%@",aError);
            }
        }];
    }
}

- (void) loginWithUsername:(NSString *)aUsername
                  password:(NSString *)aPassword
                completion:(void(^)(NSString *aUsername, LKError *aError))aCompletionBlock{
    __block LKError *error = nil;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:aUsername,@"id",aPassword,@"password",nil];
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:&error];
    
    LKLoginHandler *handler = [[LKLoginHandler alloc] init];
    
    handler.succeed = ^(NSDictionary *result) {
        aCompletionBlock(aUsername,error);
        [[NSUserDefaults standardUserDefaults]setBool:true forKey:@"Chat_Login"];
    };
    handler.failure = ^(LKError *err) {
        aCompletionBlock(aUsername,err);
        [[NSUserDefaults standardUserDefaults]setBool:false forKey:@"Chat_Login"];
    };
    
    [client syncSend:@"/v1/session/bind/uid" param:data callback:handler error:&error];
    if(error){
        aCompletionBlock(aUsername,error);
    }
}
- (void)logoutCompletion:(void(^)(LKError *aError))aCompletionBlock{
    __block  LKError *error = nil;
    LKLogoutHandler *handler = [[LKLogoutHandler alloc] init];
    handler.succeed = ^(NSDictionary *result) {
        aCompletionBlock(error);
    };
    handler.failure = ^(LKError *err) {
        aCompletionBlock(err);
    };
    
    [self asyncSend:@"/v1/session/unbind/uid" param:nil callback:handler error:&error];
    if(error){
        aCompletionBlock(error);
    }
}

- (BOOL)asyncSend:(NSString*)operator param:(NSData*)param callback:(id<ExportRequestStatusCallback>)callback error:(NSError**)error
{
    return [client asyncSend:operator param:param callback:callback error:error];
}

- (void)getDeviceInfo:(void(^)(NSArray  <LKChatSession *> *sessionList, LKError *aError))aCompletionBlock{

    LKAcquireHandler *handler = [[LKAcquireHandler alloc] init];
    
    handler.succeed = ^(NSArray<LKChatSession *> *list) {
        aCompletionBlock(list,nil);
    };
    handler.failure = ^(LKError *err) {
        aCompletionBlock(nil , err);
    };
    NSError *err0 = nil;
    [client asyncSend:@"/v1/session/list" param:nil callback:handler error:&err0];
    if(err0){
        aCompletionBlock(nil , (LKError *)err0);
    }
}

#pragma mark - OnOpen的回调
//
//- (void)handle:(NSData*)header body:(NSData*)body{
//
//  //  NSLog(@"%s",__func__);
//
//    [self initSession];
//
//    [self heartbeatSuccessful:^(NSDictionary *result) {
//        NSLog(@"心跳包:%@", [NSDate date]);
//     //   NSLog(@"心跳包：header:%@,body:%@",result[@"header"][@"value"],result[@"body"][@"value"]);
//    } error:^(LKError *err) {
//
//    }];
//}

- (void)reachabilityChanged:(NSNotification *)note {
    
    Reachability *reach = [note object];
    
    NetworkStatus status = [reach currentReachabilityStatus];
    if (status == _NotReachable) {
        if (_handlerConn && _handlerConn.onDisconnect) {
            _handlerConn.onDisconnect(nil);
        }
        
       // NSLog(@"Notification Says no network");
    } else if (status == _ReachableViaWWAN || status == _ReachableViaWiFi) {
        if (_handlerConn && _handlerConn.onConnection) {
            _handlerConn.onConnection(nil);
        }
        
     //   NSLog(@"Notification Says network ok");
    }
}

#pragma mark - ExportErrorHandler

- (void)handle:(NSString *)err{
    NSLog(@"%@",err);
}
#pragma makr - LKChatManager 聊天管理

- (void)addRxProcess
{
    LKDelegateHandler *handler = [[LKDelegateHandler alloc] init];
    handler.succeed = ^(LKMessage *aMessage) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"recvChatMessageNotify" object:aMessage];
        LKTextMessageBody *body = (LKTextMessageBody *)aMessage.body;
//        [UserInfoEngine getFriendUserInfo:aMessage.from.intValue block:^(UserInfo *info) {
//            NSString *str = [NSString stringWithFormat:@"%@:%@", info.userNickName, body.text];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self addLocalNotication:str type:0];
//            });
//
//        }];
        
    };
    
    LKMultiDeviceHandler *handler2 = [[LKMultiDeviceHandler alloc] init];
    handler2.onMessage = ^(int event, int from, int to) {
        NSInteger userId = [[NSUserDefaults standardUserDefaults] integerForKey:@"userID"];
        if (event == 1) {
            if (userId == from) {
                [self.chatManager readAllMsgOfUser:to toServer:false];
            }
            else if (userId == to)
            {
                [self.chatManager readAllMsgOfUser:from toServer:false];
            }
        }
        else
        {
            NSLog(@"error, event = %d", event);
        }
        
        
    };
    handler2.onGroup = ^(int event) {
        NSLog(@"onGroup, event = %d", event);
    };
    handler2.onContact =  ^(int event) {
        NSLog(@"onContact, event = %d", event);
    };
    
    [client addMessageListener:@"/v1/multi/device/listener" callback:handler2];
    [client addMessageListener:@"/v1/message/listener" callback:handler];
    [client addMessageListener:@"/v1/connection/listener" callback:_handlerConn];
}


- (void)addLocalNotication:(NSString *)str type:(NSInteger)type
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        
        //需创建一个包含待通知内容的 UNMutableNotificationContent 对象，注意不是 UNNotificationContent ,此对象为不可变对象。
        UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
        //   content.title = [NSString localizedUserNotificationStringForKey:@"BLE" arguments:nil];
        //   content.body = [NSString localizedUserNotificationStringForKey:@"Hello_message_body" arguments:nil];
        content.body = str;
//        NSString *soundName = [[SettingsModel getAlarmSoundName:type]lastPathComponent];
//        content.sound = [UNNotificationSound soundNamed:soundName];
        
        NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
        // 在 alertTime 后推送本地推送
        UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger
                                                      triggerWithTimeInterval:0.1 repeats:NO];
        
        UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:dic[@"CFBundleDisplayName"]
                                                                              content:content trigger:trigger];
        
        //添加推送成功后的处理！
        [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
            
        }];
        
    }
    else
    {
        UILocalNotification *notification=[[UILocalNotification alloc] init];
        if (notification!=nil) {
            notification.fireDate= [NSDate dateWithTimeIntervalSinceNow:0.1];
            //使用本地时区
            notification.timeZone = [NSTimeZone defaultTimeZone];
            notification.alertBody= str;
//            NSString *soundName = [[SettingsModel getAlarmSoundName:type]lastPathComponent];
      //      notification.soundName = soundName;
            //通知提示音 使用默认的
            //  notification.soundName = UILocalNotificationDefaultSoundName;
            //  notification.alertAction = NSLocalizedString(@"BLE", nil);
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

- (int)getUnreadMsgCount
{
    return [[DBManager sharedManager] dbGetAllUnreadCount];
}



@end



