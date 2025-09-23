import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class EditCardModal extends ConsumerWidget {
  const EditCardModal({super.key, required this.loyaltyCard});

  final LoyaltyCard loyaltyCard;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: const Text('Edit Card'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.0,
          children: [
            Container(
              height: 160,
              color: loyaltyCard.colorHex != null
                  ? Color(
                      int.parse(
                        '0xFF${loyaltyCard.colorHex!.replaceFirst('#', '')}',
                      ),
                    )
                  : Colors.grey.shade300,
              child: Center(
                child: Text(
                  loyaltyCard.merchant!,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ),
            PlatformElevatedButton(
              onPressed: () {
                // save changes and close modal
                Navigator.of(context, rootNavigator: true).pop();
              },
              child: const Text('Save'),
              material: (_, __) => MaterialElevatedButtonData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              cupertino: (_, __) => CupertinoElevatedButtonData(
                color: CupertinoColors.activeBlue,
              ),
            ),
            PlatformTextButton(
              onPressed: () async {
                // delete card
                await ref.read(loyaltyCardsProvider.notifier).deleteCard(loyaltyCard.id!);

                // navigate back to home page
                if (context.mounted) {
                  Navigator.of(context, rootNavigator: true).popUntil((route) => route.isFirst);
                }
              },
              child: const Text('Delete Card'),
              material: (_, __) => MaterialTextButtonData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              ),
              cupertino: (_, __) => CupertinoTextButtonData(
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
