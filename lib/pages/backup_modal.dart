// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:loyalty_cards_app/generated/l10n.dart';
// import 'package:loyalty_cards_app/providers/loyalty_card_provider.dart';
// import 'package:loyalty_cards_app/services/toastification_service.dart';
// import 'package:loyalty_cards_app/widgets/custom_platform_app_bar.dart';
// import 'package:loyalty_cards_app/widgets/custom_scaffold.dart';

// class BackupModal extends ConsumerStatefulWidget {
//   const BackupModal({super.key});

//   @override
//   ConsumerState<BackupModal> createState() => _BackupModalState();
// }

// class _BackupModalState extends ConsumerState<BackupModal> {
//   bool _backupEnabled = false;
//   bool _isSyncing = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadBackupStatus();
//   }

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   Future<void> _loadBackupStatus() async {
//     final notifier = ref.read(loyaltyCardsProvider.notifier);
//     final enabled = await notifier.isBackupEnabled();
//     setState(() => _backupEnabled = enabled);
//   }

//   Future<void> _toggleBackup(bool value) async {
//     final notifier = ref.read(loyaltyCardsProvider.notifier);
//     if (value) {
//       await notifier.enableBackup();
//     } else {
//       await notifier.disableBackup();
//     }
//     setState(() => _backupEnabled = value);
//   }

//   Future<void> _syncNow() async {
//     setState(() => _isSyncing = true);
//     try {
//       final notifier = ref.read(loyaltyCardsProvider.notifier);
//       await notifier.enableBackup();
//       ToastificationService.showSuccess(
//         title: 'Synced to backup',
//         description: 'Your cards have been backed up successfully',
//       );
//     } catch (e) {
//       ToastificationService.showError(
//         title: 'Sync failed',
//         description: e.toString(),
//       );
//     } finally {
//       setState(() => _isSyncing = false);
//     }
//   }

//   Future<void> _restoreFromBackup() async {
//     // Show confirmation dialog
//     if (!mounted) return;

//     final confirmed = await showDialog<bool>(
//       context: context,
//       builder: (context) => PlatformAlertDialog(
//         title: const Text('Restore from Backup?'),
//         content: const Text(
//           'This will replace all your current loyalty cards with the backed up data. This action cannot be undone.',
//         ),
//         actions: [
//           PlatformDialogAction(
//             onPressed: () => Navigator.pop(context, false),
//             child: const Text('Cancel'),
//           ),
//           PlatformDialogAction(
//             onPressed: () => Navigator.pop(context, true),
//             child: const Text('Restore'),
//           ),
//         ],
//       ),
//     );

//     if (confirmed != true) return;

//     setState(() => _isSyncing = true);
//     try {
//       final notifier = ref.read(loyaltyCardsProvider.notifier);
//       await notifier.restoreFromBackup();

//       // Invalidate and reload the provider
//       ref.invalidate(loyaltyCardsProvider);
//       await ref.read(loyaltyCardsProvider.future);

//       ToastificationService.showSuccess(
//         title: 'Restored successfully',
//         description: 'Your cards have been restored from backup',
//       );
//     } catch (e) {
//       print(e);
//       ToastificationService.showError(
//         title: 'Restore failed',
//         description: e.toString(),
//       );
//     } finally {
//       setState(() => _isSyncing = false);
//     }
//   }

//   Future<void> _deleteBackup() async {
//     try {
//       final notifier = ref.read(loyaltyCardsProvider.notifier);
//       await notifier.clearBackup();
//       ToastificationService.showSuccess(
//         title: 'Backup deleted',
//         description: 'Your backup has been cleared',
//       );
//     } catch (e) {
//       ToastificationService.showError(
//         title: 'Delete failed',
//         description: e.toString(),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScaffold(
//       backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
//       appBar: CustomPlatformAppBar(
//         title: const Text('Backup Data'),
//         trailingActions: [
//           PlatformIconButton(
//             icon: Icon(context.platformIcons.clear),
//             onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
//           ),
//         ],
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             spacing: 20.0,
//             children: [
//               const Text('Backup your data to secure cloud storage.'),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Text('Enable backup'),
//                   PlatformSwitch(
//                     value: _backupEnabled,
//                     onChanged: _toggleBackup,
//                   ),
//                 ],
//               ),
//               if (_backupEnabled) ...[
//                 PlatformElevatedButton(
//                   onPressed: _isSyncing ? null : _syncNow,
//                   child: _isSyncing
//                       ? const SizedBox(
//                           height: 20,
//                           width: 20,
//                           child: CircularProgressIndicator(strokeWidth: 2),
//                         )
//                       : const Text('Sync Now'),
//                 ),
//                 PlatformElevatedButton(
//                   onPressed: _isSyncing ? null : _restoreFromBackup,
//                   child: const Text('Restore from Backup'),
//                 ),
//                 PlatformElevatedButton(
//                   onPressed: _deleteBackup,
//                   child: const Text('Delete Backup'),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
