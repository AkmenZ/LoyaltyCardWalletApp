// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoyaltyCards)
final loyaltyCardsProvider = LoyaltyCardsProvider._();

final class LoyaltyCardsProvider
    extends $AsyncNotifierProvider<LoyaltyCards, List<LoyaltyCard>> {
  LoyaltyCardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loyaltyCardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loyaltyCardsHash();

  @$internal
  @override
  LoyaltyCards create() => LoyaltyCards();
}

String _$loyaltyCardsHash() => r'683b381b2bfaeb752d9c716150eef5c42548bc90';

abstract class _$LoyaltyCards extends $AsyncNotifier<List<LoyaltyCard>> {
  FutureOr<List<LoyaltyCard>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<LoyaltyCard>>, List<LoyaltyCard>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<LoyaltyCard>>, List<LoyaltyCard>>,
              AsyncValue<List<LoyaltyCard>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(loyaltyCardById)
final loyaltyCardByIdProvider = LoyaltyCardByIdFamily._();

final class LoyaltyCardByIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<LoyaltyCard?>,
          LoyaltyCard?,
          FutureOr<LoyaltyCard?>
        >
    with $FutureModifier<LoyaltyCard?>, $FutureProvider<LoyaltyCard?> {
  LoyaltyCardByIdProvider._({
    required LoyaltyCardByIdFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'loyaltyCardByIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$loyaltyCardByIdHash();

  @override
  String toString() {
    return r'loyaltyCardByIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<LoyaltyCard?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<LoyaltyCard?> create(Ref ref) {
    final argument = this.argument as int;
    return loyaltyCardById(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LoyaltyCardByIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$loyaltyCardByIdHash() => r'2b6e676e9b08e4877ea3f4f6fcef10c203b5a0c3';

final class LoyaltyCardByIdFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<LoyaltyCard?>, int> {
  LoyaltyCardByIdFamily._()
    : super(
        retry: null,
        name: r'loyaltyCardByIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  LoyaltyCardByIdProvider call(int id) =>
      LoyaltyCardByIdProvider._(argument: id, from: this);

  @override
  String toString() => r'loyaltyCardByIdProvider';
}
