import 'dart:async';

import 'package:facebook_applinks/src/model/app_link.dart';
import 'package:flutter/services.dart';

class FacebookApplinks {
  FacebookApplinks._() {
    _channel.setMethodCallHandler(_handleMethod);
  }

  static FacebookApplinks get instance => _instance;

  static final FacebookApplinks _instance = FacebookApplinks._();

  final MethodChannel _channel =
      const MethodChannel('v7lin.github.io/facebook_applinks');

  final StreamController<String> _handleAppLinkController =
      StreamController<String>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'handleAppLink':
        _handleAppLinkController.add(call.arguments as String);
        break;
    }
  }

  Stream<String> get handleAppLink {
    return _handleAppLinkController.stream;
  }

  Future<String?> getInitialAppLink() {
    return _channel.invokeMethod<String>('getInitialAppLink');
  }

  Future<DeferredAppLink> fetchDeferredAppLink() async {
    final Map<String, dynamic>? result =
        await _channel.invokeMapMethod<String, dynamic>('fetchDeferredAppLink');
    return DeferredAppLink.fromJson(result!);
  }
}
