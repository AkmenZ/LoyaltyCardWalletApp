// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'brands.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Brands {

 String? get id; String? get name; String? get logo; String? get colorHex; List<String>? get regions; bool? get popular;
/// Create a copy of Brands
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BrandsCopyWith<Brands> get copyWith => _$BrandsCopyWithImpl<Brands>(this as Brands, _$identity);

  /// Serializes this Brands to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Brands&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&const DeepCollectionEquality().equals(other.regions, regions)&&(identical(other.popular, popular) || other.popular == popular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logo,colorHex,const DeepCollectionEquality().hash(regions),popular);

@override
String toString() {
  return 'Brands(id: $id, name: $name, logo: $logo, colorHex: $colorHex, regions: $regions, popular: $popular)';
}


}

/// @nodoc
abstract mixin class $BrandsCopyWith<$Res>  {
  factory $BrandsCopyWith(Brands value, $Res Function(Brands) _then) = _$BrandsCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? logo, String? colorHex, List<String>? regions, bool? popular
});




}
/// @nodoc
class _$BrandsCopyWithImpl<$Res>
    implements $BrandsCopyWith<$Res> {
  _$BrandsCopyWithImpl(this._self, this._then);

  final Brands _self;
  final $Res Function(Brands) _then;

/// Create a copy of Brands
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? logo = freezed,Object? colorHex = freezed,Object? regions = freezed,Object? popular = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,regions: freezed == regions ? _self.regions : regions // ignore: cast_nullable_to_non_nullable
as List<String>?,popular: freezed == popular ? _self.popular : popular // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

}


/// Adds pattern-matching-related methods to [Brands].
extension BrandsPatterns on Brands {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Brands value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Brands() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Brands value)  $default,){
final _that = this;
switch (_that) {
case _Brands():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Brands value)?  $default,){
final _that = this;
switch (_that) {
case _Brands() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  String? name,  String? logo,  String? colorHex,  List<String>? regions,  bool? popular)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Brands() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.colorHex,_that.regions,_that.popular);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  String? name,  String? logo,  String? colorHex,  List<String>? regions,  bool? popular)  $default,) {final _that = this;
switch (_that) {
case _Brands():
return $default(_that.id,_that.name,_that.logo,_that.colorHex,_that.regions,_that.popular);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  String? name,  String? logo,  String? colorHex,  List<String>? regions,  bool? popular)?  $default,) {final _that = this;
switch (_that) {
case _Brands() when $default != null:
return $default(_that.id,_that.name,_that.logo,_that.colorHex,_that.regions,_that.popular);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Brands implements Brands {
  const _Brands({this.id, this.name, this.logo, this.colorHex, final  List<String>? regions, this.popular}): _regions = regions;
  factory _Brands.fromJson(Map<String, dynamic> json) => _$BrandsFromJson(json);

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

@override final  bool? popular;

/// Create a copy of Brands
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BrandsCopyWith<_Brands> get copyWith => __$BrandsCopyWithImpl<_Brands>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BrandsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Brands&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.logo, logo) || other.logo == logo)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&const DeepCollectionEquality().equals(other._regions, _regions)&&(identical(other.popular, popular) || other.popular == popular));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,logo,colorHex,const DeepCollectionEquality().hash(_regions),popular);

@override
String toString() {
  return 'Brands(id: $id, name: $name, logo: $logo, colorHex: $colorHex, regions: $regions, popular: $popular)';
}


}

/// @nodoc
abstract mixin class _$BrandsCopyWith<$Res> implements $BrandsCopyWith<$Res> {
  factory _$BrandsCopyWith(_Brands value, $Res Function(_Brands) _then) = __$BrandsCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? logo, String? colorHex, List<String>? regions, bool? popular
});




}
/// @nodoc
class __$BrandsCopyWithImpl<$Res>
    implements _$BrandsCopyWith<$Res> {
  __$BrandsCopyWithImpl(this._self, this._then);

  final _Brands _self;
  final $Res Function(_Brands) _then;

/// Create a copy of Brands
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? logo = freezed,Object? colorHex = freezed,Object? regions = freezed,Object? popular = freezed,}) {
  return _then(_Brands(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,logo: freezed == logo ? _self.logo : logo // ignore: cast_nullable_to_non_nullable
as String?,colorHex: freezed == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String?,regions: freezed == regions ? _self._regions : regions // ignore: cast_nullable_to_non_nullable
as List<String>?,popular: freezed == popular ? _self.popular : popular // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}

// dart format on
