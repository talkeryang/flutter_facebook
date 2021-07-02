import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

class FacebookSdk {
  FacebookSdk._();

  static const String _METHOD_LOGPURCHASE = 'logPurchase';
  static const String _ARGUMENT_KEY_PURCHASEAMOUNT = 'purchaseAmount';
  static const String _ARGUMENT_KEY_CURRENCY = 'currency';
  static const String _ARGUMENT_KEY_PARAMETERS = 'parameters';

  static FacebookSdk get instance => _instance;

  static final FacebookSdk _instance = FacebookSdk._();

  final MethodChannel _channel = const MethodChannel('v7lin.github.io/facebook_core');

  ///[purchaseAmount] 必传 价格
  ///[currency] 必传 单位
  ///[productId]产品id
  ///[contentId]动态广告必传 例如书籍id
  ///[contentType]类型 默认为product
  ///[content]默认为{}
  ///[mediaExtra]额外参数
  Future<void> logPurchase({
    required double purchaseAmount,
    required String currency,
    required String productId,
    String? contentId,
    String? contentType,
    String? content,
    Map<String, String>? mediaExtra,
  }) async {
    return _channel.invokeMethod(
      _METHOD_LOGPURCHASE,
      <String, dynamic>{
        _ARGUMENT_KEY_PURCHASEAMOUNT: purchaseAmount,
        _ARGUMENT_KEY_CURRENCY: currency,
        _ARGUMENT_KEY_PARAMETERS: json.encode(<String, dynamic>{
          'fb_content_id': contentId ?? productId,
          'fb_content_type': contentType ?? 'product',
          'fb_content': content ?? '{}',
          if (mediaExtra?.isNotEmpty ?? false) ...mediaExtra!,
        }),
      },
    );
  }

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
