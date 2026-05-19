import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_notifier/local_notifier.dart';

class NotificationService {
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await localNotifier.setup(
      appName: 'Pulse',
      shortcutPolicy: ShortcutPolicy.requireCreate,
    );
    _initialized = true;
  }

  Future<void> showAlert({required String title, required String body}) async {
    await _show(title, body);
  }

  Future<void> showRecovery(
      {required String title, required String body}) async {
    await _show(title, body);
  }

  Future<void> _show(String title, String body) async {
    final notif = LocalNotification(title: title, body: body);
    await notif.show();
  }
}

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});
