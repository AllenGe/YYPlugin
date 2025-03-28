package com.gyj.yyangplugin;

import android.app.Application;
import android.util.Log;

import com.facebook.FacebookSdk;

import io.dcloud.feature.uniapp.UniAppHookProxy;

public class YYModule_AppProxy implements UniAppHookProxy {


    String TAG = "YYModule_AppProxy";

    @Override
    public void onCreate(Application application) {
        //可写初始化触发逻辑、、、
        //当前uni应用进程回调 仅触发一次 多进程不会触发
        //可通过UniSDKEngine注册UniModule或者UniComponent
        Log.d(TAG, "1111111111111 onCreate: FacebookSdk.setAutoInitEnabled(false) ");
        FacebookSdk.setAutoInitEnabled(false);

    }

    @Override
    public void onSubProcessCreate(Application application) {
        //子进程初始化回调
        //其他子进程初始化回调 可用于初始化需要子进程初始化需要的逻辑

    }

}
