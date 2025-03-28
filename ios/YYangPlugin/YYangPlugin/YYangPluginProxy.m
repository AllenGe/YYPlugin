//
//  YYangPluginProxy.m
//  YYangPlugin
//
//  Created by mt on 2025/3/5.
//

#import "YYangPluginProxy.h"

@implementation YYangPluginProxy

- (void)onCreateUniPlugin {
    NSLog(@"$$$YYangPluginProxy--- UniPluginProtocol Func: %@,%s",self,__func__);
}

- (BOOL)application:(UIApplication *_Nullable)application didFinishLaunchingWithOptions:(NSDictionary *_Nullable)launchOptions {
    NSLog(@"$$$YYangPluginProxy--- UniPluginProtocol Func: %@,%s",self,__func__);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication * _Nullable)application {
    NSLog(@"$$$YYangPluginProxy--- UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationDidBecomeActive:(UIApplication *_Nullable)application {
    NSLog(@"$$$YYangPluginProxy--- UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationDidEnterBackground:(UIApplication *_Nullable)application {
    NSLog(@"$$$YYangPluginProxy--- UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationWillEnterForeground:(UIApplication *_Nullable)application {
    NSLog(@"$$$YYangPluginProxy--- UniPluginProtocol Func: %@,%s",self,__func__);
}

- (void)applicationWillTerminate:(UIApplication *_Nullable)application {
    NSLog(@"$$$YYangPluginProxy--- UniPluginProtocol Func: %@,%s",self,__func__);
}

@end
