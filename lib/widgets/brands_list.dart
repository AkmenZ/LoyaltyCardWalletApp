import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/brands_provider.dart';

class BrandsList extends ConsumerWidget {
  const BrandsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brandsAsync = ref.watch(brandsListProvider);

    return brandsAsync.when(
      data: (brands) => Material(
        color: Colors.transparent,
        child: ListView.builder(
          itemCount: brands.length,
          itemBuilder: (context, index) {
            final brand = brands[index];
            return Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ), // 👈 bottom border
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12, // 👈 makes the tile a bit taller
                ),
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: brand.colorHex != null
                        ? Color(
                            int.parse(
                              brand.colorHex!.replaceFirst('#', '0xff'),
                            ),
                          )
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // 👈 rounded bg for logo
                  ),
                  child: brand.logo != null
                      ? Image.asset(brand.logo!, width: 32, height: 32)
                      : const Icon(Icons.store, size: 24, color: Colors.white),
                ),
                title: Text(
                  brand.name ?? 'Unknown',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            );
          },
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
    );
  }
}
