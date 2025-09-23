import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/db/loyalty_card.dao.dart';
import 'package:loyalty_cards_app/db/sembast_database.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/pages/add_card_modal.dart';
import 'package:loyalty_cards_app/pages/card_page.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // Insert some default cards for testing/demo purposes
  Future<void> _insertDefaultCards(BuildContext context) async {
    try {
      final db = await SembastDatabase.open();
      final dao = LoyaltyCardSembastDao(db);
      final now = DateTime.now().toIso8601String();

      await dao.insert(
        LoyaltyCard(
          merchant: 'Tesco',
          barcode: '634000021015550645',
          barcodeType: 'code128',
          colorHex: '#2563EB',
          dateAdded: now,
          favorite: true,
          displayValue: '5901 2341 23457',
        ),
      );

      await dao.insert(
        LoyaltyCard(
          merchant: 'Boots',
          barcode: '633030010080419621082620',
          barcodeType: 'code128',
          colorHex: '#0EA5E9',
          dateAdded: now,
          favorite: false,
          displayValue: 'BTS 1234 567 890',
        ),
      );

      await db.close();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Insert failed: $e')));
    }
  }

  // navigate to card details page
  void _openCard(BuildContext context, LoyaltyCard card) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => CardPage(
          loyaltyCardId: card.id!,
          merchant: card.merchant ?? 'Unknown',
        ),
      ),
    );
  }

  // open Add Card Modal
  void _openAddCardModal(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      backgroundColor: Colors.amber,
      builder: (context) => Navigator(
        onGenerateRoute: (settings) {
          return platformPageRoute(
            context: context,
            builder: (context) => AddCardModal(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyaltyCardsAsync = ref.watch(loyaltyCardsProvider);
    final count = loyaltyCardsAsync.asData?.value.length ?? 0;

    return CustomScaffold(
      appBar: CustomPlatformAppBar(
        title: const Text('Cards'),
        leading: PlatformIconButton(
          icon: Icon(context.platformIcons.cloud),
          onPressed: () {
            // TODO: Implement Sync with Cloud feature
          },
        ),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.add),
            onPressed: () {
              _openAddCardModal(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              children: [
                PlatformElevatedButton(
                  onPressed: () => _insertDefaultCards(context),
                  child: const Text('Insert default cards'),
                ),
                const Spacer(),
                Text('Total: $count'),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(loyaltyCardsProvider.notifier).loadCards(),
              child: loyaltyCardsAsync.when(
                data: (cards) => cards.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Center(child: Text('No cards yet. Add some!')),
                        ],
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 1.5,
                            ),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return GestureDetector(
                            onTap: () => _openCard(context, card),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: card.colorHex != null
                                    ? Color(
                                        int.parse(
                                          '0xFF${card.colorHex!.replaceFirst('#', '')}',
                                        ),
                                      )
                                    : Theme.of(context).cardColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 25),
                                    blurRadius: 4,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Center(
                                  child: Text(
                                    card.merchant ?? 'Unknown',
                                    style: TextStyle(
                                      color: _getTextColor(card.colorHex),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => ListView(
                  children: [
                    const SizedBox(height: 120),
                    Center(child: Text('Error: $e')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getTextColor(String? colorHex) {
    if (colorHex == null) return Colors.black;

    final color = Color(int.parse('0xFF${colorHex.replaceFirst('#', '')}'));
    final luminance = color.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
