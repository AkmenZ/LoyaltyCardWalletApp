import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/pages/add_card_modal.dart';
import 'package:loyalty_cards_app/pages/backup_modal.dart';
import 'package:loyalty_cards_app/pages/card_page.dart';
import 'package:loyalty_cards_app/providers/brands_provider.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:toastification/toastification.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  // navigate to card details page
  void _openCard(BuildContext context, LoyaltyCard card, Brand? brand) {
    Navigator.push(
      context,
      platformPageRoute(
        context: context,
        builder: (_) => CardPage(
          loyaltyCardId: card.id!,
          merchant: card.merchant ?? 'Unknown',
          brand: brand,
        ),
      ),
    );
  }

  // open Add Card Modal
  void _openAddCardModal(BuildContext context, List<Brand> brands) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Navigator(
        onGenerateRoute: (settings) {
          return platformPageRoute(
            context: context,
            builder: (context) => AddCardModal(brands: brands),
          );
        },
      ),
    );
  }

  // open Backup Modal
  void _openBackupModal(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Navigator(
        onGenerateRoute: (settings) {
          return platformPageRoute(
            context: context,
            builder: (context) => BackupModal(),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loyaltyCardsAsync = ref.watch(loyaltyCardsProvider);
    final brandsAsync = ref.watch(brandsListProvider);

    return CustomScaffold(
      appBar: CustomPlatformAppBar(
        title: Text(S.of(context).cards),
        leading: PlatformIconButton(
          icon: Icon(context.platformIcons.cloud),
          // open backup modal
          onPressed: () => _openBackupModal(context),
        ),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.add),
            // open add card modal
            onPressed: () {
              _openAddCardModal(context, brandsAsync.asData?.value ?? []);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () =>
                  ref.read(loyaltyCardsProvider.notifier).loadCards(),
              child: loyaltyCardsAsync.when(
                data: (cards) {
                  return brandsAsync.when(
                    data: (brands) {
                      if (cards.isEmpty) {
                        return Center(
                          child: Column(
                            spacing: 16.0,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(S.of(context).no_cards_yet),
                              PlatformIconButton(
                                icon: Icon(
                                  context.platformIcons.add,
                                  color: onSeed,
                                ),
                                // open add card modal
                                onPressed: () => _openAddCardModal(
                                  context,
                                  brandsAsync.asData?.value ?? [],
                                ),
                                material: (_, __) => MaterialIconButtonData(
                                  padding: EdgeInsets.zero,
                                  style: IconButton.styleFrom(
                                    backgroundColor: seed,
                                  ),
                                ),
                                cupertino: (_, __) => CupertinoIconButtonData(
                                  padding: EdgeInsets.zero,
                                  sizeStyle: CupertinoButtonSize.large,
                                  borderRadius: BorderRadius.circular(30),
                                  color: seed,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return GridView.builder(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16,
                          bottom: 32,
                        ),
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

                          // find matching brand by merchant name (if not custom card)
                          final brand = brands.firstWhere(
                            (b) =>
                                card.isCustom == false &&
                                (b.name?.toLowerCase() ==
                                    card.merchant?.toLowerCase()),
                            orElse: () => Brand(isCustom: true),
                          );

                          return GestureDetector(
                            onTap: () {
                              toastification.dismissAll();
                              _openCard(context, card, brand);
                            },
                            child: Stack(
                              children: [
                                Container(
                                  // card container
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
                                        color: Theme.of(context)
                                            .colorScheme
                                            .shadow
                                            .withValues(alpha: 0.4),
                                        blurRadius: 3,
                                        offset: const Offset(3, 3),
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    // gradient overlay
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Colors.white.withValues(alpha: 0.2),
                                          Colors.transparent,
                                        ],
                                      ),
                                    ),
                                    // card content
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      // card brand
                                      child: Center(
                                        child: brand.logo != null
                                            ? Image.asset(
                                                brand.logo!,
                                                fit: BoxFit.contain,
                                              )
                                            // custom card
                                            : Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  if (card.isCustom)
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets.all(
                                                              12.0,
                                                            ),
                                                        child: Image.asset(
                                                          card.customLogo ??
                                                              'assets/icons/gocards-icon-tp.png',
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                  Text(
                                                    card.merchant ?? 'Unknown',
                                                    style: TextStyle(
                                                      color: _getTextColor(
                                                        card.colorHex,
                                                      ),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                // note positioned at top right
                                Positioned(
                                  top: 6,
                                  right: 6,
                                  child: (card.note != null)
                                      ? Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6.0,
                                            vertical: 2.0,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .surface
                                                .withValues(alpha: 0.7),
                                            borderRadius: BorderRadius.circular(
                                              4.0,
                                            ),
                                          ),
                                          child: Text(
                                            card.note!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(
                                                    context,
                                                  ).colorScheme.onSurface,
                                                ),
                                          ),
                                        )
                                      : SizedBox.shrink(),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) =>
                        Center(child: Text('Error loading brands: $e')),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error loading cards: $e')),
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
