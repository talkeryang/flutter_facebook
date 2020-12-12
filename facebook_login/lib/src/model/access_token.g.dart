// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccessToken _$AccessTokenFromJson(Map<String, dynamic> json) {
  return AccessToken(
    declinedPermissions: (json['declined_permissions'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    grantedPermissions: (json['granted_permissions'] as List)
        ?.map((e) => e as String)
        ?.toList(),
    userId: json['user_id'] as String,
    expires: json['expires'] as int,
    lastRefresh: json['last_refresh'] as int,
    token: json['token'] as String,
    applicationId: json['application_id'] as String,
    graphDomain: json['graph_domain'] as String,
    isExpired: json['is_expired'] as bool,
  );
}

Map<String, dynamic> _$AccessTokenToJson(AccessToken instance) =>
    <String, dynamic>{
      'expires': instance.expires,
      'last_refresh': instance.lastRefresh,
      'user_id': instance.userId,
      'token': instance.token,
      'application_id': instance.applicationId,
      'graph_domain': instance.graphDomain,
      'declined_permissions': instance.declinedPermissions,
      'granted_permissions': instance.grantedPermissions,
      'is_expired': instance.isExpired,
    };
