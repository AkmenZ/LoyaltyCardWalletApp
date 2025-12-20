import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:loyalty_cards_app/utils/toast_utils.dart';
import 'package:loyalty_cards_app/validators.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/widgets/loyalty_card_header.dart';

class AddCardManuallyModal extends ConsumerStatefulWidget {
  const AddCardManuallyModal({super.key, required this.brand});

  final Brand brand;

  @override
  ConsumerState<AddCardManuallyModal> createState() =>
      _AddCardManuallyModalState();
}

class _AddCardManuallyModalState extends ConsumerState<AddCardManuallyModal> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _barcodeCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    _barcodeCtrl = TextEditingController(text: '');
    _noteCtrl = TextEditingController(text: '');
  }

  @override
  void dispose() {
    _barcodeCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  // save method
  Future<void> _save() async {
    if ((_formKey.currentState?.validate() ?? false)) {
      // get the barcode value
      final newBarcode = _barcodeCtrl.text.trim();
      final newNote = _noteCtrl.text.trim();

      // create new LoyaltyCard instance
      final newCard = LoyaltyCard(
        merchant: widget.brand.name,
        barcode: newBarcode.isEmpty ? null : newBarcode,
        barcodeType: determineBarcodeType(newBarcode),
        colorHex: widget.brand.colorHex,
        dateAdded: DateTime.now().toIso8601String(),
        favorite: false,
        note: newNote.isEmpty ? null : newNote,
        isCustom: widget.brand.isCustom,
        customLogo: widget.brand.isCustom ? widget.brand.logo : null,
      );

      // insert into DB via provider
      await ref.read(loyaltyCardsProvider.notifier).insertCard(newCard);

      if (!mounted) return;
      // close modal
      Navigator.of(context, rootNavigator: true).pop();

      // show success toast
      ToastUtils.showSuccess(
        context,
        title: S.of(context).success,
        description: S.of(context).card_added_successfully,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cupertinoTheme = CupertinoTheme.of(context);

    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      resizeToAvoidBottomInset: true,
      appBar: CustomPlatformAppBar(
        title: Text(S.of(context).add_card),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          // scrollable content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // loyalty card header
                LoyaltyCardHeader(
                  colorHex: widget.brand.colorHex,
                  merchant: widget.brand.name,
                  isCustom: widget.brand.isCustom,
                  brandLogo: widget.brand.isCustom ? null : widget.brand.logo,
                  customLogo: widget.brand.isCustom ? widget.brand.logo : null,
                ),
                const SizedBox(height: 16),
                // barcode text field
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      PlatformTextFormField(
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
                      const SizedBox(height: 10.0),
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
              ],
            ),
          ),
          // bottom button
          SafeArea(
            minimum: const EdgeInsets.all(16),
            child: SizedBox(
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
          ),
        ],
      ),
    );
  }
}
