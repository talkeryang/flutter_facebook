import 'package:flutter/services.dart';

class FacebookSdk {
  FacebookSdk._();

  static FacebookSdk get instance => _instance;

  static final FacebookSdk _instance = FacebookSdk._();

  final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/facebook_core');

  Future<String?> getApplicationId() {
    return _channel.invokeMethod<String>('getApplicationId');
  }

    /// Facebook 用户追踪开关上报FB（iOS)
  Future<void> setAdvertiserTrackingEnabled({
    required bool? enabled,
  }) {
    return _channel.invokeMethod(
      'setAdvertiserTrackingEnabled',
      <String, dynamic>{
        'enabled': enabled,
      },
    );
  }
}
