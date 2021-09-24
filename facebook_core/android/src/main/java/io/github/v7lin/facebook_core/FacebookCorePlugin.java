package io.github.v7lin.facebook_core;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;
import androidx.annotation.NonNull;
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Currency;
import java.util.Iterator;
import java.util.List;
import org.json.JSONException;
import org.json.JSONObject;

import static androidx.browser.customtabs.CustomTabsService.ACTION_CUSTOM_TABS_CONNECTION;

/**
 * FacebookCorePlugin
 */
public class FacebookCorePlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
  private static final String METHOD_LOGPURCHASE = "logPurchase";
  private static final String METHOD_SUPPORT_CUSTOM_TABS_PACKAGES = "supportCustomTabsPackages";
  private static final String ARGUMENT_KEY_PURCHASEAMOUNT = "purchaseAmount";
  private static final String ARGUMENT_KEY_CURRENCY = "currency";
  private static final String ARGUMENT_KEY_PARAMETERS = "parameters";
  private AppEventsLogger logger;
  private Context applicationContext;
  private ActivityPluginBinding activityPluginBinding;

  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;
  // --- FlutterPlugin

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
    channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/facebook_core");
    channel.setMethodCallHandler(this);
    applicationContext = binding.getApplicationContext();
    logger = AppEventsLogger.newLogger(applicationContext);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
    channel = null;
  }

  // --- MethodCallHandler

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if ("getApplicationId".equals(call.method)) {
      result.success(FacebookSdk.getApplicationId());
    } else if (METHOD_LOGPURCHASE.equals(call.method)) {
      logPurchase(call, result);
    } else if (METHOD_SUPPORT_CUSTOM_TABS_PACKAGES.equals(call.method)) {
      supportCustomTabsPackages(call, result);
    } else {
      result.notImplemented();
    }
  }

  private void logPurchase(final MethodCall call, Result result) {
    if (call != null && logger != null) {
      double purchaseAmount = call.argument(ARGUMENT_KEY_PURCHASEAMOUNT);
      String currency = call.argument(ARGUMENT_KEY_CURRENCY);
      String parameters = call.argument(ARGUMENT_KEY_PARAMETERS);
      Bundle params = new Bundle(1);
      try {
        JSONObject json = new JSONObject(parameters);
        for (Iterator<String> it = json.keys(); it.hasNext(); ) {
          String key = it.next();
          Object value = json.opt(key);
          if (value != null) {
            if (value instanceof CharSequence) {// String
              params.putCharSequence(key, (CharSequence) value);
            }
          }
        }
      } catch (JSONException ignore) {
        //
      }
      logger.logPurchase(new BigDecimal(purchaseAmount), Currency.getInstance(currency), params);
    }
    result.success(null);
  }

  private void supportCustomTabsPackages(final MethodCall call, Result result){
    ArrayList<ResolveInfo> packages = getCustomTabsPackages(applicationContext);
    result.success(packages.toString());
  }

  @Override public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    activityPluginBinding = binding;
    activityPluginBinding.addActivityResultListener(this);
  }

  @Override public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override public void onDetachedFromActivity() {
    activityPluginBinding.removeActivityResultListener(this);
    activityPluginBinding = null;
  }

  @Override public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
    return false;
  }

  /**
   * Returns a list of packages that support Custom Tabs.
   */
  public static ArrayList<ResolveInfo> getCustomTabsPackages(Context context) {
    PackageManager pm = context.getPackageManager();
    // Get default VIEW intent handler.
    Intent activityIntent = new Intent()
        .setAction(Intent.ACTION_VIEW)
        .addCategory(Intent.CATEGORY_BROWSABLE)
        .setData(Uri.fromParts("http", "", null));

    // Get all apps that can handle VIEW intents.
    List<ResolveInfo> resolvedActivityList = pm.queryIntentActivities(activityIntent, 0);
    ArrayList<ResolveInfo> packagesSupportingCustomTabs = new ArrayList<>();
    for (ResolveInfo info : resolvedActivityList) {
      Intent serviceIntent = new Intent();
      serviceIntent.setAction(ACTION_CUSTOM_TABS_CONNECTION);
      serviceIntent.setPackage(info.activityInfo.packageName);
      // Check if this package also resolves the Custom Tabs service.
      if (pm.resolveService(serviceIntent, 0) != null) {
        packagesSupportingCustomTabs.add(info);
      }
    }
    return packagesSupportingCustomTabs;
  }
}
