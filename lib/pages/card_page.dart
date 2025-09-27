import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/pages/edit_card_modal.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/widgets/loyalty_card_widget.dart';

class CardPage extends ConsumerWidget {
  const CardPage({
    super.key,
    required this.loyaltyCardId,
    required this.merchant,
    this.brand,
  });

  final int loyaltyCardId;
  final String merchant;
  final Brand? brand;

  // open edit card modal
  void _openEditCardModal(
    BuildContext context,
    LoyaltyCard card,
    Brand? brand,
  ) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Navigator(
        onGenerateRoute: (settings) {
          return platformPageRoute(
            context: context,
            builder: (context) =>
                EditCardModal(loyaltyCard: card, brand: brand),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardAsync = ref.watch(loyaltyCardByIdProvider(loyaltyCardId));

    return CustomScaffold(
      appBar: CustomPlatformAppBar(
        title: Text(merchant),
        previousPageTitle: 'Cards',
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.edit),
            onPressed: () {
              final card = cardAsync.asData?.value;
              if (card != null) {
                _openEditCardModal(context, card, brand);
              }
            },
          ),
        ],
      ),
      body: cardAsync.when(
        data: (card) {
          if (card == null) {
            return ListView(
              children: const [
                SizedBox(height: 120),
                Center(
                  child: Text('Card not found. It may have been deleted!'),
                ),
              ],
            );
          }
          return Column(
            spacing: 20.0,
            children: [
              // card display
              LoyaltyCardWidget(loyaltyCard: card, brand: brand),
              // spacer
              const Spacer(),
              // share button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: PlatformElevatedButton(
                  onPressed: () {
                    // TODO: Implement share functionality
                  },
                  child: Row(
                    spacing: 20.0,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(context.platformIcons.share, color: onSeed),
                      const Text('Share', style: TextStyle(color: onSeed)),
                    ],
                  ),
                  material: (_, __) => MaterialElevatedButtonData(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                    ),
                  ),
                  cupertino: (_, __) {
                    return CupertinoElevatedButtonData(
                      color: seed,
                      sizeStyle: CupertinoButtonSize.small,
                    );
                  },
                ),
              ),
              const SizedBox(height: 40.0),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
