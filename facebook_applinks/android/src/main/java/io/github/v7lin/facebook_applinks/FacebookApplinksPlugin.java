package io.github.v7lin.facebook_applinks;

import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Handler;
import android.os.Looper;
import android.text.TextUtils;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.facebook.applinks.AppLinkData;

import java.util.HashMap;
import java.util.Map;

import bolts.AppLinks;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FacebookApplinksPlugin
 */
public class FacebookApplinksPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.NewIntentListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  private Context applicationContext;
  private ActivityPluginBinding activityPluginBinding;

  private Handler mainHandler;

  // --- FlutterPlugin

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/facebook_applinks");
    channel.setMethodCallHandler(this);
    applicationContext = binding.getApplicationContext();
    mainHandler = new Handler(Looper.getMainLooper());
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
    applicationContext = null;
    mainHandler.removeCallbacksAndMessages(null);
    mainHandler = null;
  }

  // --- ActivityAware

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activityPluginBinding = binding;
    activityPluginBinding.addOnNewIntentListener(this);
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    activityPluginBinding.removeOnNewIntentListener(this);
    activityPluginBinding = null;
  }

  // --- MethodCallHandler

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull final Result result) {
    if ("fetchAppLink".equals(call.method)) {
      Intent intent = activityPluginBinding.getActivity().getIntent();
      Uri targetUrl = null;
      Uri url = intent.getData();
      if (url != null && TextUtils.equals(url.getScheme(), fetchUrlScheme())) {
        targetUrl = AppLinks.getTargetUrlFromInboundIntent(applicationContext, intent);
      }
      if (channel != null) {
        channel.invokeMethod("handleAppLink", targetUrl != null ? targetUrl.toString() : null);
      }
      result.success(targetUrl != null ? targetUrl.toString() : null);
    } else if ("fetchDeferredAppLink".equals(call.method)) {
      AppLinkData.fetchDeferredAppLinkData(applicationContext, new AppLinkData.CompletionHandler() {
        @Override
        public void onDeferredAppLinkDataFetched(@Nullable final AppLinkData appLinkData) {
          if (appLinkData != null) {
            if (mainHandler != null) {
              mainHandler.post(new Runnable() {
                @Override
                public void run() {
                  Map<String, Object> map = new HashMap<>();
                  map.put("target_url", appLinkData.getTargetUri() != null ? appLinkData.getTargetUri().toString() : null);
                  map.put("promo_code", appLinkData.getPromotionCode());
                  channel.invokeMethod("handleDeferredAppLink", map);
                  result.success(map);
                }
              });
            }
          } else {
            if (mainHandler != null) {
              mainHandler.post(new Runnable() {
                @Override
                public void run() {
                  result.success("");
                }
              });
            }
          }
        }
      });
    } else {
      result.notImplemented();
    }
  }

  private String fetchUrlScheme() {
    try {
      ApplicationInfo appInfo = applicationContext.getPackageManager().getApplicationInfo(applicationContext.getPackageName(), PackageManager.GET_META_DATA);
      return appInfo.metaData != null ? appInfo.metaData.getString("facebook_applinks") : null;
    } catch (PackageManager.NameNotFoundException e) {
      // ignore
    }
    return null;
  }

  // --- NewIntentListener

  @Override
  public boolean onNewIntent(Intent intent) {
    Uri url = intent.getData();
    if (url != null && TextUtils.equals(url.getScheme(), fetchUrlScheme())) {
      Uri targetUrl = AppLinks.getTargetUrlFromInboundIntent(applicationContext, intent);
      if (channel != null) {
        channel.invokeMethod("handleAppLink", targetUrl != null ? targetUrl.toString() : null);
      }
      return true;
    }
    return false;
  }
}
