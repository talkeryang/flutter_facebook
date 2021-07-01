import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';

class FacebookSdk {
  FacebookSdk._();

  static const String _METHOD_LOGPURCHASE = 'logPurchase';
  static const String _ARGUMENT_KEY_PURCHASEAMOUNT = 'purchaseAmount';
  static const String _ARGUMENT_KEY_CURRENCY = 'currency';
  static const String _ARGUMENT_KEY_PARAMETERS = 'parameters';

  static FacebookSdk get instance => _instance;

  static final FacebookSdk _instance = FacebookSdk._();

  ///[purchaseAmount] 必传 价格
  ///[currency]单位
  ///[productId]产品id
  ///[productType]产品类型
  ///[purchaseTime]必传 时间
  ///[purchaseToken]android必传 token ios不用传
  ///[packageName]android包名  ios不用传
  ///[productTitle]产品名字
  ///[contentId]例如书籍id
  ///[contentType]类型 默认为product
  ///[content]默认为{}
  ///[productDescription]产品说明
  ///[transactionDate]时间 ios必传 android不用传
  ///[transactionId]ios必传 android不用传
  ///[quantity]ios必传 android不用传
  ///[mediaExtra]额外参数
  Future<void> logPurchase({
    required double purchaseAmount,
    required String currency,
    required String purchaseTime,
    required String productId,
    required String productType,
    String? contentId,
    String? purchaseToken,
    String? packageName,
    String? productTitle,
    String? contentType,
    String? content,
    String? productDescription,
    String? transactionId,
    int? quantity,
    Map<String, String>? mediaExtra,
  }) async {
    if (Platform.isAndroid) {
      assert(purchaseToken != null);
    } else if (Platform.isIOS) {
      assert(quantity != null && transactionId != null);
    }
    final Map<String, dynamic> android = <String, dynamic>{
      'fb_iap_purchase_token': purchaseToken,
      if (packageName?.isNotEmpty ?? false) 'fb_iap_package_name': packageName,
    };
    final Map<String, dynamic> ios = <String, dynamic>{
      'fb_num_items': quantity,
      'fb_transaction_id': transactionId,
    };
    return _channel.invokeMethod(
      _METHOD_LOGPURCHASE,
      <String, dynamic>{
        _ARGUMENT_KEY_PURCHASEAMOUNT: purchaseAmount,
        _ARGUMENT_KEY_CURRENCY: currency,
        _ARGUMENT_KEY_PARAMETERS: json.encode(<String, dynamic>{
          'fb_content_id': contentId ?? productId,
          'fb_content_type': contentType ?? 'product',
          'fb_content': content ?? '{}',
          'fb_iap_product_id': productId,
          'fb_iap_product_type': productType,
          'fb_iap_purchase_time': purchaseTime,
          if (Platform.isIOS) ...ios,
          if (Platform.isAndroid) ...android,
          if (productTitle?.isNotEmpty ?? false) 'fb_iap_product_title': productTitle,
          if (productDescription?.isNotEmpty ?? false) 'fb_iap_product_description': productDescription,
          if (mediaExtra?.isNotEmpty ?? false) ...mediaExtra!,
        }),
      },
    );
  }

  final MethodChannel _channel = const MethodChannel('v7lin.github.io/facebook_core');

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
