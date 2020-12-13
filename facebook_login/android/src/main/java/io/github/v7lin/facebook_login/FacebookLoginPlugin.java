package io.github.v7lin.facebook_login;

import android.content.Intent;

import androidx.annotation.NonNull;

import com.facebook.AccessToken;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.login.LoginBehavior;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;

/**
 * FacebookLoginPlugin
 */
public class FacebookLoginPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware, PluginRegistry.ActivityResultListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private ActivityPluginBinding activityPluginBinding;

    private final LoginManager loginManager = LoginManager.getInstance();
    private CallbackManager callbackManager;

    // --- FlutterPlugin

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        channel = new MethodChannel(binding.getBinaryMessenger(), "v7lin.github.io/facebook_login");
        channel.setMethodCallHandler(this);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
        channel = null;
    }

    // --- ActivityAware

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activityPluginBinding = binding;
        activityPluginBinding.addActivityResultListener(this);
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
        activityPluginBinding.removeActivityResultListener(this);
        activityPluginBinding = null;
    }

    // --- MethodCallHandler

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("login")) {
            login(call, result);
        } else if (call.method.equals("logout")) {
            logout(call, result);
        } else {
            result.notImplemented();
        }
    }

    private void login(@NonNull MethodCall call, @NonNull final Result result) {
        List<String> permissions = call.argument("permissions");
        String loginBehavior = call.argument("login_behavior");
        loginManager.setLoginBehavior(convertLoginBehavior(loginBehavior));
        callbackManager = CallbackManager.Factory.create();
        loginManager.registerCallback(callbackManager, new FacebookCallback<LoginResult>() {
            @Override
            public void onSuccess(LoginResult loginResult) {
                if (result != null) {
                    result.success(getAccessToken(loginResult.getAccessToken()));
                }
                unregisterCallback();
            }

            private Map<String, Object> getAccessToken(final AccessToken accessToken) {
                Map<String, Object> map = new HashMap<>();
                map.put("token", accessToken.getToken());
                map.put("userId", accessToken.getUserId());
                map.put("expires", accessToken.getExpires().getTime());
                map.put("applicationId", accessToken.getApplicationId());
                map.put("lastRefresh", accessToken.getLastRefresh().getTime());
                map.put("graphDomain", accessToken.getGraphDomain());
                map.put("isExpired", accessToken.isExpired());
                map.put("grantedPermissions", new ArrayList<>(accessToken.getPermissions()));
                map.put("declinedPermissions", new ArrayList<>(accessToken.getDeclinedPermissions()));
                return map;
            }

            @Override
            public void onCancel() {
                if (result != null) {
                    result.error("CANCELLED", "User has cancelled login with facebook", null);
                }
                unregisterCallback();
            }

            @Override
            public void onError(FacebookException error) {
                if (result != null) {
                    result.error("FAILED", error.getMessage(), null);
                }
                unregisterCallback();
            }

            private void unregisterCallback() {
                if (loginManager != null && callbackManager != null) {
                    loginManager.unregisterCallback(callbackManager);
                }
            }
        });
        loginManager.logIn(activityPluginBinding.getActivity(), permissions);
    }

    private LoginBehavior convertLoginBehavior(String loginBehavior) {
        if ("NATIVE_ONLY".equals(loginBehavior)) {
            return LoginBehavior.NATIVE_ONLY;
        } else if ("KATANA_ONLY".equals(loginBehavior)) {
            return LoginBehavior.KATANA_ONLY;
        } else if ("WEB_ONLY".equals(loginBehavior)) {
            return LoginBehavior.WEB_ONLY;
        } else if ("WEB_VIEW_ONLY".equals(loginBehavior)) {
            return LoginBehavior.WEB_VIEW_ONLY;
        } else if ("DIALOG_ONLY".equals(loginBehavior)) {
            return LoginBehavior.DIALOG_ONLY;
        } else if ("DEVICE_AUTH".equals(loginBehavior)) {
            return LoginBehavior.DEVICE_AUTH;
        }
        return LoginBehavior.NATIVE_WITH_FALLBACK;
    }

    private void logout(@NonNull MethodCall call, @NonNull final Result result) {
        loginManager.logOut();
        result.success(null);
    }

    // --- ActivityResultListener

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        return callbackManager != null && callbackManager.onActivityResult(requestCode, resultCode, data);
    }
}
