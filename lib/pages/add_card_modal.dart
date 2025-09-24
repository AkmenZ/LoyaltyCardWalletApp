import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:loyalty_cards_app/pages/scanner_modal.dart';
import 'package:loyalty_cards_app/widgets/brands_list.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

class AddCardModal extends StatelessWidget {
  const AddCardModal({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: const Text('Add New Card'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 20.0,
          children: [
            PlatformElevatedButton(
              onPressed: () {
                // navigate to scanner modal
                Navigator.of(context).push(
                  platformPageRoute(
                    context: context,
                    builder: (_) => const ScannerModal(),
                  ),
                );
              },
              child: const Text('Add Custom Card'),
              material: (_, __) => MaterialElevatedButtonData(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
              cupertino: (_, __) => CupertinoElevatedButtonData(
                color: CupertinoColors.activeBlue,
              ),
            ),
            _buildSearchField(context),
            // Brands list
            Expanded(child: BrandsList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return PlatformWidget(
      material: (_, __) => SearchBar(
        hintText: 'Search for popular merchants',
        elevation: WidgetStateProperty.all(0),
        onChanged: (value) {},
      ),
      cupertino: (_, __) => CupertinoSearchTextField(
        placeholder: 'Search for popular merchants',
        onChanged: (value) {},
        backgroundColor: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
