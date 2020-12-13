import 'package:json_annotation/json_annotation.dart';

part 'app_link.g.dart';

@JsonSerializable(
  explicitToJson: true,
  fieldRename: FieldRename.snake,
)
class DeferredAppLink {
  const DeferredAppLink({
    this.targetUrl,
    this.promoCode,
  });

  factory DeferredAppLink.fromJson(Map<String, dynamic> json) => _$DeferredAppLinkFromJson(json);

  final String targetUrl;
  final String promoCode;

  Map<String, dynamic> toJson() => _$DeferredAppLinkToJson(this);
}
