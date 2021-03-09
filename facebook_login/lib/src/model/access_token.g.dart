// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) {
  return AccessToken(
    token: json['token'] as String,
    userId: json['user_id'] as String,
    expires: json['expires'] as int,
    applicationId: json['application_id'] as String,
    lastRefresh: json['last_refresh'] as int,
    graphDomain: json['graph_domain'] as String,
    isExpired: json['is_expired'] as bool,
    grantedPermissions: (json['granted_permissions'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    declinedPermissions: (json['declined_permissions'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
  );
}

Map<String, dynamic> _$AccessTokenToJson(AccessToken instance) =>
    <String, dynamic>{
      'token': instance.token,
      'user_id': instance.userId,
      'expires': instance.expires,
      'application_id': instance.applicationId,
      'last_refresh': instance.lastRefresh,
      'graph_domain': instance.graphDomain,
      'is_expired': instance.isExpired,
      'granted_permissions': instance.grantedPermissions,
      'declined_permissions': instance.declinedPermissions,
    };
