import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FacebookSdk {
  FacebookSdk._();

  @visibleForTesting
  static const MethodChannel channel = MethodChannel('v7lin.github.io/facebook_core');

  static Future<String> getApplicationId() {
    return channel.invokeMethod<String>('getApplicationId');
  }
}
