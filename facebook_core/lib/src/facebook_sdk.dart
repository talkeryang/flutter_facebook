import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FacebookSdk {
  FacebookSdk._();

  static FacebookSdk get instance => _instance;

  static final FacebookSdk _instance = FacebookSdk._();

  @visibleForTesting
  final MethodChannel channel =
      const MethodChannel('v7lin.github.io/facebook_core');

  Future<String> getApplicationId() {
    return channel.invokeMethod<String>('getApplicationId');
  }
}
