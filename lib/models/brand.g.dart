// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Brand _$BrandFromJson(Map<String, dynamic> json) => _Brand(
  id: json['id'] as String?,
  name: json['name'] as String?,
  logo: json['logo'] as String?,
  colorHex: json['colorHex'] as String?,
  regions: (json['regions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  popularRegions: (json['popularRegions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  isCustom: json['isCustom'] as bool? ?? false,
);

Map<String, dynamic> _$BrandToJson(_Brand instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo': instance.logo,
  'colorHex': instance.colorHex,
  'regions': instance.regions,
  'popularRegions': instance.popularRegions,
  'isCustom': instance.isCustom,
};
