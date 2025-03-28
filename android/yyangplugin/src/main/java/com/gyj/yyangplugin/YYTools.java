package com.gyj.yyangplugin;
import com.alibaba.fastjson.JSONObject;
import android.os.Bundle;
import java.util.Iterator;


public class YYTools {
    /**
     * 将 JSONObject 转换为 Bundle
     *
     * @param jsonObject 要转换的 JSONObject
     * @return 转换后的 Bundle
     */
    public static Bundle jsonObjectToBundle(JSONObject jsonObject) {
        Bundle bundle = new Bundle();
        if (jsonObject == null) {
            return bundle;
        }

        // 遍历 JSONObject 中的所有键
        Iterator<String> keys = jsonObject.keySet().iterator();
        while (keys.hasNext()) {
            String key = keys.next();
            Object value = jsonObject.get(key);

            if (value == null) {
                // 如果值为 null，跳过该键值对
                continue;
            }

            if (value instanceof String) {
                bundle.putString(key, (String) value);
            } else if (value instanceof Integer) {
                bundle.putInt(key, (Integer) value);
            } else if (value instanceof Long) {
                bundle.putLong(key, (Long) value);
            } else if (value instanceof Double) {
                bundle.putDouble(key, (Double) value);
            } else if (value instanceof Boolean) {
                bundle.putBoolean(key, (Boolean) value);
            } else {
                // 对于其他类型的值，可以根据需要进行扩展处理
                // 这里简单地将其转换为字符串存储
                bundle.putString(key, value.toString());
            }
        }

        return bundle;

    }


}




