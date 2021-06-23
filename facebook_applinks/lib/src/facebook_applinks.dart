import 'dart:async';

import 'package:facebook_applinks/src/model/app_link.dart';
import 'package:flutter/services.dart';

class FacebookApplinks {
  FacebookApplinks._() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static FacebookApplinks get instance => _instance;

  static final FacebookApplinks _instance = FacebookApplinks._();

  final MethodChannel _channel = const MethodChannel('v7lin.github.io/facebook_applinks');

  final StreamController<String?> _appLinkController = StreamController<String?>.broadcast();

  final StreamController<Map<String, dynamic>?> _deferredAppLinkController = StreamController<Map<String, dynamic>?>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'fetchAppLink':
        _appLinkController.add(call.arguments as String?);
        break;
      case 'fetchDeferredAppLink':
        _deferredAppLinkController.add(call.arguments as Map<String, dynamic>?);
        break;
    }
  }

  Stream<String?> get appLink {
    return _appLinkController.stream;
  }

  Stream<Map<String, dynamic>?> get deferredAppLink {
    return _deferredAppLinkController.stream;
  }

  Future<void> fetchAppLink() {
    return _channel.invokeMethod<String>('fetchAppLink');
  }

  Future<void> fetchDeferredAppLink() {
    return _channel.invokeMapMethod<String, dynamic>('fetchDeferredAppLink');
  }
}
