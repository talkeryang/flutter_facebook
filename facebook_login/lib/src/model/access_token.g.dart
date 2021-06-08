// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) {
  return AccessToken(
    token: json['token'] as String,
    userId: json['userId'] as String,
    expires: json['expires'] as int,
    applicationId: json['applicationId'] as String,
    lastRefresh: json['lastRefresh'] as int,
    graphDomain: json['graphDomain'] as String,
    isExpired: json['isExpired'] as bool,
    grantedPermissions: (json['grantedPermissions'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    declinedPermissions: (json['declinedPermissions'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$AccessTokenToJson(AccessToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'expires': instance.expires,
      'applicationId': instance.applicationId,
      'lastRefresh': instance.lastRefresh,
      'graphDomain': instance.graphDomain,
      'isExpired': instance.isExpired,
      'grantedPermissions': instance.grantedPermissions,
      'declinedPermissions': instance.declinedPermissions,
    };
