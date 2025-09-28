import 'package:flutter/material.dart';

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
      child: Center(
        child: brandLogo != null
            ? Image.asset(brandLogo!, fit: BoxFit.contain)
            : isCustom
                ? Column(
                    children: [
                      if (customLogo != null)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Image.asset(
                              customLogo!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      Text(
                        merchant ?? 'Unknown',
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
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
    );
  }
}