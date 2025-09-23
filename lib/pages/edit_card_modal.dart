import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class EditCardModal extends ConsumerStatefulWidget {
  const EditCardModal({super.key, required this.loyaltyCard});
  final LoyaltyCard loyaltyCard;

  @override
  ConsumerState<EditCardModal> createState() => _EditCardModalState();
}

class _EditCardModalState extends ConsumerState<EditCardModal> {
  late final TextEditingController _barcodeCtrl;

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(text: widget.loyaltyCard.barcode ?? '');
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final newBarcode = _barcodeCtrl.text.trim();

    // If your LoyaltyCard has copyWith:
    final updated = widget.loyaltyCard.copyWith(
      barcode: newBarcode.isEmpty ? null : newBarcode,
    );

    await ref.read(loyaltyCardsProvider.notifier).updateCard(updated);

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
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
                color: widget.loyaltyCard.colorHex != null
                    ? Color(
                        int.parse(
                          '0xFF${widget.loyaltyCard.colorHex!.replaceFirst('#', '')}',
                        ),
                      )
                    : Colors.grey.shade300,
                child: Center(
                  child: Text(
                    widget.loyaltyCard.merchant!,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ),
            PlatformTextFormField(
              controller: _barcodeCtrl,              // use controller, not initialValue
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              hintText: 'Barcode',
            ),
            PlatformElevatedButton(
              onPressed: _save,
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
                await ref.read(loyaltyCardsProvider.notifier).deleteCard(widget.loyaltyCard.id!);

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