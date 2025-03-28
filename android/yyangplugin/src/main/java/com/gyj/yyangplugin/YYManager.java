package com.gyj.yyangplugin;
import android.os.Bundle;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import org.json.JSONException;

import com.alibaba.fastjson.JSONObject;
import com.facebook.FacebookSdk;
import com.facebook.LoggingBehavior;
import com.facebook.appevents.AppEventsLogger;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Map;
import io.dcloud.feature.uniapp.AbsSDKInstance;
import io.dcloud.feature.uniapp.bridge.UniJSCallback;


// 定义 YYManager 工具类
public class YYManager {

    private static final String TAG = "YYManager";
    private static final String APP_ID = "facebook_app_id"; //占位符

    private static final String  YYCodeSuccess = "200";
    private static final String YYCodeFailure = "2001";

    // 静态方法，用于 调用 uni-app方法
    public static void sendEvent(AbsSDKInstance mUniSDKInstance, String eventName, Map<String, Object> params) {
        // 获取 UniModule 的实例
        if (mUniSDKInstance != null) {
            mUniSDKInstance.fireGlobalEventCallback(eventName, params);
        } else {
            Log.e(TAG, "------ YYManager mUniSDKInstance is null, can't send event");
        }
    }

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
    public static void initSDKPlatform(@NonNull JSONObject params,@Nullable UniJSCallback callback) {

        JSONObject data = new JSONObject();

        String platformName = params.getString("platformName");
        String appID = params.getString("appID");
        String displayName = params.getString("displayName");
        String clientToken = params.getString("clientToken");


        // 检查必要参数是否为空
        if (platformName == null || platformName.isEmpty() || appID == null || appID.isEmpty() || displayName == null || displayName.isEmpty() || clientToken == null || clientToken.isEmpty()) {
            data.put("error", YYCodeFailure);
            data.put("message", "必要参数缺失，请检查 platformName、appID、displayName 和 clientToken");

        }else {
            if (platformName.equals(YYHeader.FACEBOOK.getValue())) {
                try {
                    // **手动设置 App ID 和 Client Token** (AndroidManifest.xml里ApplicationId还是得配置，内容必须是占位符 ID。FacebookSdk.setApplicationId才会生效)
                    FacebookSdk.setApplicationId(appID);
                    FacebookSdk.setClientToken(clientToken);
                    FacebookSdk.setApplicationName(displayName);

                    // **Facebook 15+ 初始化**
                    FacebookSdk.setAutoInitEnabled(true); //启用自动初始化，并调用fullyInitialize
                    FacebookSdk.fullyInitialize();

                    // **启用调试模式（可选）**
                    if (com.facebook.core.BuildConfig.DEBUG) {
                        FacebookSdk.setIsDebugEnabled(true);
                        FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
                    }

                    Log.d(TAG, "------ initSDKPlatform callEventPlatform: "+ FacebookSdk.isInitialized());
                    Log.d(TAG, "------ initSDKPlatform getApplicationId(): "+ FacebookSdk.getApplicationId());

                    // **检查 SDK 是否成功初始化**
                    if (FacebookSdk.isInitialized() && !FacebookSdk.getApplicationId().equals(APP_ID)) {
                        Log.d(TAG, "✅ Facebook SDK 初始化成功, App ID: " + FacebookSdk.getApplicationId());

                        data.put("error", YYCodeSuccess);
                        data.put("message", "✅ Facebook SDK 初始化成功, App ID: " + FacebookSdk.getApplicationId());


                    } else {
                        Log.e(TAG, "❌ Facebook SDK 初始化失败！");

                        data.put("error", "2002");
                        data.put("message", "❌ Facebook SDK 初始化失败！");
                    }
//                    在最终用户同意后，调用 FacebookSdk 类的 setAutoLogAppEventsEnabled() 方法并设为 true，以重新启用自动记录功能。
//                    FacebookSdk.setAutoLogAppEventsEnabled(true);

                } catch (Exception e) {
                    data.put("error", YYCodeFailure);
                    data.put("message", e.getMessage());

                }
            }else if (platformName.equals(YYHeader.GOOGLE.getValue())) {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");

            }else {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");

            }

            if (callback != null) {
                try {
                    callback.invokeAndKeepAlive(data);
                } catch (Exception e) {
                    Log.e(TAG, "------ YYManager 调用回调函数时出错" + e.getMessage());
                }
            }

        }

    }

    // 调用 Facebook 或 Google 事件
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
    public static void callEventPlatform(@NonNull JSONObject params, @Nullable UniJSCallback callback) {

        // 从 params 中提取所需参数
        String platformName =  params.getString("platformName");
        String methodName = params.getString("methodName");
        String eventName =  params.getString("eventName");
        JSONObject customParams = params.getJSONObject("customParams");

        JSONObject data = new JSONObject();
        // 检查必要参数是否为空
        if (platformName == null || platformName.isEmpty() ||
                methodName == null || methodName.isEmpty() ||
                eventName == null || eventName.isEmpty()) {

            data.put("error", YYCodeFailure);
            data.put("message", "必要参数缺失，请检查 platformName、methodName、eventName");
        }else {
            if (platformName.equals(YYHeader.FACEBOOK.getValue())) {

                Log.d(TAG, "!!!!!!!!!!!!! callEventPlatform: "+ FacebookSdk.isInitialized());
                Log.d(TAG, "33333333333333 callEventPlatform: "+ FacebookSdk.getApplicationId());

                if (FacebookSdk.isInitialized() && !FacebookSdk.getApplicationId().equals(APP_ID)){
                    try {
                        AppEventsLogger logger = AppEventsLogger.newLogger(FacebookSdk.getApplicationContext());
//                if(params != null ){
////                    有参数，记录带参数的时间
//                    logger.logEvent(eventName,params);
//                }else {
//                    logger.logEvent(eventName);
//                }
                        // 获取 AppEventsLogger 类的 Class 对象
                        Class<?> loggerClass = logger.getClass();
                        Method method;
                        if (customParams != null) {
                            customParams.put("platform","android");

                            Bundle bundle = YYTools.jsonObjectToBundle(customParams); //JSONObject 转换为 Bundle

                            // 查找带 Bundle 参数的方法
                            method = loggerClass.getMethod(methodName, String.class, Bundle.class);
                            // 调用方法
                            method.invoke(logger, eventName, bundle);
                        } else {
                            // 查找不带参数的方法
                            method = loggerClass.getMethod(methodName, String.class);
                            // 调用方法
                            method.invoke(logger, eventName);
                        }

                        data.put("error", YYCodeSuccess);
                        data.put("message", "发起事件：" + eventName);

                    } catch (NullPointerException e) {
                        Log.e(TAG, "------ YYManager 发生空指针异常，可能某些必要对象未正确初始化", e);

                        data.put("error", YYCodeFailure);
                        data.put("message", e.getMessage());
                    } catch (InvocationTargetException e) {
                        // 当被调用的方法内部抛出异常时，会通过此异常包装并抛出
                        Log.e(TAG, "------ YYManage 调用方法 " + methodName + " 时发生异常，内部异常信息：", e.getTargetException());

                        data.put("error", YYCodeFailure);
                        data.put("message", e.getMessage());

                    } catch (NoSuchMethodException e) {
                        // 当指定名称和参数类型的方法不存在时抛出此异常
                        Log.e(TAG, "------ 未YYManage 找到方法 " + methodName + "，请检查方法名和参数类型", e);

                        data.put("error", YYCodeFailure);
                        data.put("message", e.getMessage());

                    } catch (IllegalAccessException e) {
                        // 当尝试访问不可访问的方法时抛出此异常，例如私有方法
                        Log.e(TAG, "------ YYManage 无法访问方法 " + methodName + "，可能是方法访问权限问题", e);

                        data.put("error", YYCodeFailure);
                        data.put("message", e.getMessage());

                    } catch (Exception e) {
                        // 捕获其他未预料到的异常
                        Log.e(TAG, "------ YYManage 发生未知异常", e);

                        data.put("error", YYCodeFailure);
                        data.put("message", e.getMessage());
                    }

                }else {
                    Log.e(TAG, "------ YYManage The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.");

                    data.put("error", YYCodeFailure);
                    data.put("message", "The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.");
                }
            }else if (platformName.equals(YYHeader.GOOGLE.getValue())) {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");

            }else {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");

            }
        }
        if (callback != null) {
            try {
                callback.invokeAndKeepAlive(data);
            } catch (Exception e) {
                Log.e(TAG, "------ YYManage 调用回调函数时出错" + e.getMessage());
            }
        }

    }



    /**
     * callAutoPlatform、
     * * 用户同意后，调用 FacebookSdk 类的 setAutoLogAppEventsEnabled() 方法并设为 true，以重新启用自动记录功能。
     * @param params 必传，一个对象，包含以下属性：
     *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
     *               - isEnabled   可选， 默认false，不启用自动记录， true启用
     *
     * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
     * ret = { "error": 200, "message": "初始化成功", 非200,初始化失败}
     *
     */
    public static void callAutoPlatform(@NonNull JSONObject params, @Nullable UniJSCallback callback) {
        JSONObject data = new JSONObject();

        // 从 params 中提取所需参数
        String platformName =  params.getString("platformName");
        Boolean isEnabled = params.getBoolean("isEnabled");

        if (platformName == null || platformName.isEmpty() ) {
            data.put("error", YYCodeFailure);
            data.put("message", "必要参数缺失，请检查 platformName");
        }else {
            if (platformName.equals(YYHeader.FACEBOOK.getValue())) {
                try {
                    // **检查 SDK 是否成功初始化**
                    if (FacebookSdk.isInitialized() && !FacebookSdk.getApplicationId().equals(APP_ID)) {
                        if (isEnabled == null) {
                            isEnabled = false;
                        }

                        Log.d(TAG, "setAutoLogAppEventsEnabled :isEnabled= " + isEnabled);
                        //在最终用户同意后，调用 FacebookSdk 类的 setAutoLogAppEventsEnabled() 方法并设为 true，以重新启用自动记录功。
                        FacebookSdk.setAutoLogAppEventsEnabled(isEnabled);

                        data.put("error", YYCodeSuccess);
                        data.put("message", "Facebook SDK setAutoLogAppEventsEnabled 重新启用自动记录功能");

                    } else {
                        Log.e(TAG, "------ YYManage callAutoPlatform The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.");

                        data.put("error", YYCodeFailure);
                        data.put("message", "Extract string resource The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.");
                    }

                } catch (Exception e) {
                    data.put("error", YYCodeFailure);
                    data.put("message", e.getMessage());

                }
            }else if (platformName.equals(YYHeader.GOOGLE.getValue())) {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");

            }else {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");
            }
        }
        if (callback != null) {
            try {
                callback.invokeAndKeepAlive(data);
            } catch (Exception e) {
                Log.e(TAG, "------ YYManage 调用回调函数时出错" + e.getMessage());
            }
        }

    }


    /**
     * callAdvertiserIDPlatform 开启/关闭advertiser_id 收集功能 （默认是关闭的）
     * * 用户同意后，调用 FacebookSdk 类的 setIsAdvertiserIDCollectionEnabled() 方法并设为 true，启用advertiser_id 收集功能。
     * @param params 必传，一个对象，包含以下属性：
     *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
     *               - isEnabled   可选， 默认false，不启用， true启用
     *
     * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
     * ret = { "error": 200, "message": "advertiser_id 收集功能 开关设置成功", 非200,设置失败}
     *
     */
    public static void callAdvertiserIDPlatform(@NonNull JSONObject params, @Nullable UniJSCallback callback) {
        JSONObject data = new JSONObject();

        // 从 params 中提取所需参数
        String platformName =  params.getString("platformName");
        Boolean isEnabled = params.getBoolean("isEnabled");

        if (platformName == null || platformName.isEmpty() ) {
            data.put("error", YYCodeFailure);
            data.put("message", "必要参数缺失，请检查 platformName");
        }else {
            if (platformName.equals(YYHeader.FACEBOOK.getValue())) {
                try {
                    // **检查 SDK 是否成功初始化**
                    if (FacebookSdk.isInitialized() && !FacebookSdk.getApplicationId().equals(APP_ID)) {
                        if (isEnabled == null) {
                            isEnabled = false;
                        }

                        Log.d(TAG, "callAdvertiserIDPlatform :isEnabled= " + isEnabled);
                        //在最终用户同意后，调用 FacebookSdk 类的 setAutoLogAppEventsEnabled() 方法并设为 true，以重新启用自动记录功。
                        FacebookSdk.setAdvertiserIDCollectionEnabled(isEnabled);

                        data.put("error", YYCodeSuccess);
                        data.put("message", "Facebook SDK setAdvertiserIDCollectionEnabled advertiser_id 收集功能 开关设置成功");

                    } else {
                        Log.e(TAG, "------ YYManage callAdvertiserIDPlatform The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.");

                        data.put("error", YYCodeFailure);
                        data.put("message", "YYManage callAdvertiserIDPlatform  The SDK has not been initialized, make sure to call FacebookSdk.sdkInitialize() first.");
                    }

                } catch (Exception e) {
                    data.put("error", YYCodeFailure);
                    data.put("message", e.getMessage());

                }
            }else if (platformName.equals(YYHeader.GOOGLE.getValue())) {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");

            }else {
                // 如果平台不支持
                data.put("error", YYCodeFailure);
                data.put("message", "Unsupported platform");
            }
        }
        if (callback != null) {
            try {
                callback.invokeAndKeepAlive(data);
            } catch (Exception e) {
                Log.e(TAG, "------ YYManage 调用回调函数时出错" + e.getMessage());
            }
        }

    }

}