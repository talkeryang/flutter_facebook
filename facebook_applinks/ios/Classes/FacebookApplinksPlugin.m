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
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
    NSLog(@"facebook_applinks: register ok");
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

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"getInitialAppLink" isEqualToString:call.method]) {
        // 获取初始化深度链接
        NSURL *targetUrl = nil;
        if (_launchOptions[UIApplicationLaunchOptionsURLKey] != nil) {
            NSURL *url = (NSURL *)_launchOptions[UIApplicationLaunchOptionsURLKey];
            NSString *sourceApplication = _launchOptions[UIApplicationLaunchOptionsSourceApplicationKey];
            if (url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]]) {
                FBSDKURL *appLink = [FBSDKURL URLWithInboundURL:url sourceApplication:sourceApplication];
                targetUrl = appLink.targetURL;
            }
        }
        result(targetUrl.absoluteString ? targetUrl.absoluteString : [NSNull null]);
    } else if ([@"fetchDeferredAppLink" isEqualToString:call.method]) {
        // 获取延迟深度链接
        if (_launchOptions[UIApplicationLaunchOptionsURLKey] != nil) {
            //[FBSDKSettings setAutoInitEnabled:YES];
            [FBSDKApplicationDelegate initializeSDK:nil];
            [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *_Nullable url, NSError *_Nullable error) {
                if (error) {
                    result([FlutterError errorWithCode:@"FAILED" message:error.localizedDescription details:nil]);
                }

                if (url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]]) {
                    FBSDKURL *appLink = [FBSDKURL URLWithURL:url];
                    NSString *promoCode = [FBSDKAppLinkUtility appInvitePromotionCodeFromURL:url];
                    result(@{
                        @"target_url" : appLink.targetURL.absoluteString ? appLink.targetURL.absoluteString : [NSNull null],
                        @"promo_code" : promoCode ? promoCode : [NSNull null],
                    });
                } else {
                    result([NSNull null]);
                }
            }];
        } else {
            result([NSNull null]);
        }
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (NSString *)fetchUrlScheme {
    NSString *scheme = @"";
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSArray *types = [infoDic objectForKey:@"CFBundleURLTypes"];
    for (NSDictionary *type in types) {
        if ([@"facebook_applinks" isEqualToString:[type objectForKey:@"CFBundleURLName"]]) {
            scheme = [[type objectForKey:@"CFBundleURLSchemes"] firstObject];
        }
    }
    return scheme;
}

#pragma mark - ApplicationLifeCycleDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _launchOptions = launchOptions;
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    // iOS9及以上 & 仅处理深度链接
    NSString *sourceApplication = _launchOptions[UIApplicationLaunchOptionsSourceApplicationKey];
    if (url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]]) {
        FBSDKURL *appLink = [FBSDKURL URLWithInboundURL:url sourceApplication:sourceApplication];
        [_channel invokeMethod:@"handleAppLink" arguments:appLink.targetURL.absoluteString ? appLink.targetURL.absoluteString : [NSNull null]];
        return YES;
    }
    return NO;
}

@end
