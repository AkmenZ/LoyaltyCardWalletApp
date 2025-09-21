import 'package:flutter/material.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/widgets/loyalty_card_widget.dart';

class CardPage extends StatelessWidget {
  const CardPage({super.key, required this.loyaltyCard});

  final LoyaltyCard loyaltyCard;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(loyaltyCard.merchant ?? 'Unknown'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            child: Text('Edit'),
            onPressed: () {
              // TODO: Implement Edit card
            },
          ),
        ],
      ),
      body: Column(
        spacing: 20.0,
        children: [
          LoyaltyCardWidget(loyaltyCard: loyaltyCard),
          TextButton.icon(
            onPressed: () {},
            label: Text('Share'),
            icon: Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}
