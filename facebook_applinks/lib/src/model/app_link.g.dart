// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_link.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeferredAppLink _$DeferredAppLinkFromJson(Map<String, dynamic> json) {
  return DeferredAppLink(
    targetUrl: json['target_url'] as String,
    promoCode: json['promo_code'] as String,
  );
}

Map<String, dynamic> _$DeferredAppLinkToJson(DeferredAppLink instance) =>
    <String, dynamic>{
      'target_url': instance.targetUrl,
      'promo_code': instance.promoCode,
    };
