import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/pages/scanner_modal.dart';

class BrandsList extends StatelessWidget {
  const BrandsList({super.key, required this.brands});

  final List<Brand> brands;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: brands.length,
        itemBuilder: (context, index) {
          final brand = brands[index];
          return Container(
            decoration: BoxDecoration(
              border: index < brands.length - 1
                  ? Border(
                      bottom: BorderSide(
                        color: Colors.grey.withValues(alpha: 0.5),
                        width: 0.5,
                      ),
                    )
                  : null,
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: brand.colorHex != null
                      ? Color(
                          int.parse(brand.colorHex!.replaceFirst('#', '0xff')),
                        )
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: brand.logo != null
                    ? AspectRatio(
                        aspectRatio: 3 / 2,
                        child: Image.asset(brand.logo!, fit: BoxFit.contain),
                      )
                    : const Icon(Icons.store, size: 24, color: Colors.white),
              ),
              title: Text(
                brand.name ?? 'Unknown',
                style: const TextStyle(fontSize: 16),
              ),
              onTap: () {
                // navigate to scanner modal
                Navigator.of(context).push(
                  platformPageRoute(
                    context: context,
                    builder: (_) => ScannerModal(brand: brand),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
