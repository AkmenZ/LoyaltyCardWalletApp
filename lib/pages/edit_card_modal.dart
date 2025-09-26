import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class EditCardModal extends ConsumerStatefulWidget {
  const EditCardModal({super.key, required this.loyaltyCard, this.brand});

  final LoyaltyCard loyaltyCard;
  final Brand? brand;

  @override
  ConsumerState<EditCardModal> createState() => _EditCardModalState();
}

class _EditCardModalState extends ConsumerState<EditCardModal> {
  late final TextEditingController _barcodeCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(
      text: widget.loyaltyCard.barcode ?? '',
    );
    _noteCtrl = TextEditingController(text: widget.loyaltyCard.note ?? '');
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  // save changes method
  Future<void> _save() async {
    final newBarcode = _barcodeCtrl.text.trim();

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
      resizeToAvoidBottomInset: true,
      appBar: CustomPlatformAppBar(
        title: const Text('Edit Card'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
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
                    child: widget.brand?.logo != null
                        ? Image.asset(
                            widget.brand!.logo!,
                            fit: BoxFit.contain,
                          )
                        : Text(
                            widget.loyaltyCard.merchant ?? 'Unknown',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                PlatformTextFormField(
                  controller: _barcodeCtrl,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  hintText: 'Barcode',
                ),
                const SizedBox(height: 16),
                PlatformTextFormField(
                  controller: _noteCtrl,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: 'Note',
                ),
              ],
            ),
          ),
          // bottom buttons
          SafeArea(
            minimum: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PlatformElevatedButton(
                    onPressed: _save,
                    child: const Text('Save'),
                    material: (_, __) => MaterialElevatedButtonData(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(48),
                      ),
                    ),
                    cupertino: (_, __) => CupertinoElevatedButtonData(
                      color: CupertinoColors.activeBlue,
                    ),
                  ),
                  PlatformTextButton(
                    onPressed: () async {
                      await ref
                          .read(loyaltyCardsProvider.notifier)
                          .deleteCard(widget.loyaltyCard.id!);
                      if (context.mounted) {
                        Navigator.of(
                          context,
                          rootNavigator: true,
                        ).popUntil((route) => route.isFirst);
                      }
                    },
                    child: const Text('Delete'),
                    material: (_, __) => MaterialTextButtonData(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                    cupertino: (_, __) => CupertinoTextButtonData(
                      color: CupertinoColors.destructiveRed,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
