import 'dart:async';
import 'dart:io';

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

  final StreamController<DeferredAppLink?> _deferredAppLinkController = StreamController<DeferredAppLink?>.broadcast();

  Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'handleAppLink':
        _appLinkController.add(call.arguments as String?);
        break;
      case 'handleDeferredAppLink':
        _deferredAppLinkController.add(DeferredAppLink.fromJson((call.arguments as Map<dynamic, dynamic>).cast<String, dynamic>()));
        break;
    }
  }

  Stream<String?> get handleAppLink {
    assert(Platform.isIOS || Platform.isAndroid);
    return _appLinkController.stream;
  }

  Stream<DeferredAppLink?> get handleDeferredAppLink {
    assert(Platform.isIOS || Platform.isAndroid);
    return _deferredAppLinkController.stream;
  }

  Future<void> fetchAppLink() {
    return _channel.invokeMethod<void>('fetchAppLink');
  }

  Future<void> fetchDeferredAppLink() {
    return _channel.invokeMethod<void>('fetchDeferredAppLink');
  }
}
