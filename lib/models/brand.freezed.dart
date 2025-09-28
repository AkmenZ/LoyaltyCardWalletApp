// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brand.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Brand {

 String? get id; String? get name; String? get logo; String? get colorHex; List<String>? get regions; List<String>? get popularRegions; bool get isCustom;
/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandCopyWith<Brand> get copyWith => _$BrandCopyWithImpl<Brand>(this as Brand, _$identity);

  /// Serializes this Brand to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Brand&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&const DeepCollectionEquality().equals(other.regions, regions)&&const DeepCollectionEquality().equals(other.popularRegions, popularRegions)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logo,colorHex,const DeepCollectionEquality().hash(regions),const DeepCollectionEquality().hash(popularRegions),isCustom);

@override
String toString() {
  return 'Brand(id: $id, name: $name, logo: $logo, colorHex: $colorHex, regions: $regions, popularRegions: $popularRegions, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class $BrandCopyWith<$Res>  {
  factory $BrandCopyWith(Brand value, $Res Function(Brand) _then) = _$BrandCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? logo, String? colorHex, List<String>? regions, List<String>? popularRegions, bool isCustom
});




}
/// @nodoc
class _$BrandCopyWithImpl<$Res>
    implements $BrandCopyWith<$Res> {
  _$BrandCopyWithImpl(this._self, this._then);

  final Brand _self;
  final $Res Function(Brand) _then;

/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? logo = freezed,Object? colorHex = freezed,Object? regions = freezed,Object? popularRegions = freezed,Object? isCustom = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,regions: freezed == regions ? _self.regions : regions // ignore: cast_nullable_to_non_nullable
as List<String>?,popularRegions: freezed == popularRegions ? _self.popularRegions : popularRegions // ignore: cast_nullable_to_non_nullable
as List<String>?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Brand].
extension BrandPatterns on Brand {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Brand value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Brand() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Brand value)  $default,){
final _that = this;
switch (_that) {
case _Brand():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Brand value)?  $default,){
final _that = this;
switch (_that) {
case _Brand() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? logo,  String? colorHex,  List<String>? regions,  List<String>? popularRegions,  bool isCustom)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Brand() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.colorHex,_that.regions,_that.popularRegions,_that.isCustom);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? logo,  String? colorHex,  List<String>? regions,  List<String>? popularRegions,  bool isCustom)  $default,) {final _that = this;
switch (_that) {
case _Brand():
return $default(_that.id,_that.name,_that.logo,_that.colorHex,_that.regions,_that.popularRegions,_that.isCustom);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? logo,  String? colorHex,  List<String>? regions,  List<String>? popularRegions,  bool isCustom)?  $default,) {final _that = this;
switch (_that) {
case _Brand() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.colorHex,_that.regions,_that.popularRegions,_that.isCustom);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Brand implements Brand {
  const _Brand({this.id, this.name, this.logo, this.colorHex, final  List<String>? regions, final  List<String>? popularRegions, this.isCustom = false}): _regions = regions,_popularRegions = popularRegions;
  factory _Brand.fromJson(Map<String, dynamic> json) => _$BrandFromJson(json);

@override final  String? id;
@override final  String? name;
@override final  String? logo;
@override final  String? colorHex;
 final  List<String>? _regions;
@override List<String>? get regions {
  final value = _regions;
  if (value == null) return null;
  if (_regions is EqualUnmodifiableListView) return _regions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

 final  List<String>? _popularRegions;
@override List<String>? get popularRegions {
  final value = _popularRegions;
  if (value == null) return null;
  if (_popularRegions is EqualUnmodifiableListView) return _popularRegions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override@JsonKey() final  bool isCustom;

/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandCopyWith<_Brand> get copyWith => __$BrandCopyWithImpl<_Brand>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrandToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Brand&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&const DeepCollectionEquality().equals(other._regions, _regions)&&const DeepCollectionEquality().equals(other._popularRegions, _popularRegions)&&(identical(other.isCustom, isCustom) || other.isCustom == isCustom));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logo,colorHex,const DeepCollectionEquality().hash(_regions),const DeepCollectionEquality().hash(_popularRegions),isCustom);

@override
String toString() {
  return 'Brand(id: $id, name: $name, logo: $logo, colorHex: $colorHex, regions: $regions, popularRegions: $popularRegions, isCustom: $isCustom)';
}


}

/// @nodoc
abstract mixin class _$BrandCopyWith<$Res> implements $BrandCopyWith<$Res> {
  factory _$BrandCopyWith(_Brand value, $Res Function(_Brand) _then) = __$BrandCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? logo, String? colorHex, List<String>? regions, List<String>? popularRegions, bool isCustom
});




}
/// @nodoc
class __$BrandCopyWithImpl<$Res>
    implements _$BrandCopyWith<$Res> {
  __$BrandCopyWithImpl(this._self, this._then);

  final _Brand _self;
  final $Res Function(_Brand) _then;

/// Create a copy of Brand
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? logo = freezed,Object? colorHex = freezed,Object? regions = freezed,Object? popularRegions = freezed,Object? isCustom = null,}) {
  return _then(_Brand(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,regions: freezed == regions ? _self._regions : regions // ignore: cast_nullable_to_non_nullable
as List<String>?,popularRegions: freezed == popularRegions ? _self._popularRegions : popularRegions // ignore: cast_nullable_to_non_nullable
as List<String>?,isCustom: null == isCustom ? _self.isCustom : isCustom // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
