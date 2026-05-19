import 'dart:io';
import 'package:tray_manager/tray_manager.dart';
import 'package:window_manager/window_manager.dart';

class TrayService with TrayListener {
  Future<void> init() async {
    trayManager.addListener(this);

    final (iconPath, isTemplate) = _iconForPlatform();
    try {
      await trayManager.setIcon(iconPath, isTemplate: isTemplate);
    } catch (_) {
      // Tray sometimes não está disponível (CI, sessão headless). Ignora.
    }

    await trayManager.setToolTip('Pulse — monitoring');
    await trayManager.setContextMenu(Menu(items: [
      MenuItem(key: 'show', label: 'Mostrar Pulse'),
      MenuItem.separator(),
      MenuItem(key: 'quit', label: 'Sair'),
    ]));
  }

  /// Pick the right icon asset per platform.
  ///
  /// - macOS: template image (pure black + alpha). The OS inverts/tints it so
  ///   it looks crisp in both light and dark menu bars.
  /// - Windows: `.ico` (multi-resolution), since png in the taskbar shows blurry.
  /// - Linux: white + alpha PNG, reads well on the most common dark panels.
  (String path, bool isTemplate) _iconForPlatform() {
    if (Platform.isMacOS) {
      return ('assets/icons/tray_icon_macos.png', true);
    }
    if (Platform.isWindows) {
      return ('assets/icons/tray_icon.ico', false);
    }
    return ('assets/icons/tray_icon.png', false);
  }

  void dispose() => trayManager.removeListener(this);

  @override
  void onTrayIconMouseDown() async {
    await windowManager.show();
    await windowManager.focus();
  }

  @override
  void onTrayIconRightMouseDown() => trayManager.popUpContextMenu();

  @override
  void onTrayMenuItemClick(MenuItem menuItem) async {
    switch (menuItem.key) {
      case 'show':
        await windowManager.show();
        await windowManager.focus();
        break;
      case 'quit':
        await trayManager.destroy();
        exit(0);
    }
  }
}
