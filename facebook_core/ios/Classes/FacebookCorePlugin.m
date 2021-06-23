#import "FacebookCorePlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/facebook_core"
              binaryMessenger:[registrar messenger]];
    FacebookCorePlugin *instance = [[FacebookCorePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

#pragma mark - MethodCallHandler

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getApplicationId" isEqualToString:call.method]) {
        //        result([[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"] ?: [NSNull null]);
        result(FBSDKSettings.appID);
    } else if ([@"setAdvertiserTrackingEnabled" isEqualToString:call.method]) {
        if (@available(iOS 14.0, *)) {
            BOOL enabled = [call.arguments[@"enabled"] boolValue];
            [FBSDKSettings setAdvertiserTrackingEnabled:enabled];
        }
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - ApplicationLifeCycleDelegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url options:options];
}
#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

@end
