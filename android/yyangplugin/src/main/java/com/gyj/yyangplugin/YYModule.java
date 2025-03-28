package com.gyj.yyangplugin;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.alibaba.fastjson.JSONObject;

import java.util.HashMap;
import java.util.Map;

import io.dcloud.feature.uniapp.annotation.UniJSMethod;
import io.dcloud.feature.uniapp.bridge.UniJSCallback;
import io.dcloud.feature.uniapp.common.UniModule;


public class YYModule extends UniModule {

    String TAG = "YYModule";
    public static int REQUEST_CODE = 1000;

    //run ui thread 是否要运行在 UI 线程
    @UniJSMethod(uiThread = true)
    public void testBlock(JSONObject options, UniJSCallback callback) {
        Log.e(TAG, "YYModule testAsyncFunc--"+options);
        if(callback != null) {
            JSONObject data = new JSONObject();
            data.put("code", "success");
            callback.invoke(data);
            //callback.invokeAndKeepAlive(data);

//            invoke调用javascript回调方法，此方法将在调用后被销毁。
//            invokeAndKeepAlive 调用javascript回调方法并保持回调活动以备以后使用。
        }
    }

    //run JS thread
    /**
     * initSDK 初始化SDK
     * @param params 必传，一个对象，包含以下属性：
     *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
     *               - appID   必传， FacebookAppID（应用编号）
     *               - displayName    必传，FacebookDisplayName（应用名称）
     *               - clientToken 必传， 应用客户端口令
     *
     * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
     * ret = { "error": 200, "message": "初始化成功", 非200,初始化失败}
     *
     */
    @UniJSMethod(uiThread = true)
    public void initSDK(@NonNull JSONObject params, @Nullable UniJSCallback callback) {
        // 执行初始化操作
        Log.d(TAG, "YYModule SDK Init Start。。。。。。" + params);

        // 构造要发送的事件参数
        Map<String, Object> par = new HashMap<>();
        par.put("yyEvent", "YYModule initSDK @UniJSMethod(uiThread = true)");
        YYManager.sendEvent(mUniSDKInstance,"yyEvent",par); //通过 yyEvent 调用uni-app 的方法

        YYManager.initSDKPlatform(params,callback); //调用 初始化 方法

    }

    //run JS thread
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
    @UniJSMethod(uiThread = true)
    public void callEvent(@NonNull JSONObject params, @Nullable UniJSCallback callback) {
        // 执行初始化操作
        Log.d("YYModule -callEvent", "YYModule callEvent 。。。。。。" + params);

        // 构造要发送的事件参数
        Map<String, Object> par = new HashMap<>();
        par.put("yyEvent", "YYModule callEvent @UniJSMethod(uiThread = true)");
        YYManager.sendEvent(mUniSDKInstance,"yyEvent",par); //通过 yyEvent 调用uni-app 的方法

        YYManager.callEventPlatform(params,callback); //调用 记录事件 方法
    }

    /**
     * callAutoEventsEnabled、
     * * 用户同意后，调用 FacebookSdk 类的 setAutoLogAppEventsEnabled() 方法并设为 true，以重新启用自动记录功能。
     * @param params 必传，一个对象，包含以下属性：
     *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
     *               - isEnabled   可选， 默认false，不启用自动记录， true启用
     *
     * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
     * ret = { "error": 200, "message": "初始化成功", 非200,初始化失败}
     *
     */
    @UniJSMethod(uiThread = true)
    public void callAutoEventsEnabled(@NonNull JSONObject params, @Nullable UniJSCallback callback) {
        // 执行初始化操作
        Log.d(TAG, "YYModule -callAutoEventsEnabled 。。。。。。" + params);

        // 构造要发送的事件参数
        Map<String, Object> par = new HashMap<>();
        par.put("yyEvent", "YYModule callAutoEventsEnabled @UniJSMethod(uiThread = true)");
        YYManager.sendEvent(mUniSDKInstance,"yyEvent",par); //通过 yyEvent 调用uni-app 的方法

        YYManager.callAutoPlatform(params,callback); //调用 记录事件 方法
    }

    /**
     * callAdvertiserIDEnabled 开启/关闭 advertiser_id 收集功能 （默认是关闭的）
     * * 用户同意后，调用 FacebookSdk 类的 setIsAdvertiserIDCollectionEnabled() 方法并设为 true，启用advertiser_id 收集功能。
     * @param params 必传，一个对象，包含以下属性：
     *               - platformName: 必传，平台标识，字符串类型，例如 'google'、'facebook' 或 'other'，用于区分不同平台。
     *               - isEnabled   可选， 默认false，不启用， true启用
     *
     * @param callback 可选，回调函数，用于接收方法执行结果反馈，格式为 (ret) => {  }。
     * ret = { "error": 200, "message": "advertiser_id 收集功能 开关设置成功", 非200,设置失败}
     *
     */
    @UniJSMethod(uiThread = true)
    public void callAdvertiserIDEnabled(@NonNull JSONObject params, @Nullable UniJSCallback callback) {
        // 执行初始化操作
        Log.d(TAG, "YYModule -callAdvertiserIDEnabled 。。。。。。" + params);

        // 构造要发送的事件参数
        Map<String, Object> par = new HashMap<>();
        par.put("yyEvent", "YYModule callAdvertiserIDEnabled @UniJSMethod(uiThread = true)");
        YYManager.sendEvent(mUniSDKInstance,"yyEvent",par); //通过 yyEvent 调用uni-app 的方法

        YYManager.callAdvertiserIDPlatform(params,callback); //调用 记录事件 方法
    }
}
