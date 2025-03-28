//
//  YYManager.h
//  YYangPlugin
//
//  Created by mt on 2025/3/5.
//

#import <Foundation/Foundation.h>
#import "DCUniDefine.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYManager : NSObject



/**
1、iOS 版应用事件入门指南
https://developers.facebook.com/docs/app-events/getting-started-app-events-ios
 
2、自定义事件一起使用的实用事件参数
https://developers.facebook.com/docs/app-events/reference#standard-event-parameters-2
 */


/**
 1、允许您的应用使用 Facebook 服务 FacebookCore
 2、允许用户登录应用，同时允许应用请求访问数据的权限 FacebookLogin
 3、允许您的应用在 Facebook 上分享内容 FacebookShare
 4、允许用户登录您的应用，以参与并推广社交功能 FacebookGamingServices
 
 <key>CFBundleURLTypes</key>
 <array>
   <dict>
   <key>CFBundleURLSchemes</key>
   <array>
     <string>fbAPP-ID</string>  //在将 APP-ID 替换为您的应用编号。
   </array>
   </dict>
 </array>
 <key>FacebookAppID</key>
 <string>APP-ID</string>
 <key>FacebookClientToken</key> //客户端口令
 <string>CLIENT-TOKEN</string>
 <key>FacebookDisplayName</key>
 <string>APP-NAME</string>

 
 <key>LSApplicationQueriesSchemes</key>
 <array>
   <string>fbapi</string>
   <string>fb-messenger-share-api</string>
 </array>
 
 
 <key>FacebookAutoLogAppEventsEnabled</key> //将应用事件自动收集功能设为“true”或“false”。
 
 <true/>

 
 模版
 
 <dict>
     <key>CFBundleURLTypes</key>
     <array>
         <dict>
             <key>CFBundleURLSchemes</key>
             <array>
                 <string>fb1125858519332739</string>
             </array>
         </dict>
     </array>
     <key>FacebookAppID</key>
     <string>1125858519332739</string>
     <key>FacebookClientToken</key>
     <string>8f1eaef75d4e97292a78191be66b62d2</string>
     <key>FacebookDisplayName</key>
     <string>MtUniApp</string>
     <key>LSApplicationQueriesSchemes</key>
     <array>
         <string>fbapi</string>
         <string>fb-messenger-share-api</string>
         <string>fbauth2</string>
     </array>
     <key>FacebookAutoLogAppEventsEnabled</key>
     <true/>
 </dict>
 
 */
 

/**
    * initSDK 初始化SDK
    *
    * @param params 必传，一个对象，包含以下属性：
    *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
    *               - appID   必传， FacebookAppID（应用编号）
    *               - displayName    必传，FacebookDisplayName（应用名称）
    *               - clientToken 必传， 应用客户端口令
    *
    * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
    * ret = { "error": 200, "message": "初始化成功", 非200,初始化失败}
    * 自定义事件参数参考
    * https://developers.facebook.com/docs/app-events/reference#standard-event-parameters-2
    */
+ (void)initSDKPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback;

/**
     * callEvent 事件调用
     * @param params 必传，一个对象，包含以下属性：
     *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
     *               - methodName: 必传，原生方法名称，字符串类型，通常为 'logEvent'，可动态指定。
     *               - eventName: 必传，事件名称，字符串类型，可动态指定，如 'EventNameClickSomething'。
     *               - customParams: 可选，自定义事件参数，为键值对组成的对象，用于记录事件详细信息，
     *
     * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
     * ret = { "error": 200, "message": "没有异常信息", 非200,返回异常信息}
     * 自定义事件参数参考
     * https://developers.facebook.com/docs/app-events/reference#standard-event-parameters-2
     */
+ (void)callEventPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback;


/**
 * callAutoEventsEnabled、
 * * 用户同意后，调用 FacebookSdk 类的 setAutoLogAppEventsEnabled() 方法并设为 true，以重新启用自动记录功能。
 * @param params 必传，一个对象，包含以下属性：
 *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
 *               - isEnabled   可选， 默认false，不启用自动记录， true启用
 *
 * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
 * ret = { "error": 200, "message": "自动记录开关设置成功", 非200,设置失败}
 *
 */
+ (void)callAutoPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback;



/**
 * callAdvertiserIDPlatform
 * 用户同意后，调用 FacebookSdk 类的 setIsAdvertiserIDCollectionEnabled() 方法并设为 true，启用 advertiser_id 收集功能
 * @param params 必传，一个对象，包含以下属性：
 *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
 *               - isEnabled   可选， 默认false，不启用advertiser_id 收集功能， true启用
 *
 * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
 * ret = { "error": 200, "message": "advertiser_id 收集功能 开关成功", 非200,设置失败}
 *
 */
+ (void)callAdvertiserIDPlatform:(NSDictionary *)params callback:(nullable UniModuleKeepAliveCallback)callback;

/**
 * requestTrackingAuth、
 * 使用 Apple 的应用追踪透明度 (ATT) 系统 API  申请发送的应用事件的 ATT 权限状态
 *
 * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
 * ret = { "error": 200, "message": "已授权", 非200, 未授权等}
 *
 */
+ (void)requestTrackingAuth:(nullable UniModuleKeepAliveCallback)callback;


@end

NS_ASSUME_NONNULL_END
