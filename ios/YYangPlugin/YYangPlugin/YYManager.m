//
//  YYManager.m
//  YYangPlugin
//
//  Created by mt on 2025/3/5.
//

#import "YYManager.h"
#import "YYHeader.h"

#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>

//#import <FBSDKCoreKit/FBSDKCoreKit-Swift.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation YYManager

static NSString *const YYCodeSuccess = @"200";
static NSString *const YYCodeFailure = @"2001";
static NSString *const YYAuthMessage = @"0: NotDetermined-未决定; 1: Restricted-受限制;  2: Denied-拒绝; 3: Authorized-授权; 4: Unavailable-系统版本不支持;";



+ (void)initSDKPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    NSString *platformName = params[@"platformName"];
    NSString *appID = params[@"appID"];
    NSString *displayName = params[@"displayName"];
    NSString *clientToken = params[@"clientToken"];
    
    // **参数校验**：确保所有参数都不为空
    if (!platformName || !platformName.length || !appID || !appID.length || !displayName || !displayName.length || !clientToken || !clientToken.length) {
        if (callback) {
            callback(@{@"error": YYCodeFailure,@"message": @"Invalid parameters: platformName, appID, displayName, and clientToken are required"}, NO);
        }
        return;
    }

    if ([platformName isEqualToString:YYPlatformFacebook]) {
        NSString *sdkVersion = [[FBSDKSettings sharedSettings] sdkVersion];
        NSString *graphAPIVersion = [[FBSDKSettings sharedSettings] defaultGraphAPIVersion];
       
        NSLog(@"Facebook SDK 版本: %@", sdkVersion);
        NSLog(@"Facebook SDK GraphAPIVersion 版本: %@", graphAPIVersion);

        dispatch_async(dispatch_get_main_queue(), ^{
 
            //在 主线程 初始化 Facebook SDK

            [FBSDKSettings.sharedSettings setAppID:appID];
            [FBSDKSettings.sharedSettings setDisplayName:displayName];
            [FBSDKSettings.sharedSettings setClientToken:clientToken];
             
            
            // 仅在 Debug 模式下启用 Facebook SDK 的调试日志
            #ifdef DEBUG
//                [FBSDKSettings.sharedSettings enableLoggingBehavior:FBSDKLoggingBehaviorGraphAPIDebugInfo];
                [FBSDKSettings.sharedSettings enableLoggingBehavior:FBSDKLoggingBehaviorDeveloperErrors];
                [FBSDKSettings.sharedSettings enableLoggingBehavior:FBSDKLoggingBehaviorAppEvents];
            #endif
             
            //手动开始 初始化SDK
//            [[FBSDKApplicationDelegate sharedInstance] application:UIApplication.sharedApplication didFinishLaunchingWithOptions:nil];
            [FBSDKApplicationDelegate.sharedInstance initializeSDK];
            
            NSLog(@"Facebook SDK isAutoLogAppEventsEnabled: %d", [[FBSDKSettings sharedSettings] isAutoLogAppEventsEnabled]);
            
            
            // 尝试记录一个简单的事件来检查 SDK 是否初始化成功
            [[FBSDKAppEvents shared] logEvent:@"YYangPluginInitializationCheck" parameters:@{@"platform":@"ios"}];
             
            
            // **检测初始化是否成功**
            if ([FBSDKSettings sharedSettings].appID) {
                NSLog(@"Facebook SDK 初始化状态: %@", [FBSDKSettings sharedSettings].appID);

                // **SDK 初始化成功**
                if (callback) {
                    callback(@{@"error": YYCodeSuccess, @"message": @"Facebook SDK initialized successfully"}, NO);
                }
            } else {
                // **SDK 可能初始化失败**
                if (callback) {
                    callback(@{@"error": YYCodeFailure, @"message": @"Facebook SDK initialization failed"}, NO);
                }
            }
            
        });
        
    }else if ([platformName isEqualToString:YYPlatformGoogle]){
        
    }else {
        // 如果平台不支持
        if (callback) {
            callback(@{@"error": YYCodeFailure, @"message": @"Unsupported platform"}, NO);
        }

    }
}


+ (void)callEventPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    //    [FBSDKAppEvents.shared logEvent:FBSDKAppEventNamePurchased]; //简单上报支付
    //    [FBSDKAppEvents.shared logEvent:FBSDKAppEventNameAdClick parameters:options];
        
    NSString *platformName = params[@"platformName"];
    NSString *methodName = params[@"methodName"];
    NSString *eventName = params[@"eventName"];
    NSDictionary *customParams = params[@"customParams"];
    
    // **参数校验**：确保所有参数都不为空
    if (!platformName || !platformName.length || !methodName || !methodName.length || !eventName || !eventName.length) {
        if (callback) {
            callback(@{@"error": YYCodeFailure,@"message": @"Invalid parameters: platformName, methodName, and eventName are required"}, NO);
        }
        return;
    }
    
    // 检查 method 是否已经包含冒号，如果没有，则在末尾添加冒号
    if (![methodName hasSuffix:@":"]) {
        methodName = [methodName stringByAppendingString:@":"];
    }
 
    NSLog(@"1111 method: %@", methodName);
    SEL selector = NSSelectorFromString(methodName); // 获取选择器
    NSLog(@"2222 selector: %@", NSStringFromSelector(selector));

    @try {
        if ([platformName isEqualToString:YYPlatformFacebook]) {
            
            if ([FBSDKSettings sharedSettings].appID) {
                NSLog(@"callEventPlatform Facebook SDK 初始化状态: %@", [FBSDKSettings sharedSettings].appID);

//                            [FBSDKAppEvents.shared logEvent:eventName parameters:options];
                
                if ([FBSDKAppEvents.shared respondsToSelector:selector]) {
                    // 如果 parameters 为 nil，则调用不带参数的 logEvent
                    if (customParams && [customParams isKindOfClass:[NSDictionary class]]) {
                        NSMutableDictionary *parameters = [customParams mutableCopy];
                        [parameters setValue:@"ios" forKey:@"platform"];
                        //有参数，就调用 自定义 事件
                        [[FBSDKAppEvents shared] performSelector:selector withObject:eventName withObject:parameters];
                        
                    } else {
                        //自带事件 || 自定义事件， 无参数
                        [[FBSDKAppEvents shared] performSelector:selector withObject:eventName];
                    }
                    
                    if (callback) {
                        callback(@{@"error": YYCodeSuccess, @"message": @"FBSDKAppEvents.shared 发起事件"}, NO);
                    }
                    
                    //            // 使用NSInvocation来调用方法
                    //            NSMethodSignature *signature = [FBSDKAppEvents.shared methodSignatureForSelector:selector];
                    //            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
                    //            invocation.target = FBSDKAppEvents.shared;
                    //            invocation.selector = selector;
                    //            if (options) {// 如果有参数
                    //                [invocation setArgument:&eventName atIndex:2];  // eventName
                    //                [invocation setArgument:&params atIndex:3];    // params
                    //            } else {
                    //                [invocation setArgument:&eventName atIndex:2];  // 仅 eventName
                    //            }
                    //            [invocation invoke]; // 调用方法
                    
                } else {
                    NSLog(@"FBSDKAppEvents.shared 不能响应 logEvent:parameters: 方法");
                    if (callback) {
                        callback(@{@"error": YYCodeFailure, @"message": @"FBSDKAppEvents.shared 不能响应 logEvent:parameters: 方法"}, NO);
                    }
                }
            } else {
                // **SDK 可能初始化失败**
                if (callback) {
                    callback(@{@"error": YYCodeFailure, @"message": @"The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first."}, NO);
                }
            }
            
            
            
        }else if ([platformName isEqualToString:YYPlatformGoogle]){
            // 如果平台不支持
            if (callback) {
                callback(@{@"error": YYCodeFailure, @"message": @"Unsupported platform"}, NO);
            }
        }else {
            // 如果平台不支持
            if (callback) {
                callback(@{@"error": YYCodeFailure, @"message": @"Unsupported platform"}, NO);
            }
            
        }
    }
   
    @catch (NSException *exception) {
        // 捕获并处理异常
        NSLog(@"发生异常: %@", exception.reason);
        if (callback) {
            callback(@{@"error": YYCodeFailure, @"message": [NSString stringWithFormat:@"Exception occurred: %@", exception.reason]}, NO);
        }
    }
    
}


+ (void)callAutoPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    
    NSString *platformName = params[@"platformName"];
    BOOL isEnabled = NO; // 默认值设置为 false
    
    if ([platformName isEqualToString:YYPlatformFacebook]) {
        if ([FBSDKSettings sharedSettings].appID) { // **SDK 初始化成功**
            // 检查 params 字典中是否包含 isEnabled 键
            if (params[@"isEnabled"] != nil) {
                isEnabled = [params[@"isEnabled"] boolValue];
            }
            
            NSLog(@"Facebook SDK setIsAutoLogAppEventsEnabled :isEnabled= %d", isEnabled);
            
            [[FBSDKSettings sharedSettings] setIsAutoLogAppEventsEnabled:isEnabled]; //启用自动记录功能
            
            if (callback) {
                callback(@{@"error": YYCodeSuccess, @"message": @"Facebook SDK setIsAutoLogAppEventsEnabled 启用||禁用 自动记录功能"}, NO);
            }
        } else {
            // **SDK 可能初始化失败**
            if (callback) {
                callback(@{@"error": YYCodeFailure, @"message": @"The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first."}, NO);
            }
        }
          
    }else if ([platformName isEqualToString:YYPlatformGoogle]){
        // 如果平台不支持
        if (callback) {
            callback(@{@"error": YYCodeFailure, @"message": @"Unsupported platform"}, NO);
        }
    }else {
        // 如果平台不支持
        if (callback) {
            callback(@{@"error": YYCodeFailure, @"message": @"Unsupported platform"}, NO);
        }
        
    }
    
}



+ (void)callAdvertiserIDPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    
    NSString *platformName = params[@"platformName"];
    BOOL isEnabled = NO; // 默认值设置为 false
    
    if ([platformName isEqualToString:YYPlatformFacebook]) {
        if ([FBSDKSettings sharedSettings].appID) { // **SDK 初始化成功**
            // 检查 params 字典中是否包含 isEnabled 键
            if (params[@"isEnabled"] != nil) {
                isEnabled = [params[@"isEnabled"] boolValue];
            }
            
            NSLog(@"Facebook SDK setIsAdvertiserIDCollectionEnabled :isEnabled= %d", isEnabled);
            
            [[FBSDKSettings sharedSettings] setIsAdvertiserIDCollectionEnabled:isEnabled]; //启用||禁用 advertiser_id 收集功能
            
            if (callback) {
                callback(@{@"error": YYCodeSuccess, @"message": @"Facebook SDK setIsAdvertiserIDCollectionEnabled 启用||禁用 advertiser_id 收集功能"}, NO);
            }
        } else {
            // **SDK 可能初始化失败**
            if (callback) {
                callback(@{@"error": YYCodeFailure, @"message": @"The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first."}, NO);
            }
        }
          
    }else if ([platformName isEqualToString:YYPlatformGoogle]){
        // 如果平台不支持
        if (callback) {
            callback(@{@"error": YYCodeFailure, @"message": @"Unsupported platform"}, NO);
        }
    }else {
        // 如果平台不支持
        if (callback) {
            callback(@{@"error": YYCodeFailure, @"message": @"Unsupported platform"}, NO);
        }
        
    }
    
}



//ATTrackingManagerAuthorizationStatus 对应值：
//0: NotDetermined    // 未决定
//1: Restricted       // 受限制
//2: Denied           // 拒绝
//3: Authorized       // 授权
//4: Unavailable      // 系统版本不支持时返回（iOS <14 的情况）
/**
 应用事件的 ATT 权限状态
 */
+ (void)requestTrackingAuth:(nullable UniModuleKeepAliveCallback)callback {
    
    if (@available(iOS 14, *)) {
        // iOS 14+ 处理逻辑
        ATTrackingManagerAuthorizationStatus status = [ATTrackingManager trackingAuthorizationStatus];
        
        // 如果尚未请求授权
        if (status == ATTrackingManagerAuthorizationStatusNotDetermined) {
            [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                // 主线程回调
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (callback) {
                        callback(@{@"error": status==3 ? YYCodeSuccess : YYCodeFailure, @"message": YYAuthMessage ,@"status": @(status)}, NO);
                    }
                });
            }];
            
        }
//        else if(status == ATTrackingManagerAuthorizationStatusDenied){ }
        else {
            // 已经请求过授权，直接返回当前状态
            if (callback) {
                callback(@{@"error": status==3 ? YYCodeSuccess : YYCodeFailure, @"message": YYAuthMessage ,@"status": @(status)}, NO);
            }
        }
        
    } else {
        // iOS 13 及以下版本
        if (callback) {
            BOOL canTrack = [[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled];
            NSInteger legacyStatus = canTrack ? 3 : 2; // 3=Authorized, 2=Denied
            if (callback) {
                callback(@{@"error": legacyStatus==3 ? YYCodeSuccess : YYCodeFailure, @"message": YYAuthMessage ,@"status": @(legacyStatus)}, NO);
            }
         }
    }

    
}


//nonnull：表示 params 参数必须非空，调用时不可传递 nil。
//
//nullable：表示 callback 参数允许为空，调用时可传递 nil。


@end
