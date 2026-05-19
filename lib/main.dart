import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'app_router.dart';
import 'core/services/monitoring_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/tray_service.dart';
import 'shared/shortcuts/app_shortcuts.dart';
import 'shared/theme/app_theme.dart';
import 'shared/theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await windowManager.ensureInitialized();
  await windowManager.waitUntilReadyToShow(
    const WindowOptions(
      title: 'Pulse',
      size: Size(1180, 760),
      minimumSize: Size(940, 620),
      center: true,
      backgroundColor: Color(0xFF07080C),
      titleBarStyle: TitleBarStyle.normal,
    ),
    () async {
      await windowManager.setPreventClose(true);
      await windowManager.show();
      await windowManager.focus();
    },
  );

  // Own the ProviderContainer so the global hardware-keyboard handler can
  // read providers (e.g. monitoringServiceProvider for "R").
  final container = ProviderContainer();
  GlobalKeyboard.instance.install(container);

  runApp(UncontrolledProviderScope(
    container: container,
    child: const PulseApp(),
  ));
}

class PulseApp extends ConsumerStatefulWidget {
  const PulseApp({super.key});

  @override
  ConsumerState<PulseApp> createState() => _PulseAppState();
}

class _PulseAppState extends ConsumerState<PulseApp> with WindowListener {
  late final TrayService _tray;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    await ref.read(notificationServiceProvider).init();
    _tray = TrayService();
    await _tray.init();
    await ref.read(monitoringServiceProvider).start();
  }

  @override
  void onWindowClose() async {
    await windowManager.hide();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _tray.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefs = ref.watch(userPrefsProvider);

    return MaterialApp.router(
      title: 'Pulse',
      debugShowCheckedModeBanner: false,
      themeMode: prefs.tema,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
