import 'package:json_annotation/json_annotation.dart';

part 'access_token.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class AccessToken {
  const AccessToken({
    required this.token,
    required this.userId,
    required this.expires,
    required this.applicationId,
    required this.lastRefresh,
    required this.graphDomain,
    required this.isExpired,
    this.grantedPermissions,
    this.declinedPermissions,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) => _$AccessTokenFromJson(json);

  final String token;

  final String userId;

  final int expires;

  final String applicationId;

  final int lastRefresh;

  final String graphDomain;

  final bool isExpired;

  final List<String>? grantedPermissions;

  final List<String>? declinedPermissions;

  Map<String, dynamic> toJson() => _$AccessTokenToJson(this);
}
