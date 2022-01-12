#import "FacebookApplinksPlugin.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface FacebookApplinksPlugin ()
@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSDictionary *launchOptions;

@end

@implementation FacebookApplinksPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/facebook_applinks"
              binaryMessenger:[registrar messenger]];
    FacebookApplinksPlugin *instance = [[FacebookApplinksPlugin alloc] initWithChannel:channel];
    [registrar addApplicationDelegate:instance];
    [registrar addMethodCallDelegate:instance channel:channel];
    NSLog(@"facebook_applinks: register ok");
}

#pragma mark - Init

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
        NSLog(@"facebook_applinks: fetchAppLink & waiting for - application: openURL: options:");
        result(nil);
    } else if ([@"fetchDeferredAppLink" isEqualToString:call.method]) {
        if (_launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
            NSLog(@"facebook_applinks: fetchDeferredAppLink");
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
        } else {
            NSLog(@"facebook_applinks: fetchDeferredAppLink _launchOptions[UIApplicationLaunchOptionsURLKey] has value");
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
    NSLog(@"facebook_applinks: openURL %@", url);
    
    if (url != nil && [url.scheme isEqualToString:[self fetchUrlScheme]]) {
        /*
         延迟深度链接：
         joyread://app_page?view=novel_info&id=522&al_applink_data={"target_url":"joyread:\/\/app_page?view=novel_info&id=522","extras":{"fb_app_id":414127799907383}}
         
         深度链接：
         joyread://app_page?view=novel_info&id=522&al_applink_data={"target_url":"http:\/\/itunes.apple.com\/app\/id1551079603","extras":[],"referer_app_link":{"url":"fb:\/\/\/","app_name":"Facebook"}}
         
         普通深度链接(不作处理)：
         joyread://app_page?view=novel_info&id=522
         */
        //组装FBSDKURL
        NSString *sourceApplication = _launchOptions[UIApplicationLaunchOptionsSourceApplicationKey];
        FBSDKURL *parsedUrl = [FBSDKURL URLWithInboundURL:url sourceApplication:sourceApplication];
        if (parsedUrl.targetURL != nil && parsedUrl.appLinkExtras != nil && [parsedUrl.appLinkExtras objectForKey:@"fb_app_id"]) {
            NSLog(@"facebook_applinks: handle fb deferred link %@", parsedUrl.targetURL.absoluteString);
            NSString *promoCode = [FBSDKAppLinkUtility appInvitePromotionCodeFromURL:parsedUrl.targetURL];
            [_channel invokeMethod:@"handleDeferredAppLink" arguments:@{
                @"target_url" : url.absoluteString,
                @"promo_code" : promoCode ? promoCode : @"",
            }];
        } else if (parsedUrl.targetURL != nil && parsedUrl.appLinkData != nil && [parsedUrl.appLinkData objectForKey:@"referer_app_link"]) {
            NSLog(@"facebook_applinks: handle fb deep link %@", url.absoluteString);
            [_channel invokeMethod:@"handleAppLink" arguments:url.absoluteString];
        } else {
            NSLog(@"facebook_applinks: pass handle %@", url.absoluteString);
        }

    }
    return YES;
}

@end
