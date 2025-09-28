import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/pages/add_card_manually_modal.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class ScannerModal extends ConsumerStatefulWidget {
  const ScannerModal({super.key, required this.brand});

  final Brand brand;

  @override
  ConsumerState<ScannerModal> createState() => _ScannerModalState();
}

class _ScannerModalState extends ConsumerState<ScannerModal> {
  late final MobileScannerController _controller;
  bool _handledFirstResult = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      // Optional tuning:
      // detectionSpeed: DetectionSpeed.noDuplicates,
      // detectionTimeoutMs: 250,
      // facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // handle barcode detection
  Future<void> _onDetect(BarcodeCapture capture) async {
    if (_handledFirstResult) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final first = barcodes.first;
    final rawValue = first.rawValue?.trim();
    if (rawValue == null || rawValue.isEmpty) return;

    _handledFirstResult = true;

    // Build the card from Brand + scan result
    final String barcodeType = () {
      // MobileScanner's Barcode has a 'format' enum; fall back to 'unknown'
      try {
        final f = first.format;
        return f.name; // Dart enum name
      } catch (_) {
        return 'unknown';
      }
    }();

    final newCard = LoyaltyCard(
      merchant: widget.brand.name,
      barcode: rawValue,
      barcodeType: barcodeType,
      colorHex: widget.brand.colorHex,
      dateAdded: DateTime.now().toIso8601String(),
      favorite: false,
    );

    try {
      // Stop the camera ASAP to avoid duplicate detections
      await _controller.stop();
    } catch (_) {
      // ignore
    }

    // insert into DB via provider
    await ref.read(loyaltyCardsProvider.notifier).insertCard(newCard);

    if (!mounted) return;
    // close modal
    Navigator.of(context, rootNavigator: true).pop(rawValue);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: const Text('Scan'),
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
            child: Container(
              height: 160,
              color: widget.brand.colorHex != null
                  ? Color(
                      int.parse(
                        '0xFF${widget.brand.colorHex!.replaceFirst('#', '')}',
                      ),
                    )
                  : Colors.grey.shade300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  spacing: 4.0,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.brand.logo != null)
                      Expanded(
                        child: Image.asset(
                          widget.brand.logo!,
                          fit: BoxFit.contain,
                        ),
                      )
                    else
                      Expanded(
                        child: Center(
                          child: Text(
                            widget.brand.name ?? 'Unknown',
                            style: Theme.of(context).textTheme.titleMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    if (widget.brand.isCustom)
                      Text(
                        widget.brand.name ?? 'Custom Card',
                        style: TextStyle(
                          color: onSeed,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
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
              child: const Text(
                'Position the barcode within the frame to scan',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          // enter manually button
          Positioned(
            bottom: 100,
            left: 20,
            right: 20,
            child: PlatformTextButton(
              onPressed: () {
                // navigate to add card manually modal
                Navigator.of(context).push(
                  platformPageRoute(
                    context: context,
                    builder: (_) => AddCardManuallyModal(brand: widget.brand),
                  ),
                );
              },
              child: const Text(
                'Enter Code Manually',
                style: TextStyle(
                  color: Colors.white,
                  decoration: TextDecoration.underline,
                ),
              ),
              material: (_, __) => MaterialTextButtonData(
                style: TextButton.styleFrom(foregroundColor: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
