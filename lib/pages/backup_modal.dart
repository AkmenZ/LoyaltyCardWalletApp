import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/utils/toast_utils.dart';
import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';
import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';

class BackupModal extends ConsumerStatefulWidget {
  const BackupModal({super.key});

  @override
  ConsumerState<BackupModal> createState() => _BackupModalState();
}

class _BackupModalState extends ConsumerState<BackupModal> {
  bool _isLoading = false;
  String? _lastStatus;

  // toggle auto-backup on/off
  Future<void> _toggleBackup(bool value) async {
    setState(() => _isLoading = true);
    try {
      // triggering the permission prompt if needed
      await ref.read(loyaltyCardsProvider.notifier).toggleBackup(value);
      setState(() {
        _lastStatus = value ? 'Backup enabled & saved!' : 'Backup disabled';
      });
    } catch (e) {
      // if user cancels permission or network fails
      setState(() {
        _lastStatus = '❌ Error: ${e.toString()}';
      });
      // revert the switch visually by reloading state if needed
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _performRestore(BuildContext context) async {
    final confirmed = await showPlatformDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: const Text('Restore Data?'),
        content: const Text(
          'This will overwrite your current cards with the data from the cloud. This cannot be undone.',
        ),
        actions: [
          PlatformDialogAction(
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          PlatformDialogAction(
            child: const Text('Restore'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
      _lastStatus = 'Restoring...';
    });

    try {
      await ref.read(loyaltyCardsProvider.notifier).restoreFromCloud();

      if (context.mounted) {
        setState(() => _lastStatus = 'Database restored successfully!');
        ToastUtils.showSuccess(
          context,
          title: S.of(context).success,
          description: S.of(context).card_deleted_successfully,
        );
      }
    } catch (e) {
      if (context.mounted) setState(() => _lastStatus = '❌ Restore failed: $e');
    } finally {
      if (context.mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(loyaltyCardsProvider.notifier);
    final isEnabled = provider.isBackupEnabled;

    return CustomScaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: const Text('Cloud Backup'),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // enable/disable backup switch
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Auto-Backup',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Automatically save changes to ${Platform.isAndroid ? "Google Drive" : "iCloud"}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      PlatformSwitch(
                        value: isEnabled,
                        onChanged: _isLoading ? null : (v) => _toggleBackup(v),
                      ),
                    ],
                  ),
                  if (_lastStatus != null) ...[
                    const Divider(height: 24),
                    Text(
                      _lastStatus!,
                      style: TextStyle(
                        color: _lastStatus!.startsWith('❌')
                            ? Colors.red
                            : Colors.grey[700],
                        fontSize: 13,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 20),

            // restore button
            SizedBox(
              width: double.infinity,
              child: PlatformElevatedButton(
                color: Theme.of(context).colorScheme.secondaryContainer,
                onPressed: _isLoading ? null : () => _performRestore(context),
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Restore Data from Cloud',
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
