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
    } else if ([@"logPurchase" isEqualToString:call.method]) {
        NSNumber *purchaseAmount = call.arguments[@"purchaseAmount"];
        NSString *currency = call.arguments[@"currency"];
        NSString *parameters = call.arguments[@"parameters"];
        NSError *error = nil;
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:[parameters dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            [FBSDKAppEvents logPurchase:purchaseAmount.doubleValue currency:currency];
        } else {
            [FBSDKAppEvents logPurchase:purchaseAmount.doubleValue currency:currency parameters:params];
        }
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
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
}

@end
