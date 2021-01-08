#import "FacebookApplinksPlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation FacebookApplinksPlugin {
    FlutterMethodChannel *_channel;
    NSDictionary *_launchOptions;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/facebook_applinks"
              binaryMessenger:[registrar messenger]];
    FacebookApplinksPlugin *instance = [[FacebookApplinksPlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];
}

#pragma mark Init

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
    }
    return self;
}

#pragma mark - MethodCallHandler

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
    if ([@"getInitialAppLink" isEqualToString:call.method]) {
        NSURL *targetUrl = nil;
        if (_launchOptions[UIApplicationLaunchOptionsURLKey] != nil) {
            NSURL *url = (NSURL *)_launchOptions[UIApplicationLaunchOptionsURLKey];
            NSString *sourceApplication = _launchOptions[UIApplicationLaunchOptionsSourceApplicationKey];
            if (url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]]) {
                FBSDKURL *appLink = [FBSDKURL URLWithInboundURL:url sourceApplication:sourceApplication];
                targetUrl = appLink.targetURL;
            }
        }
        result(targetUrl.absoluteString ?: [NSNull null]);
    } else if ([@"fetchDeferredAppLink" isEqualToString:call.method]) {
        [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *_Nullable url, NSError *_Nullable error) {
            if (error == nil) {
                FBSDKURL *appLink = url != nil ? [FBSDKURL URLWithURL:url] : nil;
                NSString *promoCode = url != nil ? [FBSDKAppLinkUtility appInvitePromotionCodeFromURL:url] : nil;
                result(@{
                    @"target_url" : appLink.targetURL.absoluteString ?: [NSNull null],
                    @"promo_code" : promoCode ?: [NSNull null],
                });
            } else {
                result([FlutterError errorWithCode:@"FAILED" message:error.localizedDescription details:nil]);
            }
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (NSString *)fetchUrlScheme {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray *types = [infoDic objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *type in types) {
        if ([@"facebook_applinks" isEqualToString:[type objectForKey:@"CFBundleURLName"]]) {
            return [type objectForKey:@"CFBundleURLSchemes"][0];
        }
    }
    return nil;
}

#pragma mark - ApplicationLifeCycleDelegate

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_9_0
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [self application:application
                     openURL:url
           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];

    return NO;
}
#endif

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if (url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]]) {
        FBSDKURL *appLink = [FBSDKURL URLWithInboundURL:url sourceApplication:sourceApplication];
        NSURL *targetUrl = appLink.targetURL;
        [_channel invokeMethod:@"handleAppLink" arguments:targetUrl.absoluteString ?: [NSNull null]];
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _launchOptions = launchOptions;
    return NO;
}

@end
