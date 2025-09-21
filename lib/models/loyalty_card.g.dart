// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LoyaltyCard _$LoyaltyCardFromJson(Map<String, dynamic> json) => _LoyaltyCard(
  id: (json['id'] as num?)?.toInt(),
  merchant: json['merchant'] as String?,
  barcode: json['barcode'] as String?,
  barcodeType: json['barcodeType'] as String?,
  colorHex: json['colorHex'] as String?,
  dateAdded: json['dateAdded'] as String?,
  notes: json['notes'] as String?,
  favorite: json['favorite'] as bool? ?? false,
  displayValue: json['displayValue'] as String?,
);

Map<String, dynamic> _$LoyaltyCardToJson(_LoyaltyCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'merchant': instance.merchant,
      'barcode': instance.barcode,
      'barcodeType': instance.barcodeType,
      'colorHex': instance.colorHex,
      'dateAdded': instance.dateAdded,
      'notes': instance.notes,
      'favorite': instance.favorite,
      'displayValue': instance.displayValue,
    };
