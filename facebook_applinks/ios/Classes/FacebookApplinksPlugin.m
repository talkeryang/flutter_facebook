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
    if ([@"fetchAppLink" isEqualToString:call.method]) {
        NSURL *url = (NSURL *)_launchOptions[UIApplicationLaunchOptionsURLKey];
        bool isFBLink = url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]];
        if (isFBLink) {
            [_channel invokeMethod:@"handleAppLink" arguments:url.absoluteString];
        }
        result(nil);
    } else if ([@"fetchDeferredAppLink" isEqualToString:call.method]) {
        if (_launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
            //[FBSDKSettings setAutoInitEnabled:YES];
            [FBSDKApplicationDelegate initializeSDK:nil];
            [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *_Nullable url, NSError *_Nullable error) {
                if (error) {
                    NSLog(@"facebook_applinks: Received error while fetching deferred link %@", error.localizedDescription);
                    result([FlutterError errorWithCode:@"FAILED" message:error.localizedDescription details:nil]);
                }
                
                if (url) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
        }
        result(nil);
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
    // iOS9及以上
    NSLog(@"facebook_applinks: openURL %@", url);
    bool isFBLink = url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]];
    if (!isFBLink) {
        return NO;
    }
    
    if ([url.absoluteString containsString:@"fb_app_id"]) {
        // 延时深度链接
        NSLog(@"facebook_applinks: handle deferred link %@", url.absoluteString);

        NSString *promoCode = [FBSDKAppLinkUtility appInvitePromotionCodeFromURL:url];
        [_channel invokeMethod:@"handleDeferredAppLink" arguments:@{
            @"target_url" : url.absoluteString,
            @"promo_code" : promoCode ? promoCode : @"",
        }];
    } else {
        // 深度链接
        NSLog(@"facebook_applinks: handle deep link %@", url.absoluteString);
        
        [_channel invokeMethod:@"handleAppLink" arguments:url.absoluteString];
    }
    return YES;
}

@end
