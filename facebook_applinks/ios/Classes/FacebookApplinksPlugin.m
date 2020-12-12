#import "FacebookApplinksPlugin.h"

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
  result(FlutterMethodNotImplemented);
}

@end
