//
//  YYModule.m
//  YYangPlugin
//
//  Created by mt on 2025/3/5.
//

#import "YYModule.h"

#import "YYManager.h"
#import "YYHeader.h"



@implementation YYModule

- (void)openSwiftPage:(NSDictionary *)options callback:(UniModuleKeepAliveCallback)callback {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 实际使用 Swift 类（关键！）
//        YYSwift *swiftVC = [[YYSwift alloc] init];
         
    });
}


#pragma mark -  1111 暴露给js   初始化SDK @selector(initSDK:callback:
UNI_EXPORT_METHOD(@selector(initSDK:callback:))

- (void)initSDK:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    
    [YYManager initSDKPlatform:params callback:callback];
    
    [self callJSEvent:@{@"initSDKPlatform":@"~~~ [YYManager initSDKPlatform:params callback:callback];"}];
    
    
}


#pragma mark -  1111 暴露给js   自定义事件 @selector(callEvent:callback:
UNI_EXPORT_METHOD_SYNC(@selector(callEvent:callback:))

- (void)callEvent:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    
    //    [[MtFBManager sharedManager] callEventPlatform:platformName methodName:methodName eventName:eventName params:params];
    
    [YYManager callEventPlatform:params callback:callback];
    
    [self callJSEvent:@{@"callEvent":@"~~~ [YYManager callEventPlatform:params callback:callback];"}];
}


#pragma mark -  1111 暴露给js   启用||禁用 自动记录功能 @selector(callAutoEventsEnabled:callback:
UNI_EXPORT_METHOD_SYNC(@selector(callAutoEventsEnabled:callback:))

- (void)callAutoEventsEnabled:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    [YYManager callAutoPlatform:params callback:callback];
    
    [self callJSEvent:@{@"callAutoEventsEnabled":@"~~~ [YYManager callAutoEventsEnabled:params callback:callback];"}];
    
}


#pragma mark -  1111 暴露给js   启用||禁用 advertiser_id 收集功能 @selector(callAdvertiserIDEnabled:callback:
UNI_EXPORT_METHOD_SYNC(@selector(callAdvertiserIDEnabled:callback:))

- (void)callAdvertiserIDEnabled:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    
    [YYManager callAdvertiserIDPlatform:params callback:callback];
    
    [self callJSEvent:@{@"callAdvertiserIDEnabled":@"~~~ [YYManager callAdvertiserIDEnabled:params callback:callback];"}];
    
}


#pragma mark -  1111 暴露给js  (仅ios需要)应用事件的 ATT 权限状态 @selector(requestTrackingAuth:callback:
UNI_EXPORT_METHOD_SYNC(@selector(requestTrackingAuth:))

- (void)requestTrackingAuth:(nullable UniModuleKeepAliveCallback)callback {
    [YYManager requestTrackingAuth:callback];
    [self callJSEvent:@{@"callEvent":@"~~~ [YYManager requestTrackingAuth:callback];"}];
    
//    - pageName: 必传，页面名称，如 YYSwift，已开发存在的页面
//    - pageTitle   可选， 页面标题（导航栏标题）
//    NSDictionary *params = @{@"pageName":@"YYSwift",@"pageTitle":@"SwiftUI"};
//    [YYManager pushNativePage:params callback:callback];
}


#pragma mark -  1111 暴露给js  uni-app 跳转到原生页面上。
UNI_EXPORT_METHOD_SYNC(@selector(pushNativePage:callback:))

- (void)pushNativePage:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback {
    [YYManager pushNativePage:params callback:callback];
    
}


#pragma mark -  1111 在原生代码 发出myEvent事件
-(void)callJSEvent:(NSDictionary * _Nullable)params {
    //    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:@"yyEvent",@"eventName",nil];
    NSString * eventName = @"yyEvent";
    
    DCUniSDKInstance * instance = self.uniInstance;
    [instance fireGlobalEvent:eventName params:params];
       
}




@end
