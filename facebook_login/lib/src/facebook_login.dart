import 'dart:async';

import 'package:facebook_login/src/exception/facebook_login_exception.dart';
import 'package:facebook_login/src/login_behavior.dart';
import 'package:facebook_login/src/model/access_token.dart';
import 'package:flutter/services.dart';

class FacebookLogin {
  FacebookLogin._();

  factory FacebookLogin.shared() {
    return _instance;
  }

  static final FacebookLogin _instance = FacebookLogin._();

  final MethodChannel _channel = const MethodChannel('v7lin.github.io/facebook_login');

  Future<AccessToken> login({
    List<String> permissions = const <String>['email', 'public_profile'],
    String loginBehavior = LoginBehavior.DIALOG_ONLY,
  }) async {
    assert(permissions != null);
    assert(loginBehavior?.isNotEmpty ?? false);
    try {
      Map<String, dynamic> result = await _channel.invokeMapMethod<String, dynamic>(
        'login',
        <String, dynamic>{
          'permissions': permissions,
          'login_behavior': loginBehavior,
        },
      );
      return AccessToken.fromJson(result);
    } on PlatformException catch (e) {
      throw FacebookLoginException(
        code: e.code,
        message: e.message,
      );
    }
  }

  Future<void> logout() async {
    await _channel.invokeMethod<void>('logout');
  }
}
