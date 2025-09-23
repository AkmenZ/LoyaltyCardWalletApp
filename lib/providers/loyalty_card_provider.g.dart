// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loyalty_card_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoyaltyCards)
const loyaltyCardsProvider = LoyaltyCardsProvider._();

final class LoyaltyCardsProvider
    extends $AsyncNotifierProvider<LoyaltyCards, List<LoyaltyCard>> {
  const LoyaltyCardsProvider._()
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

String _$loyaltyCardsHash() => r'c160ffcd395ae942110f25b8a12fbeded4cdb0d8';

abstract class _$LoyaltyCards extends $AsyncNotifier<List<LoyaltyCard>> {
  FutureOr<List<LoyaltyCard>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
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
    element.handleValue(ref, created);
  }
}
