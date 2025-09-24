import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';

class LoyaltyCardWidget extends StatelessWidget {
  const LoyaltyCardWidget({super.key, required this.loyaltyCard, this.brand});

  final LoyaltyCard loyaltyCard;
  final Brand? brand;

  @override
  Widget build(BuildContext context) {
    final data = (loyaltyCard.barcode ?? '').trim();
    final type = (loyaltyCard.barcodeType ?? '').trim().toLowerCase();

    return Card(
      margin: const EdgeInsets.all(20),
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 20.0,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if ((loyaltyCard.merchant ?? '').isNotEmpty)
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
                  child: brand?.logo != null
                      ? Image.asset(brand!.logo!, fit: BoxFit.contain)
                      : Text(
                          loyaltyCard.merchant ?? 'Unknown',
                          style: Theme.of(context).textTheme.titleMedium,
                          textAlign: TextAlign.center,
                        ),
                ),
              ),
            if (data.isEmpty)
              const Text('No barcode available', textAlign: TextAlign.center)
            else
              AspectRatio(
                aspectRatio: _isQrLike(type) ? 1 : 2,
                child: BarcodeWidget(
                  barcode: _symbologyFromString(type),
                  data: data,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  textPadding: 20.0,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.shadow,
                    fontSize: 24,
                  ),
                  drawText: !_isQrLike(type),
                  backgroundColor: Colors.transparent,
                  errorBuilder: (context, err) => Center(
                    child: Text(
                      'Invalid ${type.isEmpty ? 'code128' : type}: $err',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
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

  static bool _isQrLike(String t) =>
      t.contains('qr') || t.contains('aztec') || t.contains('matrix');

  static Barcode _symbologyFromString(String type) {
    switch (type) {
      case 'ean13':
      case 'ean-13':
        return Barcode.ean13();
      case 'ean8':
      case 'ean-8':
        return Barcode.ean8();
      case 'upca':
      case 'upc-a':
        return Barcode.upcA();
      case 'upce':
      case 'upc-e':
        return Barcode.upcE();
      case 'code39':
      case 'code-39':
        return Barcode.code39();
      case 'code93':
      case 'code-93':
        return Barcode.code93();
      case 'code128':
      case 'code-128':
        return Barcode.code128();
      case 'gs1-128':
      case 'gs1128':
        return Barcode.gs128();
      case 'itf':
      case 'itf-14':
      case 'itf14':
        return Barcode.itf();
      case 'codabar':
        return Barcode.codabar();
      case 'pdf417':
        return Barcode.pdf417();
      case 'aztec':
        return Barcode.aztec();
      case 'datamatrix':
      case 'data-matrix':
        return Barcode.dataMatrix();
      case 'qr':
      case 'qrcode':
      case 'qr-code':
        return Barcode.qrCode();
      default:
        return Barcode.code128(); // safe default
    }
  }
}
