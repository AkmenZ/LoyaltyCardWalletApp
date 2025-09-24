// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Brands _$BrandsFromJson(Map<String, dynamic> json) => _Brands(
  id: json['id'] as String?,
  name: json['name'] as String?,
  logo: json['logo'] as String?,
  colorHex: json['colorHex'] as String?,
  regions: (json['regions'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
  popular: json['popular'] as bool?,
);

Map<String, dynamic> _$BrandsToJson(_Brands instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'logo': instance.logo,
  'colorHex': instance.colorHex,
  'regions': instance.regions,
  'popular': instance.popular,
};
