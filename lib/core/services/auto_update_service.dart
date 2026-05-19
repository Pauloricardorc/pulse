import 'dart:io';
import 'package:auto_updater/auto_updater.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Sparkle (macOS) / WinSparkle (Windows) auto-update orchestrator.
///
/// Reads an `appcast.xml` committed to the repo's `main` branch by the
/// release workflow. On each app start we check once — no background polls.
/// Linux is skipped entirely (no native Sparkle there); the UpdateBanner
/// widget covers Linux with a manual download link.
class AutoUpdateService {
  static const _appcastUrl =
      'https://raw.githubusercontent.com/Pauloricardorc/pulse/main/appcast.xml';

  bool get _supported => Platform.isMacOS || Platform.isWindows;

  Future<void> init() async {
    if (!_supported) return;
    try {
      await autoUpdater.setFeedURL(_appcastUrl);
      // 0 disables the scheduler — we only check on launch.
      await autoUpdater.setScheduledCheckInterval(0);
      await autoUpdater.checkForUpdates(inBackground: true);
    } catch (_) {
      // Network down, appcast missing on first run, etc. — silent fail keeps
      // the app launching even when the update infra is offline.
    }
  }

  /// Manual trigger (from Preferences → "Buscar atualizações").
  Future<void> checkNow() async {
    if (!_supported) return;
    try {
      await autoUpdater.checkForUpdates();
    } catch (_) {}
  }
}

final autoUpdateServiceProvider = Provider<AutoUpdateService>((ref) {
  return AutoUpdateService();
});
