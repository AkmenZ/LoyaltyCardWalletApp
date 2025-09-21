import 'package:freezed_annotation/freezed_annotation.dart';

part 'loyalty_card.freezed.dart';
part 'loyalty_card.g.dart';

@freezed
abstract class LoyaltyCard with _$LoyaltyCard {
  const factory LoyaltyCard({
    int? id,
    String? merchant,
    String? barcode,
    String? barcodeType,
    String? colorHex,
    String? dateAdded,
    String? notes,
    @Default(false) bool favorite,
    String? displayValue,
  }) = _LoyaltyCard;

  factory LoyaltyCard.fromJson(Map<String, dynamic> json) =>
      _$LoyaltyCardFromJson(json);
}