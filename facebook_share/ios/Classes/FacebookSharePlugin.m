#import "FacebookSharePlugin.h"
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FacebookPlugin () <FBSDKSharingDelegate>
@end

@implementation FacebookSharePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"com.zhangzhongyun/facebook_share"
            binaryMessenger:[registrar messenger]];
  FacebookSharePlugin* instance = [[FacebookSharePlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"shareImage" isEqualToString:call.method]) {
        NSString *path = call.arguments[@"imageUri"];
        if (!path.length) {
            NSLog(@"facebook: error-图片地址为空");
        } else {
            [self shareImage:path];
        }
        result(nil);

    } else if ([@"shareWebpage" isEqualToString:call.method]) {
        NSString *link = call.arguments[@"webpageUrl"];
        //注：SDK默认会从link中获取title和desc
        if (!link.length) {
            NSLog(@"facebook: error-链接地址为空");
        } else {
            [self shareLink:link];
        }
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
  }
}

- (void)shareImage:(NSString *)path {
    //    NSLog(@"social_share_plugin: image_path-%@",path);
    //    path = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),@"paragraph.png"];
    if ([path hasPrefix:@"file://"]) {
        path = [path substringFromIndex:7];
    }
    NSLog(@"facebook: image_path-%@", path);
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];

    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc] init];
    photo.image = image;

    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[ photo ];

    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.shareContent = content;
    dialog.fromViewController = [self currentViewController];
    dialog.delegate = self;
    dialog.mode = FBSDKShareDialogModeNative;
    [dialog show];
}

- (void)shareLink:(NSString *)link {
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:link];

    FBSDKShareDialog *dialog = [[FBSDKShareDialog alloc] init];
    dialog.shareContent = content;
    dialog.fromViewController = [self currentViewController];
    dialog.delegate = self;
    dialog.mode = FBSDKShareDialogModeNative;
    [dialog show];
}

#pragma mark - <FBSDKSharingDelegate>

- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results {
    NSLog(@"facebook_share: success");
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error {
    NSLog(@"facebook_share: error %@", error);
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer {
    NSLog(@"facebook_share: cancel");
}

@end
