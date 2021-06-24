import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

class FacebookShare {
  FacebookShare._();

  static FacebookShare get instance => _instance;

  static final FacebookShare _instance = FacebookShare._();

  final MethodChannel _channel = const MethodChannel('com.zhangzhongyun/facebook_share');

  Future<void> shareImage({required Uri? imageUri}) {
    assert(Platform.isIOS);
    assert(imageUri != null && (imageUri.isScheme('file') || imageUri.isScheme('http') || imageUri.isScheme('https')));
    return _channel.invokeMethod(
      'shareImage',
      <String, dynamic>{
        'imageUri': imageUri.toString(),
      },
    );
  }

  Future<void> shareWebpage({required String? webpageUrl}) {
    assert(Platform.isIOS);
    assert(webpageUrl != null && webpageUrl.isNotEmpty);
    return _channel.invokeMethod(
      'shareWebpage',
      <String, dynamic>{
        'webpageUrl': webpageUrl,
      },
    );
  }
}
