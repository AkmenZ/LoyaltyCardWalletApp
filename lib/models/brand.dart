import 'package:freezed_annotation/freezed_annotation.dart';

part 'brand.freezed.dart';
part 'brand.g.dart';

@freezed
abstract class Brand with _$Brand {
  const factory Brand({
    String? id,
    String? name,
    String? logo,
    String? colorHex,
    List<String>? regions,
    List<String>? popularRegions,
    @Default(false) bool isCustom,
  }) = _Brand;

  factory Brand.fromJson(Map<String, dynamic> json) =>
      _$BrandFromJson(json);
}