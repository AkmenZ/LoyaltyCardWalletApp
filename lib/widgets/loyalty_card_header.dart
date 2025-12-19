import 'package:flutter/material.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';
import 'package:loyalty_cards_app/theme.dart';

class LoyaltyCardHeader extends StatelessWidget {
  final String? colorHex;
  final String? merchant;
  final bool isCustom;
  final String? brandLogo;
  final String? customLogo;
  final double height;

  const LoyaltyCardHeader({
    super.key,
    required this.colorHex,
    required this.merchant,
    required this.isCustom,
    this.brandLogo,
    this.customLogo,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = colorHex != null
        ? Color(int.parse('0xFF${colorHex!.replaceFirst('#', '')}'))
        : Colors.grey.shade300;

    return Container(
      height: height,
      color: cardColor,
      child: Container(
        height: height,
        // gradient overlay
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.1),
              Colors.black.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: Center(
          child: brandLogo != null
              ? Image.asset(brandLogo!, fit: BoxFit.contain)
              : isCustom
              ? Column(
                  children: [
                    if (customLogo != null)
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Image.asset(customLogo!, fit: BoxFit.contain),
                        ),
                      ),
                    AutoSizeText(
                      merchant ?? 'Unknown',
                      style: TextStyle(
                        color: onSeed,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      minFontSize: 8,
                      maxFontSize: 20,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12.0),
                  ],
                )
              : Text(
                  merchant ?? 'Unknown',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
        ),
      ),
    );
  }
}
