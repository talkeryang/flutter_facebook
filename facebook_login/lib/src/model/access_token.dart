import 'package:json_annotation/json_annotation.dart';

part 'access_token.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class AccessToken {
  const AccessToken({
    this.declinedPermissions,
    this.grantedPermissions,
    this.userId,
    this.expires,
    this.lastRefresh,
    this.token,
    this.applicationId,
    this.graphDomain,
    this.isExpired,
  });

  factory AccessToken.fromJson(Map<String, dynamic> json) => _$AccessTokenFromJson(json);

  final int expires;

  final int lastRefresh;

  final String userId;

  final String token;

  final String applicationId;

  final String graphDomain;

  final List<String> declinedPermissions;

  final List<String> grantedPermissions;

  final bool isExpired;

  Map<String, dynamic> toJson() => _$AccessTokenToJson(this);
}
