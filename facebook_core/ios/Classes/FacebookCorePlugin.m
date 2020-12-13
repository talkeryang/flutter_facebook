#import "FacebookCorePlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookCorePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/facebook_core"
              binaryMessenger:[registrar messenger]];
    FacebookCorePlugin *instance = [[FacebookCorePlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getApplicationId" isEqualToString:call.method]) {
//        result([[NSBundle mainBundle] objectForInfoDictionaryKey:@"FacebookAppID"] ?: [NSNull null]);
        result(FBSDKSettings.appID);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
