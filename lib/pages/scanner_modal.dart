import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/pages/add_card_manually_modal.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/utils/toast_utils.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/widgets/loyalty_card_header.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerModal extends ConsumerStatefulWidget {
  const ScannerModal({super.key, required this.brand});

  final Brand brand;

  @override
  ConsumerState<ScannerModal> createState() => _ScannerModalState();
}

class _ScannerModalState extends ConsumerState<ScannerModal> {
  late final MobileScannerController _controller;
  final ImagePicker _picker = ImagePicker();
  bool _handledFirstResult = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // method to process barcode (camera or image)
  Future<void> _processBarcode(Barcode barcode) async {
    if (_handledFirstResult) return;

    final rawValue = barcode.rawValue?.trim();
    if (rawValue == null || rawValue.isEmpty) return;

    final displayValue = barcode.displayValue;

    setState(() {
      _handledFirstResult = true;
    });

    // stop camera immediately to prevent further scans
    try {
      await _controller.stop();
    } catch (_) {}

    // determine type
    final String barcodeType = () {
      try {
        return barcode.format.name;
      } catch (_) {
        return 'unknown';
      }
    }();

    String processedBarcode = displayValue ?? rawValue;

    // create card
    final newCard = LoyaltyCard(
      merchant: widget.brand.name,
      barcode: processedBarcode,
      barcodeType: barcodeType,
      colorHex: widget.brand.colorHex,
      dateAdded: DateTime.now().toIso8601String(),
      favorite: false,
      customLogo: widget.brand.isCustom ? widget.brand.logo : null,
      isCustom: widget.brand.isCustom,
    );

    // save to DB
    await ref.read(loyaltyCardsProvider.notifier).insertCard(newCard);

    // show success toast
    if (mounted) {
      ToastUtils.showSuccess(
        context,
        title: S.of(context).success,
        description: S.of(context).card_added_successfully,
      );
    }

    if (!mounted) return;
    Navigator.of(context, rootNavigator: true).pop(rawValue);
  }

  // handle camera detection
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handledFirstResult || capture.barcodes.isEmpty) return;
    await _processBarcode(capture.barcodes.first);
  }

  // handle gallery selection
  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image == null) {
        // user cancelled image picking
        return;
      }

      if (!mounted) return;

      // show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        // ensure controller started
        if (!_controller.value.isRunning) {
          await _controller.start();
          await Future.delayed(const Duration(milliseconds: 200));
        }

        final BarcodeCapture? capture = await _controller.analyzeImage(
          image.path,
        );

        if (!mounted) return;

        // dismiss loading and close modal
        Navigator.of(context, rootNavigator: true).pop();

        if (capture != null && capture.barcodes.isNotEmpty) {
          await _processBarcode(capture.barcodes.first);
        } else {
          if (mounted) {
            ToastUtils.showError(
              context,
              title: S.of(context).no_barcode_found,
              description: S.of(context).could_not_read_barcode,
            );
          }
        }
      } catch (e) {
        if (mounted) {
          // dismiss loading and close modal
          Navigator.of(context, rootNavigator: true).pop();

          ToastUtils.showError(
            context,
            title: S.of(context).error,
            description: S.of(context).failed_to_analyze_image,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ToastUtils.showError(
          context,
          title: S.of(context).error,
          description: S.of(context).failed_to_load_image,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: Text(S.of(context).scan),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // scanner view
          MobileScanner(controller: _controller, onDetect: _onDetect),
          // viewfinder
          IgnorePointer(
            child: Center(
              child: Container(
                width: 260,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.greenAccent, width: 2),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          // brand logo overlay
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: LoyaltyCardHeader(
              colorHex: widget.brand.colorHex,
              merchant: widget.brand.name,
              isCustom: widget.brand.isCustom,
              brandLogo: widget.brand.isCustom ? null : widget.brand.logo,
              customLogo: widget.brand.isCustom ? widget.brand.logo : null,
            ),
          ),
          // instructions overlay
          Positioned(
            top: 240,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(75),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                S.of(context).position_barcode,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // other actions
          Positioned(
            bottom: 60,
            left: 20,
            right: 20,
            child: Column(
              spacing: 10.0,
              mainAxisSize: MainAxisSize.min,
              children: [
                // pick image from gallery
                PlatformWidget(
                  material: (_, __) => TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(
                      Icons.photo_library,
                      color: Colors.white,
                      size: 20,
                    ),
                    label: Text(
                      S.of(context).pick_from_gallery,
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                  cupertino: (_, __) => CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: _pickImage,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.photo_on_rectangle,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).pick_from_gallery,
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // enter manually
                PlatformWidget(
                  material: (_, __) => TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (_) =>
                              AddCardManuallyModal(brand: widget.brand),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, color: Colors.white, size: 20),
                    label: Text(
                      S.of(context).enter_manually,
                      style: const TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        fontSize: 16,
                      ),
                    ),
                    style: TextButton.styleFrom(foregroundColor: Colors.white),
                  ),
                  cupertino: (_, __) => CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).push(
                        platformPageRoute(
                          context: context,
                          builder: (_) =>
                              AddCardManuallyModal(brand: widget.brand),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          CupertinoIcons.pencil,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          S.of(context).enter_manually,
                          style: const TextStyle(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
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
