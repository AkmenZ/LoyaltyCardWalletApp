import 'package:freezed_annotation/freezed_annotation.dart';

part 'brands.freezed.dart';
part 'brands.g.dart';

@freezed
abstract class Brands with _$Brands {
  const factory Brands({
    String? id,
    String? name,
    String? logo,
    String? colorHex,
    List<String>? regions,
    bool? popular,
  }) = _Brands;

  factory Brands.fromJson(Map<String, dynamic> json) =>
      _$BrandsFromJson(json);
}