import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loyalty_cards_app/generated/l10n.dart';
import 'package:loyalty_cards_app/theme.dart';
import 'package:loyalty_cards_app/utils/toast_utils.dart';
import 'package:loyalty_cards_app/widgets/custom_elevated_button.dart';
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
        _lastStatus = value
            ? S.of(context).backup_enabled
            : S.of(context).backup_disabled;
      });
    } catch (e) {
      // if user cancels permission or network fails
      setState(() {
        _lastStatus = '❌ ${S.of(context).error}: ${e.toString()}';
      });
      // revert the switch visually by reloading state if needed
    } finally {
      setState(() => _isLoading = false);
      // refresh
      ref.invalidate(loyaltyCardsProvider);
    }
  }

  Future<void> _performRestore(BuildContext context) async {
    final confirmed = await showPlatformDialog<bool>(
      context: context,
      builder: (context) => PlatformAlertDialog(
        title: Text('${S.of(context).restore}?'),
        content: Text(S.of(context).confirm_restore_data),
        actions: [
          PlatformDialogAction(
            child: Text(S.of(context).cancel),
            onPressed: () => Navigator.pop(context, false),
          ),
          PlatformDialogAction(
            child: Text(S.of(context).confirm_continue),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(loyaltyCardsProvider.notifier).restoreFromCloud();

      if (context.mounted) {
        setState(() => _lastStatus = S.of(context).success);
        ToastUtils.showSuccess(
          context,
          title: S.of(context).success,
          description: S.of(context).cards_restored_successfully,
        );
      }
    } catch (e) {
      if (context.mounted) {
        setState(() => _lastStatus = '❌ ${S.of(context).error}: $e');
      }
    } finally {
      if (context.mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final provider = ref.watch(loyaltyCardsProvider.notifier);
    final isEnabled = provider.isBackupEnabled;

    return CustomScaffold(
      backgroundColor: theme.surfaceContainerLow,
      appBar: CustomPlatformAppBar(
        title: Text(S.of(context).cloud_backup),
        trailingActions: [
          PlatformIconButton(
            icon: Icon(context.platformIcons.clear),
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 20.0,
            children: [
              if (Platform.isIOS)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.apple, size: 40, color: theme.inverseSurface),
                    Text(
                      'iCloud',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              if (Platform.isAndroid)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/google-drive-icon.png',
                      height: 40,
                    ),
                    Text(
                      ' Google Drive',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ],
                ),
              // enable/disable backup switch
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.surface,
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
                                S.of(context).auto_backup,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              Text(
                                S.of(context).auto_backup_description,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                        PlatformSwitch(
                          value: isEnabled,
                          onChanged: _isLoading
                              ? null
                              : (v) => _toggleBackup(v),
                        ),
                      ],
                    ),
                    if (_lastStatus != null || _isLoading) ...[
                      const Divider(height: 24),
                      _isLoading
                          ? SizedBox(
                              height: 12,
                              width: 12,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.grey[600],
                              ),
                            )
                          : Text(
                              _lastStatus!,
                              style: TextStyle(
                                color: _lastStatus!.startsWith('❌')
                                    ? Colors.redAccent
                                    : Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                    ],
                  ],
                ),
              ),
              // restore button
              SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: _isLoading ? null : () => _performRestore(context),
                  child: Text(
                    S.of(context).restore,
                    style: TextStyle(color: onSeed),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
