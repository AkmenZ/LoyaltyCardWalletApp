import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class AddCardManuallyModal extends ConsumerStatefulWidget {
  const AddCardManuallyModal({super.key, required this.brand});

  final Brand brand;

  @override
  ConsumerState<AddCardManuallyModal> createState() =>
      _AddCardManuallyModalState();
}

class _AddCardManuallyModalState extends ConsumerState<AddCardManuallyModal> {
  late final TextEditingController _barcodeCtrl;

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    // get the barcode value
    final newBarcode = _barcodeCtrl.text.trim();

    // create new LoyaltyCard instance
    final newCard = LoyaltyCard(
      merchant: widget.brand.name,
      barcode: newBarcode.isEmpty ? null : newBarcode,
      barcodeType: null,
      colorHex: widget.brand.colorHex,
      dateAdded: DateTime.now().toIso8601String(),
      favorite: false,
      note: null,
    );

    // insert into DB via provider
    await ref.read(loyaltyCardsProvider.notifier).insertCard(newCard);

    if (!mounted) return;
    // close modal
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: const Text('Add Card'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // card brand display
                    Container(
                      height: 160,
                      color: widget.brand.colorHex != null
                          ? Color(
                              int.parse(
                                '0xFF${widget.brand.colorHex!.replaceFirst('#', '')}',
                              ),
                            )
                          : Colors.grey.shade300,
                      child: Center(
                        child: widget.brand.logo != null
                            ? Image.asset(
                                widget.brand.logo!,
                                fit: BoxFit.contain,
                              )
                            : Text(
                                widget.brand.name ?? 'Unknown',
                                style: Theme.of(context).textTheme.titleMedium,
                                textAlign: TextAlign.center,
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // barcode text field
                    PlatformTextFormField(
                      controller: _barcodeCtrl,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,
                      hintText: 'Barcode',
                    ),
                  ],
                ),
              ),
            ),
            // button pinned to bottom, moves with keyboard
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SizedBox(
                  width: double.infinity,
                  child: PlatformElevatedButton(
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
                      originalStyle: false,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
