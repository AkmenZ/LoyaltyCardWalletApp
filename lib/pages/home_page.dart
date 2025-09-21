import 'dart:io';
import 'package:flutter/material.dart';
import 'package:loyalty_cards_app/db/loyalty_card.dao.dart';
import 'package:loyalty_cards_app/db/sembast_database.dart';
import 'package:loyalty_cards_app/models/loyalty_card.dart';
import 'package:loyalty_cards_app/pages/card_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _dbPath;
  bool _isOpen = false;
  int _count = 0;

  List<LoyaltyCard> _cards = <LoyaltyCard>[];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCards();
  }

  Future<void> _loadCards() async {
    setState(() => _loading = true);
    final db = await SembastDatabase.open();
    final dao = LoyaltyCardSembastDao(db);
    try {
      final all = await dao.getAll();
      setState(() {
        _cards = all;
        _count = all.length;
      });
    } finally {
      await db.close();
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openDb() async {
    final path = await SembastDatabase.filePath();
    final db = await SembastDatabase.open(); // creates on first run
    final exists = await File(path).exists();

    setState(() {
      _dbPath = path;
      _isOpen = true;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          exists
              ? 'Sembast DB opened/created at:\n$path'
              : 'Sembast DB opened, but file not found at:\n$path',
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    await db.close();
  }

  Future<void> _insertDefaultCards() async {
    try {
      final db = await SembastDatabase.open();
      final dao = LoyaltyCardSembastDao(db);
      final now = DateTime.now().toIso8601String();

      await dao.insert(
        LoyaltyCard(
          merchant: 'Tesco',
          barcode: '5901234123457',
          barcodeType: 'ean13',
          colorHex: '#2563EB',
          dateAdded: now,
          favorite: true,
          displayValue: '5901 2341 23457',
        ),
      );

      await dao.insert(
        LoyaltyCard(
          merchant: 'Boots',
          barcode: 'BTS1234567890',
          barcodeType: 'code128',
          colorHex: '#0EA5E9',
          dateAdded: now,
          favorite: false,
          displayValue: 'BTS 1234 567 890',
        ),
      );

      await db.close();

      // Refresh list
      await _loadCards();

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inserted default cards. Total: $_count')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Insert failed: $e')));
    }
  }

  void _openCard(LoyaltyCard card) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CardPage(loyaltyCard: card)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pathText = _dbPath ?? '(not opened yet)';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cards'),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.cloud_done),
          onPressed: () {
            // TODO: Implement Sync with Cloud feature
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            tooltip: 'Add Card',
            onPressed: () {
              // TODO: Implement Add new card feature
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
                ElevatedButton(
                  onPressed: _openDb,
                  child: const Text('Open DB'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _insertDefaultCards,
                  child: const Text('Insert default cards'),
                ),
                const Spacer(),
                Text('Total: $_count'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DB path: $pathText',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadCards,
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _cards.isEmpty
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
                      itemCount: _cards.length,
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return InkWell(
                          onTap: () => _openCard(card),
                          borderRadius: BorderRadius.circular(12),
                          child: Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: card.colorHex != null
                                ? Color(
                                    int.parse(
                                      '0xFF${card.colorHex!.replaceFirst('#', '')}',
                                    ),
                                  )
                                : null,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(card.merchant ?? 'Unknown'),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
