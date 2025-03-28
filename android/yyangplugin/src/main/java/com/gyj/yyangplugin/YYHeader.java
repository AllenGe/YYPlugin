package com.gyj.yyangplugin;

// 定义一个名为 MtPlatform 的枚举类
public enum YYHeader {
    // 定义枚举常量，分别对应 facebook 和 google 平台
    FACEBOOK("facebook"),
    GOOGLE("google");

    // 定义一个私有成员变量，用于存储每个枚举常量对应的字符串值
    private final String value;

    // 构造函数，用于初始化枚举常量的字符串值
    YYHeader(String value) {
        this.value = value;
    }

    // 获取枚举常量对应的字符串值的方法
    public String getValue() {
        return value;
    }
}