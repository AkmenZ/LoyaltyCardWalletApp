import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/pages/edit_card_modal.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/widgets/loyalty_card_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key, required this.loyaltyCard});

  final LoyaltyCard loyaltyCard;

  void _openEditCardModal(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (context) => Navigator(
        onGenerateRoute: (settings) {
          return platformPageRoute(
            context: context,
            builder: (context) => EditCardModal(loyaltyCard: loyaltyCard),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomPlatformAppBar(
        title: Text(loyaltyCard.merchant ?? 'Unknown'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.edit),
            onPressed: () {
              // open Edit Card Modal
              _openEditCardModal(context);
            },
          ),
        ],
      ),
      body: Column(
        spacing: 20.0,
        children: [
          LoyaltyCardWidget(loyaltyCard: loyaltyCard),
          Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: PlatformElevatedButton(
              onPressed: () {
                // TODO: Implement share functionality
              },
              child: Row(
                spacing: 20.0,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Icon(context.platformIcons.share), Text('Share')],
              ),
            ),
          ),
          SizedBox(height: 40.0),
        ],
      ),
    );
  }
}
