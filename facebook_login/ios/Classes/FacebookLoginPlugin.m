#import "FacebookLoginPlugin.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation FacebookLoginPlugin {
    FBSDKLoginManager *loginManager;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterMethodChannel *channel = [FlutterMethodChannel
        methodChannelWithName:@"v7lin.github.io/facebook_login"
              binaryMessenger:[registrar messenger]];
    FacebookLoginPlugin *instance = [[FacebookLoginPlugin alloc] init];
    [registrar addMethodCallDelegate:instance channel:channel];
    [registrar addApplicationDelegate:instance];
}

#pragma mark Init

- (instancetype)init {
    if (self = [super init]) {
        loginManager = [[FBSDKLoginManager alloc] init];
    }
    return self;
}

#pragma mark - MethodCallHandler

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([@"login" isEqualToString:call.method]) {
        [self login:call result:result];
    } else if ([@"logout" isEqualToString:call.method]) {
        [self logout:call result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (void)login:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSArray<NSString *> *permissions = call.arguments[@"permissions"];
    NSString *loginBehavior = call.arguments[@"login_behavior"];
    UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [loginManager logInWithPermissions:permissions fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult * _Nullable loginResult, NSError * _Nullable error) {
        if (error == nil) {
            if (loginResult.isCancelled) {
                result([FlutterError errorWithCode:@"CANCELLED" message:@"User has cancelled login with facebook" details:nil]);
            } else {
                FBSDKAccessToken *accessToken = loginResult.token;
                result(@{
                    @"token": accessToken.tokenString,
                    @"userId": accessToken.userID,
                    @"expires": [NSNumber numberWithLongLong:accessToken.expirationDate.timeIntervalSince1970 * 1000.0],
                    @"applicationId": accessToken.appID,
                    @"lastRefresh": [NSNumber numberWithLongLong:accessToken.refreshDate.timeIntervalSince1970 * 1000.0],
                    @"graphDomain": accessToken.graphDomain,
                    @"isExpired": [NSNumber numberWithBool:accessToken.isExpired],
                    @"grantedPermissions": [accessToken.permissions allObjects],
                    @"declinedPermissions": [accessToken.declinedPermissions allObjects],
                       });
            }
        } else {
            result([FlutterError errorWithCode:@"FAILED" message:error.localizedDescription details:nil]);
        }
    }];
}

- (void)logout:(FlutterMethodCall *)call result:(FlutterResult)result {
    [loginManager logOut];
    result(nil);
}

#pragma mark - ApplicationLifeCycleDelegate

@end
