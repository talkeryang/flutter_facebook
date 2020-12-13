#import "FacebookApplinksPlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookApplinksPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"v7lin.github.io/facebook_applinks"
            binaryMessenger:[registrar messenger]];
  FacebookApplinksPlugin *instance = [[FacebookApplinksPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([@"getInitialAppLink" isEqualToString:call.method]) {
        
    } else if ([@"fetchDeferredAppLink" isEqualToString:call.method]) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL * _Nullable url, NSError * _Nullable error) {
            if (error == nil) {
                result(@{
                    @"target_url": url.absoluteString ?: [NSNull null],
                    @"promo_code": url != nil ? [FBSDKAppLinkUtility appInvitePromotionCodeFromURL:url] : [NSNull null],
                       });
            } else {
                result([FlutterError errorWithCode:@"FAILED" message:error.localizedDescription details:nil]);
            }
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

@end
