import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/widgets/loyalty_card_header.dart';

class EditCardModal extends ConsumerStatefulWidget {
  const EditCardModal({super.key, required this.loyaltyCard, this.brand});

  final LoyaltyCard loyaltyCard;
  final Brand? brand;

  @override
  ConsumerState<EditCardModal> createState() => _EditCardModalState();
}

class _EditCardModalState extends ConsumerState<EditCardModal> {
  final _formKey = GlobalKey<FormState>();
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
    if ((_formKey.currentState?.validate() ?? false)) {
      final newBarcode = _barcodeCtrl.text.trim();
      final newNote = _noteCtrl.text.trim();

      final updated = widget.loyaltyCard.copyWith(
        barcode: newBarcode.isEmpty ? null : newBarcode,
        note: newNote.isEmpty ? null : newNote,
      );

      // update card in DB via provider
      await ref.read(loyaltyCardsProvider.notifier).updateCard(updated);

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      resizeToAvoidBottomInset: true,
      appBar: CustomPlatformAppBar(
        title: Text(S.of(context).edit_card),
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
                // loyalty card header
                LoyaltyCardHeader(
                  colorHex: widget.loyaltyCard.colorHex,
                  merchant: widget.loyaltyCard.merchant,
                  isCustom: widget.loyaltyCard.isCustom,
                  brandLogo: widget.brand?.logo,
                  customLogo: widget.loyaltyCard.customLogo,
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  // barcode text field
                  child: PlatformTextFormField(
                    controller: _barcodeCtrl,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    maxLength: 50,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return S.of(context).please_enter_barcode;
                      }
                      return null;
                    },
                    material: (_, __) => MaterialTextFormFieldData(
                      decoration: InputDecoration(
                        labelText: S.of(context).barcode,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    cupertino: (_, __) => CupertinoTextFormFieldData(
                      placeholder: S.of(context).barcode,
                      decoration: BoxDecoration(
                        color: cupertinoTheme.barBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // note text field
                PlatformTextFormField(
                  controller: _noteCtrl,
                  maxLength: 50,
                  keyboardType: TextInputType.visiblePassword,
                  material: (_, __) => MaterialTextFormFieldData(
                    decoration: InputDecoration(
                      labelText: S.of(context).note,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  cupertino: (_, __) => CupertinoTextFormFieldData(
                    placeholder: S.of(context).note,
                    decoration: BoxDecoration(
                      color: cupertinoTheme.barBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
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
                // save button
                SizedBox(
                  width: double.infinity,
                  child: PlatformElevatedButton(
                    onPressed: _save,
                    child: Text(
                      S.of(context).save,
                      style: TextStyle(color: onSeed),
                    ),
                    material: (_, __) => MaterialElevatedButtonData(
                      style: ElevatedButton.styleFrom(backgroundColor: seed),
                    ),
                    cupertino: (_, __) {
                      return CupertinoElevatedButtonData(
                        color: seed,
                        sizeStyle: CupertinoButtonSize.small,
                      );
                    },
                  ),
                ),
                // delete button
                SizedBox(
                  width: double.infinity,
                  child: PlatformTextButton(
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          context.platformIcons.delete,
                          size: 20,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          S.of(context).delete,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                    material: (_, __) => MaterialTextButtonData(
                      style: TextButton.styleFrom(foregroundColor: Colors.red),
                    ),
                    cupertino: (_, __) => CupertinoTextButtonData(
                      color: CupertinoColors.transparent,
                      sizeStyle: CupertinoButtonSize.small,
                    ),
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
