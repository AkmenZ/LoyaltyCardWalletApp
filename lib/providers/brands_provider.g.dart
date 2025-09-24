// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(brandsList)
const brandsListProvider = BrandsListProvider._();

final class BrandsListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Brands>>,
          List<Brands>,
          FutureOr<List<Brands>>
        >
    with $FutureModifier<List<Brands>>, $FutureProvider<List<Brands>> {
  const BrandsListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'brandsListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$brandsListHash();

  @$internal
  @override
  $FutureProviderElement<List<Brands>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Brands>> create(Ref ref) {
    return brandsList(ref);
  }
}

String _$brandsListHash() => r'd2a0debb196c812f40cdee6cb5b2d938095d7155';
