import 'dart:io';

import 'package:auto_updater/auto_updater.dart';
import 'package:injectable/injectable.dart';
import 'package:lucid_clip/core/storage/secure_storage_service.dart';

//TODO(Ethiel): Implement for Windows
abstract class AppUpdateService {
  Future<void> checkFromMenu();

  Future<void> maybeCheckOnStartup();
}

@LazySingleton(as: AppUpdateService)
class AppUpdateServiceImpl implements AppUpdateService {
  AppUpdateServiceImpl({
    required this.secureStorageService,
    required this.autoUpdater,
  });

  static const String _kLastCheckKey = 'app_update_last_check';
  static const Duration _minInterval = Duration(hours: 12);

  final AutoUpdater autoUpdater;

  final SecureStorageService secureStorageService;

  Future<void> _checkForUpdates() async {
    await autoUpdater.checkForUpdates();
  }

  @override
  Future<void> checkFromMenu() async {
    if (!Platform.isMacOS) {
      return;
    }
    await _checkForUpdates();
  }

  @override
  Future<void> maybeCheckOnStartup() async {
    if (!Platform.isMacOS) return;

    final lastCheck =
        await secureStorageService.read(key: _kLastCheckKey) ?? '0';
    final lastCheckInt = int.tryParse(lastCheck) ?? 0;
    final last = DateTime.fromMillisecondsSinceEpoch(lastCheckInt).toUtc();
    final now = DateTime.now().toUtc();

    if (now.difference(last) < _minInterval) return;

    await _checkForUpdates();
    await secureStorageService.write(
      key: _kLastCheckKey,
      value: now.millisecondsSinceEpoch.toString(),
    );
  }
}
