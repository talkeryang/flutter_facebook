import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class FacebookSdk {
  FacebookSdk._();

  static const String _METHOD_LOGPURCHASE = 'logPurchase';
  static const String _ARGUMENT_KEY_PURCHASEAMOUNT = 'purchaseAmount';
  static const String _ARGUMENT_KEY_CURRENCY = 'currency';
  static const String _ARGUMENT_KEY_PARAMETERS = 'parameters';

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

  Future<void> logPurchaseIOS({
    required double purchaseAmount,
    required String currency,
    required String productIdentifier,
    required int quantity,
    required String transactionDate,
    String? localizedTitle,
    String? localizedDescription,
    required String transactionId,
    required String productType,
    Map<String, String>? mediaExtra,
  }) async {
    return _channel.invokeMethod(
      '_METHOD_LOGPURCHASE',
      <String, dynamic>{
        _ARGUMENT_KEY_PURCHASEAMOUNT: purchaseAmount,
        _ARGUMENT_KEY_CURRENCY: currency,
        _ARGUMENT_KEY_PARAMETERS: json.encode(<String, dynamic>{
          'fb_content_id': productIdentifier,
          'fb_num_items': quantity,
          'fb_transaction_date': transactionDate,
          if (localizedTitle?.isNotEmpty ?? false)
            'fb_content_title': localizedTitle,
          if (localizedDescription?.isNotEmpty ?? false)
            'fb_description': localizedDescription,
          'fb_transaction_id': transactionId,
          'fb_iap_product_type': productType,
          if(mediaExtra?.isNotEmpty ?? false)
            ...?mediaExtra,
        }),
      },
    );
  }

  /// Facebook 事件统计控制台设置「关闭 - 自动记录 Android 应用内购买事件」，此函数才有效
  Future<void> logPurchaseAndroid({
    required double purchaseAmount,
    required String currency,
    required String productId,
    required String purchaseTime,
    required String purchaseToken,
    String? packageName,
    String? productTitle,
    String? productDescription,
    required String productType,
    Map<String, String>? mediaExtra,
  }) {
    return _channel.invokeMethod(
      _METHOD_LOGPURCHASE,
      <String, dynamic>{
        _ARGUMENT_KEY_PURCHASEAMOUNT: purchaseAmount,
        _ARGUMENT_KEY_CURRENCY: currency,
        _ARGUMENT_KEY_PARAMETERS: json.encode(<String, dynamic>{
          'fb_iap_product_id': productId,
          'fb_iap_purchase_time': purchaseTime,
          'fb_iap_purchase_token': purchaseToken,
          if (packageName?.isNotEmpty ?? false)
            'fb_iap_package_name': packageName,
          if (productTitle?.isNotEmpty ?? false)
            'fb_iap_product_title': productTitle,
          if (productDescription?.isNotEmpty ?? false)
            'fb_iap_product_description': productDescription,
          'fb_iap_product_type': productType,
          if(mediaExtra?.isNotEmpty ?? false)
            ...?mediaExtra,
        }),
      },
    );
  }
}
