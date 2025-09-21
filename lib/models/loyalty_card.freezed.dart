// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'loyalty_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LoyaltyCard {

 int? get id; String? get merchant; String? get barcode; String? get barcodeType; String? get colorHex; String? get dateAdded; String? get notes; bool get favorite; String? get displayValue;
/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoyaltyCardCopyWith<LoyaltyCard> get copyWith => _$LoyaltyCardCopyWithImpl<LoyaltyCard>(this as LoyaltyCard, _$identity);

  /// Serializes this LoyaltyCard to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoyaltyCard&&(identical(other.id, id) || other.id == id)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchant,barcode,barcodeType,colorHex,dateAdded,notes,favorite,displayValue);

@override
String toString() {
  return 'LoyaltyCard(id: $id, merchant: $merchant, barcode: $barcode, barcodeType: $barcodeType, colorHex: $colorHex, dateAdded: $dateAdded, notes: $notes, favorite: $favorite, displayValue: $displayValue)';
}


}

/// @nodoc
abstract mixin class $LoyaltyCardCopyWith<$Res>  {
  factory $LoyaltyCardCopyWith(LoyaltyCard value, $Res Function(LoyaltyCard) _then) = _$LoyaltyCardCopyWithImpl;
@useResult
$Res call({
 int? id, String? merchant, String? barcode, String? barcodeType, String? colorHex, String? dateAdded, String? notes, bool favorite, String? displayValue
});




}
/// @nodoc
class _$LoyaltyCardCopyWithImpl<$Res>
    implements $LoyaltyCardCopyWith<$Res> {
  _$LoyaltyCardCopyWithImpl(this._self, this._then);

  final LoyaltyCard _self;
  final $Res Function(LoyaltyCard) _then;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? merchant = freezed,Object? barcode = freezed,Object? barcodeType = freezed,Object? colorHex = freezed,Object? dateAdded = freezed,Object? notes = freezed,Object? favorite = null,Object? displayValue = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,barcodeType: freezed == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,dateAdded: freezed == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,displayValue: freezed == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [LoyaltyCard].
extension LoyaltyCardPatterns on LoyaltyCard {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LoyaltyCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LoyaltyCard value)  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCard():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LoyaltyCard value)?  $default,){
final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  String? merchant,  String? barcode,  String? barcodeType,  String? colorHex,  String? dateAdded,  String? notes,  bool favorite,  String? displayValue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
return $default(_that.id,_that.merchant,_that.barcode,_that.barcodeType,_that.colorHex,_that.dateAdded,_that.notes,_that.favorite,_that.displayValue);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  String? merchant,  String? barcode,  String? barcodeType,  String? colorHex,  String? dateAdded,  String? notes,  bool favorite,  String? displayValue)  $default,) {final _that = this;
switch (_that) {
case _LoyaltyCard():
return $default(_that.id,_that.merchant,_that.barcode,_that.barcodeType,_that.colorHex,_that.dateAdded,_that.notes,_that.favorite,_that.displayValue);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  String? merchant,  String? barcode,  String? barcodeType,  String? colorHex,  String? dateAdded,  String? notes,  bool favorite,  String? displayValue)?  $default,) {final _that = this;
switch (_that) {
case _LoyaltyCard() when $default != null:
return $default(_that.id,_that.merchant,_that.barcode,_that.barcodeType,_that.colorHex,_that.dateAdded,_that.notes,_that.favorite,_that.displayValue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LoyaltyCard implements LoyaltyCard {
  const _LoyaltyCard({this.id, this.merchant, this.barcode, this.barcodeType, this.colorHex, this.dateAdded, this.notes, this.favorite = false, this.displayValue});
  factory _LoyaltyCard.fromJson(Map<String, dynamic> json) => _$LoyaltyCardFromJson(json);

@override final  int? id;
@override final  String? merchant;
@override final  String? barcode;
@override final  String? barcodeType;
@override final  String? colorHex;
@override final  String? dateAdded;
@override final  String? notes;
@override@JsonKey() final  bool favorite;
@override final  String? displayValue;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoyaltyCardCopyWith<_LoyaltyCard> get copyWith => __$LoyaltyCardCopyWithImpl<_LoyaltyCard>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LoyaltyCardToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoyaltyCard&&(identical(other.id, id) || other.id == id)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.barcodeType, barcodeType) || other.barcodeType == barcodeType)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.dateAdded, dateAdded) || other.dateAdded == dateAdded)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.favorite, favorite) || other.favorite == favorite)&&(identical(other.displayValue, displayValue) || other.displayValue == displayValue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,merchant,barcode,barcodeType,colorHex,dateAdded,notes,favorite,displayValue);

@override
String toString() {
  return 'LoyaltyCard(id: $id, merchant: $merchant, barcode: $barcode, barcodeType: $barcodeType, colorHex: $colorHex, dateAdded: $dateAdded, notes: $notes, favorite: $favorite, displayValue: $displayValue)';
}


}

/// @nodoc
abstract mixin class _$LoyaltyCardCopyWith<$Res> implements $LoyaltyCardCopyWith<$Res> {
  factory _$LoyaltyCardCopyWith(_LoyaltyCard value, $Res Function(_LoyaltyCard) _then) = __$LoyaltyCardCopyWithImpl;
@override @useResult
$Res call({
 int? id, String? merchant, String? barcode, String? barcodeType, String? colorHex, String? dateAdded, String? notes, bool favorite, String? displayValue
});




}
/// @nodoc
class __$LoyaltyCardCopyWithImpl<$Res>
    implements _$LoyaltyCardCopyWith<$Res> {
  __$LoyaltyCardCopyWithImpl(this._self, this._then);

  final _LoyaltyCard _self;
  final $Res Function(_LoyaltyCard) _then;

/// Create a copy of LoyaltyCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? merchant = freezed,Object? barcode = freezed,Object? barcodeType = freezed,Object? colorHex = freezed,Object? dateAdded = freezed,Object? notes = freezed,Object? favorite = null,Object? displayValue = freezed,}) {
  return _then(_LoyaltyCard(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,barcodeType: freezed == barcodeType ? _self.barcodeType : barcodeType // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,dateAdded: freezed == dateAdded ? _self.dateAdded : dateAdded // ignore: cast_nullable_to_non_nullable
as String?,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,favorite: null == favorite ? _self.favorite : favorite // ignore: cast_nullable_to_non_nullable
as bool,displayValue: freezed == displayValue ? _self.displayValue : displayValue // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
