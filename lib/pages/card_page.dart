import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/models/brand.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/pages/edit_card_modal.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/widgets/loyalty_card_widget.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class CardPage extends ConsumerStatefulWidget {
  const CardPage({
    super.key,
    required this.loyaltyCardId,
    required this.merchant,
    this.brand,
  });

  final int loyaltyCardId;
  final String merchant;
  final Brand? brand;

  @override
  ConsumerState<CardPage> createState() => _CardPageState();
}

class _CardPageState extends ConsumerState<CardPage> {
  final ScreenshotController screenshotController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    // set screen brightness to max when viewing card
    ScreenBrightness.instance.setApplicationScreenBrightness(1.0);
  }

  @override
  void dispose() {
    // reset screen brightness when leaving page
    ScreenBrightness.instance.resetApplicationScreenBrightness();
    super.dispose();
  }

  // open edit card modal
  void _openEditCardModal(
    BuildContext context,
    LoyaltyCard card,
    Brand? brand,
  ) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      barrierColor: Colors.black.withValues(alpha: 0.7),
      builder: (context) => Navigator(
        onGenerateRoute: (settings) {
          return platformPageRoute(
            context: context,
            builder: (context) =>
                EditCardModal(loyaltyCard: card, brand: brand),
          );
        },
      ),
    );
  }

  // capture and share card as image
  Future<void> _captureAndShareCard(LoyaltyCard card) async {
    try {
      // capture the card widget as an image
      final image = await screenshotController.captureFromWidget(
        Material(
          color: Colors.black,
          type: MaterialType.transparency,
          child: Stack(
            children: [
              LoyaltyCardWidget(loyaltyCard: card, brand: widget.brand),
              Positioned(
                top: 26,
                left: 26,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6.0),
                  child: Image.asset(
                    'assets/icons/app-icon.png',
                    width: 30,
                    height: 30,
                  ),
                ),
              ),
              Positioned(
                top: 32,
                right: 36,
                child: Opacity(
                  opacity: 0.8,
                  child: Text(
                    'GoCards',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
        delay: Duration(milliseconds: 50),
      );

      final merchant = card.merchant ?? 'unknown';

      final params = ShareParams(
        files: [
          XFile.fromData(
            image,
            name: 'gocards_${merchant.toLowerCase()}_card.png',
          ),
        ],
        fileNameOverrides: ['gocards_${merchant.toLowerCase()}_card.png'],
      );

      // share the captured image
      await SharePlus.instance.share(params);
    } catch (e) {
      // handle any errors that occur during capture or sharing
      debugPrint('Error capturing or sharing card: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardAsync = ref.watch(loyaltyCardByIdProvider(widget.loyaltyCardId));

    return CustomScaffold(
      appBar: CustomPlatformAppBar(
        title: Text(widget.merchant),
        previousPageTitle: S.of(context).cards,
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.edit),
            onPressed: () {
              final card = cardAsync.asData?.value;
              if (card != null) {
                _openEditCardModal(context, card, widget.brand);
              }
            },
          ),
        ],
      ),
      body: cardAsync.when(
        data: (card) {
          if (card == null) {
            return ListView(
              children: const [
                SizedBox(height: 120),
                Center(
                  child: Text('Card not found. It may have been deleted!'),
                ),
              ],
            );
          }
          return SafeArea(
            child: Column(
              spacing: 20.0,
              children: [
                // card display
                Stack(
                  children: [
                    LoyaltyCardWidget(loyaltyCard: card, brand: widget.brand),
                    if (card.note != null)
                      Positioned(
                        top: 40,
                        right: 40,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 4.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.surface.withValues(alpha: 0.7),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Text(
                            card.note!,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                          ),
                        ),
                      ),
                  ],
                ),
                // spacer
                const Spacer(),
                // share button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: PlatformElevatedButton(
                    onPressed: () {
                      // capture and share card
                      _captureAndShareCard(card);
                    },
                    child: Row(
                      spacing: 20.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(context.platformIcons.share, color: onSeed),
                        Text(
                          S.of(context).share,
                          style: TextStyle(color: onSeed),
                        ),
                      ],
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
                const SizedBox(height: 10.0),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
