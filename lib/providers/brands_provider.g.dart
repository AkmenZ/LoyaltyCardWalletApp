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
          AsyncValue<List<Brand>>,
          List<Brand>,
          FutureOr<List<Brand>>
        >
    with $FutureModifier<List<Brand>>, $FutureProvider<List<Brand>> {
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
  $FutureProviderElement<List<Brand>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Brand>> create(Ref ref) {
    return brandsList(ref);
  }
}

String _$brandsListHash() => r'5fd2b41ebfdc06b9ff4cebfd3e5d0bcf6d5c562d';
